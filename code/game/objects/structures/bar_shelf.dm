/obj/storage/barshelf
	name = "Shelf"
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "bar_shelf"
	var/list/lines = list(3, 11, 19)
	var/list/grabbed = list()

/obj/storage/barshelf/attackby(obj/item/weapon/reagent_containers/glass/G, mob/living/user, params)
	if(!istype(G))
		user << SPAN_WARN("You can't put [G] here.")
		return
	if(user.unEquip(G, src.loc))
		auto_align(G, params)
		return TRUE

/obj/storage/barshelf/proc/auto_align(obj/item/I, params)
	grabbed |= I
	var/list/click_data = params2list(params)
	var/clicked_line = text2num(click_data["icon-y"])
	var/clicked_row  = text2num(click_data["icon-x"])
	var/selected_line
	if(clicked_line < lines[1])
		selected_line = lines[1]
	else
		for(var/elem in lines)
			if(elem < clicked_line)
				selected_line = elem
			else
				break
	I.pixel_y = src.pixel_y + selected_line - I.center_of_mass["y"] + 2
	I.pixel_x = src.pixel_x + clicked_row - I.center_of_mass["x"]

/obj/storage/barshelf/Uncrossed(obj/item/I)
	if(I in grabbed)
		I.pixel_y %= 32
		I.pixel_x %= 32
		grabbed -= I
	. = ..()
