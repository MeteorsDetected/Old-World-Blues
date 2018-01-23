//Mining
/obj/item/clothing/head/helmet/space/void/mining
	name = "mining voidsuit helmet"
	desc = "A scuffed voidsuit helmet with a boosted communication system and reinforced armor plating."
	icon_state = "rig0-mining"
	item_state = "mining_helm"
	armor = list(melee = 50, bullet = 5, laser = 20,energy = 5, bomb = 55, bio = 100, rad = 20)
	light_overlay = "helmet_light_dual"
	sprite_sheets_refit = list(
		SPECIES_UNATHI = 'icons/inv_slots/hats/mob_unathi.dmi',
		SPECIES_TAJARA = 'icons/inv_slots/hats/mob_tajaran.dmi',
		SPECIES_SKRELL = 'icons/inv_slots/hats/mob_skrell.dmi',
		SPECIES_VOX    = 'icons/inv_slots/hats/mob_vox.dmi'
	)
	sprite_sheets_obj = list(
		SPECIES_UNATHI = 'icons/inv_slots/hats/icon_unathi.dmi',
		SPECIES_TAJARA = 'icons/inv_slots/hats/icon_tajaran.dmi',
		SPECIES_SKRELL = 'icons/inv_slots/hats/icon_skrell.dmi',
		SPECIES_VOX    = 'icons/inv_slots/hats/icon_vox.dmi'
	)

/obj/item/clothing/suit/space/void/mining
	icon_state = "mining-void"
	item_state = "mining-void"
	name = "mining voidsuit"
	desc = "A grimy, decently armored voidsuit with purple blazes and extra insulation."
	armor = list(melee = 50, bullet = 5, laser = 20,energy = 5, bomb = 55, bio = 100, rad = 20)
	sprite_sheets_refit = list(
		SPECIES_UNATHI = 'icons/inv_slots/suits/mob_unathi.dmi',
		SPECIES_TAJARA = 'icons/inv_slots/suits/mob_tajaran.dmi',
		SPECIES_SKRELL = 'icons/inv_slots/suits/mob_skrell.dmi',
		SPECIES_VOX    = 'icons/inv_slots/suits/mob_vox.dmi'
	)
	sprite_sheets_obj = list(
		SPECIES_UNATHI = 'icons/inv_slots/suits/icon_unathi.dmi',
		SPECIES_TAJARA = 'icons/inv_slots/suits/icon_tajaran.dmi',
		SPECIES_SKRELL = 'icons/inv_slots/suits/icon_skrell.dmi',
		SPECIES_VOX    = 'icons/inv_slots/suits/icon_vox.dmi'
	)

/obj/item/clothing/suit/space/void/mining/prepared/New()
	..()
	helmet = new /obj/item/clothing/head/helmet/space/void/mining


//Surplus Voidsuits
/obj/item/clothing/head/helmet/space/void/mining/alt
	name = "frontier mining voidsuit helmet"
	desc = "An armored voidsuit helmet. Someone must have through they were pretty cool when they painted a mohawk on it."
	icon_state = "rig0-miningalt"
	item_state = "miningalt_helm"
	armor = list(melee = 50, bullet = 15, laser = 20,energy = 5, bomb = 55, bio = 100, rad = 0)

/obj/item/clothing/suit/space/void/mining/alt
	icon_state = "miningalt-void"
	name = "frontier mining voidsuit"
	desc = "A cheap prospecting voidsuit. What it lacks in comfort it makes up for in armor plating and street cred."
	armor = list(melee = 50, bullet = 15, laser = 20,energy = 5, bomb = 55, bio = 100, rad = 0)

/obj/item/clothing/suit/space/void/mining/alt/prepared/New()
	..()
	helmet = new /obj/item/clothing/head/helmet/space/void/mining/alt
