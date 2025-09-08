SSAnneCaptainsRoom_Script:
	call EnableAutoTextBoxDrawing
	ld hl, SSAnneCaptainsRoom_ScriptPointers
	ld a, [wSSAnneCaptainsRoomCurScript]
	jp CallFunctionInTable

SSAnneCaptainsRoom_ScriptPointers:
	def_script_pointers
	dw_const SSAnneCaptainsRoomNoopScript,         SCRIPT_SSANNECAPTAINSROOM_NOOP
	dw_const SSAnneCaptainsRoomJJPostBattleScript, SCRIPT_SSANNECAPTAINSROOM_JJ_POST_BATTLE

SSAnneCaptainsRoomNoopScript:
	ret

SSAnneCaptainsRoomJJPostBattleScript:
	; Check battle result
	ld a, [wIsInBattle]
	inc a
	jr z, .skip

	; Hide Jessie and James sprites
	call GBFadeOutToBlack
	ld c, 60
	call DelayFrames
	SetEvent EVENT_SS_ANNE_BEAT_JJ
	ld a, HS_SS_ANNE_CAPTAINS_ROOM_JESSIE
	ld [wMissableObjectIndex], a
	predef HideObject
	ld a, HS_SS_ANNE_CAPTAINS_ROOM_JAMES
	ld [wMissableObjectIndex], a
	predef HideObject
	ld a, HS_SS_ANNE_3F_SAILOR
	ld [wMissableObjectIndex], a
	predef ShowObject
	call UpdateSprites
	call Delay3
	call GBFadeInFromBlack
	call PlayDefaultMusic

	; Display victory text
	ld a, TEXT_SSANNECAPTAINSROOM_POST_BATTLE
	ldh [hTextID], a
	call DisplayTextID
.skip
	xor a
	ld [wSSAnneCaptainsRoomCurScript], a
	ld [wCurMapScript], a
	ret

SSAnneCaptainsRoom_TextPointers:
	def_text_pointers
	dw_const SSAnneCaptainsRoomCaptainText,  TEXT_SSANNECAPTAINSROOM_CAPTAIN
	dw_const SSAnneCaptainsRoomJJBattleText, TEXT_SSANNECAPTAINSROOM_JESSIE
	dw_const SSAnneCaptainsRoomJJBattleText, TEXT_SSANNECAPTAINSROOM_JAMES
	dw_const SSAnneCaptainsRoomCaptainText,  TEXT_SSANNECAPTAINSROOM_POST_BATTLE

SSAnneCaptainsRoomCaptainText:
	text_asm

	CheckEvent EVENT_SS_ANNE_GOT_HM01
	jr nz, .got_hm

	CheckEvent EVENT_SS_ANNE_BEAT_JJ
	jr nz, .give_item

	ld hl, SSAnneCaptainsRoomCaptainAboutToSailText
	jr .done
.give_item
	ld hl, SSAnneCaptainsRoomCaptainThankYouText
	call PrintText
	lb bc, HM_CUT, 1
	call GiveItem
	jr nc, .bag_full

	SetEvent EVENT_SS_ANNE_GOT_HM01
	ld hl, SSAnneCaptainsRoomCaptainReceivedHM01Text
	call PrintText
	jp TextScriptEnd
.bag_full
	ld hl, SSAnneCaptainsRoomCaptainHM01NoRoomText
	jr .done
.got_hm
	ld hl, SSAnneCaptainsRoomCaptainItsOverText
.done
	call PrintText
	jp TextScriptEnd

SSAnneCaptainsRoomCaptainItsOverText:
	text_far _SSAnneCaptainsRoomCaptainItsOverText
	text_end

SSAnneCaptainsRoomCaptainAboutToSailText:
	text_far _SSAnneCaptainsRoomCaptainAboutToSailText
	text_end

SSAnneCaptainsRoomCaptainThankYouText:
	text_far _SSAnneCaptainsRoomCaptainThankYouText
	text_end

SSAnneCaptainsRoomCaptainReceivedHM01Text:
	text_far _SSAnneCaptainsRoomCaptainReceivedHM01Text
	sound_get_key_item
	text_end

SSAnneCaptainsRoomCaptainHM01NoRoomText:
	text_far _SSAnneCaptainsRoomCaptainHM01NoRoomText
	text_end

SSAnneCaptainsRoomJJBattleText:
	text_asm

	; Start battle
	ld hl, wStatusFlags3
	set BIT_TALKED_TO_TRAINER, [hl]
	set BIT_PRINT_END_BATTLE_TEXT, [hl]
	call Delay3
	ld a, OPP_JESSIEJAMES
	ld [wCurOpponent], a
	ld a, 5
	ld [wTrainerNo], a

	; Change map script
	ld a, SCRIPT_SSANNECAPTAINSROOM_JJ_POST_BATTLE
	ld [wSSAnneCaptainsRoomCurScript], a
	ld [wCurMapScript], a

	ld hl, SSAnneCaptainsRoomJJBattleLostText
	ld de, SSAnneCaptainsRoomJJBattleWonText
	call SaveEndBattleTextPointers

	callfar PrintJJSpeechText
	call Delay3

	callfar PrintJJMeowthText
	call Delay3

	ld hl, SSAnneCaptainsRoomJJStartBattleText
	call PrintText

	jp TextScriptEnd

SSAnneCaptainsRoomJJBattleLostText:
	text_far _SSAnneCaptainsRoomJJBattleLostText
	text_end

SSAnneCaptainsRoomJJBattleWonText:
	text_far _JJBattleWonText
	text_end

SSAnneCaptainsRoomJJStartBattleText:
	text_far _SSAnneCaptainsRoomJJStartBattleText
	text_end
