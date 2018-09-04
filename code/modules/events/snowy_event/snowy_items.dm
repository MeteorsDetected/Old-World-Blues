

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


/obj/item/weapon/holder_stick/attackby(obj/item/weapon/O as obj, mob/user as mob)
	if(istype(O, /obj/item/weapon/spider_silk))
		var/obj/item/weapon/material/hatchet/stone/S = new(get_turf(src))
		S.broke()
		if(O.loc == user)
			user.put_in_inactive_hand(S)
		qdel(O)
		qdel(src)


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


//stone hatchet
/obj/item/weapon/material/hatchet/stone
	name = "stone hatchet"
	desc = "Not a very sharp hatchet, unreliable, but most available surviving tool."
	icon = 'icons/obj/snowy_event/snowy_icons.dmi'
	icon_state = "stone_hatchet"
	origin_tech = list()
	var/hits_left = 15 //there are hits count before weapon will broke
	var/unfinished = 0


/obj/item/weapon/material/hatchet/stone/afterattack(atom/A, mob/user, proximity)
	..()
	if(!istype(A, /turf))
		hits_left--
		if(hits_left <= 0)
			hits_left = 0
			if(prob(30))
				broke()
				user << SPAN_WARN("Your [name] is now out of order!")


/obj/item/weapon/material/hatchet/stone/proc/broke()
	unfinished = 1
	sharp = 0
	icon_state = "stone_hatchet-unfinished"
	name = "unfinished stone hatchet"


//folding hatchet
/obj/item/weapon/material/hatchet/folding
	name = "folding hatchet"
	desc = "Useful tool that jaegers uses in patrols. When needed this can be transformed into hatchet in one move. Somebody use him as shovel."
	icon = 'icons/obj/snowy_event/snowy_icons.dmi'
	icon_state = "folding_hatchet-closed"
	var/opened_icon = "folding_hatchet-opened"
	var/closed = 1
	w_class = ITEM_SIZE_SMALL
	force = 5
	throwforce = 5
	sharp = 0
	edge = 0

/obj/item/weapon/material/hatchet/folding/proc/use(mob/user)
	if(closed)
		closed = !closed
		icon_state = opened_icon
		sharp = 1
		edge = 1
		force = 30
		throwforce = 15
		w_class = ITEM_SIZE_LARGE
	else
		icon_state = initial(icon_state)
		closed = !closed
		sharp = 0
		edge = 0
		force = initial(force)
		throwforce = initial(throwforce)
		w_class = initial(w_class)


/obj/item/weapon/material/hatchet/folding/attack_self(mob/living/user as mob)
	use()

//discipline stuff

/obj/item/weapon/melee/discipstick
	name = "disciplinary whipstick"
	desc = "When somebody did not respect your laws and orders. You reinforce your authority with this."
	icon = 'icons/obj/snowy_event/snowy_icons.dmi'
	icon_state = "whipstick"
	item_state = "whipstick"
	w_class = ITEM_SIZE_SMALL

/obj/item/weapon/melee/discipstick/attack(var/mob/living/carbon/C, var/mob/living/user)
	C.attack_generic(user, rand(2, 5), "whips the")
	playsound(src.loc, 'sound/effects/snap.ogg', 60, rand(-70, 70))
	var/pain_word = pick("OUCH!", "FSSS!", "UUGH!")
	C << "\red <big> [pain_word] </big>"
	shake_camera(C, 3, 1)


//tool-multitool
//Well, all attackby uses path at istype so here we have no choice yet

//there are crowbar, wrench and wirecutters by price of one item. Compact. Useful. Conveniently.
///obj/item/weapon/crowbar
///obj/item/weapon/wrench
///obj/item/weapon/wirecutters

/obj/item/weapon/crowbar/multi
	name = "multitool-crowbar"
	desc = "Compact and useful multitool. There are crowbar, wrench and wirecutters."
	icon = 'icons/obj/snowy_event/snowy_icons.dmi'
	icon_state = "multi-crowbar"

/obj/item/weapon/wrench/multi
	name = "multitool-wrench"
	desc = "Compact and useful multitool. There are crowbar, wrench and wirecutters."
	icon = 'icons/obj/snowy_event/snowy_icons.dmi'
	icon_state = "multi-wrench"

/obj/item/weapon/wirecutters/multi
	name = "multitool-wirecutters"
	desc = "Compact and useful multitool. There are crowbar, wrench and wirecutters."
	icon = 'icons/obj/snowy_event/snowy_icons.dmi'
	icon_state = "multi-wirecutters"


/obj/item/weapon/crowbar/multi/attack_self(mob/living/carbon/user as mob)
	user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
	user.drop_from_inventory(src)
	var/obj/item/weapon/wirecutters/multi/W = new /obj/item/weapon/wirecutters/multi
	user.put_in_active_hand(W)
	W.icon_state = "multi-wirecutters" //there are some kind of bug. Hmm
	user << SPAN_NOTE("You change the [src.name] to [W.name].")
	playsound(src.loc, 'sound/weapons/flipblade.ogg', 70, 1) //multitool is loud
	qdel(src)

/obj/item/weapon/wirecutters/multi/attack_self(mob/living/carbon/user as mob)
	user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
	user.drop_from_inventory(src)
	var/obj/item/weapon/wrench/multi/W = new /obj/item/weapon/wrench/multi
	user.put_in_active_hand(W)
	user << SPAN_NOTE("You change the [src.name] to [W.name].")
	playsound(src.loc, 'sound/weapons/flipblade.ogg', 70, 1)
	qdel(src)


/obj/item/weapon/wrench/multi/attack_self(mob/living/carbon/user as mob)
	user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
	user.drop_from_inventory(src)
	var/obj/item/weapon/crowbar/multi/C = new /obj/item/weapon/crowbar/multi
	user.put_in_active_hand(C)
	user << SPAN_NOTE("You change the [src.name] to [C.name].")
	playsound(src.loc, 'sound/weapons/flipblade.ogg', 70, 1)
	qdel(src)



//a few guns

/obj/item/weapon/gun/projectile/heavysniper/krauzer
	name = "Krauzer 801"
	desc = "An old but powerful krauzer rifle. Even your grandpa remembers this one. If he works at the museum. Have a small chance of jam."
	icon_state = "krauzer"
	item_state = "krauzer"
	origin_tech = list(TECH_COMBAT = 4, TECH_MATERIAL = 2)
	max_shells = 5
	caliber = "a762"
	load_method = 1|2 //that means single bullets and speedloaders (defines not working here)
	ammo_type = /obj/item/ammo_casing/a762

	var/jammed = 0
	var/jam_chance = 5



/obj/item/weapon/gun/projectile/heavysniper/krauzer/update_icon()
	overlays.Cut()
	if(bolt_open)
		overlays += "krauzer-openedbolt"
	else
		overlays += "krauzer-closedbolt"


/obj/item/weapon/gun/projectile/heavysniper/krauzer/special_check(mob/user)
	if(loaded.len)
		if(prob(jam_chance))
			jammed = 1
		if(jammed)
			user.visible_message("*click click*", "<span class='danger'>*click*</span>")
			playsound(src.loc, 'sound/weapons/empty.ogg', 100, 1)
			user << "\red<big><b>[name]</b> is jammed!</big>"
			return 0
	return ..()


/obj/item/weapon/gun/projectile/heavysniper/krauzer/attack_self(mob/user as mob)
	if(user.a_intent == I_GRAB)
		if(jammed)
			user << SPAN_WARN("You need to remove the jam first!")
			return
		else
			unload_ammo(user)
	if(jammed)
		playsound(src.loc, 'sound/weapons/flipblade.ogg', 50, 1)
		bolt_open = !bolt_open
		if(prob(50))
			jammed = 0
			user << SPAN_NOTE("GOT IT!")
			bolt_open = 0
			if(chambered)
				chambered.loc = get_turf(src)
				loaded.Remove(chambered)
				user << SPAN_WARN("Jammed [chambered] has ejected!")
			else
				if(loaded.len)
					var/obj/item/ammo_casing/AC = loaded[1]
					AC.loc = get_turf(src)
					loaded.Remove(loaded[1])
					user << SPAN_WARN("Jammed [AC] has ejected!")
		else
			user << SPAN_WARN("You moves the bolt in attempt to remove the jam.")
		return
	else
		..(user)

/obj/item/weapon/gun/projectile/heavysniper/krauzer/scope()
	set hidden = 1


/obj/item/weapon/gun/projectile/heavysniper/load_ammo(var/obj/item/A, mob/user) //unload with bolt moving
	return


/obj/item/ammo_magazine/cs762
	name = "clip (.762)"
	desc = "An ammo clip for 7.62mm guns. Like old krauzer."
	icon_state = "145mm"
	caliber = "a762"
	matter = list(MATERIAL_STEEL = 360)
	ammo_type = /obj/item/ammo_casing/a762
	max_ammo = 5
	multiple_sprites = 1

//flaregun
/obj/item/weapon/gun/projectile/flaregun
	name = "flaregun"
	desc = "Polar flaregun. The red barrel of it means that's emergency item. So use this at EMERGENCY situations."
	max_shells = 1
	ammo_type = /obj/item/ammo_casing/sflare
	load_method = 1 //singe casing
	handle_casings = 0 //hold casing
	icon_state = "flaregun"
	caliber = "flare"
	origin_tech = list(TECH_COMBAT = 2, TECH_MATERIAL = 2)
	fire_sound = 'sound/weapons/spiderlunge.ogg'
	var/barrel_opened = 0

	New()
		..()
		loaded = list() //spawns empty
		update_icon()


/obj/item/weapon/gun/projectile/flaregun/update_icon()
	overlays.Cut()
	if(barrel_opened)
		icon_state = "flaregun_opened"
		var/O
		if(loaded.len && !chambered)
			O = "flaregun-flare"
		else if(loaded.len && chambered)
			O = "flaregun-flareshotted"
		if(O)
			var/obj/item/ammo_casing/sflare/SF = loaded[1]
			if(SF.flare_color)
				var/icon/I = new(icon, O)
				I.Blend(rgb(SF.flare_color["r"], SF.flare_color["g"], SF.flare_color["b"]), ICON_ADD)
				overlays += I
			else
				overlays += O
	else
		icon_state = "flaregun"




/obj/item/weapon/gun/projectile/flaregun/attack_self(mob/user as mob)
	if(!barrel_opened && loaded.len && loaded[1].BB)
		if(user.a_intent == I_DISARM)
			user.visible_message("\red <b>[user.name]</b> sublimely rises hand with [src] upward and shot!")
			playsound(user.loc, fire_sound, 50, 1)
			if(istype(get_area(user), /area/outdoor))
				var/turf/P = get_turf(user)
				var/obj/item/ammo_casing/sflare/SF = loaded[1]
				spawn(30)
					playsound(P, 'sound/effects/meteorimpact.ogg', 40, 1)
					P.visible_message("<big>\blue Bright [SF.display_color] flash has illuminate the sky.</big>")
					for(var/mob/living/L in range(120, P)) //rised from 50
						if(L in view(7, P))
							continue
						//if(istype(get_area(L), /area/outdoor)) //well, i think without this will be better
						var/d = get_adir(L.loc, P)
						L << "\blue <big> You see the [SF.display_color] flare at <b>[lowertext(d)]</b> from your current position! <big>"
						L << playsound(src.loc, 'sound/effects/explosionfar.ogg', 45, 1)
				spawn(120)
					dropFlare(P)
			else
				playsound(user.loc, 'sound/effects/meteorimpact.ogg', 60, 1)
				for(var/mob/living/carbon/M in viewers(user.loc, 3))
					if(M.eyecheck() < 1)
						flick("e_flash", M.flash)
						if(M == user)
							M.Stun(2)
							M.Weaken(10)
					dropFlare(user.loc)


			consume_next_projectile()
			if(chambered)
				chambered.expend()
				process_chambered()
	playsound(src.loc, 'sound/weapons/flipblade.ogg', 50, 1)
	barrel_opened = !barrel_opened
	add_fingerprint(user)
	update_icon()


/obj/item/weapon/gun/projectile/flaregun/proc/dropFlare(var/turf/T)
	var/obj/item/device/flashlight/flare/F = new /obj/item/device/flashlight/flare(T)
	F.on = !F.on
	F.force = F.on_damage
	F.damtype = "fire"
	processing_objects += F
	F.update_icon()


/obj/item/weapon/gun/projectile/flaregun/special_check(mob/user)
	if(barrel_opened)
		user << "<span class='warning'>You can't fire [src] while barrel is open!</span>"
		return 0
	return ..()


/obj/item/weapon/gun/projectile/flaregun/unload_ammo(mob/user, var/allow_dump = 0)
	if(barrel_opened)
		..()
		update_icon()
	else
		user << SPAN_WARN("You need to open barrel first!")


/obj/item/weapon/gun/projectile/flaregun/load_ammo(var/obj/item/A, mob/user)
	if(!barrel_opened)
		return
	..()
	update_icon()


//flares

/obj/item/ammo_casing/sflare
	desc = "A round signal flare."
	caliber = "flare"
	projectile_type = /obj/item/projectile/energy/sflare
	icon_state = "flare"
	spent_icon = "flare_shotted"
	var/display_color = "white"
	var/flare_color

	New()
		..()
		update_icon()


/obj/item/ammo_casing/sflare/update_icon()
	icon = initial(icon)
	if(!BB)
		icon_state = spent_icon
	if(flare_color)
		icon += rgb(flare_color["r"], flare_color["g"], flare_color["b"])


/obj/item/ammo_casing/sflare/red
	desc = "A round red signal flare."
	display_color = "red"
	flare_color = list("r" = 40, "g" = 0, "b" = 0)

/obj/item/ammo_casing/sflare/green
	desc = "A round green signal flare."
	display_color = "green"
	flare_color = list("r" = 0, "g" = 40, "b" = 0)

/obj/item/ammo_casing/sflare/blue
	desc = "A round blue signal flare."
	display_color = "blue"
	flare_color = list("r" = 0, "g" = 0, "b" = 40)


/obj/item/projectile/energy/sflare
	name ="signal flare"
	icon_state= "bolter"
	damage = 5 //chponk. Shot is almost harmless
	check_armour = "bullet"
	penetrating = 0

	on_impact(var/atom/A)
		var/turf/T = get_turf(A)
		if(!istype(T)) return

		if(istype(A, /mob/living))
			var/mob/living/L = A
			L.Stun(2)
			L.Weaken(10)

		for(var/mob/living/carbon/M in viewers(T, 3))
			if(M.eyecheck() < 1)
				flick("e_flash", M.flash)

		playsound(src.loc, 'sound/effects/meteorimpact.ogg', 50, 1)
		var/obj/item/device/flashlight/flare/F = new /obj/item/device/flashlight/flare(src.loc)
		F.on = !F.on
		F.force = F.on_damage
		F.damtype = "fire"
		processing_objects += F
		F.update_icon()


//supply
/obj/item/storage/box/sflares_red
	name = "box of red signal flares"

/obj/item/storage/box/sflares_red/New()
	..()
	for(var/i = 1 to 7)
		new /obj/item/ammo_casing/sflare/red(src)


/obj/item/storage/box/sflares_green
	name = "box of green signal flares"

/obj/item/storage/box/sflares_green/New()
	..()
	for(var/i = 1 to 7)
		new /obj/item/ammo_casing/sflare/green(src)


/obj/item/storage/box/sflares_blue
	name = "box of blue signal flares"

/obj/item/storage/box/sflares_blue/New()
	..()
	for(var/i = 1 to 7)
		new /obj/item/ammo_casing/sflare/blue(src)


/obj/item/storage/box/krauzerammo
	name = "box of krauzer's ammo"
	desc = "At the side of box you can see 2116 number. Maybe that's mean year?"

/obj/item/storage/box/krauzerammo/New()
	..()
	for(var/i = 1 to 6)
		new /obj/item/ammo_magazine/cs762(src)


/obj/item/storage/box/randomsnacks
	name = "box of something delicious"
	desc = "Here you can see the sign of some kind of restaurant."

/obj/item/storage/box/randomsnacks/New()
	..()
	var/randSnack = pick(subtypesof(/obj/item/weapon/reagent_containers/food/snacks))
	for(var/i = 1 to 6)
		new randSnack(src)


/obj/item/storage/box/randomseeds
	name = "box of seeds"
	desc = "You see an image of the big dome. That's one from space farm."

/obj/item/storage/box/randomseeds/New()
	..()
	var/randSeed = pick(subtypesof(/obj/item/seeds))
	for(var/i = 1 to 7)
		new randSeed(src)

//some clothesc

/obj/item/clothing/head/deerhat
	name = "deer hat"
	desc = "Handmade hat from deer's head with some furs and leather. You can see a various junk at horns: stripes, cones, branches."
	icon_state = "deerhat"
	item_state = "deerhat"
	w_class = ITEM_SIZE_NORMAL
	body_parts_covered = HEAD
	cold_protection = HEAD|FACE
	min_cold_protection_temperature = T0C-35

/obj/item/clothing/mask/wolfmask
	name = "wolf mask"
	desc = "You tricked me, Meat, Ignoring my request has a price. Do not think you can do whatever you like. \red IT'S MY FUCKING FOREST!"
	icon_state = "wolfmask"
	item_state = "wolfmask"
	flags_inv = HIDEFACE|BLOCKHAIR
	body_parts_covered = HEAD|FACE
	cold_protection = HEAD|FACE
	min_cold_protection_temperature = T0C-35

/obj/item/clothing/suit/storage/furcape
	name = "fur cloak"
	desc = "This one can give you a chance for survive at the windstorm. Warm and soft."
	icon_state = "furcape"
	item_state = "furcape"
	armor = list(melee = 30, bullet = 15, laser = 5, energy = 5, bomb = 15, bio = 0, rad = 0)
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|HANDS|ARMS
	cold_protection = UPPER_TORSO|LOWER_TORSO|LEGS|HANDS|ARMS
	min_cold_protection_temperature = T0C-55

/obj/item/storage/belt/wildpouch
	name = "wild pouch"
	desc = "Brushwood, herbs, bones or cones. No matter. This pouch can handle this. Your new best friend."
	icon_state = "wildpouch"
	storage_slots = 18
	max_storage_space = 32

/obj/item/clothing/shoes/jackboots/furboots
	name = "fur boots"
	desc = "Tough, high, warm and soft. These boots handmaded but the work is really impressive."
	icon_state = "furboots"
	force = 3
	armor = list(melee = 45, bullet = 10, laser = 3, energy = 3, bomb = 5, bio = 0, rad = 0)
	cold_protection = LEGS|FEET
	min_cold_protection_temperature = T0C-35


/obj/item/clothing/shoes/men_shoes/snowy_shoes
	name = "winter boots"
	desc = "Warm but heavyweight winter boots."
	cold_protection = LEGS|FEET
	min_cold_protection_temperature = T0C-30

/obj/item/clothing/shoes/workboots/warm
	cold_protection = LEGS|FEET
	min_cold_protection_temperature = T0C-30

/obj/item/clothing/gloves/brown/warm
	name = "warm brown gloves"
	cold_protection = HANDS
	min_cold_protection_temperature = T0C-30


/obj/item/clothing/suit/storage/toggleable_hood/wintercoat
	name = "winter coat"
	desc = "Warm winter coat. With all of that fur neck around you don't need any scarfs."
	icon_state = "wintercoat"
	item_state = "wintercoat"
	cold_protection = UPPER_TORSO|LOWER_TORSO|ARMS|LEGS
	min_cold_protection_temperature = T0C-30
	hood_type = /obj/item/clothing/head/toggleable_hood/wintercoathood


/obj/item/clothing/head/toggleable_hood/wintercoathood
	name = "winter coat's hood"
	icon_state = "wintercoathood"
	cold_protection = HEAD|FACE
	min_cold_protection_temperature = T0C-30
	flags_inv = HIDEFACE|BLOCKHAIR

//captain's stuff

/obj/item/clothing/head/snowycapthat
	name = "colony captain's hat"
	icon_state = "snowycap"
	desc = "Fine looking hat maded special for inspections."
	item_state = "snowycap"


/obj/item/clothing/under/rank/snowycaptain
	desc = "Clear and ironed uniform of colony captain. Smells like coffee and tobacco."
	name = "colony captain's jumpsuit"
	icon_state = "snowy_cap"
	item_state = "snowy_cap"
	cold_protection = UPPER_TORSO|LOWER_TORSO|LEGS|ARMS
	min_cold_protection_temperature = T0C-15


/obj/item/clothing/suit/storage/snowycapcoat
	name = "colony captain's coat"
	desc = "Warm and comfy fine looking longcoat."
	icon_state = "snowy_cap_coat"
	item_state = "snowy_cap_coat"
	cold_protection = UPPER_TORSO|LOWER_TORSO|ARMS|LEGS
	min_cold_protection_temperature = T0C-30


//chief mate
/obj/item/clothing/suit/storage/snowycm
	name = "chief mate's coat"
	desc = "Warm and comfy fine looking longcoat."
	icon_state = "snowy_cap_coat"
	item_state = "snowy_cm_coat"
	cold_protection = UPPER_TORSO|LOWER_TORSO|ARMS|LEGS
	min_cold_protection_temperature = T0C-30


//jaeger's stuff

/obj/item/storage/belt/beltbags
	name = "beltbags"
	desc = "Many bags at the belt. Hold much more than other belts. Jaegers use this as alternative to backpacks. "
	icon_state = "beltbags"
	storage_slots = 16
	max_storage_space = DEFAULT_BACKPACK_STORAGE
	max_w_class = ITEM_SIZE_NORMAL
	slot_flags = SLOT_BELT
	attack_verb = list("whipped", "lashed", "disciplined")


/obj/item/clothing/suit/storage/toggleable_hood/jaegercoat
	name = "jaeger's coat"
	desc = "Thick coat guaranteed almost perfect protect from cold."
	icon_state = "jaeger_coat"
	item_state = "jaeger_coat"
	cold_protection = UPPER_TORSO|LOWER_TORSO|ARMS|LEGS
	min_cold_protection_temperature = T0C-40
	hood_type = /obj/item/clothing/head/toggleable_hood/jaeger_coat_hood

/obj/item/clothing/head/toggleable_hood/jaeger_coat_hood
	name = "jaeger hood"
	icon_state = "jaegerhood"
	cold_protection = HEAD
	min_cold_protection_temperature = T0C-40


//worker stuff

/obj/item/clothing/head/winterhat
	name = "worker hat"
	desc = "Black winter hat. Workers use this when they work."
	icon_state = "winterhat"
	item_state = "winterhat"
	w_class = ITEM_SIZE_NORMAL
	body_parts_covered = HEAD
	cold_protection = HEAD
	min_cold_protection_temperature = T0C-30
