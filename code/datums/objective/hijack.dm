/datum/objective/hijack
	explanation_text = "Hijack the emergency shuttle by escaping alone."

/datum/objective/hijack/check_completion()
	if(!owner.current || owner.current.stat)
		return FALSE
	if(!emergency_shuttle.returned())
		return FALSE
	if(issilicon(owner.current))
		return FALSE
	var/area/shuttle = locate(/area/shuttle/escape/centcom)
	var/list/protected_types = list(/mob/living/silicon/ai, /mob/living/silicon/pai)
	for(var/mob/living/player in player_list)
		if(is_type_in_list(player, protected_types))
			continue
		if (player.mind && (player.mind != owner))
			if(player.stat != DEAD)			//they're not dead!
				if(get_turf(player) in shuttle)
					return FALSE
	return TRUE
