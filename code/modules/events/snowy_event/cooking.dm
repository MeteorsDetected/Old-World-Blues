//Campfire cooking. This stuff is cold, rough, wet and WIP
//Builded around vaporization of reagents. Maybe this can be interesting

//TODO-list:
//Rework some procs
//Refactor all this stuff to something better
//Make processor for food and items that can spoil or have temperature
//Slightly change cauldron-beakers interaction and add pour_out_from_target proc with grab intent to glasses. This make this more human-like
//Drink some coffee
//Make all of this not boring and not too hard or realistic



/obj/structure/cooker
	name = "Cooking place"
	desc = "Used to cook something. Better than nothing."
	icon = 'icons/obj/snowy_event/snowy_icons.dmi'
	icon_state = ""
	anchored = 1
	var/cooking_state = "default" //default - two holders that can cook one stick with something// brazier - four holders. Can cook four sticks with food
								//grill - four holders and grill on it. Can fry something with high quality
								//cauldron - two holders with stick and cauldron on it. Can boil something
								//Kinda useless now. I be all of it better later. Sorry
	layer = 4
	var/holders = 0
	var/sticks = 0
	var/obj/item/weapon/wgrill/grill
	var/obj/item/weapon/reagent_containers/glass/beaker/cauldron/cauldron
	var/obj/structure/campfire/fire
	var/list/cookables = list()



/obj/structure/cooker/update_icon()
	overlays.Cut()
	if(holders)
		for(var/i = 1, i<=holders, i++)
			overlays += "holder-[i]"
	if(sticks >= 1)
		overlays += "holder-stick_upper"
	if(cookables.len > 0 && sticks == 1)
		overlays += "holder-stick_upper"
		overlays += "upper_stick_food"
	if(sticks >= 2)
		overlays += "holder-stick_down"
	if(holders == 4 && sticks >= 2)
		var/pos = 1
		for(var/obj/item/weapon/stick/S in cookables)
			var/image/K = image(icon, "stick_to_fry")
			K.pixel_x = K.pixel_x + (pos*4)
			overlays += K
			pos++
	if(grill)
		overlays += "holder-grill"
	if(cookables.len > 0 && fire.burning_temp >= 100)
		overlays += "cooking_steam"
	if(cauldron)
		overlays += "cauldron-holder"
		if(cauldron.snowed)
			overlays += "cauldron-snow"
		else if(cauldron.reagents.total_volume >= 100)
			overlays += "cauldron-something"
		if(cauldron.temperature >= 100)
			if(cauldron.snowed < 3)
				overlays += "cauldron-boiling"
			var/image/SO = image(icon, "cooking_steam")
			SO.pixel_y = SO.pixel_y + 8
			overlays += SO


/obj/structure/cooker/examine(mob/user as mob)
	..()
	if(cauldron)
		user << SPAN_NOTE("[cauldron.name] have [cauldron.reagents.total_volume] amount of something.")


//That sticks - holders stuff is shit. I'm must been drunk when do hellish hell like this
//Need to rework this to something better asap when i got more time. Shame on me
/obj/structure/cooker/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(istype(W, /obj/item/weapon/holder_stick))
		if(holders < 4)
			holders++
			user.drop_from_inventory(W, src)
			user << SPAN_NOTE("You thrust in [W.name] at suitable place.")
		else
			user << SPAN_WARN("Too much holders.")
		update_icon()
	if(istype(W, /obj/item/weapon/stick) && !cauldron)
		var/obj/item/weapon/stick/S = W
		if(sticks < 2 && holders > 1 && cookables.len == 0) //for lone stick
			if(S.ingredients.len == 0)
				sticks++
			else if(S.ingredients.len && sticks == 0 && holders == 2)
				cookables.Add(W)
				sticks++
			else
				return
			user.drop_from_inventory(W, src)
			user << SPAN_NOTE("You place [W.name] on holders.")

		else if(S.ingredients.len > 0 && holders == 4 && sticks >= 2 && cookables.len < 4) // for kebabs
			cookables.Add(W)
			user.drop_from_inventory(W, src)
			user << SPAN_NOTE("You place [W.name] on sticks under fire.")
			sticks++
		else
			user << SPAN_WARN("Something is missing")
		update_icon()
	if(istype(W, /obj/item/weapon/wgrill) && holders == 4 && sticks == 2 && cookables.len == 0 && !grill)
		grill = W
		user.drop_from_inventory(W, src)
		user << SPAN_NOTE("You careful place grill on holders.")
		update_icon()
	if(istype(W, /obj/item/weapon/reagent_containers/glass/beaker/cauldron) && sticks == 1 && holders > 1 && !grill && cookables.len == 0 && !cauldron)
		cauldron = W
		cauldron.cooker = src
		user.drop_from_inventory(W, src)
		user << SPAN_NOTE("You hang [W.name] on stick.")
		update_icon()
	if(istype(W, /obj/item/weapon/reagent_containers) && cauldron)
		if(W != cauldron)
			cauldron.attackby(W, user)


/obj/structure/cooker/attack_hand(var/mob/user as mob)
	if(user.a_intent == I_GRAB)
		if(cauldron)
			var/obj/item/weapon/reagent_containers/glass/beaker/cauldron/C = locate(/obj/item/weapon/reagent_containers/glass/beaker/cauldron) in src
			C.loc = user.loc
			user.put_in_hands(C)
			cauldron.cooker = null
			processing_objects.Add(cauldron)
			cauldron = null
			user << SPAN_NOTE("You take [C.name] from stick.")
			update_icon()
			C.update_icon()
			return
		if(grill && cookables.len == 0)
			var/obj/item/weapon/wgrill/G = locate(/obj/item/weapon/wgrill) in src
			G.loc = user.loc
			user.put_in_hands(G)
			grill = null
			cookables.Remove(G)
			user << SPAN_NOTE("You take off grill from holders.")
			update_icon()
			return
		if(sticks && cookables.len < 2)
			for(var/obj/item/weapon/stick/S in src)
				S.loc = user.loc
				sticks--
				if(S in cookables)
					cookables.Remove(S)
			user << SPAN_NOTE("You take all sticks back.")
			update_icon()
			return
		if(holders && !sticks && cookables.len == 0)
			for(var/obj/item/weapon/holder_stick/H in src)
				H.loc = user.loc
				holders--
			user << SPAN_NOTE("You take all holders back.")
			fire.cook_place = null
			qdel(src)
			return
	else
		if(cookables.len)
			user.set_machine(src)
			var/dat = "<body bgcolor='#4d2800'><br>"
			for(var/obj/item/weapon/stick/S in cookables)
				dat += "[S.name] with [S.ingredients.len] ingredients "
				dat += "<A href='?src=\ref[src];stick=\ref[S];action=take'>Take off</A><br>"
				for(var/obj/item/weapon/reagent_containers/food/snacks/ingredient/I in S.ingredients)
					dat += "<center>[I.name] | [I.properties["status"]] | [I.properties["temp_desc"]]</center>"
				dat += "<br>"
			dat += "</body>"
			user << browse(dat, "window=cooker1;size=300x[100*cookables.len]")
			onclose(user, "cooker1")
		else if(cauldron)
			if(cauldron.ingredients.len)
				user.set_machine(src)
				var/dat = "<body bgcolor='#4d2800'><br>"
				dat += "<center><font size='10'>[cauldron.name]</font></center><br>"
				dat += "<center>[cauldron.reagents.total_volume] of liquid in cauldron left</center><br>"
				for(var/obj/item/weapon/reagent_containers/food/snacks/ingredient/I in cauldron.ingredients)
					dat += "<center>[I.name] | [I.properties["status"]] | [I.properties["temp_desc"]] | "
					dat += "<A href='?src=\ref[src];food=\ref[I];action=get'>Extract</A>"
					dat += "</center>"
					dat += "<br>"
				dat += "</body>"
				user << browse(dat, "window=cauldron;size=300x250")
				onclose(user, "cauldron")



/obj/structure/cooker/Topic(href, href_list)
	usr.set_machine(src)
	var/obj/item/weapon/stick/S = locate(href_list["stick"]) in src
	var/obj/item/weapon/reagent_containers/food/snacks/ingredient/F = locate(href_list["food"]) in src.cauldron

	switch(href_list["action"])
		if("take") //for skewers
			usr << SPAN_NOTE("You take [S.name] back.")
			S.loc = usr.loc
			usr.put_in_hands(S)
			cookables.Remove(S)
			sticks--
			world << cookables.len
			if(cookables.len == 0)
				usr.unset_machine()
				usr << browse(null, "window=cooker1")
		if("get") //for cauldron's ingredients
			cauldron.ingredients.Remove(F)
			F.loc = usr.loc
			usr.put_in_hands(F)
			if(!cauldron.ingredients.len)
				usr.unset_machine()
				usr << browse(null, "window=cauldron")
	update_icon()
	updateUsrDialog()




/obj/item/weapon/reagent_containers/glass/beaker/cauldron
	name = "cauldron"
	desc = "Not so bad cauldron. Nice to boil something."
	icon = 'icons/obj/snowy_event/snowy_icons.dmi'
	icon_state = "cauldron"
	item_state = ""
	center_of_mass = list("x"=16, "y"=10)
	w_class = ITEM_SIZE_NORMAL
	matter = list(MATERIAL_STEEL = 4000)
	volume = 300
	amount_per_transfer_from_this = 50
	possible_transfer_amounts = list(5,10,15,25,30,60,100)
	flags = OPENCONTAINER
	var/temperature = 10
	var/snowed = 0
	var/snow_melt_volume = 100 //how many water it can give
	var/obj/structure/cooker/cooker
	var/cooking_effects = 0 //0 is no effects. 1 - is frying, 2 - is boiling. I can use defines but meeeeh. Later
	var/list/ingredients = list()
	can_be_placed_into = list(
									/obj/structure/table,
									/obj/structure/closet,
									/obj/structure/sink,
									/obj/item/storage,
									/obj/machinery/disposal,
									/mob/living/simple_animal/cow)


/obj/item/weapon/reagent_containers/glass/beaker/cauldron/process()
	if(temperature > 10)
		temperature--
	else
		processing_objects.Remove(src)


/obj/item/weapon/reagent_containers/glass/beaker/cauldron/attack_hand(var/mob/user as mob)
	if(user.a_intent == I_GRAB)
		if(ingredients.len)
			var/obj/O = locate(/obj/item/weapon/reagent_containers/food/snacks/ingredient) in src.ingredients
			user << SPAN_NOTE("You take [O.name] from [src].")
			O.loc = user.loc
			ingredients.Remove(O)
			user.put_in_hands(O)
	else
		..()


/obj/item/weapon/reagent_containers/glass/beaker/cauldron/attack_self(var/mob/user as mob)
	return


/obj/item/weapon/reagent_containers/glass/beaker/cauldron/afterattack(atom/target, mob/user, proximity)
	if(!proximity) return
//	if(temperature >= 100)
	standard_splash_mob(user, target)
	standard_dispenser_refill(user, target)


/obj/item/weapon/reagent_containers/glass/beaker/cauldron/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(istype(W, /obj/item/weapon/snow))
		if(snowed <3 && reagents.total_volume+100 <= volume)
			snowed++
			user << SPAN_NOTE("You drop some snow into the [src.name].")
			qdel(W)
		else
			user << SPAN_WARN("[src.name] is full.")
	if(istype(W, /obj/item/weapon/reagent_containers/food/snacks/ingredient))
		if(ingredients.len < 10)
			ingredients.Add(W)
			user.drop_from_inventory(W, src)
			user << SPAN_NOTE("You place [W.name] into [src].")
		else
			user << SPAN_WARN("[src.name] is full.")
			return
	if(istype(W, /obj/item/weapon/reagent_containers/glass))
		var/obj/item/weapon/reagent_containers/glass/C = W
		if(C.reagents.total_volume && istype(C, /obj/item/weapon/reagent_containers/glass/beaker/cauldron))
			C.standard_pour_into(user, src)
		else
			src.standard_pour_into(user, C)



//Maybe do it trough direct fire - better idea
/obj/item/weapon/reagent_containers/glass/beaker/cauldron/proc/boil()
	if(cooker && cooker.fire && cooker.fire.fire_stage > 0)
		if(temperature <= cooker.fire.burning_temp)
			temperature = temperature + 2
		if(temperature > cooker.fire.burning_temp)
			temperature--
		if(temperature >= 10)
			if(snowed)
				snow_melt_volume = snow_melt_volume - 3
				src.reagents.add_reagent("water", 3)
				if(snow_melt_volume <= 0)
					snowed--
					update_icon()

		if(temperature >= 100)
			if(prob(50)) //I hope it will not lead to ear fuck. Sorry. I make my own tiny sound system later
				playsound(cooker.loc, 'sound/effects/bubbles2.ogg', 40, rand(-50, 50))
			var/datum/reagent/MR = reagents.get_master_reagent()
			if(prob(5+(5*cooker.fire.fire_stage)) && MR)
				MR.remove_self(1) //master reagent vaporization
			for(var/obj/item/weapon/reagent_containers/food/snacks/ingredient/I in ingredients)
				I.preparing(cooker.fire, 4, 1)
				if(I.properties["fry_time"] <= I.properties["burnt_treshhold"])
					for(var/datum/reagent/R in I.reagents.reagent_list)
						if(reagents.total_volume+1 > volume)
							MR.remove_self(1)
							if(MR.volume <= 0)
								MR = reagents.get_master_reagent()
						src.reagents.add_reagent(R.id, 1)
						R.remove_self(1)
				if(I.reagents.total_volume == 0)
					ingredients.Remove(I)
					qdel(I)
			if(!ingredients.len)
				if(usr)
					usr.unset_machine()
					usr << browse(null, "window=cauldron")
	update_icon()
	cooker.update_icon()


/obj/item/weapon/reagent_containers/glass/beaker/cauldron/update_icon()
	overlays.Cut()
	if(reagents.total_volume >= 100)
		overlays += "cauldron-something"
	if(snowed)
		overlays += "cauldron-snow"




/obj/item/weapon/reagent_containers/food/snacks/ingredient
	name = "ingredient"
	icon = 'icons/obj/snowy_event/snowy_icons.dmi'
	icon_state = ""
	bitesize = 1
	bitecount = 0
	trash = null
	slice_path
	slices_num
	dried_type = null
	dry = 0
	nutriment_amt = 0
	var/sliced = 0 //I know but that slicing is different
	var/obj/item/weapon/reagent_containers/food/snacks/ingredient/inside
	var/feel_desc = "resin-like shroom"
	var/standard_temp = 10
	var/spoil_time = 400 //-1 every ~10 ticks if not freezed

	var/list/inside_properties = list(current_temp = 10, temp_desc = "cold")
	var/list/properties = list(current_temp = 10,
								need_temp = 140,
								fry_time = 60,
								prepare_line = 10,
								burnt_treshhold = -10,
								status = "raw",
								temp_desc = "cold")
	var/reagents_to_vaporize = list() //place here id's
	var/reagents_to_change = list() //place here that scheme 'reagent1's id = reagent2's id'

	New()
		..()
		updateDescAndIcon()
		processing_objects.Add(src) //I know. There we need separate process for ingredients. I'm working on it...


/obj/item/weapon/reagent_containers/food/snacks/ingredient/proc/updateDescAndIcon()
	if(properties["fry_time"] <= properties["prepare_line"])
		properties["status"] = "prepared"
	if(properties["fry_time"] < 0 && properties["fry_time"] > properties["burnt_treshhold"])
		properties["status"] = "crispy"
	if(properties["fry_time"] < properties["burnt_treshhold"])
		properties["status"] = "burnt and rough"
	var/list/P = inside_properties
	for(var/i = 1, i<=2, i++)
		if(i == 2)
			P = properties
		if(P["current_temp"] >= 0 && P["current_temp"] <= 15)
			P["temp_desc"] = "cold"
		else if(P["current_temp"] >= 16 && P["current_temp"] <= 40)
			P["temp_desc"] = "warm"
		else if(P["current_temp"] >= 41 && P["current_temp"] <= 80)
			P["temp_desc"] = "hot"
		else if(P["current_temp"] >= 81)
			P["temp_desc"] = "very hot"
		else if(P["current_temp"] < 0)
			P["temp_desc"] = "freezed"

	update_icon()


/obj/item/weapon/reagent_containers/food/snacks/ingredient/process() //I hope this not hang something
	if(inside_properties["current_temp"] > standard_temp || properties["current_temp"] > standard_temp)
		if(inside_properties["current_temp"] > standard_temp)
			inside_properties["current_temp"] = inside_properties["current_temp"]--
		if(properties["current_temp"] > standard_temp)
			properties["current_temp"] = properties["current_temp"] - 2



//calls each iteration
/obj/item/weapon/reagent_containers/food/snacks/ingredient/proc/vaporization()
	for(var/datum/reagent/R in reagents.reagent_list)
		if(R.id in reagents_to_vaporize)
			vaporize_reagent(R)
		if(R.id in reagents_to_change)
			replace_reagent(R, reagents_to_change[R.id])
	return


/obj/item/weapon/reagent_containers/food/snacks/ingredient/proc/vaporize_reagent(var/datum/reagent/R)
	if(R.volume > 0)
		if(prob(50))
			R.remove_self(1)


/obj/item/weapon/reagent_containers/food/snacks/ingredient/proc/replace_reagent(var/datum/reagent/target, var/newReagent)
	if(target.volume > 0)
		reagents.add_reagent(newReagent, 1)
		target.remove_self(1)


/obj/item/weapon/reagent_containers/food/snacks/ingredient/update_icon()
	icon = initial(icon)
	switch(properties["status"])
		if("prepared") icon += rgb(96, 42, 18)
		if("crispy") icon += rgb(73, 36, 5)
		if("burnt and rough") icon += rgb(11, 6, 1)
	if(properties["temp_desc"] == "freezed")
		icon += rgb(102, 173, 162)


//calls every tick at campfire or cauldron
/obj/item/weapon/reagent_containers/food/snacks/ingredient/proc/preparing(var/obj/structure/campfire/F as obj, var/force_speed = 0, var/boil = 0)
	if(F.fire_stage > 0)
		var/surplus = F.burning_temp - properties["current_temp"]
		if(force_speed)
			surplus = force_speed
		else
			surplus = round((surplus/10))
		if(properties["current_temp"] < F.burning_temp)
			properties["current_temp"] = properties["current_temp"] + surplus
			if(properties["current_temp"] > F.burning_temp)
				properties["current_temp"] = F.burning_temp
		if(properties["current_temp"] >= properties["need_temp"])
			inside_properties["current_temp"] = inside_properties["current_temp"] + 2
			properties["fry_time"] = properties["fry_time"] - rand(1, F.fire_stage)
			if(!boil)
				vaporization()

		/*if(inside_properties["current_temp"] < F.burning_temp)
			inside_properties["current_temp"] = inside_properties["current_temp"] + 2
			if(inside_properties["current_temp"] > F.burning_temp)
				inside_properties["current_temp"] = F.burning_temp
		if(inside_properties["current_temp"] >= inside_properties["need_temp"])
			inside_properties["fry_time"] = inside_properties["fry_time"] - 1 //insides prepares slowly //I cut it later(old and harsh mechanics)
			*/
		updateDescAndIcon()


/obj/item/weapon/reagent_containers/food/snacks/ingredient/On_Consume(var/mob/M)
	M << SPAN_NOTE("When bite you feel [properties["status"]] and [properties["temp_desc"]] [feel_desc] with [inside_properties["temp_desc"]] insides.")
	..()



/obj/item/weapon/reagent_containers/food/snacks/ingredient/testos
	icon_state = "dustbomb"
//	nutriment_amt = 1
	reagents_to_vaporize = list("water")
	reagents_to_change = list("honey" = "tramadol")

	New()
		..()
		reagents.add_reagent("honey", 5)
		reagents.add_reagent("ethanol", 5)
		bitesize = 5