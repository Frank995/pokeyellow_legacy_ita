LavenderCuboneHouse_Script:
	call EnableAutoTextBoxDrawing
	ret

LavenderCuboneHouse_TextPointers:
	def_text_pointers
	dw_const LavenderCuboneHouseCuboneText,       TEXT_LAVENDERCUBONEHOUSE_CUBONE
	dw_const LavenderCuboneHouseBrunetteGirlText, TEXT_LAVENDERCUBONEHOUSE_BRUNETTE_GIRL

LavenderCuboneHouseCuboneText:
	text_asm
	ld hl, LavenderCuboneHousePrintCuboneText
	call PrintText
	ld a, MR_MIME
	call PlayCry
	call WaitForSoundToFinish
	jp TextScriptEnd

LavenderCuboneHousePrintCuboneText:
	text_far _LavenderCuboneHouseCuboneText
	text_end

LavenderCuboneHouseBrunetteGirlText:
	text_asm
	CheckEvent EVENT_ROUTE_16_RESCUED_MR_FUJI
	jr nz, .rescued_mr_fuji
	ld hl, LavenderCuboneHouseBrunetteGirlPoorCubonesMotherText
	call PrintText
	jr .done
.rescued_mr_fuji
	ld hl, LavenderCuboneHouseBrunetteGirlGhostIsGoneText
	call PrintText
.done
	jp TextScriptEnd

LavenderCuboneHouseBrunetteGirlPoorCubonesMotherText:
	text_far _LavenderCuboneHouseBrunetteGirlPoorCubonesMotherText
	text_end

LavenderCuboneHouseBrunetteGirlGhostIsGoneText:
	text_far _LavenderCuboneHouseBrunetteGirlGhostIsGoneText
	text_end
