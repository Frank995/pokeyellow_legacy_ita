MACRO two_option_menu
	db \1, \2, \3
	dw \4
ENDM

TwoOptionMenuStrings:
; entries correspond to *_MENU constants
	table_width 5
	; width, height, blank line before first menu item?, text pointer
	two_option_menu 4, 3, FALSE, .YesNoMenu
	two_option_menu 6, 3, FALSE, .NorthWestMenu
	two_option_menu 6, 3, FALSE, .SouthEastMenu
	two_option_menu 6, 3, FALSE, .YesNoMenu
	two_option_menu 6, 3, FALSE, .NorthEastMenu
	two_option_menu 7, 3, FALSE, .TradeCancelMenu
	two_option_menu 7, 4, TRUE,  .HealCancelMenu
	two_option_menu 4, 3, FALSE, .NoYesMenu
	assert_table_length NUM_TWO_OPTION_MENUS

.NoYesMenu:
	db   "NO"
	next "SÌ@"

.YesNoMenu:
	db   "SÌ"
	next "NO@"

.NorthWestMenu:
	db   "NORD"
	next "OVEST@"

.SouthEastMenu:
	db   "SUD"
	next "EST@"

.NorthEastMenu:
	db   "NORD"
	next "EST@"

.TradeCancelMenu:
	db   "OK"
	next "ESCI@"

.HealCancelMenu:
	db   "CURA"
	next "ESCI@"
