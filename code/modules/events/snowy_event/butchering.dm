//_________***BUTCHERING***_________\\

//___*ITEMS*___\\

/obj/item/weapon/head
	name = "head"
	icon = 'icons/obj/snowy_event/butchering_icons.dmi'
	icon_state = "deer_head"

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

/obj/item/weapon/reagent_containers/food/snacks/liver
	name = "liver"
	icon = 'icons/obj/snowy_event/butchering_icons.dmi'
	icon_state = "liver"

/obj/item/weapon/reagent_containers/food/snacks/heart
	name = "heart"
	icon = 'icons/obj/snowy_event/butchering_icons.dmi'
	icon_state = "heart"

/obj/item/weapon/reagent_containers/food/snacks/ribs
	name = "ribs"
	icon = 'icons/obj/snowy_event/butchering_icons.dmi'
	icon_state = "ribs"

/obj/item/weapon/reagent_containers/food/snacks/meat/natural //Real meat. From mother nature to you.
	name = "meat"
	icon = 'icons/obj/snowy_event/butchering_icons.dmi'
	icon_state = "meat"

/obj/item/weapon/reagent_containers/food/snacks/meat/natural/bad
	name = "bad meat"
	icon = 'icons/obj/snowy_event/butchering_icons.dmi'
	icon_state = "meat"

/obj/item/weapon/reagent_containers/food/snacks/meat/natural/hard
	name = "hard meat"
	icon = 'icons/obj/snowy_event/butchering_icons.dmi'
	icon_state = "meat"

//Special animal's external organs
//That's not the same as human organs
/datum/animal_organ
	var/name = "animal's limb"
	var/meat = /obj/item/weapon/reagent_containers/food/snacks/meat/natural
	var/meat_left = 0
	var/tendons_left = 0
	var/has_tendon = 0
	var/has_bones = 0
	var/bones_left = 0
	var/bitted = 0 //if carnivores bites the body
	var/list/internals = list()
	var/cutted = 0
	var/needed_organ //for damage zone selecting and precise butching
	var/part_overlay //some overlays to image the process

/datum/animal_organ/chest
	name = "deer's chest"
	meat_left = 2
	has_bones = 1
	bones_left = 4
	needed_organ = BP_CHEST
	part_overlay = "chest"
	internals = list(/obj/item/weapon/reagent_containers/food/snacks/ribs = 2, /obj/item/weapon/reagent_containers/food/snacks/heart = 1)

/datum/animal_organ/abdomen
	name = "deer's abdomen"
	meat_left = 1
	has_bones = 1
	bones_left = 2
	needed_organ = BP_GROIN
	part_overlay = "groin"
	internals = list(/obj/item/weapon/reagent_containers/food/snacks/liver = 1)

/datum/animal_organ/leg
	name = "deer's right leg"
	meat_left = 1
	has_bones = 1
	bones_left = 1
	has_tendon = 1
	tendons_left = 1
	needed_organ = BP_R_LEG
	part_overlay = "right_leg"

/datum/animal_organ/leg/left_leg
	name = "deer's left leg"
	needed_organ = BP_L_LEG
	part_overlay = "left_leg"

/datum/animal_organ/leg/front_right_leg
	name = "deer's front right leg"
	needed_organ = BP_R_ARM
	part_overlay = "right_front_leg"

/datum/animal_organ/leg/front_left_leg
	name = "deer's front left leg"
	needed_organ = BP_L_ARM
	part_overlay = "left_front_leg"

//This unreliable now. Use it carefully. WIP
//Working on freezing mechanics...
/obj/structure/butcherable
	name = "Corpse"
	desc = "Dead and unskinned body of animal."
	icon = 'icons/obj/snowy_event/butchering_icons.dmi'
	icon_state = ""
	var/sliced = 0 //if body sliced and user can get entrails
	var/has_head = 1
	var/head = /obj/item/weapon/head
	var/skin = 1
	var/list/col = list("r" = 28, "g" = 14, "b" = 6)
	//Well... Maybe do it with datum's tags is better idea than it. Hm. I make it later
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
		overlays += "animal_corpse_deer"
	if(has_head)
		overlays += "animal_corpse_deer_head"

//This looks slightly crappy. Maybe i make it better later
/obj/structure/butcherable/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(W.sharp && (has_head || skin))
		if(has_head)
			if(prob(45))
				user << SPAN_NOTE("You cut off the head of [name].")
				new head(src.loc)
				has_head = 0
			else
				user << SPAN_NOTE("You raise your hand and chop the neck of [name].")
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
					user << SPAN_NOTE("You cut and take some tendon from [A.name]. As you can see, here is [A.tendons_left] left.")
					new /obj/item/weapon/tendon(src.loc)
					if(A.tendons_left <= 0)
						A.has_tendon = 0
					return

				if(W.sharp && A.meat_left && !istype(W, /obj/item/weapon/wirecutters))
					if(A.internals.len > 0)
						if(A.cutted)
							new /obj/item/weapon/reagent_containers/food/snacks/meat/natural/bad(src.loc)
							A.meat_left--
							user << SPAN_WARN("You slice some meat from corpse. Looks like you touch entrails and spoiled the meat.")
							if(A.internals.len > 0 && !A.meat_left)
								for(var/I in A.internals) //Drop entrails if all meat cutted off
									A.internals.Remove(I)
									new I(src.loc)
								sliced = 0
							update_icon()
							return
						else
							A.cutted = 1
							sliced = 1 //for overlay
							user << SPAN_NOTE("You slice open [A.name].")
							update_icon()
							return
					A.meat_left--
					user << SPAN_NOTE("You slice some meat from corpse.")
					if(A.has_tendon)
						new /obj/item/weapon/reagent_containers/food/snacks/meat/natural/hard(src.loc)
					else
						new /obj/item/weapon/reagent_containers/food/snacks/meat/natural(src.loc)
					if(!A.meat_left && A.has_tendon)
						A.has_tendon = 0
						A.tendons_left = 0
				if(istype(W, /obj/item/weapon/wirecutters) && !A.meat_left)
					external_organs.Remove(part)
					qdel(A)
					new /obj/item/weapon/bone(src.loc)
			if(external_organs.len == 0)
				qdel(src)
		update_icon()


/obj/structure/butcherable/attack_hand(var/mob/user as mob) //Extracting organs with grab
	for(var/part_name in external_organs)
		var/datum/animal_organ/organ = external_organs[part_name]
		if(organ.needed_organ == user.zone_sel.selecting && organ.internals.len > 0)
			if(user.a_intent == I_GRAB)
				var/guts = pick(organ.internals)
				var/obj/O = new guts(src.loc)
				organ.internals.Remove(guts)
				user << SPAN_NOTE("You carefull take [O.name] from [organ.name] of [name].")


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

	var/obj/item/weapon/skin/S
	if(get_good_skin)
		S = new /obj/item/weapon/skin
	else
		S = new /obj/item/weapon/skin/bad
	S.icon += rgb(col["r"], col["g"], col["b"])
	S.loc = src.loc
	skin = 0