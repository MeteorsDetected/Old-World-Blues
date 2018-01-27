
/turf/simulated/floor/plating/snow
	name = "snow"
	icon = 'icons/obj/snowy_event/snowy_turfs.dmi'
	icon_state = "snow_turf"

/turf/simulated/floor/plating/snow/relaymove(atom/movable/A as mob|obj)
	return

/turf/simulated/floor/plating/snow/ex_act(severity)
	return



/turf/simulated/floor/plating/snow/light_forest
	dynamic_lighting = 1
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




/turf/simulated/floor/plating/chasm
	name = "chasm"
	desc = "Dark bottomless abyss."
	icon = 'icons/obj/snowy_event/snowy_turfs.dmi'
	icon_state = "chasm"
	dynamic_lighting = 1

	New()
		..()
		spawn(4)
			if(src)
				update_icon()
				for(var/direction in list(1,2,4,8,5,6,9,10))
					if(istype(get_step(src,direction),/turf/simulated/floor/plating/chasm))
						var/turf/simulated/floor/plating/chasm/FF = get_step(src,direction)
						FF.update_icon()


/turf/simulated/floor/plating/chasm/update_icon()
	var/nums = 0
	for(var/direction in list(1, 4, 2, 8))
		if(istype(get_step(src,direction),/turf/simulated/floor/plating/chasm))
			nums += direction
	if(nums)
		icon_state = "chasm-[nums]"


/turf/simulated/floor/plating/chasm/Entered(atom/movable/M as mob|obj)
	if(istype(M, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = M
		if(H.stat != DEAD)
			var/obj/structure/fallingman/F = new(src)
			F.pull_in_colonist(M)
	else
		src.visible_message("[M.name] falling in the abyss!")
		qdel(M)


/turf/simulated/floor/plating/ice
	name = "ice"
	icon = 'icons/obj/snowy_event/snowy_turfs.dmi'
	icon_state = "ice1"

	New()
		..()
		icon_state = "ice[rand(1, 5)]"

/turf/simulated/floor/plating/ice/Entered(var/mob/living/A)
	if(A.last_move && prob(10))
		if(istype(A, /mob/living/carbon/human))
			if(A.intent == "walk")
				return
		A << SPAN_NOTE("You slips away!")
		var/direction = pick(alldirs)
//		if(
		step(A, direction)
		if(prob(10) && istype(A, /mob/living/carbon/human))
			A.Weaken(2)



//I move it later
/obj/structure/fallingman
	name = "Colonist in danger"
	icon = 'icons/obj/snowy_event/snowy_icons.dmi'
	icon_state = "colonist_in_danger"
	var/mob/living/carbon/human/colonist
	dir = 1


/obj/structure/fallingman/update_icon()
	overlays.Cut()
	if(colonist)
		var/obj/item/organ/external/head/H = locate(/obj/item/organ/external/head) in colonist.organs
		var/image/I = new(H.icon, H.get_icon())
		if(dir == 2)
			I.pixel_y = I.pixel_y - 12
		else if(dir == 1)
			I.pixel_y = I.pixel_y + 3
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



/obj/structure/fallingman/attack_hand(var/mob/living/carbon/human/user as mob)
	if(!colonist)
		qdel(src)
		return
	//if(user == colonist) return
	user << SPAN_NOTE("You trying to pull out [colonist.name]...")
	if(do_after(user, 30))
		if(colonist)
			user << SPAN_NOTE("You saved [colonist.name]!")
			pull_out_colonist()
		else
			user << SPAN_WARN("That's too late...")
