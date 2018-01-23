/obj/structure/closet/secure_closet
	name = "secure locker"
	desc = "It's an immobile card-locked storage unit."
	icon = 'icons/obj/closet.dmi'
	icon_state = "secure"
	density = 1
	opened = 0
	var/locked = 1
	var/broken = 0
	var/large = 1
	icon_opened = "secureopen"
	var/locked_overlay = "locked"
	var/broken_overlay = "broken"
	wall_mounted = 0 //never solid (You can always pass over it)
	health = 200


/obj/structure/closet/secure_closet/wall
	name = "wall locker"
	broken_overlay = "wall_broken"
	req_access = list(access_security)
	density = 1
	locked_overlay = "wall_locked"
	anchored = 1
	wall_mounted = 1
	//too small to put a man in
	large = 0


/obj/structure/closet/secure_closet/New()
	..()
	update_icon()

/obj/structure/closet/secure_closet/examine(mob/user, return_dist=1)
	.=..()
	if(broken)
		user << "It appears to be broken."

/obj/structure/closet/secure_closet/can_open()
	if(src.locked)
		return 0
	return ..()

/obj/structure/closet/secure_closet/emp_act(severity)
	for(var/obj/O in src)
		O.emp_act(severity)
	if(!broken)
		if(prob(50/severity))
			src.locked = !src.locked
			src.update_icon()
		if(prob(20/severity) && !opened)
			if(!locked)
				open()
			else
				src.req_access.Cut()
				src.req_access += pick(get_all_accesses())
	..()

/obj/structure/closet/secure_closet/proc/togglelock(mob/user as mob)
	if(src.opened)
		user << SPAN_NOTE("Close the locker first.")
		return
	if(src.broken)
		user << SPAN_WARN("The locker appears to be broken.")
		return
	if(user.loc == src)
		user << SPAN_NOTE("You can't reach the lock from inside.")
		return
	if(src.allowed(user))
		src.locked = !src.locked
		for(var/mob/O in viewers(user, 3))
			if((O.client && !( O.blinded )))
				O << SPAN_NOTE("The locker has been [locked ? null : "un"]locked by [user].")
		update_icon()
	else
		user << SPAN_NOTE("Access Denied")

/obj/structure/closet/secure_closet/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(!src.opened)
		if(locked)
			if(istype(W, /obj/item/device/multitool))
				var/obj/item/device/multitool/multi = W
				if(multi.in_use)
					user << SPAN_WARN("This multitool is already in use!")
					return
				multi.in_use = 1
				for(var/i in 1 to rand(4,8))
					user.visible_message(
						SPAN_WARN("[user] picks in wires of the [src.name] with a multitool."),
						SPAN_WARN("I am trying to reset circuitry lock module ([i])...")
					)
					if(!do_after(user, 200, src)||!locked)
						multi.in_use = 0
						return
				locked = 0
				broken = 1
				src.update_icon()
				multi.in_use=0
				user.visible_message(
					SPAN_WARN("[user] [locked?"locks":"unlocks"] [name] with a multitool."),
					SPAN_WARN("I [locked?"enable":"disable"] the locking modules.")
				)
		if(istype(W, /obj/item/weapon/melee/energy/blade))
			if(emag_act(INFINITY, user, SPAN_DANG("The locker has been sliced open by [user] with \an [W]!"), SPAN_DANG("You hear metal being sliced and sparks flying.")))
				var/datum/effect/effect/system/spark_spread/spark_system = new()
				spark_system.set_up(5, 0, src.loc)
				spark_system.start()
				playsound(src.loc, 'sound/weapons/blade1.ogg', 50, 1)
				playsound(src.loc, "sparks", 50, 1)
		else if(istype(W, /obj/item/weapon/wrench))
			if(welded)
				if(anchored)
					user.visible_message(
						"\The [user] begins unsecuring \the [src] from the floor.",
						"You start unsecuring \the [src] from the floor."
					)
				else
					user.visible_message(
						"\The [user] begins securing \the [src] to the floor.",
						"You start securing \the [src] to the floor."
					)
				if(do_after(user, 20, src))
					user << SPAN_NOTE("You [anchored? "un" : ""]secured \the [src]!")
					anchored = !anchored
					return
		else if(istype(W,/obj/item/weapon/packageWrap) || istype(W,/obj/item/weapon/weldingtool))
			return ..(W,user)
		else
			togglelock(user)
	else
		..()

/obj/structure/closet/secure_closet/emag_act(var/remaining_charges, var/mob/user, var/emag_source, var/visual_feedback = "", var/audible_feedback = "")
	if(!opened && !broken)
		broken = 1
		locked = 0
		desc = "It appears to be broken."
		update_icon()

		if(visual_feedback)
			visible_message(visual_feedback, audible_feedback)
		else if(user && emag_source)
			visible_message(
				SPAN_WARN("\The [src] has been broken by \the [user] with \an [emag_source]!"),
				"You hear a faint electrical spark."
			)
		else
			visible_message(
				SPAN_WARN("\The [src] sparks and breaks open!"),
				"You hear a faint electrical spark."
			)
		return 1
	else
		return -1

/obj/structure/closet/secure_closet/attack_hand(mob/user as mob)
	src.add_fingerprint(user)
	if(src.locked)
		src.togglelock(user)
	else
		src.toggle(user)

/obj/structure/closet/secure_closet/verb/verb_togglelock()
	set src in oview(1) // One square distance
	set category = "Object"
	set name = "Toggle Lock"

	// Don't use it if you're not able to! Checks for stuns, ghost and restrain
	if(!usr.canmove || usr.stat || usr.restrained())
		return

	if(ishuman(usr))
		src.add_fingerprint(usr)
		src.togglelock(usr)
	else
		usr << SPAN_WARN("This mob type can't use this verb.")

/obj/structure/closet/secure_closet/update_icon()
	overlays.Cut()
	if(opened)
		icon_state = icon_opened
	else
		icon_state = icon_closed
		if(broken)
			overlays += broken_overlay
		else
			overlays += "[locked_overlay][locked?"1":"0"]"
		if(welded)
			overlays += "welded"


/obj/structure/closet/secure_closet/req_breakout()
	if(!opened && locked)
		return TRUE
	return ..() //It's a secure closet, but isn't locked.

/obj/structure/closet/secure_closet/break_open()
	broken = 1
	locked = 0
	update_icon()
	return ..()

