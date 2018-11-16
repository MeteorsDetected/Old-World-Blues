/*
CONTAINS:
Deployable items
Barricades
*/

//Barricades!
/obj/structure/barricade
	name = "barricade"
	desc = "This space is blocked off by a barricade."
	icon = 'icons/obj/structures.dmi'
	icon_state = "barricade"
	anchored = 1.0
	density = 1.0
	var/health = 100
	var/maxhealth = 100
	var/material/material

/obj/structure/barricade/New(var/newloc, var/material_name)
	..(newloc)
	if(!material_name)
		material_name = MATERIAL_WOOD
	material = get_material_by_name("[material_name]")
	if(!material)
		qdel(src)
		return
	name = "[material.display_name] barricade"
	desc = "This space is blocked off by a barricade made of [material.display_name]."
	color = material.icon_colour
	maxhealth = material.integrity
	health = maxhealth

/obj/structure/barricade/get_material()
	return material

/obj/structure/barricade/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W, /obj/item/stack))
		var/obj/item/stack/D = W
		//hitting things with the wrong type of stack usually doesn't produce messages,
		// and probably doesn't need to.
		if(D.get_material_name() != material.name)
			return
		if(health < maxhealth)
			if(D.get_amount() < 1)
				user << SPAN_WARN("You need one sheet of [material.display_name] to repair \the [src].")
				return
			visible_message(SPAN_NOTE("[user] begins to repair \the [src]."))
			if(do_after(user,20,src) && health < maxhealth)
				if(D.use(1))
					health = maxhealth
					visible_message(SPAN_NOTE("[user] repairs \the [src]."))
				return
		return
	else
		user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
		switch(W.damtype)
			if("fire")
				health -= W.force * 1
			if("brute")
				health -= W.force * 0.75
			else
		if(health <= 0)
			visible_message("<span class='danger'>The barricade is smashed apart!</span>")
			dismantle()
			qdel(src)
			return
		..()

/obj/structure/barricade/proc/dismantle()
	material.place_dismantled_product(get_turf(src))
	qdel(src)
	return

/obj/structure/barricade/ex_act(severity)
	switch(severity)
		if(1.0)
			visible_message("<span class='danger'>\The [src] is blown apart!</span>")
			qdel(src)
			return
		if(2.0)
			health -= 25
			if(health <= 0)
				visible_message("<span class='danger'>\The [src] is blown apart!</span>")
				dismantle()
			return

/obj/structure/barricade/meteorhit()
	visible_message("<span class='danger'>\The [src] is smashed apart!</span>")
	dismantle()
	return

/obj/structure/barricade/blob_act()
	src.health -= 25
	if (src.health <= 0)
		visible_message("<span class='danger'>The blob eats through \the [src]!</span>")
		qdel(src)
	return

//So bullets will fly over and stuff.
/obj/structure/barricade/CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
	if(air_group || (height==0))
		return 1
	if(istype(mover) && mover.checkpass(PASSTABLE))
		return 1
	else
		return 0

//Actual Deployable machinery stuff
/obj/machinery/deployable
	name = "deployable"
	desc = "deployable"
	icon = 'icons/obj/objects.dmi'
	req_access = list(access_security)//I'm changing this until these are properly tested./N

/obj/machinery/deployable/barrier
	name = "deployable barrier"
	desc = "A deployable barrier. Swipe your ID card to lock/unlock it."
	icon = 'icons/obj/objects.dmi'
	anchored = 0.0
	density = 1.0
	icon_state = "barrier0"
	var/health = 100.0
	var/maxhealth = 100.0
	var/locked = 0.0
//	req_access = list(access_maint_tunnels)

/obj/machinery/deployable/barrier/initialize()
	. = ..()
	icon_state = "barrier[locked]"

/obj/machinery/deployable/barrier/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(W.GetID())
		if(allowed(user))
			if	(emagged < 2.0)
				locked = !locked
				anchored = !anchored
				icon_state = "barrier[locked]"
				if((locked == 1.0) && (emagged < 2.0))
					user << "Barrier lock toggled on."
					return
				else if((locked == 0.0) && (emagged < 2.0))
					user << "Barrier lock toggled off."
					return
			else
				var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
				s.set_up(2, 1, src)
				s.start()
				visible_message("<span class='warning'>BZZzZZzZZzZT</span>")
				return
		return
	else if(istype(W, /obj/item/weapon/wrench))
		if(health < maxhealth)
			health = maxhealth
			emagged = 0
			req_access = list(access_security)
			visible_message("<span class='warning'>[user] repairs \the [src]!</span>")
			return
		else if(emagged > 0)
			emagged = 0
			req_access = list(access_security)
			visible_message("<span class='warning'>[user] repairs \the [src]!</span>")
			return
		return
	else
		switch(W.damtype)
			if("fire")
				health -= W.force * 0.75
			if("brute")
				health -= W.force * 0.5
			else
		if(health <= 0)
			explode()
		..()

/obj/machinery/deployable/barrier/ex_act(severity)
	switch(severity)
		if(1.0)
			explode()
			return
		if(2.0)
			health -= 25
			if(health <= 0)
				explode()
			return

/obj/machinery/deployable/barrier/emp_act(severity)
	if(stat & (BROKEN|NOPOWER))
		return
	if(prob(50/severity))
		locked = !locked
		anchored = !anchored
		icon_state = "barrier[locked]"

/obj/machinery/deployable/barrier/meteorhit()
	src.explode()
	return

/obj/machinery/deployable/barrier/blob_act()
	src.health -= 25
	if (src.health <= 0)
		src.explode()
	return

//So bullets will fly over and stuff.
/obj/machinery/deployable/barrier/CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
	if(air_group || (height==0))
		return 1
	if(istype(mover) && mover.checkpass(PASSTABLE))
		return 1
	else
		return 0

/obj/machinery/deployable/barrier/proc/explode()

	visible_message("<span class='danger'>[src] blows apart!</span>")
	var/turf/Tsec = get_turf(src)

/*	var/obj/item/stack/rods/ =*/
	PoolOrNew(/obj/item/stack/rods, Tsec)

	var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
	s.set_up(3, 1, src)
	s.start()

	explosion(src.loc,-1,-1,0)
	if(src)
		qdel(src)

/obj/machinery/deployable/barrier/emag_act(var/remaining_charges, var/mob/user)
	if(emagged == 0)
		emagged = 1
		req_access.Cut()
		req_one_access.Cut()
		user << "You break the ID authentication lock on \the [src]."
		var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
		s.set_up(2, 1, src)
		s.start()
		visible_message("<span class='warning'>BZZzZZzZZzZT</span>")
		return 1
	else if(emagged == 1)
		emagged = 2
		user << "You short out the anchoring mechanism on \the [src]."
		var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
		s.set_up(2, 1, src)
		s.start()
		visible_message("<span class='warning'>BZZzZZzZZzZT</span>")
		return 1