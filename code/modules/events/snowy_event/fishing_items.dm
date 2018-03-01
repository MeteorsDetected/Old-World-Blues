//Fishing and fishing items here
//For fishes look for fishing_fishes.dm
//Each human of that planet(Earth) can use and change this code
//Made by Macleod962
//version 0.1

//It's me, Macleod962 one year ago:
//Holy crab. This file is full of shit. I work in gasmask. If you dont have one, RUN
//Really, tons of shitcode. I rework it slightly now

//TODO-list:
//Absolutly rework all fishing


var/list/fishing_fishes = list(		/obj/item/weapon/reagent_containers/food/snacks/ingredient/fish/space_dolphin,
									/obj/item/weapon/reagent_containers/food/snacks/ingredient/fish/space_shellfish,
									/obj/item/weapon/reagent_containers/food/snacks/ingredient/fish/space_torped_shark,
									/obj/item/weapon/reagent_containers/food/snacks/ingredient/fish/space_catfish,
									/obj/item/weapon/reagent_containers/food/snacks/ingredient/fish/iced_carp,
									/obj/item/weapon/reagent_containers/food/snacks/ingredient/fish/bloodshell
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
	attack_verb = list("hooked", "cutted")


/obj/item/weapon/hook/boned
	icon_state = "bone_hook"


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
	attack_verb = list("whiped", "slapped")


/obj/item/weapon/fishing_line/examine(mob/user as mob)
	..()
	user << SPAN_NOTE("[src.length] of fishing line left.")


/obj/item/weapon/fishing_line/attack_self(mob/user as mob)
	if(src.length >= 1)
		src.length -= 1
		user << SPAN_NOTE("You make the fishing tackle.")
		var/turf/T = get_turf(src)
		var/obj/item/weapon/fishing_tackle/ft = new(T)
		ft.fishing_line = src
		ft.update_icon()
		if(src.length == 0)
			qdel(src)
	else
		user << SPAN_WARN("Not enough fishing line lenght.")


/obj/item/weapon/fishing_tackle
	desc = "Fishing tackle."
	name = "fishing tackle"
	icon = 'icons/obj/snowy_event/fishing.dmi'
	icon_state = "tackle"
	force = 3.0
	throwforce = 6.0
	throw_speed = 8
	throw_range = 10
	w_class = ITEM_SIZE_SMALL
	attack_verb = list("hooked up", "cutted down")

	var/obj/item/weapon/hook/hook
	var/obj/item/weapon/fishing_line/fishing_line
	var/obj/item/weapon/reagent_containers/food/snacks/bug/bait
	var/damaged = 0
	var/chance = 1 // Chance of a fish // Big fish = -60 of chance/ Rare fish = -90 of chance/ Legend fish = -160 of chance
	var/chance_bait = 5 // basic chance to catch something. From 1 to 5 // Be patient.
	var/obj/structure/ice_hole/place
	var/obj/item/Catch
	var/in_process = 0


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
		if(!damaged)
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
		user << SPAN_NOTE("You attach [F.name] to [src.name].")
		update_icon()

	else if(istype(F, /obj/item/weapon/fishing_line))
		var/obj/item/weapon/fishing_line/f = F // :/
		if(f.length >= 1)
			fishing_line = f
			if(damaged == 1)
				user << SPAN_NOTE("You repair [src].")
				damaged = 0
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
	if(in_process)
		usr << SPAN_WARN("You must stop fishing before you disassemble your [src]!")
		return
	if(bait)
		bait.loc = get_turf(src)
		bait = null
		update_icon()


/obj/item/weapon/fishing_tackle/verb/remove_hook()
	set name = "Remove hook"
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
	if(src.damaged)
		user << SPAN_WARN("Fishing tackle is too damaged.")
		return
	if(istype(target,/obj/structure/ice_hole))
		var/obj/structure/ice_hole/H = target
		if(!H.freezing_stage)
			if(hook)
				user.visible_message(SPAN_NOTE("[user] drops his tackle at [target] and wait for his prey."), SPAN_NOTE("You drop your [src.name] at [target]."))
				src.place = target
				place.tackles.Add(src)
				place.update_icon()
				processing_objects.Add(src)
				in_process = 1
				update_icon()
			else
				user << SPAN_WARN("You can't fishing without hook!")
		else
			user << SPAN_WARN("This [target.name] is freezed. You need something sharp to crack this ice.")


/obj/item/weapon/fishing_tackle/proc/ending()
	chance = 5
	if(bait && Catch)
		if(prob(50))
			qdel(bait)
			bait = null
	processing_objects.Remove(src)
	place.tackles.Remove(src)
	place.update_icon()
	in_process = 0
	Catch = null
	update_icon()


/obj/item/weapon/fishing_tackle/attack_self(mob/user as mob)
	if(!src.Catch && in_process)
		user << SPAN_NOTE("You take off your [src.name].")
		ending()
		return
	else if(Catch && in_process)
		user.visible_message(SPAN_NOTE("[user] hooks in the fish!"), SPAN_NOTE("You hook in [src]!"))
		if(prob(50))
			new Catch(place.loc)
			src.ending()
			user << SPAN_NOTE("You take tackle from water and look on your catch.")



/obj/item/weapon/fishing_tackle/process()
	update_icon()
	place.update_icon()
	var/mob/living/M = loc
	if(Catch == null)
		if(in_range(place, src))
			if(prob(rand(1,chance_bait)))
				if(bait)
					for(var/k in bait.baiting_fishes)
						if(prob(bait.baiting_fishes[k]))
							Catch = k
						else
							if(prob(25))
								Catch = /obj/item/weapon/kelpedloot
				else
					if(prob(35))
						Catch = /obj/item/weapon/kelpedloot
				M.visible_message(SPAN_NOTE("[src] is vibrates and bounces!"), SPAN_NOTE("[src] is vibrates and bounces in your hand!"))
				qdel(bait)
		else
			ending()
			M << SPAN_WARN("Your tackle need to stay with place of fishing.")
			M.visible_message(SPAN_NOTE("[M] takes off his [src]."), SPAN_NOTE("You take off [src.name]."))
		return
	else
		if(prob(10))
			M.visible_message(SPAN_WARN("[M] broke his [src.name]!."), SPAN_NOTE("You broke [src.name]."))
			qdel(hook)
			hook = null
			if(bait)
				qdel(bait)
				bait = null
			damaged = 1
			chance = 1
			Catch = null
			ending()
			update_icon()
			return
		M << SPAN_NOTE("Still vibrates!")


/obj/structure/ice_hole
	name = "hole"
	desc = "You can see dark water. Sometimes something moving."
	icon = 'icons/obj/snowy_event/fishing.dmi'
	icon_state = "hole"
	anchored = 1
	var/freezing_stage = 2
	var/last_update_time = 0
	var/list/tackles = list() //For overlay updating

	New()
		processing_objects.Add(src)
		update_icon()


/obj/structure/ice_hole/process()
	if(world.time - last_update_time > 200)
		last_update_time = world.time
		if(prob(30))
			if(!tackles.len)
				if(prob(10))
					freezing_stage++
					update_icon()
		if(freezing_stage == 4)
			processing_objects.Remove(src)
			qdel(src)


/obj/structure/ice_hole/update_icon()
	overlays.Cut()
	for(var/obj/O in tackles)
		var/d = get_dir(src.loc, O.loc) //need nums
		overlays += "fishing_line-[d]"
	if(!tackles.len)
		if(freezing_stage)
			overlays += "hole_freeze-[freezing_stage]"


/obj/structure/ice_hole/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(W.sharp && freezing_stage)
		freezing_stage--
		user << SPAN_NOTE("You cracks trough ice with [W.name].")
		update_icon()


/obj/item/weapon/kelpedloot
	name = "Bunch of kelps"
	desc = "There can be something interesting under layer of kelps. But be careful..."
	icon = 'icons/obj/snowy_event/fishing.dmi'
	icon_state = "kelped"


/obj/item/weapon/kelpedloot/attack_self(mob/user as mob)
	if(prob(5))
		user << SPAN_WARN("You found nothing! So sad.")
		qdel(src)
	var/list/pos_loot = list()
	if(prob(50))
		pos_loot = typesof(/obj/item/weapon)
		pos_loot.Remove(/obj/item/weapon)
		pos_loot.Remove(/obj/item/weapon/kelpedloot)
	else
		pos_loot = typesof(/obj/item/device)
		pos_loot.Remove(/obj/item/device)
	if(pos_loot.len)
		var/loot = pick(pos_loot)
		new loot(user.loc)
		user << SPAN_NOTE("You shake the kelps and something drops on the floor!")
		qdel(src)
	else
		user << SPAN_WARN("There's nothing.")
		qdel(src)