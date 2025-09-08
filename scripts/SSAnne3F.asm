SSAnne3F_Script:
	jp EnableAutoTextBoxDrawing

SSAnne3F_TextPointers:
	def_text_pointers
	dw_const SSAnne3FSailor1Text, TEXT_SSANNE3F_SAILOR1
	dw_const SSAnne3FSailor2Text, TEXT_SSANNE3F_SAILOR2

SSAnne3FSailor1Text:
	text_asm
	CheckEvent EVENT_SS_ANNE_BEAT_JJ
	jr nz, .beat_jj

	ld hl, SSAnne3FSailor1ReceptionText
	jr .done
.beat_jj
	ld hl, SSAnne3FSailor1ItsOverText
.done
	call PrintText
	jp TextScriptEnd

SSAnne3FSailor1ReceptionText:
	text_far _SSAnne3FSailor1ReceptionText
	text_end

SSAnne3FSailor1ItsOverText:
	text_far _SSAnne3FSailor1ItsOverText
	text_end

SSAnne3FSailor2Text:
	text_far _SSAnne3FSailor2Text
	text_end
