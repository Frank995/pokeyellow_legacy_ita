ViridianForest_Script:
	call EnableAutoTextBoxDrawing
	ld hl, ViridianForestTrainerHeaders
	ld de, ViridianForest_ScriptPointers
	ld a, [wViridianForestCurScript]
	call ExecuteCurMapScriptInTable
	ld [wViridianForestCurScript], a
	ret

ViridianForestResetScripts:
	xor a
	ld [wJoyIgnore], a
	ld [wViridianForestCurScript], a
	ld [wCurMapScript], a
	ret

ViridianForest_ScriptPointers:
	def_script_pointers
	dw_const ViridianForestDefaultScript,           SCRIPT_VIRIDIANFOREST_DEFAULT
	dw_const DisplayEnemyTrainerTextAndStartBattle, SCRIPT_VIRIDIANFOREST_START_BATTLE
	dw_const EndTrainerBattle,                      SCRIPT_VIRIDIANFOREST_END_BATTLE
	dw_const ViridianForestJJEncounterScript,       SCRIPT_VIRIDIANFOREST_JJ_ENCOUNTER
	dw_const ViridianForestJJSpeechScript,          SCRIPT_VIRIDIANFOREST_JJ_SPEECH
	dw_const ViridianForestJJPostBattleScript,      SCRIPT_VIRIDIANFOREST_JJ_POST_BATTLE

ViridianForestDefaultScript:
	; Check if Team Rocket event already completed
	CheckEvent EVENT_VIRIDIAN_FOREST_BEAT_JJ
	jp nz, CheckFightingMapTrainers
	
	; Check player coordinates for Team Rocket trigger
	ld a, [wXCoord]
	cp 1
	jr z, .checkYCoord
	cp 2
	jr nz, .noTeamRocketTrigger
.checkYCoord:
	ld a, [wYCoord]
	cp 2
	jr nz, .noTeamRocketTrigger
	
	; Trigger Team Rocket encounter
	ld a, SCRIPT_VIRIDIANFOREST_JJ_ENCOUNTER
	ld [wViridianForestCurScript], a
	ld [wCurMapScript], a
	ret
.noTeamRocketTrigger:
	jp CheckFightingMapTrainers

ViridianForestJJEncounterScript:
	; Stop player movement
	xor a
	ldh [hJoyHeld], a
	ld a, PAD_START | PAD_SELECT | PAD_CTRL_PAD
	ld [wJoyIgnore], a
	
	; Display initial text
	ld c, 15
	call DelayFrames
	ld a, TEXT_VIRIDIANFOREST_JJ_HEREWEARE
	ldh [hTextID], a
	call DisplayTextID
	
	; Show emotion bubble above player after a delay
	ld c, 30
	call DelayFrames
	ld a, 0
	ld [wEmotionBubbleSpriteIndex], a ; player's sprite
	ld a, EXCLAMATION_BUBBLE
	ld [wWhichEmotionBubble], a
	predef EmotionBubble
	
	; Make player turn down
	ld a, PLAYER_DIR_DOWN
	ld [wPlayerMovingDirection], a
	
	; Setup Jessie and James sprites to appear from bottom
	ld a, HS_VIRIDIAN_FOREST_JESSIE
	ld [wMissableObjectIndex], a
	predef ShowObject
	ld a, HS_VIRIDIAN_FOREST_JAMES
	ld [wMissableObjectIndex], a
	predef ShowObject
	call UpdateSprites
	
	; --- Jessie movement ---
	ld a, [wNPCMovementDirections2Index]
	ld [wSavedNPCMovementDirections2Index], a ; save current index
	ld hl, wNPCMovementDirections2
	ld b, 5
.fillJessieMovement:
	ld [hl], NPC_MOVEMENT_UP
	inc hl
	dec b
	jr nz, .fillJessieMovement
	ld [hl], $ff

	ld a, VIRIDIANFOREST_JESSIE
	ldh [hSpriteIndex], a
	ld de, wNPCMovementDirections2
	call MoveSprite

	; restore index so next NPC doesn't overwrite/loop
	ld a, [wSavedNPCMovementDirections2Index]
	ld [wNPCMovementDirections2Index], a


	; --- James movement ---
	ld a, [wNPCMovementDirections2Index]
	ld [wSavedNPCMovementDirections2Index], a
	ld hl, wNPCMovementDirections2
	ld b, 5
.fillJamesMovement:
	ld [hl], NPC_MOVEMENT_UP
	inc hl
	dec b
	jr nz, .fillJamesMovement
	ld [hl], $ff

	ld a, VIRIDIANFOREST_JAMES
	ldh [hSpriteIndex], a
	ld de, wNPCMovementDirections2
	call MoveSprite

	; Restore again
	ld a, [wSavedNPCMovementDirections2Index]
	ld [wNPCMovementDirections2Index], a

	; Advance to battle dialogue
	ld a, SCRIPT_VIRIDIANFOREST_JJ_SPEECH
	ld [wViridianForestCurScript], a
	ld [wCurMapScript], a
	ret

ViridianForestJJSpeechScript:
	; Wait for sprites to finish moving
	ld a, [wStatusFlags5]
	bit BIT_SCRIPTED_NPC_MOVEMENT, a
	ret nz

	; Renable input
	xor a
	ld [wJoyIgnore], a

	ld a, TEXT_VIRIDIANFOREST_JJ_SPEECH
	ldh [hTextID], a
	call DisplayTextID
	call DelayFrame

	ld a, TEXT_VIRIDIANFOREST_JJ_MEOWTH
	ldh [hTextID], a
	call DisplayTextID
	call Delay3

	ld a, TEXT_VIRIDIANFOREST_JJ_JESSIE_BATTLE
	ldh [hTextID], a
	call DisplayTextID
	ret

ViridianForestJJPostBattleScript:
	; Check if the player lost
	ld a, [wIsInBattle]	; If wIsInBattle is -1, then the battle was lost
	inc a	; If A holds -1, it will increment to 0 and set the z flag
	jr z, .skip	; Kick out if the player lost.
	
	; Display victory text
	ld a, TEXT_VIRIDIANFOREST_JJ_DEFEATED
	ldh [hTextID], a
	call DisplayTextID
	
	; Hide Jessie and James sprites
	call GBFadeOutToBlack
	ld c, 60
	call DelayFrames
	SetEvent EVENT_VIRIDIAN_FOREST_BEAT_JJ
	ld a, HS_VIRIDIAN_FOREST_JESSIE
	ld [wMissableObjectIndex], a
	predef HideObject
	ld a, HS_VIRIDIAN_FOREST_JAMES
	ld [wMissableObjectIndex], a
	predef HideObject
	call UpdateSprites
	call Delay3
	call GBFadeInFromBlack
.skip
	ld a, HS_VIRIDIAN_FOREST_JESSIE
	ld [wMissableObjectIndex], a
	predef HideObject
	ld a, HS_VIRIDIAN_FOREST_JAMES
	ld [wMissableObjectIndex], a
	predef HideObject
	call UpdateSprites
	ld a, SCRIPT_VIRIDIANFOREST_DEFAULT
	ld [wViridianForestCurScript], a
	ld [wCurMapScript], a
	ret

ViridianForest_TextPointers:
	def_text_pointers
	dw_const ViridianForestYoungster1Text,      TEXT_VIRIDIANFOREST_YOUNGSTER1
	dw_const ViridianForestYoungster2Text,      TEXT_VIRIDIANFOREST_YOUNGSTER2
	dw_const ViridianForestYoungster3Text,      TEXT_VIRIDIANFOREST_YOUNGSTER3
	dw_const ViridianForestYoungster4Text,      TEXT_VIRIDIANFOREST_YOUNGSTER4
	dw_const ViridianForestCooltrainerFText,    TEXT_VIRIDIANFOREST_COOLTRAINER_F
	dw_const ViridianForestYoungster5Text,      TEXT_VIRIDIANFOREST_YOUNGSTER5
	dw_const PickUpItemText,                    TEXT_VIRIDIANFOREST_POTION1
	dw_const PickUpItemText,                    TEXT_VIRIDIANFOREST_POTION2
	dw_const PickUpItemText,                    TEXT_VIRIDIANFOREST_POKE_BALL
	dw_const ViridianForestYoungster6Text,      TEXT_VIRIDIANFOREST_YOUNGSTER6
	dw_const ViridianForestJJBattleText,        TEXT_VIRIDIANFOREST_JJ_JESSIE_BATTLE
	dw_const ViridianForestJJBattleText,        TEXT_VIRIDIANFOREST_JJ_JAMES_BATTLE
	dw_const ViridianForestTrainerTips1Text,    TEXT_VIRIDIANFOREST_TRAINER_TIPS1
	dw_const ViridianForestUseAntidoteSignText, TEXT_VIRIDIANFOREST_USE_ANTIDOTE_SIGN
	dw_const ViridianForestTrainerTips2Text,    TEXT_VIRIDIANFOREST_TRAINER_TIPS2
	dw_const ViridianForestTrainerTips3Text,    TEXT_VIRIDIANFOREST_TRAINER_TIPS3
	dw_const ViridianForestTrainerTips4Text,    TEXT_VIRIDIANFOREST_TRAINER_TIPS4
	dw_const ViridianForestLeavingSignText,     TEXT_VIRIDIANFOREST_LEAVING_SIGN
	dw_const ViridianForestJJHereWeAreText,     TEXT_VIRIDIANFOREST_JJ_HEREWEARE
	dw_const ViridianForestJJSpeechText,        TEXT_VIRIDIANFOREST_JJ_SPEECH
	dw_const ViridianForestJJMeowthText,        TEXT_VIRIDIANFOREST_JJ_MEOWTH
	dw_const ViridianForestJJDefeatedText,      TEXT_VIRIDIANFOREST_JJ_DEFEATED

ViridianForestTrainerHeaders:
	def_trainers 2
ViridianForestTrainerHeader0:
	trainer EVENT_VIRIDIAN_FOREST_BEAT_TRAINER_0, 4, ViridianForestYoungster2BattleText, ViridianForestYoungster2EndBattleText, ViridianForestYoungster2AfterBattleText
ViridianForestTrainerHeader1:
	trainer EVENT_VIRIDIAN_FOREST_BEAT_TRAINER_1, 4, ViridianForestYoungster3BattleText, ViridianForestYoungster3EndBattleText, ViridianForestYoungster3AfterBattleText
ViridianForestTrainerHeader2:
	trainer EVENT_VIRIDIAN_FOREST_BEAT_TRAINER_2, 1, ViridianForestYoungster4BattleText, ViridianForestYoungster4EndBattleText, ViridianForestYoungster4AfterBattleText
ViridianForestTrainerHeader3:
	trainer EVENT_VIRIDIAN_FOREST_BEAT_TRAINER_3, 0, ViridianForestCooltrainerFBattleText, ViridianForestCooltrainerFEndBattleText, ViridianForestCooltrainerFAfterBattleText
ViridianForestTrainerHeader4:
	trainer EVENT_VIRIDIAN_FOREST_BEAT_TRAINER_4, 4, ViridianForestYoungster5BattleText, ViridianForestYoungster5EndBattleText, ViridianForestYoungster5AfterBattleText
	db -1 ; end

ViridianForestYoungster1Text:
	text_far _ViridianForestYoungster1Text
	text_end

ViridianForestYoungster2Text:
	text_asm
	ld hl, ViridianForestTrainerHeader0
	jr ViridianForestTalkToTrainer

ViridianForestYoungster3Text:
	text_asm
	ld hl, ViridianForestTrainerHeader1
	jr ViridianForestTalkToTrainer

ViridianForestYoungster4Text:
	text_asm
	ld hl, ViridianForestTrainerHeader2
	jr ViridianForestTalkToTrainer

ViridianForestCooltrainerFText:
	text_asm
	ld hl, ViridianForestTrainerHeader3
	jr ViridianForestTalkToTrainer

ViridianForestYoungster5Text:
	text_asm
	ld hl, ViridianForestTrainerHeader4
ViridianForestTalkToTrainer:
	call TalkToTrainer
	jp TextScriptEnd

ViridianForestYoungster2BattleText:
	text_far _ViridianForestYoungster2BattleText
	text_end

ViridianForestYoungster2EndBattleText:
	text_far _ViridianForestYoungster2EndBattleText
	text_end

ViridianForestYoungster2AfterBattleText:
	text_far _ViridianForestYoungster2AfterBattleText
	text_end

ViridianForestYoungster3BattleText:
	text_far _ViridianForestYoungster3BattleText
	text_end

ViridianForestYoungster3EndBattleText:
	text_far _ViridianForestYoungster3EndBattleText
	text_end

ViridianForestYoungster3AfterBattleText:
	text_far _ViridianForestYoungster3AfterBattleText
	text_end

ViridianForestYoungster4BattleText:
	text_far _ViridianForestYoungster4BattleText
	text_end

ViridianForestYoungster4EndBattleText:
	text_far _ViridianForestYoungster4EndBattleText
	text_end

ViridianForestYoungster4AfterBattleText:
	text_far _ViridianForestYoungster4AfterBattleText
	text_end

ViridianForestCooltrainerFBattleText:
	text_far _ViridianForestCooltrainerFBattleText
	text_end

ViridianForestCooltrainerFEndBattleText:
	text_far _ViridianForestCooltrainerFEndBattleText
	text_end

ViridianForestCooltrainerFAfterBattleText:
	text_far _ViridianForestCooltrainerFAfterBattleText
	text_end

ViridianForestYoungster5BattleText:
	text_far _ViridianForestYoungster5BattleText
	text_end

ViridianForestYoungster5EndBattleText:
	text_far _ViridianForestYoungster5EndBattleText
	text_end

ViridianForestYoungster5AfterBattleText:
	text_far _ViridianForestYoungster5AfterBattleText
	text_end

ViridianForestYoungster6Text:
	text_far _ViridianForestYoungster6Text
	text_end

ViridianForestJJBattleText:
	text_asm

	; Start battle
	ld hl, wStatusFlags3
	set BIT_TALKED_TO_TRAINER, [hl]
	set BIT_PRINT_END_BATTLE_TEXT, [hl]
	call Delay3
	ld a, OPP_ROCKET
	ld [wCurOpponent], a
	ld a, $2A
	ld [wTrainerNo], a

	; Change map script
	ld a, SCRIPT_VIRIDIANFOREST_JJ_POST_BATTLE
	ld [wViridianForestCurScript], a
	ld [wCurMapScript], a

	ld hl, ViridianForestJJBattleLostText
	ld de, ViridianForestJJBattleWonText
	call SaveEndBattleTextPointers

	ld hl, ViridianForestJJStartBattleText
	call PrintText
	jp TextScriptEnd

ViridianForestJJStartBattleText:
	text_far _ViridianForestJJStartBattleText
	text_end

ViridianForestJJBattleLostText:
	text_far _ViridianForestJJBattleLostText
	text_end

ViridianForestJJBattleWonText:
	text_far _JJBattleWonText
	text_end

ViridianForestJJHereWeAreText:
	text_far _ViridianForestJJHereWeAreText
	text_end

ViridianForestJJSpeechText:
	text_far _JJSpeechText
	text_end

ViridianForestJJMeowthText:
	text_far _ViridianForestJJMeowthText
	text_end

ViridianForestJJDefeatedText:
	text_far _ViridianForestJJDefeatedText
	text_end

ViridianForestTrainerTips1Text:
	text_asm
	ld hl, ViridianForestPrintTrainerTips1Text
	jp ViridianForestSign_Common

ViridianForestUseAntidoteSignText:
	text_asm
	ld hl, ViridianForestPrintUseAntidoteSignText
	jp ViridianForestSign_Common

ViridianForestTrainerTips2Text:
	text_asm
	ld hl, ViridianForestPrintTrainerTips2Text
	jp ViridianForestSign_Common

ViridianForestTrainerTips3Text:
	text_asm
	ld hl, ViridianForestPrintTrainerTips3Text
	jp ViridianForestSign_Common

ViridianForestTrainerTips4Text:
	text_asm
	ld hl, ViridianForestPrintTrainerTips4Text
	jp ViridianForestSign_Common

ViridianForestLeavingSignText:
	text_asm
	ld hl, ViridianForestPrintLeavingSignText
	jp ViridianForestSign_Common

ViridianForestSign_Common:
	ld b, BANK(ViridianForestPrintTrainerTips1Text)
	call Bankswitch
	jp TextScriptEnd
