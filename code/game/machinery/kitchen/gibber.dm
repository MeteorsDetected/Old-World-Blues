
/obj/machinery/gibber
	name = "gibber"
	desc = "The name isn't descriptive enough?"
	icon = 'icons/obj/kitchen.dmi'
	icon_state = "grinder"
	density = 1
	anchored = 1
	req_access = list(access_kitchen)

	var/operating = 0 //Is it on?
	var/dirty = 0 // Does it need cleaning?
	var/mob/living/occupant // Mob who has been put inside
	var/gib_time = 40        // Time from starting until meat appears
	var/gib_throw_dir = WEST // Direction to spit meat and gibs in.

	use_power = 1
	idle_power_usage = 2
	active_power_usage = 500

//auto-gibs anything that bumps into it
/obj/machinery/gibber/autogibber
	var/turf/input_plate

/obj/machinery/gibber/autogibber/initialize()
	. = ..()
	for(var/i in cardinal)
		var/obj/machinery/mineral/input/input_obj = locate( /obj/machinery/mineral/input, get_step(src.loc, i) )
		if(input_obj)
			if(isturf(input_obj.loc))
				input_plate = input_obj.loc
				gib_throw_dir = i
				qdel(input_obj)
				break

	if(!input_plate)
		log_misc("a [src] didn't find an input plate.")
		return

/obj/machinery/gibber/autogibber/Bumped(var/atom/A)
	if(!input_plate) return

	if(ismob(A))
		var/mob/M = A

		if(M.loc == input_plate)
			M.forceMove(src)
			M.gib()

/obj/machinery/gibber/update_icon()
	overlays.Cut()
	if (dirty)
		src.overlays += image('icons/obj/kitchen.dmi', "grbloody")
	if(stat & (NOPOWER|BROKEN))
		return
	if (!occupant)
		src.overlays += image('icons/obj/kitchen.dmi', "grjam")
	else if (operating)
		src.overlays += image('icons/obj/kitchen.dmi', "gruse")
	else
		src.overlays += image('icons/obj/kitchen.dmi', "gridle")

/obj/machinery/gibber/relaymove(mob/user as mob)
	src.go_out()

/obj/machinery/gibber/attack_hand(mob/user as mob)
	if(stat & (NOPOWER|BROKEN))
		return
	if(operating)
		user << SPAN_DANGER("The gibber is locked and running, wait for it to finish.")
		return
	else
		src.startgibbing(user)

/obj/machinery/gibber/examine()
	. = ..()
	usr << "The safety guard is [emagged ? SPAN_DANGER("disabled") : "enabled"]."

/obj/machinery/gibber/emag_act(var/remaining_charges, var/mob/user)
	emagged = !emagged
	user << SPAN_DANGER("You [emagged ? "disable" : "enable"] the gibber safety guard.")
	return 1

/obj/machinery/gibber/affect_grab(var/mob/user, var/mob/target, var/state)
	if(state < GRAB_NECK)
		user << SPAN_DANGER("You need a better grip to do that!")
		return FALSE
	move_into_gibber(user, target)
	return TRUE

/obj/machinery/gibber/attackby(var/obj/item/W, var/mob/user)
	if(W.GetIdCard())
		if(allowed(user))
			emagged = !emagged
			usr << "The safety guard is [emagged ? SPAN_DANGER("disabled") : "enabled"]."
	else
		..()

/obj/machinery/gibber/MouseDrop_T(mob/target, mob/user)
	if(user.incapacitated())
		return
	move_into_gibber(user,target)

/obj/machinery/gibber/proc/move_into_gibber(var/mob/user,var/mob/living/victim)

	if(src.occupant)
		user << SPAN_DANGER("The gibber is full, empty it first!")
		return

	if(operating)
		user << SPAN_DANGER("The gibber is locked and running, wait for it to finish.")
		return

	if(!iscarbon(victim) && !isanimal(victim))
		user << SPAN_DANGER("This is not suitable for the gibber!")
		return

	if(ishuman(victim) && !emagged)
		user << SPAN_DANGER("The gibber safety guard is engaged!")
		return

	if(victim.abiotic(1))
		user << SPAN_DANGER("Subject may not have abiotic items on.")
		return

	user.visible_message(SPAN_WARN("[user] starts to put [victim] into the gibber!"))
	src.add_fingerprint(user)
	if(do_after(user, 30, src) && victim.Adjacent(src) && user.Adjacent(src) && victim.Adjacent(user) && !occupant)
		user.visible_message("\red [user] stuffs [victim] into the gibber!")
		log_attack("[user] stuffs [victim] into the gibber!", src.loc, TRUE)
		victim.forceMove(src)
		victim.reset_view(src)
		src.occupant = victim
		update_icon()

/obj/machinery/gibber/verb/eject()
	set category = "Object"
	set name = "Empty Gibber"
	set src in oview(1)

	if (usr.incapacitated())
		return
	src.go_out()
	add_fingerprint(usr)

/obj/machinery/gibber/proc/go_out()
	if(operating || !src.occupant)
		return
	for(var/obj/O in src)
		O.forceMove(src.loc)
	src.occupant.forceMove(src.loc)
	src.occupant.reset_view()
	src.occupant = null
	update_icon()


/obj/machinery/gibber/proc/startgibbing(mob/user as mob)
	if(src.operating)
		return
	if(!src.occupant)
		visible_message("<span class='danger'>You hear a loud metallic grinding sound.</span>")
		return
	use_power(1000)
	visible_message(SPAN_DANGER("You hear a loud [occupant.isSynthetic() ? "metallic" : "squelchy"] grinding sound."))
	src.operating = 1
	update_icon()

	var/slab_name = occupant.name
	var/slab_count = 3
	var/slab_type = /obj/item/weapon/reagent_containers/food/snacks/meat
	var/slab_nutrition = src.occupant.nutrition / 15

	// Some mobs have specific meat item types.
	if(isanimal(src.occupant))
		var/mob/living/simple_animal/critter = src.occupant
		if(critter.meat_amount)
			slab_count = critter.meat_amount
		if(critter.meat_type)
			slab_type = critter.meat_type
	else if(ishuman(src.occupant))
		var/mob/living/carbon/human/H = occupant
		slab_name = src.occupant.real_name
		slab_type = H.isSynthetic() ? /obj/item/stack/material/steel : H.species.meat_type

	// Small mobs don't give as much nutrition.
	if(src.occupant.small)
		slab_nutrition *= 0.5
	slab_nutrition /= slab_count

	for(var/i=1 to slab_count)
		var/obj/item/weapon/reagent_containers/food/snacks/meat/new_meat = new slab_type(src)
		new_meat.name = "[slab_name] [new_meat.name]"
		new_meat.reagents.add_reagent("nutriment",slab_nutrition)

		if(src.occupant.reagents)
			src.occupant.reagents.trans_to_obj(new_meat, round(occupant.reagents.total_volume/slab_count,1))

	admin_attack_log(user, occupant,
		"Gibbed <b>[key_name(src.occupant)]</b>",
		"Was gibbed by <b>[key_name(user)]</b>",
		"gibbed"
	)

	src.occupant.ghostize()

	spawn(gib_time)

		src.operating = 0
		src.occupant.gib()
		qdel(src.occupant)

		playsound(src.loc, 'sound/effects/splat.ogg', 50, 1)
		operating = 0
		for (var/obj/thing in contents)
			// Todo: unify limbs and internal organs
			// There's a chance that the gibber will fail to destroy some evidence.
			if((istype(thing,/obj/item/organ) || istype(thing,/obj/item/organ)) && prob(80))
				qdel(thing)
				continue
			//Drop it onto the turf for throwing.
			thing.forceMove(get_turf(thing))
			// Being pelted with bits of meat and bone would hurt.
			thing.throw_at(get_edge_target_turf(src,gib_throw_dir),rand(0,3),emagged ? 100 : 50)

		update_icon()

