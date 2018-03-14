/obj/virus_handler
	var/mob/living/carbon/human/owner = null
	var/last_mut_time
	var/mut_delay = 15 MINUTES
	var/mutCount = 0


/obj/virus_handler/initialize()
	. = ..()
	processing_objects.Add(src)

/obj/virus_handler/Destroy()
	owner = null
	return ..()

/obj/virus_handler/proc/set_owner(var/mob/living/carbon/human/H)
	if(!istype(H))
		return

	owner = H
	forceMove(owner)
	last_mut_time = world.time


/obj/virus_handler/process()
	if(!owner)
		return
	if(last_mut_time + mut_delay < world.time)
		return
	last_mut_time = world.time
	muatate()


/obj/virus_handler/proc/mutate()
	if(!mutCount) //befor first blue organ
		var/list/mutable_organs = list()
		for(var/organ in owner.organs)
			var/obj/item/organ/external/E = organ
			if(E.robotic >= ORGAN_ROBOT)
				continue
			mutable_organs |= E
		if(!mutable_organs.len)
			qdel(src)
			return

	var/obj/item/organ/external/E in owner.organs
	E.becomeBlue()


	var/list/mutable_organs = list()

	for(var/organ in owner.organs)
		var/obj/item/organ/external/E = organ
		if(!E.blue)
			mutable_organs |= E

	if(!first_mutate)
		for(var/obj/item/organ/external/E in mutable_organs)
			if(E.parent && E.parent.blue)
				continue
			if(E.children)
				for(var/organ/item/organ/external/Child in E.children)
					children


