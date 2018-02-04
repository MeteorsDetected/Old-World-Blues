/obj/item/clothing/under/shorts
	name = "athletic shorts"
	desc = "95% Polyester, 5% Spandex!"
	gender = PLURAL
	body_parts_covered = LOWER_TORSO
	var/item_color = "black"

/obj/item/clothing/under/shorts/initialize()
	name = "[item_color] [name]"
	item_state = item_color

/obj/item/clothing/under/shorts/red
	icon_state = "redshorts"
	item_color = "red"

/obj/item/clothing/under/shorts/green
	icon_state = "greenshorts"
	item_color = "green"

/obj/item/clothing/under/shorts/blue
	icon_state = "blueshorts"
	item_color = "blue"

/obj/item/clothing/under/shorts/grey
	icon_state = "greyshorts"
	item_color = "grey"


/*
 * Skrits
 */

/obj/item/clothing/miniskirt
	name = "swept skirt"
	desc = "A skirt that is swept to one side."
	icon_state = "skirt_swept"

/obj/item/clothing/miniskirt/black
	name = "short black skirt"
	desc = "A skirt that is a shiny black."
	icon_state = "skirt_short_black"

/obj/item/clothing/miniskirt/blue
	name = "short blue skirt"
	desc = "A skirt that is a shiny blue."
	icon_state = "skirt_short_blue"

/obj/item/clothing/miniskirt/red
	name = "short red skirt"
	desc = "A skirt that is a shiny red."
	icon_state = "skirt_short_red"

/obj/item/clothing/miniskirt/khaki
	name = "khaki skirt"
	desc = "A skirt that is a khaki color."
	icon_state = "skirt_khaki"

