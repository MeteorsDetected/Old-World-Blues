/obj/structure/closet/secure_closet/scientist
	name = "scientist's locker"
	req_access = list(access_tox_storage)
	icon_state = "secureres"
	icon_opened = "secureresopen"

/obj/structure/closet/secure_closet/scientist/willContatin()
	return list(
		/obj/item/clothing/under/rank/scientist,
		/obj/item/clothing/under/rank/plasmares,
		/obj/item/clothing/suit/storage/toggle/labcoat,
		/obj/item/clothing/shoes/white,
//		/obj/item/weapon/cartridge/signal/science,
		/obj/item/device/radio/headset/sci,
		/obj/item/weapon/tank/air,
		/obj/item/clothing/mask/gas,
	)


/obj/structure/closet/secure_closet/RD
	name = "research director's locker"
	req_access = list(access_rd)
	icon_state = "rdsecure"
	icon_opened = "rdsecureopen"

/obj/structure/closet/secure_closet/RD/willContatin()
	return list(
		/obj/item/clothing/suit/bio_suit/scientist,
		/obj/item/clothing/head/bio_hood/scientist,
		/obj/item/clothing/under/rank/research_director,
		/obj/item/clothing/under/rank/research_director/alt,
		/obj/item/clothing/under/rank/research_director/skirt,
		/obj/item/clothing/suit/storage/toggle/labcoat,
		/obj/item/weapon/cartridge/rd,
		/obj/item/clothing/shoes/white,
		/obj/item/clothing/shoes/leather,
		/obj/item/clothing/gloves/latex,
		/obj/item/device/radio/headset/heads/rd,
		/obj/item/device/radio/headset/heads/rd/alt,
		/obj/item/weapon/tank/air,
		/obj/item/clothing/mask/gas,
		/obj/item/weapon/melee/baton/shocker/loaded,
		/obj/item/device/flash,
	)


/obj/structure/closet/secure_closet/animal
	name = "animal control closet"
	req_access = list(access_surgery)

/obj/structure/closet/secure_closet/animal/willContatin()
	return list(
		/obj/item/device/assembly/signaler,
		/obj/item/device/radio/electropack,
		/obj/item/device/radio/electropack,
		/obj/item/device/radio/electropack,
	)
