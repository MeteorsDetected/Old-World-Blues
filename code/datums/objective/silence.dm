/datum/objective/silence
	explanation_text = "Do not allow anyone to escape the station. Only allow the shuttle to be called when everyone is dead and your story is the only one left."

/datum/objective/silence/check_completion()
	if(!emergency_shuttle.returned())
		return FALSE

	var/area/checking = null
	for(var/mob/living/player in player_list)
		if(player == owner.current || !player.mind || player.stat == DEAD)
			continue
		checking = get_area(player)
		if(checking.is_escape_location)
			return FALSE
	return TRUE

