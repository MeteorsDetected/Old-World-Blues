// Eyes
/datum/gear/eyes
	display_name = "eyepatch"
	path = /obj/item/clothing/glasses/eyepatch
	slot = slot_glasses
	sort_category = "Glasses and Eyewear"

/datum/gear/eyes/glasses
	display_name = "Glasses, prescription"
	path = /obj/item/clothing/glasses/regular

/datum/gear/eyes/glasses/green
	display_name = "Glasses (color)"
	path = /obj/item/clothing/glasses/gglasses
	options = list(
		"green" = /obj/item/clothing/glasses/gglasses,
		"orange"= /obj/item/clothing/glasses/orange,
		"red"   = /obj/item/clothing/glasses/red
	)

/datum/gear/eyes/glasses/aviator
	display_name = "Glasses, aviator"
	path = /obj/item/clothing/glasses/sunglasses/aviator
	options = list(
		"aviator"               = /obj/item/clothing/glasses/sunglasses/aviator,
		"black aviator"         = /obj/item/clothing/glasses/sunglasses/aviator_black,
		"bloody aviator"        = /obj/item/clothing/glasses/sunglasses/aviator_bloody
		/*"engineering aviators"  = /obj/item/clothing/glasses/meson/aviator/prescription,
		"medical HUD aviators"  = /obj/item/clothing/glasses/hud/health/aviator,
		"security HUD aviators" = /obj/item/clothing/glasses/sunglasses/sechud/aviator */
	)

/datum/gear/head/hardhat
	display_name = "hardhat"
	path = /obj/item/clothing/head/hardhat
	cost = 2
	options = list(
		"yellow" = /obj/item/clothing/head/hardhat,
		"blue"   = /obj/item/clothing/head/hardhat/dblue,
		"orange" = /obj/item/clothing/head/hardhat/orange,
		"red"    = /obj/item/clothing/head/hardhat/red
	)

/datum/gear/eyes/glasses/prescriptionhipster
	display_name = "Glasses, hipster"
	path = /obj/item/clothing/glasses/regular/hipster

/datum/gear/eyes/glasses/monocle
	display_name = "Monocle"
	path = /obj/item/clothing/glasses/monocle

/datum/gear/eyes/scanning_goggles
	display_name = "Scanning goggles"
	path = /obj/item/clothing/glasses/regular/scanners

/datum/gear/eyes/sciencegoggles
	display_name = "Science Goggles"
	path = /obj/item/clothing/glasses/science

/datum/gear/eyes/security
	display_name = "Security HUD (Security)"
	path = /obj/item/clothing/glasses/hud/security
	cost = 2
	allowed_roles = list("Security Officer","Head of Security","Warden","Detective")

/datum/gear/eyes/medical
	display_name = "Medical HUD (Medical)"
	path = /obj/item/clothing/glasses/hud/health
	allowed_roles = list("Medical Doctor","Chief Medical Officer","Paramedic")

/datum/gear/eyes/medical/prescription
	display_name = "Medical HUD, prescription (Medical)"
	path = /obj/item/clothing/glasses/hud/health/prescription

/datum/gear/eyes/crimson
	display_name = "Sunglasses, crimson"
	path = /obj/item/clothing/glasses/sunglasses/red
	cost = 2

/datum/gear/eyes/shades
	display_name = "Sunglasses, fat (Security/Command)"
	path = /obj/item/clothing/glasses/sunglasses/big
	allowed_roles = list(
		"Security Officer","Head of Security","Warden","Captain","Head of Personnel",
		"Quartermaster","Internal Affairs Agent","Detective"
	)

/datum/gear/eyes/shades/prescriptionsun
	display_name = "Sunglasses, presciption (Security/Command)"
	path = /obj/item/clothing/glasses/sunglasses/prescription
	cost = 2

