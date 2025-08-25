BluesHouse_Script:
	jp EnableAutoTextBoxDrawing

BluesHouse_TextPointers:
	def_text_pointers
	dw_const BluesHouseDaisySittingText, TEXT_BLUESHOUSE_DAISY_SITTING
	dw_const BluesHouseDaisyWalkingText, TEXT_BLUESHOUSE_DAISY_WALKING
	dw_const BluesHouseTownMapText,      TEXT_BLUESHOUSE_TOWN_MAP

BluesHouseDaisySittingText:
	text_asm
	CheckEvent EVENT_PALLET_GOT_TOWN_MAP
	jr nz, .got_town_map
	CheckEvent EVENT_PALLET_GOT_POKEDEX
	jr nz, .give_town_map
	ld hl, BluesHouseDaisyRivalAtLabText
	call PrintText
	jr .done
.give_town_map
	ld hl, BluesHouseDaisyOfferMapText
	call PrintText
	lb bc, TOWN_MAP, 1
	call GiveItem
	jr nc, .bag_full
	ld a, HS_BLUES_HOUSE_TOWN_MAP
	ld [wMissableObjectIndex], a
	predef HideObject
	ld hl, BluesHouseDaisyGotMapText
	call PrintText
	SetEvent EVENT_PALLET_GOT_TOWN_MAP

	; Set event in pallet to change daisy routine
	ld a, 4 ; SCRIPT_PALLETTOWN_SET_DAISY
	ld [wPalletTownCurScript], a

	jr .done
.got_town_map
	ld hl, BluesHouseDaisyUseMapText
	call PrintText
	jr .done
.bag_full
	ld hl, BluesHouseDaisyBagFullText
	call PrintText
.done
	jp TextScriptEnd

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

BluesHouseDaisyUseMapText:
	text_far _BluesHouseDaisyUseMapText
	text_end

BluesHouseDaisyBagFullText:
	text_far _BluesHouseDaisyBagFullText
	text_end

BluesHouseDaisyWalkingText:
	text_far _BluesHouseDaisyWalkingText
	text_end

BluesHouseTownMapText:
	text_far _BluesHouseTownMapText
	text_end
