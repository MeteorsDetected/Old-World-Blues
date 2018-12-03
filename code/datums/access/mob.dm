#define HUMAN_ID_CARDS list(get_active_hand(), wear_id, get_inactive_hand())
/mob/living/carbon/human/GetIdCard(var/equip_only = FALSE)
	if(equip_only)
		var/obj/item/weapon/card/id = get_equipped_item(slot_wear_id)
		return id && id.GetIdCard()
	else
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

/proc/get_all_job_icons() //For all existing HUD icons
	return joblist + list("Prisoner")

/obj/item/weapon/card/id/proc/GetJobName() //Used in secHUD icon generation
	var/job_icons = get_all_job_icons()
	if(assignment in job_icons) //Check if the job has a hud icon
		return assignment
	if(rank in job_icons)
		return rank

	//Return with the NT logo if it is a Centcom job
	var/centcom = get_all_centcom_jobs()
	if(assignment in centcom || rank in centcom)
		return "Centcom"

	return "Unknown" //Return unknown if none of the above apply
