CeladonMart3FPrintClerkText::
	CheckEvent EVENT_CELADON_GOT_TM18
	jr nz, .got_item
	ld hl, CeladonMart3FClerkTM18PreReceiveText
	call PrintText
	lb bc, TM_COUNTER, 1
	call GiveItem
	jr nc, .bag_full
	SetEvent EVENT_CELADON_GOT_TM18
	ld hl, CeladonMart3FClerkReceivedTM18Text
	jr .done
.bag_full
	ld hl, CeladonMart3FClerkTM18NoRoomText
	jr .done
.got_item
	ld hl, CeladonMart3FClerkTM18ExplanationText
.done
	call PrintText
	ret

CeladonMart3FClerkTM18PreReceiveText:
	text_far _CeladonMart3FClerkTM18PreReceiveText
	text_end

CeladonMart3FClerkReceivedTM18Text:
	text_far _CeladonMart3FClerkReceivedTM18Text
	sound_get_item_1
	text_end

CeladonMart3FClerkTM18ExplanationText:
	text_far _CeladonMart3FClerkTM18ExplanationText
	text_end

CeladonMart3FClerkTM18NoRoomText:
	text_far _CeladonMart3FClerkTM18NoRoomText
	text_end
