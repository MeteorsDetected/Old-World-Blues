/obj/structure/closet/code_blue_equipment
	name = "Blue Code Equipment"
	desc = "In case of Blue-Code Emergency at the station. Riot-equipment."
	icon_state = "black"
	icon_closed = "black"

/obj/structure/closet/code_blue_equipment/willContatin()
	return list(
		/obj/item/device/flashlight/flare,
		/obj/item/clothing/under/syndicate/PMC,
		/obj/item/clothing/accessory/storage/black_vest,
		/obj/item/clothing/shoes/jackboots,
		/obj/item/storage/belt/security/tactical,
		/obj/item/device/flash,
		/obj/item/weapon/tank/emergency_oxygen/double,
		/obj/item/storage/backpack/satchel/sec,
		/obj/item/device/flashlight/seclite,
		/obj/item/weapon/handcuffs,
		/obj/item/weapon/handcuffs,
		/obj/item/storage/box/shotgunammo,
		/obj/item/weapon/grenade/flashbang,
		/obj/item/weapon/material/hatchet/tacknife,
		/obj/item/weapon/crowbar/red,
		/obj/item/device/radio/off,
		/obj/item/clothing/suit/armor/riot,
		/obj/item/weapon/gun/projectile/shotgun/pump/combat,
		/obj/item/clothing/gloves/black,
		/obj/item/clothing/mask/gas,
		/obj/item/clothing/head/helmet/riot,
		/obj/item/clothing/accessory/armband,
		/obj/item/weapon/shield/riot,
		/obj/item/weapon/melee/baton/loaded,
		/obj/item/weapon/card/id/syndicate,
	)

/obj/structure/closet/code_red_equipment
	name = "Red Code Equipment"
	desc = "In case of Red-Code Emergency at the station. ArmedTeam-equipment."
	icon_state = "black"
	icon_closed = "black"

/obj/structure/closet/code_red_equipment/New()
	return list(
		/obj/item/storage/backpack/satchel/sec,
		/obj/item/clothing/head/beret/sec/alt,
		/obj/item/device/flashlight/seclite,
		/obj/item/weapon/gun/projectile/sec,
		/obj/item/clothing/suit/armor/vest,
		/obj/item/clothing/accessory/storage/black_vest,
		/obj/item/clothing/under/syndicate/PMC,
		/obj/item/clothing/shoes/jackboots,
		/obj/item/clothing/gloves/black,
		/obj/item/storage/belt/security/tactical,
		/obj/item/weapon/melee/classic_baton,
		/obj/item/weapon/handcuffs,
		/obj/item/ammo_magazine/c45m,
		/obj/item/ammo_magazine/c45m,
		/obj/item/ammo_magazine/c45m,
		/obj/item/ammo_magazine/c45m,
		/obj/item/ammo_magazine/c45m/flash,
		/obj/item/ammo_magazine/c45m/rubber,
		/obj/item/weapon/material/hatchet/tacknife,
		/obj/item/clothing/mask/gas/voice,
		/obj/item/weapon/tank/emergency_oxygen/double,
		/obj/item/weapon/card/id/syndicate,
		/obj/item/storage/firstaid/regular,
		/obj/item/weapon/reagent_containers/food/snacks/liquidfood,
		/obj/item/device/flashlight/flare,
		/obj/item/weapon/crowbar/red,
		/obj/item/device/radio/off,
	)