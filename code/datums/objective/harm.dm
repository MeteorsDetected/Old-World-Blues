/datum/objective/harm
	var/already_completed = FALSE

/datum/objective/harm/get_panel_entry()
	var/target = src.target ? "[src.target.current.real_name], the [src.target.assigned_role]" : "no_target"
	return "Make an example of <a href='?src=\ref[src];switch_target=1'>[target]</a>."

/datum/objective/harm/update_explanation()
	if(target && target.current)
		explanation_text = "Make an example of [target.current.real_name], the [target.assigned_role]. Break one of their bones, detach one of their limbs or disfigure their face. Make sure they're alive when you do it."
	else
		explanation_text = "Target has not arrived today. Did he know that I would come?"

/datum/objective/harm/check_completion()
	if(already_completed)
		return TRUE

	if(target && target.current && ishuman(target.current))
		if(target.current.stat == DEAD)
			return FALSE

		var/mob/living/carbon/human/H = target.current
		for(var/limb_tag in H.species.has_limbs)
			var/obj/item/organ/external/E = H.get_organ(limb_tag)
			if(!E || (E.status & ORGAN_BROKEN))
				return TRUE

		var/obj/item/organ/external/head/head = H.get_organ(BP_HEAD)
		if(head.disfigured)
			return TRUE
	return FALSE
