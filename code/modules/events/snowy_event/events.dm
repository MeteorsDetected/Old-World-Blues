//There are snowy events
//Don't forget, they will not work if SnowyMaster not created. They will trigger, but actually not happen


/datum/event_container/mundane
	severity = EVENT_LEVEL_MUNDANE
	available_events = list(
	// Severity level, event name, even type, base weight, role weights, one shot, min weight, max weight. Last two only used if set and non-zero
		new /datum/event_meta(EVENT_LEVEL_MUNDANE, "Nothing",			/datum/event/nothing,			150),
		new /datum/event_meta(EVENT_LEVEL_MUNDANE, "Container drop",		/datum/event/containerdrop,		2),
		new /datum/event_meta(EVENT_LEVEL_MUNDANE, "Temperature shift",		/datum/event/tempshift,		15),
	)

/datum/event_container/moderate
	severity = EVENT_LEVEL_MODERATE
	available_events = list(
		new /datum/event_meta(EVENT_LEVEL_MODERATE, "Nothing",					/datum/event/nothing,					300),
		new /datum/event_meta(EVENT_LEVEL_MODERATE, "Random Antagonist",		/datum/event/random_antag,		 		30,	, 1, 0, 5),
		new /datum/event_meta(EVENT_LEVEL_MODERATE, "Cable failure",			/datum/event/cablegnaw,		95),
		new /datum/event_meta(EVENT_LEVEL_MODERATE, "Meteorite fall",		/datum/event/meteoritefall,		55),
	)

/datum/event_container/major
	severity = EVENT_LEVEL_MAJOR
	available_events = list(
		new /datum/event_meta(EVENT_LEVEL_MAJOR, "Nothing",			/datum/event/nothing,			600)
	)


//container drop
/datum/event/containerdrop
	announceWhen = 0
	endWhen = 12
	var/fail = 0
	var/list/loot = list()
	var/list/possible_loot_list = list("weapon" = list(/obj/item/weapon/gun/projectile/heavysniper/krauzer,
																/obj/item/storage/box/krauzerammo,
																/obj/item/storage/box/krauzerammo,
																/obj/item/storage/box/krauzerammo),

										"flares" = list(/obj/item/storage/box/sflares_red,
																/obj/item/storage/box/sflares_green,
																/obj/item/storage/box/sflares_blue),

										"monkeys" = list(/obj/item/storage/box/monkeycubes,
														/obj/item/storage/box/monkeycubes),

										"donkpockets" = list(/obj/item/storage/box/donkpockets,
															/obj/item/storage/box/donkpockets,
															/obj/item/storage/box/donkpockets),

										"matches" = list(/obj/item/storage/box/matches,
														/obj/item/storage/box/matches,
														/obj/item/storage/box/matches),

										"snacks" = list(/obj/item/storage/box/randomsnacks,
														/obj/item/storage/box/randomsnacks,
														/obj/item/storage/box/randomsnacks),

										"seeds" = list(/obj/item/storage/box/randomseeds,
														/obj/item/storage/box/randomseeds,
														/obj/item/storage/box/randomseeds)
										)


/datum/event/containerdrop/start()
	if(SnowyMaster)
		var/turf/dropPoint = pick(SnowyMaster.spawnable_turfs)
		var/P = pick(possible_loot_list)
		loot = possible_loot_list[P]
		SnowyMaster.container_drop(dropPoint, loot)
	else
		fail = 1


/datum/event/containerdrop/announce()
	if(!fail)
		command_announcement.Announce("Something small approaching to the surface!", "Bright flash in the sky")



//temperature shift
/datum/event/tempshift
	announceWhen = 4
	endWhen = 10
	var/fail = 0
	var/shift = 0
	var/minShift = -15
	var/maxShift = 15


/datum/event/tempshift/start()
	if(SnowyMaster)
		shift = rand(minShift, maxShift)
		var/t = SnowyMaster.current_temperature+shift-T0C
		if((t >= -50) && (t <= -15))
			SnowyMaster.setTemperature(t)
		else
			fail = 1
	else
		fail = 1


/datum/event/tempshift/announce()
	if(!fail && shift != 0)
		if(shift > 0)
			command_announcement.Announce("The green flare! Temperature will rise.", "News from the old weather station")
		else
			command_announcement.Announce("The red flare! Temperature will fall.", "News from the old weather station")


//Cables gnawing. Wild animal or just aftermath of snowy weather
/datum/event/cablegnaw
	announceWhen = 0
	endWhen = 10
	var/fail = 0


/datum/event/cablegnaw/start()
	if(SnowyMaster)
		for(var/obj/structure/cable/C in world)
			if((istype(C.loc, /turf/simulated/floor/plating/snow) || istype(C.loc, /turf/simulated/floor/plating/ice)) && C.loc.contents.len == 1)
				for(var/mob/living/L in view(10, C))
					if(L.key)
						continue
				new /obj/item/stack/cable_coil(C.loc, 1, C.color)
				var/datum/effect/effect/system/spark_spread/Shock = new /datum/effect/effect/system/spark_spread
				Shock.set_up(5, 1, src)
				Shock.start()
				if(prob(10))
					new /obj/structure/butcherable/wolf(get_step(C, pick(1, 2, 4, 8)))
				qdel(C)
				break
	else
		fail = 1



//Meteorite fall
/datum/event/meteoritefall
	announceWhen = 0
	endWhen = 10
	var/fail = 0
	var/size
	var/minSize = 2
	var/maxSize = 6


/datum/event/meteoritefall/start()
	if(SnowyMaster)
		size = rand(minSize, maxSize)
		spawn(100)
			var/turf/land_point = pick(SnowyMaster.spawnable_turfs)
			explosion(land_point, 0, 0, 1, 2)
			for(var/turf/T in circlerange(land_point, size))
				if(!istype(T, /turf/simulated/floor/plating/chasm) && !istype(T, /turf/unsimulated/snow))
					T.ChangeTurf(/turf/simulated/mineral/random/snowy)
					for(var/obj/O in T)
						O.ex_act(3)
					var/mob/living/L = locate() in T
					if(L)
						L.apply_damage(rand(30, 60),BRUTE)
			if(size > 3)
				for(var/obj/structure/window/W in range(50, land_point))
					if(prob(3))
						W.shatter(0)
	else
		fail = 1


/datum/event/meteoritefall/announce()
	if(!fail)
		if(size <= 3)
			command_announcement.Announce("Something small approaching to the surface!", "Bright flash in the sky")
		else
			command_announcement.Announce("Something medium approaching to the surface!", "Bright flash in the sky")