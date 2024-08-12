
/obj/structure/table/CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
	if(air_group || (height==0)) return 1
	if(istype(mover,/obj/item/projectile))
		return (check_cover(mover,target))
	if (flipped == 1)
		if (get_dir(loc, target) == dir)
			return !density
		else
			return 1
	if(istype(mover) && mover.checkpass(PASSTABLE))
		return 1
	if(locate(/obj/structure/table) in get_turf(mover))
		return 1
	return 0

//checks if projectile 'P' from turf 'from' can hit whatever is behind the table. Returns 1 if it can, 0 if bullet stops.
/obj/structure/table/proc/check_cover(obj/item/projectile/P, turf/from)
	var/turf/cover
	if(flipped==1)
		cover = get_turf(src)
	else if(flipped==0)
		cover = get_step(loc, get_dir(from, loc))
	if(!cover)
		return 1
	if (get_dist(P.starting, loc) <= 1) //Tables won't help you if people are THIS close
		return 1
	if (get_turf(P.original) == cover)
		var/chance = 20
		if (ismob(P.original))
			var/mob/M = P.original
			if (M.lying)
				chance += 20				//Lying down lets you catch less bullets
		if(flipped==1)
			if(get_dir(loc, from) == dir)	//Flipped tables catch mroe bullets
				chance += 20
			else
				return 1					//But only from one side
		if(prob(chance))
			health -= P.damage/2
			if (health > 0)
				visible_message(SPAN_WARN("[P] hits \the [src]!"))
				return 0
			else
				visible_message(SPAN_WARN("[src] breaks down!"))
				break_to_parts()
				return 1
	return 1

/obj/structure/table/CheckExit(atom/movable/O as mob|obj, target as turf)
	if(istype(O) && O.checkpass(PASSTABLE))
		return 1
	if (flipped==1)
		if (get_dir(loc, target) == dir)
			return !density
		else
			return 1
	return 1


/obj/structure/table/MouseDrop_T(obj/O as obj, mob/user as mob)

	if (!istype(O, /obj/item) || user.get_active_hand() != O)
		return ..()
	user.unEquip(O, src.loc)
	return


/obj/structure/table/affect_grab(var/mob/living/user, var/mob/living/target, var/state)
	var/obj/occupied = turf_is_crowded()
	if(occupied)
		user << SPAN_DANGER("There's \a [occupied] in the way.")
		return
	if(state < GRAB_AGGRESSIVE || target.loc==src.loc)
		if(user.a_intent == I_HURT)
			if(prob(15))
				target.Weaken(5)
			target.apply_damage(8,def_zone = BP_HEAD)
			visible_message(SPAN_DANGER("[user] slams [target]'s face against \the [src]!"))
			if(material)
				playsound(loc, material.tableslam_noise, 50, 1)
			else
				playsound(loc, 'sound/weapons/tablehit1.ogg', 50, 1)
			var/list/L = take_damage(rand(1,5))
			// Shards. Extra damage, plus potentially the fact YOU LITERALLY HAVE A PIECE OF GLASS/METAL/WHATEVER IN YOUR FACE
			for(var/obj/item/weapon/material/shard/S in L)
				if(prob(50))
					target.visible_message(
						SPAN_DANGER("\The [S] slices [target]'s face messily!"),
						SPAN_DANGER("\The [S] slices your face messily!")
					)
					target.apply_damage(10, def_zone = BP_HEAD)
					if(prob(2))
						target.embed(S, def_zone = BP_HEAD)
		else
			user << SPAN_DANGER("You need a better grip to do that!")
			return
	else
		target.forceMove(loc)
		target.Weaken(5)
		visible_message(SPAN_DANGER("[user] puts [target] on \the [src]."))
	return TRUE


/obj/structure/table/attackby(obj/item/W, mob/living/user, var/click_params)
	if(!istype(W))
		return

	// Handle dismantling or placing things on the table from here on.
	if(istype(W, /obj/item/weapon/melee/energy/blade))
		var/datum/effect/effect/system/spark_spread/spark_system = new
		spark_system.set_up(5, 0, src.loc)
		spark_system.start()
		playsound(src.loc, 'sound/weapons/blade1.ogg', 50, 1)
		playsound(src.loc, "sparks", 50, 1)
		user.visible_message(SPAN_DANGER("\The [src] was sliced apart by [user]!"))
		break_to_parts()
		return

	if(can_plate && !material)
		user << SPAN_WARN("There's nothing to put \the [W] on! Try adding plating to \the [src] first.")
		return

	// Placing stuff on tables
	if(user.unEquip(W, src.loc))
		auto_align(W, click_params)
		return 1

	return

/*
Automatic alignment of items to an invisible grid, defined by CELLS and CELLSIZE, defined in code/__defines/misc.dm.
Since the grid will be shifted to own a cell that is perfectly centered on the turf, we end up with two 'cell halves'
on edges of each row/column.
Each item defines a center_of_mass, which is the pixel of a sprite where its projected center of mass toward a turf
surface can be assumed. For a piece of paper, this will be in its center. For a bottle, it will be (near) the bottom
of the sprite.
auto_align() will then place the sprite so the defined center_of_mass is at the bottom left corner of the grid cell
closest to where the cursor has clicked on.
Note: This proc can be overwritten to allow for different types of auto-alignment.
*/
/obj/item/var/list/center_of_mass = list("x"=16,"y"=16)
/obj/structure/table/proc/auto_align(obj/item/W, click_params)
	if (!W.center_of_mass || !click_params)
		return 0

	var/list/click_data = params2list(click_params)
	if (!click_data["icon-x"] || !click_data["icon-y"])
		return

	// Calculation to apply new pixelshift.
	var/mouse_x = text2num(click_data["icon-x"])-1 // Ranging from 0 to 31
	var/mouse_y = text2num(click_data["icon-y"])-1

	var/cell_x = Clamp(round(mouse_x/CELLSIZE), 0, CELLS-1) // Ranging from 0 to CELLS-1
	var/cell_y = Clamp(round(mouse_y/CELLSIZE), 0, CELLS-1)

	W.pixel_x = (CELLSIZE * (cell_x + 0.5)) - W.center_of_mass["x"]
	W.pixel_y = (CELLSIZE * (cell_y + 0.5)) - W.center_of_mass["y"]

/obj/structure/table/rack/auto_align(obj/item/W, click_params)
	if(W && !W.center_of_mass)
		..(W)

	var/i = -1
	for (var/obj/item/I in get_turf(src))
		if (I.anchored || !I.center_of_mass)
			continue
		i++
		I.pixel_x = max(3-i*3, -3) + 1 // There's a sprite layering bug for 0/0 pixelshift, so we avoid it.
		I.pixel_y = max(4-i*4, -4) + 1
		I.pixel_z = 0

/obj/structure/table/attack_tk() // no telehulk sorry
	return
