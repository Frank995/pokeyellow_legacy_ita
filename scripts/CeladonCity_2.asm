CeladonCityPrintGramps3Text::
	text_asm
	CheckEvent EVENT_CELADON_GOT_TM41
	jr nz, .gotTM41
	ld hl, CeladonCityGramps3GiveTM41Text
	call PrintText
	lb bc, TM_SOFTBOILED, 1
	call GiveItem
	jr c, .Success
	ld hl, CeladonCityGramps3TM41NoRoomText
	call PrintText
	jr .Done
.Success
	ld hl, CeladonCityGramps3ReceivedTM41Text
	call PrintText
	SetEvent EVENT_CELADON_GOT_TM41
	jr .Done
.gotTM41
	ld hl, CeladonCityGramps3TM41ExplanationText
	call PrintText
.Done
	jp TextScriptEnd

CeladonCityGramps3GiveTM41Text:
	text_far _CeladonCityGramps3GiveTM41Text
	text_end

CeladonCityGramps3ReceivedTM41Text:
	text_far _CeladonCityGramps3ReceivedTM41Text
	sound_get_item_1
	text_end

CeladonCityGramps3TM41ExplanationText:
	text_far _CeladonCityGramps3TM41ExplanationText
	text_end

CeladonCityGramps3TM41NoRoomText:
	text_far _CeladonCityGramps3TM41NoRoomText
	text_end