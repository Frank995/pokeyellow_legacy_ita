Route1_Script:
	call EnableAutoTextBoxDrawing
	ld hl, Route1_ScriptPointers
	ld a, [wRoute1CurScript]
	jp CallFunctionInTable

Route1_ScriptPointers:
	def_script_pointers
	dw_const Route1NoopScript,          SCRIPT_ROUTE1_NOOP
	dw_const Route1PostOakBattleScript, SCRIPT_ROUTE1_POST_OAK_BATTLE

Route1NoopScript:
	ret

Route1PostOakBattleScript:
	; There is no check to see if the player actually lost.
	; Let's go ahead and add that
	ld a, [wIsInBattle]	; If wIsInBattle is -1, then the battle was lost
	inc a	; If A holds -1, it will increment to 0 and set the z flag (but not the c flag, dec and inc cannot affect it).
	jr z, .skip	; Kick out if the player lost.

	; Print dialogue in case of victory
	ld a, TEXT_ROUTE1_POST_OAK_BATTLE
	ldh [hTextID], a
	call DisplayTextID

	; Animation to make oak disappear
	call GBFadeOutToBlack
	SetEvent EVENT_BEAT_OAK
	ld a, HS_OAKS_LAB_OAK
	ld [wMissableObjectIndex], a
	predef ShowObject
	ld a, HS_ROUTE_1_OAK
	ld [wMissableObjectIndex], a
	predef HideObject
	call UpdateSprites
	call Delay3
	call GBFadeInFromBlack
.skip
	ld a, 0
	ld [wRoute1CurScript], a
	ld [wCurMapScript], a
	ret

Route1_TextPointers:
	def_text_pointers
	dw_const Route1Youngster1Text,    TEXT_ROUTE1_YOUNGSTER1
	dw_const Route1Youngster2Text,    TEXT_ROUTE1_YOUNGSTER2
	dw_const Route1OakText,		      TEXT_ROUTE1_OAK
	dw_const Route1SignText,          TEXT_ROUTE1_SIGN
	dw_const Route1PostOakBattleText, TEXT_ROUTE1_POST_OAK_BATTLE

Route1Youngster1Text:
	text_asm
	farcall Route1PrintYoungster1Text
	jp TextScriptEnd

Route1Youngster2Text:
	text_far _Route1Youngster2Text
	text_end

Route1SignText:
	text_far _Route1SignText
	text_end

Route1OakText:
	text_asm
	ld hl, Route1OakBeforeBattleText
	call PrintText

	; Asks if willing to fight
	call YesNoChoice
	ld a, [wCurrentMenuItem]
	and a
	jr nz, .refused
	
	; Start battle
	ld c, BANK(Music_MeetMaleTrainer)
	ld a, MUSIC_MEET_MALE_TRAINER
	call PlayMusic
	ld hl, wStatusFlags3
	set BIT_TALKED_TO_TRAINER, [hl]
	set BIT_PRINT_END_BATTLE_TEXT, [hl]
	call Delay3
	ld a, OPP_PROF_OAK
	ld [wCurOpponent], a
	ld a, $1
	ld [wTrainerNo], a
	ld a, $1
	ld [wRoute1CurScript], a ; change map script
	ld [wCurMapScript], a
	ld hl, Route1OakBattleLostText
	ld de, Route1OakBattleWonText
	call SaveEndBattleTextPointers
	ld hl, Route1OakRealChallengeBattleText
	call PrintText
	jp .done
.refused
	ld hl, Route1OakRefusedBattleText
	call PrintText
.done
	jp TextScriptEnd

Route1OakBeforeBattleText:
	text_far _Route1OakBeforeBattleText
	text_end

Route1OakRealChallengeBattleText:
	text_far _Route1OakRealChallengeBattleText
	text_end

Route1OakBattleLostText:
	text_far _Route1OakBattleLostText
	text_end

Route1OakBattleWonText:
	text_far _Route1OakBattleWonText
	text_end

Route1OakRefusedBattleText:
	text_far _Route1OakRefusedBattleText
	text_end

Route1PostOakBattleText:
	text_far _Route1PostOakBattleText
	text_end
