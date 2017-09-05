/obj/item/weapon/lipstick
	gender = PLURAL
	name = "red lipstick"
	desc = "A generic brand of lipstick."
	icon = 'icons/obj/items.dmi'
	icon_state = "lipstick"
	w_class = ITEM_SIZE_TINY
	slot_flags = SLOT_EARS
	var/colour = "#F00000"
	var/open = 0

	New()
		update_icon()
		..()

/obj/item/weapon/lipstick/purple
	name = "purple lipstick"
	colour = "#D55CD0"

/obj/item/weapon/lipstick/jade
	name = "jade lipstick"
	colour = "#218C17"

/obj/item/weapon/lipstick/black
	name = "black lipstick"
	colour = "#56352F"

/obj/item/weapon/lipstick/colorise
	name = "multicolor lipctick"

/obj/item/weapon/lipstick/colorise/attack_self(mob/user)
	if(!open)
		colour = input("Select new color!", "Color", colour) as color
	..()

/obj/item/weapon/lipstick/random
	name = "lipstick"

/obj/item/weapon/lipstick/random/New()
	var/list/colors = list("red"="#F00000","purple"="#D55CD0","jade"="#218C17","black"="#56352F")
	var/picked_color = pick(colors)
	name = "[picked_color] lipstick"
	colour = colors[picked_color]
	..()


/obj/item/weapon/lipstick/attack_self(mob/user as mob)
	open = !open
	user << SPAN_NOTE("You twist \the [src] [open ? "open" : "closed"].")
	update_icon()

/obj/item/weapon/lipstick/update_icon()
	overlays.Cut()
	if(open)
		var/image/stick = image(icon = 'icons/obj/items.dmi', icon_state = "lipstick_open")
		stick.color = colour
		overlays += stick
	else
		overlays += "lipstick_closed"


/obj/item/weapon/lipstick/attack(mob/M as mob, mob/user as mob)
	if(!open)
		return

	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		if(H.lip_color)	//if they already have lipstick on
			user << SPAN_NOTE("You need to wipe off the old lipstick first!")
			return
		if(H == user)
			user.visible_message(SPAN_NOTE("[user] does their lips with \the [src]."), \
								 SPAN_NOTE("You take a moment to apply \the [src]. Perfect!"))
			H.lip_color = colour
			H.update_body()
		else
			user.visible_message("<span class='warning'>[user] begins to do [H]'s lips with \the [src].</span>", \
								 SPAN_NOTE("You begin to apply \the [src]."))
			if (do_mob(user, H, 20))//user needs to keep their active hand, H does not.
				user.visible_message(SPAN_NOTE("[user] does [H]'s lips with \the [src]."), \
									 SPAN_NOTE("You apply \the [src]."))
				H.lip_color = colour
				H.update_body()
	else
		user << SPAN_NOTE("Where are the lips on that?")

//you can wipe off lipstick with paper! see code/modules/paperwork/paper.dm, paper/attack()


/obj/item/weapon/haircomb //sparklysheep's comb
	name = "purple comb"
	desc = "A pristine purple comb made from flexible plastic."
	w_class = ITEM_SIZE_TINY
	slot_flags = SLOT_EARS
	icon = 'icons/obj/items.dmi'
	icon_state = "purplecomb"
	item_state = "purplecomb"

/obj/item/weapon/haircomb/attack_self(mob/user)
	if(user.r_hand == src || user.l_hand == src)
		user.visible_message(text("\red [] uses [] to comb their hair with incredible style and sophistication. What a [].", user, src, user.gender == FEMALE ? "lady" : "guy"))
	return
