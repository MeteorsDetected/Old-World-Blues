/obj/structure/table/rack
	name = "rack"
	desc = "Different from the Middle Ages version."
	icon = 'icons/obj/objects.dmi'
	icon_state = "rack"
	can_plate = 0
	can_reinforce = 0
	flipped = -1

/obj/structure/table/rack/initialize()
	. = ..()
	verbs -= /obj/structure/table/verb/do_flip
	verbs -= /obj/structure/table/proc/do_put
	auto_align()

/obj/structure/table/rack/update_connections()
	return

/obj/structure/table/rack/update_icon()
	return

/obj/structure/table/rack/holorack/dismantle(obj/item/weapon/wrench/W, mob/user)
	user << SPAN_WARN("You cannot dismantle \the [src].")
	return
