/turf
	var/list/affecting_lights
	var/atom/movable/lighting_overlay/lighting_overlay

/turf/proc/reconsider_lights()
	for(var/datum/light_source/L in affecting_lights)
		L.vis_update()

/turf/proc/lighting_clear_overlays()
	if(lighting_overlay)
		qdel(lighting_overlay)

/turf/proc/lighting_build_overlays()
	if(!lighting_overlay)
		var/area/A = loc
		if(A.lighting_use_dynamic)
			var/atom/movable/lighting_overlay/O = PoolOrNew(/atom/movable/lighting_overlay, src)
			lighting_overlay = O

	//Make the light sources recalculate us so the lighting overlay updates immediately
	for(var/datum/light_source/L in affecting_lights)
		L.calc_turf(src)

/turf/Entered(atom/movable/obj)
	. = ..()
	if(obj && obj.opacity)
		reconsider_lights()

/turf/Exited(atom/movable/obj)
	. = ..()
	if(obj && obj.opacity)
		reconsider_lights()

// Used to get a scaled lumcount.
/turf/proc/get_lumcount(var/minlum = 0, var/maxlum = 1)
	if(!lighting_overlay)
		return 0.5