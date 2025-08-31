Route22PrintRivalText::
	; Check which rival battle we're in
	CheckEvent EVENT_ROUTE_22_BEAT_RIVAL2
	jr nz, .rival2_done_check   ; if rival 2 has been fought, go to rival 2 after battle check

	; Not rival 2, must be rival 1
	CheckEvent EVENT_ROUTE_22_BEAT_RIVAL1
	jr z, .rival1_before
	ld hl, Route22Rival1AfterBattleText
	jr .print_text

.rival1_before
	ld hl, Route22Rival1BeforeBattleText
	jr .print_text

.rival2_done_check
	; Rival 2 branch
	CheckEvent EVENT_ROUTE_22_BEAT_RIVAL2
	jr z, .rival2_before
	ld hl, Route22Rival2AfterBattleText
	jr .print_text

.rival2_before
	ld hl, Route22Rival2BeforeBattleText

.print_text
	call PrintText
	ret

Route22Rival1BeforeBattleText:
	text_far _Route22Rival1BeforeBattleText
	text_end

Route22Rival1AfterBattleText:
	text_far _Route22Rival1AfterBattleText
	text_end

Route22Rival2BeforeBattleText:
	text_far _Route22Rival2BeforeBattleText
	text_end

Route22Rival2AfterBattleText:
	text_far _Route22Rival2AfterBattleText
	text_end