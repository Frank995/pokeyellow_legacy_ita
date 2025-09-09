LavenderMart_Script:
	jp EnableAutoTextBoxDrawing

LavenderMart_TextPointers:
	def_text_pointers
	dw_const LavenderMartClerkText,        TEXT_LAVENDERMART_CLERK
	dw_const LavenderMartBaldingGuyText,   TEXT_LAVENDERMART_BALDING_GUY
	dw_const LavenderMartCooltrainerMText, TEXT_LAVENDERMART_COOLTRAINER_M

LavenderMartBaldingGuyText:
	text_far _LavenderMartBaldingGuyText
	text_end

LavenderMartCooltrainerMText:
	text_asm
	CheckEvent EVENT_ROUTE_16_RESCUED_MR_FUJI
	jr nz, .give_nugget
	ld hl, LavenderMartCooltrainerMReviveText
	call PrintText
	jr .done
.give_nugget
	ld hl, LavenderMartCooltrainerMNuggetText
	call PrintText
.done
	jp TextScriptEnd

LavenderMartCooltrainerMReviveText:
	text_far _LavenderMartCooltrainerMReviveText
	text_end

LavenderMartCooltrainerMNuggetText:
	text_far _LavenderMartCooltrainerMNuggetText
	text_end

LavenderMartClerkText::
	script_mart POKE_BALL, GREAT_BALL, POTION, SUPER_POTION, REVIVE, FULL_HEAL, ESCAPE_ROPE, SUPER_REPEL 