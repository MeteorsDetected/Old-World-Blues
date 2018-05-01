//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:32

/obj/item/storage/lockbox
	name = "lockbox"
	desc = "A locked box."
	icon_state = "lockbox+l"
	item_state = "syringe_kit"
	w_class = ITEM_SIZE_HUGE
	max_w_class = ITEM_SIZE_NORMAL
	max_storage_space = 14 //The sum of the w_classes of all the items in this storage item.
	storage_slots = 4
	req_access = list(access_armory)
	var/locked = 1
	var/broken = 0
	var/icon_locked = "lockbox+l"
	var/icon_closed = "lockbox"
	var/icon_broken = "lockbox+b"

/obj/item/storage/lockbox/update_icon()
	if(broken)
		icon_state = icon_broken
	else if(locked)
		icon_state = icon_locked
	else
		icon_state = icon_closed

/obj/item/storage/lockbox/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if (istype(W, /obj/item/weapon/card/id))
		if(src.broken)
			user << SPAN_WARN("It appears to be broken.")
			return
		if(src.allowed(user))
			src.locked = !( src.locked )
			if(src.locked)
				update_icon()
				user << SPAN_NOTE("You lock \the [src]!")
				close_all()
				return
			else
				update_icon()
				user << SPAN_NOTE("You unlock \the [src]!")
				return
		else
			user << SPAN_WARN("Access Denied")
	else if(istype(W, /obj/item/weapon/melee/energy/blade))
		if(emag_act(INFINITY, user, W, "The locker has been sliced open by [user] with an energy blade!", "You hear metal being sliced and sparks flying."))
			var/datum/effect/effect/system/spark_spread/spark_system = new /datum/effect/effect/system/spark_spread()
			spark_system.set_up(5, 0, src.loc)
			spark_system.start()
			playsound(src.loc, 'sound/weapons/blade1.ogg', 50, 1)
			playsound(src.loc, "sparks", 50, 1)
	if(!locked)
		..()
	else
		user << SPAN_WARN("It's locked!")

/obj/item/storage/lockbox/show_to(mob/user as mob)
	if(locked)
		user << SPAN_WARN("It's locked!")
	else
		..()

/obj/item/storage/lockbox/emag_act(var/remaining_charges, var/mob/user, var/emag_source, var/visual_feedback = "", var/audible_feedback = "")
	if(!broken)
		if(visual_feedback)
			visual_feedback = SPAN_WARN("[visual_feedback]")
		else
			visual_feedback = SPAN_WARN("The locker has been sliced open by [user] with an electromagnetic card!")
		if(audible_feedback)
			audible_feedback = SPAN_WARN("[audible_feedback]")
		else
			audible_feedback = SPAN_WARN("You hear a faint electrical spark.")

		broken = 1
		locked = 0
		desc = "It appears to be broken."
		update_icon()
		visible_message(visual_feedback, audible_feedback)
		return 1

/obj/item/storage/lockbox/loyalty
	name = "lockbox of loyalty implants"
	req_access = list(access_security)
	preloaded = list(
		/obj/item/weapon/implantcase/loyalty = 3,
		/obj/item/weapon/implanter/loyalty
	)


/obj/item/storage/lockbox/clusterbang
	name = "lockbox of clusterbangs"
	desc = "You have a bad feeling about opening this."
	req_access = list(access_security)
	preloaded = list(
		/obj/item/weapon/grenade/flashbang/clusterbang
	)

/obj/item/storage/lockbox/medal
	name = "lockbox of medals"
	desc = "A lockbox filled with commemorative medals, it has the NanoTrasen logo stamped on it."
	req_access = list(access_heads)
	storage_slots = 7
	preloaded = list(
		/obj/item/clothing/accessory/medal/conduct,
		/obj/item/clothing/accessory/medal/bronze_heart,
		/obj/item/clothing/accessory/medal/nobel_science,
		/obj/item/clothing/accessory/medal/silver/valor,
		/obj/item/clothing/accessory/medal/silver/security,
		/obj/item/clothing/accessory/medal/gold/captain,
		/obj/item/clothing/accessory/medal/gold/heroism,
	)
