/obj/item/weapon/reagent_containers/glass/drinks/cans
	var/wired = 0
	var/igniter = 0

/obj/item/weapon/grenade/iedcasing
	name = "improvised firebomb"
	desc = "A weak, improvised incendiary device."
	w_class = ITEM_SIZE_SMALL
	icon = 'icons/obj/grenade.dmi'
	icon_state = "improvised_grenade"
	item_state = "flashbang"
	throw_speed = 3
	throw_range = 7
	flags = CONDUCT
	slot_flags = SLOT_BELT
	active = 0
	det_time = 50
	var/range = 3
	var/list/times

/obj/item/weapon/grenade/iedcasing/prime() //Blowing that can up
	var/turf/T = get_turf(src)
	if(T)
		explosion(T,0,0,3)
		var/turf/simulated/floor/location = get_turf(src)
		if(location)
			spawn (0)
				new/obj/effect/decal/cleanable/liquid_fuel/flamethrower_fuel(location,15,T)
				location.hotspot_expose((T20C*2) + 380,500)
		qdel(src)

/obj/item/weapon/grenade/iedcasing/examine(mob/user)
	..()
	to_chat(user, "You can't tell when it will explode!")


/obj/item/weapon/grenade/proc/update_mob()
	if(ismob(loc))
		var/mob/M = loc
		M.drop_from_inventory(src)


/obj/item/weapon/reagent_containers/glass/drinks/cans/attackby(var/obj/item/I, mob/user as mob)
	var/obj/item/complete
	//add wires

	if(istype(I, /obj/item/stack/cable_coil))
		if(reagents.has_reagent("fuel",30))
			var/obj/item/stack/cable_coil/C = I
			if(wired)
				user << "<span class='notice'>The [src] are already wired.</span>"
				return

			if(C.amount < 2)
				user << "<span class='notice'>There is not enough wire to cover the [src].</span>"
				return

			C.use(2)
			wired = 1
			siemens_coefficient = 3.0
			user << "<span class='notice'>You wrap some wires around the [src].</span>"
			update_icon()
			return

		else
			user << "<span class='notice'>Not enough fuel in [src].</span>"
	//add cell
	else if(istype(I, /obj/item/device/assembly/igniter))
		if(!wired)
			user << "<span class='notice'>The [src] need to be wired first.</span>"
		else if(!igniter)
			complete = new /obj/item/weapon/grenade/iedcasing(get_turf(user))
			user << "<span class='notice'>You attach the [igniter] to the [src].</span>"
			user.drop_from_inventory(src)
			user.drop_from_inventory(I)
			qdel(I)
			qdel(src)
			user.put_in_hands(complete)
			update_icon()
		else
			user << "<span class='notice'>A [igniter] is already attached to the [src].</span>"
		return

		return

	..()



/obj/item/weapon/grenade/iedcasing/attack_self(mob/user as mob)
	if(!active)
		if(clown_check(user))
			user << "<span class='warning'>You prime \the [name]! [det_time/10] seconds!</span>"

			activated(user)
			add_fingerprint(user)
			if(iscarbon(user))
				var/mob/living/carbon/C = user
				C.throw_mode_on()
	return



/obj/item/weapon/grenade/iedcasing/proc/activated(mob/user as mob)
	if(active)
		return

	if(user)
		self_attack_log(user, "primed \a [src]", 1)
	times = list("5" = 10, "-1" = 20, "[rand(30,80)]" = 50, "[rand(65,180)]" = 20)// "Premature, Dud, Short Fuse, Long Fuse"=[weighting value]
	det_time = text2num(pickweight(times))
	if(det_time < 0) //checking for 'duds'
		range = 1
		det_time = rand(30,80)
	else
		range = pick(2,2,2,3,3,3,4)
	icon_state = initial(icon_state) + "_active"
	active = 1
//	playsound(loc, 'sound/weapons/armbomb.ogg', 75, 1, -3)

	spawn(det_time)
		prime()
		return