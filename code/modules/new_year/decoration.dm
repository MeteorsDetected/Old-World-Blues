/obj/item/decoration
	name = "decoration"
	desc = "Winter is coming!"
	icon = 'code/modules/new_year/decorations.dmi'
	icon_state = "santa"
	layer = 4.1

///Garland
/obj/item/decoration/garland
	name = "garland"
	desc = "Beautiful lights! Shinee!"
	icon_state = "garland"
	var/on = 0
	var/brightness = 2

/obj/item/decoration/garland/initialize()
	..()
	if(on)
		icon_state = "[initial(icon_state)]_on"
		set_light(brightness)
	else
		icon_state = initial(icon_state)
		set_light(0)

/obj/item/decoration/garland/New()
	on = 1
	light_color = pick("#FF0000","#6111FF","#FFA500","#44FAFF")
	initialize()

/obj/item/decoration/garland/attack_hand()
	on = !on
	initialize()

///Tinsels
/obj/item/decoration/tinsel
	name = "tinsel"
	desc = "Soft tinsel, pleasant to the touch. Ahhh..."
	icon_state = "tinsel_g"

/obj/item/decoration/tinsel/New()
	icon_state = "tinsel[pick("_g","_r","_y","_w")]"

/obj/item/decoration/tinsel/green
	icon_state = "tinsel_g"
	New()
		return

/obj/item/decoration/tinsel/red
	icon_state = "tinsel_r"
	New()
		return

/obj/item/decoration/tinsel/yellow
	icon_state = "tinsel_y"
	New()
		return

/obj/item/decoration/tinsel/white
	icon_state = "tinsel_w"
	New()
		return
