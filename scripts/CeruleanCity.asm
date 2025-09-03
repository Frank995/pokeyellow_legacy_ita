CeruleanCity_Script:
	call EnableAutoTextBoxDrawing
	ld hl, CeruleanCity_ScriptPointers
	ld a, [wCeruleanCityCurScript]
	jp CallFunctionInTable

CeruleanCity_ScriptPointers:
	def_script_pointers
	dw_const CeruleanCityDefaultScript,         SCRIPT_CERULEANCITY_DEFAULT
	dw_const CeruleanCityRivalWalkScript,       SCRIPT_CERULEANCITY_RIVAL_WALK
	dw_const CeruleanCityRivalBattleScript,     SCRIPT_CERULEANCITY_RIVAL_BATTLE
	dw_const CeruleanCityRivalPostBattleScript, SCRIPT_CERULEANCITY_RIVAL_POST_BATTLE
	dw_const CeruleanCityRivalCleanupScript,    SCRIPT_CERULEANCITY_RIVAL_CLEANUP
	dw_const CeruleanCityNoopScript,            SCRIPT_CERULEANCITY_NOOP

CeruleanCityDefaultScript:
IF DEF(_DEBUG)
	call DebugPressedOrHeldB
	ret nz
ENDC

	; Check if the player has already beaten rival
	CheckEvent EVENT_CERULEAN_BEAT_RIVAL
	jr nz, .skip_check

	; Check coordinates
	ld a, [wYCoord]
	cp 6 ; is player at north exit?
	ret nz

	; Stop player movement
	xor a
	ldh [hJoyHeld], a
	ld a, PAD_START | PAD_SELECT | PAD_CTRL_PAD
	ld [wJoyIgnore], a

	; Play music
	ld c, BANK(Music_MeetRival)
	ld a, MUSIC_MEET_RIVAL
	call PlayMusic

	ld a, SCRIPT_CERULEANCITY_RIVAL_WALK
	ld [wCeruleanCityCurScript], a
	ld [wCurMapScript], a
	ret

.skip_check
	; Skip to noop script for normal gameplay
	ld a, SCRIPT_CERULEANCITY_NOOP
	ld [wCeruleanCityCurScript], a
	ld [wCurMapScript], a
	ret

CeruleanCityRivalMovement1:
	db NPC_MOVEMENT_DOWN
	db NPC_MOVEMENT_DOWN
	db NPC_MOVEMENT_DOWN
	db NPC_MOVEMENT_DOWN
	db -1 ; end

CeruleanCityRivalWalkScript:
	; Show rival sprite
	ld a, HS_CERULEAN_CITY_RIVAL
	ld [wMissableObjectIndex], a
	predef ShowObject

	; Is the player standing on the right side of the bridge?
	ld a, [wXCoord]
	cp 20
	jr z, .playerOnRightSideOfBridge

	; Shift the rival if on the wrong side
	ld a, CERULEANCITY_RIVAL
	ldh [hSpriteIndex], a
	ld a, SPRITESTATEDATA2_MAPX
	ldh [hSpriteDataOffset], a
	call GetPointerWithinSpriteStateData2
	ld [hl], 25
.playerOnRightSideOfBridge
	; Move rival
	ld de, CeruleanCityRivalMovement1
	ld a, CERULEANCITY_RIVAL
	ldh [hSpriteIndex], a
	call MoveSprite

	ld a, SCRIPT_CERULEANCITY_RIVAL_BATTLE
	ld [wCeruleanCityCurScript], a
	ld [wCurMapScript], a
	ret

CeruleanCityRivalBattleScript:
	; Wait for movement to finish
	ld a, [wStatusFlags5]
	bit BIT_SCRIPTED_NPC_MOVEMENT, a
	ret nz

	; Enable input
	xor a
	ld [wJoyIgnore], a

	; Load text
	ld a, TEXT_CERULEANCITY_RIVAL
	ldh [hTextID], a
	call DisplayTextID
	ret

CeruleanCityRivalPostBattleScript:
	; If the player lost, reset event
	ld a, [wIsInBattle]
	inc a
	jr z, .skip

	; Make sure he's turned toward the player
	ld a, CERULEANCITY_RIVAL
	ldh [hSpriteIndex], a
	ld a, SPRITE_FACING_DOWN
	ldh [hSpriteFacingDirection], a
	call SetSpriteFacingDirectionAndDelay

	; Display victory text
	ld a, TEXT_CERULEANCITY_RIVAL_BILL
	ldh [hTextID], a
	call DisplayTextID
	call Delay3

	; Stop player input
	ld a, PAD_START | PAD_SELECT | PAD_CTRL_PAD
	ld [wJoyIgnore], a

	; Move rival
	SetEvent EVENT_CERULEAN_BEAT_RIVAL
	call StopAllMusic
	farcall Music_RivalAlternateStart
	ld a, CERULEANCITY_RIVAL
	ldh [hSpriteIndex], a
	call SetSpriteMovementBytesToFF
	ld a, [wXCoord]
	cp 20 ; is the player standing on the right side of the bridge?
	jr nz, .playerOnRightSideOfBridge
	ld de, CeruleanCityRivalMovement3
	jr .cleanup
.playerOnRightSideOfBridge
	ld de, CeruleanCityRivalMovement2
.cleanup
	ld a, CERULEANCITY_RIVAL
	ldh [hSpriteIndex], a
	call MoveSprite

	ld a, SCRIPT_CERULEANCITY_RIVAL_CLEANUP
	ld [wCeruleanCityCurScript], a
	ld [wCurMapScript], a
	ret
.skip
	xor a ; SCRIPT_CERULEANCITY_DEFAULT
	ld [wJoyIgnore], a
	ld [wCeruleanCityCurScript], a
	ld [wCurMapScript], a
	ret

CeruleanCityRivalMovement2:
	db NPC_MOVEMENT_LEFT
	db NPC_MOVEMENT_DOWN
	db NPC_MOVEMENT_DOWN
	db NPC_MOVEMENT_DOWN
	db NPC_MOVEMENT_DOWN
	db NPC_MOVEMENT_DOWN
	db NPC_MOVEMENT_DOWN
	db -1 ; end

CeruleanCityRivalMovement3:
	db NPC_MOVEMENT_RIGHT
	db NPC_MOVEMENT_DOWN
	db NPC_MOVEMENT_DOWN
	db NPC_MOVEMENT_DOWN
	db NPC_MOVEMENT_DOWN
	db NPC_MOVEMENT_DOWN
	db NPC_MOVEMENT_DOWN
	db -1 ; end

CeruleanCityRivalCleanupScript:
	; Wait for rival to finish movement
	ld a, [wStatusFlags5]
	bit BIT_SCRIPTED_NPC_MOVEMENT, a
	ret nz

	; Hide rival
	ld a, HS_CERULEAN_CITY_RIVAL
	ld [wMissableObjectIndex], a
	predef HideObject

	; Enable input
	xor a
	ld [wJoyIgnore], a

	; Default music
	call DelayFrame
	call PlayDefaultMusic

	ld a, SCRIPT_CERULEANCITY_NOOP
	ld [wCeruleanCityCurScript], a
	ld [wCurMapScript], a
	ret

CeruleanCityNoopScript:
	ret

CeruleanCity_TextPointers:
	def_text_pointers
	dw_const CeruleanCityRivalBattleText,     TEXT_CERULEANCITY_RIVAL
	dw_const CeruleanCityCooltrainerMText,    TEXT_CERULEANCITY_COOLTRAINER_M
	dw_const CeruleanCitySuperNerd1Text,      TEXT_CERULEANCITY_SUPER_NERD1
	dw_const CeruleanCitySuperNerd2Text,      TEXT_CERULEANCITY_SUPER_NERD2
	dw_const CeruleanCityJennyText,           TEXT_CERULEANCITY_JENNY
	dw_const CeruleanCityCooltrainerF1Text,   TEXT_CERULEANCITY_COOLTRAINER_F1
	dw_const CeruleanCityElectrodeText,       TEXT_CERULEANCITY_ELECTRODE
	dw_const CeruleanCityCooltrainerF2Text,   TEXT_CERULEANCITY_COOLTRAINER_F2
	dw_const CeruleanCitySuperNerd3Text,      TEXT_CERULEANCITY_SUPER_NERD3
	dw_const CeruleanCitySignText,            TEXT_CERULEANCITY_SIGN
	dw_const CeruleanCityTrainerTipsText,     TEXT_CERULEANCITY_TRAINER_TIPS
	dw_const MartSignText,                    TEXT_CERULEANCITY_MART_SIGN
	dw_const PokeCenterSignText,              TEXT_CERULEANCITY_POKECENTER_SIGN
	dw_const CeruleanCityBikeShopSign,        TEXT_CERULEANCITY_BIKESHOP_SIGN
	dw_const CeruleanCityGymSign,             TEXT_CERULEANCITY_GYM_SIGN
	dw_const CeruleanCityRivalBillText, TEXT_CERULEANCITY_RIVAL_BILL

CeruleanCityRivalBattleText:
	text_asm

	; Start battle
	ld hl, wStatusFlags3
	set BIT_TALKED_TO_TRAINER, [hl]
	set BIT_PRINT_END_BATTLE_TEXT, [hl]
	call Delay3
	ld a, OPP_RIVAL1
	ld [wCurOpponent], a
	ld a, 3
	ld [wTrainerNo], a

	; Change map script
	ld a, SCRIPT_CERULEANCITY_RIVAL_POST_BATTLE
	ld [wCeruleanCityCurScript], a
	ld [wCurMapScript], a

	ld hl, CeruleanCityRivalBattleLostText
	ld de, CeruleanCityRivalBattleWonText
	call SaveEndBattleTextPointers

	ld hl, CeruleanCityRivalStartBattleText
	call PrintText
	jp TextScriptEnd

CeruleanCityRivalStartBattleText:
	text_far _CeruleanCityRivalStartBattleText
	text_end

CeruleanCityRivalBattleLostText:
	text_far _CeruleanCityRivalBattleLostText
	text_end

CeruleanCityRivalBattleWonText:
	text_far _CeruleanCityRivalBattleWonText
	text_end

CeruleanCityRivalBillText:
	text_far _CeruleanCityRivalWentToBillText
	text_end

CeruleanCityCooltrainerMText:
	text_far _CeruleanCityCooltrainerMText
	text_end

CeruleanCitySuperNerd1Text:
	text_far _CeruleanCitySuperNerd1Text
	text_end

CeruleanCitySuperNerd2Text:
	text_far _CeruleanCitySuperNerd2Text
	text_end

CeruleanCityJennyText:
	text_far _CeruleanCityJennyText
	text_end

CeruleanCityCooltrainerF1Text:
	text_far _CeruleanCityCooltrainerF1Text
	text_end

CeruleanCityElectrodeText:
	text_asm
	ld hl, CeruleanCityPrintElectrodeText
	call PrintText
	ld a, ELECTRODE
	call PlayCry
	call WaitForSoundToFinish
	jp TextScriptEnd

CeruleanCityPrintElectrodeText:
	text_far _CeruleanCityElectrodeText
	text_end

CeruleanCityCooltrainerF2Text:
	text_far _CeruleanCityCooltrainerF2Text
	text_end

CeruleanCitySuperNerd3Text:
	text_far _CeruleanCitySuperNerd3Text
	text_end

CeruleanCitySignText:
	text_far _CeruleanCitySignText
	text_end

CeruleanCityTrainerTipsText:
	text_far _CeruleanCityTrainerTipsText
	text_end

CeruleanCityBikeShopSign:
	text_far _CeruleanCityBikeShopSign
	text_end

CeruleanCityGymSign:
	text_far _CeruleanCityGymSign
	text_end
