/obj/item/storage/pill_bottle/dice	//7d6
	name = "bag of dice"
	desc = "It's a small bag with dice inside."
	icon = 'icons/obj/dice.dmi'
	icon_state = "dicebag"
	preloaded = list(
		/obj/item/weapon/dice = 7
	)

/obj/item/storage/pill_bottle/dice_nerd	//DnD dice
	name = "bag of gaming dice"
	desc = "It's a small bag with gaming dice inside."
	icon = 'icons/obj/dice.dmi'
	icon_state = "magicdicebag"
	preloaded = list(
		/obj/item/weapon/dice/d4,
		/obj/item/weapon/dice,
		/obj/item/weapon/dice/d8,
		/obj/item/weapon/dice/d10,
		/obj/item/weapon/dice/d12,
		/obj/item/weapon/dice/d20,
		/obj/item/weapon/dice/d100,
	)

/*
 * Donut Box
 */

/obj/item/storage/box/donut
	icon = 'icons/obj/food.dmi'
	icon_state = "donutbox"
	name = "donut box"
	storage_slots = 6
	can_hold = list(/obj/item/weapon/reagent_containers/food/snacks/donut)
	foldable = /obj/item/stack/material/cardboard
	preloaded = list(
		/obj/item/weapon/reagent_containers/food/snacks/donut/normal = 6
	)

/obj/item/storage/box/donut/initialize()
	. = ..()
	update_icon()

/obj/item/storage/box/donut/update_icon()
	overlays.Cut()
	var/i = 0
	for(var/obj/item/weapon/reagent_containers/food/snacks/donut/D in contents)
		var/image/img = image('icons/obj/food.dmi', D.overlay_state)
		img.pixel_x = i * 3
		overlays += img
		i++

/obj/item/storage/box/donut/empty
	preloaded = null
