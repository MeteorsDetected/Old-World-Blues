//Snowy event. WIP

//Cant find flora. So i make it. Sorry
/obj/structure/flora
	var/loot_left = 3
	var/loot_chance = 35
	var/list/loot_list = list(/obj/item/weapon/reagent_containers/food/snacks/bug, /obj/item/weapon/spider_silk)

/obj/structure/flora/attack_hand(var/mob/user as mob)
	if(user.a_intent == I_DISARM)
		if(loot_left)
			if(prob(loot_chance))
				user << SPAN_NOTE("You found something.")
				var/loot =  pick(loot_list)
				new loot(user.loc)
				loot_left--
			else
				user << SPAN_WARN("You find nothing.")
			loot_left--
		else
			user << SPAN_WARN("You check all possible places, but nothing.")
		return


/obj/structure/flora/snowytree
	name = "tree"
	desc = "Just old trunk."
	icon = 'icons/obj/snowy_icons.dmi'

	icon_state = "old_wood"
	anchored = 1
	density = 1
	pixel_x = 0 //use -16 for big sprites like at old trees
	layer = 9
	var/max_health = 20
	var/tree_health = 20
	var/wood_amount = 1 //how many logs will be spawned. 1 log - 3 chunks. 1 chunk - 10 planks
	var/toughness = 1
	var/branch_factor = 1 //branches per log and height. Branches total = branch_factor*1 +  branch_factor*2 + branch_factor*3 //numbers is wood_amount
	// type of object = cut_factor(damage per hit)
	var/list/can_cut = list(/obj/item/weapon/material/hatchet = 4,
							/obj/item/weapon/material/twohanded/fireaxe = 8,
							/obj/item/weapon/material/sword = 4,
							/obj/item/weapon/melee/energy/axe = 15,
							/obj/item/weapon/melee/energy/sword = 10,
							)

	New()
		icon_state = "old_wood[rand(1, 3)]"


//You can do very-very-very big trees, but don't forget about cutted overlays and make another object
/obj/structure/flora/snowytree/big
	name = "tree"
	desc = "Just old trunk."
	icon = 'icons/obj/snowy_trees_big.dmi'
	icon_state = "tree_1"
	pixel_x = -16
	max_health = 35
	tree_health = 35
	wood_amount = 2
	toughness = 1
	branch_factor = 2

	New()
		icon_state = "tree_[rand(1, 3)]"


/obj/structure/flora/snowytree/big/another
	icon_state = "tree_3"
	pixel_x = -16
	max_health = 25
	tree_health = 25
	wood_amount = 2
	toughness = 1
	branch_factor = 3

	New()
		icon_state = "tree_[rand(3, 6)]"


/obj/structure/flora/snowytree/high
	name = "tree"
	desc = "Just old trunk."
	icon = 'icons/obj/snowy_trees_high.dmi'
	icon_state = "pine_1"
	pixel_x = -16
	max_health = 40
	tree_health = 40
	wood_amount = 3
	toughness = 1
	branch_factor = 3


	New()
		icon_state = "pine_[rand(1, 3)]"



/obj/structure/flora/snowytree/update_icon()
	overlays.Cut()
	if(tree_health <= max_health/2)
		overlays += "cutted-half"
	else if(tree_health <= max_health/4)
		overlays += "cutted-almost"
	else if(max_health != tree_health)
		overlays += "cutted-few"


/obj/structure/flora/snowytree/attackby(obj/item/weapon/T as obj, mob/user as mob)
	user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN) //To prevent extra fast lumberJERKing
	if(!T.sharp && !istype(T, /obj/item/weapon/pickaxe))
		return

	var/cut_factor = 1
	if(T.type in can_cut)
		cut_factor = can_cut[T.type]
	else
		if(istype(T, /obj/item/weapon/material/hatchet))
			cut_factor = 2
		else if(istype(T, /obj/item/weapon/pickaxe))
			cut_factor = 3
		else if(istype(T, /obj/item/weapon/melee/energy))
			cut_factor = 8
	cut_factor = cut_factor-toughness

	if(cut_factor <= 0)
		user << SPAN_WARN("This [src.name] is too tough. Your [T.name] can't cut trough!")
		return
	if((tree_health - cut_factor) <= 0)
		tree_health = 0
	else
		tree_health = tree_health - cut_factor
		var/datum/effect/effect/system/steam_spread/F = new /datum/effect/effect/system/steam_spread/spread()
		F.set_up(4, 0, src.loc, /obj/effect/effect/steam/flinders)
		F.start()
		playsound(src.loc, 'sound/effects/woodhit.ogg', 60, rand(-50, 50), 8, 6)
		user << SPAN_NOTE("You aim a blow and hit that [src.name].")
		update_icon()

	if(tree_health <= 0)
		src.visible_message(SPAN_WARN("<b>[src.name] falling down!</b>"))
		playsound(src.loc, 'sound/effects/snowy/falling_tree.ogg', 45, rand(-90, 90), 36, 12)
		var/d = pick(alldirs)
		var/t = get_step(src, d)
		for(var/i = 1, i<=wood_amount, i++) //In the memory of Jarlo, my old partner who makes tree falling almost like there. Thank you
			var/obj/structure/fshadow/L = new /obj/structure/fshadow(t)
			L.objs_holder.Add(new /obj/structure/bed/chair/office/log(L))
			for(var/q = 1, q<=branch_factor*i, q++)
				L.objs_holder.Add(new /obj/item/weapon/branches(L))
			t = get_step(t, d)
		icon = initial(icon) //clear icon from colors here
		new /obj/structure/flora/stump(src.loc)
		qdel(src)

/obj/structure/flora/snowybush
	name = "Bush"
	icon = 'icons/obj/snowy_icons.dmi'
	icon_state = "snowbush4"
	anchored = 1
	layer = 8
	var/dead = 0
	var/berries_left = 3
	var/obj/item/weapon/reagent_containers/food/snacks/berries/berry = /obj/item/weapon/reagent_containers/food/snacks/berries

	New()
		icon_state = "snowbush[rand(4, 5)]"
		if(!dead)
			overlays += "berries-full"


/obj/structure/flora/snowybush/attackby(obj/item/weapon/T as obj, mob/user as mob)
	if(T.sharp)
		user << SPAN_NOTE("You whack [src.name].")
		if(prob(70) || istype(T, /obj/item/weapon/melee/energy))
			new /obj/item/weapon/branches(src.loc)
			qdel(src)

/obj/structure/flora/snowybush/attack_hand(var/mob/user as mob)
	..()
	if(!dead && berries_left)
		berries_left = berries_left-1
		new berry(user.loc)


/obj/structure/flora/snowybush/deadbush
	name = "Bush"
	icon_state = "deadbush"
	dead = 1

	New()


/obj/structure/fshadow
	name = "Shadow from falling tree"
	desc = "Tree fall here. Stay away!"
	icon = 'icons/obj/snowy_icons.dmi'
	icon_state = "falling_tree_shadow"
	anchored = 1
	var/list/objs_holder = list() //Object to spawn
	var/timer = 2
	var/alpha_channel = 50

	New()
		icon += rgb(,,, alpha_channel)
		processing_objects.Add(src)

/obj/structure/fshadow/process()
	timer--
	icon = initial(icon) //update our shadow
	alpha_channel = alpha_channel + 40
	icon += rgb(,,, alpha_channel)
	if(timer <= 0)
		for(var/obj/O in objs_holder)
			O.loc = src.loc
		var/mob/living/carbon/human/H = locate(/mob/living/carbon/human) in src.loc
		if(H)
			H.Weaken(5)
			for(var/i = 1, i<=3, i++)
				H.apply_damage(rand(10, 20),BRUTE) //Be careful with falling tree
		processing_objects.Remove(src) //I'm not sure about GC collect it from that list, so i put it here
		qdel(src)


/obj/structure/bed/chair/office/log
	name = "wood log"
	desc = "Part of tree. You are not sure about what kind of part is it, but you can sit down on it and drink some milk. Or cut into chunks."
	icon = 'icons/obj/snowy_icons.dmi'
	icon_state = "log"


/obj/structure/flora/stump
	name = "tree's stump"
	desc = "Bottom part of tree."
	icon = 'icons/obj/snowy_icons.dmi'
	icon_state = "stump"
	var/list/stored_items = list()
	anchored = 1

/obj/structure/flora/stump/attackby(obj/item/weapon/T as obj, mob/user as mob)
	user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
	if(istype(T, /obj/item/weapon/material/hatchet) || istype(T, /obj/item/weapon/melee/energy))
		user << SPAN_NOTE("You swing your [T.name] and hit the [src.name].")

		var/datum/effect/effect/system/steam_spread/F = new /datum/effect/effect/system/steam_spread/spread()
		F.set_up(4, 0, src.loc, /obj/effect/effect/steam/flinders)
		F.start()
		playsound(src.loc, 'sound/effects/woodhit.ogg', 60, rand(-50, 50), 8, 6)

		if(prob(30))
			new /obj/item/weapon/snowy_woodchunks(src.loc)
			user << SPAN_NOTE("You chop [src.name] into usable chunks.")
			qdel(src)


/obj/structure/flora/stump/fallen
	name = "old wood log"
	desc = "Old and hollow."
	icon = 'icons/obj/snowy_icons.dmi'
	icon_state = "old_trunk"


/obj/structure/bed/chair/office/log/attackby(obj/item/weapon/T as obj, mob/user as mob)
	if(istype(T, /obj/item/weapon/material/hatchet) || istype(T, /obj/item/weapon/melee/energy))
		for(var/i = 1, i<=3, i++)
			new /obj/item/weapon/snowy_woodchunks(src.loc)
		user << SPAN_NOTE("You chop log into usable chunks.")
		var/datum/effect/effect/system/steam_spread/F = new /datum/effect/effect/system/steam_spread/spread()
		F.set_up(4, 0, src.loc, /obj/effect/effect/steam/flinders)
		F.start()
		playsound(src.loc, 'sound/effects/woodhit.ogg', 60, rand(-50, 50), 8, 6)
		qdel(src)

//Well. I forgot about smolder stage after all firewood burnt. I add this later
/obj/structure/campfire
	name = "Campfire"
	desc = "Only you, me and that firewood."
	icon = 'icons/obj/snowy_icons.dmi'
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

/obj/structure/rock
	name = "Rock"
	desc = "Cold and big rock. Looks tough."
	icon = 'icons/obj/snowy_icons.dmi'
	icon_state = "rock"
	anchored = 1
	density = 1


//Some of special flora. Thanks to Ilya||| for good ideas

/obj/structure/flora/dustshroom //i'm not done with it. Need to make better and add chem burst with some deadly stuff
	name = "Dustshroom"
	desc = "Baloon-like mushroom."
	icon = 'icons/obj/snowy_icons.dmi'
	icon_state = "dustshroom"
	anchored = 1
	var/list/possible_reagents = list(/datum/reagent/toxin/amatoxin, /datum/reagent/mindbreaker, /datum/reagent/leporazine, /datum/reagent/tramadol)
	var/burst_reagent

	New()
		burst_reagent = pick(possible_reagents)


//obj/structure/flora/dustshroom/proc/Burst() //WIP


//obj/structure/flora/dustshroom/Crossed(atom/movable/M as mob|obj) //Yep, you can throw something on it
//	if(istype(M, /mob/living) || istype(M, /obj))
//		Burst()
//		qdel(src)

/obj/structure/ice_hole
	name = "hole"
	desc = "You can see dark water. Sometimes something moving."
	icon = 'icons/obj/snowy_icons.dmi'
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

/obj/structure/lootable
	name = "Spaceship chunk"
	desc = "Chunk of spaceship. You don't sure what part it is, but looks like something can be inside."
	icon = 'icons/obj/snowy_icons.dmi'
	icon_state = "debris1"
	var/obj/loot
	var/amount_of_loot = 1
	var/list/possible_loot = list()
	var/list/tools = list(/obj/item/weapon/wrench, /obj/item/weapon/screwdriver, /obj/item/weapon/wirecutters, /obj/item/weapon/crowbar)
	var/ultimate_tool = /obj/item/weapon/weldingtool
	var/ultimate_tool_can_be_used = 1
	var/ultimate_tool_message = "You slice metal debris with"
	var/del_when_harvested = 0
	var/harvested = 0
	var/stage = 1
	var/rand_stages = "yes"
	var/randomize_tools = "yes"
	var/list/tools_messages = list(/obj/item/weapon/wrench = list("You wrench the", "Looks like here need to wrench something."),
								/obj/item/weapon/screwdriver = list("You screwed the", "Need to screw some of these screws."),
								/obj/item/weapon/wirecutters = list("You cutted up that", "There's better to cut it up"),
								/obj/item/weapon/crowbar = list("You pried that", "Need to pry that bulky stuff here"),
								) //tool path = list(msg1, msg2) //msg1 - act_message, msg2 - examine_message
	var/list/item_message = list("bolts of huge steel plate", "panel with some wires and screws", "steel grille with panel at the bottom")
	var/list/messages_by_stages = list() //Here you can store messages for every stage. Well... In future
	anchored = 1
	density = 1

	New()
		if(randomize_tools == "yes")
			tools = shuffle(tools) //let's make it random
		if(rand_stages == "yes")
			var/L = rand(1, 5)
			for(var/i = 1, i<=L, i++)
				var/repeat = pick(tools)
				tools.Add(repeat)
		for(var/t = 1, t<=tools.len, t++)
			messages_by_stages.Add(pick(item_message))
		if(!loot)
			loot = pick(possible_loot)

/obj/structure/lootable/examine(mob/user as mob)
	..()
	if(!harvested)
		if(tools_messages[tools[stage]][2])
			user << SPAN_NOTE("You can see [messages_by_stages[stage]] here. [tools_messages[tools[stage]][2]].")


/obj/structure/lootable/proc/harvest(var/mob/user as mob)
	if(loot)
		for(var/i = 1, i<=amount_of_loot, i++)
			new loot(src.loc)
		user << SPAN_NOTE("You found something!")
	else
		user << SPAN_WARN("There's nothing...")

	if(del_when_harvested)
		qdel(src)
	else
		after_harvest(user)

/obj/structure/lootable/proc/after_harvest(var/mob/user as mob)
	icon_state = "debris_junk"
	name = "Metal debris"
	desc = "Now this just a junk..."
	harvested = 1

/obj/structure/lootable/proc/junk_harvest(var/mob/user as mob)
	user << "You slice [src.name] into a few lists of metal"
	playsound(src, 'sound/items/Welder.ogg', 100, 1)
	if(do_after(user, 30))
		var/obj/item/stack/material/steel/S = new(user.loc)
		S.amount = rand(8, 16)
		qdel(src)

/obj/structure/lootable/attack_hand(var/mob/user as mob)
	if(tools.len)
		user << SPAN_WARN("Looks like you can't harvest something from it without tools.")
	else
		if(!harvested)
			harvest(user)
		else
			junk_harvest(user)

/obj/structure/lootable/attackby(obj/item/weapon/T as obj, mob/user as mob)
	if(istype(T, tools[stage]) && !harvested)
		if(prob(85))
			if(tools_messages[tools[stage]][1])
				user << SPAN_NOTE("[tools_messages[tools[stage]][1]] [messages_by_stages[stage]].")
			if(stage >= tools.len)
				harvest(user)
			stage++
		else
			user << SPAN_WARN("You doing something wrong. Oops.")
			src.visible_message("[src.name] colapses!")
			after_harvest(user)
	else if(istype(T, ultimate_tool) && ultimate_tool_can_be_used)
		if(!harvested)
			if(prob(95))
				user << SPAN_NOTE("[ultimate_tool_message] [T.name]")
				harvest(user)
			else
				user << SPAN_WARN("You doing something wrong. Oops.")
				src.visible_message("[src.name] colapses!")
				after_harvest(user)
		else
			junk_harvest(user)



/obj/structure/lootable/mushroom_hideout
	name = "Mushrooms"
	desc = "Mushrooms under layer of snow. Looks alive..."
	icon = 'icons/obj/snowy_icons.dmi'
	icon_state = "shrooms_hided"
	loot = /obj/item/weapon/reagent_containers/food/snacks/mushroom
	tools = list()
	amount_of_loot = 3
	del_when_harvested = 1
	rand_stages = "no"
	randomize_tools = "no"
	density = 0
	ultimate_tool = null
	ultimate_tool_can_be_used = 0


/obj/structure/lootable/mushroom_hideout/tree_mush
	name = "Mushrooms"
	desc = "Mushrooms that grow on the tree. Looks undamaged."
	icon = 'icons/obj/snowy_icons.dmi'
	icon_state = "shrooms_hided"
	loot = /obj/item/weapon/reagent_containers/food/snacks/mushroom
	amount_of_loot = 2
	del_when_harvested = 1

	New()
		..()
		icon_state = "shrooms_trees[rand(1,2)]"

/obj/item/weapon/snowy_woodchunks
	name = "wood chunks"
	desc = "Some wood from one of these trees."
	icon = 'icons/obj/snowy_icons.dmi'
	icon_state = "wood_chunks"

/obj/item/weapon/snowy_woodchunks/attackby(obj/item/weapon/T as obj, mob/user as mob)
	if(!T.sharp)
		return

	for(var/i = 1, i<10, i++)
		var/obj/item/stack/material/wood/W = new(user.loc)
		for (var/obj/item/stack/material/G in user.loc) //Yeah, i copypasted that small part. Sorry. Don't know why nobody puts this in New() of sheets
			if(G.get_material_name() != MATERIAL_WOOD || G==W)
				continue
			if(G.amount>=G.max_amount)
				continue
			G.attackby(W, user)
	qdel(src)

/obj/item/weapon/snowy_woodchunks/attack_self(var/mob/user as mob)
	new /obj/structure/campfire(user.loc)
	user << SPAN_NOTE("You place chunks into circle and make campfire.")
	qdel(src)


/obj/item/weapon/branches
	name = "branches"
	desc = "Wood branches. Can be used as firewood."
	icon = 'icons/obj/snowy_icons.dmi'
	icon_state = "branches1"

	New()
		icon_state = "branches[rand(1, 3)]"
		pixel_x = rand(-10, 10)
		pixel_y = rand(-10, 10)


/obj/item/weapon/reagent_containers/food/snacks/mushroom
	name = "mushroom"
	desc = "Unknown shroom. Eatable. Can be toxic."
	icon = 'icons/obj/snowy_icons.dmi'
	icon_state = "shroom_bottom1"
	var/icon_head = "shroom_upper1"
	var/icon_ring = "shroom_ring1"

	New()
		..()
		update_icon()


/obj/item/weapon/reagent_containers/food/snacks/mushroom/update_icon()
	if(icon_head)
		overlays += icon_head
	if(icon_ring)
		overlays += icon_ring


/obj/item/weapon/reagent_containers/food/snacks/berries
	name = "Berries"
	desc = "Unknown berries. You can eat it, but they might kill you."
	icon = 'icons/obj/snowy_icons.dmi'
	icon_state = "handful_berries"


/obj/item/weapon/reagent_containers/food/snacks/bug
	name = "Barksleeper"
	desc = "Small bug with hump on his back. You can try to eat that, but... Well.."
	icon = 'icons/obj/snowy_icons.dmi'
	icon_state = "barksleeper_bug"

/obj/item/weapon/spider_silk
	name = "Spider Silk"
	desc = "High quality spider silk. Very strong and soft."
	icon = 'icons/obj/snowy_icons.dmi'
	icon_state = "spider_silk"

/obj/item/weapon/spider_silk/attack_self(var/mob/user as mob)
	var/obj/item/weapon/fishing_line/F = new /obj/item/weapon/fishing_line(user.loc)
	F.length = 3
	user << SPAN_NOTE("You rolled up [src.name] in thin line.")
	qdel(src)


//Some special effects for that event based on steam effects
/obj/effect/effect/steam/flinders
	name = "flinders"
	icon = 'icons/obj/snowy_icons.dmi'
	icon_state = "flinders1"

	New()
		..()
		icon_state = "flinders[rand(1,3)]"

/obj/effect/effect/steam/fire_spark
	name = "fire spark"
	icon = 'icons/obj/snowy_icons.dmi'
	icon_state = "fire_spark"

/datum/effect/effect/system/steam_spread/spread
	var/effect

	//Dont know why nobody makes effect_system more... better and reusable?..
	set_up(n = 3, c = 0, turf/loc, effect_obj)
		if(n > 10)
			n = 10
		number = n
		cardinals = c
		location = loc
		effect = effect_obj

	start()
		var/i = 0
		for(i=0, i<src.number, i++)
			spawn(0)
				if(holder)
					src.location = get_turf(holder)
				var/obj/effect/effect/eff = PoolOrNew(effect, src.location)
				eff.pixel_x = rand(-15, 15)
				eff.pixel_y = rand(-15, 15)
				var/direction
				if(src.cardinals)
					direction = pick(cardinal)
				else
					direction = pick(alldirs)
				for(i=0, i<pick(1,2,3), i++)
					sleep(5)
					step(eff,direction)
				spawn(20)
					qdel(eff)


/turf/simulated/floor/plating/snow/light_forest
	var/bush_factor = 1 //helper. Dont change or use it please

	New()
		..()
		spawn(4)
			if(src)
				forest_gen(20, list(/obj/structure/flora/snowytree/big/another, /obj/structure/flora/snowytree/big, /obj/structure/flora/snowytree), 40,
								list(/obj/structure/flora/snowybush/deadbush, /obj/structure/flora/snowybush, /obj/structure/lootable/mushroom_hideout), 10, 40,
								list(/obj/structure/flora/stump/fallen, /obj/structure/flora/stump), 20,
								list(/obj/item/weapon/branches), 10,
								list(/obj/structure/rock), 5,
								list(/obj/structure/lootable), 3)


//I know, all of that and previous generation is shit and needed to coded separatly with masks. But i have't so much time to dig it up
//Sorry. Maybe i remake it to good version

//Another long shit. Hell!
/turf/simulated/floor/plating/snow/light_forest/proc/forest_gen(spawn_chance, trees, tree_chance, bushes, bush_chance, bush_density, stumps, stump_chance, items, item_chance, rocks, rock_chance, additions, addition_chance)
	if(prob(spawn_chance))
		if(prob(tree_chance))
			var/obj/structure/S = pick(trees)
			new S(src)
			if(prob(8))
				var/obj/structure/lootable/mushroom_hideout/tree_mush/TM = new /obj/structure/lootable/mushroom_hideout/tree_mush(src)
				TM.layer = 10
			return
		if(prob(bush_chance))
			var/obj/structure/B = pick(bushes)
			new B(src)
			bush_gen(bush_density, B)
			return
		if(prob(stump_chance))
			var/obj/structure/L = pick(stumps)
			new L(src)
			return
		if(prob(item_chance))
			var/obj/item/weapon/O = pick(items)
			new O(src)
			return
		if(prob(addition_chance))
			var/obj/structure/A = pick(additions)
			new A(src)


/turf/simulated/floor/plating/snow/light_forest/proc/bush_gen(var/chance, var/bush) //play with this carefully
	for(var/dir in alldirs)
		if(istype(get_step(src, dir), /turf/simulated/floor/plating/snow))
			var/turf/simulated/floor/plating/snow/light_forest/K = get_step(src, dir)
			var/obj/structure/flora/snowybush/B = locate(/obj/structure/flora/snowybush) in K
			if(!B && !(locate(/obj/structure/flora/snowytree) in K))
				if(prob(chance/src.bush_factor))
					K.bush_factor = src.bush_factor + 1
					new bush(K)
					bush_gen()


/turf/simulated/floor/plating/snow/light_forest/pines

	New()
		spawn(4)
			if(src)
				forest_gen(30, list(/obj/structure/flora/snowytree/high), 35,
								list(/obj/structure/flora/snowybush/deadbush), 20, 40,
								list(/obj/structure/flora/stump/fallen, /obj/structure/flora/stump, /obj/structure/lootable/mushroom_hideout), 20,
								list(/obj/item/weapon/branches), 10,
								list(/obj/structure/rock), 5,
								list(/obj/structure/lootable), 3)


/turf/simulated/floor/plating/snow/light_forest/mixed

	New()
		spawn(4)
			if(src)
				forest_gen(50, list(/obj/structure/flora/snowytree/high, /obj/structure/flora/snowytree/big/another, /obj/structure/flora/snowytree/big, /obj/structure/flora/snowytree), 35,
								list(/obj/structure/flora/snowybush/deadbush, /obj/structure/flora/snowybush), 20, 40,
								list(/obj/structure/flora/stump/fallen, /obj/structure/flora/stump, /obj/structure/lootable/mushroom_hideout), 20,
								list(/obj/item/weapon/branches), 10,
								list(/obj/structure/rock), 5,
								list(/obj/structure/lootable), 3)