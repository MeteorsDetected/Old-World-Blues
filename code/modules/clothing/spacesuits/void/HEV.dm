/obj/item/clothing/head/helmet/space/void/hev
	name = "hev helmet"
	desc = "A high-tech dark red space suit helmet. Used for AI satellite maintenance."
	icon_state = "hev"
	armor = list(melee = 10, bullet = 10, laser = 15,energy = 10, bomb = 20, bio = 90, rad = 80)
	species_restricted = list(SPECIES_HUMAN)

/obj/item/clothing/suit/space/void/hev
	name = "hev"
	icon_state = "hev"
	w_class = ITEM_SIZE_HUGE//bulky item
	desc = "A high-tech dark red space suit. Used for AI satellite maintenance."
	slowdown = 1
	armor = list(melee = 10, bullet = 15, laser = 20,energy = 10, bomb = 25, bio = 90, rad = 80)
	allowed = list(/obj/item/device/flashlight,/obj/item/weapon/tank,/obj/item/device/suit_cooling_unit)
	species_restricted = list(SPECIES_HUMAN)
	can_breach = FALSE
	//(live support)
	var/list/mob_states

/obj/item/clothing/suit/space/void/hev/refit_for_species()
	return null

/obj/item/clothing/suit/space/void/hev/New()
	..()
	processing_objects |= src

/obj/item/clothing/suit/space/void/hev/process()
	var/list/new_mob_states = list()

/obj/item/clothing/suit/space/void/hev/process()
	if(!ishuman(loc))
		return
	var/mob/living/carbon/human/H = loc
		if(H.get_equipped_item(slot_wear_suit) != src)
			reutrn
	var/list/new_mob_states = list()
	var/list/broken_limbs = list()
	var/list/bleeding_limbs = list()
		if(E.is_broken())
			broken_limbs  += E
		if(E.stat & ORGAN_BLEEDING)
			bleeding_limbs += E
	new_mob_states["burn"] = H.getFireLoss()
	new_mob_states["tox"] = H.getToxLoss()
		if(mob_stats) //no first run
	mob_stats = new_mob_stats
	mob_stats["broken"] = broken_limbs
	mob_stats["bleeding"] = bleeding_limbs
