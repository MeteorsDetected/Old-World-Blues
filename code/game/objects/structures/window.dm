/obj/structure/window
	name = "window"
	desc = "A window."
	icon = 'icons/obj/structures.dmi'
	density = 1
	w_class = ITEM_SIZE_NORMAL
	layer = 3.2//Just above doors
	anchored = TRUE
	flags = ON_BORDER
	var/maxhealth = 14.0
	var/health
	var/ini_dir = null
	var/state = 2
	var/reinf = 0
	var/basestate
	var/shardtype = /obj/item/weapon/material/shard
	var/glasstype = null // Set this in subtypes. Null is assumed strange or otherwise impossible to dismantle, such as for shuttle glass.
	var/silicate = 0 // number of units of silicate

/obj/structure/window/examine(mob/user)
	. = ..()

	if(health == maxhealth)
		user << SPAN_NOTE("It looks fully intact.")
	else
		var/perc = health / maxhealth
		if(perc > 0.75)
			user << SPAN_NOTE("It has a few cracks.")
		else if(perc > 0.5)
			user << "<span class='warning'>It looks slightly damaged.</span>"
		else if(perc > 0.25)
			user << "<span class='warning'>It looks moderately damaged.</span>"
		else
			user << "<span class='danger'>It looks heavily damaged.</span>"
	if(silicate)
		if (silicate < 30)
			user << SPAN_NOTE("It has a thin layer of silicate.")
		else if (silicate < 70)
			user << SPAN_NOTE("It is covered in silicate.")
		else
			user << SPAN_NOTE("There is a thick layer of silicate covering it.")

/obj/structure/window/proc/take_damage(var/damage = 0,  var/sound_effect = 1)
	var/initialhealth = health

	if(silicate)
		damage = damage * (1 - silicate / 200)

	health = max(0, health - damage)

	if(health <= 0)
		shatter()
	else
		if(sound_effect)
			playsound(loc, 'sound/effects/Glasshit.ogg', 100, 1)
		if(health < maxhealth / 4 && initialhealth >= maxhealth / 4)
			visible_message("[src] looks like it's about to shatter!" )
		else if(health < maxhealth / 2 && initialhealth >= maxhealth / 2)
			visible_message("[src] looks seriously damaged!" )
		else if(health < maxhealth * 3/4 && initialhealth >= maxhealth * 3/4)
			visible_message("Cracks begin to appear in [src]!" )
	return

/obj/structure/window/proc/apply_silicate(var/amount)
	if(health < maxhealth) // Mend the damage
		health = min(health + amount * 3, maxhealth)
		if(health == maxhealth)
			visible_message("[src] looks fully repaired." )
	else // Reinforce
		silicate = min(silicate + amount, 100)
		updateSilicate()

/obj/structure/window/proc/updateSilicate()
	if (overlays)
		overlays.Cut()

	var/image/img = image(src.icon, src.icon_state)
	img.color = "#ffffff"
	img.alpha = silicate * 255 / 100
	overlays += img

/obj/structure/window/proc/shatter(var/display_message = 1)
	playsound(src, "shatter", 70, 1)
	if(display_message)
		visible_message("[src] shatters!")
	if(dir == SOUTHWEST)
		var/index = null
		index = 0
		while(index < 2)
			new shardtype(loc) //todo pooling?
			if(reinf) PoolOrNew(/obj/item/stack/rods, loc)
			index++
	else
		new shardtype(loc) //todo pooling?
		if(reinf) PoolOrNew(/obj/item/stack/rods, loc)
	qdel(src)
	return


/obj/structure/window/bullet_act(var/obj/item/projectile/Proj)

	//Tasers and the like should not damage windows.
	if(!(Proj.damage_type == BRUTE || Proj.damage_type == BURN))
		return

	..()
	take_damage(Proj.damage)
	return


/obj/structure/window/ex_act(severity)
	switch(severity)
		if(1.0)
			qdel(src)
			return
		if(2.0)
			shatter(0)
			return
		if(3.0)
			if(prob(50))
				shatter(0)
				return


/obj/structure/window/blob_act()
	shatter()


/obj/structure/window/meteorhit()
	shatter()


/obj/structure/window/CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
	if(istype(mover) && mover.checkpass(PASSGLASS))
		return 1
	if(is_fulltile())
		return 0	//full tile window, you can't move into it!
	if(get_dir(loc, target) == dir)
		return !density
	else
		return 1


/obj/structure/window/CheckExit(atom/movable/O as mob|obj, target as turf)
	if(istype(O) && O.checkpass(PASSGLASS))
		return 1
	if(get_dir(O.loc, target) == dir)
		return 0
	return 1


/obj/structure/window/hitby(AM as mob|obj)
	..()
	visible_message("<span class='danger'>[src] was hit by [AM].</span>")
	var/tforce = 0
	if(ismob(AM))
		tforce = 10
		var/mob/living/M = AM
		M.apply_damage(tforce)
	else if(isobj(AM))
		var/obj/item/I = AM
		tforce = I.throwforce
	if(reinf) tforce *= 0.5
	if(health - tforce <= 7 && !reinf)
		anchored = 0
		update_nearby_icons()
		step(src, get_dir(AM, src))
	take_damage(tforce)

/obj/structure/window/attack_tk(mob/user as mob)
	user.visible_message(SPAN_NOTE("Something knocks on [src]."))
	playsound(loc, 'sound/effects/Glasshit.ogg', 50, 1)

/obj/structure/window/attack_hand(mob/user as mob)
	user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
	//TODO: DNA3 hulk
	/*
	if(HULK in user.mutations)
		user.say(pick(";RAAAAAAAARGH!", ";HNNNNNNNNNGGGGGGH!", ";GWAAAAAAAARRRHHH!", "NNNNNNNNGGGGGGGGHH!", ";AAAAAAARRRGH!"))
		user.visible_message("<span class='danger'>[user] smashes through [src]!</span>")
		user.do_attack_animation(src)
		shatter()
		return
	*/

	if(usr.a_intent == I_HURT)
		if (ishuman(usr))
			var/mob/living/carbon/human/H = usr
			if(H.can_shred())
				attack_generic(H,25)
				return

		playsound(src.loc, 'sound/effects/glassknock.ogg', 80, 1)
		user.do_attack_animation(src)
		usr.visible_message(
			"<span class='danger'>\The [usr] bangs against \the [src]!</span>",
			"<span class='danger'>You bang against \the [src]!</span>",
			"You hear a banging sound."
		)
	else
		playsound(src.loc, 'sound/effects/glassknock.ogg', 80, 1)
		usr.visible_message(
			"[usr.name] knocks on the [src.name].",
			"You knock on the [src.name].",
			"You hear a knocking sound."
		)

/obj/structure/window/attack_generic(var/mob/user, var/damage)
	user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
	if(!damage)
		return
	if(damage >= 10)
		visible_message("<span class='danger'>[user] smashes into [src]!</span>")
		take_damage(damage)
	else
		visible_message(SPAN_NOTE("\The [user] bonks \the [src] harmlessly."))
	user.do_attack_animation(src)
	return 1

/obj/structure/window/affect_grab(var/mob/living/user, var/mob/living/target, var/state)
	switch(state)
		if(GRAB_PASSIVE)
			visible_message(SPAN_WARN("[user] slams [target] against \the [src]!"))
			target.apply_damage(7)
			hit(10)
		if(GRAB_AGGRESSIVE)
			visible_message(SPAN_DANGER("[user] bashes [target] against \the [src]!"))
			if(prob(50))
				target.Weaken(1)
			target.apply_damage(10)
			hit(25)
		if(GRAB_NECK)
			visible_message(SPAN_DANGER("<big>[user] crushes [target] against \the [src]!</big>"))
			target.Weaken(5)
			target.apply_damage(20)
			hit(50)
	admin_attack_log(user, target,
		"Smashed [key_name(target)] against \the [src]",
		"Smashed against \the [src] by [key_name(user)]",
		"smashed [key_name(target)] against \the [src]."
	)
	return TRUE


/obj/structure/window/attackby(obj/item/W as obj, mob/user as mob)
	if(!istype(W)) return//I really wish I did not need this
	if(W.flags & NOBLUDGEON) return

	if(istype(W, /obj/item/weapon/screwdriver))
		if(reinf && state >= 1)
			state = 3 - state
			playsound(loc, 'sound/items/Screwdriver.ogg', 75, 1)
			user << (state == 1 ? SPAN_NOTE("You have unfastened the window from the frame.") : SPAN_NOTE("You have fastened the window to the frame."))
		else if(reinf && state == 0)
			anchored = !anchored
			update_nearby_icons()
			playsound(loc, 'sound/items/Screwdriver.ogg', 75, 1)
			user << (anchored ? SPAN_NOTE("You have fastened the frame to the floor.") : SPAN_NOTE("You have unfastened the frame from the floor."))
		else if(!reinf)
			anchored = !anchored
			update_nearby_icons()
			playsound(loc, 'sound/items/Screwdriver.ogg', 75, 1)
			user << (anchored ? SPAN_NOTE("You have fastened the window to the floor.") : SPAN_NOTE("You have unfastened the window."))
	else if(istype(W, /obj/item/weapon/crowbar) && reinf && state <= 1)
		state = 1 - state
		playsound(loc, 'sound/items/Crowbar.ogg', 75, 1)
		user << (state ? SPAN_NOTE("You have pried the window into the frame.") : SPAN_NOTE("You have pried the window out of the frame."))
	else if(istype(W, /obj/item/weapon/wrench) && !anchored && (!state || !reinf))
		if(!glasstype)
			user << SPAN_NOTE("You're not sure how to dismantle \the [src] properly.")
		else
			playsound(src.loc, 'sound/items/Ratchet.ogg', 75, 1)
			visible_message(SPAN_NOTE("[user] dismantles \the [src]."))
			if(dir == SOUTHWEST)
				var/obj/item/stack/material/mats = new glasstype(loc)
				mats.amount = is_fulltile() ? 4 : 2
			else
				new glasstype(loc)
			qdel(src)
	else
		user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
		if(W.damtype == BRUTE || W.damtype == BURN)
			user.do_attack_animation(src)
			hit(W.force)
			if(health <= 7)
				anchored = 0
				update_nearby_icons()
				step(src, get_dir(user, src))
		else
			playsound(loc, 'sound/effects/Glasshit.ogg', 75, 1)
		..()
	return

/obj/structure/window/proc/hit(var/damage, var/sound_effect = 1)
	if(reinf) damage *= 0.5
	take_damage(damage)
	return


/obj/structure/window/verb/rotate()
	set name = "Rotate Window Counter-Clockwise"
	set category = "Object"
	set src in oview(1)

	if(usr.incapacitated())
		return 0

	if(anchored)
		usr << "It is fastened to the floor therefore you can't rotate it!"
		return 0

	update_nearby_tiles(need_rebuild=1) //Compel updates before
	set_dir(turn(dir, 90))
	updateSilicate()
	update_nearby_tiles(need_rebuild=1)
	return


/obj/structure/window/verb/revrotate()
	set name = "Rotate Window Clockwise"
	set category = "Object"
	set src in oview(1)

	if(usr.incapacitated())
		return 0

	if(anchored)
		usr << "It is fastened to the floor therefore you can't rotate it!"
		return 0

	update_nearby_tiles(need_rebuild=1) //Compel updates before
	set_dir(turn(dir, 270))
	updateSilicate()
	update_nearby_tiles(need_rebuild=1)


/obj/structure/window/New(Loc, start_dir=null, constructed=0)
	//player-constructed windows
	if (constructed)
		anchored = 0
	if (start_dir)
		set_dir(start_dir)
	..()


/obj/structure/window/initialize(maploaded = FALSE)
	. = ..()
	health = maxhealth

	ini_dir = dir

	update_nearby_tiles(need_rebuild=1)
	if(maploaded)
		update_icon()
	else
		update_nearby_icons()


/obj/structure/window/Destroy()
	density = 0
	update_nearby_tiles()
	update_nearby_icons()
	. = ..()


/obj/structure/window/Move()
	var/ini_dir = dir
	update_nearby_tiles(need_rebuild=1)
	..()
	set_dir(ini_dir)
	update_nearby_tiles(need_rebuild=1)

//TODO: Make full windows a separate type of window.
//Once a full window, it will always be a full window, so there's no point
//having the same type for both.
//checks if this window is full-tile one
/obj/structure/window/proc/is_fulltile()
	if(dir & (dir - 1))
		return 1
	return 0

//This proc is used to update the icons of nearby windows. It should not be confused with update_nearby_tiles(), which is an atmos proc!
/obj/structure/window/proc/update_nearby_icons()
	update_icon()
	for(var/direction in cardinal)
		for(var/obj/structure/window/W in get_step(src,direction) )
			W.update_icon()

//merges adjacent full-tile windows into one (blatant ripoff from game/smoothwall.dm)
/obj/structure/window/update_icon()
	//A little cludge here, since I don't know how it will work with slim windows. Most likely VERY wrong.
	//this way it will only update full-tile ones
	//This spawn is here so windows get properly updated when one gets deleted.
	spawn(2)
		if(!src) return
		if(!is_fulltile())
			icon_state = "[basestate]"
			return
		var/junction = 0 //will be used to determine from which side the window is connected to other windows
		if(anchored)
			for(var/obj/structure/window/W in orange(src,1))
				if(W.anchored && W.density	&& W.is_fulltile()) //Only counts anchored, not-destroyed fill-tile windows.
					if(abs(x-W.x)-abs(y-W.y) ) 		//doesn't count windows, placed diagonally to src
						junction |= get_dir(src,W)
		if(opacity)
			icon_state = "[basestate][junction]"
		else
			if(reinf)
				icon_state = "[basestate][junction]"
			else
				icon_state = "[basestate][junction]"


/obj/structure/window/fire_act(datum/gas_mixture/air, exposed_temperature, exposed_volume)
	if(exposed_temperature > T0C + 800)
		hit(round(exposed_volume / 100), 0)
	..()



/obj/structure/window/basic
	desc = "It looks thin and flimsy. A few knocks with... anything, really should shatter it."
	icon_state = "window"
	basestate = "window"
	glasstype = /obj/item/stack/material/glass


/obj/structure/window/phoronbasic
	name = "phoron window"
	desc = "A phoron-glass alloy window. It looks insanely tough to break. It appears it's also insanely tough to burn through."
	basestate = "phoronwindow"
	icon_state = "phoronwindow"
	shardtype = /obj/item/weapon/material/shard/phoron
	glasstype = /obj/item/stack/material/glass/phoronglass
	maxhealth = 120

/obj/structure/window/phoronbasic/fire_act(datum/gas_mixture/air, exposed_temperature, exposed_volume)
	if(exposed_temperature > T0C + 32000)
		hit(round(exposed_volume / 1000), 0)
	..()

/obj/structure/window/phoronreinforced
	name = "reinforced phoron window"
	desc = "A phoron-glass alloy window, with rods supporting it. It looks hopelessly tough to break. It also looks completely fireproof, considering how basic phoron windows are insanely fireproof."
	basestate = "phoronrwindow"
	icon_state = "phoronrwindow"
	shardtype = /obj/item/weapon/material/shard/phoron
	glasstype = /obj/item/stack/material/glass/phoronrglass
	reinf = 1
	maxhealth = 160

/obj/structure/window/phoronreinforced/fire_act(datum/gas_mixture/air, exposed_temperature, exposed_volume)
	return

/obj/structure/window/reinforced
	name = "reinforced window"
	desc = "It looks rather strong. Might take a few good hits to shatter it."
	icon_state = "rwindow"
	basestate = "rwindow"
	maxhealth = 40
	reinf = 1
	glasstype = /obj/item/stack/material/glass/reinforced

/obj/structure/window/New(Loc, constructed=0)
	..()

	//player-constructed windows
	if (constructed)
		state = 0

/obj/structure/window/reinforced/tinted
	name = "tinted window"
	desc = "It looks rather strong and opaque. Might take a few good hits to shatter it."
	icon_state = "twindow"
	basestate = "twindow"
	opacity = 1

/obj/structure/window/reinforced/tinted/frosted
	name = "frosted window"
	desc = "It looks rather strong and frosted over. Looks like it might take a few less hits then a normal reinforced window."
	icon_state = "fwindow"
	basestate = "fwindow"
	maxhealth = 30

/obj/structure/window/shuttle
	name = "shuttle window"
	desc = "It looks rather strong. Might take a few good hits to shatter it."
	icon = 'icons/obj/podwindows.dmi'
	icon_state = "basic"
	basestate = "basic"
	maxhealth = 40
	reinf = 1
	dir = 5

/obj/structure/window/shuttle/is_fulltile()
	return TRUE

/obj/structure/window/shuttle/update_icon() //icon_state has to be set manually
	icon_state = "blank"
	overlays.Cut()

	for(var/dir in cardinal)
		var/turf/T = get_step(src, dir)
		if(istype(T, /turf/simulated/shuttle/wall) || locate(/obj/shuttle/corner) in T)
			overlays += image("wall",   dir = dir)
		else if(locate(/obj/structure/window/shuttle) in T)
			overlays += image("window", dir = dir)
		else
			overlays += image("empty", dir = dir)


/obj/structure/window/reinforced/polarized
	name = "electrochromic window"
	desc = "Adjusts its tint with voltage. Might take a few good hits to shatter it."
	var/id

/obj/structure/window/reinforced/polarized/proc/toggle()
	if(opacity)
		animate(src, color="#FFFFFF", time=5)
		set_opacity(0)
	else
		animate(src, color="#222222", time=5)
		set_opacity(1)



/obj/machinery/button/windowtint
	name = "window tint control"
	icon = 'icons/obj/power.dmi'
	icon_state = "light0"
	desc = "A remote control switch for polarized windows."
	var/range = 7

/obj/machinery/button/windowtint/attack_hand(mob/user as mob)
	if(..())
		return 1

	toggle_tint()

/obj/machinery/button/windowtint/proc/toggle_tint()
	use_power(5)

	active = !active
	update_icon()

	for(var/obj/structure/window/reinforced/polarized/W in range(src,range))
		if (W.id == src.id || !W.id)
			spawn(0)
				W.toggle()
				return

/obj/machinery/button/windowtint/power_change()
	..()
	if(active && stat&NOPOWER)
		toggle_tint()

/obj/machinery/button/windowtint/update_icon()
	icon_state = "light[active]"
