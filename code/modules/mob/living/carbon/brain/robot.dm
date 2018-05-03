/obj/item/device/mmi/digital/robot
	name = "robotic intelligence circuit"
	desc = "The pinnacle of artifical intelligence which can be achieved using classical computer science."
	icon = 'icons/obj/module.dmi'
	icon_state = "mainboard"
	w_class = ITEM_SIZE_NORMAL
	origin_tech = list(TECH(T_ENGINEERING) = 4, TECH(T_MATERIAL) = 3, TECH(T_DATA) = 4)

/obj/item/device/mmi/digital/robot/initialize()
	. = ..()
	src.brainmob.name = "[pick(list("ADA","DOS","GNU","MAC","WIN"))]-[rand(1000, 9999)]"
	src.brainmob.real_name = src.brainmob.name

/obj/item/device/mmi/digital/robot/update_icon()
	return

/obj/item/device/mmi/digital/robot/transfer_identity(var/mob/living/carbon/H)
	..()
	if(brainmob.mind)
		brainmob.mind.assigned_role = "Robotic Intelligence"
	brainmob << "<span class='notify'>You feel slightly disoriented. That's normal when you're little more than a complex circuit.</span>"
	return
