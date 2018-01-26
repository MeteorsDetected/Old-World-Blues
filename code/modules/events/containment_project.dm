/datum/event/containment_project
	announceWhen	= 60
	endWhen 		= 900
	var/mob/living/simple_animal/scp_173/Statue

/datum/event/containment_project/setup()
	announceWhen = rand(20, 60)
	endWhen = rand(600,1200)

/datum/event/containment_project/announce()
	command_announcement.Announce("Special containment procedures initiated at [station_name()], object 'DATA DELETED' has escaped, all staff, please stand-by.")

/datum/event/containment_project/start()
	var/list/spawn_locations = list()
	for(var/obj/effect/landmark/C in landmarks_list)
		if(C.name == "scpspawn")
			spawn_locations.Add(C.loc)

	var/turf/simulated/floor/T = pick(spawn_locations)
	Statue = new /mob/living/simple_animal/scp_173(T)
	message_admins(SPAN_NOTE("Event: SCP-173 spawned at [T.loc] ([T.x],[T.y],[T.z])"))
