/datum/objective/escape
	explanation_text = "Escape on the shuttle or an escape pod alive and free."


/datum/objective/escape/check_completion()
	if(issilicon(owner.current))
		return FALSE
	if(isbrain(owner.current))
		return FALSE
	if(!emergency_shuttle.returned())
		return FALSE
	if(!owner.current || owner.current.stat == DEAD)
		return FALSE
	var/turf/location = get_turf(owner.current.loc)
	if(!location)
		return FALSE

	// Fails traitors if they are in the shuttle brig -- Polymorph
	if(istype(location, /turf/simulated/shuttle/floor4))
		if(iscarbon(owner.current))
			var/mob/living/carbon/C = owner.current
			if(C.handcuffed)
				return FALSE

	var/area/check_area = get_area(owner.current)
	return check_area.is_escape_location


