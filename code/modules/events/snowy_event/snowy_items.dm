

/obj/item/weapon/snowy_woodchunks
	name = "wood chunks"
	desc = "Some wood from one of these trees."
	icon = 'icons/obj/snowy_event/snowy_icons.dmi'
	icon_state = "wood_chunks"
	w_class = ITEM_SIZE_SMALL
	//var/temperature_gives = 480 //how many heat it can give
	//I do it later. Need to rework campfire


/obj/item/weapon/snowy_woodchunks/attackby(obj/item/weapon/T as obj, mob/user as mob)
	if(istype(T, /obj/item/weapon/tendon))
		user << SPAN_NOTE("You take useful wood, tendons and crafted construction kit.")
		var/obj/item/blueprints/ckit/CK = new(user.loc)
		qdel(T)
		qdel(src)
		user.put_in_hands(CK)
		return
	if(!T.sharp || istype(T, /obj/item/weapon/wirecutters))
		return

	for(var/i = 1, i<5, i++)
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
	if(istype(O, /obj/item/weapon/spider_silk))
		user << SPAN_NOTE("You wind up a silk at the stick.")
		new /obj/item/weapon/spindle(get_turf(src))
		qdel(O)
		qdel(src)



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

/obj/item/weapon/spindle/examine(mob/user as mob)
	..()
	user << SPAN_NOTE("[charges] charges left.")


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


//Sewing stuff. Temporary here

/obj/item/weapon/spindle
	name = "Spindle"
	desc = "Spindle with some threads. Take off your finger from it!"
	icon = 'icons/obj/snowy_event/snowy_icons.dmi'
	icon_state = "spindle"
	w_class = ITEM_SIZE_TINY
	var/charges = 5

/obj/item/weapon/needle
	name = "bone needle"
	desc = "Looks sharp but crooked."
	icon = 'icons/obj/snowy_event/snowy_icons.dmi'
	icon_state = "bone_needle"
	w_class = ITEM_SIZE_TINY
	var/thread = 0
	var/charges = 3


/obj/item/weapon/needle/update_icon()
	overlays.Cut()
	if(thread)
		overlays += "needle_thread"


/obj/item/weapon/needle/attackby(obj/item/weapon/O as obj, mob/user as mob)
	if(thread)
		if(charges > 0)
			return
	if(istype(O, /obj/item/weapon/spindle))
		var/obj/item/weapon/spindle/S = O
		user << SPAN_NOTE("You put the thread through the needle eye.")
		if(S.charges > 0)
			thread = 1
			charges = 3
			S.charges--
			update_icon()
			if(S.charges < 1)
				qdel(S)
				new /obj/item/weapon/stick(get_turf(src))


/obj/item/weapon/unfinishedfurs
	name = "Unfinished"
	desc = "Fur, leather, threads. This is how it begins."
	icon = 'icons/obj/snowy_event/snowy_icons.dmi'
	icon_state = "fur_stuff"
	w_class = ITEM_SIZE_SMALL
	var/stripes = 0
	var/obj/item/weapon/head/head = null
	var/tendons = 0
	var/obj/item/weapon/skin/skin = null
	var/creating_obj = null
	var/required_thread = 0


/obj/item/weapon/unfinishedfurs/proc/makeThings(var/choosed_obj)
	if(choosed_obj == "Deer hat")
		stripes = 2
		tendons = 5
		src.name = "[src.name] deer hat."
	else
		stripes = 5
		tendons = 2
		src.name = "[src.name] wolf mask."
	creating_obj = choosed_obj


/obj/item/weapon/unfinishedfurs/examine(mob/user as mob)
	..()
	if(required_thread)
		user << SPAN_NOTE("Need to sew this.")
	else
		if(tendons > 0)
			user << SPAN_NOTE("[tendons] tendons left.")
		if(stripes > 0)
			user << SPAN_NOTE("[stripes] leather stripes left.")
		if(!skin)
			user << SPAN_NOTE("good skin required.")
		if(!head)
			if(creating_obj == "Deer hat")
				user << SPAN_NOTE("Deer's head required.")
			else
				user << SPAN_NOTE("Wolf's head required.")


/obj/item/weapon/unfinishedfurs/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(required_thread)
		if(istype(W, /obj/item/weapon/needle))
			var/obj/item/weapon/needle/N = W
			if(N.charges > 0)
				user.visible_message(
						SPAN_NOTE("[user] sews something with needle."),
						SPAN_NOTE("You sew the [name].")
					)
				N.charges--
				N.update_icon()
				required_thread = 0
			else
				user << SPAN_WARN("You need threads.")
		else
			user << SPAN_WARN("You need to sew this first.")
	else
		if(istype(W, /obj/item/weapon/leatherstripes) && stripes > 0)
			qdel(W)
			stripes--
			required_thread = 1
		if(istype(W, /obj/item/weapon/tendon) && tendons > 0)
			qdel(W)
			tendons--
			required_thread = 1
		if(istype(W, /obj/item/weapon/head) && !head)
			if(creating_obj == "Deer hat" && W.type == /obj/item/weapon/head)
				head = W
				user.drop_from_inventory(W, src)
				required_thread = 1
			else if(creating_obj == "Wolf mask" && W.type == /obj/item/weapon/head/wolf)
				head = W
				user.drop_from_inventory(W, src)
				required_thread = 1
		if(istype(W, /obj/item/weapon/skin) && !skin)
			skin = W
			user.drop_from_inventory(W, src)
			required_thread = 1
	if(tendons == 0 && stripes == 0 && skin && head && !required_thread)
		if(creating_obj == "Deer hat")
			new /obj/item/clothing/head/deerhat(get_turf(src))
			qdel(src)
		else
			new /obj/item/clothing/mask/wolfmask(get_turf(src))
			qdel(src)



/obj/item/weapon/leatherstripes
	name = "Leather stripes"
	desc = "Inaccurate, but still useful. Looks like a bacon but this is not!"
	icon = 'icons/obj/snowy_event/snowy_icons.dmi'
	icon_state = "leather_stripes"
	w_class = ITEM_SIZE_TINY


//Room building. Temporary method. Maybe later i make roof building as part of construction
//Or rework this and make trough atmos's zones
//Or i drink some coffee and will never touch that shit
//Maybe...
/obj/item/blueprints/ckit
	name = "Construction kit"
	desc = "Some of wood, ropes and your imagination"
	icon = 'icons/obj/snowy_event/snowy_icons.dmi'
	icon_state = "construction_kit"
	w_class = ITEM_SIZE_NORMAL
	var/in_process = 0


/obj/item/blueprints/ckit/attack_self(mob/living/carbon/human/H as mob)
	var/area/A = get_area()
	if(istype(A, /area/outdoor))
		H << SPAN_NOTE("You begin reinforce the roof...")
		in_process = 1
		if(do_after(H, 70))
			create_area()
			H << SPAN_NOTE("You reinforced the roof.")
		else
			in_process = 0
			H << SPAN_WARN("You stop the reinforcing.")
	else if(istype(A, /area/indoor))
		H << SPAN_NOTE("You begin to remove cover from roof...")
		in_process = 1
		if(do_after(H, 70))
			removeArea()
			H << SPAN_NOTE("You removed cover from roof.")
		else
			in_process = 0
			H << SPAN_WARN("You change your mind.")


//Copypasted and slightly changed
/obj/item/blueprints/ckit/create_area()
	var/res = detect_room(get_turf(usr))
	if(!istype(res,/list))
		switch(res)
			if(ROOM_ERR_SPACE)
				usr << "\red You need full closed room with platings to reinforce roof properly."
				return
			if(ROOM_ERR_TOOLARGE)
				usr << "\red This room is too large for roof building. Or this is not room."
				return
			else
				usr << "\red Error! Please notify administration!"
				return
	var/list/turf/turfs = res
	var/area/indoor/A = new
	A.name = "Room [rand(1, 100)]-[rand(1, 999)]"
	A.power_equip = 0
	A.power_light = 0
	A.power_environ = 0
	A.always_unpowered = 0
	move_turfs_to_area(turfs, A)
	for(var/turf/T in A.contents)
		T.lighting_build_overlays()
		T.luminosity = !A.lighting_use_dynamic
		for(var/turf/Turf in orange(1, T))
			if(Turf.luminosity)
				Turf.update_sunlight()
	qdel(src)


//Copypasted with some changes
//For some reason .. not working here. Hm. I'm take a look closer later
/obj/item/blueprints/ckit/check_tile_is_border(var/turf/T2,var/dir)
	if (istype(T2, /turf/simulated/floor/plating/snow))
		return BORDER_SPACE //omg hull breach we all going to die here
	if (istype(T2, /turf/simulated/shuttle))
		return BORDER_SPACE
	if (get_area_type(T2.loc)!=AREA_SPACE)
		return BORDER_BETWEEN
	if (istype(T2, /turf/simulated/wall))
		return BORDER_2NDTILE
	if (!istype(T2, /turf/simulated))
		return BORDER_BETWEEN
	for (var/obj/structure/window/W in T2)
		if(turn(dir,180) == W.dir)
			return BORDER_BETWEEN
		if (W.dir in list(NORTHEAST,SOUTHEAST,NORTHWEST,SOUTHWEST))
			return BORDER_2NDTILE
	for(var/obj/machinery/door/window/D in T2)
		if(turn(dir,180) == D.dir)
			return BORDER_BETWEEN
	if (locate(/obj/machinery/door) in T2)
		return BORDER_2NDTILE

	return BORDER_NONE


/obj/item/blueprints/ckit/get_area_type(var/area/A = get_area())
	if(istype(A, /area/outdoor) || istype(A, /area/indoor))
		return AREA_SPACE
	..()


/obj/item/blueprints/ckit/proc/removeArea()
	var/area/master_area = locate(/area/outdoor) in world //there must be the world.area, bu-u-u-ut... I think this is not necessary
	var/area/A = get_area()
	var/list/turf/turfs = detect_room(get_turf(usr))
	move_turfs_to_area(turfs, master_area)
	for(var/turf/T in master_area.contents)
		T.lighting_clear_overlays()
		T.luminosity = !master_area.lighting_use_dynamic
		for(var/turf/Turf in orange(1, T))
			if(Turf.luminosity)
				Turf.update_sunlight()
	qdel(A)
	qdel(src)



//some clothes

/obj/item/clothing/head/deerhat
	name = "Deer hat"
	desc = "Handmade hat from deer's head with some furs and leather. You can see a various junk at horns: stripes, cones, branches."
	icon_state = "deerhat"
	item_state = "deerhat"
	w_class = ITEM_SIZE_NORMAL
	body_parts_covered = HEAD|FACE
	cold_protection = HEAD|FACE
	min_cold_protection_temperature = 35

/obj/item/clothing/mask/wolfmask
	name = "Wolf mask"
	desc = "You tricked me, Meat, Ignoring my request has a price. Do not think you can do whatever you like. \red IT'S MY FUCKING FOREST!"
	icon_state = "wolfmask"
	item_state = "wolfmask"
	flags_inv = HIDEFACE|BLOCKHAIR
	body_parts_covered = HEAD|FACE
	cold_protection = HEAD|FACE
	min_cold_protection_temperature = 25