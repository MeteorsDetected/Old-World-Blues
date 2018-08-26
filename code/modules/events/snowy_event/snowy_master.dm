var/global/datum/snowy_master/SnowyMaster

proc/createSnowyMaster()
	SnowyMaster = new /datum/snowy_master

//Need to add:
//weather
//events based on it
//game master panel
/datum/snowy_master
	var/deer_pop = 3 //how many deers must be on the map. For small maps use small amounts. Deers are unoptimized shit
	var/wolf_pop = 3 //how many wolfs must be on the map. Later i make this param for scenarios
	var/deers_to_spawn = 0 //helper
	var/wolfs_to_spawn = 0 //helper
	var/spawn_radius = 10 //radius to check for witnesses in spawn area //When mob spawns from ass - this isn't fun
	var/list/spawnable_turfs = list() //turfs for spawning stuff. Such players or mobs. Or drops from orbit
	var/pop_tick_interval = 10 //interval between population checks to make this less laggy
	var/pop_tick = 0

	var/list/coolers = list()
	var/current_temperature = T0C-30


//this one makes our cooling turfs in one list
/datum/snowy_master/proc/makeAtmosTurfsList()
	for(var/y=1, world.maxy >= y, y++)
		for(var/x=1, world.maxx >= x, x++)
			var/turf/T = locate(x, y, 1)
			if(istype(T, /turf/unsimulated/snow))
				coolers.Add(T)


/datum/snowy_master/proc/setTemperature(var/Temperature)
	Temperature = T0C + Temperature
	for(var/turf/T in coolers)
		T.temperature = Temperature
		air_master.mark_for_update(T)
	for(var/zone/Z in air_master.zones) //this one much reliable
		Z.rebuild()
	current_temperature = Temperature



/datum/snowy_master/proc/makeSpawnableTurfsList() //this can be slow or very slow on large maps, so be careful
	for(var/y=2, world.maxy-2 >= y, y++)
		for(var/x=2, world.maxx-2 >= x, x++)
			var/turf/T = locate(x, y, 1)
			if(!istype(T, /turf/simulated/mineral) && !istype(T, /turf/simulated/floor/plating/chasm))
				spawnable_turfs.Add(T)


//Yes, we can split map on quads and spawn animals evenly but this is too slow, i think. Or there's too much romp on optimization side
//So this simple one is better choice, i think
/datum/snowy_master/proc/spawnTheAnimal(var/path)
	var/turf/T = pick(spawnable_turfs)
	if(!istype(T, /turf/simulated/floor/plating/snow) && !istype(T, /turf/simulated/floor/plating/ice))
		spawnable_turfs.Remove(T)
		return
	for(var/mob/living/L in range(spawn_radius, T))
		if(L.key)
			return
	new path(T)


//Check population on the map. If possible, spawns animal. Done or not - no matter, we set the interval everytime
/datum/snowy_master/proc/checkPopulation()
	var/wolfs = 0
	var/deers = 0
	pop_tick = pop_tick_interval
	for(var/mob/living/simple_animal/SA in world)
		if(istype(SA, /mob/living/simple_animal/hostile/creature/wolf))
			wolfs++
		if(istype(SA, /mob/living/simple_animal/snowy_animal))
			deers++
	deers_to_spawn = deer_pop - deers
	wolfs_to_spawn = wolf_pop - wolfs
	if(deers_to_spawn > 0)
		spawnTheAnimal(/mob/living/simple_animal/snowy_animal/deer)
		return
	if(wolfs_to_spawn > 0)
		spawnTheAnimal(/mob/living/simple_animal/hostile/creature/wolf)


/datum/controller/process/snowy/setup()
	name = "snowy"
	schedule_interval = 20


/datum/controller/process/snowy/doWork()
	SnowyMaster.pop_tick--
	if(SnowyMaster.spawnable_turfs.len < 1)
		SnowyMaster.makeSpawnableTurfsList()
	if(SnowyMaster.pop_tick <= 0)
		SnowyMaster.checkPopulation()




//procs and things

//container drop proc
//loot list must have only paths
//land_point and mob_to_drop is existing things
/datum/snowy_master/proc/container_drop(var/turf/land_point, var/list/loot = list(), var/mob/living/mob_to_drop)
	var/list/space_around = list()
	spawn(100) //time to fly
		new /obj/structure/lootable/container(land_point)
		for(var/turf/T in range(1, land_point))
			if(!istype(T, /turf/simulated/floor/plating/chasm) && !T.density && T != land_point)
				space_around.Add(T)
		if(space_around.len == 0) //then things really bad
			space_around.Add(land_point)
		if(mob_to_drop)
			mob_to_drop.loc = pick(space_around)
			mob_to_drop.apply_damage(rand(15, 25), BRUTE) //high speed + unreliable ADS + some luck = say thanks not dead
			mob_to_drop.Weaken(4)
		for(var/P in loot)
			new P(pick(space_around))
		explosion(land_point, 0, 0, 1, 2)



/datum/snowy_master/proc/latejoin_handler(var/mob/living/character)
	var/rand_startpoint = pick(spawnable_turfs)

	if(character.mind.assigned_role == "Dweller")
		latejoinOldRoad(character, rand_startpoint)
	else
		var/R = rand(1, 3)
		switch(R)
			if(1)
				latejoinOldRoad(character, rand_startpoint)
			if(2)
				latejoinEmergencyLand(character, rand_startpoint)
			if(3)
				latejoinBoozeTrip(character, rand_startpoint)

	ticker.minds += character.mind //do standard stuff
	if(character.mind.assigned_role != "Dweller") //Only colony guys will added to manifest
		data_core.manifest_inject(character)
	matchmaker.do_matchmaking()



//Alternative late spawns

//Well, i want four scenarios
//1: drop in container on surface of planet. Injured, but have some extra loot
//2: just go in from border of map //Lose some items. But some of new found
//3: wakes up in bushes completely drunk //Lose some items, almost naked but have flaregun, hatchet and some booze
//4: after battle with wolfes. Injured, but have some loot around
//All of this must be a bit challenging to make start diffirent and form the story of character

//Need special controller for that

/datum/snowy_master/proc/latejoinOldRoad(var/mob/living/character, var/turf/start_point)
	var/list/lostlist = list("When you sleep thiefs stole your ",
							"At last night wolfes comes to your camp, you run, but forgot ",
							"You try to make a deal with trader but he robbed you with the gun, taked ",
							"You thought that's a good idea to shortcut a way through the lake, but ice is cracked! You saved youself, but lost ",
							"When you cross the bridge under chasm, something fall. This is ")

	var/list/foundlist = list("Some guy awakes you at night, says \"Ugr-m-Ba, Da-gha-ramt\" and, before he's run into forest with laugh, gives you ",
							"When you gather some wood and shrooms, you've seen something on the tree. This was ",
							"At one great morning, you've seen the beartrap and something inside. You takes the stick and hook up ",
							"You happen upon an old camp. Much of stuff has been broken, but in rusty crate you found ",
							"You meet an old friend. After long talk about good old days, hes left you ")

	character.loc = start_point
	character << SPAN_NOTE("You've made long way from distant station here when found out that there are people. Some of your equipment are may be lost, but you found something new.")
	for(var/obj/item/clothing/C in character)
		if(istype(C, /obj/item/clothing/under) || istype(C, /obj/item/clothing/shoes))
			continue
		if(prob(10))
			character << SPAN_WARN("[pick(lostlist)][C.name]")
			qdel(C)

	var/i = rand(1, 3)
	switch(i)
		if(1)
			var/randSuit = pick(subtypesof(/obj/item/clothing/suit))
			var/obj/item/clothing/suit/S = new randSuit(character)
			character.equip_to_slot_or_del(S, slot_wear_suit)
			character << SPAN_NOTE("[pick(foundlist)][S.name]")
		if(2)
			var/randHat = pick(subtypesof(/obj/item/clothing/head))
			var/obj/item/clothing/head/H = new randHat(character)
			character.equip_to_slot_or_del(H, slot_head)
			character << SPAN_NOTE("[pick(foundlist)][H.name]")
		if(3)
			var/randItem = pick(subtypesof(/obj/item/weapon))
			var/obj/item/weapon/W = new randItem(character)
			W.loc = character.loc
			character.put_in_active_hand(W)
			character << SPAN_NOTE("[pick(foundlist)][W.name]")


/datum/snowy_master/proc/latejoinEmergencyLand(var/mob/living/character, var/turf/start_point)
	var/ship_class = pick("Colibri", "Mule", "Dino", "Spectrum", "Clown", "Qiwi", "Sigurd", "Whitebait", "Chessnaut")
	var/employer = pick("Nanotrasen", "Cybersun Industries", "MI13", "Tiger Cooperative", "S.E.L.F.", "Animal Rights Consortium", "Donk Corporation", "Waffle Corporation")
	var/cargo = pick("fruits", "cyborgs", "animals", "minerals", "mining parts", "weapons", "slaves", "ore", "booze", "passengers")
	var/happen = pick("Captain gives reckless order and ship got heavy damage.",
					"One of your shipment has awake, going mad and attacked the personnel.",
					"Engine of your ship has broken. Crew has going mad and begins kill and eat each other. By a miracle, you survived and after 3 months of soaring ship approach close enough to planet.",
					"Your friend tried to rape you. But you taked the wrench and now your friend is dead. Crew judge you, but you escaped.",
					"AI of your ship was defective. One by one his kill the personnel."
					"Space pirates shot the ship and have taken it by boarding. They take other but you evade the pirates and hide under the bed.",
					"You just a paranoid fool.",
					"Your friends awakes you at night and said that ship was mined. They said need to run! Bastards...",
					"Days comes one by one, but nothing happens. You've seen same faces, doing same things, eat same food. Enough! You decide to run from this hellish ship and begin your life from scratch.")
	var/last_thing = pick("how somebody waving you with hand.", "how ship collides with the asteroid!", "that ship was vanished!", "how ship floating at the same way...")


	character << SPAN_NOTE("You've been worked at the ship of [ship_class] class. Your ship carried [cargo] and your employer was [employer]. But something going wrong. [happen] You've runned to one of the pod, takes a seat and pressed the button. After ADS shot you from the ship you've seen [last_thing]")
	character << "\red <big>GET READY FOR IMPACT IN TEN SECONDS!</big>"
	character.loc = SnowyMaster //Let's hide player before impact
	container_drop(start_point, list(/obj/item/storage/firstaid/adv), character)
	command_announcement.Announce("Something small approaching to the surface!", "Bright flash in the sky")
	spawn(100)
		for(var/obj/item/I in character)
			if(prob(20))
				character.unEquip(I, get_step(character, pick(alldirs)))
		character << SPAN_WARN("That was hard! ADS shot you stronger then need. Now you crashed upon the surface. Cold and almost lifeless planet! Pod damaged but somewhere there must be emergency first aid kit. Then, need to find sharp tools and make campfire.")



/datum/snowy_master/proc/latejoinBoozeTrip(var/mob/living/character, var/turf/start_point)
	var/list/booze_list = list(/obj/item/weapon/reagent_containers/glass/drinks/bottle/vodka,
								/obj/item/weapon/reagent_containers/glass/drinks/bottle/specialwhiskey,
								/obj/item/weapon/reagent_containers/glass/drinks/bottle/tequilla,
								/obj/item/weapon/reagent_containers/glass/drinks/bottle/rum,
								/obj/item/weapon/reagent_containers/glass/drinks/bottle/vermouth)

	var/hidden_person = pick("donkey", "monkey", "ex-wife", "ex-husband", "freak", "ugly bastard", "Walter White")
	var/what_happen_in_last_wagon = pick("robber", "married")
	switch(what_happen_in_last_wagon)
		if("robber")
			character << SPAN_NOTE("Holy monkeys. How much you drink? You looks as you feel. Bad. You only remember how you robbed the warehouse of [hidden_person] with three friends and one gun.")
		if("married")
			character << SPAN_NOTE("Holy monkeys. How much you drink? You looks as you feel. Bad. You only remember how you get merried with an [hidden_person].")
	character.loc = start_point
	character.Weaken(4)
	character.reagents.add_reagent("ethanol", 20)
	for(var/turf/T in range(2, character))
		if(prob(5))
			var/B = pick(booze_list)
			new B(T)
			continue
		if(prob(15))
			new /obj/item/weapon/broken_bottle(T)
	var/obj/item/weapon/card/id/Card = locate() in character
	character.drop_from_inventory(Card, character.loc)
	new /obj/item/weapon/gun/projectile/flaregun(character.loc)
	new /obj/item/ammo_casing/sflare/red(character.loc)
	new /obj/item/weapon/material/hatchet(character.loc)
	for(var/obj/item/clothing/C in character)
		if(!istype(C, /obj/item/clothing/hidden) && !istype(C, /obj/item/clothing/shoes) && !istype(C, /obj/item/clothing/head))
			qdel(C)
	var/obj/item/storage/backpack/BP = locate()
	qdel(BP)