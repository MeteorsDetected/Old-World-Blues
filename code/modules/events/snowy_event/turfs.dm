/turf/simulated/floor/plating/var/last_turf //Here we memorize last turf. if none, returns world.turf


/turf/simulated/floor/plating/wooden
	name = "wooden plating"
	icon_state = "plating_wood"
	icon_plating = "plating_wood"


/turf/simulated/floor/plating/snow
	name = "snow"
	icon = 'icons/obj/snowy_event/snowy_turfs.dmi'
	icon_state = "snow_turf"
	icon_plating = "snow_turf"
	temperature = T0C-25

	New()
		..()
		icon_state = "snow_turf"




/turf/simulated/floor/plating/snow/ex_act(severity)
	return


/turf/simulated/floor/plating/snow/attack_hand(var/mob/user as mob)
	if(user.a_intent == I_GRAB)
		var/obj/item/weapon/snow/S = new(src)
		user.put_in_hands(S)
		user << SPAN_NOTE("You grab some snow.")
		return
	..(user)


/turf/simulated/floor/plating/snow/attackby(obj/item/C as obj, mob/user as mob)
	if(istype(C, /obj/item/stack/tile/steel))
		var/obj/item/stack/tile/T = C
		var/turf/simulated/floor/plating/P = src.ChangeTurf(/turf/simulated/floor/plating)
		P.dynamic_lighting = dynamic_lighting
		P.luminosity = luminosity
		P.last_turf = src.type
		T.use(1)
		if(T.get_amount() < 1)
			qdel(T)
		return
	if(istype(C, /obj/item/stack/tile/wood))
		var/obj/item/stack/tile/T = C
		var/turf/simulated/floor/plating/P = src.ChangeTurf(/turf/simulated/floor/plating/wooden)
		P.dynamic_lighting = dynamic_lighting
		P.luminosity = luminosity
		P.last_turf = src.type
		T.use(1)
		if(T.get_amount() < 1)
			qdel(T)
		return
	if(istype(C, /obj/item/stack/cable_coil))
		var/obj/item/stack/cable_coil/coil = C
		coil.turf_place(src, user)



/turf/simulated/floor/plating/snow/Entered(mob/living/user as mob)
	..()
	if(!floor_type)
		if(istype(user, /mob/living))
			if(prob(15))
				var/p = pick('sound/effects/snowy/snow_step1.ogg', 'sound/effects/snowy/snow_step2.ogg', 'sound/effects/snowy/snow_step3.ogg')
				playsound(src, p, 15, rand(-50, 50))
			var/image/I = image(icon, "footprint[1]", dir = user.dir)
			I.pixel_x = rand(-6, 6)
			I.pixel_y = rand(-6, 6)
			overlays += I
			spawn(1200) //Hm. Maybe that's a bad idea. Or not?..
				overlays -= I


/turf/simulated/floor/plating/snow/Exited(mob/living/user as mob)
	..()
	if(!floor_type)
		if(istype(user, /mob/living))
			var/image/I = image(icon, "footprint[2]", dir = user.dir)
			I.pixel_x = rand(-6, 6)
			I.pixel_y = rand(-6, 6)
			overlays += I
			spawn(1200)
				overlays -= I



/turf/simulated/floor/plating/snow/generable
	icon_state = "snow_forest"
	var/bush_factor = 1 //helper. Dont change or use it please



//I know, all of that and previous generation is shit and needed to coded separatly with masks. But i have't so much time to dig it up
//Sorry. Maybe i remake it to good version

//Another long shit. Hell!
/turf/simulated/floor/plating/snow/generable/proc/forest_gen(spawn_chance, trees, tree_chance, bushes, bush_chance, bush_density, stumps, stump_chance, additions)
	if(!istype(src, /turf/simulated/floor/plating/snow/generable))
		return
	if(locate(/obj) in src) //If something here, return
		return
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
			if(isnum(additions[p]))
				if(prob(additions[p]))
					equal_chances.Add(p)
			else
				switch(additions[p])
					if("rare")
						if(rand(1, 100) == 1) // 1:100
							new p(src)
							return
					if("very rare")
						if(rand(1, 250) == 1) // 1:250
							new p(src)
							return
					if("extra rare")
						if(rand(1, 500) == 1) // 1:500
							new p(src)
							return
		if(equal_chances.len)
			var/to_spawn = pick(equal_chances)
			new to_spawn(src)


/turf/simulated/floor/plating/snow/generable/proc/bush_gen(var/chance, var/bush) //play with this carefully
	for(var/dir in alldirs)
		if(istype(get_step(src, dir), /turf/simulated/floor/plating/snow/generable))
			var/turf/simulated/floor/plating/snow/generable/K = get_step(src, dir)
			if(!(locate(/obj) in K))
				if(prob(chance/src.bush_factor))
					K.bush_factor = src.bush_factor + 1
					new bush(K)
					bush_gen()


/turf/simulated/floor/plating/chasm
	name = "chasm"
	desc = "Dark bottomless abyss."
	icon = 'icons/obj/snowy_event/snowy_turfs.dmi'
	icon_state = "chasm"

	New()
		..()
		spawn(4)
			if(src && istype(src, /turf/simulated/floor/plating/chasm))
				update_icon()
				for(var/direction in list(1,2,4,8,5,6,9,10))
					if(istype(get_step(src,direction),/turf/simulated/floor/plating/chasm))
						var/turf/simulated/floor/plating/chasm/FF = get_step(src,direction)
						FF.update_icon()


/turf/simulated/floor/plating/chasm/ex_act(severity)
	return

/turf/simulated/floor/plating/chasm/update_icon()
	overlays.Cut()
	var/nums = 0
	var/list/our_dirs = list()
	for(var/direction in list(1, 4, 2, 8))
		if(istype(get_step(src,direction),/turf/simulated/floor/plating/chasm))
			nums += direction
			our_dirs.Add(direction)
	if(nums && nums != 15)
		icon_state = "chasm-[nums]"
	if(our_dirs.len > 1)
		for(var/i = 1, i<=our_dirs.len, i++)
			var/next_dir = i+1
			if(i == our_dirs.len)
				next_dir = 1
			var/sum_dir = our_dirs[i] + our_dirs[next_dir]
			if(!istype(get_step(src, sum_dir), /turf/simulated/floor/plating/chasm))
				overlays += "corner-[sum_dir]"


/turf/simulated/floor/plating/chasm/attackby(obj/item/C as obj, mob/user as mob)
	if(istype(C, /obj/item/blueprints/ckit))
		if(!locate(/obj/structure/bridge) in src)
			user << SPAN_NOTE("You build the bridge girders.")
			qdel(C)
			var/obj/structure/bridge/B = new(src)
			B.dir = user.dir
			B.update_icon()
		else
			user << SPAN_WARN("Bridge is already at this location.")


/turf/simulated/floor/plating/chasm/proc/eat(atom/movable/M as mob|obj)
	if(istype(M, /obj/item/projectile))
		return
	var/obj/structure/bridge/Bridge = locate() in src
	if(Bridge && Bridge.planks >= 5)
		Bridge.stepped(M)
		return
	if(istype(M, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = M
		if(H.stat != DEAD)
			var/can_clutch = 0
			for(var/direction in list(1,2,4,8))
				if(!istype(get_step(src,direction), /turf/simulated/floor/plating/chasm) || locate(/obj/structure/bridge) in get_step(src, direction))
					can_clutch = 1
					break
			if(can_clutch)
				var/obj/structure/fallingman/F = new(src)
				F.pull_in_colonist(M)
			else
				H.ghostize()
				qdel(M)
				src.visible_message(SPAN_WARN("[M.name] falling in the abyss!"))
		else
			src.visible_message(SPAN_WARN("[M.name] falling in the abyss!")) //meh, these three... I fix it later maybe
			if(H.ckey)
				H.ghostize()
			qdel(M)
	else if(!istype(M, /mob/observer))
		src.visible_message(SPAN_WARN("[M.name] falling in the abyss!"))
		qdel(M)


/turf/simulated/floor/plating/chasm/Entered(atom/movable/M as mob|obj)
	if(M.throwing)
		spawn(5) //Hm. Can't find need proc and hitby not working. Dont know why nobody puts Entered() under else at impact
			if(M.loc == src)
				eat(M)
	else
		eat(M)


/turf/simulated/floor/plating/ice
	name = "ice"
	icon = 'icons/obj/snowy_event/snowy_turfs.dmi'
	icon_state = "ice1"
	icon_plating = "ice1"

	New()
		..()
		icon_state = "ice[rand(1, 5)]"


/turf/simulated/floor/plating/ice/ex_act(severity)
	return

//need to add effects and sound here
/turf/simulated/floor/plating/ice/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(W.sharp && !istype(W, /obj/item/weapon/wirecutters) && !istype(W, /obj/item/weapon/material/shard))
		var/obj/structure/ice_hole/I = locate(/obj/structure/ice_hole) in src
		if(I)
			user << SPAN_WARN("Ice is already are cracked here.")
		else
			user << SPAN_NOTE("You cracks trough the ice with your [W.name]...")
			if(do_after(user, 30))
				I = locate(/obj/structure/ice_hole) in src
				if(I)
					user << SPAN_WARN("Ice is already are cracked here.")
				else
					new /obj/structure/ice_hole(src)
				user << SPAN_NOTE("A few time ago you can see water under thin layer of ice.")
			else
				user << SPAN_WARN("You need to stay still.")


//I rework it to something better later
/turf/simulated/floor/plating/ice/Entered(var/mob/living/A)
	if(A.last_move && prob(10))
		if(istype(A, /mob/living/carbon/human))
			if(A.m_intent == "walk")
				return
		if(prob(30) && istype(A, /mob/living/carbon/human))
			A << SPAN_WARN("You slipped!")
			A.Weaken(2)
			var/direction = pick(alldirs)
			step(A, direction)
	..(A)


/turf/unsimulated/snow
	name = "snow"
	icon = 'icons/obj/snowy_event/snowy_turfs.dmi'
	icon_state = "freezer"
	temperature = T0C - 30

	New()
		..()
		icon_state = "snow_turf"



/turf/simulated/wall/wood

/turf/simulated/wall/wood/New(var/newloc)
	..(newloc,MATERIAL_WOOD)



/turf/simulated/wall/wood/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(istype(W, /obj/item/weapon/weldingtool))
		return
	else if(istype(W, /obj/item/weapon/crowbar))
		user << SPAN_NOTE("You pry wooden panels...")
		if(do_after(user, 40))
			if(src)
				dismantle_wall()
	else
		..()



/turf/simulated/wall/wood/dismantle_wall(var/devastated, var/explode, var/no_product)
	playsound(src, 'sound/items/Deconstruct.ogg', 100, 1)
	if(!no_product) //Yeah, another copypast. That inconvenient proc does not allow do otherwise
		material.place_dismantled_product(src,devastated)
		new /obj/structure/girder/wooden(src)

	for(var/obj/O in src.contents) //Eject contents!
		if(istype(O,/obj/item/weapon/contraband/poster))
			var/obj/item/weapon/contraband/poster/P = O
			P.roll_and_drop(src)
		else
			O.loc = src

	clear_plants()
	material = get_material_by_name("placeholder")
	reinf_material = null
	check_relatives()

	ChangeTurf(/turf/simulated/floor/plating/wooden) //Hm. Need to memory last tile...


//mining stuff

//can't find where ore actually spawns. Ore data list is empty. There's no docs or something like ref. So go fuck this pile of shit.
//i'm just make my own. Very fast. Very simple.

//need to find some frozen stones for this
/turf/simulated/mineral/random/snowy
	mineralSpawnChanceList = list(/ore/uranium = 5, /ore/platinum = 5, /ore/hematite = 35, /ore/coal = 35, /ore/diamond = 1, /ore/gold = 5, /ore/silver = 5, /ore/phoron = 10)
	mineralChance = 10

/turf/simulated/mineral/random/snowy/New()
	if (prob(mineralChance) && !mineral)
		var/mineral_path
		for(var/O in mineralSpawnChanceList)
			if(prob(mineralSpawnChanceList[O]))
				mineral_path = O
		if (mineral_path && (mineral_path in mineralSpawnChanceList))
			mineral = new mineral_path
			UpdateMineral()
			MineralSpread()

	. = ..()

