TrainerAIPointers:
	table_width 3
	; one entry per trainer class
	; first byte, number of times (per Pokémon) it can occur
	; next two bytes, pointer to AI subroutine for trainer class
	; subroutines are defined in engine/battle/trainer_ai.asm
	dbw 1, GenericAI ; YOUNGSTER
	dbw 1, GenericAI ; BUG_CATCHER
	dbw 1, GenericAI ; LASS
	dbw 1, GenericAI ; SAILOR
	dbw 1, GenericAI ; JR_TRAINER_M
	dbw 1, GenericAI ; JR_TRAINER_F
	dbw 1, GenericAI ; POKEMANIAC
	dbw 1, GenericAI ; SUPER_NERD
	dbw 1, GenericAI ; HIKER
	dbw 1, GenericAI ; BIKER
	dbw 1, GenericAI ; BURGLAR
	dbw 1, GenericAI ; ENGINEER
	dbw 1, GenericAI ; SAMURAI
	dbw 1, GenericAI ; FISHER
	dbw 1, GenericAI ; SWIMMER
	dbw 1, GenericAI ; CUE_BALL
	dbw 1, GenericAI ; GAMBLER
	dbw 1, GenericAI ; BEAUTY
	dbw 1, GenericAI ; PSYCHIC_TR
	dbw 1, GenericAI ; ROCKER
	dbw 1, GenericAI ; JUGGLER
	dbw 1, GenericAI ; TAMER
	dbw 1, GenericAI ; BIRD_KEEPER
	dbw 1, BlackbeltAI ; BLACKBELT
	dbw 1, GenericAI ; RIVAL1
	dbw 1, ProfOakAI ; PROF_OAK
	dbw 1, GenericAI ; JESSIE_JAMES
	dbw 1, GenericAI ; SCIENTIST
	dbw 1, GiovanniAI ; GIOVANNI
	dbw 1, GenericAI ; ROCKET
	dbw 1, CooltrainerAI ; COOLTRAINER_M
	dbw 1, CooltrainerAI ; COOLTRAINER_F
	dbw 1, BrunoAI ; BRUNO
	dbw 1, BrockAI ; BROCK
	dbw 1, MistyAI ; MISTY
	dbw 1, LtSurgeAI ; LT_SURGE
	dbw 1, ErikaAI ; ERIKA
	dbw 1, KogaAI ; KOGA
	dbw 1, BlaineAI ; BLAINE
	dbw 1, SabrinaAI ; SABRINA
	dbw 1, GenericAI ; GENTLEMAN
	dbw 1, Rival2AI ; RIVAL2
	dbw 1, Rival3AI ; RIVAL3
	dbw 1, LoreleiAI ; LORELEI
	dbw 1, GenericAI ; CHANNELER
	dbw 1, AgathaAI ; AGATHA
	dbw 1, LanceAI ; LANCE
	dbw 1, GenericAI ; JANINE
	assert_table_length NUM_TRAINERS
