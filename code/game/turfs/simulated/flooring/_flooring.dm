var/global/list/flooring_list
/proc/get_flooring(type)
	if(!flooring_list)
		flooring_list = new

	if(! type in flooring_list)
		flooring_list[type] = new type

	return flooring_list[type]



/datum/flooring
	var/name
	var/desc
	var/icon = 'icons/turf/floors.dmi'
	var/icon_base

	var/damage_temperature

	var/build_type      // Unbuildable if not set. Must be /obj/item/stack.
	var/build_cost = 1  // Stack units.
	var/build_time = 0  // BYOND ticks.

	var/flags

/datum/flooring/proc/on_remove()
	return

/datum/flooring/tiling
	name = "floor"
	desc = "A solid, heavy set of flooring plates."
	icon = 'icons/turf/floor/tiles.dmi'
	icon_base = "floor"
	damage_temperature = T0C+1400
//	flags = TURF_REMOVE_CROWBAR | TURF_CAN_BREAK | TURF_CAN_BURN
//	build_type = /obj/item/stack/tile/floor

/datum/flooring/grass
	name = "grass"
	desc = "Do they smoke grass out in space, Bowie? Or do they smoke AstroTurf?"
	icon_base = "grass"
	damage_temperature = T0C+80

/datum/flooring/carpet
	name = "brown carpet"
	desc = "Comfy and fancy carpeting."
	icon = 'icons/turf/floor/carpet.dmi'
	icon_base = "brown"
	build_type = /obj/item/stack/tile/carpet
	damage_temperature = T0C+200

/datum/flooring/carpet/blue
	name = "blue carpet"
	icon_base = "blue1"

/datum/flooring/linoleum
	name = "linoleum"
	desc = "It's like the 2090's all over again."

/datum/flooring/wood
	name = "wooden floor"
	desc = "Polished wood planks."
	icon = 'icons/turf/floor/wood.dmi'
	icon_base = "wood"
	damage_temperature = T0C+200

