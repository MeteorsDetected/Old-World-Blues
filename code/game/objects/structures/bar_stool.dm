/obj/structure/bar_stool
	name = "bar stool"
	icon = 'icons/obj/furniture.dmi'
	icon_state = "stool_padded_new"

/obj/structure/bar_stool/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(istype(W, /obj/item/weapon/screwdriver))
		anchored = !anchored
		playsound(src.loc, 'sound/items/Ratchet.ogg', 75, 1)
		if(anchored)
			user.visible_message(
				"[user.name] secures [src] to the floor.",
				"You secure the bolts to the floor.",
				"You hear a ratchet"
			)
		else
			user.visible_message(
				"[user.name] unsecures [src] from the floor.",
				"You undo the bolts.",
				"You hear a ratchet"
			)
		return 1
	else
		return ..()
