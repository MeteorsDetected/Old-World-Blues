/obj/structure/cyberplant
	name = "Holographic plant"
	desc = "Holographic plant projector"
	icon = 'icons/obj/cyberplants.dmi'
	icon_state = "holopot"
	light_color = "#3C94C5"
	var/autostripes = TRUE
	var/emaged = FALSE
	var/interference = FALSE
	var/icon/plant = null
	var/global/list/possible_plants = list(
		"applebush",
		"plant-01",
		"plant-02",
		"plant-03",
		"plant-03",
		"plant-04",
		"plant-05",
		"plant-06",
		"plant-07",
		"plant-08",
		"plant-09",
		"plant-10",
		"plant-11",
		"plant-12",
		"plant-13",
		"plant-14",
		"plant-15",
		"plant-16",
		"plant-17",
		"plant-18",
		"plant-19",
		"plant-20",
		"plant-21",
		"plant-22",
		"plant-23",
		"plant-24",
		"plant-25",
		"plant-26",
		"plant-xmas"
	)

/obj/structure/cyberplant/New()
	..()
	plant = prepare_icon(plant)
	overlays += plant
	set_light(3)

/obj/structure/cyberplant/proc/prepare_icon(var/state)
	if(!state)
		state = pick(possible_plants)
	if(autostripes)
		var/plant_icon = icon(icon, state)
		return getHologramIcon(plant_icon, 0)
	else
		return image(icon, state)

/obj/structure/cyberplant/emag_act()
	if(emaged)
		return

	emaged = TRUE
	overlays -= plant
	plant = prepare_icon("emaged")
	overlays += plant

/obj/structure/cyberplant/Crossed(var/mob/living/L)
	if(!interference && istype(L))
		interference = TRUE
		spawn(0)
			overlays.Cut()
			set_light(0)
			sleep(3)
			overlays += plant
			set_light(3)
			sleep(3)
			overlays -= plant
			set_light(0)
			sleep(3)
			overlays += plant
			set_light(3)
			interference = FALSE
