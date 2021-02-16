/obj/item/device/pipe_painter
	name = "pipe painter"
	icon = 'icons/obj/bureaucracy.dmi'
	icon_state = "labeler1"
	item_state = "flight"
	var/list/modes
	var/mode

/obj/item/device/pipe_painter/initialize()
	. = ..()
	modes = new()
	for(var/C in pipe_colors)
		modes += "[C]"
	mode = pick(modes)
	desc = "It is in [mode] mode."

/obj/item/device/pipe_painter/afterattack(atom/A, mob/user as mob, proximity)
	if(!proximity)
		return

	var/list/restricted_types = list(
		/obj/machinery/atmospherics/pipe/tank,
		/obj/machinery/atmospherics/pipe/vent,
		/obj/machinery/atmospherics/pipe/simple/heat_exchanging,
		/obj/machinery/atmospherics/pipe/simple/insulated,
	)

	if(!user.Adjacent(src) || !istype(A,/obj/machinery/atmospherics/pipe) || is_type_in_list(A,restricted_types))
		return
	var/obj/machinery/atmospherics/pipe/P = A

	var/turf/T = P.loc
	if (P.level < 2 && isturf(T) && T.intact)
		user << "\red You must remove the plating first."
		return

	P.change_color(pipe_colors[mode])

/obj/item/device/pipe_painter/attack_self(mob/user as mob)
	mode = input("Which colour do you want to use?", "Pipe painter", mode) in modes
	desc = "It is in [mode] mode."
