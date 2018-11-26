var/const/access_court = 42

/*
//returns 1 if this mob has sufficient access to use this object
/obj/proc/allowed(mob/M)
	//check if it doesn't require any access at all
	if(src.check_access(null))
		return 1
	if(issilicon(M))
		//AI can do whatever he wants
		return 1
	else if(ishuman(M))
		var/mob/living/carbon/human/H = M
		//if they are holding or wearing a card that has access, that works
		if(src.check_access(H.get_active_hand()) || src.check_access(H.wear_id))
			return 1
	return 0
*/
/obj/item/proc/GetID()
	return null


/proc/GetIdCard(var/mob/living/carbon/human/H)
	if(H.wear_id)
		var/id = H.wear_id.GetIdCard()
		if(id)
			return id
	if(H.get_active_hand())
		var/obj/item/I = H.get_active_hand()
		return I.GetIdCard()

/proc/FindNameFromID(var/mob/living/carbon/human/H)
	ASSERT(istype(H))
	var/obj/item/weapon/card/id/C = GetIdCard(H)
	if(C)
		return C.registered_name

/proc/get_all_job_icons() //For all existing HUD icons
	return joblist + list("Prisoner")

/obj/proc/GetJobName() //Used in secHUD icon generation
	var/obj/item/weapon/card/id/I
	if(istype(src, /obj/item/device/pda))
		var/obj/item/device/pda/P = src
		I = P.id
	else if(istype(src, /obj/item/weapon/card/id))
		I = src

	if(I)
		var/job_icons = get_all_job_icons()
		var/centcom = get_all_centcom_jobs()

		if(I.assignment	in job_icons) //Check if the job has a hud icon
			return I.assignment
		if(I.rank in job_icons)
			return I.rank

		if(I.assignment	in centcom) //Return with the NT logo if it is a Centcom job
			return "Centcom"
		if(I.rank in centcom)
			return "Centcom"
	else
		return

	return "Unknown" //Return unknown if none of the above apply
