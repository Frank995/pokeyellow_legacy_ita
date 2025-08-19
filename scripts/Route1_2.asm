Route1PrintYoungster1Text::
	CheckAndSetEvent EVENT_GOT_POTION_SAMPLE
	jr nz, .got_item
	ld hl, Route1Youngster1MartSampleText
	call PrintText
	lb bc, POTION, 1
	call GiveItem
	jr nc, .bag_full
	ld hl, Route1Youngster1GotPotionText
	jr .done
.bag_full
	ld hl, Route1Youngster1NoRoomText
	jr .done
.got_item
	ld hl, Route1Youngster1AlsoGotPokeballsText
.done
	call PrintText
	ret

Route1Youngster1MartSampleText:
	text_far _Route1Youngster1MartSampleText
	text_end

Route1Youngster1GotPotionText:
	text_far _Route1Youngster1GotPotionText
	sound_get_item_1
	text_end

Route1Youngster1AlsoGotPokeballsText:
	text_far _Route1Youngster1AlsoGotPokeballsText
	text_end

Route1Youngster1NoRoomText:
	text_far _Route1Youngster1NoRoomText
	text_end

