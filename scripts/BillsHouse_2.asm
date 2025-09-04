BillsHousePrintKabutoText::
	CheckEvent EVENT_BILLS_HOUSE_ASKED_FOR_HELP
	jr nz, .asked_for_help

	SetEvent EVENT_BILLS_HOUSE_ASKED_FOR_HELP
	ld hl, BillsHouseKabutoImNotAPokemonText
	jr .done
.asked_for_help
	; If already asked for help and facing down play sound
	ld a, [wSpritePlayerStateData1FacingDirection]
	cp SPRITE_FACING_DOWN
	jr z, .unmasking

	ld hl, BillsHouseKabutoPleaseHelpText
	jr .done
.unmasking
	ld a, SFX_SWAP
	call PlaySound
	call WaitForSoundToFinish

	ld hl, BillsHouseKabutoUnmaskingText
.done
	call PrintText
	ret

BillsHouseKabutoImNotAPokemonText:
	text_far _BillsHouseKabutoImNotAPokemonText
	text_end

BillsHouseKabutoPleaseHelpText:
	text_far _BillsHouseKabutoPleaseHelpText
	text_end

BillsHouseKabutoUnmaskingText:
	text_far _BillsHouseKabutoUnmaskingText
	text_end

BillsHousePrintBillText::
	; If player already got the ticket
	CheckEvent EVENT_BILLS_HOUSE_GOT_SS_TICKET
	jr nz, .got_ticket

	; Give ticket
	ld hl, BillsHouseBillThankYouText
	call PrintText
	lb bc, S_S_TICKET, 1
	call GiveItem
	jr nc, .bag_full
	ld hl, BillsHouseBillSSTicketReceivedText
	call PrintText
	SetEvent EVENT_BILLS_HOUSE_GOT_SS_TICKET
	call Delay3
	ld hl, BillsHouseBillWhyDontYouGoInsteadOfMeText
	call PrintText

	; Hide rocket
	ld a, HS_ROUTE_24_ROCKET
	ld [wMissableObjectIndex], a
	predef HideObject
	ret
.got_ticket
	ld hl, BillsHouseBillResearchText
	call PrintText
	ret
.bag_full
	ld hl, BillsHouseBillSSTicketNoRoomText
	call PrintText
	ret

BillsHouseBillThankYouText:
	text_far _BillsHouseBillThankYouText
	text_end

BillsHouseBillSSTicketReceivedText:
	text_far _BillsHouseBillSSTicketReceivedText
	sound_get_key_item
	text_end

BillsHouseBillSSTicketNoRoomText:
	text_far _BillsHouseBillSSTicketNoRoomText
	text_end

BillsHouseBillWhyDontYouGoInsteadOfMeText:
	text_far _BillsHouseBillWhyDontYouGoInsteadOfMeText
	text_end

BillsHouseBillResearchText:
	text_far _BillsHouseBillResearchText
	text_end