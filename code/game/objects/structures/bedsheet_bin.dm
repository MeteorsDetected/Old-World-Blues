/*
CONTAINS:
BEDSHEETS
LINEN BINS
*/
/obj/item/weapon/bedsheet
	name = "bedsheet"
	desc = "A surprisingly soft linen bedsheet."
	icon = 'icons/obj/bed.dmi'
	icon_state = "bedsheet"
	slot_flags = SLOT_BACK
	layer = 4.0
	throwforce = 1
	throw_speed = 1
	throw_range = 2
	w_class = ITEM_SIZE_SMALL
	var/material = "cotton"
	var/is_double = FALSE
	var/global/list/cached_icon

/obj/item/weapon/bedsheet/New(loc, material)
	if(material)
		src.material = material
	..(loc)

/obj/item/weapon/bedsheet/initialize()
	..()
	var/material/material = get_material_by_name(src.material)
	name = "[material.display_name] [initial(name)]"
	src.color = material.icon_colour
	update_icon()

/obj/item/weapon/bedsheet/update_icon()
	overlays.Cut()
	var/icon_key = is_double ? "double_top" : "bedsheet_top"
	if(!cached_icon)
		cached_icon = new
	if(!cached_icon[icon_key])
		var/image/image = image(icon, icon_key)
		image.appearance_flags |= RESET_COLOR
		cached_icon[icon_key] = image
	overlays += cached_icon[icon_key]

/obj/item/weapon/bedsheet/attack_self(mob/user as mob)
	user.drop_from_inventory(src)
	if(layer == initial(layer))
		layer = 5
		pixel_x = 0
		pixel_y = 0
	else
		layer = initial(layer)
	add_fingerprint(user)
	return

/obj/item/weapon/bedsheet/attackby(obj/item/I, mob/living/user)
	if(istype(I) && material)
		if(I.sharp)
			if(isturf(src.loc))
				create_material_stacks(material, 2, src.loc)
				qdel(src)
			else if(user.get_inactive_hand() == src && isturf(user.loc))
				create_material_stacks(material, 2, user.loc)
				qdel(src)
			else
				user << SPAN_WARN("You can't cut [src] there.")
			return
	return ..()

/obj/item/weapon/bedsheet/blue
	material = "blue"
	color = "#6B6FE3"

/obj/item/weapon/bedsheet/green
	material = "green"
	color = "#01C608"

/obj/item/weapon/bedsheet/purple
	material = "purple"
	color = "#9C56C4"

/obj/item/weapon/bedsheet/red
	material = "red"
	color = "#DA020A"

/obj/item/weapon/bedsheet/lime
	material = "lime"
	color = "#62E36C"

/obj/item/weapon/bedsheet/orange
	material = "orange"
	color = "#FFCF72"

/obj/item/weapon/bedsheet/teal
	material ="teal"
	color = "#00EAFA"

/obj/item/weapon/bedsheet/brown
	material = "leather"
	color = "#5C4831"

/obj/item/weapon/bedsheet/rainbow
	icon_state = "sheetrainbow"

/obj/item/weapon/bedsheet/clown
	icon_state = "sheetclown"

/obj/item/weapon/bedsheet/mime
	icon_state = "sheetmime"

/obj/item/weapon/bedsheet/medical
	icon_state = "sheetmedical"

/obj/item/weapon/bedsheet/rd
	icon_state = "sheetrd"

/obj/item/weapon/bedsheet/cmo
	icon_state = "sheetcmo"

/obj/item/weapon/bedsheet/hos
	icon_state = "sheethos"

/obj/item/weapon/bedsheet/ce
	icon_state = "sheetce"

/obj/item/weapon/bedsheet/hop
	icon_state = "sheethop"

/obj/item/weapon/bedsheet/captain
	icon_state = "sheetcaptain"

/obj/item/weapon/bedsheet/ian
	icon_state = "sheetian"


/obj/item/weapon/bedsheet/doublesheet
	icon_state = "doublesheet"
	is_double = TRUE

/obj/item/weapon/bedsheet/doublesheet/rainbow
	icon_state = "doublesheetrainbow"

/obj/item/weapon/bedsheet/doublesheet/ian
	icon_state = "doublesheetian"

/obj/item/weapon/bedsheet/doublesheet/captain
	icon_state = "doublesheetcaptain"

/obj/item/weapon/bedsheet/doublesheet/hop
	icon_state = "doublesheethop"

/obj/item/weapon/bedsheet/doublesheet/ce
	icon_state = "doublesheetce"

/obj/item/weapon/bedsheet/doublesheet/hos
	icon_state = "doublesheethos"

/obj/item/weapon/bedsheet/doublesheet/rd
	icon_state = "doublesheetrd"

/obj/item/weapon/bedsheet/doublesheet/clown
	icon_state = "doublesheetclown"

/obj/item/weapon/bedsheet/doublesheet/mime
	icon_state = "doublesheetmime"


/obj/structure/bedsheetbin
	name = "linen bin"
	desc = "A linen bin. It looks rather cosy."
	icon = 'icons/obj/structures.dmi'
	icon_state = "linenbin-full"
	anchored = 1
	var/amount = 20
	var/list/sheets = list()
	var/obj/item/hidden = null


/obj/structure/bedsheetbin/examine(mob/user)
	. = ..()

	if(amount < 1)
		user << "There are no bed sheets in the bin."
		return
	if(amount == 1)
		user << "There is one bed sheet in the bin."
		return
	user << "There are [amount] bed sheets in the bin."


/obj/structure/bedsheetbin/update_icon()
	switch(amount)
		if(0)				icon_state = "linenbin-empty"
		if(1 to amount / 2)	icon_state = "linenbin-half"
		else				icon_state = "linenbin-full"


/obj/structure/bedsheetbin/attackby(obj/item/I as obj, mob/user as mob)
	if(istype(I, /obj/item/weapon/bedsheet))
		user.drop_from_inventory(I, src)
		sheets.Add(I)
		amount++
		user << SPAN_NOTE("You put [I] in [src].")
	//make sure there's sheets to hide it among, make sure nothing else is hidden in there.
	else if(amount && !hidden && I.w_class < ITEM_SIZE_HUGE && user.unEquip(I, src))
		hidden = I
		user << SPAN_NOTE("You hide [I] among the sheets.")

/obj/structure/bedsheetbin/attack_hand(mob/user as mob)
	if(amount >= 1)
		amount--

		var/obj/item/weapon/bedsheet/B
		if(sheets.len > 0)
			B = sheets[sheets.len]
			sheets.Remove(B)

		else
			B = new /obj/item/weapon/bedsheet(loc)

		user.put_in_hands(B)
		user << SPAN_NOTE("You take [B] out of [src].")

		if(hidden)
			hidden.loc = user.loc
			user << SPAN_NOTE("[hidden] falls out of [B]!")
			hidden = null


	add_fingerprint(user)

/obj/structure/bedsheetbin/attack_tk(mob/user as mob)
	if(amount >= 1)
		amount--

		var/obj/item/weapon/bedsheet/B
		if(sheets.len > 0)
			B = sheets[sheets.len]
			sheets.Remove(B)

		else
			B = new /obj/item/weapon/bedsheet(loc)

		B.loc = loc
		user << SPAN_NOTE("You telekinetically remove [B] from [src].")
		update_icon()

		if(hidden)
			hidden.loc = loc
			hidden = null


	add_fingerprint(user)
