namespace eval gui {
	msgcat::mcflmset {
		apptitle 		"Finanzplaner"
		addInventory	"Eintrag hinzfügen"
	}
}

namespace eval inventoryDialog {
	msgcat::mcflmset {
		dialogTitle		"Neuer Eintrag"
		
		date 			"Datum: "
		name 			"Name: "
		amount 			"Betrag: "
		classification 	"Klasse: "
		category 		"Kategorie: "
		place			"Ort: "
		
		accept			"Übernehmen"
		discard			"Verwerfen"
	}
}
