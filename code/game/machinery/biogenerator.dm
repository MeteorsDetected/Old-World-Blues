/obj/machinery/biogenerator
	name = "Biogenerator"
	desc = ""
	icon = 'icons/obj/biogenerator.dmi'
	icon_state = "biogen-stand"
	density = 1
	anchored = 1
	use_power = 1
	idle_power_usage = 40
	circuit = /obj/item/weapon/circuitboard/biogenerator
	var/processing = 0
	var/obj/item/weapon/reagent_containers/glass/beaker/beaker = null
	var/points = 0
	var/menustat = "menu"
	var/build_eff = 1
	var/eat_eff = 1

	var/list/recipes = list(
		"Food",
			list(name="10 Milk", cost=20, path="milk"),
			list(name="Slab of meat", cost=50, path=/obj/item/weapon/reagent_containers/food/snacks/meat),
		"Nutrient",
			list(name="EZ-Nutrient", cost=10, path=/obj/item/weapon/reagent_containers/glass/fertilizer/ez, allow_multiple = 1),
			list(name="Left4Zed", cost=20, path=/obj/item/weapon/reagent_containers/glass/fertilizer/l4z, allow_multiple = 1),
			list(name="Robust Harvest", cost=25, path=/obj/item/weapon/reagent_containers/glass/fertilizer/rh, allow_multiple = 1),
		"Leather",
			list(name="Wallet", cost=100, path=/obj/item/storage/wallet),
			list(name="Botanical gloves", cost=250, path=/obj/item/clothing/gloves/botanic_leather),
			list(name="Utility belt", cost=300, path=/obj/item/storage/belt/utility),
			list(name="Leather Satchel", cost=400, path=/obj/item/storage/backpack/satchel),
			list(name="Cash Bag", cost=400, path=/obj/item/storage/bag/cash),
		"Medicine",
			list(name="Roll of gauze", cost=100, path=/obj/item/stack/medical/bruise_pack),
			list(name="Ointment", cost=100, path=/obj/item/stack/medical/ointment),
/*
			list(name="Advanced trauma kit", cost=200, path=/obj/item/stack/medical/advanced/bruise_pack),
			list(name="Advanced burn kit", cost=200, path=/obj/item/stack/medical/advanced/ointment),
*/
	)

/obj/machinery/biogenerator/initialize()
	. = ..()
	create_reagents(1000)
	beaker = new /obj/item/weapon/reagent_containers/glass/beaker/large (src)

/obj/machinery/biogenerator/on_reagent_change()			//When the reagents change, change the icon as well.
	update_icon()

/obj/machinery/biogenerator/update_icon()
	if(!beaker)
		icon_state = "biogen-empty"
	else if(!processing)
		icon_state = "biogen-stand"
	else
		icon_state = "biogen-work"

/obj/machinery/biogenerator/attackby(var/obj/item/O as obj, var/mob/user as mob)
	if(default_deconstruction_screwdriver(user, O))
		return
	if(default_deconstruction_crowbar(user, O))
		return
	if(default_part_replacement(user, O))
		return
	if(istype(O, /obj/item/weapon/reagent_containers/glass))
		if(beaker)
			user << SPAN_NOTE("The [src] is already loaded.")
		else
			if(user.unEquip(O, src))
				beaker = O
				updateUsrDialog()
	else if(processing)
		user << SPAN_NOTE("\The [src] is currently processing.")
	else if(istype(O, /obj/item/storage/bag/plants))
		var/i = 0
		for(var/obj/item/weapon/reagent_containers/food/snacks/grown/G in contents)
			i++
		if(i >= 10)
			user << SPAN_NOTE("\The [src] is already full! Activate it.")
		else
			for(var/obj/item/weapon/reagent_containers/food/snacks/grown/G in O.contents)
				G.forceMove(src)
				i++
				if(i >= 10)
					user << SPAN_NOTE("You fill \the [src] to its capacity.")
					break
			if(i < 10)
				user << SPAN_NOTE("You empty \the [O] into \the [src].")


	else if(!istype(O, /obj/item/weapon/reagent_containers/food/snacks/grown))
		user << SPAN_NOTE("You cannot put this in \the [src].")
	else
		var/i = 0
		for(var/obj/item/weapon/reagent_containers/food/snacks/grown/G in contents)
			i++
		if(i >= 10)
			user << SPAN_NOTE("\The [src] is full! Activate it.")
		else
			if(user.unEquip(O, src))
				user << SPAN_NOTE("You put \the [O] in \the [src]")
	update_icon()

/obj/machinery/biogenerator/ui_interact(mob/user, ui_key = "main", datum/nanoui/ui = null, force_open = 1, var/master_ui = null, var/datum/topic_state/state = default_state)
	user.set_machine(src)
	var/list/data = list()

	if(menustat == "menu")
		data["beaker"] = beaker
		if(beaker)
			data["points"] = points
			var/list/tmp_recipes = list()
			for(var/smth in recipes)
				if(istext(smth))
					tmp_recipes += list(list(
						"is_category" = 1,
						"name" = smth,
					))
				else
					var/list/L = smth
					tmp_recipes += list(list(
						"is_category" = 0,
						"name" = L["name"],
						"cost" = round(L["cost"]/build_eff),
						"allow_multiple" = L["allow_multiple"],
					))

			data["recipes"] = tmp_recipes

	data["processing"] = processing
	data["menustat"] = menustat
	if(menustat == "menu")
		data["beaker"] = beaker

	ui = nanomanager.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		// the ui does not exist, so we'll create a new() one
		// for a list of parameters and their descriptions see the code docs in \code\modules\nano\nanoui.dm
		ui = new(user, src, ui_key, "biogenerator.tmpl", "Biogenerator", 550, 655)
		// when the ui is first opened this is the data it will use
		ui.set_initial_data(data)
		// open the new ui window
		ui.open()

/obj/machinery/biogenerator/attack_hand(mob/living/user)
	ui_interact(user)

/obj/machinery/biogenerator/proc/activate()
	if (usr.incapacitated())
		return
	if (stat) //NOPOWER etc
		return
	if(processing)
		usr << SPAN_NOTE("The biogenerator is in the process of working.")
		return
	var/S = 0
	for(var/obj/item/weapon/reagent_containers/food/snacks/grown/I in contents)
		S += 5
		if(I.reagents.get_reagent_amount("nutriment") < 0.1)
			points += 1
		else points += I.reagents.get_reagent_amount("nutriment") * 10 * eat_eff
		qdel(I)
	if(S)
		processing = 1
		update_icon()
		updateUsrDialog()
		playsound(src.loc, 'sound/machines/blender.ogg', 50, 1)
		use_power(S * 30)
		sleep((S + 15) / eat_eff)
		processing = 0
		update_icon()
	else
		menustat = "void"

/obj/machinery/biogenerator/proc/create_product(var/item, var/amount)
	if(processing)
		return

	var/list/recipe = null

	for(var/list/R in recipes)
		if(R["name"] == item)
			recipe = R
			break
	if(!recipe)
		return

	if(!"allow_multiple" in recipe)
		amount = 1
	else
		amount = max(amount, 1)

	var/cost = recipe["cost"] * amount / build_eff

	if(cost > points)
		menustat = "nopoints"
		return 0

	processing = 1
	update_icon()
	updateUsrDialog() //maybe we can remove it
	points -= cost
	sleep(30)

	var/creating = recipe["path"]
	if(creating) //For reagents like milk
		beaker.reagents.add_reagent(creating, 10)
	else
		for(var/i in 1 to amount)
			new creating(loc)
	processing = 0
	menustat = "complete"
	update_icon()
	return 1

/obj/machinery/biogenerator/Topic(href, href_list)
	if(stat & BROKEN || usr.incapacitated() || !in_range(src, usr)) return

	usr.set_machine(src)

	switch(href_list["action"])
		if("activate")
			activate()
		if("detach")
			if(beaker)
				beaker.forceMove(src.loc)
				beaker = null
				update_icon()
		if("create")
			create_product(href_list["item"], text2num(href_list["amount"]))
		if("menu")
			menustat = "menu"
	updateUsrDialog()

/obj/machinery/biogenerator/RefreshParts()
	..()
	var/man_rating = 0
	var/bin_rating = 0

	for(var/obj/item/weapon/stock_parts/P in component_parts)
		if(istype(P, /obj/item/weapon/stock_parts/matter_bin))
			bin_rating += P.rating
		if(istype(P, /obj/item/weapon/stock_parts/manipulator))
			man_rating += P.rating

	build_eff = man_rating
	eat_eff = bin_rating
