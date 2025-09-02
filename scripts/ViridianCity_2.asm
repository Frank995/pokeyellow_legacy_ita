ViridianCityPrintGambler1Text::
	ld hl, ViridianCityGambler1GymOpenText
	ld a, [wObtainedBadges]
	cp ~(1 << BIT_EARTHBADGE)
	jr z, .print_text
	CheckEvent EVENT_VIRIDIAN_GYM_BEAT_GIOVANNI
	jr nz, .print_text
	ld hl, ViridianCityGambler1GymClosedText
.print_text
	call PrintText
	ret

ViridianCityGambler1GymClosedText:
	text_far _ViridianCityGambler1GymClosedText
	text_end

ViridianCityGambler1GymOpenText:
	text_far _ViridianCityGambler1GymOpenText
	text_end

ViridianCityPrintGirlText::
	ld hl, ViridianCityGirlShopText
	CheckEvent EVENT_VIRIDIAN_BEAT_JJ
	jr nz, .beat_jj
	ld hl, ViridianCityGirlGriefText
.beat_jj
	call PrintText
	ret

ViridianCityGirlShopText:
	text_far _ViridianCityGirlShopText
	text_end

ViridianCityGirlGriefText:
	text_far _ViridianCityGirlGriefText
	text_end

ViridianCityPrintFisherText::
	CheckEvent EVENT_VIRIDIAN_GOT_TM42
	jr nz, .got_item
	ld hl, ViridianCityFisherGiveTMText
	call PrintText
	lb bc, TM_DREAM_EATER, 1
	call GiveItem
	jr nc, .bag_full
	ld hl, ViridianCityFisherGotTMText
	call PrintText
	SetEvent EVENT_VIRIDIAN_GOT_TM42
	ret
.bag_full
	ld hl, ViridianCityFisherNoRoomText
	call PrintText
	ret
.got_item
	ld hl, ViridianCityFisherExplainTMText
	call PrintText
	ret

ViridianCityFisherGiveTMText:
	text_far _ViridianCityFisherGiveTMText
	text_end

ViridianCityFisherGotTMText:
	text_far _ViridianCityFisherGotTMText
	sound_get_item_2
	text_end

ViridianCityFisherExplainTMText:
	text_far _ViridianCityFisherExplainTMText
	text_end

ViridianCityFisherNoRoomText:
	text_far _ViridianCityFisherNoRoomText
	text_end
