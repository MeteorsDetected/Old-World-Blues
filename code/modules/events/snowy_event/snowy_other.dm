//There is small storage for various stuff
//From little things to effects and procs



/obj/structure/rock
	name = "Rock"
	desc = "Cold and big rock. Looks tough."
	icon = 'icons/obj/snowy_event/snowy_icons.dmi'
	icon_state = "rock"
	anchored = 1
	density = 1

	New()
		icon_state = "rock[rand(1, 2)]"


//Some special effects for that event based on steam effects
/obj/effect/effect/steam/flinders
	name = "flinders"
	icon = 'icons/obj/snowy_event/snowy_icons.dmi'
	icon_state = "flinders1"

	New()
		..()
		icon_state = "flinders[rand(1,3)]"


/obj/effect/effect/steam/fire_spark
	name = "fire spark"
	icon = 'icons/obj/snowy_event/snowy_icons.dmi'
	icon_state = "fire_spark"




/datum/effect/effect/system/steam_spread/spread
	var/effect

	//Dont know why nobody makes effect_system more... better and reusable?..
	set_up(n = 3, c = 0, turf/loc, effect_obj)
		if(n > 10)
			n = 10
		number = n
		cardinals = c
		location = loc
		effect = effect_obj

	start()
		var/i = 0
		for(i=0, i<src.number, i++)
			spawn(0)
				if(holder)
					src.location = get_turf(holder)
				var/obj/effect/effect/eff = PoolOrNew(effect, src.location)
				eff.pixel_x = rand(-15, 15)
				eff.pixel_y = rand(-15, 15)
				var/direction
				if(src.cardinals)
					direction = pick(cardinal)
				else
					direction = pick(alldirs)
				for(i=0, i<pick(1,2,3), i++)
					sleep(5)
					step(eff,direction)
				spawn(20)
					qdel(eff)


//I'm tired from all of that. So... I end it later.
/*
/datum/regular_sound
	var/list/listeners = list()
	var/sound_path
	var/volume = 100
	var/channel = 0
	var/radius = 5
	var/status = "off"
	var/live_ticker = 5 //if ticker not updated, automaticaly kill sound

	New()
		..()
		channelSetup()


/datum/regular_sound/proc


/datum/regular_sound/proc/channelSetup()
	if(!channel)
		channel = rand(455, 490)
		if(var/datum/regular_sound/another in hearers(radius, source.loc)
			if(another != src && another.channel == channel)
				channel = rand(455, 490)


/datum/regular_sound/proc/updateSound(var/atom/source)
	if(status == "on")
		for(var/mob/M in listeners)
			if(!(M in hearers(radius, source.loc)))
				M << sound(null, channel)
				listeners.Remove(M)
		for(var/mob/M in hearers(radius, source.loc))
			if(!(M in listeners))
				M << sound(sound_path, repeat = 1, wait = 0, volume = 60, channel)
				listeners.Add(M)


/datum/regular_sound/proc/kill()
	for(var/mob/M in listeners)
		M << sound(null, channel)
		listeners.Remove(M)
	qdel(src)
*/

/obj/snowfloor_mask
	name = "Snow floor overlay"
	icon = 'icons/turf/overlays.dmi'
	icon_state = "snowfloor"

	New()
		spawn(4)
		if(src.loc)
			var/image/O = new(icon, icon_state)
			src.loc.overlays += O
			qdel(src)



/obj/structure/fallingman
	name = "Colonist in danger"
	icon = 'icons/obj/snowy_event/snowy_icons.dmi'
	icon_state = "colonist_in_danger"
	anchored = 1
	density = 1
	var/mob/living/carbon/human/colonist
	var/time_left = 120
	dir = 1


	New()
		..()
		time_left = rand(120, 240) //you dont know how many time you can hold on
		processing_objects.Add(src)


/obj/structure/fallingman/process()
	time_left--
	if(time_left == 10)
		colonist << SPAN_WARN("You can't hold on anymore!..")
	if(time_left <= 0 || !colonist)
		processing_objects.Remove(src)
		fall()


/obj/structure/fallingman/update_icon()
	overlays.Cut()
	if(colonist)
		var/obj/item/organ/external/head/H = locate(/obj/item/organ/external/head) in colonist.organs
		var/image/I = new(H.icon, H.get_icon())
		if(dir == 2)
			I.pixel_y = I.pixel_y - 12
		else if(dir == 1)
			I.pixel_y = I.pixel_y - 4
		else if(dir == 4)
			I.pixel_y = I.pixel_y - 7
			I.pixel_x = I.pixel_x + 5
		else if(dir == 8)
			I.pixel_y = I.pixel_y - 7
			I.pixel_x = I.pixel_x - 5
		I.overlays += H.hair
		I.overlays += H.facial
		overlays += I
		src.set_dir(dir)


/obj/structure/fallingman/proc/pull_out_colonist()
	if(colonist)
		colonist << SPAN_NOTE("You are in safety now.")
		for(var/direction in list(1,2,4,8))
			if(!istype(get_step(src,direction),/turf/simulated/floor/plating/chasm))
				var/turf/T = get_step(src,direction)
				colonist.loc = T
				colonist.canmove = 1
				colonist.Weaken(3)
				colonist = null
				qdel(src)
				break


/obj/structure/fallingman/proc/pull_in_colonist(var/mob/living/carbon/human/H)
	if(!colonist)
		H.loc = src
		colonist = H
		H.canmove = 0
		for(var/direction in list(1,2,4,8))
			if(!istype(get_step(src,direction),/turf/simulated/floor/plating/chasm))
				src.dir = direction
				update_icon()
				break


/obj/structure/fallingman/proc/fall()
	if(colonist)
		colonist.ghostize()
		if(colonist.gender == MALE)
			if(prob(30))
				playsound(src.loc, 'sound/effects/snowy/Wilhelm.ogg', 60, rand(-50, 50), 10, 1) //AAAaaaAARgHh~ //You know, THAT scream
			else
				playsound(src.loc, 'sound/effects/snowy/male_fall.ogg', 60, rand(-50, 50), 10, 1)
		else if(colonist.gender == FEMALE)
			playsound(src.loc, 'sound/effects/snowy/female_fall.ogg', 60, rand(-50, 50), 10, 1)
		src.visible_message(SPAN_WARN("<b>[colonist.name] falls!</b>"))
	qdel(src)


/obj/structure/fallingman/proc/pulling_out(var/mob/living/carbon/human/user as mob)
	if(do_after(user, 30))
		if(user) //if you try to climb out by yourself
			if(colonist)
				if(!(colonist == user))
					user << SPAN_NOTE("You saved [colonist.name]!")
				else
					if(prob(20))
						fall()
				pull_out_colonist()
			else
				user << SPAN_WARN("That's too late...")


//Need to make messages better
/obj/structure/fallingman/attack_hand(var/mob/living/carbon/human/user as mob)
	if(!colonist)
		qdel(src)
		return
	if(user.a_intent == I_HURT)
		if(user == colonist)
			var/choice = alert("Are you really want to fall into abyss and die?",, "Yes", "No")
			if(choice == "Yes")
				user.visible_message(
					SPAN_WARN("<b>[colonist.name] released hands and just fall down...</b>"),
					SPAN_WARN("<b>You release your hands...</b>")
				)
				fall()
		else
			user.visible_message(
				SPAN_WARN("<b>[user] stepped at hands of [colonist.name]</b>"),
				SPAN_NOTE("<b>You stepped at hands of [colonist.name]...</b>")
			)
			colonist << SPAN_WARN("[user.name] stepped at your hand. <b>How painful!</b>")
			if(prob(50))
				fall()
	else
		if(user == colonist)
			user.visible_message(
				SPAN_NOTE("[colonist.name] trying to get out from the abyss."),
				SPAN_NOTE("You trying to climb out by yourself...")
			)
			pulling_out(user)
		else
			user.visible_message(
				SPAN_NOTE("[user] trying to pull out [colonist.name]"),
				SPAN_NOTE("You trying to pull out [colonist.name]...")
			)
			pulling_out(user)



/obj/structure/fence
	name = "Metal fence"
	icon = 'icons/obj/snowy_event/snowy_icons.dmi'
	icon_state = "fence"
	anchored = 1
	layer = 8
	flags = ON_BORDER
	var/cutted = 0
	var/door = 0
	var/opened = 0
	var/locked = 0


	New()
		if(dir == 1)
			set_dir(2)
		update_icon()


/obj/structure/fence/update_icon()
	..()
	if(door && !opened)
		icon_state = "fence_door"
	if(!door && cutted)
		icon_state = "fence_cutted"
	if(door && opened)
		icon_state = "fence_opened"


/obj/structure/fence/CheckExit(atom/movable/O as mob|obj, target as turf)
	if(get_dir(O.loc, target) == dir)
		if(cutted || (opened && door))
			return 1
		return 0
	return 1


/obj/structure/fence/CanPass(atom/movable/O as mob|obj, turf/target, height=0, air_group=0)
	if(get_dir(loc, target) == dir)
		if(cutted || (opened && door))
			return 1
		return 0
	return 1


/obj/structure/fence/attackby(obj/item/weapon/T as obj, mob/user as mob)
	if(T.sharp && !istype(T, /obj/item/weapon/material/shard))
		if(!cutted && !door)
			user.visible_message(
				SPAN_NOTE("[user] cuts the [src]."),
				SPAN_NOTE("You cut the [src] with your [T.name]")
			)
			cutted = 1
	if(istype(T, /obj/item/device/multitool) && door && !opened && locked)
		user.visible_message(
				SPAN_NOTE("[user] trying to pick lock with [T.name]."),
				SPAN_NOTE("You trying to pick lock...")
			)
		if(do_after(user, 50))
			if(!locked)
				user << SPAN_WARN("Lock is already picked.")
			else
				locked = 1
				user << SPAN_NOTE("Lock is picked!")
		else
			user << SPAN_WARN("You need to stay still.")
	update_icon()


/obj/structure/fence/door
	name = "Metal fence"
	icon = 'icons/obj/snowy_event/snowy_icons.dmi'
	icon_state = "fence_door"
	door = 1
	locked = 1


/obj/structure/fence/door/attack_hand(var/mob/user as mob)
	if(locked)
		user << SPAN_WARN("Door is locked!")
	else
		opened = !opened
	update_icon()