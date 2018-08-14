//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:32

/obj/item/weapon/implantcase
	name = "glass case"
	desc = "A case containing an implant."
	icon = 'icons/obj/items.dmi'
	icon_state = "implantcase-0"
	item_state = "implantcase"
	throw_speed = 1
	throw_range = 5
	w_class = ITEM_SIZE_TINY
	var/obj/item/weapon/implant/imp = null

/obj/item/weapon/implantcase/initialize()
	. = ..()
	update_icon()

/obj/item/weapon/implantcase/proc/implantPrepared()
	if(ispath(imp))
		imp = new imp(src)
	return imp

/obj/item/weapon/implantcase/update_icon()
	if(src.imp)
		src.icon_state = "implantcase-1"
	else
		src.icon_state = "implantcase-0"
	..()

/obj/item/weapon/implantcase/attackby(obj/item/weapon/I as obj, mob/user as mob)
	..()
	if (istype(I, /obj/item/weapon/pen))
		var/t = input(user, "What would you like the label to be?", text("[]", src.name), null)  as text
		if (user.get_active_hand() != I)
			return
		if((!IN_RANGE(src, usr) && src.loc != user))
			return
		t = sanitizeSafe(t, MAX_NAME_LEN)
		if(t)
			src.name = "Glass Case - '[t]'"
		else
			src.name = "Glass Case"
	else if(istype(I, /obj/item/weapon/reagent_containers/syringe))
		if(!src.implantPrepared())
			user << "\The [src] is empty"
			return
		if(!src.imp.allow_reagents)
			return
		if(src.imp.reagents.total_volume >= src.imp.reagents.maximum_volume)
			user << "\red [src] is full."
		else
			I.reagents.trans_to_obj(src.imp, 5)
			user << SPAN_NOTE("You inject 5 units of the solution. The syringe now contains [I.reagents.total_volume] units.")
	else if (istype(I, /obj/item/weapon/implanter))
		var/obj/item/weapon/implanter/M = I
		if (M.imp)
			if(src.imp)
				return
			M.imp.forceMove(src)
			src.imp = M.imp
			M.imp = null
			src.update_icon()
			M.update_icon()
		else
			if (src.implantPrepared())
				src.imp.forceMove(M)
				M.imp = src.imp
				src.imp = null
				update_icon()
			M.update_icon()