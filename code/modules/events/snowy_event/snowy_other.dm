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


/area/outdoor
	name = "Outdoor"
	icon = 'icons/obj/snowy_event/snowy_icons.dmi'
	icon_state = "outdoor_area"
	requires_power = 1
	always_unpowered = 1
	lighting_use_dynamic = 0
	power_light = 0
	power_equip = 0
	power_environ = 0
	ambience = list(
		'sound/effects/wind/wind_2_1.ogg','sound/effects/wind/wind_2_2.ogg','sound/effects/wind/wind_3_1.ogg',
		'sound/effects/wind/wind_4_1.ogg','sound/effects/wind/wind_4_2.ogg','sound/effects/wind/wind_5_1.ogg'
	)


/area/indoor
	name = "Indoor"
	icon = 'icons/obj/snowy_event/snowy_icons.dmi'
	icon_state = "indoor_area"


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


/obj/structure/girder/wooden
	name = "wooden wall girders"
	desc = "reliable girders for wall."
	icon = 'icons/obj/snowy_event/snowy_icons.dmi'
	icon_state = "wooden_girder"



/obj/structure/girder/wooden/dismantle()
	new /obj/item/stack/material/wood(get_turf(src))
	qdel(src)


/obj/structure/girder/wooden/construct_wall(obj/item/stack/material/S, mob/user)
	if(istype(S, /obj/item/stack/material/wood))
		if(S.get_amount() < 2)
			user << SPAN_NOTE("There isn't enough material here to construct a wall.")
			return 0

		var/material/M = name_to_material[S.default_type]
		if(!istype(M))
			return 0

		var/wall_fake
		add_hiddenprint(usr)

		if(M.integrity < 25)
			user << SPAN_NOTE("This material is too soft for use in wall construction.")
			return 0

		user << SPAN_NOTE("You begin adding the plating...")

		if(!do_after(user,40) || !S.use(2))
			return 1 //once we've gotten this far don't call parent attackby()

		if(anchored)
			user << SPAN_NOTE("You added the plating!")
		else
			user << SPAN_NOTE("You create a false wall! Push on it to open or close the passage.")
			wall_fake = 1

		var/turf/Tsrc = get_turf(src)
		Tsrc.ChangeTurf(/turf/simulated/wall/wood)
		var/turf/simulated/wall/T = get_turf(src)
		T.set_material(M, reinf_material)
		if(wall_fake)
			T.can_open = 1
		T.add_hiddenprint(usr)
		qdel(src)
		return 1
	else
		user << SPAN_WARN("This girder is slimpsy for that material.")


/obj/structure/girder/wooden/attackby(obj/item/W as obj, mob/user as mob)
	if((istype(W, /obj/item/weapon/wrench) || istype(W, /obj/item/weapon/crowbar)) && anchored)
		return
	else
		..()


/obj/structure/girder/wooden/attack_hand(mob/user as mob)
	user << SPAN_NOTE("Now disassembling the girder...")
	if(do_after(user,40))
		if(!src) return
		user << SPAN_NOTE("You dissasembled the girder!")
		dismantle()





//////////////SOME KIND OF A CHILL MECHANICS///////////////
//Bulky and slightly shitty. I rework it asap

//Need to rework it to better version. And faster. But later
//Well. I maked it simple, without Newton's law of cooling or other formulas
//if body part not covered -1c per part
//if body part covered, but clothes is meeeeh and not for winter is -0.5c
//if body part covered with winter stuff but min temperature of protection is lowes than env, is -0.3c
//if body part covered well - -0.1c
//but if you wear spess suit, you got 0

/mob/living/carbon/human/var/last_chill_tick = 0 //Chill updates every 3 ticks. That's slow enough i think

/mob/living/carbon/human/proc/snowyTemperatureHandler(var/env_temp)
	//All of these bitflags and organs hard to tie. Hm.
	if(stat == DEAD && in_stasis)
		return
	var/list/parts = list()
	var/list/flags_bp = list(UPPER_TORSO, LOWER_TORSO, HEAD, ARMS, ARMS, HANDS, HANDS, LEGS, LEGS, FEET, FEET)
	var/i = 0
	for(var/part in BP_ALL) //At first, we setup our list. Yes, this is slowly...
		i++
		var/list/L = list("part" = part, "flag" = flags_bp[i], "temp" = 1)
		parts.Add(list(L))

	var/list/clothes = list(head, wear_mask, wear_suit, w_uniform, gloves, shoes)
	for(var/obj/item/clothing/C in clothes)
		var/t = 1
		if(istype(C, /obj/item/clothing/suit/space))
			return 0
		if(C.cold_protection && C.min_cold_protection_temperature >= env_temp)
			t = 0.1
		else if(C.cold_protection && C.min_cold_protection_temperature < env_temp)
			t = 0.3
		else
			t = 0.5
		for(var/list/p in parts)
			if(C.body_parts_covered & p["flag"])
				p["temp"] = t*2 //Yeah. Let's make this harder. Later i rework all of that and made it based on env temperature


	if(bodytemperature <= T0C-5 && bodytemperature > T0C-10)
		if(prob(10))
			src << SPAN_WARN("You feel your limbs badly. Chill bites into the skin.")
	else if(bodytemperature <= T0C-10 && bodytemperature > T0C-20)
		if(prob(10))
			src << SPAN_WARN("You almost not feel your limbs. Your eyelids close...")

	var/G = 0
	for(var/list/part in parts)
		if(bodytemperature <= T0C-20)
			if(!istype(loc, /obj/machinery/atmospherics/unary/cryo_cell))
				apply_damage(part["temp"],  BURN, part["part"],  0, 0, "Freeze")
		G += part["temp"]
	last_chill_tick = 0
	G = G/parts.len
	return G




////////////////Rails>>>

obj/machinery/lightrail
	name = "rail with light"
	icon = 'icons/obj/snowy_event/snowy_icons.dmi'
	icon_state = "rail_light"
	anchored = 1
	use_power = 1
	idle_power_usage = 4
	var/light_on = 1
	pass_flags = PASSTABLE


obj/machinery/lightrail/update_icon()
	overlays.Cut()
	overlays += "light_on"


obj/machinery/lightrail/process()
	..()
	if(stat & (NOPOWER))
		update_use_power(0)
		light_on = 0
		if(!light_on)
			update_icon()
			set_light(2, 0.5, "#ff1a1a")
		return
	else
		light_on = 1
		if(light_on)
			update_icon()
			set_light(6, 1, "#ffff80")

/obj/structure/snowyrail
	name = "rails"
	icon = 'icons/obj/snowy_event/snowy_icons.dmi'
	icon_state = "rail"
	anchored = 1

/obj/structure/snowyrail/tie
	name = "tie"
	icon_state = "tie"

/obj/structure/snowyrail/railtie
	icon_state = "railtie"

/obj/structure/snowyrail/deadend
	name = "dead end"
	icon_state = "deadend"

/obj/structure/snowyrail/device
	icon_state = "device"



//Some special reagents

/datum/reagent/nutriment/protein/fish
	name = "fish"
	taste_description = "fish"
	id = "fish"