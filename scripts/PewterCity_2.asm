PewterCityPrintSuperNerd1Text::
    ld hl, PewterCitySuperNerd1QuestionText
	call PrintText
	call YesNoChoice

	ld a, [wCurrentMenuItem]
	cp 0
	jr z, .yes
	ld hl, PewterCitySuperNerd1NoText
	jr .print_text
.yes
	ld hl, PewterCitySuperNerd1YesText
.print_text
	call PrintText
	ret

PewterCitySuperNerd1QuestionText:
	text_far _PewterCitySuperNerd1QuestionText
	text_end

PewterCitySuperNerd1NoText:
	text_far _PewterCitySuperNerd1NoText
	text_end

PewterCitySuperNerd1YesText:
	text_far _PewterCitySuperNerd1YesText
	text_end

PewterCityPrintYoungsterText::
	CheckEvent EVENT_PEWTER_GYM_BEAT_BROCK
	jr nz, .beat_brock

	ld hl, PewterCityYoungsterBrockIsLookingForText
	jr .done
.beat_brock
	ld hl, PewterCityYoungsterWellDoneText
.done
	call PrintText
	ret

PewterCityYoungsterBrockIsLookingForText:
	text_far _PewterCityYoungsterBrockIsLookingForText
	text_end

PewterCityYoungsterWellDoneText:
	text_far _PewterCityYoungsterWellDoneText
	text_end