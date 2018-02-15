/*
*	Here is where any supply packs
*	related to materials live.
*/


/datum/supply_packs/materials
	group = "Materials"

/datum/supply_packs/materials/metal
	name = "50 metal sheets"
	contains = list(/obj/item/stack/material/steel/full)
	cost = 10
	containertype = /obj/structure/closet/crate
	containername = "Metal sheets crate"

/datum/supply_packs/materials/glass
	name = "50 glass sheets"
	contains = list(/obj/item/stack/material/glass/full)
	cost = 10
	containertype = /obj/structure/closet/crate
	containername = "Glass sheets crate"
	
/datum/supply_packs/materials/plasteel
	name = "20 plasteel sheets"
	contains = list(/obj/item/stack/material/plasteel{amount = 20}) //I praise the gods, that this does work, please
	cost = 20
	containertype = /obj/structure/closet/crate
	containername = "Plasteel sheets crate"

/datum/supply_packs/materials/wood
	name = "50 wooden planks"
	contains = list(/obj/item/stack/material/wood/full)
	cost = 10
	containertype = /obj/structure/closet/crate
	containername = "Wooden planks crate"

/datum/supply_packs/materials/plastic
	name = "50 plastic sheets"
	contains = list(/obj/item/stack/material/plastic/full)
	cost = 10
	containertype = /obj/structure/closet/crate
	containername = "Plastic sheets crate"

/datum/supply_packs/materials/cardboard_sheets
	name = "50 cardboard sheets"
	contains = list(/obj/item/stack/material/cardboard/full)
	cost = 10
	containertype = /obj/structure/closet/crate
	containername = "Cardboard sheets crate"

/datum/supply_packs/materials/carpet
	name = "50 imported carpets"
	contains = list(/obj/item/stack/tile/carpet/full)
	cost = 15
	containertype = /obj/structure/closet/crate
	containername = "Imported carpets crate"

/datum/supply_packs/randomised/materials/research
	name = "Research materials"
	num_contained = 10
	contains = list(
		/obj/item/stack/material/phoron,	//Highest probability
		/obj/item/stack/material/phoron,
		/obj/item/stack/material/phoron,
		/obj/item/stack/material/silver,	//Medium probability
		/obj/item/stack/material/silver,
		/obj/item/stack/material/gold,
		/obj/item/stack/material/gold,
		/obj/item/stack/material/uranium,
		/obj/item/stack/material/uranium,
		/obj/item/stack/material/diamond	//Lowest probability
	)
	cost = 200
	containertype = /obj/structure/closet/crate
	containername = "Research materials crate"
