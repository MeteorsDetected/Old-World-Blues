/*
*	Here is where any supply packs
*	related to voidsuits live.
*/


/datum/supply_packs/voidsuits
	group = "EVA Equipment"

/datum/supply_packs/randomised/voidsuits
	group = "EVA Equipment"

/datum/supply_packs/voidsuits/atmos
	name = "Atmospheric voidsuits"
	contains = list(
		/obj/item/clothing/suit/space/void/atmos = 2,
		/obj/item/clothing/head/helmet/space/void/atmos = 2,
		/obj/item/clothing/mask/breath = 2,
		/obj/item/clothing/shoes/magboots/toggleable = 2,
		/obj/item/weapon/tank/oxygen = 2,
	)
	cost = 40
	containertype = /obj/structure/closet/crate/secure
	containername = "Atmospheric voidsuit crate"
	access = access_atmospherics

/datum/supply_packs/voidsuits/engineering
	name = "Engineering voidsuits"
	contains = list(
		/obj/item/clothing/suit/space/void/engineering = 2,
		/obj/item/clothing/head/helmet/space/void/engineering = 2,
		/obj/item/clothing/mask/breath = 2,
		/obj/item/clothing/shoes/magboots/toggleable = 2,
		/obj/item/weapon/tank/oxygen = 2
	)
	cost = 40
	containertype = /obj/structure/closet/crate/secure
	containername = "Engineering voidsuit crate"
	access = access_engine_equip

/datum/supply_packs/voidsuits/medical
	name = "Medical voidsuits"
	contains = list(
		/obj/item/clothing/suit/space/void/medical = 2,
		/obj/item/clothing/head/helmet/space/void/medical = 2,
		/obj/item/clothing/mask/breath = 2,
		/obj/item/clothing/shoes/magboots/toggleable = 2,
		/obj/item/weapon/tank/oxygen = 2
	)
	cost = 40
	containertype = /obj/structure/closet/crate/secure
	containername = "Medical voidsuit crate"
	access = access_medical_equip

/datum/supply_packs/voidsuits/security
	name = "Security voidsuits"
	contains = list(
		/obj/item/clothing/suit/space/void/security = 2,
		/obj/item/clothing/head/helmet/space/void/security = 2,
		/obj/item/clothing/mask/breath = 2,
		/obj/item/clothing/shoes/magboots/toggleable = 2,
		/obj/item/weapon/tank/oxygen = 2
	)
	cost = 40
	containertype = /obj/structure/closet/crate/secure
	containername = "Security voidsuit crate"

/datum/supply_packs/voidsuits/supply
	name = "Mining voidsuits"
	contains = list(
		/obj/item/clothing/suit/space/void/mining = 2,
		/obj/item/clothing/head/helmet/space/void/mining = 2,
		/obj/item/clothing/mask/breath = 2,
		/obj/item/weapon/tank/oxygen = 2
	)
	cost = 40
	containertype = /obj/structure/closet/crate/secure
	containername = "Mining voidsuit crate"
	access = access_mining

/datum/supply_packs/randomised/voidsuits/surplus
	name = "Surplus EVA equipment"
	num_contained = 7
	contains = list(
		/obj/item/clothing/suit/space/syndicate/green,
		/obj/item/clothing/head/helmet/space/syndicate/green,
		/obj/item/clothing/suit/space/syndicate/green/dark,
		/obj/item/clothing/head/helmet/space/syndicate/green/dark,
		/obj/item/clothing/suit/space/syndicate/blue,
		/obj/item/clothing/head/helmet/space/syndicate/blue,
		/obj/item/clothing/suit/space/syndicate/black/med,
		/obj/item/clothing/head/helmet/space/syndicate/black/med,
		/obj/item/clothing/suit/space/syndicate/black/orange,
		/obj/item/clothing/head/helmet/space/syndicate/black/orange,
		/obj/item/clothing/suit/space/syndicate/red,
		/obj/item/clothing/head/helmet/space/syndicate/red,
		/obj/item/clothing/suit/space/syndicate/black,
		/obj/item/clothing/head/helmet/space/syndicate/black,
		/obj/item/clothing/suit/space/syndicate/black/engie,
		/obj/item/clothing/head/helmet/space/syndicate/black/engie,
		/obj/item/clothing/shoes/magboots/toggleable,
		/obj/item/clothing/shoes/magboots/toggleable,
		/obj/item/weapon/tank/emergency_oxygen/double,
		/obj/item/weapon/tank/emergency_oxygen/double,
		/obj/item/weapon/tank/emergency_oxygen/double,
		/obj/item/weapon/tank/jetpack/oxygen,
		/obj/item/weapon/tank/oxygen,
		/obj/item/weapon/tank/oxygen
	)
	cost = 60
	containertype = /obj/structure/closet/crate
	containername = "Surplus EVA crate"

/datum/supply_packs/voidsuits/rig_modules
	name = "Hardsuit modules"
	contains = list(
		/obj/item/rig_module/ai_container,
		/obj/item/rig_module/device/plasmacutter,
		/obj/item/rig_module/device/rcd,
		/obj/item/rig_module/chem_dispenser,
		/obj/item/rig_module/maneuvering_jets,
		/obj/item/rig_module/vision/nvg
	)
	cost = 80
	containertype = /obj/structure/closet/crate
	containername = "Hardsuit modules crate"