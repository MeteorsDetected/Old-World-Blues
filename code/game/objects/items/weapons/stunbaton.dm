//replaces our stun baton code with /tg/station's code
/obj/item/weapon/melee/baton
	name = "stunbaton"
	desc = "A stun baton for incapacitating people with."
	icon_state = "stunbaton"
	item_state = "stunbaton"
	slot_flags = SLOT_BELT
	force = 15
	sharp = 0
	edge = 0
	throwforce = 7
	w_class = ITEM_SIZE_NORMAL
	origin_tech = list(TECH(T_COMBAT) = 2)
	attack_verb = list("beaten")
	var/stunforce = 2
	var/agonyforce = 80
	var/status = 0		//whether the thing is on or not
	var/obj/item/weapon/cell/bcell = null
	var/hitcost = 1000	//oh god why do power cells carry so much charge? We probably need to make a distinction between "industrial" sized power cells for APCs and power cells for everything else.

/obj/item/weapon/melee/baton/suicide_act(mob/user)
	user.visible_message("<span class='suicide'>[user] is putting the live [name] in \his mouth! It looks like \he's trying to commit suicide.</span>")
	return (FIRELOSS)

/obj/item/weapon/melee/baton/initialize()
	update_icon()
	return ..()

/obj/item/weapon/melee/baton/loaded/initialize() //this one starts with a cell pre-installed.
	bcell = new/obj/item/weapon/cell/high(src)
	return ..()

/obj/item/weapon/melee/baton/proc/deductcharge(var/chrgdeductamt)
	if(bcell)
		if(bcell.checked_use(chrgdeductamt))
			return 1
		else
			status = 0
			update_icon()
			return 0
	return null

/obj/item/weapon/melee/baton/update_icon()
	if(status)
		icon_state = "[initial(name)]_active"
	else if(!bcell)
		icon_state = "[initial(name)]_nocell"
	else
		icon_state = "[initial(name)]"

/obj/item/weapon/melee/baton/examine(mob/user, return_dist = 1)
	.=..()
	if(.>3)
		return

	if(bcell)
		user << SPAN_NOTE("The baton is [bcell.percent()]% charged.")
	else
		user << SPAN_WARN("The baton does not have a power source installed.")

/obj/item/weapon/melee/baton/attackby(obj/item/weapon/W, mob/user)
	if(istype(W, /obj/item/weapon/cell))
		if(!bcell)
			user.drop_from_inventory(W, src)
			bcell = W
			user << SPAN_NOTE("You install a cell in [src].")
			update_icon()
		else
			user << SPAN_NOTE("[src] already has a cell.")

	else if(istype(W, /obj/item/weapon/screwdriver))
		if(bcell)
			bcell.update_icon()
			bcell.forceMove(get_turf(src.loc))
			bcell = null
			user << SPAN_NOTE("You remove the cell from the [src].")
			status = 0
			update_icon()
			return
		..()
	return

/obj/item/weapon/melee/baton/attack_self(mob/user)
	if(bcell && bcell.charge > hitcost)
		status = !status
		user << SPAN_NOTE("[src] is now [status ? "on" : "off"].")
		playsound(loc, "sparks", 75, 1, -1)
		update_icon()
	else
		status = 0
		if(!bcell)
			user << SPAN_WARN("[src] does not have a power source!")
		else
			user << SPAN_WARN("[src] is out of charge.")
	add_fingerprint(user)


/obj/item/weapon/melee/baton/attack(mob/M, mob/user)
	//TODO: DNA3 clown_block
/*
	if(status && (CLUMSY in user.mutations) && prob(50))
		user << "span class='danger'>You accidentally hit yourself with the [src]!</span>"
		user.Weaken(30)
		deductcharge(hitcost)
		return
*/
	if(isrobot(M))
		..()
		return

	var/agony = agonyforce
	var/stun = stunforce
	var/mob/living/L = M

	var/target_zone = check_zone(user.zone_sel.selecting)
	if(force && user.a_intent == I_HURT)
		if (!..())	//item/attack() does it's own messaging and logs
			return 0	// item/attack() will return 1 if they hit, 0 if they missed.
		agony *= 0.5	//whacking someone causes a much poorer contact than prodding them.
		stun *= 0.5
		//we can't really extract the actual hit zone from ..(), unfortunately. Just act like they attacked the area they intended to.
	else
		//copied from human_defense.dm - human defence code should really be refactored some time.
		if (ishuman(L))
			user.lastattacked = L	//are these used at all, if we have logs?
			L.lastattacker = user

			if (user != L) // Attacking yourself can't miss
				target_zone = get_zone_with_miss_chance(user.zone_sel.selecting, L)

			if(!target_zone)
				L.visible_message("\red <B>[user] misses [L] with \the [src]!")
				return 0

			var/mob/living/carbon/human/H = L
			var/obj/item/organ/external/affecting = H.get_organ(target_zone)
			if (affecting)
				if(!status)
					L.visible_message(
						SPAN_WARN("[L] has been prodded in the [affecting.name] with [src] by [user]. Luckily it was off.")
					)
					return 1
				else
					H.visible_message(
						SPAN_DANGER("[L] has been prodded in the [affecting.name] with [src] by [user]!")
					)
		else
			if(!status)
				L.visible_message(
					SPAN_WARN("[L] has been prodded with [src] by [user]. Luckily it was off.")
				)
				return 1
			else
				L.visible_message(
					SPAN_DANGER("[L] has been prodded with [src] by [user]!")
				)

	//stun effects
	L.stun_effect_act(stun, agony, target_zone, src)

	playsound(loc, 'sound/weapons/Egloves.ogg', 50, 1, -1)
	log_attack("[key_name(user)] stunned [key_name(L)] with the [src].", L)

	deductcharge(hitcost)

	if(ishuman(L))
		var/mob/living/carbon/human/H = L
		H.forcesay(hit_appends)

	return 1

/obj/item/weapon/melee/baton/emp_act(severity)
	if(bcell)
		bcell.emp_act(severity)	//let's not duplicate code everywhere if we don't have to please.
	..()


/obj/item/weapon/melee/baton/robot
	hitcost = 100

//secborg stun baton module
/obj/item/weapon/melee/baton/robot/attack_self(mob/user)
	//try to find our power cell
	var/mob/living/silicon/robot/R = loc
	if (istype(R))
		bcell = R.cell
	return ..()

/obj/item/weapon/melee/baton/robot/attackby(obj/item/weapon/W, mob/user)
	return

//Makeshift stun baton. Replacement for stun gloves.
/obj/item/weapon/melee/baton/cattleprod
	name = "stunprod"
	desc = "An improvised stun baton."
	icon_state = "stunprod_nocell"
	item_state = "prod"
	force = 3
	throwforce = 5
	stunforce = 0
	agonyforce = 60	//same force as a stunbaton, but uses way more charge.
	hitcost = 2500
	attack_verb = list("poked")
	slot_flags = null

/obj/item/weapon/melee/baton/shocker
	name = "shocker"
	desc = "Electrifying!"
	icon_state = "shocker"
	item_state = "shocker"
	force = 0
	throwforce = 0
	stunforce = 0
	agonyforce = 60
	hitcost = 1000
	w_class = ITEM_SIZE_SMALL
	attack_verb = list("shocked")

/obj/item/weapon/melee/baton/shocker/loaded/initialize()
	bcell = new/obj/item/weapon/cell/high(src)
	return ..()