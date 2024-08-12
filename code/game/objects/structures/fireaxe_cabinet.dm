/obj/structure/fireaxecabinet
	name = "fire axe cabinet"
	desc = "There is small label that reads \"For Emergency use only\" along with details for safe use of the axe. As if."
	var/obj/item/weapon/material/twohanded/fireaxe/fireaxe
	icon = 'icons/obj/fireaxe.dmi'
	icon_state = "holder"
	var/atom/movable/door
	anchored = TRUE
	density = FALSE
	var/health
	var/maxhealth = 100
	breakable = TRUE
	var/opened = FALSE
	var/locked = TRUE

/obj/structure/fireaxecabinet/initialize()
	. = ..()
	health = maxhealth
	fireaxe = new (src)
	door = new(src.loc)
	door.density = FALSE
	door.opacity = FALSE
	door.anchored = TRUE
	door.pixel_x = pixel_x
	door.pixel_y = pixel_y
	door.mouse_opacity = FALSE
	door.icon = icon
	src.update_icon()


/obj/structure/fireaxecabinet/Move()
	. = ..()
	door.forceMove(src.loc)

/obj/structure/fireaxecabinet/forceMove()
	. = ..()
	door.forceMove(src.loc)


/obj/structure/fireaxecabinet/update_icon()
	overlays.Cut()
	if(fireaxe)
		overlays += "fireaxe"
	if(opened)
		src.door.icon_state = "door_opened"
	else
		var/index = round(health/maxhealth*100, 25)
		src.door.icon_state = "door[index]_closed"


/obj/structure/fireaxecabinet/attack_hand(mob/user as mob)
	if(src.fireaxe && (src.opened || !health))
		user.put_in_hands(src.fireaxe)
		src.fireaxe = null
		user << SPAN_NOTE("You take the fire axe from the [src].")
		src.add_fingerprint(user)
		src.update_icon()
	else
		if(src.locked)
			user << SPAN_WARN("The cabinet won't budge!")
		else
			src.toggleOpen(user)


/obj/structure/fireaxecabinet/attackby(var/obj/item/O, var/mob/living/user)
	user.setClickCooldown(10)
	if(istype(O, /obj/item/weapon/weldingtool))
		if(user.a_intent == I_HELP && !src.opened)
			if(src.health >= src.maxhealth)
				user << SPAN_NOTE("[src] is not damaged!")
				return
			else if((src.health/src.maxhealth) < 0.25)
				user << SPAN_WARN("[src] glass is too damaged. You need replace it.")
				return
			var/obj/item/weapon/weldingtool/W = O
			if(W.get_fuel() < 6)
				user << SPAN_NOTE("You need more welding fuel to complete this task.")
				return
			if(W.remove_fuel(3, user))
				user.visible_message(
					"[user] start patching \the [src] with [W].",
					"You start patching \the [src] with [W].",
					SPAN_WARN("You hear welging sound.")
				)
				if(do_after(user, 10, src) && W.remove_fuel(3, user))
					adjustHealth(-30)
					user << SPAN_NOTE("You've patch some damages!")
			return

	else if(ismaterial(O) && O.get_material_name() == MATERIAL_RGLASS)
		if(health >= maxhealth)
			user << SPAN_NOTE("[src] is not damaged!")
			return
		var/obj/item/stack/material/M = O
		if(M.amount < 2)
			user << SPAN_WARN("You need two sheets of glass!")
			return
		user.visible_message(
			"[user] start replacing \the [src] glass.",
			"You start replacing \the [src] glass.",
			SPAN_WARN("You hear welging sound.")
		)
		if(do_after(user, 10, src) && M.use(2))
			user << SPAN_NOTE("You fully replace [src] glass")
			adjustHealth(-maxhealth)
		return

	if(src.locked)
		if(istype(O, /obj/item/device/multitool))
			src.toggleLock(user)
		else
			if(src.health) //We don't want this playing every time
				playsound(user, 'sound/effects/Glasshit.ogg', 100, 1)

			if(O.force < 15)
				user << SPAN_NOTE("The cabinet's protective glass glances off the hit.")
			else
				src.attack_generic(user, O)

	else
		if(src.opened || !src.health)
			if(istype(O, /obj/item/weapon/material/twohanded/fireaxe) && !fireaxe)
				var/obj/item/weapon/material/twohanded/fireaxe/FX = O
				if(FX.wielded)
					user << SPAN_WARN("Unwield the axe first.")
					return
				if(!user.unEquip(O, src))
					return
				src.fireaxe = O
				user << SPAN_NOTE("You place the fire axe back in the [src].")
				src.update_icon()
			else
				src.toggleOpen(user)
		else
			if(istype(O, /obj/item/device/multitool))
				src.toggleLock(user)
			else
				src.toggleOpen(user)


/obj/structure/fireaxecabinet/proc/toggleOpen(user)
	src.opened = !src.opened
	src.update_icon()
	var/index = round(health/maxhealth * 100, 25)
	if(src.opened)
		flick("door[index]_opening", src.door)
	else
		flick("door[index]_closing", src.door)


/obj/structure/fireaxecabinet/proc/toggleLock(mob/living/user)
	var/saved_state = src.locked
	user << SPAN_WARN("Resetting circuitry...")
	playsound(src, 'sound/machines/lockreset.ogg', 50, 1)
	if(do_after(user, 20, src) && !src.opened && saved_state == src.locked)
		src.locked = !src.locked
		if(src.locked)
			user << SPAN_NOTE("You re-enable the locking modules.")
		else
			user << SPAN_WARN("You disable the locking modules.")
		update_icon()


/obj/structure/fireaxecabinet/attack_generic(var/mob/user, var/obj/item/W, var/damage, var/attack_verb)
	if(src.health <= 0)
		return

	if((!istype(W) || !W.force) && !damage)
		return

	if(W)
		if(!damage)
			damage = W.force
		if(!attack_verb)
			attack_verb = W.attack_verb ? pick(W.attack_verb) : "hit"
		visible_message(SPAN_DANGER("[user] [attack_verb] the [src] with [W]!"))
	else
		visible_message(SPAN_DANGER("[user] [attack_verb] the [src]!"))
	user.do_attack_animation(src)

	adjustHealth(damage)

/obj/structure/fireaxecabinet/proc/adjustHealth(damage)
	src.health -= damage
	if(src.health < 0)
		src.health = 0
	else if(src.health > src.maxhealth)
		src.health = src.maxhealth

/obj/structure/fireaxecabinet/adjustHealth(damage)
	..()
	if(!src.health)
		playsound(loc, 'sound/effects/Glassbr3.ogg', 100, 1)
	src.update_icon()
