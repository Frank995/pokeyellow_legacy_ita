ViridianPokecenter_Script:
	call Serial_TryEstablishingExternallyClockedConnection
	call EnableAutoTextBoxDrawing
	ld hl, ViridianPokecenter_ScriptPointers
	ld a, [wViridianPokecenterCurScript]
	jp CallFunctionInTable

ViridianPokecenter_ScriptPointers:
	def_script_pointers
	dw_const ViridianPokecenterJJCheckScript,      SCRIPT_VIRIDIANPOKECENTER_JJ_CHECK
	dw_const ViridianPokecenterJJBlackOutScript,   SCRIPT_VIRIDIANPOKECENTER_JJ_BLACK_OUT
	dw_const ViridianPokecenterJJBubbleScript,     SCRIPT_VIRIDIANPOKECENTER_JJ_BUBBLE
	dw_const ViridianPokecenterJJSpeechScript,     SCRIPT_VIRIDIANPOKECENTER_JJ_SPEECH
	dw_const ViridianPokecenterJJPostBattleScript, SCRIPT_VIRIDIANPOKECENTER_JJ_POST_BATTLE
	dw_const ViridianPokecenterNoopScript,         SCRIPT_VIRIDIANPOKECENTER_NOOP

ViridianPokecenterJJCheckScript:
IF DEF(_DEBUG)
	call DebugPressedOrHeldB
	ret nz
ENDC

	; Check if the player has already beaten J&J
	CheckEvent EVENT_VIRIDIAN_BEAT_JJ
	jr nz, .skip_check

	; Check that pokemon have been already healed
	CheckEvent EVENT_VIRIDIAN_HEALED_AT_CENTER
	ret z

	; Check position
	ld a, [wYCoord]
	cp 4 ; one tile down the counter
	ret nz
	
	; Stop player movement
	xor a
	ldh [hJoyHeld], a
	ld a, PAD_START | PAD_SELECT | PAD_CTRL_PAD
	ld [wJoyIgnore], a
	
	ld a, SCRIPT_VIRIDIANPOKECENTER_JJ_BLACK_OUT
	ld [wViridianPokecenterCurScript], a
	ld [wCurMapScript], a
	ret
.skip_check
	; Skip to noop script for normal gameplay
	ld a, SCRIPT_VIRIDIANPOKECENTER_NOOP
	ld [wViridianPokecenterCurScript], a
	ld [wCurMapScript], a
	ret

ViridianPokecenterJJBlackOutScript:
	; Wait a little
	ld c, 30
	call DelayFrames

	; Black out
	call GBFadeOutToBlack

	; Waiting a little
	ld c, 80 
	call DelayFrames

	; Show NPCs
	ld a, HS_VIRIDIAN_POKECENTER_JESSIE
	ld [wMissableObjectIndex], a
	predef ShowObject
	ld a, HS_VIRIDIAN_POKECENTER_JAMES
	ld [wMissableObjectIndex], a
	predef ShowObject
	ld a, HS_VIRIDIAN_POKECENTER_MEOWTH
	ld [wMissableObjectIndex], a
	predef ShowObject

	; Play ekans cry
	ld a, EKANS
	call PlayCry
	call WaitForSoundToFinish
	ld c, 10
	call DelayFrames

	; Play music
	ld c, BANK(Music_MeetJessieJames)
	ld a, MUSIC_MEET_JESSIE_JAMES
	call PlayMusic

	; Additional delay
	ld c, 10
	call DelayFrames

	; Fade in
	call GBFadeInFromBlack

	ld a, SCRIPT_VIRIDIANPOKECENTER_JJ_BUBBLE
	ld [wViridianPokecenterCurScript], a
	ld [wCurMapScript], a
	ret

ViridianPokecenterJJBubbleScript:
	; Delay
	ld c, 20
	call DelayFrames

	; Show question bubble on player
	ld a, 0
	ld [wEmotionBubbleSpriteIndex], a ; player's sprite
	ld a, QUESTION_BUBBLE
	ld [wWhichEmotionBubble], a
	predef EmotionBubble

	; Additional delay
	ld c, 30
	call DelayFrames

	ld a, SCRIPT_VIRIDIANPOKECENTER_JJ_SPEECH
	ld [wViridianPokecenterCurScript], a
	ld [wCurMapScript], a
	ret

ViridianPokecenterJJSpeechScript:
	; Enable player input
	xor a
	ld [wJoyIgnore], a

	; Start speech
	ld a, TEXT_VIRIDIANPOKECENTER_JJ_SPEECH
	ldh [hTextID], a
	call DisplayTextID

	ld a, TEXT_VIRIDIANPOKECENTER_JJ_JESSIE
	ldh [hTextID], a
	call DisplayTextID
	ret

ViridianPokecenterJJPostBattleScript:
	; Check if the player lost
	ld a, [wIsInBattle]	; If wIsInBattle is -1, then the battle was lost
	inc a	; If A holds -1, it will increment to 0 and set the z flag
	jr z, .skip	; Kick out if the player lost.

	; Print dialogue in case of victory
	ld a, TEXT_VIRIDIANPOKECENTER_JJ_DEFEATED
	ldh [hTextID], a
	call DisplayTextID

	; Animation to make J&J disapper
	call GBFadeOutToBlack
	ld c, 60
	call DelayFrames
	SetEvent EVENT_VIRIDIAN_BEAT_JJ
	ld a, HS_VIRIDIAN_POKECENTER_JESSIE
	ld [wMissableObjectIndex], a
	predef HideObject
	ld a, HS_VIRIDIAN_POKECENTER_JAMES
	ld [wMissableObjectIndex], a
	predef HideObject
	ld a, HS_VIRIDIAN_POKECENTER_MEOWTH
	ld [wMissableObjectIndex], a
	predef HideObject
	ld a, HS_VIRIDIAN_CITY_OLD_MAN_DRUNK
	ld [wMissableObjectIndex], a
	predef HideObject
	ld a, HS_VIRIDIAN_CITY_OLD_MAN
	ld [wMissableObjectIndex], a
	predef ShowObject

	; Enable rival at route 22
	SetEvents EVENT_ROUTE_22_RIVAL1_BATTLE, EVENT_ROUTE_22_RIVAL_WANTS_BATTLE
	ld a, HS_ROUTE_22_RIVAL
	ld [wMissableObjectIndex], a
	predef ShowObject

	; Change viridian city script
	ld a, SCRIPT_VIRIDIANCITY_GYM_CHECK
	ld [wViridianCityCurScript], a

	call UpdateSprites
	call Delay3
	call GBFadeInFromBlack
	; fallthrough
.skip
	ld a, SCRIPT_VIRIDIANPOKECENTER_NOOP
	ld [wViridianPokecenterCurScript], a
	ld [wCurMapScript], a
	ret

ViridianPokecenterNoopScript:
	ret

ViridianPokecenter_TextPointers:
	def_text_pointers
	dw_const ViridianPokecenterNurseText,            TEXT_VIRIDIANPOKECENTER_NURSE
	dw_const ViridianPokecenterGentlemanText,        TEXT_VIRIDIANPOKECENTER_GENTLEMAN
	dw_const ViridianPokecenterCooltrainerMText,     TEXT_VIRIDIANPOKECENTER_COOLTRAINER_M
	dw_const ViridianPokecenterLinkReceptionistText, TEXT_VIRIDIANPOKECENTER_LINK_RECEPTIONIST
	dw_const ViridianPokecenterChanseyText,          TEXT_VIRIDIANPOKECENTER_CHANSEY
	dw_const ViridianPokecenterJJBattleText,         TEXT_VIRIDIANPOKECENTER_JJ_JESSIE
	dw_const ViridianPokecenterJJBattleText,         TEXT_VIRIDIANPOKECENTER_JJ_JAMES
	dw_const ViridianPokecenterJJBattleText,         TEXT_VIRIDIANPOKECENTER_JJ_MEOWTH
	dw_const ViridianPokecenterJJSpeechText,         TEXT_VIRIDIANPOKECENTER_JJ_SPEECH
	dw_const ViridianPokecenterJJDefeatedText,       TEXT_VIRIDIANPOKECENTER_JJ_DEFEATED

ViridianPokecenterNurseText:
	script_pokecenter_nurse

ViridianPokecenterGentlemanText:
	text_far _ViridianPokecenterGentlemanText
	text_end

ViridianPokecenterCooltrainerMText:
	text_far _ViridianPokecenterCooltrainerMText
	text_end

ViridianPokecenterLinkReceptionistText:
	script_cable_club_receptionist

ViridianPokecenterChanseyText:
	text_asm
	callfar PokecenterChanseyText
	jp TextScriptEnd

ViridianPokecenterJJBattleText:
	text_asm

	; Start battle
	ld hl, wStatusFlags3
	set BIT_TALKED_TO_TRAINER, [hl]
	set BIT_PRINT_END_BATTLE_TEXT, [hl]
	call Delay3
	ld a, OPP_JESSIEJAMES
	ld [wCurOpponent], a
	ld a, 1
	ld [wTrainerNo], a

	; Change map script
	ld a, SCRIPT_VIRIDIANPOKECENTER_JJ_POST_BATTLE
	ld [wViridianPokecenterCurScript], a
	ld [wCurMapScript], a

	ld hl, ViridianPokecenterJJBattleLostText
	ld de, ViridianPokecenterJJBattleWonText
	call SaveEndBattleTextPointers

	ld hl, ViridianPokecenterJJStartBattleText
	call PrintText
	jp TextScriptEnd

ViridianPokecenterJJStartBattleText:
	text_far _ViridianPokecenterJJStartBattleText
	text_end

ViridianPokecenterJJBattleLostText:
	text_far _ViridianPokecenterJJBattleLostText
	text_end

ViridianPokecenterJJBattleWonText:
	text_far _JJBattleWonText
	text_end

ViridianPokecenterJJSpeechText:
	text_asm
    ld hl, ViridianPokecenterJJFearNotText
    call PrintText

	; Wait a little
	ld c, 20
	call DelayFrames

    callfar PrintJJSpeechText
    call Delay3

    callfar PrintJJMeowthText
    call Delay3

	jp TextScriptEnd

ViridianPokecenterJJFearNotText:
	text_far _ViridianPokecenterJJFearNotText
	text_end

ViridianPokecenterJJDefeatedText:
	text_far _ViridianPokecenterJJDefeatedText
	text_end