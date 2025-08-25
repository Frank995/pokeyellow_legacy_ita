RedsHouse1FPrintMomText::
	CheckEvent EVENT_PALLET_MOM_CONGRATULATE_CHAMPION
	jr nz, .continue
	ld a, [wGameStage]
	and a
	jr z, .continue
	; Trigger champion congratulations
	ld hl, RedsHouse1FMomChampionText
	call PrintText
	SetEvent EVENT_PALLET_MOM_CONGRATULATE_CHAMPION
	jr .done
.continue
	; Check for new Mr. Mime dialogue condition
	CheckEvent EVENT_BEAT_ERIKA
	jr z, .normalFlow
	CheckEvent EVENT_PALLET_MOM_TALKED_ABOUT_MRMIME
	jr nz, .normalFlow
	; Trigger Mr. Mime dialogue
	ld hl, RedsHouse1FMomMrMimeText
	call PrintText
	SetEvent EVENT_PALLET_MOM_TALKED_ABOUT_MRMIME
	jr .done
.normalFlow
	ld a, [wStatusFlags4]
	bit BIT_GOT_STARTER, a
	jp nz, RedsHouse1FMomHealScript
	ld hl, RedsHouse1FMomWakeUpText
	call PrintText
.done
	ret

RedsHouse1FMomWakeUpText:
	text_far _RedsHouse1FMomWakeUpText
	text_end
RedsHouse1FMomChampionText:
	text_far _RedsHouse1FMomChampionText
	text_end
RedsHouse1FMomMrMimeText:
	text_far _RedsHouse1FMomMrMimeText
	text_end

RedsHouse1FMomHealScript:
	ld hl, RedsHouse1FMomYouShouldRestText
	call PrintText
	call GBFadeOutToWhite
	call ReloadMapData
	predef HealParty
	ld a, MUSIC_PKMN_HEALED
	ld [wNewSoundID], a
	call PlaySound
.next
	ld a, [wChannelSoundIDs]
	cp MUSIC_PKMN_HEALED
	jr z, .next
	ld a, [wMapMusicSoundID]
	ld [wNewSoundID], a
	call PlaySound
	call GBFadeInFromWhite
	ld hl, RedsHouse1FMomLookingGreatText
	call PrintText
	ret

RedsHouse1FMomYouShouldRestText:
	text_far _RedsHouse1FMomYouShouldRestText
	text_end
RedsHouse1FMomLookingGreatText:
	text_far _RedsHouse1FMomLookingGreatText
	text_end

RedsHouse1FPrintTVText::
	ld hl, RedsHouse1FTVWrongSideText
	ld a, [wSpritePlayerStateData1FacingDirection]
	cp SPRITE_FACING_UP
	jp nz, .wrong_side
	ld hl, RedsHouse1FTVStandByMeMovieText
.wrong_side
	call PrintText
	ret

RedsHouse1FTVStandByMeMovieText:
	text_far _RedsHouse1FTVStandByMeMovieText
	text_end
RedsHouse1FTVWrongSideText:
	text_far _RedsHouse1FTVWrongSideText
	text_end
