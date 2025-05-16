# gui.tcl

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

	#displays the input dialog
	proc addInventory {} {
		transactionDialog::displayModal
	}
	proc printAllEntrys {} {
		set filename [relativePath data.sqlite3]
		db::open $filename
		db::printTable transactions
		db::close
	}

	#loads all transactions and displays it in the treeview
	proc loadTransactions {} {
		set filename [relativePath data.sqlite3]
		db::open $filename
		set res [db::selectFrom transactions]
		#delete all old entrys
		.c.view delete [.c.view children {}]
		while {[$res nextdict row]} {
			.c.view insert {} end -text [dict get $row name] -values [list [dict get $row amount] [dict get $row date]] 
		}
		db::close
	}
	#set heading captions, #0 means first column
	.c.view configure -columns "amount date"
	.c.view heading #0 	   -text [msgcat::mc name]
	.c.view heading amount -text [msgcat::mc amount]
	.c.view heading date   -text [msgcat::mc date]
	.c.view heading classification -text [msgcat::mc classification]
	.c.view heading category -text [msgcat::mc category]
	.c.view heading place 	-text [msgcat::mc place]
	#display all transactions at the beginning of the application
	loadTransactions
}