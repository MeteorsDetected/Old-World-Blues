/obj/item/storage/toolbox
	name = "toolbox"
	desc = "Danger. Very robust."
	icon = 'icons/obj/storage.dmi'
	icon_state = "red"
	item_state = "toolbox_red"
	flags = CONDUCT
	force = 10
	throwforce = 10
	throw_speed = 1
	throw_range = 7
	w_class = ITEM_SIZE_LARGE
	max_w_class = ITEM_SIZE_NORMAL
	storage_slots = 0
	max_storage_space = DEFAULT_LARGEBOX_STORAGE //enough to hold all starting contents
	origin_tech = list(TECH_COMBAT = 1)
	attack_verb = list("robusted")

/obj/item/storage/toolbox/emergency
	name = "emergency toolbox"
	icon_state = "red"
	item_state = "toolbox_red"
	preloaded = list(
		/obj/item/weapon/crowbar/red,
		/obj/item/weapon/extinguisher/mini,
		/obj/item/device/radio,
	)

/obj/item/storage/toolbox/emergency/populateContents()
	..()
	if(prob(50))
		PoolOrNew(/obj/item/device/flashlight, src)
	else
		PoolOrNew(/obj/item/device/flashlight/flare, src)


/obj/item/storage/toolbox/mechanical
	name = "mechanical toolbox"
	icon_state = "blue"
	item_state = "toolbox_blue"
	preloaded = list(
		/obj/item/weapon/screwdriver,
		/obj/item/weapon/wrench,
		/obj/item/weapon/weldingtool,
		/obj/item/weapon/crowbar,
		/obj/item/device/analyzer,
		/obj/item/weapon/wirecutters,
	)


/obj/item/storage/toolbox/electrical
	name = "electrical toolbox"
	icon_state = "yellow"
	item_state = "toolbox_yellow"
	preloaded = list(
		/obj/item/weapon/screwdriver,
		/obj/item/weapon/wirecutters,
		/obj/item/device/t_scanner,
		/obj/item/weapon/crowbar,
		/obj/item/stack/cable_coil/random,
		/obj/item/stack/cable_coil/random,
	)

/obj/item/storage/toolbox/electrical/populateContents()
	..()
	if(prob(5))
		PoolOrNew(/obj/item/clothing/gloves/yellow, src)
	else
		PoolOrNew(/obj/item/stack/cable_coil/random, src)


/obj/item/storage/toolbox/syndicate
	name = "black and red toolbox"
	icon_state = "syndicate"
	item_state = "toolbox_syndi"
	origin_tech = list(TECH_COMBAT = 1, TECH_ILLEGAL = 1)
	force = 14
	preloaded = list(
		/obj/item/clothing/gloves/yellow,
		/obj/item/weapon/screwdriver,
		/obj/item/weapon/wrench,
		/obj/item/weapon/weldingtool,
		/obj/item/weapon/crowbar,
		/obj/item/weapon/wirecutters,
		/obj/item/device/multitool,
	)

