namespace eval gui {
	msgcat::mcflmset {
		apptitle 		"Finance Planner"
		addInventory	"Add Entry"
		
		date 			"Date"
		name 			"Name"
		amount 			"Amount"
	}
}

namespace eval transactionDialog {
	msgcat::mcflmset {
		dialogTitle		"New Entry"
		
		date 			"Date: "
		name 			"Name: "
		amount 			"Amount: "
		classification 	"Class: "
		category 		"Category: "
		place			"Place: "
		
		accept			"Accept"
		discard			"Discard"
	}
}
