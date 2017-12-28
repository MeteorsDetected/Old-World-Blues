//Atmospherics
/obj/item/clothing/head/helmet/space/void/atmos
	name = "atmospherics voidsuit helmet"
	desc = "A flame-retardant voidsuit helmet with a self-repairing visor and light anti-radiation shielding."
	icon_state = "rig0-atmos"
	item_state = "atmos_helm"
	armor = list(melee = 40, bullet = 5, laser = 20,energy = 5, bomb = 35, bio = 100, rad = 50)
	max_heat_protection_temperature = FIRE_HELMET_MAX_HEAT_PROTECTION_TEMPERATURE
	light_overlay = "helmet_light_dual"

/obj/item/clothing/suit/space/void/atmos
	name = "atmos voidsuit"
	desc = "A durable voidsuit with advanced temperature-regulation systems as well as minor radiation protection. Well worth the price."
	icon_state = "atmos-void"
	item_state = "atmos-void"
	armor = list(melee = 40, bullet = 5, laser = 20,energy = 5, bomb = 35, bio = 100, rad = 50)
	max_heat_protection_temperature = FIRESUIT_MAX_HEAT_PROTECTION_TEMPERATURE
	allowed = list(
		/obj/item/device/flashlight,/obj/item/weapon/tank,/obj/item/device/suit_cooling_unit,/obj/item/weapon/rcd,
		/obj/item/storage/toolbox,/obj/item/storage/briefcase/inflatable,/obj/item/device/t_scanner
	)

/obj/item/clothing/suit/space/void/atmos/prepared/New()
	..()
	helmet = new /obj/item/clothing/head/helmet/space/void/atmos
	boots = new /obj/item/clothing/shoes/magboots


//Surplus Voidsuits
/obj/item/clothing/head/helmet/space/void/atmos/alt
	desc = "A voidsuit helmet plated with an expensive heat and radiation resistant ceramic."
	name = "heavy duty atmospherics voidsuit helmet"
	icon_state = "rig0-atmosalt"
	item_state = "atmosalt_helm"
	armor = list(melee = 20, bullet = 5, laser = 20,energy = 15, bomb = 45, bio = 100, rad = 50)
	max_heat_protection_temperature = FIRE_HELMET_MAX_HEAT_PROTECTION_TEMPERATURE
	light_overlay = "hardhat_light"

/obj/item/clothing/suit/space/void/atmos/alt
	desc = "An expensive NanoTrasen voidsuit, rated to withstand extreme heat and even minor radiation without exceeding room temperature within."
	icon_state = "atmosalt-void"
	name = "heavy duty atmos voidsuit"
	armor = list(melee = 20, bullet = 5, laser = 20,energy = 15, bomb = 45, bio = 100, rad = 50)
	max_heat_protection_temperature = FIRESUIT_MAX_HEAT_PROTECTION_TEMPERATURE

/obj/item/clothing/suit/space/void/atmos/alt/prepared/New()
	..()
	helmet = new /obj/item/clothing/head/helmet/space/void/atmos/alt
	boots = new /obj/item/clothing/shoes/magboots

