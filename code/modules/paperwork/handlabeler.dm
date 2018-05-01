/obj/item/weapon/hand_labeler
	name = "hand labeler"
	icon = 'icons/obj/bureaucracy.dmi'
	icon_state = "labeler0"
	item_state = "flight"
	var/label = null
	var/labels_left = 30
	var/mode = 0	//off or on.

/obj/item/weapon/hand_labeler/attack()
	return

/obj/item/weapon/hand_labeler/get_storage_cost()
	if(mode)
		return ITEM_SIZE_NO_CONTAINER
	else
		return ..()

/obj/item/weapon/hand_labeler/afterattack(atom/A, mob/user as mob, proximity)
	if(!proximity)
		return
	if(!mode)	//if it's off, give up.
		return
	if(A == loc)	// if placing the labeller into something (e.g. backpack)
		return		// don't set a label

	if(!labels_left)
		user << SPAN_NOTE("No labels left.")
		return
	if(!label || !length(label))
		user << SPAN_NOTE("No text set.")
		return
	if(length(A.name) + length(label) > 64)
		user << SPAN_NOTE("Label too big.")
		return
	if(ishuman(A))
		user << SPAN_NOTE("The label refuses to stick to [A.name].")
		return
	if(issilicon(A))
		user << SPAN_NOTE("The label refuses to stick to [A.name].")
		return
	if(isobserver(A))
		user << SPAN_NOTE("[src] passes through [A.name].")
		return
	if(istype(A, /obj/item/weapon/reagent_containers/glass))
		user << SPAN_NOTE("The label can't stick to the [A.name].  (Try using a pen)")
		return
	if(istype(A, /obj/machinery/portable_atmospherics/hydroponics))
		var/obj/machinery/portable_atmospherics/hydroponics/tray = A
		if(!tray.mechanical)
			user << SPAN_NOTE("How are you going to label that?")
			return
		tray.labelled = label
		spawn(1)
			tray.update_icon()

	user.visible_message(SPAN_NOTE("[user] labels [A] as [label]."), \
						 SPAN_NOTE("You label [A] as [label]."))
	A.name = "[A.name] ([label])"

/obj/item/weapon/hand_labeler/attack_self(mob/user as mob)
	mode = !mode
	icon_state = "labeler[mode]"
	if(mode)
		user << SPAN_NOTE("You turn on \the [src].")
		//Now let them chose the text.
		var/str = sanitizeSafe(input(user,"Label text?","Set label",""), MAX_NAME_LEN)
		if(!str || !length(str))
			user << SPAN_NOTE("Invalid text.")
			return
		label = str
		user << SPAN_NOTE("You set the text to '[str]'.")
	else
		user << SPAN_NOTE("You turn off \the [src].")