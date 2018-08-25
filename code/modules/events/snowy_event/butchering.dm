//Maked special for snowy event.
//TODO-list:
//Make small corpses for little animals
//Make custom stages of butching and refact this?..


//_________***BUTCHERING***_________\\

//___*ITEMS*___\\

/obj/item/weapon/head
	name = "deer's head"
	icon = 'icons/obj/snowy_event/butchering_icons.dmi'
	icon_state = "deer_head"


/obj/item/weapon/head/wolf
	name = "wolf's head"
	icon = 'icons/obj/snowy_event/butchering_icons.dmi'
	icon_state = "wolf_head"


//check sewing.dm for skin's attackby
/obj/item/weapon/skin
	name = "skin"
	icon = 'icons/obj/snowy_event/butchering_icons.dmi'
	icon_state = "skin"

/obj/item/weapon/skin/bad
	name = "bad skin"
	icon = 'icons/obj/snowy_event/butchering_icons.dmi'
	icon_state = "bad_skin"

/obj/item/weapon/tendon
	name = "tendon"
	icon = 'icons/obj/snowy_event/butchering_icons.dmi'
	icon_state = "tendon"

/obj/item/weapon/bone
	name = "bone"
	icon = 'icons/obj/snowy_event/butchering_icons.dmi'
	icon_state = "bone"
	var/list/carvable_stuff = list("Fishing hook" = /obj/item/weapon/hook/boned,
									"Sewing needle" = /obj/item/weapon/needle)


/obj/item/weapon/bone/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(W.sharp)
		var/choosed = input(user, "Carve what?") in carvable_stuff
		if (choosed)
			user << SPAN_NOTE("You carve [choosed] from the bone.")
			var/obj/C = carvable_stuff[choosed]
			new C(user.loc)
			qdel(src)

/obj/item/weapon/reagent_containers/food/snacks/ingredient/liver
	name = "liver"
	icon = 'icons/obj/snowy_event/butchering_icons.dmi'
	icon_state = "liver"
	reagents_to_vaporize = list("toxin", "blood")
	New()
		..()
		reagents.add_reagent("protein", 15)
		reagents.add_reagent("toxin", 5)
		reagents.add_reagent("blood", 10)


/obj/item/weapon/reagent_containers/food/snacks/ingredient/heart
	name = "heart"
	icon = 'icons/obj/snowy_event/butchering_icons.dmi'
	icon_state = "heart"
	reagents_to_vaporize = list("blood")
	New()
		..()
		reagents.add_reagent("protein", 30)
		reagents.add_reagent("tramadol", 15)
		reagents.add_reagent("blood", 10)


/obj/item/weapon/reagent_containers/food/snacks/ingredient/ribs
	name = "ribs"
	icon = 'icons/obj/snowy_event/butchering_icons.dmi'
	icon_state = "ribs"
	reagents_to_vaporize = list("blood")
	New()
		..()
		reagents.add_reagent("protein", 15)
		reagents.add_reagent("blood", 10)


/obj/item/weapon/reagent_containers/food/snacks/ingredient/meat/natural //Real meat. From mother nature to you
	name = "meat"
	icon = 'icons/obj/snowy_event/butchering_icons.dmi'
	icon_state = "meat"
	reagents_to_vaporize = list("blood")
	New()
		..()
		reagents.add_reagent("protein", 25)
		reagents.add_reagent("blood", 15)


/obj/item/weapon/reagent_containers/food/snacks/ingredient/meat/natural/bad
	name = "bad meat"
	icon = 'icons/obj/snowy_event/butchering_icons.dmi'
	icon_state = "meat"
	New()
		..()
		reagents.add_reagent("toxin", 20)


/obj/item/weapon/reagent_containers/food/snacks/ingredient/meat/natural/hard
	name = "hard meat"
	icon = 'icons/obj/snowy_event/butchering_icons.dmi'
	icon_state = "meat"



//___*ORGANS*___\\

//Special animal's external organs
//That's not the same as human organs
/datum/animal_organ
	var/name = "animal's limb"
	var/meat_left = 0
	var/tendons_left = 0
	var/has_tendon = 0
	var/has_bones = 0
	var/bones_left = 0
	var/bitted = 0 //if carnivores bites the body
	var/cutted = 0
	var/needed_organ //for damage zone selecting and precise butching
	var/part_overlay //some overlays to image the process
	var/list/internals = list()

/datum/animal_organ/chest
	name = "chest"
	meat_left = 2
	has_bones = 1
	bones_left = 4
	needed_organ = BP_CHEST
	part_overlay = "chest"
	internals = list(/obj/item/weapon/reagent_containers/food/snacks/ingredient/ribs = 2, /obj/item/weapon/reagent_containers/food/snacks/ingredient/heart = 1)

/datum/animal_organ/abdomen
	name = "abdomen"
	meat_left = 1
	has_bones = 1
	bones_left = 2
	needed_organ = BP_GROIN
	part_overlay = "groin"
	internals = list(/obj/item/weapon/reagent_containers/food/snacks/ingredient/liver = 1)

/datum/animal_organ/leg
	name = "right leg"
	meat_left = 1
	has_bones = 1
	bones_left = 1
	has_tendon = 1
	tendons_left = 1
	needed_organ = BP_R_LEG
	part_overlay = "right_leg"

/datum/animal_organ/leg/left_leg
	name = "left leg"
	needed_organ = BP_L_LEG
	part_overlay = "left_leg"

/datum/animal_organ/leg/front_right_leg
	name = "front right leg"
	needed_organ = BP_R_ARM
	part_overlay = "right_front_leg"

/datum/animal_organ/leg/front_left_leg
	name = "front left leg"
	needed_organ = BP_L_ARM
	part_overlay = "left_front_leg"


//___*CORPSES*___\\

//This unreliable now. Use it carefully. WIP
//Freezing mechanics needed. Hmmm
//If you want to make your own corpse of animal, you need set organs or create new one, change sprite of body, set sprite of head
//And set head of animal. Don't forget about tendons and meat.
/obj/structure/butcherable
	name = "Corpse"
	desc = "Dead and unskinned body of animal."
	icon = 'icons/obj/snowy_event/butchering_icons.dmi'
	icon_state = ""
	var/sliced = 0 //if body sliced and user can get entrails
	var/has_head = 1
	var/head = /obj/item/weapon/head
	var/head_overlay = "animal_corpse_deer_head"
	var/skin_overlay = "animal_corpse_deer"
	var/mob/living/animal
	var/meat_type = /obj/item/weapon/reagent_containers/food/snacks/ingredient/meat/natural
	var/skin = 1
	var/list/col = list("r" = 28, "g" = 14, "b" = 6) //color of the skin
	//Well... Maybe do it with datum's tags is better idea than it. Hm. Maybe.
	var/list/external_organs = list("chest" = /datum/animal_organ/chest,
									"abdomen" = /datum/animal_organ/abdomen,
									"right leg" = /datum/animal_organ/leg,
									"left leg" = /datum/animal_organ/leg/left_leg,
									"front right leg" = /datum/animal_organ/leg/front_right_leg,
									"front left leg" = /datum/animal_organ/leg/front_left_leg
									)
	var/list/cut_to_unskin = list("right leg", "left leg", "front right leg", "front left leg")

	New()
		for(var/part in external_organs)
			var/part_path = external_organs[part]
			var/datum/animal_organ/organ = new part_path(src)
			external_organs[part] = organ

		update_icon()


/obj/structure/butcherable/examine(mob/user as mob)
	..()
	if(istype(user, /mob/living/carbon))
		for(var/part in external_organs)
			var/datum/animal_organ/O = external_organs[part]
			if(O.needed_organ == user.zone_sel.selecting)
				if(!skin && O.meat_left && O.tendons_left)
					user << SPAN_NOTE("You look at unskinned animal's part and see [O.tendons_left] tendons here.")


/obj/structure/butcherable/update_icon()
	overlays.Cut()
	if(!skin)
		for(var/p in external_organs)
			var/datum/animal_organ/P = external_organs[p]
			overlays += "skeleton-[P.part_overlay]"
			if(P.meat_left)
				overlays += "unskinned-[P.part_overlay]"
		if(sliced)
			overlays += "corpse_opened"
	else
		icon = initial(icon) //reset color
		icon += rgb(col["r"], col["g"], col["b"])
		overlays += skin_overlay
	if(has_head)
		overlays += head_overlay


//This looks slightly crappy. Maybe i make it better later
/obj/structure/butcherable/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(W.sharp && (has_head || skin) && !istype(W, /obj/item/weapon/wirecutters))
		if(has_head)
			if(prob(45))
				user.visible_message(
						SPAN_NOTE("<b>[user] cuts off the head of [name].</b>"),
						SPAN_NOTE("<b>You cut off the head of [name].</b>")
					)
				new head(src.loc)
				has_head = 0
			else
				user.visible_message(
						SPAN_NOTE("[user] raises them hand and chop the neck of [name]."),
						SPAN_NOTE("You raise your hand and chop the neck of [name].")
					)
		else
			if(skin)
				unskin(W, user)
				icon = initial(icon) //And we reset colors after unskin
		update_icon()

	else if(W.sharp || istype(W, /obj/item/weapon/wirecutters) && !has_head && !skin)
		for(var/part in external_organs)
			var/datum/animal_organ/A = external_organs[part]
			if(A.needed_organ == user.zone_sel.selecting)
				if(A.has_tendon && istype(W, /obj/item/weapon/wirecutters))
					A.tendons_left--
					user << SPAN_NOTE("You carve and take some tendon from [A.name].")
					new /obj/item/weapon/tendon(src.loc)
					if(A.tendons_left <= 0)
						A.has_tendon = 0
					return

				if(A.meat_left)
					if(W.sharp && !istype(W, /obj/item/weapon/wirecutters))
						cutMeat(W, user, A)
					else
						user << SPAN_WARN("You need something sharp.")

				if(!A.meat_left)
					if(istype(W, /obj/item/weapon/wirecutters))
						external_organs.Remove(part)
						qdel(A)
						new /obj/item/weapon/bone(src.loc)
					else
						user << SPAN_WARN("You need wirecutters or something like this to extract bones.")

			if(external_organs.len == 0)
				qdel(src)
		update_icon()


/obj/structure/butcherable/attack_hand(var/mob/user as mob) //Extracting organs with grab
	for(var/part_name in external_organs)
		var/datum/animal_organ/organ = external_organs[part_name]
		if(organ.needed_organ == user.zone_sel.selecting && organ.internals.len > 0)
			if(user.a_intent == I_GRAB)
				var/guts = pick(organ.internals)
				var/obj/O
				for(var/i = 1, i<=organ.internals[guts], i++)
					O = new guts(src.loc)
				organ.internals.Remove(guts)
				user << SPAN_NOTE("You carefull take [O.name] from [organ.name] of [name].")


/obj/structure/butcherable/proc/cutMeat(obj/item/weapon/W as obj, mob/user as mob, var/datum/animal_organ/A)
	if(A.internals.len > 0)
		if(A.cutted)
			new /obj/item/weapon/reagent_containers/food/snacks/ingredient/meat/natural/bad(src.loc)
			A.meat_left--
			user.visible_message(
					SPAN_WARN("[user] cut away meat from [name], but touched entrails and spoiled the meat!"),
					SPAN_WARN("You cut away some meat from [name]. Looks like you touch entrails and spoiled the meat!")
				)
			if(A.internals.len > 0 && !A.meat_left)
				for(var/I in A.internals) //Drop entrails if all meat cutted away
					A.internals.Remove(I)
					for(var/i = 1, i<=A.internals[I], i++)
						new I(src.loc)
			if(!A.meat_left)
				sliced = 0
			update_icon()
			return
		else
			A.cutted = 1
			sliced = 1 //for overlay
			user.visible_message(
					SPAN_NOTE("[user] sliced open [src.name]'s [A.name]."),
					SPAN_NOTE("You slice open [src.name]'s [A.name].")
				)
			update_icon()
			return
	A.meat_left--
	user << SPAN_NOTE("You cut away some meat from [name].")
	if(A.has_tendon)
		new /obj/item/weapon/reagent_containers/food/snacks/ingredient/meat/natural/hard(src.loc)
	else
		new meat_type(src.loc)

	if(!A.meat_left && A.has_tendon)
		A.has_tendon = 0
		A.tendons_left = 0


/obj/structure/butcherable/proc/unskin(obj/item/weapon/W as obj, mob/user as mob)
	var/get_good_skin = 1
	for(var/part_name in cut_to_unskin)
		var/datum/animal_organ/part = external_organs[part_name]
		if(part.needed_organ == user.zone_sel.selecting)
			if(part.cutted)
				user << SPAN_NOTE("Part already is undercutted.")
			else
				user << SPAN_NOTE("You undercut the [part_name].")
				part.cutted = 1
			return
		if(!part.cutted)
			get_good_skin = 0

	user << SPAN_NOTE("You careful flay the skin...")
	if(do_after(user, 50))
		var/obj/item/weapon/skin/S
		if(get_good_skin)
			S = new /obj/item/weapon/skin
		else
			S = new /obj/item/weapon/skin/bad
		S.icon += rgb(col["r"], col["g"], col["b"])
		S.loc = src.loc
		skin = 0
	else
		user << SPAN_WARN("You need to stay still to do this.")



/obj/structure/butcherable/wolf
	name = "Wolf's corpse"
	desc = "Dead and unskinned body of wolf."
	icon = 'icons/obj/snowy_event/butchering_icons.dmi'
	head = /obj/item/weapon/head/wolf
	head_overlay = "animal_corpse_wolf_head"
	skin_overlay = "animal_corpse_deer"
	meat_type = /obj/item/weapon/reagent_containers/food/snacks/ingredient/meat/natural
	skin = 1
	col = list("r" = 15, "g" = 15, "b" = 15)

