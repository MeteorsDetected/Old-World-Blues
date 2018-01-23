/*
 * Roller beds
 */
/obj/structure/roller_bed
	name = "roller bed"
	icon = 'icons/obj/rollerbed.dmi'
	icon_state = "down"
	anchored = FALSE
	surgery_odds = 75
	can_buckle = TRUE
	buckle_dir = SOUTH
	buckle_lying = RIGHT
	mob_offset_y = 3

/obj/structure/roller_bed/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(istype(W,/obj/item/roller_holder))
		if(buckled_mob)
			user_unbuckle_mob(user)
		else
			visible_message("[user] collapses \the [src.name].")
			new/obj/item/roller(get_turf(src))
			spawn(0)
				qdel(src)
		return
	..()

/obj/item/roller
	name = "roller bed"
	desc = "A collapsed roller bed that can be carried around."
	icon = 'icons/obj/rollerbed.dmi'
	icon_state = "folded"
	item_state = "folded"
	slot_flags = SLOT_BACK
	w_class = ITEM_SIZE_HUGE // Can't be put in backpacks. Oh well. For now.

/obj/item/roller/attack_self(mob/user)
	var/obj/structure/roller_bed/R = new (user.loc)
	R.add_fingerprint(user)
	qdel(src)

/obj/item/roller/attackby(obj/item/weapon/W, mob/living/user)
	if(istype(W,/obj/item/roller_holder))
		var/obj/item/roller_holder/RH = W
		if(!RH.held)
			user << SPAN_NOTE("You collect the roller bed.")
			src.loc = RH
			RH.held = src
		return

	..()

/obj/item/roller_holder
	name = "roller bed rack"
	desc = "A rack for carrying a collapsed roller bed."
	icon = 'icons/obj/rollerbed.dmi'
	icon_state = "folded"
	var/obj/item/roller/held = new

/obj/item/roller_holder/attack_self(mob/user as mob)

	if(!held)
		user << SPAN_NOTE("The rack is empty.")
		return

	user << SPAN_NOTE("You deploy the roller bed.")
	held.add_fingerprint(user)
	held.forceMove(user.loc)
	held = null

/obj/structure/roller_bed/Move()
	..()
	if(buckled_mob)
		if(buckled_mob.buckled == src)
			buckled_mob.loc = src.loc
		else
			buckled_mob = null

/obj/structure/roller_bed/post_buckle_mob(mob/living/M as mob)
	if(M == buckled_mob)
		M.pixel_y = 6
		M.old_y = 6
		density = 1
		icon_state = "up"
	else
		M.pixel_y = 0
		M.old_y = 0
		density = 0
		icon_state = "down"

	return ..()

/obj/structure/roller_bed/MouseDrop(over_object, src_location, over_location)
	..()
	if((over_object == usr && (in_range(src, usr) || usr.contents.Find(src))))
		if(!ishuman(usr) || buckled_mob)
			return 0
		visible_message("[usr] collapses \the [src.name].")
		new/obj/item/roller(get_turf(src))
		spawn(0)
			qdel(src)
		return
