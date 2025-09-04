Route24PrintRocketText::
    ; If already got nugget
	ResetEvent EVENT_ROUTE_24_NUGGET_REWARD_AVAILABLE
	CheckEvent EVENT_ROUTE_24_GOT_NUGGET
	jr nz, .got_item

    ; Contest beaten, give nugget
	ld hl, Route24RocketYouBeatOurContestText
	call PrintText
	lb bc, NUGGET, 1
	call GiveItem
	jr nc, .bag_full
	SetEvent EVENT_ROUTE_24_GOT_NUGGET
	ld hl, Route24RocketReceivedNuggetText
	call PrintText
	ld hl, Route24RocketJoinTeamRocketText
	call PrintText

    ; Start fight
	ld hl, wStatusFlags3
	set BIT_TALKED_TO_TRAINER, [hl]
	set BIT_PRINT_END_BATTLE_TEXT, [hl]
	ld hl, Route24RocketDefeatedText
	ld de, Route24RocketDefeatedText
	call SaveEndBattleTextPointers
	ldh a, [hSpriteIndex]
	ld [wSpriteIndex], a
	call EngageMapTrainer
	call InitBattleEnemyParameters

    ; Start post battle script
	xor a
	ldh [hJoyHeld], a
	ld a, SCRIPT_ROUTE24_AFTER_ROCKET_BATTLE
	ld [wRoute24CurScript], a
	ld [wCurMapScript], a
	ret
.got_item
	ld hl, Route24RocketYouCouldBecomeATopLeaderText
	call PrintText
	ret
.bag_full
	ld hl, Route24RocketNoRoomText
	call PrintText
	SetEvent EVENT_ROUTE_24_NUGGET_REWARD_AVAILABLE
	ret

Route24RocketYouBeatOurContestText:
	text_far _Route24RocketYouBeatOurContestText
	sound_get_item_1
	text_far _Route24RocketYouJustEarnedAPrizeText
	text_end

Route24RocketReceivedNuggetText:
	text_far _Route24RocketReceivedNuggetText
	sound_get_key_item
	text_promptbutton
	text_end

Route24RocketNoRoomText:
	text_far _Route24RocketNoRoomText
	text_end

Route24RocketJoinTeamRocketText:
	text_far _Route24RocketJoinTeamRocketText
	text_end

Route24RocketDefeatedText:
	text_far _Route24RocketDefeatedText
	text_end

Route24RocketYouCouldBecomeATopLeaderText:
	text_far _Route24RocketYouCouldBecomeATopLeaderText
	text_end

Route24PrintDamianText::
    ; Check if already got charmander
	CheckEvent EVENT_ROUTE_24_GOT_CHARMANDER
	jr nz, .got_charmander

    ; Ask question
	ld hl, Route24DamianDoYouWantItText
	call PrintText
	call YesNoChoice
	ld a, [wCurrentMenuItem]
	and a
	jr nz, .not_willing

    ; Willing to take it
	ld a, $1
	ld [wDoNotWaitForButtonPressAfterDisplayingText], a
	ld a, CHARMANDER
	ld [wNamedObjectIndex], a
	ld [wCurPartySpecies], a
	call GetMonName
	lb bc, CHARMANDER, 10
	call GivePokemon
	ret nc

	ld a, [wAddedToParty]
	and a
	call z, WaitForTextScrollButtonPress
	ld a, $1
	ld [wDoNotWaitForButtonPressAfterDisplayingText], a
	ld hl, Route24DamianTakeCareText
	call PrintText
	SetEvent EVENT_ROUTE_24_GOT_CHARMANDER
	ret
.not_willing
	ld hl, Route24DamianThatsAShameText
	jr .done
.got_charmander
	ld hl, Route24DamianIsItFineText
.done
	call PrintText
	ret

Route24DamianDoYouWantItText:
	text_far _Route24DamianDoYouWantItText
	text_end

Route24DamianTakeCareText:
	text_far _Route24DamianTakeCareText
	text_end

Route24DamianThatsAShameText:
	text_far _Route24DamianThatsAShameText
	text_end

Route24DamianIsItFineText:
	text_far _Route24DamianIsItFineText
	text_end
