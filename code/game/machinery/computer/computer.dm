#define COMPUTER_ICON 'icons/obj/computer.dmi'
#define LAPTOP_ICON   'icons/obj/computer_laptop.dmi'

/obj/machinery/computer
	name = "computer"
	icon = 'icons/obj/computer.dmi'
	icon_state = "computer"
	var/screen_icon = "broken"
	var/screen_broken = "broken"
	density = 1
	anchored = 1.0
	use_power = 1
	idle_power_usage = 300
	active_power_usage = 300
	var/frame = FRAME_COMPUTER
	var/processing = 0

	var/light_range_on = 3
	var/light_power_on = 1
	clicksound = "keyboard"

/obj/machinery/computer/initialize()
	power_change()

/obj/machinery/computer/process()
	if(stat & (NOPOWER|BROKEN))
		return 0
	return 1

/obj/machinery/computer/meteorhit(var/obj/O as obj)
	set_broken()
	var/datum/effect/effect/system/smoke_spread/smoke = PoolOrNew(/datum/effect/effect/system/smoke_spread)
	smoke.set_up(5, 0, src)
	smoke.start()


/obj/machinery/computer/emp_act(severity)
	if(prob(20/severity))
		set_broken()
	..()


/obj/machinery/computer/ex_act(severity)
	switch(severity)
		if(1.0)
			qdel(src)
			return
		if(2.0)
			if (prob(25))
				qdel(src)
				return
			if (prob(50))
				set_broken()
		if(3.0)
			if (prob(25))
				set_broken()
		else
	return

/obj/machinery/computer/bullet_act(var/obj/item/projectile/Proj)
	if(!(Proj.damage_type == BRUTE || Proj.damage_type == BURN))
		return

	if(prob(Proj.damage))
		set_broken()
	..()


/obj/machinery/computer/blob_act()
	if (prob(75))
		set_broken()

/obj/machinery/computer/update_icon()
	if(frame == FRAME_LAPTOP)
		icon = LAPTOP_ICON
		density = FALSE
	else
		icon = COMPUTER_ICON
		density = TRUE
	icon_state = initial(icon_state)
	overlays.Cut()

	// Broken
	if(stat & BROKEN)
		overlays += screen_broken

	// Unpowered
	else if(stat & NOPOWER)
		set_light(0)

	else
		if(screen_icon in icon_states(icon))
			overlays += screen_icon
		else
			overlays += "computer_generic"
		set_light(light_range_on, light_power_on)


/obj/machinery/computer/proc/set_broken()
	stat |= BROKEN
	update_icon()

/obj/machinery/computer/proc/decode(text)
	// Adds line breaks
	text = replacetext(text, "\n", "<BR>")
	return text


/obj/machinery/computer/attack_ghost(user as mob)
	return src.attack_hand(user)

/obj/machinery/computer/attack_hand(user as mob)
	/* Observers can view computers, but not actually use them via Topic*/
	if(isobserver(user)) return 0
	return ..()

/obj/machinery/computer/attackby(I as obj, user as mob)
	if(istype(I, /obj/item/weapon/screwdriver) && circuit)
		playsound(src.loc, 'sound/items/Screwdriver.ogg', 50, 1)
		if(do_after(user, 20))
			new /obj/structure/computerframe/deconstruct(src.loc, src)
			for (var/obj/C in src)
				C.loc = src.loc
			if (src.stat & BROKEN)
				user << SPAN_NOTE("The broken glass falls out.")
				new /obj/item/weapon/material/shard( src.loc )
			else
				user << SPAN_NOTE("You disconnect the monitor.")
			qdel(src)
	else
		..()

#undef COMPUTER_ICON
#undef LAPTOP_ICON