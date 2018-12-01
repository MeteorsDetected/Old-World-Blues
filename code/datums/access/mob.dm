#define HUMAN_ID_CARDS list(get_active_hand(), wear_id, get_inactive_hand())
/mob/living/carbon/human/GetIdCard()
	for(var/item_slot in HUMAN_ID_CARDS)
		var/obj/item/I = item_slot
		var/obj/item/weapon/card/id = I ? I.GetIdCard() : null
		if(id)
			return id

/mob/living/carbon/human/GetAccess()
	. = list()
	for(var/item_slot in HUMAN_ID_CARDS)
		var/obj/item/I = item_slot
		if(I)
			. |= I.GetAccess()
#undef HUMAN_ID_CARDS

/*
// Unconscious, dead or once possessed but now client-less silicons are not considered to have id access.
/mob/living/silicon/GetIdCard()
	if(stat || (ckey && !client))
		return
	return idcard
*/

/mob/living/silicon/GetAccess()
	return get_all_accesses()

/obj/item/weapon/card/id/proc/GetJobName() //Used in secHUD icon generation
	var/obj/item/weapon/card/id/I = GetIdCard()

	if(I)
		var/job_icons = get_all_job_icons()
		if(I.assignment	in job_icons) //Check if the job has a hud icon
			return I.assignment
		if(I.rank in job_icons)
			return I.rank

		//Return with the NT logo if it is a Centcom job
		var/centcom = get_all_centcom_jobs()
		if(I.assignment in centcom || I.rank in centcom)
			return "Centcom"
	else
		return "Unknown" //Return unknown if none of the above apply
