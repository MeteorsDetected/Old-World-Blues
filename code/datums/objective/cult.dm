/datum/objective/cult/survive
	explanation_text = "Our knowledge must live on."
	target_amount = 5

/datum/objective/cult/survive/find_target()
	target_amount = rand(4, 6)
	update_explanation()

/datum/objective/cult/survive/update_explanation()
	explanation_text = "Our knowledge must live on. Make sure at least [target_amount] acolytes escape on the shuttle to spread their work on an another station."

/datum/objective/cult/survive/get_panel_entry()
	return "<a href='?src=\ref[src];set_amount=Requed acolytes'>[target_amount]</a> acolytes must escape."

/datum/objective/cult/survive/check_completion()
	var/acolytes_survived = 0
	if(!cult)
		return FALSE

	for(var/datum/mind/cult_mind in cult.current_antagonists)
		if(cult_mind.current && cult_mind.current.stat != DEAD)
			var/area/check_area = get_area(cult_mind.current)
			if(check_area.is_escape_location)
				acolytes_survived++

	return (acolytes_survived >= target_amount)


/datum/objective/cult/eldergod
	explanation_text = "Summon Nar-Sie via the use of the appropriate rune (Hell join self). It will only work if nine cultists stand on and around it. The convert rune is join blood self."

/datum/objective/cult/eldergod/check_completion()
	return (locate(/obj/singularity/narsie/large) in machines)


/datum/objective/cult/sacrifice
	explanation_text = "Conduct a ritual sacrifice for the glory of Nar-Sie."

/datum/objective/cult/sacrifice/find_target()
	var/list/possible_targets = list()
	for(var/mob/living/carbon/human/player in player_list)
		if(player.mind && !(player.mind in cult))
			possible_targets += player.mind
	if(possible_targets.len > 0)
		target = pick(possible_targets)
	update_explanation()

/datum/objective/cult/sacrifice/update_explanation()
	if(target)
		explanation_text = "Sacrifice [target.name], the [target.assigned_role]. You will need the sacrifice rune (Hell blood join) and three acolytes to do so."
	else
		explanation_text = "Conduct a ritual sacrifice for the glory of Nar-Sie."

/datum/objective/cult/sacrifice/check_completion()
	return (!target || cult && cult.sacrificed.Find(target))

