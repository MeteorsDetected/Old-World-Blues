/turf/simulated/floor
	name = "plating"
	icon = 'icons/turf/floors.dmi'
	icon_state = "plating"

	var/list/decals

	// Damage to flooring.
	var/broken
	var/burnt

	// Plating data.
	var/base_name = "plating"
	var/base_desc = "The naked hull."
	var/base_icon = 'icons/turf/floors.dmi'
	var/base_icon_state = "plating"

	// Flooring data.
	var/datum/flooring/flooring

	thermal_conductivity = 0.040
	heat_capacity = 10000

	//To remove
	var/icon_regular_floor = "floor" //used to remember what icon the tile should have by default
	var/icon_plating = "plating"
	var/floor_type = /obj/item/stack/tile/steel

/turf/simulated/floor/is_plating()
	return !flooring

/turf/simulated/floor/New(var/newloc, var/floortype)
	..(newloc)
	if(!floortype && flooring)
		floortype = flooring
	if(floortype)
		set_flooring(get_flooring(floortype))
		//set_flooring(decls_repository.get_decl(floortype))

/turf/simulated/floor/proc/set_flooring(var/datum/flooring/newflooring)
//	make_plating(defer_icon_update = 1)
	flooring = newflooring
	update_icon(1)
	levelupdate()

//This proc will set floor_type to null and the update_icon() proc will then change the icon_state of the turf
/turf/simulated/floor/proc/make_plating(var/place_product, var/defer_icon_update)
	name = base_name
	desc = base_desc
	icon = base_icon
	icon_state = base_icon_state
	layer = PLATING_LAYER

	if(flooring)
		flooring.on_remove()
		if(flooring.build_type && place_product)
			new flooring.build_type(src)
		flooring = null

	set_light(0)
	broken = null
	burnt = null

	if(!defer_icon_update)
		update_icon(1)

/turf/simulated/floor/levelupdate()
	for(var/obj/O in src)
		O.hide(O.hides_under_flooring() && src.flooring)

	if(flooring)
		layer = TURF_LAYER
	else
		layer = PLATING_LAYER





/turf/simulated/floor/ex_act(severity)
	//set src in oview(1)
	switch(severity)
		if(1.0)
			src.ChangeTurf(/turf/space)
		if(2.0)
			switch(pick(40;1,40;2,3))
				if (1)
					if(prob(33)) new /obj/item/stack/material/steel(src)
					src.ReplaceWithLattice()
				if(2)
					src.ChangeTurf(/turf/space)
				if(3)
					if(prob(33))
						new /obj/item/stack/material/steel(src)
					if(prob(80))
						src.break_tile_to_plating()
					else
						src.break_tile()
					src.hotspot_expose(1000,CELL_VOLUME)
		if(3.0)
			if (prob(50))
				src.break_tile()
				src.hotspot_expose(1000,CELL_VOLUME)

/turf/simulated/floor/fire_act(datum/gas_mixture/air, exposed_temperature, exposed_volume)

	var/temp_destroy = get_damage_temperature()
	if(!burnt && prob(5))
		burn_tile(exposed_temperature)
	else if(temp_destroy && exposed_temperature >= (temp_destroy + 100) && prob(1) && !is_plating())
		make_plating() //destroy the tile, exposing plating
		burn_tile(exposed_temperature)
	return

//should be a little bit lower than the temperature required to destroy the material
/turf/simulated/floor/proc/get_damage_temperature()
	if(is_steel_floor())	return T0C+1400
	if(is_wood_floor())		return T0C+200
	if(is_carpet_floor())	return T0C+200
	if(is_grass_floor())	return T0C+80
	return null

/turf/simulated/floor/adjacent_fire_act(turf/simulated/floor/adj_turf, datum/gas_mixture/adj_air, adj_temp, adj_volume)
	var/dir_to = get_dir(src, adj_turf)

	for(var/obj/structure/window/W in src)
		if(W.dir == dir_to || W.is_fulltile()) //Same direction or diagonal (full tile)
			W.fire_act(adj_air, adj_temp, adj_volume)

/turf/simulated/floor/blob_act()
	return

/turf/simulated/floor/return_siding_icon_state()
	..()
	if(is_grass_floor())
		var/dir_sum = 0
		for(var/direction in cardinal)
			var/turf/T = get_step(src,direction)
			if(!(T.is_grass_floor()))
				dir_sum += direction
		if(dir_sum)
			return "wood_siding[dir_sum]"
		else
			return 0

/turf/simulated/floor/proc/gets_drilled()
	return

/turf/simulated/floor/proc/break_tile_to_plating()
	if(!is_plating())
		make_plating()
	break_tile()

/turf/simulated/floor/is_steel_floor()
	if(ispath(floor_type, /obj/item/stack/tile/steel))
		return 1
	else
		return 0

/turf/simulated/floor/is_light_floor()
	if(ispath(floor_type, /obj/item/stack/tile/light))
		return 1
	else
		return 0

/turf/simulated/floor/is_grass_floor()
	if(ispath(floor_type, /obj/item/stack/tile/grass))
		return 1
	else
		return 0

/turf/simulated/floor/is_wood_floor()
	if(ispath(floor_type, /obj/item/stack/tile/wood))
		return 1
	else
		return 0

/turf/simulated/floor/is_carpet_floor()
	if(ispath(floor_type, /obj/item/stack/tile/carpet))
		return 1
	else
		return 0

/turf/simulated/floor/is_plating()
	if(!floor_type)
		return 1
	return 0

/turf/simulated/floor/proc/break_tile()
	if(istype(src,/turf/simulated/floor/engine)) return
	if(istype(src,/turf/simulated/floor/mech_bay_recharge_floor))
		src.ChangeTurf(/turf/simulated/floor/plating)
	if(broken) return
	if(is_steel_floor())
		src.icon_state = "damaged[pick(1,2,3,4,5)]"
		broken = 1
	else if(is_light_floor())
		src.icon_state = "light_broken"
		broken = 1
	else if(is_plating())
		src.icon_state = "platingdmg[pick(1,2,3)]"
		broken = 1
	else if(is_wood_floor())
		src.icon_state = "wood-broken"
		broken = 1
	else if(is_carpet_floor())
		src.icon_state = "carpet-broken"
		broken = 1
	else if(is_grass_floor())
		src.icon_state = "sand[pick("1","2","3")]"
		broken = 1

/turf/simulated/floor/proc/burn_tile(var/exposed_temperature)
	if(istype(src,/turf/simulated/floor/engine)) return
	if(istype(src,/turf/simulated/floor/plating/airless/asteroid)) return//Asteroid tiles don't burn

	var/damage_temp = get_damage_temperature()

	if(broken) return
	if(burnt)
		if(is_steel_floor() && exposed_temperature >= damage_temp) //allow upgrading from scorched tiles to damaged tiles
			src.icon_state = "damaged[pick(1,2,3,4,5)]"
			broken = 1
		return

	if(is_steel_floor() && exposed_temperature >= T0C+300) //enough to char the floor, but not hot enough to actually burn holes in it
		src.icon_state = "floorscorched[pick(1,2)]"
		burnt = 1
	else if(exposed_temperature >= damage_temp)
		if(is_steel_floor())
			src.icon_state = "damaged[pick(1,2,3,4,5)]"
			burnt = 1
		else if(is_plating())
			src.icon_state = "panelscorched"
			burnt = 1
		else if(is_wood_floor())
			src.icon_state = "wood-broken"
			burnt = 1
		else if(is_carpet_floor())
			src.icon_state = "carpet-broken"
			burnt = 1
		else if(is_grass_floor())
			src.icon_state = "sand[pick("1","2","3")]"
			burnt = 1

//This proc will make the turf a plasteel floor tile. The expected argument is the tile to make the turf with
//If none is given it will make a new object. dropping or unequipping must be handled before or after calling
//this proc.
/turf/simulated/floor/proc/make_plasteel_floor(var/obj/item/stack/tile/steel/T = null)
	broken = 0
	burnt = 0
	intact = 1
	set_light(0)
	if(T)
		if(istype(T,/obj/item/stack/tile/steel))
			floor_type = T.type
			if (icon_regular_floor)
				icon_state = icon_regular_floor
			else
				icon_state = "floor"
				icon_regular_floor = icon_state
			update_icon()
			levelupdate()
			return
	//if you gave a valid parameter, it won't get thisf ar.
	floor_type = /obj/item/stack/tile/steel
	icon_state = "floor"
	icon_regular_floor = icon_state

	update_icon()
	levelupdate()

//This proc will make the turf a light floor tile. The expected argument is the tile to make the turf with
//If none is given it will make a new object. dropping or unequipping must be handled before or after calling
//this proc.
/turf/simulated/floor/proc/make_light_floor(var/obj/item/stack/tile/light/T = null)
	broken = 0
	burnt = 0
	intact = 1
	if(T)
		if(istype(T,/obj/item/stack/tile/light))
			floor_type = T.type
			update_icon()
			levelupdate()
			return
	//if you gave a valid parameter, it won't get thisf ar.
	floor_type = /obj/item/stack/tile/light

	update_icon()
	levelupdate()

//This proc will make a turf into a grass patch. Fun eh? Insert the grass tile to be used as the argument
//If no argument is given a new one will be made.
/turf/simulated/floor/proc/make_grass_floor(var/obj/item/stack/tile/grass/T = null)
	broken = 0
	burnt = 0
	intact = 1
	if(T)
		if(istype(T,/obj/item/stack/tile/grass))
			floor_type = T.type
			update_icon()
			levelupdate()
			return
	//if you gave a valid parameter, it won't get thisf ar.
	floor_type = /obj/item/stack/tile/grass

	update_icon()
	levelupdate()

//This proc will make a turf into a wood floor. Fun eh? Insert the wood tile to be used as the argument
//If no argument is given a new one will be made.
/turf/simulated/floor/proc/make_wood_floor(var/obj/item/stack/tile/wood/T = null)
	broken = 0
	burnt = 0
	intact = 1
	if(T)
		if(istype(T,/obj/item/stack/tile/wood))
			floor_type = T.type
			update_icon()
			levelupdate()
			return
	//if you gave a valid parameter, it won't get thisf ar.
	floor_type = /obj/item/stack/tile/wood

	update_icon()
	levelupdate()

//This proc will make a turf into a carpet floor. Fun eh? Insert the carpet tile to be used as the argument
//If no argument is given a new one will be made.
/turf/simulated/floor/proc/make_carpet_floor(var/obj/item/stack/tile/carpet/T = null)
	broken = 0
	burnt = 0
	intact = 1
	if(T)
		if(istype(T,/obj/item/stack/tile/carpet))
			floor_type = T.type
			update_icon()
			levelupdate()
			return
	//if you gave a valid parameter, it won't get thisf ar.
	floor_type = /obj/item/stack/tile/carpet

	update_icon()
	levelupdate()

/turf/simulated/floor/attackby(obj/item/C as obj, mob/user as mob)

	if(!C || !user)
		return 0

	if(istype(C,/obj/item/weapon/light/bulb)) //only for light tiles
		if(is_light_floor())
			if(get_lightfloor_state())
				user.remove_from_mob(C)
				qdel(C)
				set_lightfloor_state(0) //fixing it by bashing it with a light bulb, fun eh?
				update_icon()
				user << SPAN_NOTE("You replace the light bulb.")
			else
				user << SPAN_NOTE("The lightbulb seems fine, no need to replace it.")

	if(istype(C, /obj/item/weapon/crowbar) && (!(is_plating())))
		if(broken || burnt)
			user << "\red You remove the broken plating."
		else
			if(is_wood_floor())
				user << "\red You forcefully pry off the planks, destroying them in the process."
			else
				var/obj/item/I = new floor_type(src, 1)
				if(is_light_floor())
					var/obj/item/stack/tile/light/L = I
					L.on = get_lightfloor_on()
					L.state = get_lightfloor_state()
				user << "\red You remove the [I.name]."

		make_plating()
		playsound(src, 'sound/items/Crowbar.ogg', 80, 1)

		return

	if(istype(C, /obj/item/weapon/screwdriver) && is_wood_floor())
		if(broken || burnt)
			return
		else
			if(is_wood_floor())
				user << "\red You unscrew the planks."
				new floor_type(src, 1)

		make_plating()
		playsound(src, 'sound/items/Screwdriver.ogg', 80, 1)

		return

	if(istype(C, /obj/item/stack/rods))
		var/obj/item/stack/rods/R = C
		if (is_plating())
			if (R.get_amount() < 2)
				user << "<span class='warning'>You need more rods.</span>"
				return
			user << SPAN_NOTE("Reinforcing the floor...")
			if(do_after(user, 30) && is_plating())
				if (R.use(2))
					ChangeTurf(/turf/simulated/floor/engine)
					playsound(src, 'sound/items/Deconstruct.ogg', 80, 1)
				return
			else
		else
			user << "\red You must remove the plating first."
		return

	if(istype(C, /obj/item/stack/tile))
		if(is_plating())
			if(!broken && !burnt)
				var/obj/item/stack/tile/T = C
				if (T.get_amount() < 1)
					return
				if(!T.build_type)
					floor_type = T.type
				else
					floor_type = T.build_type
				intact = 1
				if(istype(T,/obj/item/stack/tile/light))
					var/obj/item/stack/tile/light/L = T
					set_lightfloor_state(L.state)
					set_lightfloor_on(L.on)
				if(istype(T,/obj/item/stack/tile/grass))
					for(var/direction in cardinal)
						if(istype(get_step(src,direction),/turf/simulated/floor))
							var/turf/simulated/floor/FF = get_step(src,direction)
							FF.update_icon() //so siding gets updated properly
				else if(istype(T,/obj/item/stack/tile/carpet))
					for(var/direction in list(1,2,4,8,5,6,9,10))
						if(istype(get_step(src,direction),/turf/simulated/floor))
							var/turf/simulated/floor/FF = get_step(src,direction)
							FF.update_icon() //so siding gets updated properly
				T.use(1)
				update_icon()
				levelupdate()
				playsound(src, 'sound/weapons/Genhit.ogg', 50, 1)
			else
				user << SPAN_NOTE("This section is too damaged to support a tile. Use a welder to fix the damage.")


	if(istype(C, /obj/item/stack/cable_coil))
		if(is_plating())
			var/obj/item/stack/cable_coil/coil = C
			coil.turf_place(src, user)
		else
			user << "\red You must remove the plating first."

	if(istype(C, /obj/item/weapon/shovel))
		if(is_grass_floor())
			new /obj/item/weapon/ore/glass(src)
			new /obj/item/weapon/ore/glass(src) //Make some sand if you shovel grass
			user << SPAN_NOTE("You shovel the grass.")
			make_plating()
		else
			user << "\red You cannot shovel this."

	if(istype(C, /obj/item/weapon/weldingtool))
		var/obj/item/weapon/weldingtool/welder = C
		if(welder.isOn() && (is_plating()))
			if(broken || burnt)
				if(welder.remove_fuel(0,user))
					user << "\red You fix some dents on the broken plating."
					playsound(src, 'sound/items/Welder.ogg', 80, 1)
					icon_state = "plating"
					burnt = 0
					broken = 0
				else
					user << SPAN_NOTE("You need more welding fuel to complete this task.")
