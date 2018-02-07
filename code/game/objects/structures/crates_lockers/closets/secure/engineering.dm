/obj/structure/closet/secure_closet/engineering_chief
	name = "chief engineer's locker"
	req_access = list(access_ce)
	icon_state = "securece"
	icon_opened = "secureceopen"


/obj/structure/closet/secure_closet/engineering_chief/willContatin()
	. = list(
		/obj/item/clothing/accessory/storage/brown_vest,
		/obj/item/blueprints,
		/obj/item/clothing/under/rank/chief_engineer,
		/obj/item/clothing/under/rank/chief_engineer/skirt,
		/obj/item/clothing/head/hardhat/white,
		/obj/item/clothing/head/welding,
		/obj/item/clothing/gloves/yellow,
		/obj/item/clothing/shoes/brown,
		/obj/item/weapon/cartridge/ce,
		/obj/item/device/radio/headset/heads/ce/alt,
		/obj/item/storage/toolbox/mechanical,
		/obj/item/clothing/suit/storage/hazardvest,
		/obj/item/clothing/mask/gas,
		/obj/item/device/multitool,
		/obj/item/weapon/melee/baton/shocker/loaded,
		/obj/item/device/flash,
		/obj/item/taperoll/engineering,
		/obj/item/weapon/tank/emergency_oxygen/engi,
	)

	. += pick(getBackpackTypes(BACKPACK_ENGINEERING))


/obj/structure/closet/secure_closet/engineering_electrical
	name = "electrical supplies"
	req_access = list(access_engine_equip)
	icon_state = "secureengelec"
	icon_opened = "toolclosetopen"

/obj/structure/closet/secure_closet/engineering_electrical/willContatin()
	return list(
		/obj/item/clothing/gloves/yellow = 2,
		/obj/item/storage/toolbox/electrical = 3,
		/obj/item/weapon/power_control = 3,
		/obj/item/device/multitool = 3,
	)


/obj/structure/closet/secure_closet/engineering_welding
	name = "welding supplies"
	req_access = list(access_construction)
	icon_state = "secureengweld"
	icon_opened = "toolclosetopen"

/obj/structure/closet/secure_closet/engineering_welding/willContatin()
	return list(
		/obj/item/clothing/head/welding = 3,
		/obj/item/weapon/weldingtool/largetank = 3,
		/obj/item/weapon/weldpack = 3,
		/obj/item/clothing/glasses/welding = 3,
	)


/obj/structure/closet/secure_closet/engineering_personal
	name = "engineer's locker"
	req_access = list(access_engine_equip)
	icon_state = "secureeng"
	icon_opened = "secureengopen"

/obj/structure/closet/secure_closet/engineering_personal/willContatin()
	. = list(
		/obj/item/clothing/accessory/storage/brown_vest,
		/obj/item/storage/toolbox/mechanical,
		/obj/item/device/radio/headset/eng,
		/obj/item/device/radio/headset/eng/alt,
		/obj/item/clothing/suit/storage/hazardvest,
		/obj/item/clothing/mask/gas,
		/obj/item/clothing/glasses/meson,
		/obj/item/weapon/cartridge/engineering,
		/obj/item/taperoll/engineering,
		/obj/item/weapon/tank/emergency_oxygen/engi,
	)
	. += pick(getBackpackTypes(BACKPACK_ENGINEERING))


/obj/structure/closet/secure_closet/atmos_personal
	name = "technician's locker"
	req_access = list(access_atmospherics)
	icon_state = "secureatm"
	icon_opened = "secureatmopen"

/obj/structure/closet/secure_closet/atmos_personal/willContatin()
	. = list(
		/obj/item/clothing/accessory/storage/brown_vest,
		/obj/item/clothing/suit/fire/firefighter,
		/obj/item/device/flashlight,
		/obj/item/weapon/extinguisher,
		/obj/item/device/radio/headset/eng,
		/obj/item/device/radio/headset/eng/alt,
		/obj/item/clothing/suit/storage/hazardvest,
		/obj/item/clothing/mask/gas,
		/obj/item/weapon/cartridge/atmos,
		/obj/item/taperoll/engineering,
		/obj/item/weapon/tank/emergency_oxygen/engi,
	)
	. += pick(getBackpackTypes(BACKPACK_ENGINEERING))


