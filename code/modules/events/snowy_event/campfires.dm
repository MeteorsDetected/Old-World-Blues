//Maked special for Snowy Event
//TODO-list:
//Add smolder stage
//Add firewood based on list and average burning temperature
//Refactor this to make code looks much better
//Add item burn while they laying on fire


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
	var/obj/structure/cooker/cook_place
	var/burning_temp = 0 //burning temperature. Need for cooking and maybe to heat. Eeeeh. I make firewood types later. Time is near...
	var/firewood_desc = ""
	var/list/cookers = list() //holder for sticks and other
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


/obj/structure/campfire/examine(mob/user as mob)
	..()
	var/T = round( (world.tick_lag*firewood)/60 )
	var/time_left = ""
	if(T > 0)
		time_left = "somewhere about [T] minutes left"
	else
		time_left = "looks like [round(world.tick_lag*firewood)] seconds left"
	user << SPAN_NOTE("You look at campfire and see [time_left] to burn.")


/obj/structure/campfire/attackby(obj/item/weapon/T as obj, mob/user as mob)
	if(istype(T, /obj/item/weapon/snowy_woodchunks) || istype(T, /obj/item/stack/material/wood) || istype(T, /obj/item/weapon/branches))
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
		user.visible_message(
				SPAN_NOTE("[user] added some firewood to [name]."),
				SPAN_NOTE("You add some firewood into [src.name].")
			)

	if(istype(T, /obj/item/weapon/paper) || istype(T, /obj/item/weapon/spacecash))
		if(tinder < 5)
			user << SPAN_NOTE("You put a [T.name] as tinder into [src.name].")
			tinder = tinder + 1
			firewood = firewood + 5
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
	if(istype(T, /obj/item/weapon/holder_stick))
		if(cook_place)
			cook_place.attackby(T, user)
		else
			var/obj/structure/cooker/C = new(src.loc)
			cook_place = C //lets make the ref to our cooker that we create. That cooker will be updated trough campfire
			C.fire = src
			user.drop_from_inventory(T, C)
			C.holders++
			C.update_icon()
			user.visible_message(
				SPAN_NOTE("[user] thrust holder stick beside campfire."),
				SPAN_NOTE("You find suitable place for first holder stick and thrust it in.")
			)
	if(istype(T, /obj/item/weapon/stick) || istype(T, /obj/item/weapon/wgrill) || istype(T, /obj/item/weapon/reagent_containers/glass/beaker/cauldron))
		if(istype(T, /obj/item/weapon/stick))
			var/obj/item/weapon/stick/S = T
			if(S.ingredients.len && !(T in cookers) && S.ingredients.len < 3 && !cook_place) //yeah, only two items can be frying on one stick without holders
				cookers.Add(T)
				user.visible_message(
						SPAN_NOTE("[user] holds them stick under fire to fry something on it."),
						SPAN_NOTE("You holds your stick with food above fire...")
					)
		if(cook_place)
			cook_place.attackby(T, user)


/obj/structure/campfire/attack_hand(var/mob/user as mob)
	user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
	if(user.a_intent == I_HELP && fire_stage == 1)
		if(fire_stage == 3 && firewood <= 50)
			user << SPAN_WARN("Not enough wood.")
			return
		user << SPAN_NOTE("You carefull waves with your hand in attempt to fire it campfire up...")
		if(do_after(user, 30))
			if(fire_stage == 1)
				if(prob(15+(10*tinder))) //tinder is needed to fire up the campfire. But if you really need...
					firingUp()
				else
					user << SPAN_WARN("You still can't see fire. Maybe try again?")
			else if(fire_stage > 1)
				user << SPAN_WARN("Fire is already kindled.")
			else
				user << SPAN_WARN("You need to light it up again.")
		else
			user << SPAN_NOTE("You can't do this while going away.")

	else if(user.a_intent == I_HURT && fire_stage != 0)
		if(prob(80))
			fadingFire()
		update_icon()
		user << SPAN_NOTE("You trying to put out the fire.")

	else if(user.a_intent == I_DISARM && fire_stage == 0 && firewood >= 300)
		user << SPAN_NOTE("You take wood chunks back.")
		new /obj/item/weapon/snowy_woodchunks(user.loc)
		firewood = firewood-300
		if(firewood <= 0)
			qdel(src)


/obj/structure/campfire/process()
	if(firewood > 0 && fire_stage > 0)
		if(burning_temp < fire_stage*80)
			burning_temp = burning_temp + 3
		else if(burning_temp > fire_stage*80)
			burning_temp--

		if(firewood <= 50 && fire_stage == 4)
			fire_stage = 3
			update_icon()

		if(fire_stage == 1)
			if(prob(15))
				fadingFire()
				src.visible_message(SPAN_WARN("Fire weakens..."))

		if(burning_temp >= fire_stage*80 && fire_stage != 4 && firewood > 200)
			if(prob(30+(fire_stage*20)))
				firingUp()
				src.visible_message(SPAN_NOTE("Fire is flaming!"))

		firewood = firewood - round((1*(fire_stage/2))) //firewood decrease //Yeah, on first stage it will be 0. On this stage you need to fan fire
		set_light(fire_stage*2, pick(0.5, 0.6, 0.7, 0.8, 0.9, 1))

		cookingUpdate()

		if(fire_stage > 2)
			soundAndEffects()
		var/mob/living/carbon/human/H = locate(/mob/living/carbon/human) in src.loc

		if(H)
			if(H.lying)
				H.apply_damage(rand(5, 20)*fire_stage, BURN) //Witches gonna hurt...
			else
				H.apply_damage(rand(1, 10)*fire_stage, BURN, pick(BP_R_LEG, BP_L_LEG, BP_L_FOOT, BP_R_FOOT)) //Dont play with fire, kids
		heating()
	else
		processing_objects.Remove(src)
		fire_stage = 0
		burning_temp = 0
		update_icon()
		set_light(fire_stage*2)
		for(var/mob/M in listeners)
			M << sound(null, channel = 43)
			listeners.Remove(M)


/obj/structure/campfire/proc/fadingFire()
	fire_stage--
	burning_temp = burning_temp - 40 //To prevent fast flaming. Need to change all of that crap. Oh crap.
	update_icon()


/obj/structure/campfire/proc/firingUp()
	fire_stage++
	update_icon()


/obj/structure/campfire/proc/soundAndEffects()
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


/obj/structure/campfire/proc/cookingUpdate()
	for(var/obj/item/weapon/stick/C in cookers)
		if(in_range(src, C))
			for(var/obj/item/weapon/reagent_containers/food/snacks/ingredient/I in C.ingredients)
				I.preparing(src)
		else
			cookers.Remove(C)
			src.visible_message(SPAN_WARN("[C.name] must be holded above campfire!"))

	if(cook_place)
		for(var/obj/item/weapon/stick/S in cook_place.cookables)
			if(S.ingredients.len > 0)
				for(var/obj/item/weapon/reagent_containers/food/snacks/ingredient/I in S.ingredients)
					I.preparing(src)
		if(cook_place.cauldron)
			cook_place.cauldron.boil()
		cook_place.updateUsrDialog()


//Ye-e-ea-ah... Copypasted from space heater. I know, it's very-very-very bad, but... This is temporary method until i study atmos
//Sorry. Another shame on me
/obj/structure/campfire/proc/heating()
	var/heating_power = burning_temp*100
	var/set_temperature = T0C + (5 + (10*fire_stage))
	var/datum/gas_mixture/env = loc.return_air()
	if(env && abs(env.temperature - set_temperature) > 0.1)
		var/transfer_moles = 0.25 * env.total_moles
		var/datum/gas_mixture/removed = env.remove(transfer_moles)

		if(removed)
			var/heat_transfer = removed.get_thermal_energy_change(set_temperature)
			if(heat_transfer > 0)	//heating air
				heat_transfer = min( heat_transfer , heating_power ) //limit by the power rating of the heater

				removed.add_thermal_energy(heat_transfer)
			else	//cooling air
				heat_transfer = abs(heat_transfer)

				//Assume the heat is being pumped into the hull which is fixed at 20 C
				var/cop = removed.temperature/T20C	//coefficient of performance from thermodynamics -> power used = heat_transfer/cop
				heat_transfer = min(heat_transfer, cop * heating_power)	//limit heat transfer by available power

				heat_transfer = removed.add_thermal_energy(-heat_transfer)	//get the actual heat transfer

		env.merge(removed)

	for(var/mob/living/L in range(fire_stage, src)) //Fire stage as range. Why not?
		if(istype(L, /mob/living/carbon/human))
			var/mob/living/carbon/human/H = L
			if(H.bodytemperature <= 320)
				H.bodytemperature = H.bodytemperature + fire_stage