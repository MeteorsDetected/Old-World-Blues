//Well. I forgot about smolder stage after all firewood burnt. I add this later
/obj/structure/campfire
	name = "Campfire"
	desc = "Only you, me and that firewood."
	icon = 'icons/obj/snowy_event/snowy_icons.dmi'
	icon_state = "campfire"
	anchored = 1
	var/fire_stage = 0
	var/firewood = 300
	var/tinder = 0
	var/list/listeners = list()


/obj/structure/campfire/update_icon()
	overlays.Cut()
	if(firewood >= 200)
		icon_state = "campfire"
	else if(firewood < 200 && firewood >= 100)
		icon_state = "campfire_burnt"
	else
		icon_state = "campfire_burnt_down"
		overlays += "smolder"
	switch(fire_stage)
		if(1) overlays += "fire_started"
		if(2) overlays += "fire_small"
		if(3) overlays += "fire_almost"
		if(4) overlays += "fire_stable"


/obj/structure/campfire/attackby(obj/item/weapon/T as obj, mob/user as mob)
	if(istype(T, /obj/item/weapon/snowy_woodchunks) || istype(T, /obj/item/stack/material/wood))
		if(istype(T, /obj/item/weapon/snowy_woodchunks))
			firewood = firewood + 300
			qdel(T)

		else if(istype(T, /obj/item/stack/material/wood))
			var/obj/item/stack/material/wood/W = T
			firewood = firewood + 30
			W.amount--
			if(W.amount <= 0)
				qdel(T)

		else if(istype(T, /obj/item/weapon/branches))
			firewood = firewood + 15
			qdel(T)
		update_icon()
		user << SPAN_NOTE("You add some firewood into [src.name].")

	if(istype(T, /obj/item/weapon/paper))
		if(tinder < 5)
			user << SPAN_NOTE("You put a tinder into [src.name].")
			tinder = 1
			qdel(T)

	//very long, i know, sorry
	if(istype(T, /obj/item/weapon/flame) || istype(T, /obj/item/weapon/weldingtool) || istype(T, /obj/item/clothing/mask/smokable/cigarette) || istype(T, /obj/item/device/flashlight/flare))
		if(istype(T, /obj/item/weapon/flame))
			var/obj/item/weapon/flame/F = T
			if(!F.lit)
				return
		else if(istype(T, /obj/item/clothing/mask/smokable/cigarette))
			var/obj/item/clothing/mask/smokable/cigarette/C = T
			if(!C.lit)
				if(fire_stage > 1)
					C.light(SPAN_NOTE("[user] light his [C.name] with fire."))
				return
		else
			var/obj/item/weapon/weldingtool/W = T
			if(!W.welding)
				return

		if(fire_stage == 0)
			fire_stage = 1
			processing_objects.Add(src)
			update_icon()
			set_light(fire_stage*2, 1, "#FF8000")


/obj/structure/campfire/attack_hand(var/mob/user as mob)
	if(user.a_intent == I_HELP && fire_stage < 4 && fire_stage > 0)
		if(fire_stage == 3 && firewood <= 50)
			user << SPAN_WARN("Not enough wood.")
			return
		if(prob(35+(10*tinder)))
			fire_stage++
		user << SPAN_NOTE("You tries to fan fire.")
		update_icon()

	else if(user.a_intent == I_HURT && fire_stage != 0)
		if(prob(80))
			fire_stage--
		update_icon()
		user << SPAN_NOTE("You trying to put out the fire.")

	else if(user.a_intent == I_DISARM && fire_stage == 0 && firewood == 300)
		user << SPAN_NOTE("You take wood chunks back.")
		new /obj/item/weapon/snowy_woodchunks(src.loc)
		qdel(src)


/obj/structure/campfire/process()
	if(firewood > 0)
		if(firewood <= 50 && fire_stage == 4)
			fire_stage = 3
			update_icon()
		if(fire_stage == 1 || fire_stage == 2)
			if(prob(10))
				fire_stage--
				update_icon()
		firewood--
		set_light(fire_stage*2, pick(0.5, 0.6, 0.7, 0.8, 0.9, 1)) //I'm not check it. I test it later and removes if not work
		if(fire_stage > 2)
			for(var/mob/M in listeners)
				if(!(M in hearers(12, src.loc)))
					M << sound(null, channel = 43)
					listeners.Remove(M)
					break
			for(var/mob/M in hearers(12, src.loc))
				if(!(M in listeners))
					M << sound('sound/effects/snowy/flame.ogg', repeat = 1, wait = 0, volume = 60, channel = 43)
					listeners.Add(M)
					break
			if(prob(15))
				playsound(src.loc, 'sound/effects/snap.ogg', 30, rand(-50, 50), 2, 4)
				var/datum/effect/effect/system/steam_spread/F = new /datum/effect/effect/system/steam_spread/spread()
				F.set_up(rand(1, 5), 0, src.loc, /obj/effect/effect/steam/fire_spark)
				F.start()
		var/mob/living/carbon/human/H = locate(/mob/living/carbon/human) in src.loc
		if(H)
			if(H.lying)
				H.apply_damage(20, BURN) //Witches gonna hurt...
			else
				H.apply_damage(10, BURN, pick(BP_R_LEG, BP_L_LEG, BP_L_FOOT, BP_R_FOOT)) //Dont play with fire, kids
	else
		processing_objects.Remove(src)
		fire_stage = 0
		update_icon()
		set_light(fire_stage*2)