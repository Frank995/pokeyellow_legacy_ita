RedsHouse1F_Script:
	jp EnableAutoTextBoxDrawing

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
	ld hl, RedsHouse1FPrintMrMimeText
	call PrintText
	ld a, MR_MIME
	call PlayCry
	call WaitForSoundToFinish
	jp TextScriptEnd

RedsHouse1FPrintMrMimeText:
	text_far _RedsHouse1FMrMimeText
	text_end

RedsHouse1FTVText:
	text_asm
	callfar RedsHouse1FPrintTVText
	jp TextScriptEnd
