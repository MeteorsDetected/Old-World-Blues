
//chemistry stuff here so that it can be easily viewed/modified

/obj/item/weapon/reagent_containers/glass/solution_tray
	name = "solution tray"
	desc = "A small, open-topped glass container for delicate research samples. It sports a re-useable strip for labelling with a pen."
	icon = 'icons/obj/device.dmi'
	icon_state = "solution_tray"
	matter = list(MATERIAL_GLASS = 5)
	w_class = ITEM_SIZE_SMALL
	amount_per_transfer_from_this = 1
	possible_transfer_amounts = list(1, 2)
	volume = 2
	flags = OPENCONTAINER

/obj/item/weapon/reagent_containers/glass/solution_tray/attackby(obj/item/weapon/W as obj, mob/living/user as mob)
	if(istype(W, /obj/item/weapon/pen))
		var/new_label = sanitizeSafe(input("What should the new label be?","Label solution tray"), MAX_NAME_LEN)
		if(new_label)
			name = "solution tray ([new_label])"
			user << "\blue You write on the label of the solution tray."
	else
		..(W, user)

/obj/item/storage/box/solution_trays
	name = "solution tray box"
	icon_state = "solution_trays"
	preloaded = list(
		/obj/item/weapon/reagent_containers/glass/solution_tray = 7
	)

/obj/item/weapon/reagent_containers/glass/beaker/tungsten
	name = "beaker 'tungsten'"
	preloaded = list("tungsten" = 50)

/obj/item/weapon/reagent_containers/glass/beaker/acetone
	name = "beaker 'acetone'"
	preloaded = list("acetone" = 50)

/obj/item/weapon/reagent_containers/glass/beaker/sodium
	name = "beaker 'sodium'"
	preloaded = list("sodium" = 50)

/obj/item/weapon/reagent_containers/glass/beaker/lithium
	name = "beaker 'lithium'"
	preloaded = list("lithium" = 50)

/obj/item/weapon/reagent_containers/glass/beaker/water
	name = "beaker 'water'"
	preloaded = list("water" = 50)

/obj/item/weapon/reagent_containers/glass/beaker/water
	name = "beaker 'water'"
	preloaded = list("water" = 50)

/obj/item/weapon/reagent_containers/glass/beaker/fuel
	name = "beaker 'fuel'"
	preloaded = list("fuel" = 50)
