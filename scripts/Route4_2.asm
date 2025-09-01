Route4PrintSeymourText:
    CheckEvent EVENT_ROUTE_4_BEAT_ZUBAT
    jr nz, .saved_saymour
	ld hl, Route4SeymourSaveMeText
	call PrintText
    jr .done
.saved_saymour
	ld hl, Route4SeymourThankYouText
	call PrintText
	call Delay3

	ld hl, Route4SeymourExplanationText
	call PrintText
	call Delay3

	ld hl, Route4SeymourMoonStoneText
	call PrintText

	ld a, SCRIPT_ROUTE4_SEYMOUR_ENTERS_CAVE
	ld [wRoute4CurScript], a
	ld [wCurMapScript], a
.done
    ret

Route4SeymourSaveMeText:
	text_far _Route4SeymourSaveMeText
	text_end

Route4SeymourThankYouText:
	text_far _Route4SeymourThankYouText
	text_end

Route4SeymourExplanationText:
	text_far _Route4SeymourExplanationText
	text_end

Route4SeymourMoonStoneText:
	text_far _Route4SeymourMoonStoneText
	text_end