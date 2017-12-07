/**********************Miner Lockers**************************/

/obj/structure/closet/secure_closet/miner
	name = "miner's equipment"
	icon_state = "miningsec"
	icon_opened = "miningsecopen"
	icon_broken = "miningsecbroken"
	req_access = list(access_mining)

/obj/structure/closet/secure_closet/miner/New()
	..()
	switch(rand(4))
		if(1) new /obj/item/storage/backpack/industrial(src)
		if(2) new /obj/item/storage/backpack/satchel/eng(src)
		if(3) new /obj/item/storage/backpack/dufflebag/eng(src)
		if(4) new /obj/item/storage/backpack/messenger/eng(src)
	new /obj/item/device/radio/headset/cargo(src)
	new /obj/item/clothing/under/rank/miner(src)
	new /obj/item/clothing/gloves/black(src)
	new /obj/item/clothing/shoes/black(src)
	new /obj/item/device/analyzer(src)
	new /obj/item/storage/bag/ore(src)
	new /obj/item/device/flashlight/lantern(src)
	new /obj/item/weapon/shovel(src)
	if(prob(50))
		new /obj/item/weapon/pickaxe(src)
	else
		new /obj/item/weapon/pickaxe/drill(src)
	new /obj/item/clothing/glasses/material(src)

/******************************Lantern*******************************/

/obj/item/device/flashlight/lantern
	name = "lantern"
	icon_state = "lantern"
	desc = "A mining lantern."
	brightness_on = 6			// luminosity when on

/*****************************Pickaxe********************************/

/obj/item/weapon/pickaxe
	name = "power pickaxe"
	desc = "STRIKE THE GROUND! DIG A HOLE!"
	icon = 'icons/obj/items.dmi'
	flags = CONDUCT
	slot_flags = SLOT_BELT
	force = 15.0
	throwforce = 4.0
	icon_state = "pickaxe"
	item_state = "pickaxe"
	w_class = ITEM_SIZE_HUGE
	matter = list(MATERIAL_STEEL = 3750)
	var/digspeed = 40 //moving the delay to an item var so R&D can make improved picks. --NEO
	origin_tech = list(TECH_MATERIAL = 1, TECH_ENGINEERING = 1)
	attack_verb = list("hit", "dug", "sliced", "attacked")
	var/drill_sound = 'sound/weapons/Genhit.ogg'
	var/drill_verb = "digging"
	sharp = 1

	var/excavation_amount = 100

/obj/item/weapon/pickaxe/drill
	name = "mining drill"
	desc = "The most basic of mining drills, for short excavations and small mineral extractions."
	item_state = "pickaxe"
	attack_verb = list("hit", "pierced", "sliced", "attacked")
	drill_verb = "drilling"

/obj/item/weapon/pickaxe/hammer
	name = "sledgehammer"
	//icon_state = "sledgehammer" Waiting on sprite
	desc = "A mining hammer made of reinforced metal. You feel like smashing your boss in the face with this."

/obj/item/weapon/pickaxe/silver
	name = "silver pickaxe"
	icon_state = "spickaxe"
	item_state = "spickaxe"
	digspeed = 30
	origin_tech = list(TECH_MATERIAL = 3)
	desc = "This makes no metallurgic sense."

/obj/item/weapon/pickaxe/drill
	name = "advanced mining drill" // Can dig sand as well!
	icon_state = "handdrill"
	item_state = "jackhammer"
	digspeed = 30
	origin_tech = list(TECH_MATERIAL = 2, TECH_POWER = 3, TECH_ENGINEERING = 2)
	desc = "Yours is the drill that will pierce through the rock walls."
	drill_verb = "drilling"

/obj/item/weapon/pickaxe/jackhammer
	name = "sonic jackhammer"
	icon_state = "jackhammer"
	item_state = "jackhammer"
	digspeed = 20 //faster than drill, but cannot dig
	origin_tech = list(TECH_MATERIAL = 3, TECH_POWER = 2, TECH_ENGINEERING = 2)
	desc = "Cracks rocks with sonic blasts, perfect for killing cave lizards."
	drill_verb = "hammering"

/obj/item/weapon/pickaxe/gold
	name = "golden pickaxe"
	icon_state = "gpickaxe"
	item_state = "gpickaxe"
	digspeed = 20
	origin_tech = list(TECH_MATERIAL = 4)
	desc = "This makes no metallurgic sense."
	drill_verb = "picking"

/obj/item/weapon/pickaxe/plasmacutter
	name = "plasma cutter"
	icon_state = "plasmacutter"
	item_state = "gun"
	w_class = ITEM_SIZE_NORMAL //it is smaller than the pickaxe
	damtype = "fire"
	digspeed = 20 //Can slice though normal walls, all girders, or be used in reinforced wall deconstruction/ light thermite on fire
	origin_tech = list(TECH_MATERIAL = 4, TECH_PHORON = 3, TECH_ENGINEERING = 3)
	desc = "A rock cutter that uses bursts of hot plasma. You could use it to cut limbs off of xenos! Or, you know, mine stuff."
	drill_verb = "cutting"
	drill_sound = 'sound/items/Welder.ogg'
	sharp = 1
	edge = 1

/obj/item/weapon/pickaxe/diamond
	name = "diamond pickaxe"
	icon_state = "dpickaxe"
	item_state = "dpickaxe"
	digspeed = 10
	origin_tech = list(TECH_MATERIAL = 6, TECH_ENGINEERING = 4)
	desc = "A pickaxe with a diamond pick head."
	drill_verb = "picking"

/obj/item/weapon/pickaxe/diamonddrill //When people ask about the badass leader of the mining tools, they are talking about ME!
	name = "diamond mining drill"
	icon_state = "diamonddrill"
	item_state = "jackhammer"
	digspeed = 5 //Digs through walls, girders, and can dig up sand
	origin_tech = list(TECH_MATERIAL = 6, TECH_POWER = 4, TECH_ENGINEERING = 5)
	desc = "Yours is the drill that will pierce the heavens!"
	drill_verb = "drilling"

/obj/item/weapon/pickaxe/borgdrill
	name = "cyborg mining drill"
	icon_state = "diamonddrill"
	item_state = "jackhammer"
	digspeed = 15
	desc = ""
	drill_verb = "drilling"

/*****************************Shovel********************************/

/obj/item/weapon/shovel
	name = "shovel"
	desc = "A large tool for digging and moving dirt."
	icon = 'icons/obj/items.dmi'
	icon_state = "shovel"
	flags = CONDUCT
	slot_flags = SLOT_BELT
	force = 8.0
	throwforce = 4.0
	item_state = "shovel"
	w_class = ITEM_SIZE_HUGE
	origin_tech = list(TECH_MATERIAL = 1, TECH_ENGINEERING = 1)
	matter = list(MATERIAL_STEEL = 50)
	attack_verb = list("bashed", "bludgeoned", "thrashed", "whacked")
	sharp = 0
	edge = 1

/obj/item/weapon/shovel/spade
	name = "spade"
	desc = "A small tool for digging and moving dirt."
	icon_state = "spade"
	item_state = "spade"
	force = 5.0
	throwforce = 7.0
	w_class = ITEM_SIZE_SMALL


/**********************Mining car (Crate like thing, not the rail car)**************************/

/obj/structure/closet/crate/miningcar
	desc = "A mining car. This one doesn't work on rails, but has to be dragged."
	name = "Mining car (not for rails)"
	icon = 'icons/obj/storage.dmi'
	icon_state = "miningcar"
	density = 1
	icon_opened = "miningcaropen"

// Flags.

/obj/item/stack/flag
	name = "flags"
	desc = "Some colourful flags."
	singular_name = "flag"
	amount = 10
	max_amount = 10
	icon = 'icons/obj/mining.dmi'
	var/upright = 0
	var/base_state

/obj/item/stack/flag/New()
	..()
	base_state = icon_state

/obj/item/stack/flag/red
	name = "red flags"
	singular_name = "red flag"
	icon_state = "redflag"

/obj/item/stack/flag/yellow
	name = "yellow flags"
	singular_name = "yellow flag"
	icon_state = "yellowflag"

/obj/item/stack/flag/green
	name = "green flags"
	singular_name = "green flag"
	icon_state = "greenflag"

/obj/item/stack/flag/attackby(obj/item/W as obj, mob/user as mob)
	if(upright && istype(W,src.type))
		src.attack_hand(user)
	else
		..()

/obj/item/stack/flag/attack_hand(user as mob)
	if(upright)
		upright = 0
		icon_state = base_state
		anchored = 0
		src.visible_message("<b>[user]</b> knocks down [src].")
	else
		..()

/obj/item/stack/flag/attack_self(mob/user as mob)

	var/obj/item/stack/flag/F = locate() in get_turf(src)

	var/turf/T = get_turf(src)
	if(!T || !istype(T,/turf/simulated/floor/plating/airless/asteroid))
		user << "The flag won't stand up in this terrain."
		return

	if(F && F.upright)
		user << "There is already a flag here."
		return

	var/obj/item/stack/flag/newflag = new src.type(T)
	newflag.amount = 1
	newflag.upright = 1
	anchored = 1
	newflag.name = newflag.singular_name
	newflag.icon_state = "[newflag.base_state]_open"
	newflag.visible_message("<b>[user]</b> plants [newflag] firmly in the ground.")
	src.use(1)

/******************************Seismic Charge*******************************/

/obj/item/weapon/plastique/seismic
	name = "seismic charge"
	desc = "A complex mining device that utilizes a seismic detonation to eliminate weak asteroid turf in a wide radius."
	origin_tech = list(TECH_MAGNET = 2, TECH_MATERIAL = 4, TECH_PHORON = 2)
	timer = 15

/obj/item/weapon/plastique/seismic/explode(var/turf/location)
	if(!target)
		target = get_atom_on_turf(src)
	if(!target)
		target = src
	if(location)
		explosion(location, -1, -1, 2, 3)
		playsound(location, 'sound/effects/Explosion1.ogg', 100, 1)
		for(var/atom/A in range(4,location))
			if(istype(A,/turf/simulated/mineral))
				var/turf/simulated/mineral/M = A
				M.GetDrilled(1)
			else if(istype(A, /turf/simulated/wall) && prob(66))
				var/turf/simulated/wall/W = A
				W.ex_act(2)
			else if(istype(A, /obj/structure/window))
				var/obj/structure/window/WI = A
				WI.ex_act(3)
			else if(istype(A,/mob/living))
				var/mob/living/LI = A
				LI << 'sound/effects/Explosion1.ogg'
				if(iscarbon(LI))
					var/mob/living/carbon/L = A
					L.Weaken(3)
					if(ishuman(L))
						shake_camera(L, 20, 1)

		spawn(2)
			for(var/turf/simulated/mineral/M in range(7,location))
				if(prob(75))
					M.GetDrilled(1)

	if(target)
		target.overlays -= image_overlay
	qdel(src)

/**********************Point Transfer Card**********************/

/obj/item/weapon/card/mining_point_card
	name = "mining points card"
	desc = "A small card preloaded with mining points. Swipe your ID card over it to transfer the points, then discard."
	icon_state = "data"
	var/points = 500

/obj/item/weapon/card/mining_point_card/attackby(obj/item/I, mob/user, params)
	if(istype(I, /obj/item/weapon/card/id))
		if(points)
			var/obj/item/weapon/card/id/C = I
			C.mining_points += points
			user << "<span class='info'>You transfer [points] points to [C].</span>"
			points = 0
		else
			user << "<span class='info'>There's no points left on [src].</span>"
	..()

/obj/item/weapon/card/mining_point_card/examine(mob/user)
	..()
	user << "There's [points] point\s on the card."

/**********************Jaunter**********************/

/obj/item/device/wormhole_jaunter
	name = "wormhole jaunter"
	desc = "A single use device harnessing outdated warp technology. The wormholes it creates are unpleasant to travel through, to say the least."
	icon = 'icons/obj/mining_contained.dmi'
	icon_state = "jaunter"
	item_state = "jaunter"
	throwforce = 0
	w_class = 2
	throw_speed = 3
	throw_range = 5
	slot_flags = SLOT_BELT
	origin_tech = list(TECH_BLUESPACE = 2, TECH_PHORON = 4, TECH_ENGINEERING = 4)

/obj/item/device/wormhole_jaunter/attack_self(mob/user)
	user.visible_message("<span class='notice'>[user.name] activates the [src.name]!</span>")
	activate(user)

/obj/item/device/wormhole_jaunter/proc/turf_check(mob/user)
	var/turf/device_turf = get_turf(user)
	if(!device_turf||device_turf.z==0)
		user << "<span class='notice'>You're having difficulties getting the [src.name] to work.</span>"
		return FALSE
	return TRUE

/obj/item/device/wormhole_jaunter/proc/get_destinations(mob/user)
	var/list/destinations = list()

	for(var/obj/item/device/radio/beacon/B in world)
		var/turf/T = get_turf(B)
		if(T.z == 1 || T.z == 2 || T.z == 3)//Hardcode for z-lvls
			destinations += B

	return destinations

/obj/item/device/wormhole_jaunter/proc/activate(mob/user)
	if(!turf_check(user))
		return

	var/list/L = get_destinations(user)
	if(!L.len)
		user << "<span class='notice'>The [src.name] found no beacons in the world to anchor a wormhole to.</span>"
		return
	var/chosen_beacon = pick(L)
	var/obj/effect/portal/wormhole/jaunt_tunnel/J = new /obj/effect/portal/wormhole/jaunt_tunnel(get_turf(src), chosen_beacon, lifespan=100)
	J.target = chosen_beacon
	playsound(src,'sound/effects/sparks4.ogg',50,1)
	qdel(src)

/obj/item/device/wormhole_jaunter/emp_act(power)
	var/triggered = FALSE
	if(power == 1)
		triggered = TRUE
	else if(power == 2 && prob(50))
		triggered = TRUE

	if(triggered)
		usr.visible_message("<span class='warning'>The [src] overloads and activates!</span>")
		activate(usr)

/obj/effect/portal/wormhole/jaunt_tunnel
	name = "jaunt tunnel"
	icon = 'icons/obj/objects.dmi'
	icon_state = "bhole3"
	desc = "A stable hole in the universe made by a wormhole jaunter. Turbulent doesn't even begin to describe how rough passage through one of these is, but at least it will always get you somewhere near a beacon."

/obj/effect/portal/wormhole/jaunt_tunnel/teleport(atom/movable/M)
	if(M.anchored || istype(M, /obj/effect))
		return
	if(istype(M))
		if(do_teleport(M, target, 6))
			playsound(M,'sound/weapons/pulse3.ogg',50,1)
			if(iscarbon(M))
				var/mob/living/carbon/L = M
				L.Weaken(3)
				if(ishuman(L))
					shake_camera(L, 20, 1)