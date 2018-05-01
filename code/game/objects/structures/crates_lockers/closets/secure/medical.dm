/proc/pickMedicalPack()
	return pick(\
		list(
			/obj/item/clothing/under/rank/medical/sleeveless/blue,
			/obj/item/clothing/head/surgery/blue,
		),
		list(
			/obj/item/clothing/under/rank/medical/sleeveless/green,
			/obj/item/clothing/head/surgery/green,
		),
		list(
			/obj/item/clothing/under/rank/medical/sleeveless/purple,
			/obj/item/clothing/head/surgery/purple,
		),
		list(
			/obj/item/clothing/under/rank/medical/sleeveless/black,
			/obj/item/clothing/head/surgery/black,
		),
		list(
			/obj/item/clothing/under/rank/medical/sleeveless/navyblue,
			/obj/item/clothing/head/surgery/navyblue,
		),
	)

/obj/structure/closet/secure_closet/medical1
	name = "medicine closet"
	desc = "Filled with medical junk."
	icon_state = "medical"
	icon_opened = "medicalopen"
	req_access = list(access_medical_equip)

/obj/structure/closet/secure_closet/medical1/willContatin()
	return list(
		/obj/item/storage/box/autoinjectors,
		/obj/item/storage/box/pillbottles,
		/obj/item/weapon/reagent_containers/glass/beaker = 2,
		/obj/item/weapon/reagent_containers/dropper,
		/obj/item/weapon/reagent_containers/glass/beaker/bottle/inaprovaline = 2,
		/obj/item/weapon/reagent_containers/glass/beaker/bottle/antitoxin = 2,
		/obj/item/storage/box/syringes,
	)


/obj/structure/closet/secure_closet/medical2
	name = "anesthetics closet"
	desc = "Used to knock people out."
	icon_state = "medical"
	icon_opened = "medicalopen"
	req_access = list(access_surgery)

/obj/structure/closet/secure_closet/medical2/willContatin()
	return list(
		/obj/item/weapon/tank/anesthetic = 3,
		/obj/item/clothing/mask/breath/medical = 3,
	)



/obj/structure/closet/secure_closet/medical3
	name = "medical doctor's locker"
	req_access = list(access_medical_equip)
	icon_state = "securemed"
	icon_opened = "securemedopen"

/obj/structure/closet/secure_closet/medical3/willContatin()
	. = list(
		/obj/item/clothing/under/rank/nursesuit ,
		/obj/item/clothing/head/nursehat ,
		/obj/item/clothing/under/rank/medical,
		/obj/item/clothing/under/rank/nurse,
		/obj/item/clothing/under/rank/orderly,
		/obj/item/clothing/suit/storage/toggle/labcoat,
		/obj/item/clothing/suit/storage/toggle/fr_jacket,
		/obj/item/clothing/shoes/white,
		/obj/item/device/radio/headset/med,
	)
	for(var/i in 1 to 2)
		. += pickMedicalPack()
	. += pick(getBackpackTypes(BACKPACK_MEDICAL))

/obj/structure/closet/secure_closet/paramedic
	name = "paramedic locker"
	desc = "Supplies for a first responder."
	icon_state = "secureems"
	icon_opened = "secureemsopen"
	req_access = list(access_medical_equip)


/obj/structure/closet/secure_closet/paramedic/willContatin()
	. = list(
		/obj/item/storage/box/autoinjectors,
		/obj/item/storage/box/syringes,
		/obj/item/weapon/reagent_containers/glass/beaker/bottle/inaprovaline,
		/obj/item/weapon/reagent_containers/glass/beaker/bottle/antitoxin,
		/obj/item/storage/belt/medical/emt,
		/obj/item/clothing/mask/gas,
		/obj/item/clothing/suit/storage/toggle/fr_jacket/ems,
		/obj/item/device/radio/headset/med/alt,
		/obj/item/weapon/cartridge/medical,
		/obj/item/device/flashlight,
		/obj/item/weapon/tank/emergency_oxygen/engi,
		/obj/item/clothing/glasses/hud/health,
		/obj/item/device/healthanalyzer,
		/obj/item/device/radio/off,
		/obj/random/medical,
		/obj/item/weapon/crowbar,
		/obj/item/weapon/extinguisher/mini,
		/obj/item/clothing/accessory/storage/white_vest
	)

	. += pick(getBackpackTypes(BACKPACK_PARAMEDIC))


/obj/structure/closet/secure_closet/CMO
	name = "chief medical officer's locker"
	req_access = list(access_cmo)
	icon_state = "cmosecure"
	icon_opened = "cmosecureopen"

/obj/structure/closet/secure_closet/CMO/willContatin()
	. = list(
		/obj/item/clothing/suit/bio_suit/cmo,
		/obj/item/clothing/head/bio_hood/cmo,
		/obj/item/clothing/shoes/white,
		/obj/item/clothing/under/rank/chief_medical_officer,
		/obj/item/clothing/suit/storage/toggle/labcoat/cmo,
		/obj/item/clothing/suit/storage/toggle/labcoat/cmoalt,
		/obj/item/weapon/cartridge/cmo,
		/obj/item/clothing/gloves/latex,
		/obj/item/clothing/shoes/brown	,
		/obj/item/device/radio/headset/heads/cmo,
		/obj/item/weapon/melee/baton/shocker/loaded,
		/obj/item/device/flash,
		/obj/item/weapon/reagent_containers/hypospray,
		/obj/item/clothing/mask/gas,
	)
	. += pickMedicalPack()
	. += pick(getBackpackTypes(BACKPACK_MEDICAL))



/obj/structure/closet/secure_closet/chemical
	name = "chemical closet"
	desc = "Store dangerous chemicals in here."
	icon_state = "medical"
	icon_opened = "medicalopen"
	req_access = list(access_chemistry)

/obj/structure/closet/secure_closet/chemical/willContatin()
	return list(
		/obj/item/storage/box/pillbottles = 2
	)


/obj/structure/closet/secure_closet/wall/medical
	name = "first aid closet"
	desc = "It's a secure wall-mounted storage unit for first aid supplies."
	icon_state = "medical_wall_sec"
	icon_opened = "medical_wall_open"
	req_access = list(access_medical_equip)

