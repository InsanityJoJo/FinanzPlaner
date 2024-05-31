package require Tk

proc relativePath {relPath} {
	return [file join [file dirname [info script]] $relPath]
}
msgcat::mcload [relativePath msgs]

namespace eval gui {
	wm title . [msgcat::mc apptitle]
	grid columnconfigure . 0 -weight 1; grid rowconfigure . 0 -weight 1

	ttk::frame .c

}
