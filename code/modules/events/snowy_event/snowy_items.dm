

/obj/item/weapon/snowy_woodchunks
	name = "wood chunks"
	desc = "Some wood from one of these trees."
	icon = 'icons/obj/snowy_event/snowy_icons.dmi'
	icon_state = "wood_chunks"
	w_class = ITEM_SIZE_SMALL
	//var/temperature_gives = 480 //how many heat it can give
	//I do it later. Need to rework campfire


/obj/item/weapon/snowy_woodchunks/attackby(obj/item/weapon/T as obj, mob/user as mob)
	if(!T.sharp || istype(T, /obj/item/weapon/wirecutters))
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
	if(!(locate(/obj/structure/campfire) in user.loc))
		new /obj/structure/campfire(user.loc)
		user << SPAN_NOTE("You place chunks in circle and make campfire.")
		qdel(src)
	else
		user << SPAN_WARN("Campfire is already here.")



/obj/item/weapon/branches
	name = "Branches"
	desc = "Wood branches. Can be used as firewood."
	icon = 'icons/obj/snowy_event/snowy_icons.dmi'
	icon_state = "branches1"
	w_class = ITEM_SIZE_TINY

	New()
		..()
		icon_state = "branches[rand(1, 3)]"
		pixel_x = rand(-10, 10)
		pixel_y = rand(-10, 10)


/obj/item/weapon/branches/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(W.sharp)
		user << SPAN_NOTE("You take most suitable stick and sharpen it.")
		new /obj/item/weapon/stick(get_turf(src))
		qdel(src)



/obj/item/weapon/stick
	name = "Stick"
	desc = "Stick with sharp end. Only one."
	icon = 'icons/obj/snowy_event/snowy_icons.dmi'
	icon_state = "sharp_stick"
	w_class = ITEM_SIZE_TINY
	var/list/ingredients = list()


/obj/item/weapon/stick/examine(mob/user as mob)
	..()
	for(var/obj/item/weapon/reagent_containers/food/snacks/ingredient/F in ingredients)
		var/obj/item/weapon/reagent_containers/food/snacks/ingredient/I = F
		user << SPAN_NOTE("[I.name] looks [I.properties["status"]] and feel [I.properties["temp_desc"]].")


/obj/item/weapon/stick/update_icon()
	overlays.Cut()
	if(ingredients.len == 1)
		overlays += "stick_food"
	else if(ingredients.len > 1)
		overlays += "stick_food_many"


/obj/item/weapon/stick/attackby(obj/item/weapon/O as obj, mob/user as mob)
	if(istype(O, /obj/item/weapon/stick))
		new /obj/item/weapon/tied_sticks(get_turf(src))
		qdel(O)
		qdel(src)
	if(istype(O, /obj/item/weapon/reagent_containers/food/snacks/ingredient))
		if(ingredients.len < 5)
			ingredients.Add(O)
			user << SPAN_NOTE("You skewer [O.name] on stick.")
			user.drop_from_inventory(O, src)
			update_icon()
		else
			user << SPAN_WARN("There's no more space for this.")


/obj/item/weapon/stick/attack_hand(var/mob/user as mob)
	if(src.loc == user)
		if(ingredients.len)
			var/obj/O = locate(/obj/item/weapon/reagent_containers/food/snacks/ingredient) in src.ingredients
			user << SPAN_NOTE("You take [O.name] from [src.name].")
			O.loc = user.loc
			ingredients.Remove(O)
			user.put_in_hands(O)
			update_icon()
	else
		..()


/obj/item/weapon/tied_sticks
	name = "Tied sticks"
	desc = "Sticks that keeps together for some reason."
	icon = 'icons/obj/snowy_event/snowy_icons.dmi'
	icon_state = "sticks"
	w_class = ITEM_SIZE_SMALL


/obj/item/weapon/tied_sticks/attack_self(var/mob/user as mob)
	user << SPAN_NOTE("You make simple holder from these sticks")
	var/obj/item/weapon/holder_stick/HS = new(user.loc)
	user.put_in_hands(HS)
	qdel(src)


///obj/item/weapon/tied_sticks/attackby(obj/item/weapon/O as obj, mob/user as mob)
//	if(istype(O, /obj/item/weapon/tied_sticks))
//		user << SPAN_NOTE("You tie up sticks and make useful grill.") //Maybe i make it great again later. But now, this is just useless junk
//		new /obj/item/weapon/wgrill(get_turf(src))
//		qdel(O)
//		qdel(src)




/obj/item/weapon/holder_stick
	name = "Holder stick"
	desc = "Stick with horn-like end. Nice to hold something above fire."
	icon = 'icons/obj/snowy_event/snowy_icons.dmi'
	icon_state = "stick_holder"
	w_class = ITEM_SIZE_TINY


/obj/item/weapon/wgrill
	name = "Grill"
	desc = "Wooden makeshift grill."
	icon = 'icons/obj/snowy_event/snowy_icons.dmi'
	icon_state = "grill"
	w_class = ITEM_SIZE_SMALL


/obj/item/weapon/reagent_containers/food/snacks/bug
	name = "Barksleeper"
	desc = "Small bug with hump on his back. You can try to eat that, but... Well.."
	icon = 'icons/obj/snowy_event/snowy_icons.dmi'
	icon_state = "barksleeper_bug"


/obj/item/weapon/reagent_containers/food/snacks/ingredient/meat/fishmeat
	name = "fish meat"
	desc = "Meat of fish. Looks oily..."
	icon = 'icons/obj/snowy_event/fishing.dmi'
	icon_state = "fishmeat"



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



/obj/item/weapon/snow
	name = "Snow"
	desc = "Iced water. Looks cold. Feels cold."
	icon = 'icons/obj/snowy_event/snowy_icons.dmi'
	icon_state = "snow"
	var/snowball_progress = 0
	w_class = ITEM_SIZE_TINY

	New()
		spawn(200)
			if(src)
				qdel(src)


/obj/item/weapon/snow/attack_self(var/mob/user as mob)
	if(user.a_intent == I_GRAB)
		icon_state = "snow-mold"
		user << SPAN_NOTE("You crumple snow in hands")
		snowball_progress++
	if(snowball_progress >= 2)
		var/obj/item/weapon/snowball/SB = new(user.loc)
		qdel(src)
		user.put_in_hands(SB)
		user << SPAN_NOTE("You make snowball!")



/obj/item/weapon/snowball
	name = "Snowball"
	desc = "Roundish and cold. Nice!"
	icon = 'icons/obj/snowy_event/snowy_icons.dmi'
	icon_state = "snowball"
	w_class = ITEM_SIZE_TINY

	New()
		spawn(300)
			if(src)
				qdel(src)


/obj/item/weapon/snowball/throw_impact(atom/hit_atom)
	if(istype(hit_atom, /obj) || istype(hit_atom, /mob))
		hit_atom.visible_message(SPAN_WARN("<b>[hit_atom.name] got some snow!</b>"))
	qdel(src) //need to place here some nice effects later