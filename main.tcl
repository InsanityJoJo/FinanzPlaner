package require Tk
package require tdbc::sqlite3

proc relativePath {relPath} {
	return [file join [file dirname [info script]] $relPath]
}
msgcat::mcload [relativePath msgs]

#msgcat::mclocale en
namespace eval gui {
  	#configure mainwindow
	wm title . [msgcat::mc apptitle]
	grid columnconfigure . 0 -weight 1; grid rowconfigure . 0 -weight 1

	#create mainframe that holds every other widget
	ttk::frame .c
	grid .c -column 0 -row 0 -sticky nsew
	grid columnconfigure .c 0 -weight 1; grid rowconfigure .c 0 -weight 1

	#create main elements
	ttk::treeview .c.view
	ttk::button .c.add -text [msgcat::mc addInventory] -command gui::addInventory
	ttk::button .c.print -text "print" -command gui::printAllEntrys
	grid .c.view -column 0 -row 0 -sticky nsew
	grid .c.add  -column 0 -row 1 -sticky w
	grid .c.print  -column 0 -row 1 -sticky e

	proc addInventory {} {
		inventoryDialog::displayModal
	}
	proc printAllEntrys {} {
		set filename [relativePath data.sqlite3]
		db::open $filename
		db::printTable transactions
		db::close
	}
}

namespace eval inventoryDialog {
	#Holds the names of all input values.
	#Used to populate the dialog with input fields(so we need to type less).
	variable entryNames {date name amount classification category place}
	
	proc displayModal {} {
		variable entryNames
		
		#create and configure dialog window
		tk::toplevel .dAddInventory
		wm title .dAddInventory [msgcat::mc dialogTitle]
		grid columnconfigure .dAddInventory 0 -weight 1
		grid rowconfigure    .dAddInventory 0 -weight 1

		#create topframe for all other elements
		ttk::frame .dAddInventory.top
		grid .dAddInventory.top -row 0 -column 0 -sticky nsew
		grid columnconfigure .dAddInventory.top 0 -weight 1
		grid columnconfigure .dAddInventory.top 1 -weight 1
		set row 0
		while {$row <= [llength entryNames]} {
			grid rowconfigure .dAddInventory.top $row -weight 1
			incr row
		}
		
		# create input(entry) widgets
		set row 0
		foreach name $entryNames {
			grid [ttk::label .dAddInventory.top.${name}Label -text [msgcat::mc $name]] -column 0 -row $row
			grid [ttk::entry .dAddInventory.top.${name}Entry] -column 1 -row $row
			incr row
		}

		# create accept and discard buttons
		ttk::button .dAddInventory.top.accept  -text [msgcat::mc accept]  -command inventoryDialog::accept
		ttk::button .dAddInventory.top.discard -text [msgcat::mc discard] -command inventoryDialog::close
		grid .dAddInventory.top.accept  -column 0 -row $row -sticky w
		grid .dAddInventory.top.discard -column 1 -row $row -sticky e
		
		# make dialog modal
		wm protocol .dAddInventory WM_DELETE_WINDOW {inventoryDialog::close}
		wm transient .dAddInventory .
		tkwait visibility .dAddInventory
		raise .dAddInventory
		focus .dAddInventory
		grab  .dAddInventory
		tkwait window .dAddInventory
	}

	proc accept {} {
		variable entryNames
		set values {}
		foreach name $entryNames {
			dict set values $name [.dAddInventory.top.${name}Entry get]
		}
		puts $values

		set columnNames [join $entryNames ", "]
		set filename [relativePath data.sqlite3]
		db::open $filename
		db::execSql "create table if not exists transactions ($columnNames)"
		db::execValuesSql "insert into transactions ($columnNames) values (:[join $entryNames ", :"])" $values
		db::close
		inventoryDialog::close
	}
	
	proc close {} {
		grab release .dAddInventory
		destroy .dAddInventory
	}
}

namespace eval db {
	#opens database and creates db::conn object
	proc open {filename} {
		tdbc::sqlite3::connection create conn $filename
	}
	#executes sql statement
	proc execSql {sql} {
		set stmt [conn prepare $sql]
		$stmt execute
		$stmt close
	}
	#executes sql statement with values as a dictionary
	proc execValuesSql {sql values} {
		set stmt [conn prepare $sql]
		$stmt execute $values
		$stmt close
	}
	proc printTable {tableName} {
		conn foreach row "select * from $tableName" {} {
			puts $row
		}
		
	}
	#closes database connection
	proc close {} {
		conn close
	}
}
