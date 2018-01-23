/obj/item/towel
	name = "towel"
	icon = 'icons/obj/items.dmi'
	icon_state = "towel"
	slot_flags = SLOT_HEAD | SLOT_BELT | SLOT_ICLOTHING | SLOT_OCLOTHING
	w_class = ITEM_SIZE_NORMAL
	attack_verb = list("whipped")
	hitsound = 'sound/weapons/towelwhip.ogg'
	desc = "A soft cotton towel."
	var/material = "cotton"

/obj/item/towel/attack_self(mob/living/user)
	user.visible_message(SPAN_NOTE("[user] uses [src] to towel themselves off."))
	playsound(user, 'sound/weapons/towelwipe.ogg', 25, 1)


/obj/item/towel/New(loc, material)
	if(material)
		src.material = material
	..(loc)

/obj/item/towel/initialize()
	..()
	var/material/material = get_material_by_name(src.material)
	name = "[material.display_name] [initial(name)]"
	src.color = material.icon_colour

/obj/item/towel/attackby(obj/item/I, mob/living/user)
	if(istype(I) && material)
		if(I.sharp)
			if(isturf(src.loc))
				create_material_stacks(material, 1, src.loc)
				qdel(src)
			else if(user.get_inactive_hand() == src && isturf(user.loc))
				create_material_stacks(material, 1, user.loc)
				qdel(src)
			else
				user << SPAN_WARN("You can't cut [src] there.")
			return
	return ..()
