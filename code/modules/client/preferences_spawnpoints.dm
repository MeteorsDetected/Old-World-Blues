var/list/spawntypes = list()

/proc/populate_spawn_points()
	spawntypes = list()
	for(var/type in typesof(/datum/spawnpoint)-/datum/spawnpoint)
		var/datum/spawnpoint/S = new type()
		spawntypes[S.display_name] = S

/datum/spawnpoint
	var/msg          //Message to display on the arrivals computer.
	var/list/targets //List of turfs to spawn on.
	var/display_name //Name used in preference setup.
	var/list/restrict_job = null
	var/list/disallow_job = null

	proc/check_job_spawning(job)
		if(restrict_job && !(job in restrict_job))
			return 0

		if(disallow_job && (job in disallow_job))
			return 0

		return 1

/datum/spawnpoint/proc/pickPoint()
	return pick(getPoints())

/datum/spawnpoint/proc/getPoints()
	return src.targets


/*Subtypes*/

/datum/spawnpoint/alecto
	display_name = "Alekto Shuttle"
	msg = "has completed cryogenic revival"

/datum/spawnpoint/alecto/getPoints()
	. = list()
	for(var/elem in latejoin_alecto)
		var/obj/machinery/cryopod/C = elem
		. += get_step(C, C.dir)
	return .

