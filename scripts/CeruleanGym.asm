CeruleanGym_Script:
	ld hl, wCurrentMapScriptFlags
	bit BIT_CUR_MAP_LOADED_2, [hl]
	res BIT_CUR_MAP_LOADED_2, [hl]
	call nz, .LoadNames
	call EnableAutoTextBoxDrawing
	ld hl, CeruleanGymTrainerHeaders
	ld de, CeruleanGym_ScriptPointers
	ld a, [wCeruleanGymCurScript]
	call ExecuteCurMapScriptInTable
	ld [wCeruleanGymCurScript], a
	ret

.LoadNames:
	ld hl, .CityName
	ld de, .LeaderName
	jp LoadGymLeaderAndCityName

.CityName:
	db "CELESTOPOLI@"

.LeaderName:
	db "MISTY@"

CeruleanGymResetScripts:
	xor a
	ld [wJoyIgnore], a
	ld [wCeruleanGymCurScript], a
	ld [wCurMapScript], a
	ret

CeruleanGym_ScriptPointers:
	def_script_pointers
	dw_const CheckFightingMapTrainers,              SCRIPT_CERULEANGYM_DEFAULT
	dw_const DisplayEnemyTrainerTextAndStartBattle, SCRIPT_CERULEANGYM_START_BATTLE
	dw_const EndTrainerBattle,                      SCRIPT_CERULEANGYM_END_BATTLE
	dw_const CeruleanGymMistyPostBattleScript,      SCRIPT_CERULEANGYM_MISTY_POST_BATTLE
	dw_const CeruleanGymJJPostBattleScript,         SCRIPT_CERULEANGYM_JJ_POST_BATTLE

CeruleanGymMistyPostBattleScript:
	ld a, [wIsInBattle]
	cp $ff
	jp z, CeruleanGymResetScripts
	ld a, PAD_CTRL_PAD
	ld [wJoyIgnore], a
	ld a, [wGameStage] ; Check if player has beat the game
	and a
	jr nz, MistyRematchPostBattle
; fallthrough
CeruleanGymReceiveTM11:
	ld a, TEXT_CERULEANGYM_MISTY_CASCADE_BADGE_INFO
	ldh [hTextID], a
	call DisplayTextID
	SetEvent EVENT_CERULEAN_GYM_BEAT_MISTY
	lb bc, TM_BUBBLEBEAM, 1
	call GiveItem
	jr nc, .BagFull
	ld a, TEXT_CERULEANGYM_MISTY_RECEIVED_TM11
	ldh [hTextID], a
	call DisplayTextID
	SetEvent EVENT_CERULEAN_GYM_GOT_TM11
	jr .gymVictory
.BagFull
	ld a, TEXT_CERULEANGYM_MISTY_TM11_NO_ROOM
	ldh [hTextID], a
	call DisplayTextID
.gymVictory
	ld hl, wObtainedBadges
	set BIT_CASCADEBADGE, [hl]
	ld hl, wBeatGymFlags
	set BIT_CASCADEBADGE, [hl]

	; deactivate gym trainers
	SetEvents EVENT_CERULEAN_GYM_BEAT_TRAINER_0, EVENT_CERULEAN_GYM_BEAT_TRAINER_1

	jp CeruleanGymResetScripts

MistyRematchPostBattle:
	ld a, TEXT_CERULEANGYM_REMATCH_POST_BATTLE
	ldh [hTextID], a
	call DisplayTextID
	jp CeruleanGymResetScripts

CeruleanGymJJPostBattleScript:
	; If the player lost reset event
	ld a, [wIsInBattle]
	inc a
	jr z, .skip

	; Display victory text
	ld a, TEXT_CERULEANGYM_JJ_LOST_TM
	ldh [hTextID], a
	call DisplayTextID

	; Hide Jessie and James sprites
	call GBFadeOutToBlack
	ld c, 60
	call DelayFrames
	SetEvent EVENT_CERULEAN_GYM_BEAT_JJ
	ld a, HS_CERULEAN_GYM_JESSIE
	ld [wMissableObjectIndex], a
	predef HideObject
	ld a, HS_CERULEAN_GYM_JAMES
	ld [wMissableObjectIndex], a
	predef HideObject
	ld a, HS_CERULEAN_CITY_JENNY
	ld [wMissableObjectIndex], a
	predef HideObject
	call UpdateSprites
	call Delay3
	call GBFadeInFromBlack
.skip
	xor a
	ld [wCeruleanCityCurScript], a
	ld [wCurMapScript], a
	ret

CeruleanGym_TextPointers:
	def_text_pointers
	dw_const CeruleanGymMistyText,                 TEXT_CERULEANGYM_MISTY
	dw_const CeruleanGymCooltrainerFText,          TEXT_CERULEANGYM_COOLTRAINER_F
	dw_const CeruleanGymSwimmerText,               TEXT_CERULEANGYM_SWIMMER
	dw_const CeruleanGymGymGuideText,              TEXT_CERULEANGYM_GYM_GUIDE
	dw_const CeruleanGymJJBattleText,              TEXT_CERULEANGYM_JESSIE
	dw_const CeruleanGymJJBattleText,              TEXT_CERULEANGYM_JAMES
	dw_const CeruleanGymMistyCascadeBadgeInfoText, TEXT_CERULEANGYM_MISTY_CASCADE_BADGE_INFO
	dw_const CeruleanGymMistyReceivedTM11Text,     TEXT_CERULEANGYM_MISTY_RECEIVED_TM11
	dw_const CeruleanGymMistyTM11NoRoomText,       TEXT_CERULEANGYM_MISTY_TM11_NO_ROOM
	dw_const CeruleanGymRematchPostBattleText, 	   TEXT_CERULEANGYM_REMATCH_POST_BATTLE
	dw_const CeruleanGymJJLostTMText,              TEXT_CERULEANGYM_JJ_LOST_TM

CeruleanGymTrainerHeaders:
	def_trainers 2
CeruleanGymTrainerHeader0:
	trainer EVENT_CERULEAN_GYM_BEAT_TRAINER_0, 3, CeruleanGymBattleText1, CeruleanGymEndBattleText1, CeruleanGymAfterBattleText1
CeruleanGymTrainerHeader1:
	trainer EVENT_CERULEAN_GYM_BEAT_TRAINER_1, 3, CeruleanGymBattleText2, CeruleanGymEndBattleText2, CeruleanGymAfterBattleText2
	db -1 ; end

CeruleanGymJJBattleText:
	text_asm

	; Turn JJ sprites down
	ld a, CERULEANGYM_GYM_JESSIE
	ldh [hSpriteIndex], a
	ld a, SPRITE_FACING_DOWN
	ldh [hSpriteFacingDirection], a
	call SetSpriteFacingDirection
	ld a, CERULEANGYM_GYM_JAMES
	ldh [hSpriteIndex], a
	ld a, SPRITE_FACING_DOWN
	ldh [hSpriteFacingDirection], a
	call SetSpriteFacingDirectionAndDelay

	; Start battle
	ld hl, wStatusFlags3
	set BIT_TALKED_TO_TRAINER, [hl]
	set BIT_PRINT_END_BATTLE_TEXT, [hl]
	call Delay3
	ld a, OPP_JESSIEJAMES
	ld [wCurOpponent], a
	ld a, 4
	ld [wTrainerNo], a

	; Change map script
	ld a, SCRIPT_CERULEANGYM_JJ_POST_BATTLE
	ld [wCeruleanGymCurScript], a
	ld [wCurMapScript], a

	ld hl, CeruleanGymJJBattleLostText
	ld de, CeruleanGymJJBattleWonText
	call SaveEndBattleTextPointers

	callfar PrintJJSpeechText
	call Delay3

	callfar PrintJJMeowthText
	call Delay3

	ld hl, CeruleanGymJJStartBattleText
	call PrintText

	jp TextScriptEnd

CeruleanGymJJStartBattleText:
	text_far _CeruleanGymJJStartBattleText
	text_end

CeruleanGymJJBattleLostText:
	text_far _CeruleanGymJJBattleLostText
	text_end

CeruleanGymJJBattleWonText:
	text_far _JJBattleWonText
	text_end

CeruleanGymJJLostTMText:
	text_far _CeruleanGymJJLostTMText
	text_end

CeruleanGymMistyText:
	text_asm
	CheckEvent EVENT_CERULEAN_GYM_BEAT_MISTY
	jr z, .beforeBeat
	CheckEventReuseA EVENT_CERULEAN_GYM_GOT_TM11
	jr nz, .afterBeat
	call z, CeruleanGymReceiveTM11
	call DisableWaitingAfterTextDisplay
	jr .done
.afterBeat
	ld a, [wGameStage] ; Check if player has beat the game
	and a
	jr nz, .MistyRematch
	ld hl, .TM11ExplanationText
	call PrintText
	jr .done
.beforeBeat
	ld hl, .PreBattleText
	call PrintText
	ld hl, wStatusFlags3
	set BIT_TALKED_TO_TRAINER, [hl]
	set BIT_PRINT_END_BATTLE_TEXT, [hl]
	ld hl, CeruleanGymMistyReceivedCascadeBadgeText
	ld de, CeruleanGymMistyReceivedCascadeBadgeText
	call SaveEndBattleTextPointers
	ldh a, [hSpriteIndex]
	ld [wSpriteIndex], a
	call EngageMapTrainer
	call InitBattleEnemyParameters
	ld a, $2
	ld [wGymLeaderNo], a
	xor a
	ldh [hJoyHeld], a
	jr .endBattle
.MistyRematch
	ld hl, .PreBattleRematch1Text
	call PrintText
	call YesNoChoice
	ld a, [wCurrentMenuItem]
	and a
	jr nz, .refused
	ld hl, .PreBattleRematch2Text
	call PrintText
	call Delay3
	ld a, OPP_MISTY
	ld [wCurOpponent], a
	ld a, 2
	ld [wTrainerNo], a
	ld a, $4 ; new script
	ld [wCeruleanGymCurScript], a
	ld [wCurMapScript], a
	jr .endBattle
.refused
	ld hl, .PreBattleRematchRefusedText
	call PrintText
	jr .done
.endBattle
	ld a, SCRIPT_CERULEANGYM_MISTY_POST_BATTLE
	ld [wCeruleanGymCurScript], a
	ld [wCurMapScript], a
.done
	jp TextScriptEnd

.PreBattleText:
	text_far _CeruleanGymMistyPreBattleText
	text_end

.TM11ExplanationText:
	text_far _CeruleanGymMistyTM11ExplanationText
	text_end

.PreBattleRematch1Text
	text_far _CeruleanGymRematchPreBattle1Text
	text_end

.PreBattleRematchRefusedText
	text_far _GymRematchRefusedText
	text_end

.PreBattleRematch2Text
	text_far _CeruleanGymPreRematchBattle2Text
	text_end

CeruleanGymRematchPostBattleText:
	text_far _CeruleanGymRematchPostBattleText
	text_end

CeruleanGymMistyCascadeBadgeInfoText:
	text_far _CeruleanGymMistyCascadeBadgeInfoText
	text_end

CeruleanGymMistyReceivedTM11Text:
	text_far _CeruleanGymMistyReceivedTM11Text
	sound_get_item_1
	text_end

CeruleanGymMistyTM11NoRoomText:
	text_far _CeruleanGymMistyTM11NoRoomText
	text_end

CeruleanGymMistyReceivedCascadeBadgeText:
	text_far _CeruleanGymMistyReceivedCascadeBadgeText
	text_end

CeruleanGymCooltrainerFText:
	text_asm
	ld hl, CeruleanGymTrainerHeader0
	call TalkToTrainer
	jp TextScriptEnd

CeruleanGymBattleText1:
	text_far _CeruleanGymBattleText1
	text_end

CeruleanGymEndBattleText1:
	text_far _CeruleanGymEndBattleText1
	text_end

CeruleanGymAfterBattleText1:
	text_far _CeruleanGymAfterBattleText1
	text_end

CeruleanGymSwimmerText:
	text_asm
	ld hl, CeruleanGymTrainerHeader1
	call TalkToTrainer
	jp TextScriptEnd

CeruleanGymBattleText2:
	text_far _CeruleanGymBattleText2
	text_end

CeruleanGymEndBattleText2:
	text_far _CeruleanGymEndBattleText2
	text_end

CeruleanGymAfterBattleText2:
	text_far _CeruleanGymAfterBattleText2
	text_end

CeruleanGymGymGuideText:
	text_asm
	CheckEvent EVENT_CERULEAN_GYM_BEAT_MISTY
	jr nz, .afterBeat
	ld hl, .ChampInMakingText
	call PrintText
	jr .done
.afterBeat
	ld hl, .BeatMistyText
	call PrintText
.done
	jp TextScriptEnd

.ChampInMakingText:
	text_far _CeruleanGymGymGuideChampInMakingText
	text_end

.BeatMistyText:
	text_far _CeruleanGymGymGuideBeatMistyText
	text_end
