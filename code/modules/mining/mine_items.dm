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
	item_state = "lantern"
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


/**********************Miner Carts***********************/
/obj/item/weapon/rrf_ammo
	name = "compressed railway cartridge"
	desc = "Highly compressed matter for the RRF."
	icon = 'icons/obj/ammo.dmi'
	icon_state = "rcd"
	item_state = "rcdammo"
	w_class = 2
	origin_tech = list(TECH_MATERIAL = 2)
	matter = list(DEFAULT_WALL_MATERIAL = 15000,"glass" = 7500)

/obj/item/weapon/rrf
	name = "\improper Rapid-Railway-Fabricator"
	desc = "A device used to rapidly deploy mine tracks."
	icon = 'icons/obj/items.dmi'
	icon_state = "rcd"
	opacity = 0
	density = 0
	anchored = 0.0
	var/stored_matter = 30
	w_class = 3.0

/obj/item/weapon/rrf/examine(mob/user)
	if(..(user, 0))
		user << "It currently holds [stored_matter]/30 fabrication-units."

/obj/item/weapon/rrf/attackby(obj/item/weapon/W as obj, mob/user as mob)
	..()
	if (istype(W, /obj/item/weapon/rcd_ammo))

		if ((stored_matter + 30) > 30)
			user << "The RRF can't hold any more matter."
			return

		qdel(W)

		stored_matter += 30
		playsound(src.loc, 'sound/machines/click.ogg', 10, 1)
		user << "The RRF now holds [stored_matter]/30 fabrication-units."
		return

	if (istype(W, /obj/item/weapon/rrf_ammo))

		if ((stored_matter + 15) > 30)
			user << "The RRF can't hold any more matter."
			return

		qdel(W)

		stored_matter += 15
		playsound(src.loc, 'sound/machines/click.ogg', 10, 1)
		user << "The RRF now holds [stored_matter]/30 fabrication-units."
		return

/obj/item/weapon/rrf/afterattack(atom/A, mob/user as mob, proximity)

	if(!proximity) return

	if(istype(user,/mob/living/silicon/robot))
		var/mob/living/silicon/robot/R = user
		if(R.stat || !R.cell || R.cell.charge <= 0)
			return
	else
		if(stored_matter <= 0)
			return

	if(!istype(A, /turf/simulated/floor))
		return

	if(locate(/obj/structure/track) in A)
		return

	playsound(src.loc, 'sound/machines/click.ogg', 10, 1)
	var/used_energy = 0

	used_energy = 10

	new /obj/structure/track(get_turf(A))

	user << "Dispensing track..."

	if(isrobot(user))
		var/mob/living/silicon/robot/R = user
		if(R.cell)
			R.cell.use(used_energy)
	else
		stored_matter--
		user << "The RRF now holds [stored_matter]/30 fabrication-units."


/obj/structure/track
	name = "mine track"
	desc = "Just like your grandpappy used to lay 'em in 1862."
	icon = 'icons/obj/smoothtrack.dmi'
	icon_state = "track15"
	density = 0
	anchored = 1.0
	w_class = 3
	layer = 2.44

/obj/structure/track/New()
	Initialize()

/obj/structure/track/Initialize()
	. = ..()
	var/obj/structure/track/track = locate() in loc
	if (track && track != src)
		qdel(src)
		return
	updateOverlays()
	for (var/dir in cardinal)
		var/obj/structure/track/R = locate(/obj/structure/track, get_step(src, dir))
		if(R)
			R.updateOverlays()

/obj/structure/track/Destroy()
	for (var/dir in cardinal)
		var/obj/structure/track/R = locate(/obj/structure/track, get_step(src, dir))
		if(R)
			R.updateOverlays()
	return ..()

/obj/structure/track/ex_act(severity)
	switch(severity)
		if(1.0)
			qdel(src)
		if(2.0)
			qdel(src)
	return

/obj/structure/track/attackby(obj/item/C as obj, mob/user as mob)

	if (istype(C, /obj/item/stack/tile))
		var/turf/T = get_turf(src)
		T.attackby(C, user)
		return
	if (iswelder(C))
		var/obj/item/weapon/weldingtool/WT = C
		if(WT.remove_fuel(0, user))
			user << "<span class='notice'>Slicing apart connectors ...</span>"
		new /obj/item/stack/rods(src.loc)
		qdel(src)

	return

/obj/structure/track/proc/updateOverlays()
	set waitfor = FALSE
	overlays = list()

	var/dir_sum = 0

	for (var/direction in cardinal)
		if(locate(/obj/structure/track, get_step(src, direction)))
			dir_sum += direction

	icon_state = "track[dir_sum]"
	return

/obj/vehicle/train/cargo/engine/mining
	name = "mine cart engine"
	desc = "A ridable electric minecart designed for pulling other mine carts."
	icon = 'icons/obj/cart.dmi'
	icon_state = "mining_engine"
	on = 0
	powered = 1
	move_delay = -1

	load_item_visible = 1
	load_offset_x = 0
	mob_offset_y = 15
	active_engines = 1

	light_power = 1
	light_range = 6

/obj/vehicle/train/cargo/engine/mining/Initialize()
	. = ..()
	cell = new /obj/item/weapon/cell/high(src)
	key = null
	var/image/I = new(icon = 'icons/obj/cart.dmi', icon_state = "[icon_state]_overlay", layer = src.layer + 0.2) //over mobs
	overlays += I
	turn_off()	//so engine verbs are correctly set

/obj/vehicle/train/cargo/engine/mining/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(istype(W, /obj/item/weapon/key/minecarts))
		if(!key)
			usr.unEquip(W, src)
			W.forceMove(src)
			key = W
			verbs += /obj/vehicle/train/cargo/engine/verb/remove_key
		return
	..()

/obj/vehicle/train/cargo/engine/mining/Move(var/turf/destination)
	return ((locate(/obj/structure/track) in destination)) ? ..() : FALSE

/obj/vehicle/train/cargo/engine/mining/update_car(var/train_length, var/active_engines)
	return

/obj/vehicle/train/cargo/trolley/mining
	name = "mine-cart"
	desc = "A modern day twist to an ancient classic."
	icon = 'icons/obj/cart.dmi'
	icon_state = "mining_trailer"
	anchored = 0
	passenger_allowed = 0
	move_delay = -1

	load_item_visible = 1
	load_offset_x = 1
	load_offset_y = 15
	mob_offset_y = 16

	light_power = 1
	light_range = 3
	var/obj/item/weapon/key/cargo_train/key = null

/obj/vehicle/train/cargo/trolley/mining/Move(var/turf/destination)
	return ((locate(/obj/structure/track) in destination)) ? ..() : FALSE

/obj/item/weapon/key/minecarts
	name = "key"
	desc = "A keyring with a small steel key, and a pickaxe shaped fob."
	icon = 'icons/obj/vehicles.dmi'
	icon_state = "mine_keys"
	w_class = 1

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

/******************************Sculpting*******************************/
/obj/item/weapon/autochisel
	name = "auto-chisel"
	icon = 'icons/obj/items.dmi'
	icon_state = "jackhammer"
	item_state = "jackhammer"
	origin_tech = list(TECH_MATERIAL = 3, TECH_POWER = 2, TECH_ENGINEERING = 2)
	desc = "With an integrated AI chip and hair-trigger precision, this baby makes sculpting almost automatic!"

/obj/structure/sculpting_block
	name = "sculpting block"
	desc = "A finely chiselled sculpting block, it is ready to be your canvas."
	icon = 'icons/obj/mining.dmi'
	icon_state = "sculpting_block"
	density = 1
	opacity = 1
	anchored = 0
	var/sculpted = 0
	var/mob/living/T
	var/times_carved = 0
	var/last_struck = 0

/obj/structure/sculpting_block/verb/rotate()
	set name = "Rotate"
	set category = "Object"
	set src in oview(1)

	if (src.anchored || usr:stat)
		usr << "It is fastened to the floor!"
		return 0
	src.set_dir(turn(src.dir, 90))
	return 1

/obj/structure/sculpting_block/attackby(obj/item/C as obj, mob/user as mob)

	if (iswrench(C))
		playsound(src.loc, 'sound/items/Ratchet.ogg', 100, 1)
		user << "<span class='notice'>You [anchored ? "un" : ""]anchor the [name].</span>"
		anchored = !anchored

	if (istype(C, /obj/item/weapon/autochisel))
		if(!sculpted)
			if(last_struck)
				return

			if(!T)
				var/list/choices = list()
				for(var/mob/living/M in view(7,user))
					choices += M
				T = input(user,"Who do you wish to sculpt?") as null|anything in choices
				user.visible_message("<span class='notice'>[user] begins sculpting.</span>",
					"<span class='notice'>You begin sculpting.</span>")

			var/sculpting_coefficient = get_dist(user,T)
			if(sculpting_coefficient <= 0)
				sculpting_coefficient = 1

			if(sculpting_coefficient >= 7)
				user << "<span class='warning'>You hardly remember what [T] really looks like! Bah!</span>"
				T = null

			user.visible_message("<span class='notice'>[user] carves away at the sculpting block!</span>",
				"<span class='notice'>You continue sculpting.</span>")

			if(prob(25))
				playsound(user, 'sound/items/Screwdriver.ogg', 20, 1)
			else
				playsound(user, "sound/weapons/chisel[rand(1,2)].ogg", 20, 1)
				spawn(3)
					playsound(user, "sound/weapons/chisel[rand(1,2)].ogg", 20, 1)
					spawn(3)
						playsound(user, "sound/weapons/chisel[rand(1,2)].ogg", 20, 1)

			last_struck = 1
			if(do_after(user,(20)))
				last_struck = 0
				if(times_carved <= 9)
					times_carved += 1
//					if(times_carved < 1)
					user << "<span class='notice'>You review your work and see there is more to do.</span>"
//					return
				else
					sculpted = 1
					user.visible_message("<span class='notice'>[user] finishes sculpting their magnum opus!</span>",
						"<span class='notice'>You finish sculpting a masterpiece.</span>")
					src.appearance = T
					src.color = list(
					    0.35, 0.3, 0.25,
					    0.35, 0.3, 0.25,
					    0.35, 0.3, 0.25
					)
					src.pixel_y += 8
					var/image/pedestal_underlay = image('icons/obj/mining.dmi', icon_state = "pedestal")
					pedestal_underlay.appearance_flags = RESET_COLOR
					pedestal_underlay.pixel_y -= 8
					src.underlays += pedestal_underlay
					var/title = sanitize(input(usr, "If you would like to name your art, do so here.", "Christen Your Sculpture", "") as text|null)
					if(title)
						name = title
					else
						name = "*[T.name]*"
					var/legend = sanitize(input(usr, "If you would like to describe your art, do so here.", "Story Your Sculpture", "") as message|null)
					if(legend)
						desc = legend
					else
						desc = "This is a sculpture of [T.name]. All craftsmanship is of the highest quality. It is decorated with rock and more rock. It is covered with rock. On the item is an image of a rock. The rock is [T.name]."
			else
				last_struck = 0
		return

/******************************KA*******************************/

/obj/item/weapon/gun/energy/kinetic_accelerator
	name = "proto-kinetic accelerator"
	desc = "A reloadable, ranged mining tool that does increased damage in low pressure. Capable of holding up to six slots worth of mod kits."
	icon = 'icons/obj/mining.dmi'
	icon_state = "kineticgun"
	item_state = "kineticgun"
	charge_meter = 0
	fire_delay = 16
	slot_flags = SLOT_BELT|SLOT_BACK
	origin_tech = list(TECH_COMBAT = 2, TECH_MAGNET = 4, TECH_POWER = 4)
	projectile_type = /obj/item/projectile/kinetic
	fire_sound = 'sound/weapons/kenetic_accel.ogg'
	var/max_mod_capacity = 100
	var/list/modkits = list()

/obj/item/weapon/gun/energy/kinetic_accelerator/attack_self(mob/living/user as mob)
	if(power_supply.charge < power_supply.maxcharge)
		user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
		user << "<span class='notice'>You begin charging \the [src]...</span>"
		if(do_after(user,20))
			playsound(src.loc, 'sound/weapons/kenetic_reload.ogg', 60, 1)
			user.visible_message(
				"<span class='warning'>\The [user] pumps \the [src]!</span>",
				"<span class='warning'>You pump \the [src]!</span>"
				)
			power_supply.charge = power_supply.maxcharge

/obj/item/weapon/gun/energy/kinetic_accelerator/examine(mob/user)
	..()
	if(max_mod_capacity)
		user << "<b>[get_remaining_mod_capacity()]%</b> mod capacity remaining."
		for(var/A in get_modkits())
			var/obj/item/borg/upgrade/modkit/M = A
			user << "<span class='notice'>There is a [M.name] mod installed, using <b>[M.cost]%</b> capacity.</span>"

/obj/item/weapon/gun/energy/kinetic_accelerator/attackby(obj/item/A, mob/user)
	if(iscrowbar(A))
		if(modkits.len)
			user << "<span class='notice'>You pry the modifications out.</span>"
			playsound(loc, 100, 1)
			for(var/obj/item/borg/upgrade/modkit/M in modkits)
				M.uninstall(src)
		else
			user << "<span class='notice'>There are no modifications currently installed.</span>"
	else if(istype(A, /obj/item/borg/upgrade/modkit))
		var/obj/item/borg/upgrade/modkit/MK = A
		MK.install(src, user)
	else
		..()

/obj/item/weapon/gun/energy/kinetic_accelerator/proc/get_remaining_mod_capacity()
	var/current_capacity_used = 0
	for(var/A in get_modkits())
		var/obj/item/borg/upgrade/modkit/M = A
		current_capacity_used += M.cost
	return max_mod_capacity - current_capacity_used

/obj/item/weapon/gun/energy/kinetic_accelerator/proc/get_modkits()
	. = list()
	for(var/A in modkits)
		. += A

//Modkits
/obj/item/borg/upgrade/modkit
	name = "modification kit"
	desc = "An upgrade for kinetic accelerators."
	icon = 'icons/obj/mining.dmi'
	icon_state = "modkit"
	origin_tech = list(TECH_ENGINEERING = 2, TECH_MATERIAL = 2, TECH_MAGNET = 4)
	var/denied_type = null
	var/maximum_of_type = 1
	var/cost = 30
	var/modifier = 1 //For use in any mod kit that has numerical modifiers

/obj/item/borg/upgrade/modkit/examine(mob/user)
	..()
	user << "<span class='notice'>Occupies <b>[cost]%</b> of mod capacity.</span>"

/obj/item/borg/upgrade/modkit/attackby(obj/item/A, mob/user)
	if(istype(A, /obj/item/weapon/gun/energy/kinetic_accelerator) && !issilicon(user))
		install(A, user)
	else
		..()

/obj/item/borg/upgrade/modkit/proc/install(obj/item/weapon/gun/energy/kinetic_accelerator/KA, mob/user)
	. = TRUE
	if(denied_type)
		var/number_of_denied = 0
		for(var/A in KA.get_modkits())
			var/obj/item/borg/upgrade/modkit/M = A
			if(istype(M, denied_type))
				number_of_denied++
			if(number_of_denied >= maximum_of_type)
				. = FALSE
				break
	if(KA.get_remaining_mod_capacity() >= cost)
		if(.)
			user << "<span class='notice'>You install the modkit.</span>"
			playsound(loc, 'sound/items/Screwdriver.ogg', 100, 1)
			user.unEquip(src)
			forceMove(KA)
			KA.modkits += src
		else
			user << "<span class='notice'>The modkit you're trying to install would conflict with an already installed modkit. Use a crowbar to remove existing modkits.</span>"
	else
		user << "<span class='notice'>You don't have room(<b>[KA.get_remaining_mod_capacity()]%</b> remaining, [cost]% needed) to install this modkit. Use a crowbar to remove existing modkits.</span>"
		. = FALSE



/obj/item/borg/upgrade/modkit/proc/uninstall(obj/item/weapon/gun/energy/kinetic_accelerator/KA)
	forceMove(get_turf(KA))
	KA.modkits -= src

/obj/item/borg/upgrade/modkit/proc/modify_projectile(obj/item/projectile/kinetic/K)

//Range
/obj/item/borg/upgrade/modkit/range
	name = "range increase"
	desc = "Increases the range of a kinetic accelerator when installed."
	modifier = 1
	cost = 24 //so you can fit four plus a tracer cosmetic

/obj/item/borg/upgrade/modkit/range/modify_projectile(obj/item/projectile/kinetic/K)
	K.kill_count += modifier


//Damage
/obj/item/borg/upgrade/modkit/damage
	name = "damage increase"
	desc = "Increases the damage of kinetic accelerator when installed."
	modifier = 10

/obj/item/borg/upgrade/modkit/damage/modify_projectile(obj/item/projectile/kinetic/K)
	K.damage += modifier


//Cooldown
/obj/item/borg/upgrade/modkit/cooldown
	name = "cooldown decrease"
	desc = "Decreases the cooldown of a kinetic accelerator and increases the recharge rate."
	modifier = 2

/obj/item/borg/upgrade/modkit/cooldown/install(obj/item/weapon/gun/energy/kinetic_accelerator/KA, mob/user)
	. = ..()
	if(.)
		KA.fire_delay -= modifier
		KA.recharge_time -= modifier

/obj/item/borg/upgrade/modkit/cooldown/uninstall(obj/item/weapon/gun/energy/kinetic_accelerator/KA)
	KA.fire_delay += modifier
	KA.recharge_time += modifier
	..()


//AoE blasts
/obj/item/borg/upgrade/modkit/aoe
	modifier = 0

/obj/item/borg/upgrade/modkit/aoe/modify_projectile(obj/item/projectile/kinetic/K)
	K.name = "kinetic explosion"
	if(!K.turf_aoe && !K.mob_aoe)
		K.hit_overlays += /obj/effect/overlay/temp/explosion/fast
	K.mob_aoe += modifier

/obj/item/borg/upgrade/modkit/aoe/turfs
	name = "mining explosion"
	desc = "Causes the kinetic accelerator to destroy rock in an AoE."
	denied_type = /obj/item/borg/upgrade/modkit/aoe/turfs

/obj/item/borg/upgrade/modkit/aoe/turfs/modify_projectile(obj/item/projectile/kinetic/K)
	..()
	K.turf_aoe = TRUE

/obj/item/borg/upgrade/modkit/aoe/turfs/andmobs
	name = "offensive mining explosion"
	desc = "Causes the kinetic accelerator to destroy rock and damage mobs in an AoE."
	maximum_of_type = 3
	modifier = 0.25

/obj/item/borg/upgrade/modkit/aoe/mobs
	name = "offensive explosion"
	desc = "Causes the kinetic accelerator to damage mobs in an AoE."
	modifier = 0.2


//Indoors
/obj/item/borg/upgrade/modkit/indoors
	name = "decrease pressure penalty"
	desc = "Increases the damage a kinetic accelerator does in a high pressure environment."
	modifier = 2
	denied_type = /obj/item/borg/upgrade/modkit/indoors
	maximum_of_type = 2
	cost = 40

/obj/item/borg/upgrade/modkit/indoors/modify_projectile(obj/item/projectile/kinetic/K)
	K.pressure_decrease *= modifier

/obj/item/borg/upgrade/modkit/tracer
	name = "white tracer bolts"
	desc = "Causes kinetic accelerator bolts to have a white tracer trail and explosion."
	cost = 4
	denied_type = /obj/item/borg/upgrade/modkit/tracer
	var/bolt_color = "#FFFFFF"

/obj/item/borg/upgrade/modkit/tracer/modify_projectile(obj/item/projectile/kinetic/K)
	K.icon_state = "ka_tracer"
	K.color = bolt_color

/obj/item/borg/upgrade/modkit/tracer/adjustable
	name = "adjustable tracer bolts"
	desc = "Causes kinetic accelerator bolts to have a adjustably-colored tracer trail and explosion. Use in-hand to change color."

/obj/item/borg/upgrade/modkit/tracer/adjustable/attack_self(mob/user)
	bolt_color = input(user,"Choose Color") as color

/**********************Lazarus Injector**********************/

/obj/item/weapon/lazarus_injector
	name = "lazarus injector"
	desc = "An injector with a cocktail of nanomachines and chemicals, this device can seemingly raise animals from the dead. If no effect in 3 days please call customer support."
	icon = 'icons/obj/mining.dmi'
	icon_state = "lazarus_full"
	item_state = "hypo"
	throwforce = 0
	w_class = 2
	throw_speed = 3
	throw_range = 5
	var/loaded = 1
	var/no_revive_type = MOB_ROBOTIC
	var/malfunctioning = 0
	origin_tech = list(TECH_BIO = 7, TECH_MATERIAL = 4)

/obj/item/weapon/lazarus_injector/afterattack(atom/target, mob/user, proximity_flag)
	if(!loaded)
		return
	if(isliving(target) && proximity_flag)
		if(istype(target, /mob/living/simple_animal))
			var/mob/living/simple_animal/M = target
			if(no_revive_type == target)
				user << "<span class='info'>[src] does not work on this sort of creature.</span>"
				return
			if(M.stat == DEAD)
				if(!malfunctioning)
					M.faction = "neutral"
				M.revive()
//				M.icon_state = M.icon_living
				loaded = 0
				user.visible_message("<span class='notice'>[user] injects [M] with [src], reviving it.</span>")
				playsound(src,'sound/effects/refill.ogg',50,1)
				icon_state = "lazarus"
				return
			else
				user << "<span class='info'>[src] is only effective on the dead.</span>"
				return
		else
			user << "<span class='info'>[src] is only effective on lesser beings.</span>"
			return

/obj/item/weapon/lazarus_injector/emp_act()
	if(!malfunctioning)
		malfunctioning = 1

/obj/item/weapon/lazarus_injector/examine(mob/user)
	..()
	if(!loaded)
		user << "<span class='info'>[src] is empty.</span>"
	if(malfunctioning)
		user << "<span class='info'>The display on [src] seems to be flickering.</span>"

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
