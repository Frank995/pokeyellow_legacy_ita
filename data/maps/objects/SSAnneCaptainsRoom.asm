	object_const_def
	const_export SSANNECAPTAINSROOM_CAPTAIN
	const_export SSANNECAPTAINSROOM_JESSIE
	const_export SSANNECAPTAINSROOM_JAMES

SSAnneCaptainsRoom_Object:
	db $c ; border block

	def_warp_events
	warp_event  0,  7, SS_ANNE_2F, 9

	def_bg_events

	def_object_events
	object_event  1,  1, SPRITE_CAPTAIN, STAY, DOWN, TEXT_SSANNECAPTAINSROOM_CAPTAIN
	object_event  3,  1, SPRITE_JESSIE, STAY, LEFT, TEXT_SSANNECAPTAINSROOM_JESSIE
	object_event  3,  2, SPRITE_JAMES, STAY, LEFT, TEXT_SSANNECAPTAINSROOM_JAMES

	def_warps_to SS_ANNE_CAPTAINS_ROOM
