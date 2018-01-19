/obj/item/weapon/snowy_woodchunks
	name = "wood chunks"
	desc = "Some wood from one of these trees."
	icon = 'icons/obj/snowy_event/snowy_icons.dmi'
	icon_state = "wood_chunks"
	w_class = ITEM_SIZE_SMALL

/obj/item/weapon/snowy_woodchunks/attackby(obj/item/weapon/T as obj, mob/user as mob)
	if(!T.sharp)
		return

	for(var/i = 1, i<10, i++)
		var/obj/item/stack/material/wood/W = new(user.loc)
		for (var/obj/item/stack/material/G in user.loc) //Yeah, i copypasted that small part. Sorry. Don't know why nobody puts this in New() of sheets
			if(G.get_material_name() != MATERIAL_WOOD || G==W)
				continue
			if(G.amount>=G.max_amount)
				continue
			G.attackby(W, user)
	qdel(src)

/obj/item/weapon/snowy_woodchunks/attack_self(var/mob/user as mob)
	new /obj/structure/campfire(user.loc)
	user << SPAN_NOTE("You place chunks into circle and make campfire.")
	qdel(src)


/obj/item/weapon/branches
	name = "branches"
	desc = "Wood branches. Can be used as firewood."
	icon = 'icons/obj/snowy_event/snowy_icons.dmi'
	icon_state = "branches1"
	w_class = ITEM_SIZE_TINY

	New()
		icon_state = "branches[rand(1, 3)]"
		pixel_x = rand(-10, 10)
		pixel_y = rand(-10, 10)


/obj/item/weapon/reagent_containers/food/snacks/mushroom
	name = "mushroom"
	desc = "Unknown shroom. Eatable. Can be toxic."
	icon = 'icons/obj/snowy_event/snowy_icons.dmi'
	icon_state = "shroom_bottom1"
	var/icon_head = "shroom_upper1"
	var/icon_ring = "shroom_ring1"

	New()
		..()
		update_icon()


/obj/item/weapon/reagent_containers/food/snacks/mushroom/update_icon()
	if(icon_head)
		overlays += icon_head
	if(icon_ring)
		overlays += icon_ring


/obj/item/weapon/reagent_containers/food/snacks/berries
	name = "Berries"
	desc = "Unknown berries. You can eat it, but they might kill you."
	icon = 'icons/obj/snowy_event/snowy_icons.dmi'
	icon_state = "handful_berries"


/obj/item/weapon/reagent_containers/food/snacks/bug
	name = "Barksleeper"
	desc = "Small bug with hump on his back. You can try to eat that, but... Well.."
	icon = 'icons/obj/snowy_event/snowy_icons.dmi'
	icon_state = "barksleeper_bug"

/obj/item/weapon/spider_silk
	name = "Spider Silk"
	desc = "High quality spider silk. Very strong and soft."
	icon = 'icons/obj/snowy_event/snowy_icons.dmi'
	icon_state = "spider_silk"
	w_class = ITEM_SIZE_TINY

/obj/item/weapon/spider_silk/attack_self(var/mob/user as mob)
	var/obj/item/weapon/fishing_line/F = new /obj/item/weapon/fishing_line(user.loc)
	F.length = 3
	user << SPAN_NOTE("You rolled up [src.name] in thin line.")
	qdel(src)
