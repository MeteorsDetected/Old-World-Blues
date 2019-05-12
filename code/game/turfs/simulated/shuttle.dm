/turf/simulated/shuttle
	name = "shuttle"
	icon = 'icons/turf/shuttle.dmi'
	thermal_conductivity = 0.05
	heat_capacity = 0
	layer = 2

/turf/simulated/shuttle/wall
	name = "wall"
	icon_state = "wall"
	opacity = 1
	density = 1
	blocks_air = 1

/turf/simulated/shuttle/wall/New()
	..()
	spawn(1)
		update_icon()

/turf/simulated/shuttle/wall/orange
	color = "#FF6633"

/turf/simulated/shuttle/wall/proc/update_icon()
	var/neighbors = 0
	for(var/dir in cardinal)
		var/turf/T = get_step(src, dir)
		if(istype(T, /turf/simulated/shuttle/wall))
			neighbors |= dir
		else if(locate(/obj/structure/window/shuttle) in T)
			neighbors |= dir
		else if(locate(/obj/shuttle/corner) in T)
			neighbors |= dir

	//No neighbors
	if(!neighbors)
		icon_state = initial(icon_state)
	//Neighbors allside
	else if(neighbors == (NORTH|SOUTH|EAST|WEST))
		icon_state = "[initial(icon_state)]_full"
	//One or two adjacent neighbors
	else if(neighbors in alldirs)
		icon_state = "[initial(icon_state)]_edge"
		dir = neighbors
	//Two opposite neighbors
	else if(neighbors in list(NORTH|SOUTH, EAST|WEST))
		dir = neighbors & (NORTH|EAST)
		icon_state = "[initial(icon_state)]_line"
	//Three neighbors
	else
		icon_state = "[initial(icon_state)]_trine"
		dir = (NORTH|SOUTH|EAST|WEST) - neighbors

/turf/simulated/shuttle/wall/gray
	icon_state = "wall_gray"

/turf/simulated/shuttle/wall/gray/update_icon()
	return

/obj/shuttle/corner
	icon = 'icons/turf/shuttle.dmi'
	icon_state = "corner"
	name = "wall"
	anchored = TRUE

/obj/shuttle/corner/New()
	var/turf/loc = src.loc
	loc.dynamic_lighting = TRUE
	..()

/obj/shuttle/corner/initialize()
	. = ..()
	var/dir = 0
	var/count = 0
	for(var/i in cardinal)
		var/turf/T = get_step(src, i)
		if(istype(T, /turf/simulated/shuttle/wall) || locate(/obj/structure/window/shuttle) in T)
			dir |= i
			count ++

	if(count != 2)
		log_world("ERROR: Shuttle coner ([x],[y],[z]) has [count] neigbors. Must have only 2.")
		new /turf/simulated/shuttle/wall(loc)
		return INITIALIZE_HINT_QDEL
	else
		src.dir = dir



/turf/simulated/shuttle/floor
	name = "floor"
	icon_state = "floor"

/turf/simulated/shuttle/plating
	name = "plating"
	icon = 'icons/turf/floors.dmi'
	icon_state = "plating"

/turf/simulated/shuttle/plating/vox	//Skipjack plating
	oxygen = 0
	nitrogen = MOLES_N2STANDARD + MOLES_O2STANDARD

/turf/simulated/shuttle/floor4 // Added this floor tile so that I have a seperate turf to check in the shuttle -- Polymorph
	name = "Brig floor"        // Also added it into the 2x3 brig area of the shuttle.
	icon_state = "floor4"

/turf/simulated/shuttle/floor4/vox	//skipjack floors
	name = "skipjack floor"
	oxygen = 0
	nitrogen = MOLES_N2STANDARD + MOLES_O2STANDARD

