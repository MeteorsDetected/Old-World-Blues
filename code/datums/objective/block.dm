/datum/objective/block
	explanation_text = "Do not allow any organic lifeforms to escape on the shuttle alive."


/datum/objective/block/check_completion()
	if(!issilicon(owner.current))
		return FALSE
	if(!emergency_shuttle.returned())
		return FALSE
	if(!owner.current)
		return FALSE

	var/area/shuttle = locate(/area/shuttle/escape/centcom)
	var/list/protected_types = list(/mob/living/silicon/ai, /mob/living/silicon/pai, /mob/living/silicon/robot)
	for(var/mob/living/player in player_list)
		if(is_type_in_list(player, protected_types))
			continue
		if(player.mind)
			if(player.stat != DEAD)
				if (get_turf(player) in shuttle)
					return FALSE
	return TRUE
