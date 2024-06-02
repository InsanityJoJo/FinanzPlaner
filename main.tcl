package require Tk

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
	grid .c.view -column 0 -row 0 -sticky nsew
	grid .c.add  -column 0 -row 1 -sticky w

	proc addInventory {} {
		inventoryDialog::displayModal
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
		set resultList {}
		foreach name $entryNames {
			lappend resultList [.dAddInventory.top.${name}Entry get]
		}
		puts $resultList
		inventoryDialog::close
	}
	
	proc close {} {
		grab release .dAddInventory
		destroy .dAddInventory
	}
}

