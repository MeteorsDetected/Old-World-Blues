/datum/objective/meme_attune

/datum/objective/meme_attune/find_target(var/lowbound = 4, var/highbound = 6)
	target_amount = rand (lowbound,highbound)

	update_explanation()

/datum/objective/meme_attune/update_explanation()
	explanation_text = "Attune [target_amount] humanoid brains."

/datum/objective/meme_attune/get_panel_entry()
	return "Attune <a href='src=\ref[src];set_amount=Attuned humans'>[target_amount]</a> humanoid brains."

/datum/objective/meme_attune/check_completion()
	if(owner.current && istype(owner.current,/mob/living/parasite/meme))
		var/mob/living/parasite/meme/meme = owner.current
		return meme.indoctrinated.len >= target_amount
	else
		return 0