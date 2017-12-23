//Medical
/obj/item/clothing/head/helmet/space/void/medical
	name = "medical voidsuit helmet"
	desc = "A bulbous voidsuit helmet with minor radiation shielding and a massive visor."
	icon_state = "rig0-medical"
	item_state = "medical_helm"
	armor = list(melee = 30, bullet = 5, laser = 20,energy = 5, bomb = 25, bio = 100, rad = 50)

/obj/item/clothing/suit/space/void/medical
	icon_state = "medic-void"
	item_state = "medic-void"
	name = "medical voidsuit"
	desc = "A sterile voidsuit with minor radiation shielding and a suite of self-cleaning technology. Standard issue in NanoTrasen medical facilities."
	allowed = list(
		/obj/item/device/flashlight,/obj/item/weapon/tank,/obj/item/device/suit_cooling_unit,
		/obj/item/storage/firstaid,/obj/item/device/healthanalyzer,/obj/item/stack/medical
	)
	armor = list(melee = 30, bullet = 5, laser = 20,energy = 5, bomb = 25, bio = 100, rad = 50)

//Surplus Voidsuits
/obj/item/clothing/head/helmet/space/void/medical/alt
	name = "streamlined medical voidsuit helmet"
	desc = "A trendy, lightly radiation-shielded voidsuit helmet trimmed in a fetching green."
	icon_state = "rig0-medicalalt"
	item_state = "medicalalt_helm"
	armor = list(melee = 30, bullet = 5, laser = 10,energy = 5, bomb = 5, bio = 100, rad = 60)
	light_overlay = "helmet_light_dual_green"

/obj/item/clothing/suit/space/void/medical/alt
	icon_state = "medicalt-void"
	name = "streamlined medical voidsuit"
	desc = "A more recent model of Vey-Med voidsuit, featuring the latest in radiation shielding technology, without sacrificing comfort or style."
	allowed = list(/obj/item/device/flashlight,/obj/item/weapon/tank,/obj/item/device/suit_cooling_unit,/obj/item/storage/firstaid,/obj/item/device/healthanalyzer,/obj/item/stack/medical)
	armor = list(melee = 30, bullet = 5, laser = 10,energy = 5, bomb = 5, bio = 100, rad = 60)

/obj/item/clothing/suit/space/void/medical/alt/prepared/New()
	..()
	helmet = new /obj/item/clothing/head/helmet/space/void/medical/alt
	boots = new /obj/item/clothing/shoes/magboots
