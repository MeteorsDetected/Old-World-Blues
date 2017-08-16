

/obj/structure/shuttle_part
	var/req_types = list()

/obj/structure/simple_fix/attackby(obj/item/I, mob/living/user)
	var/obj_type = I.type
	if(obj_type in req_types && !req_types[obj_type])
		if(!user.unEquip(I, src))
			return TRUE

		req_types[obj_type] = I
		user << SPAN_NOTE("You insert [I] into [src].")


