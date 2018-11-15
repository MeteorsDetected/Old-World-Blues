//Science
/obj/item/clothing/head/helmet/space/void/science
	name = "science voidsuit helmet"
	desc = "A bulbous voidsuit helmet with minor radiation shielding and a massive visor."
	icon_state = "rig0-science"
	item_state = "medical_helm"
	armor = list(melee = 30, bullet = 5, laser = 20,energy = 5, bomb = 25, bio = 100, rad = 75)

/obj/item/clothing/suit/space/void/science
	icon_state = "science-void"
	item_state = "medic-void"
	name = "science voidsuit"
	desc = "A white voidsuit with radiation shielding. Standard issue in NanoTrasen science facilities."
	allowed = list(
		/obj/item/device/flashlight,/obj/item/weapon/tank,/obj/item/device/suit_cooling_unit,
		/obj/item/device/multitool, /obj/item/device/robotanalyzer, /obj/item/device/assembly/signaler
	)
	armor = list(melee = 30, bullet = 5, laser = 20,energy = 5, bomb = 25, bio = 100, rad = 75)

/obj/item/clothing/suit/space/void/medical/prepared/initialize()
	. = ..()
	helmet = new /obj/item/clothing/head/helmet/space/void/science
	boots = new /obj/item/clothing/shoes/magboots/toggleable

