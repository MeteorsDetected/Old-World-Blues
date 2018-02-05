// Mask
/datum/gear/mask
	slot = slot_wear_mask
	sort_category = "Masks and Facewear"

/datum/gear/mask/bandana
	display_name = "bandana"
	path = /obj/item/clothing/mask/bandana/blue
	options = list(
		"blue" = /obj/item/clothing/mask/bandana/blue,
		"gold" = /obj/item/clothing/mask/bandana/gold,
		"green"= /obj/item/clothing/mask/bandana/green,
		"red"  = /obj/item/clothing/mask/bandana/red
	)

/datum/gear/mask/sterile
	display_name = "sterile mask"
	path = /obj/item/clothing/mask/surgical
	cost = 2

/datum/gear/mask/scarf
	cost = 2
	display_name = "scarf"
	path = /obj/item/clothing/mask/scarf/blue
	options = list(
		"blue" = /obj/item/clothing/mask/scarf/blue,
		"red" = /obj/item/clothing/mask/scarf/red,
		"red and white" = /obj/item/clothing/mask/scarf/redwhite,
		"green" = /obj/item/clothing/mask/scarf/green
	)

/datum/gear/mask/scarf/stripedred
	display_name = "striped scarf"
	path = /obj/item/clothing/mask/scarf/long_red
	options = list(
		"red"   = /obj/item/clothing/mask/scarf/long_red,
		"green" = /obj/item/clothing/mask/scarf/long_green,
		"blue"  = /obj/item/clothing/mask/scarf/long_blue
	)

/datum/gear/mask/scarf/arafatka
	display_name = "scarf, shemagh"
	path = /obj/item/clothing/mask/scarf/arafatka
