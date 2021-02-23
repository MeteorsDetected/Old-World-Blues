/turf/simulated/floor/proc/update_icon()
	if(flooring)
		// Set initial icon and strings.
		name = flooring.name
		desc = flooring.desc
		icon = flooring.icon

		//Actually icon
		icon_state = flooring.icon_base

		// Apply edges, corners, and inner corners.
		overlays.Cut()

	if(decals && decals.len)
		for(var/image/I in decals)
			overlays |= I

/*
	//Damage overlay - TODO
	if(is_plating() && !(isnull(broken) && isnull(burnt))) //temp, todo
		icon = 'icons/turf/flooring/plating.dmi'
		icon_state = "dmg[rand(1,4)]"
	else if(flooring)
		if(!isnull(broken) && (flooring.flags & TURF_CAN_BREAK))
			overlays |= get_damage_overlay("broken[broken]", BLEND_MULTIPLY)
		if(!isnull(burnt) && (flooring.flags & TURF_CAN_BURN))
			overlays |= get_damage_overlay("burned[burnt]")
broken
*/
