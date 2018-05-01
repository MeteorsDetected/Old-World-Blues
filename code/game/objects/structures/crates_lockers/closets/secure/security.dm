/obj/structure/closet/secure_closet/captains
	name = "captain's locker"
	req_access = list(access_captain)
	icon_state = "capsecure"
	icon_opened = "capsecureopen"

/obj/structure/closet/secure_closet/captains/willContatin()
	. = list(
		/obj/item/clothing/suit/captunic,
		/obj/item/clothing/suit/captunic/capjacket,
		/obj/item/clothing/head/cap,
		/obj/item/clothing/under/rank/captain,
		/obj/item/clothing/suit/storage/vest,
		/obj/item/weapon/cartridge/captain,
		/obj/item/clothing/head/helmet/swat,
		/obj/item/storage/lockbox/medal,
		/obj/item/clothing/shoes/brown,
		/obj/item/device/radio/headset/heads/captain/alt,
		/obj/item/clothing/gloves/captain,
		/obj/item/weapon/gun/energy/gun,
		/obj/item/weapon/melee/baton/shocker/loaded,
		/obj/item/weapon/melee/telebaton,
		/obj/item/clothing/under/rank/captain/dress,
		/obj/item/clothing/head/captain/formal,
		/obj/item/clothing/under/captainformal,
	)

	. += pick(getBackpackTypes(BACKPACK_CAPTAIN))


/obj/structure/closet/secure_closet/hop
	name = "head of personnel's locker"
	req_access = list(access_hop)
	icon_state = "hopsecure"
	icon_opened = "hopsecureopen"

/obj/structure/closet/secure_closet/hop/willContatin()
	return list(
		/obj/item/clothing/glasses/sunglasses,
		/obj/item/clothing/suit/storage/vest,
		/obj/item/clothing/head/helmet/security,
		/obj/item/weapon/cartridge/hop,
		/obj/item/device/radio/headset/com/alt,
		/obj/item/storage/box/ids,
		/obj/item/storage/box/ids,
		/obj/item/weapon/gun/energy/gun,
		/obj/item/weapon/gun/projectile/sec/flash,
		/obj/item/weapon/melee/baton/shocker/loaded,
		/obj/item/device/flash,
	)


/obj/structure/closet/secure_closet/hop2
	name = "head of personnel's attire"
	req_access = list(access_hop)
	icon_state = "hopsecure"
	icon_opened = "hopsecureopen"

/obj/structure/closet/secure_closet/hop2/willContatin()
	return list(
		/obj/item/clothing/under/rank/hop,
		/obj/item/clothing/under/rank/hop/dress,
		/obj/item/clothing/under/rank/hop/dress/hr,
		/obj/item/clothing/under/lawyer/female,
		/obj/item/clothing/under/lawyer/black,
		/obj/item/clothing/under/lawyer/red,
		/obj/item/clothing/under/lawyer/oldman,
		/obj/item/clothing/shoes/brown,
		/obj/item/clothing/shoes/black,
		/obj/item/clothing/shoes/leather,
		/obj/item/clothing/shoes/white,
		/obj/item/clothing/under/rank/hop/whimsy,
		/obj/item/clothing/under/rank/hop/dark,
		/obj/item/clothing/suit/storage/toggle/hop,
		/obj/item/clothing/head/hop,
	)


/obj/structure/closet/secure_closet/hos
	name = "head of security's locker"
	req_access = list(access_hos)
	icon_state = "hossecure"
	icon_opened = "hossecureopen"

/obj/structure/closet/secure_closet/hos/willContatin()
	. = list(
		/obj/item/clothing/head/HoS,
		/obj/item/clothing/suit/storage/vest/hos,
		/obj/item/clothing/under/rank/head_of_security/jensen,
		/obj/item/clothing/under/rank/head_of_security/corp,
		/obj/item/clothing/suit/storage/hos/jensen,
		/obj/item/clothing/suit/storage/hos,
		/obj/item/clothing/head/helmet/dermal,
		/obj/item/weapon/cartridge/hos,
		/obj/item/device/radio/headset/heads/hos/alt,
		/obj/item/clothing/glasses/sunglasses/sechud,
		/obj/item/taperoll,
		/obj/item/weapon/shield/riot,
		/obj/item/storage/box/holobadge/hos,
		/obj/item/clothing/accessory/badge/holo/hos,
		/obj/item/weapon/reagent_containers/spray/pepper,
		/obj/item/weapon/crowbar/red,
		/obj/item/storage/box/flashbangs,
		/obj/item/storage/belt/security,
		/obj/item/device/flash,
		/obj/item/weapon/melee/baton/loaded,
		/obj/item/weapon/gun/energy/gun,
		/obj/item/clothing/accessory/holster/gun/waist,
		/obj/item/weapon/melee/telebaton,
		/obj/item/clothing/head/beret/sec/hos,
		/obj/item/clothing/under/rank/head_of_security/dnavy,
		/obj/item/clothing/suit/storage/security/dnavyhos,
	)
	. += pick(getBackpackTypes(BACKPACK_SECURITY))


/obj/structure/closet/secure_closet/warden
	name = "warden's locker"
	req_access = list(access_armory)
	icon_state = "wardensecure"
	icon_opened = "wardensecureopen"

/obj/structure/closet/secure_closet/warden/willContatin()
	. = list(
		/obj/item/clothing/suit/storage/vest/warden,
		/obj/item/clothing/under/rank/warden,
		/obj/item/clothing/under/rank/warden/corp,
		/obj/item/clothing/under/rank/warden/dnavy,
		/obj/item/clothing/suit/storage/vest/warden,
		/obj/item/clothing/head/helmet/warden,
		/obj/item/clothing/head/helmet/warden/alt,
		/obj/item/weapon/cartridge/security,
		/obj/item/device/radio/headset/sec/alt,
		/obj/item/clothing/glasses/sunglasses/sechud,
		/obj/item/taperoll,
		/obj/item/storage/box/flashbangs,
		/obj/item/storage/belt/security,
		/obj/item/weapon/reagent_containers/spray/pepper,
		/obj/item/weapon/melee/baton/loaded,
		/obj/item/weapon/gun/energy/gun,
		/obj/item/storage/box/holobadge,
		/obj/item/clothing/head/beret/sec/warden,
		/obj/item/clothing/head/helmet/warden/drill,
		/obj/item/clothing/accessory/storage/black_vest,
		/obj/item/clothing/suit/storage/security/dnavywarden,
	)
	. += pick(getBackpackTypes(BACKPACK_SECURITY))


/obj/structure/closet/secure_closet/security
	name = "security officer's locker"
	req_access = list(access_brig)
	icon_state = "sec"
	icon_opened = "secopen"

/obj/structure/closet/secure_closet/security/willContatin()
	. = list(
		/obj/item/clothing/suit/storage/vest/officer,
		/obj/item/clothing/head/helmet/security,
//		/obj/item/weapon/cartridge/security,
		/obj/item/device/radio/headset/sec/alt,
		/obj/item/storage/belt/security,
		/obj/item/device/flash,
		/obj/item/weapon/reagent_containers/spray/pepper,
		/obj/item/weapon/grenade/flashbang,
		/obj/item/weapon/melee/baton/loaded,
		/obj/item/clothing/glasses/sunglasses/sechud,
		/obj/item/taperoll,
		/obj/item/device/hailer,
		/obj/item/clothing/accessory/storage/black_vest,
		/obj/item/clothing/head/soft/sec/corp,
		/obj/item/clothing/under/rank/security/corp,
		/obj/item/ammo_magazine/c45m/rubber,
		/obj/item/weapon/gun/energy/taser,
		/obj/item/clothing/gloves/black,
		/obj/item/clothing/under/rank/security/dnavy,
		/obj/item/clothing/suit/storage/security/dnavyofficer,
	)

	. += pick(getBackpackTypes(BACKPACK_SECURITY))


/obj/structure/closet/secure_closet/security/cargo/willContatin()
	return list(
		/obj/item/clothing/accessory/armband/cargo,
		/obj/item/device/encryptionkey/cargo,
	)

/obj/structure/closet/secure_closet/security/engine/willContatin()
	return list(
		/obj/item/clothing/accessory/armband/engine,
		/obj/item/device/encryptionkey/eng,
	)

/obj/structure/closet/secure_closet/security/science/willContatin()
	return list(
		/obj/item/clothing/accessory/armband/science,
		/obj/item/device/encryptionkey/sci,
	)

/obj/structure/closet/secure_closet/security/med/willContatin()
	return list(
		/obj/item/clothing/accessory/armband/medgreen,
		/obj/item/device/encryptionkey/med,
	)


/obj/structure/closet/secure_closet/cabinet/detective
	name = "detective's cabinet"
	req_access = list(access_forensics_lockers)

/obj/structure/closet/secure_closet/cabinet/detective/willContatin()
	. = list(
		/obj/item/clothing/suit/storage/toggle/investigator,
		/obj/item/clothing/suit/storage/toggle/investigator/alt,
		/obj/item/device/radio/headset/sec/alt,
		/obj/item/clothing/suit/storage/vest/detective,
		/obj/item/storage/box/evidence,
		/obj/item/ammo_magazine/c45m = 2,
		/obj/item/taperoll,
		/obj/item/weapon/gun/projectile/colt/detective,
		/obj/item/clothing/accessory/holster/gun/armpit,
		/obj/item/storage/belt/detective,
		/obj/item/clothing/accessory/badge/sec/detective,
		/obj/item/clothing/gloves/black,
		/obj/item/clothing/glasses/hud/security,
	)

	if(prob(50))
		. += list(
			/obj/item/clothing/head/det_hat,
			/obj/item/clothing/under/rank/det,
			/obj/item/clothing/shoes/brown,
			/obj/item/clothing/suit/storage/det_suit,
		)
	else
		. += list(
			/obj/item/clothing/head/det_hat/black,
			/obj/item/clothing/under/rank/det/black,
			/obj/item/clothing/shoes/laceup,
			/obj/item/clothing/suit/storage/det_suit/black,
		)

/obj/structure/closet/secure_closet/cabinet/forentech
	name = "forensic technician's cabinet"
	req_access = list(access_forensics_lockers)

/obj/structure/closet/secure_closet/cabinet/forentech/willContatin()
	return list(
		/obj/item/clothing/suit/storage/det_suit/seven,
		/obj/item/clothing/under/rank/forentech,
		/obj/item/clothing/suit/storage/forensics/blue,
		/obj/item/clothing/suit/storage/forensics/red,
		/obj/item/clothing/suit/storage/toggle/labcoat/forensic,
		/obj/item/clothing/shoes/brown,
		/obj/item/clothing/accessory/badge/sec/detective,
		/obj/item/clothing/gloves/latex,
		/obj/item/storage/box/evidence,
		/obj/item/device/radio/headset/sec,
		/obj/item/device/radio/headset/sec/alt,
		/obj/item/clothing/suit/storage/toggle/labcoat/forensic,
		/obj/item/clothing/under/rank/forensic,
		/obj/item/storage/belt/detective,
		/obj/item/taperoll,
		/obj/item/storage/briefcase/crimekit,
	)


/obj/structure/closet/secure_closet/injection
	name = "lethal injections locker"
	req_access = list(access_captain)

/obj/structure/closet/secure_closet/injection/willContatin()
	return list(
		/obj/item/weapon/reagent_containers/syringe/ld50_syringe/choral,
		/obj/item/weapon/reagent_containers/syringe/ld50_syringe/choral,
	)


/obj/structure/closet/secure_closet/brig
	name = "brig locker"
	req_access = list(access_brig)
	anchored = 1
	var/id = null

/obj/structure/closet/secure_closet/brig/willContatin()
	return list(
		/obj/item/clothing/under/color/orange,
		/obj/item/clothing/shoes/orange,
	)


/obj/structure/closet/secure_closet/courtroom
	name = "courtroom locker"
	req_access = list(access_court)

/obj/structure/closet/secure_closet/courtroom/willContatin()
	return list(
		/obj/item/clothing/shoes/brown,
		/obj/item/weapon/paper/Court ,
		/obj/item/weapon/paper/Court ,
		/obj/item/weapon/paper/Court ,
		/obj/item/weapon/pen ,
		/obj/item/clothing/suit/judgerobe ,
		/obj/item/clothing/head/powdered_wig ,
		/obj/item/storage/briefcase,
	)


/obj/structure/closet/secure_closet/wall/batman
	name = "head of personnel's emergency suit"
	desc = "It's a secure wall-mounted storage unit for justice."
	icon_state = "batman_wall_closed"
	icon_opened = "batman_wall_open"
	req_access = list(access_hop)

/obj/structure/closet/secure_closet/wall/batman/willContatin()
	return list(
		/obj/item/clothing/mask/gas/batman,
		/obj/item/clothing/under/batman,
		/obj/item/clothing/gloves/black/batman,
		/obj/item/clothing/shoes/swat/batman,
		/obj/item/storage/belt/security/batman,
	)
