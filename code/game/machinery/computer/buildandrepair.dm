//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:31

#define SECURED 1

/obj/structure/computerframe
	density = 1
	anchored = 0
	name = "computer frame"
	icon = 'icons/obj/stock_parts.dmi'
	icon_state = "0"
	var/state = 0
	var/frame_type = FRAME_COMPUTER
	var/obj/item/weapon/circuitboard/circuit = null
	var/obj/item/stack/material/glass = null
	var/obj/item/stack/cable_coil/wire = null

/obj/structure/computerframe/laptop
	frame_type = FRAME_LAPTOP
	icon_state = "laptop"

/obj/structure/computerframe/New()
	..()
	update_icon()

/obj/structure/computerframe/update_icon()
	var/frame = "computer"
	if(frame_type == FRAME_LAPTOP)
		density = FALSE
		pass_flags |= PASSTABLE
		frame = "laptop"
	else
		density = TRUE
		pass_flags &= ~PASSTABLE

	icon_state = frame

	overlays.Cut()
	if(wire)
		overlays += "[frame]_wire"
	if(circuit)
		if(state&SECURED)
			overlays += "[frame]_secured"
		else
			overlays += "[frame]_circuit"
	if(glass)
		overlays += "[frame]_glass"


/obj/structure/computerframe/attackby(obj/item/P as obj, mob/user as mob)
	if(!circuit)
		if(istype(P, /obj/item/weapon/weldingtool))
			var/obj/item/weapon/weldingtool/WT = P
			if(!WT.remove_fuel(0, user))
				user << "The welding tool must be on to complete this task."
				return
			playsound(src.loc, 'sound/items/Welder.ogg', 50, 1)
			if(do_after(user, 20, src))
				if(!src || !WT.isOn()) return
				user << SPAN_NOTE("You deconstruct the frame.")
				new /obj/item/stack/material/steel( src.loc, 5 )
				qdel(src)

		else if(istype(P, /obj/item/weapon/wrench))
			playsound(src.loc, 'sound/items/Ratchet.ogg', 50, 1)
			if(do_after(user, 20, src))
				src.anchored = !src.anchored
				if(anchored)
					user << SPAN_NOTE("You wrench the frame into place.")
				else
					user << SPAN_NOTE("You unfasten the frame.")
		else if(istype(P, /obj/item/weapon/circuitboard) && !circuit)
			var/obj/item/weapon/circuitboard/B = P
			if(B.board_type == "computer")
				playsound(src.loc, 'sound/items/Deconstruct.ogg', 50, 1)
				user << SPAN_NOTE("You place the circuit board inside the frame.")
				src.circuit = P
				user.unEquip(P, src)
			else
				user << SPAN_WARN("This frame does not accept circuit boards of this type!")

	else // circuit exist
		if(glass)
			if(istype(P, /obj/item/weapon/crowbar))
				playsound(src.loc, 'sound/items/Crowbar.ogg', 50, 1)
				user << SPAN_NOTE("You remove the glass panel.")
				glass.forceMove(loc)
				glass = null

			if(istype(P, /obj/item/weapon/screwdriver))
				playsound(src.loc, 'sound/items/Screwdriver.ogg', 50, 1)
				user << SPAN_NOTE("You connect the monitor.")
				var/obj/machinery/computer/B = new src.circuit.build_path(src.loc)
				B.circuit = circuit
				circuit = null
				B.circuit.construct(B)
				B.frame = frame_type
				B.update_icon()
				qdel(src)
				return
		else // No glass

			if(wire)
				if(istype(P, /obj/item/weapon/wirecutters))
					playsound(src.loc, 'sound/items/Wirecutter.ogg', 50, 1)
					user << SPAN_NOTE("You remove the cables.")
					wire.forceMove(loc)
					wire = null
			else
				if(istype(P, /obj/item/stack/cable_coil))
					var/obj/item/stack/cable_coil/C = P
					if (C.get_amount() < 5)
						user << SPAN_WARN("You need five coils of wire to add them to the frame.")
						return
					user << SPAN_NOTE("You start to add cables to the frame.")
					playsound(src.loc, 'sound/items/Deconstruct.ogg', 50, 1)
					if(do_after(user, 20, src) && !wire)
						if(C.get_amount() >= 5)
							wire = C.split(5)
							user << SPAN_NOTE("You add cables to the frame.")

			if(istype(P, /obj/item/weapon/screwdriver))
				playsound(src.loc, 'sound/items/Screwdriver.ogg', 50, 1)
				if(state&SECURED)
					state &= ~SECURED
					user << SPAN_NOTE("You unfasten the circuit board.")
				else
					state |= SECURED
					user << SPAN_NOTE("You screw the circuit board into place.")
			else if(istype(P, /obj/item/weapon/crowbar))
				playsound(src.loc, 'sound/items/Crowbar.ogg', 50, 1)
				user << SPAN_NOTE("You remove the circuit board.")
				src.circuit.forceMove(src.loc)
				src.circuit = null

			else if(ismaterial(P) && P.get_material_name() == MATERIAL_GLASS)
				var/obj/item/stack/G = P
				if (G.get_amount() < 2)
					user << SPAN_WARN("You need two sheets of glass to put in the glass panel.")
					return
				playsound(src.loc, 'sound/items/Deconstruct.ogg', 50, 1)
				user << SPAN_NOTE("You start to put in the glass panel.")
				if(do_after(user, 20, src))
					if(G.get_amount() >= 2)
						glass = G.split(2)
						user << SPAN_NOTE("You put in the glass panel.")
	update_icon()


/obj/structure/computerframe/deconstruct
	anchored = TRUE
	state = SECURED

/obj/structure/computerframe/deconstruct/New(loc, obj/machinery/computer/Computer)
	wire = new(src, 5)
	if(!istype(Computer))
		return
	circuit = Computer.circuit
	circuit.forceMove(src)
	circuit.deconstruct(Computer)
	Computer.circuit = null
	frame_type = Computer.frame
	if(istype(Computer) && !Computer.stat|BROKEN)
		glass = new /obj/item/stack/material/glass(src, 2)
	..()