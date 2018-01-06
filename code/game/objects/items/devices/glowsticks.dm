/obj/item/device/flashlight/glowstick
	name = "green glowstick"
	desc = "A green military-grade glowstick."
	w_class = 2
	brightness_on = 1.5
	light_power = 1
	light_color = "#49F37C"
	icon = 'icons/obj/glowsticks.dmi'
	icon_state = "glowstick"
	item_state = "glowstick"
	var/fuel = 0

/obj/item/device/flashlight/glowstick/New()
	fuel = rand(900, 1200)
	..()

/obj/item/device/flashlight/glowstick/process()
	fuel = max(fuel - 1, 0)
	if(!fuel || !on)
		turn_off()
		if(!fuel)
			src.icon_state = "[initial(icon_state)]-empty"

/obj/item/device/flashlight/glowstick/proc/turn_off()
	on = 0
	update_icon()

/obj/item/device/flashlight/glowstick/attack_self(var/mob/living/user)
/*
	if(((CLUMSY in user.mutations)) && prob(50))
		user << "<span class='notice'>You break \the [src] apart, spilling its contents everywhere!</span>"
		fuel = 0
		new /obj/effect/decal/cleanable/greenglow(get_turf(user))
		user.apply_effect((rand(15,30)),IRRADIATE,blocked = user.getarmor(null, "rad"))
		qdel(src)
		return
*/
	if(!fuel)
		user << "<span class='notice'>\The [src] has already been used.</span>"
		return
	if(on)
		user << "<span class='notice'>\The [src] has already been turned on.</span>"
		return

	. = ..()

	if(.)
		user.visible_message("<span class='notice'>[user] cracks and shakes \the [src].</span>", "<span class='notice'>You crack and shake \the [src], turning it on!</span>")

/obj/item/device/flashlight/glowstick/red
	name = "red glowstick"
	desc = "A red military-grade glowstick."
	light_color = "#FC0F29"
	icon_state = "glowstick_red"
	item_state = "glowstick_red"

/obj/item/device/flashlight/glowstick/blue
	name = "blue glowstick"
	desc = "A blue military-grade glowstick."
	light_color = "#599DFF"
	icon_state = "glowstick_blue"
	item_state = "glowstick_blue"

/obj/item/device/flashlight/glowstick/orange
	name = "orange glowstick"
	desc = "A orange military-grade glowstick."
	light_color = "#FA7C0B"
	icon_state = "glowstick_orange"
	item_state = "glowstick_orange"

/obj/item/device/flashlight/glowstick/yellow
	name = "yellow glowstick"
	desc = "A yellow military-grade glowstick."
	light_color = "#FEF923"
	icon_state = "glowstick_yellow"
	item_state = "glowstick_yellow"