
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


/turf/simulated/floor/plating/snow/light_forest
	var/bush_factor = 1 //helper. Dont change or use it please

	New()
		..()
		spawn(4)
			if(src)
				forest_gen(20, list(/obj/structure/flora/snowytree/big/another, /obj/structure/flora/snowytree/big, /obj/structure/flora/snowytree), 40,
								list(/obj/structure/flora/snowybush/deadbush, /obj/structure/flora/snowybush, /obj/structure/lootable/mushroom_hideout), 10, 40,
								list(/obj/structure/flora/stump/fallen, /obj/structure/flora/stump), 20,
								list(/obj/item/weapon/branches = 10, /obj/structure/rock = 3, /obj/structure/lootable = 2, /obj/structure/butcherable = 1))


//I know, all of that and previous generation is shit and needed to coded separatly with masks. But i have't so much time to dig it up
//Sorry. Maybe i remake it to good version

//Another long shit. Hell!
/turf/simulated/floor/plating/snow/light_forest/proc/forest_gen(spawn_chance, trees, tree_chance, bushes, bush_chance, bush_density, stumps, stump_chance, additions)
	if(prob(spawn_chance))
		if(prob(tree_chance))
			var/obj/structure/S = pick(trees)
			new S(src)
			if(prob(8))
				var/obj/structure/lootable/mushroom_hideout/tree_mush/TM = new /obj/structure/lootable/mushroom_hideout/tree_mush(src)
				TM.layer = 10
			return
		if(prob(bush_chance))
			var/obj/structure/B = pick(bushes)
			new B(src)
			bush_gen(bush_density, B)
			return
		if(prob(stump_chance))
			var/obj/structure/L = pick(stumps)
			new L(src)
			return
		var/list/equal_chances = list()
		for(var/p in additions)
			if(prob(additions[p]))
				equal_chances.Add(p)
		if(equal_chances.len)
			var/to_spawn = pick(equal_chances)
			new to_spawn(src)


/turf/simulated/floor/plating/snow/light_forest/proc/bush_gen(var/chance, var/bush) //play with this carefully
	for(var/dir in alldirs)
		if(istype(get_step(src, dir), /turf/simulated/floor/plating/snow))
			var/turf/simulated/floor/plating/snow/light_forest/K = get_step(src, dir)
			var/obj/structure/B = locate(/obj/structure) in K
			if(!B)
				if(prob(chance/src.bush_factor))
					K.bush_factor = src.bush_factor + 1
					new bush(K)
					bush_gen()


/turf/simulated/floor/plating/snow/light_forest/pines

	New()
		spawn(4)
			if(src)
				forest_gen(30, list(/obj/structure/flora/snowytree/high), 35,
								list(/obj/structure/flora/snowybush/deadbush), 20, 40,
								list(/obj/structure/flora/stump/fallen, /obj/structure/flora/stump, /obj/structure/lootable/mushroom_hideout), 20,
								list(/obj/item/weapon/branches = 10, /obj/structure/rock = 3, /obj/structure/lootable = 2, /obj/structure/butcherable = 1))


/turf/simulated/floor/plating/snow/light_forest/mixed

	New()
		spawn(4)
			if(src)
				forest_gen(50, list(/obj/structure/flora/snowytree/high, /obj/structure/flora/snowytree/big/another, /obj/structure/flora/snowytree/big, /obj/structure/flora/snowytree), 35,
								list(/obj/structure/flora/snowybush/deadbush, /obj/structure/flora/snowybush), 20, 40,
								list(/obj/structure/flora/stump/fallen, /obj/structure/flora/stump, /obj/structure/lootable/mushroom_hideout), 20,
								list(/obj/item/weapon/branches = 10, /obj/structure/rock = 3, /obj/structure/lootable = 2, /obj/structure/butcherable = 1))