/datum/game_mode/mercwiz
	name = "Operatives & Wizard"
	round_description = "Syndicate forces team and a wizard have invaded the station!"
	extended_round_description = "Syndicate operatives and wizard spawn during this round."
	config_tag = "mercwiz"
	required_players = 15			//I don't think we can have it lower and not need an ERT every round.
	required_enemies = 7
	end_on_antag_death = 0
	antag_tags = list(ROLE_MERCENARY, ROLE_WIZARD)
	require_all_templates = 1