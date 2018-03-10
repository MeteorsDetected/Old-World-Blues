/*
 * The 'fancy' path is for objects like donut boxes that show how many items are in the storage item on the sprite itself
 * .. Sorry for the shitty path name, I couldnt think of a better one.
 *
 * WARNING: var/icon_type is used for both examine text and sprite name. Please look at the procs below and adjust your sprite names accordingly
 *		TODO: Cigarette boxes should be ported to this standard
 *
 * Contains:
 *		Donut Box
 *		Egg Box
 *		Candle Box
 *		Crayon Box
 *		Cigarette Box
 */

/obj/item/storage/fancy
	icon = 'icons/obj/food.dmi'
	icon_state = "donutbox6"
	name = "donut box"
	var/icon_type = "donut"
	var/fill_type = null

/obj/item/storage/fancy/update_icon()
	..()
	src.icon_state = "[src.icon_type]box[src.contents.len]"

/obj/item/storage/fancy/populateContents()
	..()
	for(var/i in 1 to storage_slots - contents.len)
		PoolOrNew(fill_type, src)

/obj/item/storage/fancy/examine(mob/user, return_dist = 1)
	.=..()
	if(.>4)
		return

	if(contents.len <= 0)
		user << "There are no [src.icon_type]s left in the box."
	else if(contents.len == 1)
		user << "There is one [src.icon_type] left in the box."
	else
		user << "There are [src.contents.len] [src.icon_type]s in the box."

/*
 * Egg Box
 */

/obj/item/storage/fancy/egg_box
	icon = 'icons/obj/food.dmi'
	icon_state = "eggbox"
	name = "egg box"
	icon_type = "egg"
	fill_type = /obj/item/weapon/reagent_containers/food/snacks/egg
	storage_slots = 12
	max_w_class = ITEM_SIZE_SMALL
	w_class = ITEM_SIZE_NORMAL

	can_hold = list(
		/obj/item/weapon/reagent_containers/food/snacks/egg,
		/obj/item/weapon/reagent_containers/food/snacks/boiledegg
		)


/*
 * Candle Box
 */

/obj/item/storage/fancy/candle_box
	name = "candle pack"
	desc = "A pack of red candles."
	icon = 'icons/obj/candle.dmi'
	icon_state = "candlebox5"
	icon_type = "candle"
	fill_type = /obj/item/weapon/flame/candle
	item_state = "candlebox5"
	storage_slots = 5
	throwforce = 2
	w_class = ITEM_SIZE_SMALL
	max_w_class = ITEM_SIZE_TINY
	max_storage_space = 5
	slot_flags = SLOT_BELT

/*
 * Crayon Box
 */

/obj/item/storage/fancy/crayons
	name = "box of crayons"
	desc = "A box of crayons for all your rune drawing needs."
	icon = 'icons/obj/crayons.dmi'
	icon_state = "crayonbox"
	w_class = ITEM_SIZE_SMALL
	max_w_class = ITEM_SIZE_TINY
	max_storage_space = 6
	storage_slots = 6
	icon_type = "crayon"
	can_hold = list(
		/obj/item/weapon/pen/crayon
	)
	preloaded = list(
		/obj/item/weapon/pen/crayon/red,
		/obj/item/weapon/pen/crayon/orange,
		/obj/item/weapon/pen/crayon/yellow,
		/obj/item/weapon/pen/crayon/green,
		/obj/item/weapon/pen/crayon/blue,
		/obj/item/weapon/pen/crayon/purple,
	)

/obj/item/storage/fancy/crayons/initialize()
	..()
	update_icon()

/obj/item/storage/fancy/crayons/update_icon()
	overlays = list() //resets list
	overlays += "crayonbox"
	for(var/obj/item/weapon/pen/crayon/crayon in contents)
		overlays += image('icons/obj/crayons.dmi',crayon.colourName)

/obj/item/storage/fancy/crayons/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W,/obj/item/weapon/pen/crayon))
		switch(W:colourName)
			if("mime")
				usr << "This crayon is too sad to be contained in this box."
				return
			if("rainbow")
				usr << "This crayon is too powerful to be contained in this box."
				return
	..()

////////////
//CIG PACK//
////////////
/obj/item/storage/fancy/cigarettes
	name = "cigarette packet"
	desc = "The most popular brand of Space Cigarettes, sponsors of the Space Olympics."
	icon = 'icons/obj/cigarettes.dmi'
	icon_state = "cigpacket"
	item_state = "cigpacket"
	w_class = ITEM_SIZE_SMALL
	max_w_class = ITEM_SIZE_TINY
	max_storage_space = 6
	throwforce = 2
	slot_flags = SLOT_BELT
	storage_slots = 6
	can_hold = list(/obj/item/clothing/mask/smokable/cigarette, /obj/item/weapon/flame/lighter)
	icon_type = "cigarette"
	fill_type = /obj/item/clothing/mask/smokable/cigarette

/obj/item/storage/fancy/cigarettes/populateContents()
	..()
	//Allow people inject cigarettes without opening a packet
	flags |= NOREACT
	create_reagents(15 * storage_slots)

/obj/item/storage/fancy/cigarettes/update_icon()
	icon_state = "[initial(icon_state)][contents.len]"

/obj/item/storage/fancy/cigarettes/remove_from_storage(obj/item/W as obj, atom/new_location)
	var/obj/item/clothing/mask/smokable/cigarette/C = W
	if(!istype(C))
		return
	reagents.trans_to_obj(C, (reagents.total_volume/contents.len))
	..()

/obj/item/storage/fancy/cigarettes/attack(mob/living/carbon/M, mob/living/carbon/user)
	if(!ismob(M))
		return

	if(M == user && user.zone_sel.selecting == O_MOUTH && contents.len > 0 && !user.wear_mask)
		var/obj/item/clothing/mask/smokable/cigarette/W = new /obj/item/clothing/mask/smokable/cigarette(user)
		reagents.trans_to_obj(W, (reagents.total_volume/contents.len))
		user.equip_to_slot_if_possible(W, slot_wear_mask)
		reagents.maximum_volume = 15 * contents.len
		contents.len--
		user << SPAN_NOTE("You take a cigarette out of the pack.")
		update_icon()
	else
		..()

/obj/item/storage/fancy/cigarettes/dromedaryco
	name = "\improper DromedaryCo packet"
	desc = "A packet of six imported DromedaryCo cancer sticks. A label on the packaging reads, \"Wouldn't a slow death make a change?\""
	icon_state = "Dpacket"
	item_state = "Dpacket"

/obj/item/storage/fancy/cigarettes/killthroat
	name = "\improper AcmeCo packet"
	desc = "A packet of six AcmeCo cigarettes. For those who somehow want to obtain the record for the most amount of cancerous tumors."
	icon_state = "Bpacket"
	//brand = "\improper Acme Co. cigarette"

	New()
		..()
		fill_cigarre_package(src,list("chloralhydrate" = 5))

// sweet dreams, baby!//

/obj/item/storage/fancy/cigarettes/luckystars
	name = "\improper pack of Lucky Stars"
	desc = "A mellow blend made from synthetic, pod-grown tobacco. The commercial jingle is guaranteed to get stuck in your head."
	icon_state = "LSpacket"
	//brand = "\improper Lucky Star"

/obj/item/storage/fancy/cigarettes/jerichos
	name = "\improper pack of Jerichos"
	desc = "Typically seen dangling from the lips of Martian soldiers and border world hustlers. Tastes like hickory smoke, feels like warm liquid death down your lungs."
	icon_state = "Jpacket"
	//brand = "\improper Jericho"

/obj/item/storage/fancy/cigarettes/menthols
	name = "\improper pack of Temperamento Menthols"
	desc = "With a sharp and natural organic menthol flavor, these Temperamentos are a favorite of NDV crews. Hardly anyone knows they make 'em in non-menthol!"
	icon_state = "TMpacket"
	//brand = "\improper Temperamento Menthol"

/obj/item/storage/fancy/cigarettes/carcinomas
	name = "\improper pack of Carcinoma Angels"
	desc = "This unknown brand was slated for the chopping block, until they were publicly endorsed by an old Earthling gonzo journalist. The rest is history. They sell a variety for cats, too."
	icon_state = "CApacket"
	//brand = "\improper Carcinoma Angel"

/obj/item/storage/fancy/cigarettes/professionals
	name = "\improper pack of Professional 120s"
	desc = "Let's face it - if you're smoking these, you're either trying to look upper-class or you're 80 years old. That's the only excuse. They are, however, very good quality."
	icon_state = "P100packet"
	//brand = "\improper Professional 120"

/obj/item/storage/fancy/cigar
	name = "cigar case"
	desc = "A case for holding your cigars when you are not smoking them."
	icon_state = "cigarcase"
	item_state = "cigarcase"
	icon = 'icons/obj/cigarettes.dmi'
	w_class = ITEM_SIZE_SMALL
	max_w_class = ITEM_SIZE_TINY
	throwforce = 2
	slot_flags = SLOT_BELT
	max_storage_space = 7
	storage_slots = 7
	can_hold = list(/obj/item/clothing/mask/smokable/cigarette/cigar)
	icon_type = "cigar"

/obj/item/storage/fancy/cigar/New()
	..()
	flags |= NOREACT
	for(var/i = 1 to storage_slots)
		new /obj/item/clothing/mask/smokable/cigarette/cigar(src)
	create_reagents(15 * storage_slots)

/obj/item/storage/fancy/cigar/update_icon()
	icon_state = "[initial(icon_state)][contents.len]"
	return

/obj/item/storage/fancy/cigar/remove_from_storage(obj/item/W as obj, atom/new_location)
		var/obj/item/clothing/mask/smokable/cigarette/cigar/C = W
		if(!istype(C)) return
		reagents.trans_to_obj(C, (reagents.total_volume/contents.len))
		..()

/obj/item/storage/fancy/cigar/attack(mob/living/carbon/M as mob, mob/living/carbon/user as mob)
	if(!ismob(M))
		return

	if(M == user && user.zone_sel.selecting == O_MOUTH && contents.len > 0 && !user.wear_mask)
		var/obj/item/clothing/mask/smokable/cigarette/cigar/W = new (user)
		reagents.trans_to_obj(W, (reagents.total_volume/contents.len))
		user.equip_to_slot_if_possible(W, slot_wear_mask)
		reagents.maximum_volume = 15 * contents.len
		contents.len--
		user << SPAN_NOTE("You take a cigar out of the case.")
		update_icon()
	else
		..()

/*
 * Vial Box
 */

/obj/item/storage/fancy/vials
	icon = 'icons/obj/vialbox.dmi'
	icon_state = "vialbox6"
	icon_type = "vial"
	name = "vial storage box"
	w_class = ITEM_SIZE_NORMAL
	max_w_class = ITEM_SIZE_TINY
	storage_slots = 6
	can_hold = list(/obj/item/weapon/reagent_containers/glass/beaker/vial)
	fill_type = /obj/item/weapon/reagent_containers/glass/beaker/vial


/obj/item/storage/lockbox/vials
	name = "secure vial storage box"
	desc = "A locked box for keeping things away from children."
	icon = 'icons/obj/vialbox.dmi'
	icon_state = "vialbox0"
	item_state = "syringe_kit"
	w_class = ITEM_SIZE_NORMAL
	max_w_class = ITEM_SIZE_TINY
	can_hold = list(/obj/item/weapon/reagent_containers/glass/beaker/vial)
	max_storage_space = 12 //The sum of the w_classes of all the items in this storage item.
	storage_slots = 6
	req_access = list(access_virology)

/obj/item/storage/lockbox/vials/initialize()
	..()
	update_icon()

/obj/item/storage/lockbox/vials/update_icon()
	src.icon_state = "vialbox[src.contents.len]"
	src.overlays.Cut()
	if (!broken)
		overlays += image(icon, src, "led[locked]")
		if(locked)
			overlays += image(icon, src, "cover")
	else
		overlays += image(icon, src, "ledb")

