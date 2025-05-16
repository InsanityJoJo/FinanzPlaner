package require Tk
package require tdbc::sqlite3
package require msgcat

proc relativePath {relPath} {
	return [file join [file dirname [info script]] $relPath]
}
msgcat::mcload [relativePath msgs]
#msgcat::mclocale en

#load all functions related to the database
source [relativePath database.tcl]

source [relativePath gui.tcl]


namespace eval transactionDialog {
	#Holds the names of all input values.
	#Used to populate the dialog with input fields(so we need to type less).
	variable entryNames {date name amount classification category place}
	
	proc displayModal {} {
		variable entryNames
		
		#create and configure dialog window
		tk::toplevel .dAddTransaction
		wm title .dAddTransaction [msgcat::mc dialogTitle]
		grid columnconfigure .dAddTransaction 0 -weight 1
		grid rowconfigure    .dAddTransaction 0 -weight 1

		#create topframe for all other elements
		ttk::frame .dAddTransaction.top
		grid .dAddTransaction.top -row 0 -column 0 -sticky nsew
		grid columnconfigure .dAddTransaction.top 0 -weight 1
		grid columnconfigure .dAddTransaction.top 1 -weight 1
		set row 0
		while {$row <= [llength entryNames]} {
			grid rowconfigure .dAddTransaction.top $row -weight 1
			incr row
		}
		
		# create input(entry) widgets
		set row 0
		foreach name $entryNames {
			grid [ttk::label .dAddTransaction.top.${name}Label -text [msgcat::mc $name]] -column 0 -row $row
			grid [ttk::entry .dAddTransaction.top.${name}Entry] -column 1 -row $row
			incr row
		}

		# create accept and discard buttons
		ttk::button .dAddTransaction.top.accept  -text [msgcat::mc accept]  -command transactionDialog::accept
		ttk::button .dAddTransaction.top.discard -text [msgcat::mc discard] -command transactionDialog::close
		grid .dAddTransaction.top.accept  -column 0 -row $row -sticky w
		grid .dAddTransaction.top.discard -column 1 -row $row -sticky e
		
		# make dialog modal
		wm protocol .dAddTransaction WM_DELETE_WINDOW {transactionDialog::close}
		wm transient .dAddTransaction .
		tkwait visibility .dAddTransaction
		raise .dAddTransaction
		focus .dAddTransaction
		grab  .dAddTransaction
		tkwait window .dAddTransaction 
	}

	#callback for the accept button
	proc accept {} {
		variable entryNames
		set values {}
		foreach name $entryNames {
			dict set values $name [.dAddTransaction.top.${name}Entry get]
		}
		puts $values

		set columnNames [join $entryNames ", "]
		set filename [relativePath data.sqlite3]
		db::open $filename
		db::execSql "create table if not exists transactions ($columnNames)"
		db::execValuesSql "insert into transactions ($columnNames) values (:[join $entryNames ", :"])" $values
		db::close
		gui::loadTransactions
		transactionDialog::close
	}

	#closes the input dialog
	proc close {} {
		grab release .dAddTransaction
		destroy .dAddTransaction
	}
}
