
/obj/structure/rock
	name = "Rock"
	desc = "Cold and big rock. Looks tough."
	icon = 'icons/obj/snowy_event/snowy_icons.dmi'
	icon_state = "rock"
	anchored = 1
	density = 1

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