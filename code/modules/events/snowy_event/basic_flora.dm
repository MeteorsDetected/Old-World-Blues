//TODO-list:
//Find and fix bugs


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
	icon = 'icons/obj/snowy_event/snowy_icons.dmi'

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
	icon = 'icons/obj/snowy_event/snowy_trees_big.dmi'
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
	icon = 'icons/obj/snowy_event/snowy_trees_high.dmi'
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
		playsound(src.loc, 'sound/effects/woodhit.ogg', 60, rand(-50, 50), 8, 2)
		user << SPAN_NOTE("You aim a blow and hit that [src.name].")
		update_icon()

	if(tree_health <= 0)
		src.visible_message(SPAN_WARN("<b>[src.name] falling down!</b>"))
		playsound(src.loc, 'sound/effects/snowy/falling_tree.ogg', 45, rand(-50, 50), 36, 2)
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
	icon = 'icons/obj/snowy_event/snowy_icons.dmi'
	icon_state = "snowbush4"
	anchored = 1
	layer = 8
	var/dead = 0
	var/berries_left = 3
	var/obj/item/weapon/reagent_containers/food/snacks/ingredient/berries/berry = /obj/item/weapon/reagent_containers/food/snacks/ingredient/berries

	New()
		if(!dead)
			icon_state = "snowbush[rand(4, 5)]"
			if(berry && berries_left)
				overlays += "berries-full"
		else
			icon_state = "deadbush[rand(1, 4)]"


/obj/structure/flora/snowybush/deadbush/examine(var/mob/user as mob)
	..()
	if(dead)
		user << SPAN_NOTE("That bush is dead or sleeping at this time.")
	else
		if(berry && berries_left)
			user << SPAN_NOTE("You see how [berry.name] berries growing here. You can harvest them for [berries_left] times left.")


/obj/structure/flora/snowybush/attackby(obj/item/weapon/T as obj, mob/user as mob)
	if(T.sharp)
		user << SPAN_NOTE("You whack [src.name].")
		if(prob(70) || istype(T, /obj/item/weapon/melee/energy))
			new /obj/item/weapon/branches(src.loc)
			qdel(src)


/obj/structure/flora/snowybush/attack_hand(var/mob/user as mob)
	..()
	if(!dead && berries_left && user.a_intent != I_DISARM)
		berries_left = berries_left-1
		new berry(user.loc)


/obj/structure/flora/snowybush/deadbush
	name = "Bush"
	icon_state = "deadbush1"
	dead = 1


/obj/structure/fshadow
	name = "Shadow from falling tree"
	desc = "Tree fall here. Stay away!"
	icon = 'icons/obj/snowy_event/snowy_icons.dmi'
	icon_state = "falling_tree_shadow"
	anchored = 1
	var/timer = 2
	var/alpha_channel = 50
	var/list/objs_holder = list() //Objects to spawn

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
	icon = 'icons/obj/snowy_event/snowy_icons.dmi'
	icon_state = "log"


/obj/structure/bed/chair/office/log/attackby(obj/item/weapon/T as obj, mob/user as mob)
	if(istype(T, /obj/item/weapon/material/hatchet) || istype(T, /obj/item/weapon/melee/energy))
		for(var/i = 1, i<=3, i++)
			new /obj/item/weapon/snowy_woodchunks(src.loc)
		user << SPAN_NOTE("You chop log into usable chunks.")
		var/datum/effect/effect/system/steam_spread/F = new /datum/effect/effect/system/steam_spread/spread()
		F.set_up(4, 0, src.loc, /obj/effect/effect/steam/flinders)
		F.start()
		playsound(src.loc, 'sound/effects/woodhit.ogg', 60, rand(-50, 50), 8, 2)
		qdel(src)



/obj/structure/flora/stump
	name = "tree's stump"
	desc = "Bottom part of tree."
	icon = 'icons/obj/snowy_event/snowy_icons.dmi'
	icon_state = "stump"
	anchored = 1
	var/list/stored_items = list()


/obj/structure/flora/stump/attackby(obj/item/weapon/T as obj, mob/user as mob)
	if(user.a_intent != I_GRAB)
		user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
		if(istype(T, /obj/item/weapon/material/hatchet) || istype(T, /obj/item/weapon/melee/energy))
			user << SPAN_NOTE("You swing your [T.name] and hit the [src.name].")

			var/datum/effect/effect/system/steam_spread/F = new /datum/effect/effect/system/steam_spread/spread()
			F.set_up(4, 0, src.loc, /obj/effect/effect/steam/flinders)
			F.start()
			playsound(src.loc, 'sound/effects/woodhit.ogg', 60, rand(-50, 50), 8, 2)

			if(prob(30))
				new /obj/item/weapon/snowy_woodchunks(src.loc)
				user << SPAN_NOTE("You chop [src.name] into usable chunks.")
				if(stored_items.len)
					src.visible_message(SPAN_NOTE("Something drops from [src]!"))
					for(var/obj/item/W in stored_items)
						W.loc = src.loc
						stored_items.Remove(W)
				qdel(src)
	else
		if(stored_items.len < 5)
			if(T.w_class <= 3)
				stored_items.Add(T)
				user << SPAN_NOTE("You place [T.name] into the [src.name].")
				user.drop_from_inventory(T, src)
			else
				user << SPAN_WARN("There's no space for such big item.")
		else
			user << SPAN_WARN("There's no more space.")


/obj/structure/flora/stump/attack_hand(mob/user as mob)
	user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
	if(user.a_intent == I_GRAB)
		if(stored_items.len)
			var/obj/item/weapon/F = pick(stored_items)
			if(prob(60))
				user << SPAN_NOTE("You shove your hand into the [src.name] and take something!")
				user.put_in_hands(F)
				stored_items.Remove(F)
			else
				user << SPAN_WARN("You check this [src.name] but nothing is here.")
		else
			user << SPAN_WARN("You check this [src.name] but nothing is here.")



/obj/structure/flora/stump/fallen
	name = "old wood log"
	desc = "Old and hollow."
	icon = 'icons/obj/snowy_event/snowy_icons.dmi'
	icon_state = "old_trunk"