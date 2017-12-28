/obj/structure/material
	var/material/material = MATERIAL_STEEL
	var/material/padding_material = null
	var/base_icon = null

/obj/structure/material/New(loc, var/_material, var/_padding_material)
	if(_material)
		material = _material
	if(_padding_material)
		padding_material = _padding_material
	..(loc)

/obj/structure/material/initialize()
	..()
	color = null
	material = get_material_by_name(material)
	if(!istype(material))
		qdel(src)
		return
	if(padding_material)
		padding_material = get_material_by_name(padding_material)
	update_icon()

/obj/structure/material/get_material()
	return material

/obj/structure/material/proc/remove_padding()
	if(padding_material)
		padding_material.place_sheet(get_turf(src))
		padding_material = null
		update_icon()

/obj/structure/material/proc/add_padding(var/padding_type)
	padding_material = get_material_by_name(padding_type)
	update_icon()

/obj/structure/material/proc/dismantle()
	material.place_sheet(get_turf(src))
	if(padding_material)
		padding_material.place_sheet(get_turf(src))
	qdel(src)

// Reuse the cache/code from stools, todo maybe unify.
/obj/structure/material/update_icon()
	// Prep icon.
	icon_state = ""
	overlays.Cut()

	// Base icon.
	var/cache_key = "[base_icon]-[material.name]"
	if(isnull(stool_cache[cache_key]))
		var/image/I = image(icon, base_icon)
		I.color = material.icon_colour
		stool_cache[cache_key] = I
	overlays |= stool_cache[cache_key]

	// Padding overlay.
	if(padding_material)
		var/padding_cache_key = "[base_icon]-padding-[padding_material.name]"
		if(isnull(stool_cache[padding_cache_key]))
			var/image/I =  image(icon, "[base_icon]_padding")
			I.color = padding_material.icon_colour
			stool_cache[padding_cache_key] = I
		overlays |= stool_cache[padding_cache_key]

	// Strings.
	desc = initial(desc)
	if(padding_material)
		name = "[padding_material.display_name] [initial(name)]" //this is not perfect but it will do for now.
		desc += " It's made of [material.use_name] and covered with [padding_material.use_name]."
	else
		name = "[material.display_name] [initial(name)]"
		desc += " It's made of [material.use_name]."

/obj/structure/material/ex_act(severity)
	switch(severity)
		if(1)
			dismantle(src)
		if(2)
			if(prob(50))
				dismantle(src)
		if(3)
			if(prob(5))
				dismantle(src)

/obj/structure/material/blob_act()
	if(prob(75))
		dismantle()

/obj/structure/material/attackby(obj/item/weapon/W, mob/living/user)
	if(istype(W, /obj/item/weapon/wrench))
		playsound(src.loc, 'sound/items/Ratchet.ogg', 50, 1)
		dismantle()
		return

	else if(ismaterial(W))
		if(padding_material)
			user << "\The [src] is already padded."
			return
		var/obj/item/stack/material/M = W
		if(M.get_amount() < 1) // How??
			user.drop_from_inventory(W)
			qdel(W)
			return
		if(!M.material || !(M.material.flags & MATERIAL_PADDING))
			user << "You cannot pad \the [src] with that."
			return
		user << "You add padding to \the [src]."
		add_padding(M.material.name)
		M.use(1)
		return

	else if(istype(W, /obj/item/weapon/wirecutters))
		if(!padding_material)
			user << "\The [src] has no padding to remove."
			return
		user << "You remove the padding from \the [src]."
		playsound(src, 'sound/items/Wirecutter.ogg', 100, 1)
		remove_padding()

	else
		..()
