//Fishing and fishing items here
//For fishes look for fishing_fishes.dm
//Each human of that planet(Earth) can use and change this code
//Made by Macleod962
//version 0.1

//It's me, Macleod962 one year ago:
//Holy crab. This file is full of shit. I work in gasmask. If you dont have one, RUN
//Really, tons of shitcode. I rework it slightly now


//Catch and meals here
var/list/fishing_garbage = list(	/obj/item/weapon/handcuffs,
							/obj/item/weapon/dice,
							/obj/item/device/multitool,
							/obj/item/weapon/lipstick/jade,
							/obj/item/toy/gun
							)

var/list/fishing_fishes = list(		/obj/item/weapon/reagent_containers/food/snacks/fish/space_dolphin,
									/obj/item/weapon/reagent_containers/food/snacks/fish/space_shellfish,
									/obj/item/weapon/reagent_containers/food/snacks/fish/space_torped_shark,
									/obj/item/weapon/reagent_containers/food/snacks/fish/space_catfish
							)




/obj/item/weapon/hook
	desc = "Small fishing hook for a small fish. 11."
	name = "fishing hook 11"
	icon = 'icons/obj/snowy_event/fishing.dmi'
	icon_state = "hook"
	force = 3.0
	throwforce = 6.0
	throw_speed = 8
	throw_range = 10
	w_class = 1.0
	w_class = ITEM_SIZE_TINY
	var/addChance = 5
	attack_verb = list("hooked", "cutted")


/obj/item/weapon/fishing_line
	desc = "Thin fishing line for a small fish."
	name = "fishing line(0.3mm)"
	icon = 'icons/obj/snowy_event/fishing.dmi'
	icon_state = "fishing_line"
	var/length = 50
	force = 3.0
	throwforce = 2.0
	throw_speed = 5
	throw_range = 6
	w_class = ITEM_SIZE_TINY
	var/addChance = 5
	attack_verb = list("whiped", "slapped")

/obj/item/weapon/fishing_line/examine(mob/user as mob)
	..()
	user << SPAN_NOTE("[src.length] of fishing line left.")

/obj/item/weapon/fishing_line/attack_self(mob/user as mob)
	if(src.length >= 1)
		src.length -= 1
		usr << SPAN_NOTE("You make the fishing tackle. [src.length] of [src.name] left.")
		var/turf/T = get_turf(src)
		var/obj/item/weapon/fishing_tackle/ft = new(T)
		ft.fishing_line = src
		ft.update_icon()
		if(src.length == 0)
			user.drop_from_inventory(src)
			qdel(src)
	else
		usr << SPAN_WARN("Not enough of fishing line length.")
	return


/obj/item/weapon/fishing_tackle
	desc = "Fishing tackle."
	name = "fishing tackle"
	icon = 'icons/obj/snowy_event/fishing.dmi'
	icon_state = "tackle"
	var/obj/item/weapon/hook/hook = null
	var/obj/item/weapon/fishing_line/fishing_line = null
	var/obj/item/bait = null
	var/damaged = 0
	var/fish = null
	var/chance = 1 // Chance of a fish // Big fish = -60 of chance/ Rare fish = -90 of chance/ Legend fish = -160 of chance
	var/chance_bait = 15 // Chance to catch something. From 1 to 15 // Be patient.
	var/obj/structure/ice_hole/place
	var/obj/item/Catch
	var/in_process = 0
	force = 3.0
	throwforce = 6.0
	throw_speed = 8
	throw_range = 10
	w_class = ITEM_SIZE_SMALL
	attack_verb = list("hooked up", "cutted down")

	New()
		if(!fishing_line)
			fishing_line = new /obj/item/weapon/fishing_line(src)
			fishing_line.length = 1

/obj/item/weapon/fishing_tackle/update_icon()
	overlays.Cut()
	if(in_process)
		icon_state = "tackle_hand"
		dir = get_dir(src.loc, place.loc)
	else
		if(damaged == 0)
			icon_state = "tackle"
		else
			icon_state = "tackle_damaged"
		if(hook)
			overlays += "tackle_hook"
		if(bait)
			overlays += "tackle_bait"


/obj/item/weapon/fishing_tackle/examine(mob/user as mob)
	..()
	user << SPAN_NOTE("There is...")
	if(hook)
		user << SPAN_NOTE("<B>[hook]</B>.")
	if(fishing_line)
		user << SPAN_NOTE("<B>[fishing_line]</B>.")
	if(bait)
		user << SPAN_NOTE("Bait is <B>[bait]</B>.")

/obj/item/weapon/fishing_tackle/attackby(obj/item/F as obj, mob/user as mob)
	if(istype(F, /obj/item/weapon/hook))
		hook = F
		user.drop_from_inventory(F, src)
		usr << SPAN_NOTE("You attach [F.name] to [src.name].")
		update_icon()

	else if(istype(F, /obj/item/weapon/fishing_line))
		var/obj/item/weapon/fishing_line/f = F // :/
		if(f.length >= 1)
			fishing_line = f
			if(damaged == 1)
				user << SPAN_NOTE("You repair [src].")
				damaged = 0
//			else
//				user << SPAN_NOTE("You replace fishing line on that [src.name].")
			f.length--
			if(!f.length)
				qdel(f)
			update_icon()
	else if(istype(F, /obj/item/weapon/reagent_containers/food/snacks/bug) && hook && !damaged)
		user << SPAN_NOTE("You add [F.name] to [src.name] as bait.")
		src.bait = F
		user.drop_from_inventory(F, src)
		update_icon()


/obj/item/weapon/fishing_tackle/verb/remove_bait()
	set name = "Remove bait"
	set category = "Object"
	bait.loc = get_turf(src)
	bait = null
	update_icon()


/obj/item/weapon/fishing_tackle/verb/remove_hook()
	set name = "Remove hook"
	set category = "Object"
	hook.loc = get_turf(src)
	hook = null
	if(bait)
		bait.loc = get_turf(src)
		bait = null
	update_icon()


/obj/item/weapon/fishing_tackle/verb/disassemble()
	set name = "Disassemble"
	set category = "Object"
	if(in_process)
		usr << SPAN_WARN("You must stop fishing before you disassemble your [src]!")
		return
	if(hook)
		hook.loc = get_turf(src)
		hook = null
	if(bait)
		bait.loc = get_turf(src)
		bait = null
	var/obj/item/weapon/fishing_line/FL = new(get_turf(src))
	FL.length = 1
	usr.drop_from_inventory(src)
	qdel(src)




/obj/item/weapon/fishing_tackle/afterattack(atom/target, mob/user, proximity)
	if(!proximity) return
	if(in_process)
		user << SPAN_WARN("You are already fishing.")
		return
	if(src.damaged == 1)
		user << SPAN_WARN("Fishing tackle is too damaged.")
		return
	if(istype(target,/obj/structure/ice_hole))
		user.visible_message("[user] drops his tackle at [target] and wait for his prey.", "You drop your [src.name] at [target].")
		src.chance = src.chance + src.hook.addChance + src.fishing_line.addChance
		src.place = target
		place.tackles.Add(src)
		place.update_icon()
		processing_objects.Add(src)
		in_process = 1
		update_icon()

/obj/item/weapon/fishing_tackle/proc/ending()
	chance = 1
	if(bait && Catch)
		qdel(bait)
	processing_objects.Remove(src)
	place.tackles.Remove(src)
	place.update_icon()
	in_process = 0
	Catch = null
	update_icon()


/obj/item/weapon/fishing_tackle/attack_self(mob/user as mob)
	if(src.Catch == null && in_process)
		user << SPAN_NOTE("You take off your [src.name].")
		ending()
		return
	else if(Catch && in_process)
		user << SPAN_NOTE("You hook in [src]!")
		if(prob(50))
			new src.Catch(place.loc)
			src.ending()
			user << SPAN_NOTE("You take tackle from water and look on your catch.")



/obj/item/weapon/fishing_tackle/process()
	update_icon()
	place.update_icon()
	var/mob/living/M = loc
	if(Catch == null)
		if(in_range(place, src))
			if(prob(rand(1,chance_bait)))
				if(prob(30) && bait)
					Catch = pick(fishing_fishes)
				else
					Catch = pick(fishing_garbage)
				M.visible_message(SPAN_NOTE("[src] is vibrates and bounces!"), SPAN_NOTE("[src] is vibrates and bounces in your hand!"))
				qdel(bait)
		else
			ending()
			M << SPAN_WARN("Your tackle need to stay with place of fishing.")
			M.visible_message(SPAN_NOTE("[M] takes off his [src]."), SPAN_NOTE("You take off [src.name]."))
		return
	else
		if(prob(20))
			if(prob(10))
				M.visible_message(SPAN_WARN("[M] broke his [src.name]!."), SPAN_NOTE("You broke [src.name]."))
				qdel(hook)
				damaged = 1
				chance = 1
				Catch = null
				ending()
				update_icon()
				return
			qdel(bait)
			ending()
			return
		M << SPAN_NOTE("Still vibrates!")


/obj/structure/ice_hole
	name = "hole"
	desc = "You can see dark water. Sometimes something moving."
	icon = 'icons/obj/snowy_event/fishing.dmi'
	icon_state = "hole"
	anchored = 1
	var/list/tackles = list() //For overlay updating

/obj/structure/ice_hole/update_icon()
	overlays.Cut()
	for(var/obj/O in tackles)
		var/d = get_dir(src.loc, O.loc) //need nums
		overlays += "fishing_line-[d]"

/obj/structure/ice_hole/attackby(obj/item/weapon/W as obj, mob/user as mob)
	//blank space. Just to prevent hit message