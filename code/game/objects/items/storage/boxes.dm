/*
 *	Everything derived from the common cardboard box.
 *	Basically everything except the original is a kit (starts full).
 *
 *	Contains:
 *		Empty box, starter boxes (survival/engineer),
 *		Latex glove and sterile mask boxes,
 *		Syringe, beaker, dna injector boxes,
 *		Blanks, flashbangs, and EMP grenade boxes,
 *		Tracking and chemical implant boxes,
 *		Prescription glasses and drinking glass boxes,
 *		Condiment bottle and silly cup boxes,
 *		Donkpocket and monkeycube boxes,
 *		ID and security PDA cart boxes,
 *		Handcuff, mousetrap, and pillbottle boxes,
 *		Snap-pops and matchboxes,
 *		Replacement light boxes.
 *
 *		For syndicate call-ins see uplink_kits.dm
 */

/obj/item/storage/box
	name = "box"
	desc = "It's just an ordinary box."
	icon_state = "box"
	item_state = "syringe_kit"
	max_storage_space = DEFAULT_BOX_STORAGE
	// BubbleWrap - if set, can be folded (when empty) into a sheet of cardboard
	var/foldable = /obj/item/stack/material/cardboard
	max_w_class = ITEM_SIZE_SMALL

// BubbleWrap - A box can be folded up to make card
/obj/item/storage/box/attack_self(mob/user as mob)
	if(..()) return

	//try to fold it.
	if ( contents.len )
		return

	if ( !ispath(src.foldable) )
		return
	var/found = 0
	// Close any open UI windows first
	for(var/mob/M in range(1))
		if (M.s_active == src)
			src.close(M)
		if ( M == user )
			found = 1
	if ( !found )	// User is too far away
		return
	// Now make the cardboard
	user << SPAN_NOTE("You fold [src] flat.")
	new src.foldable(get_turf(src))
	qdel(src)

/obj/item/storage/box/survival
	preloaded = list(
		/obj/item/clothing/mask/breath,
		/obj/item/weapon/tank/emergency_oxygen,
	)

/obj/item/storage/box/vox
	preloaded = list(
		/obj/item/clothing/mask/vox_breath,
		/obj/item/weapon/tank/emergency_nitrogen,
	)

/obj/item/storage/box/engineer
	preloaded = list(
		/obj/item/clothing/mask/breath,
		/obj/item/weapon/tank/emergency_oxygen/engi,
	)

/obj/item/storage/box/gloves
	name = "box of latex gloves"
	desc = "Contains white gloves."
	icon_state = "latex"
	preloaded = list(
		/obj/item/clothing/gloves/latex = 7
	)

/obj/item/storage/box/ems
	name = "box of nitrile gloves"
	desc = "Contains black gloves."
	icon_state = "nitrile"
	preloaded = list(
		/obj/item/clothing/gloves/latex/emt = 7
	)

/obj/item/storage/box/masks
	name = "box of sterile masks"
	desc = "This box contains masks of sterility."
	icon_state = "sterile"
	preloaded = list(
		/obj/item/clothing/mask/surgical = 7
	)

/obj/item/storage/box/syringes
	name = "box of syringes"
	desc = "A box full of syringes."
	icon_state = "syringe"
	preloaded = list(
		/obj/item/weapon/reagent_containers/syringe = 7
	)

/obj/item/storage/box/beakers
	name = "box of beakers"
	icon_state = "beaker"
	preloaded = list(
		/obj/item/weapon/reagent_containers/glass/beaker = 7
	)
/*
/obj/item/storage/box/injectors
	name = "box of DNA injectors"
	desc = "This box contains injectors it seems."
*/
/obj/item/storage/box/blanks
	name = "box of blank shells"
	desc = "It has a picture of a gun and several warning symbols on the front."
	icon_state = "practiceshot_box"
	preloaded = list(
		/obj/item/ammo_casing/shotgun/blank = 7
	)

/obj/item/storage/box/beanbags
	name = "box of beanbag shells"
	desc = "It has a picture of a gun and several warning symbols on the front.<br>WARNING: Live ammunition. Misuse may result in serious injury or death."
	icon_state = "rubbershot_box"
	preloaded = list(
		/obj/item/ammo_casing/shotgun/beanbag = 7
	)

/obj/item/storage/box/shotgunammo
	name = "box of shotgun slugs"
	desc = "It has a picture of a gun and several warning symbols on the front.<br>WARNING: Live ammunition. Misuse may result in serious injury or death."
	icon_state = "slugshot_box"
	preloaded = list(
		/obj/item/ammo_casing/shotgun = 7
	)

/obj/item/storage/box/shotgunshells
	name = "box of shotgun shells"
	desc = "It has a picture of a gun and several warning symbols on the front.<br>WARNING: Live ammunition. Misuse may result in serious injury or death."
	icon_state = "lethalshot_box"
	preloaded = list(
		/obj/item/ammo_casing/shotgun/pellet = 7
	)

/obj/item/storage/box/flashshells
	name = "box of illumination shells"
	desc = "It has a picture of a gun and several warning symbols on the front.<br>WARNING: Live ammunition. Misuse may result in serious injury or death."
	icon_state = "flashshot_box"
	preloaded = list(
		/obj/item/ammo_casing/shotgun/flash = 7
	)

/obj/item/storage/box/stunshells
	name = "box of stun shells"
	desc = "It has a picture of a gun and several warning symbols on the front.<br>WARNING: Live ammunition. Misuse may result in serious injury or death."
	icon_state = "stunshot_box"
	preloaded = list(
		/obj/item/ammo_casing/shotgun/stunshell = 7
	)

/obj/item/storage/box/practiceshells
	name = "box of practice shells"
	desc = "It has a picture of a gun and several warning symbols on the front.<br>WARNING: Live ammunition. Misuse may result in serious injury or death."
	icon_state = "practiceshot_box"
	preloaded = list(
		/obj/item/ammo_casing/shotgun/practice = 7
	)

/obj/item/storage/box/sniperammo
	name = "box of 14.5mm shells"
	desc = "It has a picture of a gun and several warning symbols on the front.<br>WARNING: Live ammunition. Misuse may result in serious injury or death."
	preloaded = list(
		/obj/item/ammo_casing/a145 = 7
	)

/obj/item/storage/box/flashbangs
	name = "box of flashbangs (WARNING)"
	desc = "<B>WARNING: These devices are extremely dangerous and can cause blindness or deafness in repeated use.</B>"
	icon_state = "flashbang"
	preloaded = list(
		/obj/item/weapon/grenade/flashbang = 7
	)

/obj/item/storage/box/teargas
	name = "box of teargas grenades (WARNING)"
	desc = "<B>WARNING: These devices are extremely dangerous and can cause blindness in repeated use.</B>"
	icon_state = "flashbang"
	preloaded = list(
		/obj/item/weapon/grenade/chem_grenade/teargas = 7
	)

/obj/item/storage/box/emps
	name = "box of emp grenades"
	desc = "A box containing 5 military grade EMP grenades.<br> WARNING: Do not use near unshielded electronics or biomechanical augmentations, death or permanent paralysis may occur."
	icon_state = "flashbang"
	preloaded = list(
		/obj/item/weapon/grenade/empgrenade = 5
	)

/obj/item/storage/box/smoke
	name = "box of smoke grenades (WARNING)"
	desc = "<B>WARNING: These devices are extremely dangerous and can cause blindness in repeated use.</B>"
	icon_state = "flashbang"
	preloaded = list(
		/obj/item/weapon/grenade/smokebomb = 7
	)

/obj/item/storage/box/trackimp
	name = "boxed tracking implant kit"
	desc = "Box full of scum-bag tracking utensils."
	icon_state = "implant"
	preloaded = list(
		/obj/item/weapon/implantcase/tracking = 4,
		/obj/item/weapon/implanter,
		/obj/item/weapon/implantpad,
		/obj/item/weapon/locator,
	)

/obj/item/storage/box/chemimp
	name = "boxed chemical implant kit"
	desc = "Box of stuff used to implant chemicals."
	icon_state = "implant"
	preloaded = list(
		/obj/item/weapon/implantcase/chem = 5,
		/obj/item/weapon/implanter,
		/obj/item/weapon/implantpad
	)

/obj/item/storage/box/inhibitionimp
	name = "boxed prosthesis inhibition implant kit"
	desc = "Box of stuff used to deactivate and lock human prosthesis or embed modules."
	icon_state = "implant"
	preloaded = list(
		/obj/item/weapon/implant/prosthesis_inhibition = 5,
		/obj/item/weapon/implanter,
		/obj/item/weapon/implantpad
	)

/obj/item/storage/box/rxglasses
	name = "box of prescription glasses"
	desc = "This box contains nerd glasses."
	icon_state = "glasses"
	preloaded = list(/obj/item/clothing/glasses/regular = 7)

/obj/item/storage/box/drinkingglasses
	name = "box of drinking glasses"
	desc = "It has a picture of drinking glasses on it."
	preloaded = list(/obj/item/weapon/reagent_containers/glass/drinks/drinkingglass = 7)

/obj/item/storage/box/cdeathalarm_kit
	name = "death alarm kit"
	desc = "Box of stuff used to implant death alarms."
	icon_state = "implant"
	preloaded = list(
		/obj/item/weapon/implantcase/death_alarm = 7,
		/obj/item/weapon/implanter
	)

/obj/item/storage/box/condimentbottles
	name = "box of condiment bottles"
	desc = "It has a large ketchup smear on it."
	preloaded = list(/obj/item/weapon/reagent_containers/condiment = 7)

/obj/item/storage/box/cups
	name = "box of paper cups"
	desc = "It has pictures of paper cups on the front."
	preloaded = list(/obj/item/weapon/reagent_containers/glass/drinks/sillycup = 7)

/obj/item/storage/box/donkpockets
	name = "box of donk-pockets"
	desc = "<B>Instructions:</B> <I>Heat in microwave. Product will cool if not eaten within seven minutes.</I>"
	icon_state = "donk_kit"
	preloaded = list(/obj/item/weapon/reagent_containers/food/snacks/donkpocket = 7)

/obj/item/storage/box/sinpockets
	name = "box of sin-pockets"
	desc = "<B>Instructions:</B> <I>Crush bottom of package to initiate chemical heating. Wait for 20 seconds before consumption. Product will cool if not eaten within seven minutes.</I>"
	icon_state = "donk_kit"
	preloaded = list(/obj/item/weapon/reagent_containers/food/snacks/donkpocket/sinpocket = 7)

/obj/item/storage/box/monkeycubes
	name = "monkey cube box"
	desc = "Drymate brand monkey cubes. Just add water!"
	icon = 'icons/obj/food.dmi'
	icon_state = "monkeycubebox"
	can_hold = list(/obj/item/weapon/reagent_containers/food/snacks/monkeycube)
	preloaded = list(/obj/item/weapon/reagent_containers/food/snacks/monkeycube/wrapped = 4)

/obj/item/storage/box/monkeycubes/farwacubes
	name = "farwa cube box"
	desc = "Drymate brand farwa cubes, shipped from Ahdomai. Just add water!"
	preloaded = list(/obj/item/weapon/reagent_containers/food/snacks/monkeycube/wrapped/farwacube = 4)

/obj/item/storage/box/monkeycubes/stokcubes
	name = "stok cube box"
	desc = "Drymate brand stok cubes, shipped from Moghes. Just add water!"
	preloaded = list(/obj/item/weapon/reagent_containers/food/snacks/monkeycube/wrapped/stokcube = 4)

/obj/item/storage/box/monkeycubes/neaeracubes
	name = "neaera cube box"
	desc = "Drymate brand neaera cubes, shipped from Jargon 4. Just add water!"
	preloaded = list(/obj/item/weapon/reagent_containers/food/snacks/monkeycube/wrapped/neaeracube = 4)

/obj/item/storage/box/ids
	name = "box of spare IDs"
	desc = "Has so many empty IDs."
	icon_state = "id"
	preloaded = list(/obj/item/weapon/card/id = 7)

/obj/item/storage/box/seccarts
	name = "box of spare R.O.B.U.S.T. Cartridges"
	desc = "A box full of R.O.B.U.S.T. Cartridges, used by Security."
	icon_state = "pda"
	preloaded = list(/obj/item/weapon/cartridge/security = 7)

/obj/item/storage/box/handcuffs
	name = "box of spare handcuffs"
	desc = "A box full of handcuffs."
	icon_state = "handcuff"
	preloaded = list(/obj/item/weapon/handcuffs = 7)

/obj/item/storage/box/mousetraps
	name = "box of Pest-B-Gon mousetraps"
	desc = "<B><FONT color='red'>WARNING:</FONT></B> <I>Keep out of reach of children</I>."
	icon_state = "mousetraps"
	preloaded = list(/obj/item/device/assembly/mousetrap = 7)

/obj/item/storage/box/pillbottles
	name = "box of pill bottles"
	desc = "It has pictures of pill bottles on its front."
	preloaded = list(/obj/item/storage/pill_bottle = 7)

/obj/item/storage/box/snappops
	name = "snap pop box"
	desc = "Eight wrappers of fun! Ages 8 and up. Not suitable for children."
	icon = 'icons/obj/toy.dmi'
	icon_state = "spbox"
	can_hold = list(/obj/item/toy/snappop)
	preloaded = list(/obj/item/toy/snappop = 8)

/obj/item/storage/box/matches
	name = "matchbox"
	desc = "A small box of 'Space-Proof' premium matches."
	icon = 'icons/obj/cigarettes.dmi'
	icon_state = "matchbox"
	item_state = "zippo"
	sprite_group = null
	w_class = ITEM_SIZE_TINY
	slot_flags = SLOT_BELT
	can_hold = list(/obj/item/weapon/flame/match)
	preloaded = list(/obj/item/weapon/flame/match = 10)

/obj/item/storage/box/matches/attackby(obj/item/weapon/flame/match/W, mob/living/user)
	if(istype(W) && !W.lit && !W.burnt)
		W.lit = 1
		W.damtype = "burn"
		W.icon_state = "match_lit"
		processing_objects.Add(W)
	W.update_icon()

/obj/item/storage/box/autoinjectors
	name = "box of injectors"
	desc = "Contains autoinjectors."
	icon_state = "syringe"
	preloaded = list(/obj/item/weapon/reagent_containers/hypospray/autoinjector = 7)

/obj/item/storage/box/lights
	name = "box of replacement bulbs"
	icon = 'icons/obj/storage.dmi'
	icon_state = "light"
	desc = "This box is shaped on the inside so that only light tubes and bulbs fit."
	storage_slots = 21
	can_hold = list(/obj/item/weapon/light/tube, /obj/item/weapon/light/bulb)
	max_storage_space = 21 * ITEM_SIZE_SMALL //holds 21 items of w_class 2
	use_to_pickup = TRUE // for picking up broken bulbs, not that most people will try

/obj/item/storage/box/lights/bulbs
	preloaded = list(/obj/item/weapon/light/bulb = 24)

/obj/item/storage/box/lights/tubes
	name = "box of replacement tubes"
	icon_state = "lighttube"
	preloaded = list(/obj/item/weapon/light/tube = 24)

/obj/item/storage/box/lights/mixed
	name = "box of replacement lights"
	icon_state = "lightmixed"
	preloaded = list(
		/obj/item/weapon/light/tube = 16,
		/obj/item/weapon/light/bulb = 8
	)

/obj/item/storage/box/freezer
	name = "portable freezer"
	desc = "This nifty shock-resistant device will keep your 'groceries' nice and non-spoiled."
	icon = 'icons/obj/storage.dmi'
	icon_state = "portafreezer"
	item_state = "medicalpack"
	sprite_group = SPRITE_BACKPACK
	foldable = null
	max_w_class = ITEM_SIZE_NORMAL
	w_class = ITEM_SIZE_HUGE
	can_hold = list(
		/obj/item/organ,
		/obj/item/weapon/reagent_containers/food,
		/obj/item/weapon/reagent_containers/glass
	)
	max_storage_space = DEFAULT_BACKPACK_STORAGE
	use_to_pickup = 1 // for picking up broken bulbs, not that most people will try

/obj/item/storage/box/freezer/Entered(var/atom/movable/AM)
	if(istype(AM, /obj/item/organ))
		var/obj/item/organ/O = AM
		O.preserved = 1
		for(var/obj/item/organ/organ in O)
			organ.preserved = TRUE
	..()

/obj/item/storage/box/freezer/Exited(var/atom/movable/AM)
	if(istype(AM, /obj/item/organ))
		var/obj/item/organ/O = AM
		O.preserved = 0
		for(var/obj/item/organ/organ in O)
			organ.preserved = FALSE
	..()

/obj/item/storage/box/underwear
	icon_state = "underwear"
	name = "underwear box"
	can_hold = list(/obj/item/clothing/hidden)
	storage_slots = 9
	max_storage_space = 9

/obj/item/storage/box/underwear/populateContents()
	var/tmp_type
	for(var/i = 1 to 3)
		tmp_type = pick(subtypesof(/obj/item/clothing/hidden/underwear))
		new tmp_type(src)
	for(var/i = 1 to 3)
		tmp_type = pick(subtypesof(/obj/item/clothing/hidden/undershirt))
		new tmp_type(src)
	for(var/i = 1 to 3)
		tmp_type = pick(subtypesof(/obj/item/clothing/hidden/socks))
		new tmp_type(src)
	..()

