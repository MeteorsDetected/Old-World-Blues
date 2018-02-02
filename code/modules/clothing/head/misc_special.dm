/*
 * Contents:
 *		Welding mask
 *		Cakehat
 *		Ushanka
 *		Pumpkin head
 *		Kitty ears
 *		Vox Captain Hat
 */

/*
 * Welding mask
 */
/obj/item/clothing/head/welding
	name = "welding helmet"
	desc = "A head-mounted face cover designed to protect the wearer completely from space-arc eye."
	icon_state = "welding"
	item_state = "welding"
	matter = list(MATERIAL_STEEL = 3000, MATERIAL_GLASS = 1000)
	var/up = 0
	armor = list(melee = 35, bullet = 10, laser = 20,energy = 10, bomb = 20, bio = 0, rad = 0)
	flags_inv = (HIDEMASK|HIDEEARS|HIDEEYES|HIDEFACE)
	body_parts_covered = HEAD|FACE|EYES
	icon_action_button = "action_welding"
	siemens_coefficient = 0.9
	w_class = ITEM_SIZE_NORMAL

/obj/item/clothing/head/welding/attack_self()
	toggle()

/obj/item/clothing/head/welding/verb/toggle()
	set category = "Object"
	set name = "Adjust welding mask"
	set src in usr

	if(usr.canmove && !usr.stat && !usr.restrained())
		if(src.up)
			src.up = !src.up
			body_parts_covered |= (EYES|FACE)
			flags_inv |= (HIDEMASK|HIDEEARS|HIDEEYES|HIDEFACE)
			icon_state = initial(icon_state)
			usr << "You flip the [src] down to protect your eyes."
		else
			src.up = !src.up
			body_parts_covered &= ~(EYES|FACE)
			flags_inv &= ~(HIDEMASK|HIDEEARS|HIDEEYES|HIDEFACE)
			icon_state = "[initial(icon_state)]up"
			usr << "You push the [src] up out of your face."
		update_clothing_icon()	//so our mob-overlays update

/obj/item/clothing/head/welding/flame
	name = "flame welding helmet"
	desc = "A head-mounted face cover designed to protect the wearer completely from space-arc eye with style."
	icon_state = "welding_flame"
	item_state = "welding_flame"

/obj/item/clothing/head/welding/white
	name = "white welding helmet"
	desc = "A head-mounted face cover designed to protect the wearer completely from space-arc eye with style."
	icon_state = "welding_white"
	item_state = "welding_white"

/obj/item/clothing/head/welding/blue
	name = "blue welding helmet"
	desc = "A head-mounted face cover designed to protect the wearer completely from space-arc eye with style."
	icon_state = "welding_blue"
	item_state = "welding_blue"

/obj/item/clothing/head/welding/knight
	name = "knightwelding welding helmet"
	desc = "A painted welding helmet, this one looks like a knights helmet."
	icon_state = "knightwelding"
	item_state = "knightwelding"

/obj/item/clothing/head/welding/engie
	name = "engineering welding helmet"
	desc = "A painted welding helmet, this one has been painted the engineering colours."
	icon_state = "engiewelding"
	item_state = "engiewelding"

/obj/item/clothing/head/welding/demon
	name = "demonic welding helmet"
	desc = "A painted welding helmet, this one has a demonic face on it."
	icon_state = "demonwelding"
	item_state = "demonwelding"

/obj/item/clothing/head/welding/fancy
	name = "fancy welding helmet"
	desc = "A painted welding helmet, the black and gold make this one look very fancy."
	icon_state = "fancywelding"
	item_state = "fancywelding"

/obj/item/clothing/head/welding/navy_blue
	name = "navy blue welding helmet"
	desc = "A head-mounted face cover designed to protect the wearer completely from space-arc eye with style."
	icon_state = "navy_blue"
	item_state = "navy_blue"

obj/item/clothing/head/welding/welding_hot
	name = "Comin'In Hot welding helmet"
	desc = "A head-mounted face cover designed to protect the wearer completely from space-arc eye with style. Inscription on a helmet: from Chloe N."
	icon_state = "welding_hot"
	item_state = "welding_hot"

/*
 * Cakehat
 */
/obj/item/clothing/head/cakehat
	name = "cake-hat"
	desc = "It's tasty looking!"
	icon_state = "cake0"
	var/onfire = 0.0
	var/status = 0
	//this is the max temp it can stand before you start to cook. although it might not burn away, you take damage
	var/fire_resist = T0C+1300
	var/processing = 0 //I dont think this is used anywhere.
	body_parts_covered = HEAD

/obj/item/clothing/head/cakehat/process()
	if(!onfire)
		processing_objects.Remove(src)
		return

	var/turf/location = src.loc
	if(istype(location, /mob/))
		var/mob/living/carbon/human/M = location
		if(M.l_hand == src || M.r_hand == src || M.head == src)
			location = M.loc

	if (istype(location, /turf))
		location.hotspot_expose(700, 1)

/obj/item/clothing/head/cakehat/attack_self(mob/user as mob)
	if(status > 1)	return
	src.onfire = !( src.onfire )
	if (src.onfire)
		src.force = 3
		src.damtype = "fire"
		src.icon_state = "cake1"
		processing_objects.Add(src)
	else
		src.force = null
		src.damtype = "brute"
		src.icon_state = "cake0"
	return


/*
 * Ushanka
 */
/obj/item/clothing/head/ushanka
	name = "ushanka"
	desc = "Perfect for winter in Siberia, da?"
	icon_state = "ushankadown"
	item_state = "ushankadown"
	flags_inv = HIDEEARS

/obj/item/clothing/head/ushanka/attack_self(mob/user as mob)
	if(src.icon_state == "ushankadown")
		src.icon_state = "ushankaup"
		src.item_state = "ushankaup"
		user << "You raise the ear flaps on the ushanka."
	else
		src.icon_state = "ushankadown"
		src.item_state = "ushankadown"
		user << "You lower the ear flaps on the ushanka."

/*
 * Pumpkin head
 */
/obj/item/clothing/head/pumpkinhead
	name = "carved pumpkin"
	desc = "A jack o' lantern! Believed to ward off evil spirits."
	icon_state = "hardhat0_pumpkin"//Could stand to be renamed
	flags_inv = HIDEMASK|HIDEEARS|HIDEEYES|HIDEFACE|BLOCKHAIR
	body_parts_covered = HEAD|FACE|EYES
	brightness_on = 2
	light_overlay = "helmet_light"
	w_class = ITEM_SIZE_NORMAL

/*
 * Kitty ears
 */
/obj/item/clothing/head/kitty
	name = "kitty ears"
	desc = "A pair of kitty ears. Meow!"
	icon_state = "kitty"
	body_parts_covered = 0
	siemens_coefficient = 1.5

	equipped(var/mob/living/carbon/human/user, var/slot)
		if(!istype(user) || slot!=slot_head) return
		var/icon/ears = new/icon(user.body_build.get_mob_icon("head", "kitty"), "kitty")
		ears.Blend(user.hair_color, ICON_ADD)

		var/icon/earbit = new/icon(user.body_build.get_mob_icon("head", "kittyinner"), "kittyinner")
		ears.Blend(earbit, ICON_OVERLAY)

		icon_override = ears

	dropped()
		icon_override = null

/obj/item/clothing/head/richard
	name = "chicken mask"
	desc = "You can hear the distant sounds of rhythmic electronica."
	icon_state = "richard"
	body_parts_covered = HEAD|FACE
	flags_inv = BLOCKHAIR

/obj/item/clothing/head/vox_cap
	name = "vox captain's hat"
	desc = "KHAAAAK!"
	icon_state = "vox-captain_hat"
	item_state = "vox-captain_hat"
	species_restricted = list(SPECIES_VOX)
