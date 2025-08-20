ViridianCityPrintGambler1Text::
	ld hl, ViridianCityGambler1GymOpenText
	ld a, [wObtainedBadges]
	cp ~(1 << BIT_EARTHBADGE)
	jr z, .print_text
	CheckEvent EVENT_BEAT_VIRIDIAN_GYM_GIOVANNI
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

ViridianCityPrintYoungster2Text::
	ld hl, ViridianCityYoungster2QuestionText
	call PrintText
	call YesNoChoice

	ld a, [wCurrentMenuItem]
	cp 0
	jr z, .yes
	ld hl, ViridianCityYoungster2NoText
	jr .print_text
.yes
	ld hl, ViridianCityYoungster2YesText
.print_text
	call PrintText
	ret

ViridianCityYoungster2QuestionText:
	text_far _ViridianCityYoungster2QuestionText
	text_end

ViridianCityYoungster2NoText:
	text_far _ViridianCityYoungster2NoText
	text_end

ViridianCityYoungster2YesText:
	text_far _ViridianCityYoungster2YesText
	text_end

ViridianCityPrintGirlText::
	ld hl, ViridianCityGirlShopText
	CheckEvent EVENT_GOT_POKEDEX
	jr nz, .got_pokedex
	ld hl, ViridianCityGirlHasntHadHisCoffeeYetText
.got_pokedex
	call PrintText
	ret

ViridianCityGirlShopText:
	text_far _ViridianCityGirlShopText
	text_end

ViridianCityGirlHasntHadHisCoffeeYetText:
	text_far _ViridianCityGirlHasntHadHisCoffeeYetText
	text_end

ViridianCityPrintFisherText::
	CheckEvent EVENT_GOT_TM42
	jr nz, .got_item
	ld hl, ViridianCityFisherGiveTMText
	call PrintText
	lb bc, TM_DREAM_EATER, 1
	call GiveItem
	jr nc, .bag_full
	ld hl, ViridianCityFisherGotTMText
	call PrintText
	SetEvent EVENT_GOT_TM42
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
