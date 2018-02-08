/obj/structure/lootable
	name = "Spaceship chunk"
	desc = "Chunk of spaceship. You don't sure what part it is, but looks like something can be inside."
	icon = 'icons/obj/snowy_event/snowy_icons.dmi'
	icon_state = "debris1"
	var/obj/loot
	var/amount_of_loot = 1
	var/list/possible_loot = list()
	var/ultimate_tool = /obj/item/weapon/weldingtool
	var/ultimate_tool_can_be_used = 1
	var/ultimate_tool_message = "You slice metal debris with"
	var/del_when_harvested = 0
	var/harvested = 0
	var/stage = 1
	var/rand_stages = "yes"
	var/randomize_tools = "yes"
	var/list/tools = list(/obj/item/weapon/wrench, /obj/item/weapon/screwdriver, /obj/item/weapon/wirecutters, /obj/item/weapon/crowbar)
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
		if(!loot && possible_loot.len != 0)
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


/obj/structure/lootable/proc/junk_harvest(var/mob/user as mob, var/obj/item/weapon/W)
	if(istype(W, /obj/item/weapon/weldingtool))
		var/obj/item/weapon/weldingtool/WT = W
		if(WT.welding == 1)
			playsound(src, 'sound/items/Welder.ogg', 100, 1)
			if(do_after(user, 30))
				if(src)
					user << SPAN_NOTE("You slice a [src.name] into a few lists of metal")
					WT.remove_fuel(10, user)
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
			src.visible_message(SPAN_WARN("[src.name] colapses!"))
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
			junk_harvest(user, T)



/obj/structure/lootable/chunk

	New()
		..()
		icon_state = "debris[rand(1, 3)]"



/obj/structure/lootable/mushroom_hideout
	name = "Mushrooms"
	desc = "Mushrooms under layer of snow. Looks alive..."
	icon = 'icons/obj/snowy_event/snowy_icons.dmi'
	icon_state = "shrooms_hided"
	possible_loot = list(/obj/item/weapon/reagent_containers/food/snacks/ingredient/mushroom/dumb,
						/obj/item/weapon/reagent_containers/food/snacks/ingredient/mushroom/healer,
						/obj/item/weapon/reagent_containers/food/snacks/ingredient/mushroom/guts,
						/obj/item/weapon/reagent_containers/food/snacks/ingredient/mushroom/choco,
						/obj/item/weapon/reagent_containers/food/snacks/ingredient/mushroom/meat,
						/obj/item/weapon/reagent_containers/food/snacks/ingredient/mushroom/rad)
	tools = list()
	amount_of_loot = 3
	del_when_harvested = 1
	rand_stages = "no"
	randomize_tools = "no"
	density = 0
	ultimate_tool = null
	ultimate_tool_can_be_used = 0

	New()
		..()
		icon_state = "shrooms_hided[rand(1, 5)]"
		amount_of_loot = rand(2, 4)


/obj/structure/lootable/mushroom_hideout/tree_mush
	name = "Mushrooms"
	desc = "Mushrooms that grow on the tree. Looks undamaged."
	icon = 'icons/obj/snowy_event/snowy_icons.dmi'
	icon_state = "shrooms_hided"
	possible_loot = list(/obj/item/weapon/reagent_containers/food/snacks/ingredient/mushroom/mind,
						/obj/item/weapon/reagent_containers/food/snacks/ingredient/mushroom/paradise,
						/obj/item/weapon/reagent_containers/food/snacks/ingredient/mushroom/pure)
	amount_of_loot = 2
	del_when_harvested = 1

	New()
		..()
		icon_state = "shrooms_trees[rand(1, 3)]"