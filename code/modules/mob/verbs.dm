// mob verbs are faster than object verbs.
// See http://www.byond.com/forum/?post=1326139&page=2#comment8198716 for why this isn't atom/verb/examine()
/mob/verb/examinate(atom/A as mob|obj|turf in view())
	set name = "Examine"
	set category = "IC"

	if((is_blind(src) || usr.stat) && !isobserver(src))
		src << SPAN_NOTE("Something is there but you can't see it.")
		return 1

	face_atom(A)
	A.examine(src)

/mob/verb/pointed(atom/A as mob|obj|turf in view())
	set name = "Point To"
	set category = "Object"

	if(!src || !isturf(src.loc) || !(A in view(src.loc)))
		return 0
	if(istype(A, /obj/effect/decal/point))
		return 0

	var/tile = get_turf(A)
	if (!tile)
		return 0

	var/obj/P = new /obj/effect/decal/point(tile)
	P.invisibility = invisibility
	spawn (20)
		if(P)
			qdel(P)	// qdel

	face_atom(A)
	return 1


/mob/verb/cancel_camera()
	set name = "Cancel Camera View"
	set category = "OOC"
	unset_machine()
	reset_view(null)


/mob/verb/mode()
	set name = "Activate Held Object"
	set category = "Object"
	set src = usr

	if(istype(loc,/obj/mecha)) return

	if(hand)
		var/obj/item/W = l_hand
		if (W)
			W.attack_self(src)
			update_inv_l_hand()
	else
		var/obj/item/W = r_hand
		if (W)
			W.attack_self(src)
			update_inv_r_hand()
	return


/mob/verb/memory()
	set name = "Notes"
	set category = "IC"
	if(mind)
		mind.show_memory(src)
	else
		src << "The game appears to have misplaced your mind datum, so we can't show you your notes."

/mob/verb/add_memory(msg as message)
	set name = "Add Note"
	set category = "IC"

	msg = sanitize(msg)

	if(mind)
		mind.store_memory(msg)
	else
		src << "The game appears to have misplaced your mind datum, so we can't show you your notes."


/mob/verb/stop_pulling()

	set name = "Stop Pulling"
	set category = "IC"

	if(pulling)
		pulling.pulledby = null
		pulling = null
		if(pullin)
			pullin.icon_state = "pull0"

/mob/proc/yank_out_object()
	set category = "Object"
	set name = "Yank out object"
	set desc = "Remove an embedded item at the cost of bleeding and pain."
	set src in view(1)

	if(!ishuman(usr) || !usr.canClick() || !Adjacent(usr))
		return
	usr.setClickCooldown(20)

	if(usr.stat)
		usr << "You are unconcious and cannot do that!"
		return

	if(usr.restrained())
		usr << "You are restrained and cannot do that!"
		return

	var/mob/S = src
	var/mob/U = usr
	var/list/valid_objects = list()
	var/self = null

	if(S == U)
		self = 1 // Removing object from yourself.

	valid_objects = get_visible_implants(0)
	if(!valid_objects.len)
		if(self)
			src << "You have nothing stuck in your body that is large enough to remove."
		else
			U << "[src] has nothing stuck in their wounds that is large enough to remove."
		return

	var/obj/item/weapon/selection = input("What do you want to yank out?", "Embedded objects") in valid_objects

	if(self)
		src << "<span class='warning'>You attempt to get a good grip on [selection] in your body.</span>"
	else
		U << "<span class='warning'>You attempt to get a good grip on [selection] in [S]'s body.</span>"

	if(!do_after(U, 30))
		return
	if(!selection || !S || !U)
		return

	if(self)
		visible_message("<span class='warning'><b>[src] rips [selection] out of their body.</b></span>","<span class='warning'><b>You rip [selection] out of your body.</b></span>")
	else
		visible_message("<span class='warning'><b>[usr] rips [selection] out of [src]'s body.</b></span>","<span class='warning'><b>[usr] rips [selection] out of your body.</b></span>")
	valid_objects = get_visible_implants(0)
	if(valid_objects.len == 1) //Yanking out last object - removing verb.
		src.verbs -= /mob/proc/yank_out_object

	if(ishuman(src))
		var/mob/living/carbon/human/H = src
		var/obj/item/organ/external/affected

		for(var/obj/item/organ/external/organ in H.organs) //Grab the organ holding the implant.
			for(var/obj/item/O in organ.implants)
				if(O == selection)
					affected = organ

		affected.implants -= selection
		H.shock_stage+=20
		affected.take_damage((selection.w_class * 3), 0, 0, 1, "Embedded object extraction")

		if(prob(selection.w_class * 5)) //I'M SO ANEMIC I COULD JUST -DIE-.
			var/datum/wound/internal_bleeding/I = new (min(selection.w_class * 5, 15))
			affected.wounds += I
			H.custom_pain("Something tears wetly in your [affected] as [selection] is pulled free!", 1)

		if (ishuman(U))
			var/mob/living/carbon/human/human_user = U
			human_user.bloody_hands(H)

	U.put_in_hands(selection)

	for(var/obj/item/weapon/O in pinned)
		if(O == selection)
			pinned -= O
		if(!pinned.len)
			anchored = 0
	return 1

