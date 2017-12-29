/obj/item/clothing/shoes/magboots
	desc = "Magnetic boots, often used during extravehicular activity to ensure the user remains safely attached to the vehicle. They're large enough to be worn over other footwear."
	name = "magboots"
	icon_state = "magboots0"
	species_restricted = null
	force = 3
	overshoes = TRUE
	flags = PHORONGUARD
	item_flags = NOSLIP
	var/additional_slowdown = 2

/obj/item/clothing/shoes/magboots/proc/set_slowdown()
	slowdown = (shoes? max(0, shoes.slowdown): 0) + 1 //So you can't put on magboots to make you walk faster.
	if(item_flags&NOSLIP)
		slowdown += additional_slowdown

/obj/item/clothing/shoes/magboots/mob_can_equip(mob/user, slot)
	. = ..()
	if(.)
		set_slowdown()

/obj/item/clothing/shoes/magboots/toggleable
	var/icon_base = "magboots"
	icon_action_button = "action_blank"
	action_button_name = "Toggle the magboots"
	item_flags = null

/obj/item/clothing/shoes/magboots/toggleable/update_icon()
	if(icon_base)
		if(item_flags&NOSLIP)
			icon_state = "[icon_base]1"
		else
			icon_state = "[icon_base]0"

/obj/item/clothing/shoes/magboots/toggleable/attack_self(mob/user)
	if(item_flags&NOSLIP)
		item_flags &= ~NOSLIP
		force = 3
		user << "You disable the mag-pulse traction system."
	else
		item_flags |= NOSLIP
		force = 5
		user << "You enable the mag-pulse traction system."

	set_slowdown()
	update_icon()
	user.update_inv_shoes()	//so our mob-overlays update

/obj/item/clothing/shoes/magboots/toggleable/examine(mob/user, return_dist = TRUE)
	. = ..()
	if(.<=3)
		user << "Its mag-pulse traction system appears to be [item_flags&NOSLIP ? "enabled" : "disabled"]."



/obj/item/clothing/shoes/magboots/toggleable/advanced
	desc = "Advanced magnetic boots that have a lighter magnetic pull, placing less burden on the wearer."
	name = "advanced magboots"
	icon_state = "advmag0"
	icon_base = "advmag"
	additional_slowdown = 1

/obj/item/clothing/shoes/magboots/toggleable/syndie
	desc = "Reverse-engineered magnetic boots that have a heavy magnetic pull. Property of Gorlex Marauders."
	name = "blood-red magboots"
	icon_state = "syndiemag0"
	icon_base = "syndiemag"
