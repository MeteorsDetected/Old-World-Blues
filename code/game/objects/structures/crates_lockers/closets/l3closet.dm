/obj/structure/closet/l3closet
	name = "level-3 biohazard suit closet"
	desc = "It's a storage unit for level-3 biohazard gear."
	icon_state = "bio"
	icon_opened = "bioopen"

/obj/structure/closet/l3closet/general
	icon_state = "bio_general"
	icon_opened = "bioopen"

/obj/structure/closet/l3closet/general/willContatin()
	return list(
		/obj/item/clothing/suit/bio_suit/general,
		/obj/item/clothing/head/bio_hood/general,
	)


/obj/structure/closet/l3closet/virology
	icon_state = "bio_virology"
	icon_opened = "bioopen"

/obj/structure/closet/l3closet/virology/willContatin()
	return list(
		/obj/item/clothing/suit/bio_suit/virology,
		/obj/item/clothing/head/bio_hood/virology,
		/obj/item/clothing/mask/gas,
		/obj/item/weapon/tank/oxygen,
	)


/obj/structure/closet/l3closet/security
	icon_state = "bio_security"
	icon_opened = "bio_securityopen"

/obj/structure/closet/l3closet/security/willContatin()
	return list(
		/obj/item/clothing/suit/bio_suit/security,
		/obj/item/clothing/head/bio_hood/security,
	)


/obj/structure/closet/l3closet/janitor
	icon_state = "bio_janitor"
	icon_opened = "bio_janitoropen"

/obj/structure/closet/l3closet/janitor/willContatin()
	return list(
		/obj/item/clothing/suit/bio_suit/janitor = 4,
		/obj/item/clothing/mask/gas = 2,
		/obj/item/weapon/tank/emergency_oxygen/engi = 2,
	)


/obj/structure/closet/l3closet/scientist
	icon_state = "bio_scientist"
	icon_opened = "bio_scientistopen"

/obj/structure/closet/l3closet/scientist/willContatin()
	return list(
		/obj/item/clothing/suit/bio_suit/scientist,
		/obj/item/clothing/head/bio_hood/scientist,
	)


/obj/structure/closet/l3closet/medical
	icon_state = "bio_scientist"
	icon_opened = "bio_scientistopen"

/obj/structure/closet/l3closet/medical/willContatin()
	return list(
		/obj/item/clothing/suit/bio_suit/general = 6,
		/obj/item/clothing/mask/gas = 3,
	)
