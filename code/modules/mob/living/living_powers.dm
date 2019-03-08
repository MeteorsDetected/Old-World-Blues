/mob/living/proc/ventcrawl()
	set name = "Crawl through Vent"
	set desc = "Enter an air vent and crawl through the pipe system."
	set category = "Abilities"

	if(stat == DEAD || paralysis || weakened || stunned || restrained())
		return

	handle_ventcrawl()

/mob/living/proc/hide()
	set name = "Hide"
	set desc = "Allows to hide beneath tables or certain items. Toggled on or off."
	set category = "Abilities"

	if(stat == DEAD || paralysis || weakened || stunned || restrained())
		return

	if (layer != ABOVE_NORMAL_TURF_LAYER)
		layer = ABOVE_NORMAL_TURF_LAYER //Just above cables with their 2.44
		src.visible_message(
			SPAN_NOTE("[src] scurries to the ground!"),
			SPAN_NOTE("You are now hiding.")
		)

	else
		layer = MOB_LAYER
		src.visible_message(
			SPAN_NOTE("[src] slowly peeks up from the ground..."),
			SPAN_NOTE("You stop hiding.")
		)
