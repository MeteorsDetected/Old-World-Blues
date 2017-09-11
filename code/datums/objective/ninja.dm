/datum/objective/ninja_highlander
	explanation_text = "You aspire to be a Grand Master of the Spider Clan. Kill all of your fellow acolytes."

/datum/objective/ninja_highlander/check_completion()
	for(var/datum/mind/ninja in get_antags("ninja"))
		if(ninja != owner)
			if(ninja.current.stat < DEAD)
				return FALSE
	return TRUE

