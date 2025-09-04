	object_const_def
	const_export BILLSHOUSE_KABUTO
	const_export BILLSHOUSE_BILL

BillsHouse_Object:
	db $d ; border block

	def_warp_events
	warp_event  2,  7, LAST_MAP, 1
	warp_event  3,  7, LAST_MAP, 1

	def_bg_events

	def_object_events
	object_event  4,  3, SPRITE_KABUTO, STAY, DOWN, TEXT_BILLSHOUSE_KABUTO
	object_event  4,  3, SPRITE_SUPER_NERD, STAY, NONE, TEXT_BILLSHOUSE_BILL

	def_warps_to BILLS_HOUSE
