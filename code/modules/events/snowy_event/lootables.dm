/obj/structure/lootable
	name = "Spaceship chunk"
	desc = "Chunk of spaceship. You don't sure what part it is, but looks like something can be inside."
	icon = 'icons/obj/snowy_event/snowy_icons.dmi'
	icon_state = "debris1"
	var/loot
	var/amount_of_loot = 1
	var/list/possible_loot = list()
	var/ultimate_tool = /obj/item/weapon/weldingtool
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
	var/list/messages_by_stages = list()
	//var/tool_delay
	anchored = 1
	density = 1
	opacity = 1

	New()
		if(randomize_tools == "yes")
			tools = shuffle(tools) //let's make it random
		if(rand_stages == "yes" && tools.len)
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
		if(WT.welding)
			playsound(src, 'sound/items/Welder.ogg', 100, 1)
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
	if(tools.len && istype(T, tools[stage]) && !harvested)
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
	else if(ultimate_tool && istype(T, ultimate_tool))
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
		icon_state = "debris[rand(1, 3)]"
		if(prob(30))
			possible_loot = typesof(/obj/machinery/computer3)
			possible_loot.Remove(/obj/machinery/computer3)
			possible_loot.Remove(/obj/machinery/computer3/wall_comp)
			possible_loot.Remove(/obj/machinery/computer3/communications) //ha-ha-ha. No.
			..()
			return
		if(prob(40))
			possible_loot = typesof(/obj/structure/closet/crate)
			possible_loot.Remove(/obj/structure/closet/crate)
			..()
			return
		if(prob(70))
			possible_loot = SnowyMaster.safe_items_list
			amount_of_loot = rand(1, 10)
		..()


/obj/structure/lootable/container
	name = "Container's debris"
	desc = "It's hard to say what this was before. But for now - just a junk."
	icon_state = "debris_container"


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
	opacity = 0
	ultimate_tool = null

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


/obj/structure/lootable/wooden
	name = "Wooden blockage"
	desc = "Bunch of almost useless wooden details. Maybe under layers of wood can be something."
	icon = 'icons/obj/snowy_event/snowy_icons.dmi'
	icon_state = "wooden_debris1"
	ultimate_tool = /obj/item/weapon/shovel
	ultimate_tool_message = "You dig up the blockage with"
	del_when_harvested = 0
	tools = list()
	tools_messages = list()
	item_message = list()
	var/loot_chance = 30


/obj/structure/lootable/wooden/New()
	possible_loot = SnowyMaster.safe_items_list
	..()
	icon_state = "wooden_debris[rand(1, 2)]"


/obj/structure/lootable/wooden/after_harvest(var/mob/user as mob)
	var/wood_amount = rand(1, 4)
	for(var/i=1 to wood_amount)
		new /obj/item/weapon/snowy_woodchunks(src.loc)
	qdel(src)


/obj/structure/lootable/wooden/harvest(var/mob/user as mob)
	user << SPAN_NOTE("You taking apart that [name]...")
	if(do_after(user, 30))
		if(src && prob(loot_chance) && loot)
			for(var/i=1 to amount_of_loot)
				new loot(src.loc)
			loot = null
			user << SPAN_NOTE("You found something!")
			after_harvest(user)


/obj/structure/lootable/rocky
	name = "Stone blockage"
	desc = "This is what happens, when you digging wrong."
	icon = 'icons/obj/snowy_event/snowy_icons.dmi'
	icon_state = "rocky_debris"
	amount_of_loot = 3
	ultimate_tool = /obj/item/weapon/pickaxe
	ultimate_tool_message = "You dig up the blockage with"
	del_when_harvested = 0
	tools = list(/obj/item/weapon/shovel, /obj/item/weapon/crowbar)
	tools_messages = list(/obj/item/weapon/shovel = list("You digging up the", "Need to dig it."),
								/obj/item/weapon/crowbar = list("You pried the", "Need something to pry it.")
								)
	item_message = list("tricky rocks", "crushed rocks with metal wreckages", "covered with dirt medium-sized rocks")
	del_when_harvested = 1


/obj/structure/lootable/rocky/New()
	possible_loot = subtypesof(/obj/item/weapon/ore)
	..()
	amount_of_loot = rand(2, 5)