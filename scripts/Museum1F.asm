Museum1F_Script:
	call EnableAutoTextBoxDrawing
	ld hl, PewterCity_ScriptPointers
	ld a, [wMuseum1FCurScript]
	jp CallFunctionInTable

Museum1F_ScriptPointers:
	def_script_pointers
	dw_const Museum1FDefaultScript, SCRIPT_MUSEUM1F_DEFAULT
	dw_const Museum1FNoopScript,    SCRIPT_MUSEUM1F_NOOP

Museum1FDefaultScript:
	ld a, [wYCoord]
	cp 4
	ret nz
	ld a, [wXCoord]
	cp 9
	jr z, .continue
	ld a, [wXCoord]
	cp 10
	ret nz
.continue
	xor a
	ldh [hJoyHeld], a
	ld a, TEXT_MUSEUM1F_SCIENTIST1
	ldh [hTextID], a
	jp DisplayTextID

Museum1FNoopScript:
	ret

Museum1F_TextPointers:
	def_text_pointers
	dw_const Museum1FScientist1Text, TEXT_MUSEUM1F_SCIENTIST1
	dw_const Museum1FGamblerText,    TEXT_MUSEUM1F_GAMBLER
	dw_const Museum1FScientist2Text, TEXT_MUSEUM1F_SCIENTIST2
	dw_const Museum1FScientist3Text, TEXT_MUSEUM1F_SCIENTIST3
	dw_const Museum1FOldAmberText,   TEXT_MUSEUM1F_OLD_AMBER

Museum1FScientist1Text:
	text_asm
	farcall Museum1FPrintScientist1Text
	jp TextScriptEnd

Museum1FGamblerText:
	text_far _Museum1FGamblerText
	text_end

Museum1FScientist2Text:
	text_asm
	farcall Museum1FPrintScientist2Text
	jp TextScriptEnd

Museum1FScientist3Text:
	text_far _Museum1FScientist3Text
	text_end

Museum1FOldAmberText:
	text_far _Museum1FOldAmberText
	text_end
