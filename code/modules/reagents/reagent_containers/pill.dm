////////////////////////////////////////////////////////////////////////////////
/// Pills.
////////////////////////////////////////////////////////////////////////////////
/obj/item/weapon/reagent_containers/pill
	name = "pill"
	desc = "A pill."
	icon = 'icons/obj/chemical.dmi'
	icon_state = null
	item_state = "pill"
	randpixel = 7
	possible_transfer_amounts = null
	w_class = ITEM_SIZE_TINY
	slot_flags = SLOT_EARS
	volume = 60
	center_of_mass = list("x"=16, "y"=15)

/obj/item/weapon/reagent_containers/pill/initialize()
	. = ..()
	if(!icon_state)
		icon_state = "pill[rand(1, 20)]"


/obj/item/weapon/reagent_containers/pill/do_surgery(mob/M, mob/user)
	if(user.a_intent != I_HELP) //in case it is ever used as a surgery tool
		return ..()
	attack(M, user) //default surgery behaviour is just to scan as usual
	return 1

/obj/item/weapon/reagent_containers/pill/attack(mob/M as mob, mob/user as mob, def_zone)
	if(standard_feed_mob(user, M))
		qdel(src)
		return 1
	return 0

/obj/item/weapon/reagent_containers/pill/self_feed_message(var/mob/user)
	user << SPAN_NOTE("You swallow \the [src].")

/obj/item/weapon/reagent_containers/pill/other_feed_message_start(var/mob/user, var/mob/target)
	user.visible_message("<span class='warning'>[user] attempts to force [target] to swallow \the [src].</span>")

/obj/item/weapon/reagent_containers/pill/other_feed_message_finish(var/mob/user, var/mob/target)
	user.visible_message("<span class='warning'>[user] forces [target] to swallow \the [src].</span>")

/obj/item/weapon/reagent_containers/pill/afterattack(obj/target, mob/user, proximity)
	if(!proximity) return

	..()

	if(target.is_open_container() && target.reagents)
		if(!target.reagents.total_volume)
			user << SPAN_NOTE("[target] is empty. Can't dissolve \the [src].")
			return
		user << SPAN_NOTE("You dissolve \the [src] in [target].")

		self_attack_log(user, "Spiked \a [key_name(target)] with a pill. Reagents: [reagentlist()]", 1)

		reagents.trans_to(target, reagents.total_volume)
		for(var/mob/O in viewers(2, user))
			O.show_message("<span class='warning'>[user] puts something in \the [target].</span>", 1)

		qdel(src)

	return

////////////////////////////////////////////////////////////////////////////////
/// Pills. END
////////////////////////////////////////////////////////////////////////////////

//Pills
/obj/item/weapon/reagent_containers/pill/antitox
	name = "Anti-toxins pill"
	desc = "Neutralizes many common toxins."
	icon_state = "pill17"
	preloaded = list("anti_toxin" = 25)


/obj/item/weapon/reagent_containers/pill/tox
	name = "Toxins pill"
	desc = "Highly toxic."
	icon_state = "pill5"
	preloaded = list("toxin" = 50)


/obj/item/weapon/reagent_containers/pill/cyanide
	name = "Cyanide pill"
	desc = "Don't swallow this."
	icon_state = "pill5"
	preloaded = list("cyanide" = 50)


/obj/item/weapon/reagent_containers/pill/adminordrazine
	name = "Adminordrazine pill"
	desc = "It's magic. We don't have to explain it."
	icon_state = "pill16"
	preloaded = list("adminordrazine" = 50)

/obj/item/weapon/reagent_containers/pill/stox
	name = "Sleeping pill"
	desc = "Commonly used to treat insomnia."
	icon_state = "pill8"
	preloaded = list("stoxin" = 15)


/obj/item/weapon/reagent_containers/pill/kelotane
	name = "Kelotane pill"
	desc = "Used to treat burns."
	icon_state = "pill11"
	preloaded = list("kelotane" = 15)


/obj/item/weapon/reagent_containers/pill/paracetamol
	name = "Paracetamol pill"
	desc = "Tylenol! A painkiller for the ages. Chewables!"
	icon_state = "pill8"
	preloaded = list("paracetamol" = 15)


/obj/item/weapon/reagent_containers/pill/tramadol
	name = "Tramadol pill"
	desc = "A simple painkiller."
	icon_state = "pill8"
	preloaded = list("tramadol" = 15)


/obj/item/weapon/reagent_containers/pill/methylphenidate
	name = "Methylphenidate pill"
	desc = "Improves the ability to concentrate."
	icon_state = "pill8"
	preloaded = list("methylphenidate" = 15)


/obj/item/weapon/reagent_containers/pill/citalopram
	name = "Citalopram pill"
	desc = "Mild anti-depressant."
	icon_state = "pill8"
	preloaded = list("citalopram" = 15)


/obj/item/weapon/reagent_containers/pill/inaprovaline
	name = "Inaprovaline pill"
	desc = "Used to stabilize patients."
	icon_state = "pill20"
	preloaded = list("inaprovaline" = 30)


/obj/item/weapon/reagent_containers/pill/dexalin
	name = "Dexalin pill"
	desc = "Used to treat oxygen deprivation."
	icon_state = "pill16"
	preloaded = list("dexalin" = 15)


/obj/item/weapon/reagent_containers/pill/dexalin_plus
	name = "Dexalin Plus pill"
	desc = "Used to treat extreme oxygen deprivation."
	icon_state = "pill8"
	preloaded = list("dexalinp" = 15)


/obj/item/weapon/reagent_containers/pill/dermaline
	name = "Dermaline pill"
	desc = "Used to treat burn wounds."
	icon_state = "pill12"
	preloaded = list("dermaline" = 15)


/obj/item/weapon/reagent_containers/pill/dylovene
	name = "Dylovene pill"
	desc = "A broad-spectrum anti-toxin."
	icon_state = "pill13"
	preloaded = list("anti_toxin" = 15)


/obj/item/weapon/reagent_containers/pill/inaprovaline
	name = "Inaprovaline pill"
	desc = "Used to stabilize patients."
	icon_state = "pill20"
	preloaded = list("inaprovaline" = 30)


/obj/item/weapon/reagent_containers/pill/bicaridine
	name = "Bicaridine pill"
	desc = "Used to treat physical injuries."
	icon_state = "pill18"
	preloaded = list("bicaridine" = 20)


/obj/item/weapon/reagent_containers/pill/happy
	name = "Happy pill"
	desc = "Happy happy joy joy!"
	icon_state = "pill18"
	preloaded = list("space_drugs" = 15, "sugar" = 15)


/obj/item/weapon/reagent_containers/pill/zoom
	name = "Zoom pill"
	desc = "Zoooom!"
	icon_state = "pill18"
	preloaded = list("impedrezene" = 10, "synaptizine" = 5, "hyperzine" = 5)


/obj/item/weapon/reagent_containers/pill/spaceacillin
	name = "Spaceacillin pill"
	desc = "Contains antiviral agents."
	icon_state = "pill19"
	preloaded = list("spaceacillin" = 15)
