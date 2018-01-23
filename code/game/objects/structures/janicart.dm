/obj/structure/janitorialcart
	name = "janitorial cart"
	desc = "The ultimate in janitorial carts! Has space for water, mops, signs, trash bags, and more!"
	icon = 'icons/obj/janitor.dmi'
	icon_state = "cart"
	anchored = 0
	density = 1
	flags = OPENCONTAINER
	//copypaste sorry
	var/amount_per_transfer_from_this = 5 //shit I dunno, adding this so syringes stop runtime erroring. --NeoFite
	var/obj/item/storage/bag/trash/mybag	= null
	var/obj/item/weapon/mop/mymop = null
	var/obj/item/weapon/reagent_containers/spray/myspray = null
	var/obj/item/device/lightreplacer/myreplacer = null
	var/signs = 0	//maximum capacity hardcoded below


/obj/structure/janitorialcart/New()
	create_reagents(100)


/obj/structure/janitorialcart/examine(mob/user, return_dist=1)
	.=..()
	if(.<=1)
		user << "[src] \icon[src] contains [reagents.total_volume] unit\s of liquid!"
	//everything else is visible, so doesn't need to be mentioned


/obj/structure/janitorialcart/attackby(obj/item/I, mob/user)
	if(istype(I, /obj/item/storage/bag/trash) && !mybag)
		user.drop_from_inventory(I, src)
		mybag = I
		update_icon()
		updateUsrDialog()
		user << SPAN_NOTE("You put [I] into [src].")

	else if(istype(I, /obj/item/weapon/mop))
		if(I.reagents.total_volume < I.reagents.maximum_volume)	//if it's not completely soaked we assume they want to wet it, otherwise store it
			if(reagents.total_volume < 1)
				user << "[src] is out of water!</span>"
			else
				reagents.trans_to_obj(I, 5)	//
				user << SPAN_NOTE("You wet [I] in [src].")
				playsound(loc, 'sound/effects/slosh.ogg', 25, 1)
				return
		if(!mymop)
			user.drop_from_inventory(I, src)
			mymop = I
			update_icon()
			updateUsrDialog()
			user << SPAN_NOTE("You put [I] into [src].")

	else if(istype(I, /obj/item/weapon/reagent_containers/spray) && !myspray)
		user.drop_from_inventory(I, src)
		myspray = I
		update_icon()
		updateUsrDialog()
		user << SPAN_NOTE("You put [I] into [src].")

	else if(istype(I, /obj/item/device/lightreplacer) && !myreplacer)
		user.drop_from_inventory(I, src)
		myreplacer = I
		update_icon()
		updateUsrDialog()
		user << SPAN_NOTE("You put [I] into [src].")

	else if(istype(I, /obj/item/weapon/caution))
		if(signs < 4)
			user.drop_from_inventory(I, src)
			signs++
			update_icon()
			updateUsrDialog()
			user << SPAN_NOTE("You put [I] into [src].")
		else
			user << SPAN_NOTE("[src] can't hold any more signs.")

	else if(mybag)
		mybag.attackby(I, user)


/obj/structure/janitorialcart/attack_hand(mob/user)
	ui_interact(user)
	return

/obj/structure/janitorialcart/ui_interact(var/mob/user, var/ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1)
	var/data[0]
	data["name"] = capitalize(name)
	data["bag"] = mybag ? capitalize(mybag.name) : null
	data["mop"] = mymop ? capitalize(mymop.name) : null
	data["spray"] = myspray ? capitalize(myspray.name) : null
	data["replacer"] = myreplacer ? capitalize(myreplacer.name) : null
	data["signs"] = signs ? "[signs] sign\s" : null

	ui = nanomanager.try_update_ui(user, src, ui_key, ui, data, force_open)
	if(!ui)
		ui = new(user, src, ui_key, "janitorcart.tmpl", "Janitorial cart", 240, 160)
		ui.set_initial_data(data)
		ui.open()

/obj/structure/janitorialcart/Topic(href, href_list)
	if(!in_range(src, usr))
		return
	if(!isliving(usr))
		return
	var/mob/living/user = usr

	if(href_list["take"])
		switch(href_list["take"])
			if("garbage")
				if(mybag)
					user.put_in_hands(mybag)
					user << SPAN_NOTE("You take [mybag] from [src].")
					mybag = null
			if("mop")
				if(mymop)
					user.put_in_hands(mymop)
					user << SPAN_NOTE("You take [mymop] from [src].")
					mymop = null
			if("spray")
				if(myspray)
					user.put_in_hands(myspray)
					user << SPAN_NOTE("You take [myspray] from [src].")
					myspray = null
			if("replacer")
				if(myreplacer)
					user.put_in_hands(myreplacer)
					user << SPAN_NOTE("You take [myreplacer] from [src].")
					myreplacer = null
			if("sign")
				if(signs)
					var/obj/item/weapon/caution/Sign = locate() in src
					if(Sign)
						user.put_in_hands(Sign)
						user << SPAN_NOTE("You take \a [Sign] from [src].")
						signs--
					else
						warning("[src] signs ([signs]) didn't match contents")
						signs = 0

	update_icon()
	updateUsrDialog()


/obj/structure/janitorialcart/update_icon()
	overlays = null
	if(mybag)
		overlays += "cart_garbage"
	if(mymop)
		overlays += "cart_mop"
	if(myspray)
		overlays += "cart_spray"
	if(myreplacer)
		overlays += "cart_replacer"
	if(signs)
		overlays += "cart_sign[signs]"


//old style retardo-cart
/obj/structure/material/chair/janicart
	name = "janicart"
	icon = 'icons/obj/vehicles.dmi'
	icon_state = "pussywagon"
	anchored = 1
	density = 1
	flags = OPENCONTAINER
	//copypaste sorry
	var/amount_per_transfer_from_this = 5 //shit I dunno, adding this so syringes stop runtime erroring. --NeoFite
	var/obj/item/storage/bag/trash/mybag	= null
	var/callme = "pimpin' ride"	//how do people refer to it?


/obj/structure/material/chair/janicart/initialize()
	..()
	create_reagents(100)


/obj/structure/material/chair/janicart/examine(mob/user, return_dist=1)
	.=..()
	if(.>1)
		return

	user << "\icon[src] This [callme] contains [reagents.total_volume] unit\s of water!"
	if(mybag)
		user << "\A [mybag] is hanging on the [callme]."


/obj/structure/material/chair/janicart/attackby(obj/item/I, mob/user)
	if(istype(I, /obj/item/weapon/mop))
		if(reagents.total_volume > 1)
			reagents.trans_to_obj(I, 2)
			user << SPAN_NOTE("You wet [I] in the [callme].")
			playsound(loc, 'sound/effects/slosh.ogg', 25, 1)
		else
			user << SPAN_NOTE("This [callme] is out of water!")
	else if(istype(I, /obj/item/key))
		user << "Hold [I] in one of your hands while you drive this [callme]."
	else if(istype(I, /obj/item/storage/bag/trash))
		user << SPAN_NOTE("You hook the trashbag onto the [callme].")
		user.drop_from_inventory(I, src)
		mybag = I


/obj/structure/material/chair/janicart/attack_hand(mob/user)
	if(mybag)
		user.put_in_hands(mybag)
		mybag = null
	else
		..()


/obj/structure/material/chair/janicart/relaymove(mob/user, direction)
	if(user.stat || user.stunned || user.weakened || user.paralysis)
		unbuckle_mob()
	if(istype(user.l_hand, /obj/item/key) || istype(user.r_hand, /obj/item/key))
		step(src, direction)
		update_mob()
	else
		user << SPAN_NOTE("You'll need the keys in one of your hands to drive this [callme].")


/obj/structure/material/chair/janicart/Move()
	..()
	if(buckled_mob)
		if(buckled_mob.buckled == src)
			buckled_mob.loc = loc


/obj/structure/material/chair/janicart/post_buckle_mob(mob/living/M)
	update_mob()
	return ..()


/obj/structure/material/chair/janicart/update_layer()
	if(dir == SOUTH)
		layer = FLY_LAYER
	else
		layer = OBJ_LAYER


/obj/structure/material/chair/janicart/unbuckle_mob()
	var/mob/living/M = ..()
	if(M)
		M.pixel_x = 0
		M.pixel_y = 0
	return M


/obj/structure/material/chair/janicart/proc/update_mob()
	if(buckled_mob)
		buckled_mob.set_dir(dir)
		switch(dir)
			if(SOUTH)
				buckled_mob.pixel_x = 0
				buckled_mob.pixel_y = 7
			if(WEST)
				buckled_mob.pixel_x = 13
				buckled_mob.pixel_y = 7
			if(NORTH)
				buckled_mob.pixel_x = 0
				buckled_mob.pixel_y = 4
			if(EAST)
				buckled_mob.pixel_x = -13
				buckled_mob.pixel_y = 7


/obj/structure/material/chair/janicart/bullet_act(var/obj/item/projectile/Proj)
	if(buckled_mob)
		if(prob(85))
			return buckled_mob.bullet_act(Proj)
	visible_message("<span class='warning'>[Proj] ricochets off the [callme]!</span>")


/obj/item/key
	name = "key"
	desc = "A keyring with a small steel key, and a pink fob reading \"Pussy Wagon\"."
	icon = 'icons/obj/vehicles.dmi'
	icon_state = "keys"
	w_class = ITEM_SIZE_TINY
