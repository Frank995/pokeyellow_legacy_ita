RedsHouse1F_Script:
	call EnableAutoTextBoxDrawing
	ret

RedsHouse1F_TextPointers:
	def_text_pointers
	dw_const RedsHouse1FMomText,    TEXT_REDSHOUSE1F_MOM
	dw_const RedsHouse1FMrMimeText, TEXT_REDSHOUSE1F_MIME
	dw_const RedsHouse1FTVText,     TEXT_REDSHOUSE1F_TV

RedsHouse1FMomText:
	text_asm
	callfar RedsHouse1FPrintMomText
	jp TextScriptEnd

RedsHouse1FMrMimeText:
	text_asm

	; Play Mr. Mime cry
	ld a, SFX_CRY_20
	call PlayCry

	ld hl, RedsHouse1FMrMimeCryText
	call PrintText
	jp TextScriptEnd

RedsHouse1FMrMimeCryText:
	text_far _RedsHouse1FMrMimeCryText
	text_end

RedsHouse1FTVText:
	text_asm
	callfar RedsHouse1FPrintTVText
	jp TextScriptEnd
