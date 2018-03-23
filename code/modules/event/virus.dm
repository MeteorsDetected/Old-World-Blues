/obj/virus_handler
	var/mob/living/carbon/human/owner
	var/last_mutate = 0
	var/global/delay = 30 MINUTES
	var/evolution_level = 0

/obj/virus_handler/New(loc)
	..()
	last_mutate = world.time
	if(ishuman(loc))
		owner = loc

/obj/virus_handler/initialize()
	. = ..()
	processing_objects.Add(src)


/obj/virus_handler/proc/setOwner(mob)
	if(ishuman(mob))
		owner = mob
		return owner

/obj/virus_handler/process()
	if(last_mutate + delay < world.time)
		return
	++evolution_level


