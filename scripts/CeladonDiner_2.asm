CeladonDinerPrintGymGuideText::
	CheckEvent EVENT_CELADON_GOT_COIN_CASE
	jr nz, .got_item
	ld hl, CeladonDinerGymGuideImFlatOutBustedText
	call PrintText
	lb bc, COIN_CASE, 1
	call GiveItem
	jr nc, .bag_full
	SetEvent EVENT_CELADON_GOT_COIN_CASE
	ld hl, CeladonDinerGymGuideReceivedCoinCaseText
	call PrintText
	jr .done
.bag_full
	ld hl, CeladonDinerGymGuideCoinCaseNoRoomText
	call PrintText
	jr .done
.got_item
	ld hl, CeladonDinerGymGuideWinItBackText
	call PrintText
.done
	ret

CeladonDinerGymGuideImFlatOutBustedText:
	text_far _CeladonDinerGymGuideImFlatOutBustedText
	text_end

CeladonDinerGymGuideReceivedCoinCaseText:
	text_far _CeladonDinerGymGuideReceivedCoinCaseText
	sound_get_key_item
	text_end

CeladonDinerGymGuideCoinCaseNoRoomText:
	text_far _CeladonDinerGymGuideCoinCaseNoRoomText
	text_end

CeladonDinerGymGuideWinItBackText:
	text_far _CeladonDinerGymGuideWinItBackText
	text_end
