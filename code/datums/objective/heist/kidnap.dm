/datum/objective/heist/kidnap

/datum/objective/heist/kidnap/find_target()
	var/list/roles = list("Chief Engineer","Research Director","Roboticist","Chemist","Station Engineer")
	var/list/possible_targets = list()
	var/list/priority_targets = list()

	for(var/datum/mind/target in ticker.minds)
		if(target != owner && ishuman(target.current) && (target.current.stat != DEAD) && (!target.special_role))
			possible_targets += target
			if(target.assigned_role in roles)
				priority_targets += target

	if(priority_targets.len > 0)
		target = pick(priority_targets)
	else if(possible_targets.len > 0)
		target = pick(possible_targets)

	update_explanation()


/datum/objective/heist/kidnap/update_explanation()
	if(target && target.current)
		explanation_text = "We can get a good price for [target.current.real_name], the [target.assigned_role]. Take them alive."
	else
		explanation_text = "Target has not arrived today. Is it a coincidence?"

/datum/objective/heist/kidnap/check_completion()
	if(!target)//If it's a free objective.
		return TRUE

	if(target.current)
		if (target.current.stat == DEAD)
			return FALSE // They're dead. Fail.
		//if (!target.current.restrained())
		//	return 0 // They're loose. Close but no cigar.

		var/area/skipjack_station/start/A = locate()
		return get_turf(target.current) in A
	else
		return FALSE