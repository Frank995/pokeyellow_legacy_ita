VermilionOldRodHouse_Script:
	jp EnableAutoTextBoxDrawing

VermilionOldRodHouse_TextPointers:
	def_text_pointers
	dw_const VermilionOldRodHouseFishingGuruText, TEXT_VERMILIONOLDRODHOUSE_FISHING_GURU

VermilionOldRodHouseFishingGuruText:
	text_asm
	ld a, [wStatusFlags1]
	bit BIT_GOT_OLD_ROD, a
	jr nz, .got_old_rod
	ld hl, VermilionOldRodHouseFishingGuruDoYouLikeToFishText
	call PrintText
	call YesNoChoice
	ld a, [wCurrentMenuItem]
	and a
	jr nz, .refused
	lb bc, OLD_ROD, 1
	call GiveItem
	jr nc, .bag_full
	ld hl, wStatusFlags1
	set BIT_GOT_OLD_ROD, [hl]
	ld hl, VermilionOldRodHouseFishingGuruTakeThisText
	jr .print_text
.bag_full
	ld hl, VermilionOldRodHouseFishingGuruNoRoomText
	jr .print_text
.refused
	ld hl, VermilionOldRodHouseFishingGuruThatsSoDisappointingText
	jr .print_text
.got_old_rod
	ld hl, VermilionOldRodHouseFishingGuruHowAreTheFishBitingText
.print_text
	call PrintText
	jp TextScriptEnd

VermilionOldRodHouseFishingGuruDoYouLikeToFishText:
	text_far _VermilionOldRodHouseFishingGuruDoYouLikeToFishText
	text_end

VermilionOldRodHouseFishingGuruTakeThisText:
	text_far _VermilionOldRodHouseFishingGuruTakeThisText
	sound_get_item_1
	text_far _VermilionOldRodHouseFishingGuruFishingIsAWayOfLifeText
	text_end

VermilionOldRodHouseFishingGuruThatsSoDisappointingText:
	text_far _VermilionOldRodHouseFishingGuruThatsSoDisappointingText
	text_end

VermilionOldRodHouseFishingGuruHowAreTheFishBitingText:
	text_far _VermilionOldRodHouseFishingGuruHowAreTheFishBitingText
	text_end

VermilionOldRodHouseFishingGuruNoRoomText:
	text_far _VermilionOldRodHouseFishingGuruNoRoomText
	text_end
