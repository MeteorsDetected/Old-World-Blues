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
	var/turf/simulated/S = pick(spawnable_turfs) //need only one good outdoor turf to rebuild
	S.zone.rebuild()
	air_master.mark_for_update(S)



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

