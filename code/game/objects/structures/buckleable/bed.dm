/* Beds... get your mind out of the gutter, they're for sleeping!
 * Contains:
 *		Beds
 *		Roller beds
 */

/*
 * Beds
 */
/obj/structure/material/bed
	name = "bed"
	desc = "This is used to lie in, sleep in or strap on."
	icon = 'icons/obj/bed.dmi'
	icon_state = "bed"
	anchored = TRUE
	can_buckle = TRUE
	buckle_dir = SOUTH
	buckle_lying = RIGHT
	mob_offset_y = 1
	base_icon = "bed"

/obj/structure/material/bed/flipped
	transform = matrix(
		-1, 0, 1,
		 0, 1, 0
	)
	buckle_lying = LEFT

/obj/structure/material/bed/flipped/initialize()
	..()
	for(var/obj/item/weapon/bedsheet/B in src.loc)
		B.transform = src.transform

/obj/structure/material/bed/double
	icon_state = "doublebed"
	base_icon  = "doublebed"
	mob_offset_y = 15

/obj/structure/material/bed/flipped/double
	icon_state = "doublebed"
	base_icon  = "doublebed"
	mob_offset_y = 15

/obj/structure/material/bed/CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
	if(istype(mover) && mover.checkpass(PASSTABLE))
		return 1
	else
		return ..()

/obj/structure/material/bed/affect_grab(var/mob/user, var/mob/target)
	user.visible_message(SPAN_NOTE("[user] attempts to buckle [target] into \the [src]!"))
	if(do_after(user, 20, src) && Adjacent(target))
		target.forceMove(loc)
		spawn(0)
			if(buckle_mob(target))
				target.visible_message(
					SPAN_DANG("[target] is buckled to [src] by [user]!"),
					SPAN_DANG("You are buckled to [src] by [user]!"),
					SPAN_NOTE("You hear metal clanking.")
				)
		return TRUE

/obj/structure/material/bed/attackby(obj/item/weapon/W, mob/living/user)
	if(istype(W, /obj/item/weapon/bedsheet))
		user.drop_from_inventory(W, src.loc)
		W.pixel_x = 0
		W.pixel_y = 0
		W.transform = src.transform
		if(buckled_mob)
			W.layer = 5
			src.visible_message(SPAN_NOTE("[user] covers [buckled_mob] with \the [W]."))
		else
			W.layer = initial(W.layer)
			src.visible_message(SPAN_NOTE("[user] makes the bed with \the [W]."))
	else
		..()


/obj/structure/material/bed/psych
	name = "psychiatrist's couch"
	desc = "For prime comfort during psychiatric evaluations."
	icon_state = "psychbed"
	base_icon = "psychbed"
	mob_offset_y = 5
	material = MATERIAL_WOOD
	padding_material = "leather"

/obj/structure/material/bed/padded
	material = MATERIAL_PLASTIC
	padding_material = "cotton"

/obj/structure/material/bed/alien
	name = "resting contraption"
	desc = "This looks similar to contraptions from earth. Could aliens be stealing our technology?"
	mob_offset_y = 3
	material = "resin"

