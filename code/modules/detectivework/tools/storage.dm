/obj/item/storage/box/swabs
	name = "box of swab kits"
	desc = "Sterilized equipment within. Do not contaminate."
	icon = 'icons/obj/forensics.dmi'
	icon_state = "dnakit"
	can_hold = list(/obj/item/weapon/forensics/swab)
	storage_slots = 14
	preloaded = list(
		/obj/item/weapon/forensics/swab = 14
	)

/obj/item/storage/box/evidence
	name = "evidence bag box"
	desc = "A box claiming to contain evidence bags."
	storage_slots = 7
	can_hold = list(/obj/item/weapon/evidencebag)
	preloaded = list(
		/obj/item/weapon/evidencebag = 7
	)

/obj/item/storage/box/fingerprints
	name = "box of fingerprint cards"
	desc = "Sterilized equipment within. Do not contaminate."
	icon = 'icons/obj/forensics.dmi'
	icon_state = "dnakit"
	can_hold = list(/obj/item/weapon/sample/print)
	storage_slots = 14
	preloaded = list(
		/obj/item/weapon/sample/print = 14
	)

