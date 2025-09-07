BluesHousePrintDaisyText:
	; If already got the town map 
	CheckEvent EVENT_PALLET_GOT_TOWN_MAP
	jr nz, .got_town_map

	; If already got the pokedex give the map
	CheckEvent EVENT_PALLET_GOT_POKEDEX
	jr nz, .give_town_map

	; If talking before seeing rival
	ld hl, BluesHouseDaisyRivalAtLabText
	call PrintText
	ret

.give_town_map
	ld hl, BluesHouseDaisyOfferMapText
	call PrintText
	lb bc, TOWN_MAP, 1
	call GiveItem

	; Se ha lo zaino pieno, salta
	jr nc, .bag_full

	; Hide town map and set event
	ld a, HS_BLUES_HOUSE_TOWN_MAP
	ld [wMissableObjectIndex], a
	predef HideObject
	ld hl, BluesHouseDaisyGotMapText
	call PrintText
	SetEvent EVENT_PALLET_GOT_TOWN_MAP
	ret

.got_town_map
	ld hl, BluesHouseDaisyFriendlyText
	call PrintText
	ret

.bag_full
	ld hl, BluesHouseDaisyBagFullText
	call PrintText
    ret

BluesHouseDaisyRivalAtLabText:
	text_far _BluesHouseDaisyRivalAtLabText
	text_end

BluesHouseDaisyOfferMapText:
	text_far _BluesHouseDaisyOfferMapText
	text_end

BluesHouseDaisyGotMapText:
	text_far _BluesHouseDaisyGotMapText
	sound_get_key_item
	text_end

BluesHouseDaisyFriendlyText:
	text_far _BluesHouseDaisyFriendlyText
	text_end

BluesHouseDaisyBagFullText:
	text_far _BluesHouseDaisyBagFullText
	text_end