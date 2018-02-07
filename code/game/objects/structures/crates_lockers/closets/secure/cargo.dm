/obj/structure/closet/secure_closet/cargotech
	name = "cargo technician's locker"
	req_access = list(access_cargo)
	icon_state = "securecargo"
	icon_opened = "securecargoopen"

/obj/structure/closet/secure_clset/carbgotech/willContatin()
	. = list(
		/obj/item/clothing/under/rank/cargoshort,
		/obj/item/clothing/under/rank/cargo/skirt,
		/obj/item/clothing/under/rank/cargo/jeans,
		/obj/item/clothing/under/rank/cargo/jeans/female,
		/obj/item/clothing/shoes/black,
		/obj/item/device/radio/headset/cargo,
		/obj/item/clothing/gloves/black,
		/obj/item/clothing/head/soft,
	)
	. += pick(getBackpackTypes(BACKPACK_COMMON))

/obj/structure/closet/secure_closet/quartermaster
	name = "quartermaster's locker"
	req_access = list(access_qm)
	icon_state = "secureqm"
	icon_opened = "secureqmopen"

/obj/structure/closet/secure_closet/quartermaster/willContatin()
	. = list(
		/obj/item/clothing/under/rank/qm,
		/obj/item/clothing/under/rank/qm/skirt,
		/obj/item/clothing/under/rank/qm/jeans,
		/obj/item/clothing/under/rank/qm/jeans/female,
		/obj/item/clothing/shoes/brown,
		/obj/item/device/radio/headset/cargo,
		/obj/item/clothing/gloves/black,
		/obj/item/weapon/cartridge/quartermaster,
		/obj/item/clothing/suit/fire/firefighter,
		/obj/item/weapon/tank/emergency_oxygen,
		/obj/item/clothing/mask/gas,
		/obj/item/clothing/glasses/meson,
		/obj/item/clothing/head/soft,
	)
	. += pick(getBackpackTypes(BACKPACK_COMMON))


