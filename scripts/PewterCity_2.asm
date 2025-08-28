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