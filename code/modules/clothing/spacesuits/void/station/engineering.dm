//Engineering
/obj/item/clothing/head/helmet/space/void/engineering
	name = "engineering voidsuit helmet"
	desc = "A sturdy looking voidsuit helmet rated to protect against radiation."
	icon_state = "rig0-engineering"
	item_state = "eng_helm"
	armor = list(melee = 40, bullet = 5, laser = 20,energy = 5, bomb = 35, bio = 100, rad = 80)

/obj/item/clothing/suit/space/void/engineering
	name = "engineering voidsuit"
	desc = "A run-of-the-mill service voidsuit with all the plating and radiation protection required for industrial work in vacuum."
	icon_state = "engine-void"
	item_state = "engine-void"
	slowdown = 1
	armor = list(melee = 40, bullet = 5, laser = 20,energy = 5, bomb = 35, bio = 100, rad = 80)
	allowed = list(
		/obj/item/device/flashlight,/obj/item/weapon/tank,/obj/item/device/suit_cooling_unit,
		/obj/item/storage/bag/ore,/obj/item/device/t_scanner,/obj/item/weapon/pickaxe,
		/obj/item/weapon/rcd
	)

/obj/item/clothing/suit/space/void/engineering/prepared/New()
	..()
	helmet = new /obj/item/clothing/head/helmet/space/void/engineering
	boots = new /obj/item/clothing/shoes/magboots

//Surplus Voidsuits
/obj/item/clothing/head/helmet/space/void/engineering/alt
	name = "reinforced engineering voidsuit helmet"
	desc = "A heavy, radiation-shielded voidsuit helmet with a surprisingly comfortable interior."
	icon_state = "rig0-engineeringalt"
	item_state = "engalt_helm"
	armor = list(melee = 40, bullet = 5, laser = 20,energy = 5, bomb = 45, bio = 100, rad = 100)
	light_overlay = "helmet_light_dual"

/obj/item/clothing/suit/space/void/engineering/alt
	name = "reinforced engineering voidsuit"
	desc = "A bulky industrial voidsuit. It's a few generations old, but a reliable design and radiation shielding make up for the lack of climate control."
	icon_state = "enginealt-void"
	slowdown = 2
	armor = list(melee = 40, bullet = 5, laser = 20,energy = 5, bomb = 45, bio = 100, rad = 100)

/obj/item/clothing/suit/space/void/engineering/alt/prepared/New()
	..()
	helmet = new /obj/item/clothing/head/helmet/space/void/engineering/alt
	boots = new /obj/item/clothing/shoes/magboots
