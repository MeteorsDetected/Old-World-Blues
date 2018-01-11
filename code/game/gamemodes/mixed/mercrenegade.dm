/datum/game_mode/mercren
	name = "Operatives & Renegades"
	round_description = "Syndicate forces have invaded the station, as well as other having brought their own form protection."
	extended_round_description = "Syndicate operatives and traitors spawn during this round."
	config_tag = "mercren"
	required_players = 16			//What could possibly go wrong?
	required_enemies = 8
	end_on_antag_death = 0
	antag_tags = list(ROLE_MERCENARY, ROLE_RENEGADE)
	require_all_templates = 1