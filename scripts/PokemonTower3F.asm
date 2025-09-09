PokemonTower3F_Script:
	call EnableAutoTextBoxDrawing
	ld hl, PokemonTower3FTrainerHeaders
	ld de, PokemonTower3F_ScriptPointers
	ld a, [wPokemonTower3FCurScript]
	call ExecuteCurMapScriptInTable
	ld [wPokemonTower3FCurScript], a
	ret

PokemonTower3F_ScriptPointers:
	def_script_pointers
	dw_const CheckFightingMapTrainers,              SCRIPT_POKEMONTOWER3F_DEFAULT
	dw_const DisplayEnemyTrainerTextAndStartBattle, SCRIPT_POKEMONTOWER3F_START_BATTLE
	dw_const EndTrainerBattle,                      SCRIPT_POKEMONTOWER3F_END_BATTLE

PokemonTower3F_TextPointers:
	def_text_pointers
	dw_const PokemonTower3FChanneler1Text, TEXT_POKEMONTOWER3F_CHANNELER1
	dw_const PokemonTower3FChanneler2Text, TEXT_POKEMONTOWER3F_CHANNELER2
	dw_const PokemonTower3FChanneler3Text, TEXT_POKEMONTOWER3F_CHANNELER3
	dw_const PickUpItemText,               TEXT_POKEMONTOWER3F_ESCAPE_ROPE

PokemonTower3FTrainerHeaders:
	def_trainers
PokemonTower3FTrainerHeader0:
	trainer EVENT_POKEMONTOWER_3F_BEAT_TRAINER_0, 2, PokemonTower3FChanneler1BattleText, PokemonTower3FChanneler1EndBattleText, PokemonTower3FChanneler1AfterBattleText
PokemonTower3FTrainerHeader1:
	trainer EVENT_POKEMONTOWER_3F_BEAT_TRAINER_1, 3, PokemonTower3FChanneler2BattleText, PokemonTower3FChanneler2EndBattleText, PokemonTower3FChanneler2AfterBattleText
PokemonTower3FTrainerHeader2:
	trainer EVENT_POKEMONTOWER_3F_BEAT_TRAINER_2, 2, PokemonTower3FChanneler3BattleText, PokemonTower3FChanneler3EndBattleText, PokemonTower3FChanneler3AfterBattleText
	db -1 ; end

PokemonTower3FChanneler1Text:
	text_asm
	ld hl, PokemonTower3FTrainerHeader0
	call TalkToTrainer
	jp TextScriptEnd

PokemonTower3FChanneler2Text:
	text_asm
	ld hl, PokemonTower3FTrainerHeader1
	call TalkToTrainer
	jp TextScriptEnd

PokemonTower3FChanneler3Text:
	text_asm
	ld hl, PokemonTower3FTrainerHeader2
	call TalkToTrainer
	jp TextScriptEnd

PokemonTower3FChanneler1BattleText:
	text_far _PokemonTower3FChanneler1BattleText
	text_end

PokemonTower3FChanneler1EndBattleText:
	text_far _PokemonTower3FChanneler1EndBattleText
	text_end

PokemonTower3FChanneler1AfterBattleText:
	text_far _PokemonTower3FChanneler1AfterBattleText
	text_end

PokemonTower3FChanneler2BattleText:
	text_far _PokemonTower3FChanneler2BattleText
	text_end

PokemonTower3FChanneler2EndBattleText:
	text_far _PokemonTower3FChanneler2EndBattleText
	text_end

PokemonTower3FChanneler2AfterBattleText:
	text_far _PokemonTower3FChanneler2AfterBattleText
	text_end

PokemonTower3FChanneler3BattleText:
	text_far _PokemonTower3FChanneler3BattleText
	text_end

PokemonTower3FChanneler3EndBattleText:
	text_far _PokemonTower3FChanneler3EndBattleText
	text_end

PokemonTower3FChanneler3AfterBattleText:
	text_far _PokemonTower3FChanneler3AfterBattleText
	text_end
