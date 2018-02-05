/datum/gear/head
	slot = slot_head
	sort_category = "Hats and Headwear"

/datum/gear/head
	display_name = "Bandana (head)"
	path = /obj/item/clothing/head/bandana
	options = list(
		"pirate-red" = /obj/item/clothing/head/bandana,
		"green"  = /obj/item/clothing/head/greenbandana,
		"orange" = /obj/item/clothing/head/orangebandana
	)

/datum/gear/head/beret
	display_name = "beret"
	path = /obj/item/clothing/head/beret
	options = list(
		"red" = /obj/item/clothing/head/beret,
		"orange/engineer" = /obj/item/clothing/head/beret/eng,
		"purple/janitor" = /obj/item/clothing/head/beret/jan,
		"black" = /obj/item/clothing/head/beret/black
	)

/datum/gear/head/beret/sec
	display_name = "beret (security)"
	path = /obj/item/clothing/head/beret/sec
	allowed_roles = list("Security Officer","Head of Security","Warden")
	options = list(
		"red" = /obj/item/clothing/head/beret/sec,
		"navy" = /obj/item/clothing/head/beret/sec/alt
	)

/datum/gear/head/beret/sec_corp
	display_name = "beret, corporage (security)"
	path = /obj/item/clothing/head/beret/sec/alt/corp
	allowed_roles = list("Security Officer","Head of Security","Warden","Detective","Forensic Technician")

/datum/gear/uniform/job_jeans/spawn_for(var/mob/living/carbon/human/H)
	var/tmp_path = path
	switch(H.job)
		if("Head of Security")
			tmp_path = /obj/item/clothing/head/beret/sec/hos/corp
		if("Warden")
			tmp_path = /obj/item/clothing/head/beret/sec/warden/corp
		if("Security Officer")
			tmp_path = /obj/item/clothing/head/beret/sec/alt/corp
		else
			H << SPAN_WARN("Your current job does not permit you to spawn with [display_name]!")
	return new tmp_path(H)

/datum/gear/head/cap/corp
	display_name = "cap, corporate (Security)"
	path = /obj/item/clothing/head/soft/sec/corp
	allowed_roles = list("Security Officer","Head of Security","Warden", "Detective")

/datum/gear/head/cap/mailman
	display_name = "cap, blue station"
	path = /obj/item/clothing/head/mailman

/datum/gear/head/cap/flat
	display_name = "cap, brown-flat"
	path = /obj/item/clothing/head/flatcap

/datum/gear/head/cap/color
	display_name = "cap"
	path = /obj/item/clothing/head/soft/grey
	options = list(
		"grey"    = /obj/item/clothing/head/soft/grey,
		"blue"    = /obj/item/clothing/head/soft/blue,
		"green"   = /obj/item/clothing/head/soft/green,
		"orange"  = /obj/item/clothing/head/soft/orange,
		"purple"  = /obj/item/clothing/head/soft/purple,
		"rainbow" = /obj/item/clothing/head/soft/rainbow,
		"red"     = /obj/item/clothing/head/soft/red,
		"yellow"  = /obj/item/clothing/head/soft/yellow,
		"white"   = /obj/item/clothing/head/soft/mime
	)

/datum/gear/head/hairflower
	display_name = "hair flower pin, red"
	path = /obj/item/clothing/head/hairflower

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

/datum/gear/head/welding
	display_name = "welding helmet"
	path = /obj/item/clothing/head/welding
	options = list(
		"default"= /obj/item/clothing/head/welding,
		"flame"  = /obj/item/clothing/head/welding/flame,
		"white"  = /obj/item/clothing/head/welding/white,
		"blue"   = /obj/item/clothing/head/welding/blue
	)
	cost = 2

/datum/gear/head/boater
	display_name = "hat, boatsman"
	path = /obj/item/clothing/head/boaterhat

/datum/gear/head/bowler
	display_name = "hat, bowler"
	path = /obj/item/clothing/head/bowlerhat

/datum/gear/head/fez
	display_name = "hat, fez"
	path = /obj/item/clothing/head/fez

/datum/gear/head/tophat
	display_name = "hat, tophat"
	path = /obj/item/clothing/head/that

/datum/gear/head/philosopher_wig
	display_name = "natural philosopher's wig"
	path = /obj/item/clothing/head/philosopher_wig

/datum/gear/head/ushanka
	display_name = "ushanka"
	path = /obj/item/clothing/head/ushanka

/datum/gear/head/zhan_scarf
	display_name = "Zhan headscarf"
	path = /obj/item/clothing/head/tajaran/scarf
	whitelisted = SPECIES_TAJARA

/datum/gear/head/sombrero
	display_name = "sombrero"
	path = /obj/item/clothing/head/sombrero

/datum/gear/head/fedora
	display_name = "fedora"
	path = /obj/item/clothing/head/fedora
	cost = 2