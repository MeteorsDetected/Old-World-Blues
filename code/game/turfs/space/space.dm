/turf/space
	icon = 'icons/turf/space.dmi'
	name = "\proper space"
	icon_state = "0"
	dynamic_lighting = 0

	plane = PLANE_SPACE

	temperature = T20C
	thermal_conductivity = OPEN_HEAT_TRANSFER_COEFFICIENT
//	heat_capacity = 700000 No.

/turf/space/New()
	if(!istype(src, /turf/space/transit))
		icon_state = "[((x + y) ^ ~(x * y) + z) % 25]"
	update_starlight()

	if(z <= 8 || config.use_overmap)
		if(x <= TRANSITIONEDGE || x >= (world.maxx - TRANSITIONEDGE + 1) || y <= TRANSITIONEDGE || y >= (world.maxy - TRANSITIONEDGE + 1))
			new /obj/effect/step_trigger/edge_teleporter(src)

	..()

/turf/space/proc/update_starlight()
	if(!config.starlight)
		return
	if(locate(/turf/simulated) in orange(1,src))
		set_light(config.starlight)
	else
		set_light(0)

/turf/space/attackby(obj/item/C as obj, mob/user as mob)

	if (istype(C, /obj/item/stack/rods))
		var/obj/structure/lattice/L = locate(/obj/structure/lattice, src)
		if(L)
			return
		var/obj/item/stack/rods/R = C
		if (R.use(1))
			user << SPAN_NOTE("Constructing support lattice ...")
			playsound(src, 'sound/weapons/Genhit.ogg', 50, 1)
			ReplaceWithLattice()
		return

	if (istype(C, /obj/item/stack/tile/steel))
		var/obj/structure/lattice/L = locate(/obj/structure/lattice, src)
		if(L)
			var/obj/item/stack/tile/steel/S = C
			if (S.get_amount() < 1)
				return
			qdel(L)
			playsound(src, 'sound/weapons/Genhit.ogg', 50, 1)
			S.build(src)
			S.use(1)
			return
		else
			user << "\red The plating is going to need some support."
	return


// Ported from unstable r355

/turf/space/Entered(atom/movable/A as mob|obj)
	..()
	if (!A || src != A.loc)	return //Is that possible?

	inertial_drift(A)

/turf/space/ChangeTurf(var/turf/N, var/tell_universe=1, var/force_lighting_update = 0)
	return ..(N, tell_universe, 1)
