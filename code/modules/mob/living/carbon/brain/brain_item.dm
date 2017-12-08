/obj/item/organ/internal/brain
	name = "brain"
	health = 400 //They need to live awhile longer than other organs.
	desc = "A piece of juicy meat found in a person's head."
	organ_tag = O_BRAIN
	parent_organ = BP_HEAD
	vital = 1
	icon_state = "brain2"
	force = 1.0
	w_class = ITEM_SIZE_SMALL
	throwforce = 1.0
	throw_speed = 3
	throw_range = 5
	origin_tech = list(TECH_BIO = 3)
	attack_verb = list("attacked", "slapped", "whacked")
	var/mob/living/carbon/brain/brainmob = null

/obj/item/organ/internal/pariah_brain
	name = "brain remnants"
	desc = "Did someone tread on this? It looks useless for cloning or cyborgification."
	organ_tag = O_BRAIN
	parent_organ = BP_HEAD
	icon = 'icons/mob/alien.dmi'
	icon_state = "chitin"
	vital = 1

/obj/item/organ/internal/brain/xeno
	name = "thinkpan"
	desc = "It looks kind of like an enormous wad of purple bubblegum."
	icon = 'icons/mob/alien.dmi'
	icon_state = "chitin"

/obj/item/organ/internal/brain/New()
	..()
	health = config.default_brain_health
	spawn(5)
		create_reagents(10)
		if(brainmob && brainmob.client)
			brainmob.client.screen.len = null //clear the hud

/obj/item/organ/internal/brain/Destroy()
	if(brainmob)
		qdel(brainmob)
		brainmob = null
	..()

/obj/item/organ/internal/brain/proc/transfer_identity(var/mob/living/carbon/H)
	name = "\the [H]'s [initial(src.name)]"
	brainmob = new(src)
	brainmob.name = H.real_name
	brainmob.real_name = H.real_name
	brainmob.dna = H.dna.Clone()
	brainmob.timeofhostdeath = H.timeofdeath
	if(H.mind)
		H.mind.transfer_to(brainmob)

	brainmob << SPAN_NOTE("You feel slightly disoriented. That's normal when you're just a [initial(src.name)].")
	callHook("debrain", list(brainmob))

	for(var/datum/language/L in H.languages)
		brainmob.add_language(L.name)

/obj/item/organ/internal/brain/examine(mob/user, return_dist) // -- TLE
	.=..(user)
	if(brainmob && brainmob.client)//if thar be a brain inside... the brain.
		user << "You can feel the small spark of life still left in this one."
	else
		user << "This one seems particularly lifeless. Perhaps it will regain some of its luster later.."

/obj/item/organ/internal/brain/removed(var/mob/living/user)

	name = "[owner.real_name]'s brain"

	var/mob/living/simple_animal/borer/borer = owner.has_brain_worms()

	if(borer)
		borer.detatch() //Should remove borer if the brain is removed - RR

	if(istype(owner))
		transfer_identity(owner)

	..()

/obj/item/organ/internal/brain/install(var/mob/living/target)

	if(brainmob)
		if(target.key)
			target.ghostize()
		if(brainmob.mind)
			brainmob.mind.transfer_to(target)
		else
			target.key = brainmob.key
	..()

/obj/item/organ/internal/brain/slime
	name = "slime core"
	desc = "A complex, organic knot of jelly and crystalline particles."
	robotic = 2
	icon = 'icons/mob/slimes.dmi'
	icon_state = "green slime extract"
	var/clonnig_process = 0
	var/attemps = 2

/obj/item/organ/internal/brain/slime/proc/slimeclone()

	if(attemps<=0) usr << "<span class = 'warning'>[src] is not react!</span>"
	if(clonnig_process) return 0
	clonnig_process = 1
	attemps--

	visible_message(SPAN_NOTE("It seems [src] start moving!"))
	if(!brainmob || !brainmob.mind)
		clonnig_process = 0
		return 0

	if(!brainmob.client)
		for(var/mob/observer/dead/ghost in player_list)
			if(ghost.mind == brainmob.mind)
				ghost << "<b><font color = #330033><font size = 3>Someone is trying to regrown you from your brain. Return to your body if you want to be resurrected/cloned!</b> (Verbs -> Ghost -> Re-enter corpse)</font color>"
				break

		for(var/i = 0; i < 6; i++)
			sleep(100)
			visible_message(SPAN_NOTE("[src] moving slightly!"))
			if(brainmob.client) break

	if(!brainmob.client)
		visible_message("<span class = 'warning'>It seems \the [src] stop moving</span>")
		clonnig_process = 0
		return 0

	var/datum/mind/clonemind = brainmob.mind
	if(clonemind.current != brainmob)
		clonnig_process = 0
		return 0

	visible_message("<span class = 'warning'>\The [src] start growing!</span>")
	var/mob/living/carbon/slime/S = new(src.loc)
	brainmob.mind.transfer_to(S)
	S.dna = brainmob.dna
	S.a_intent = "hurt"
	S.add_language("Galactic Common")
	del(src)

/obj/item/organ/internal/brain/golem
	name = "chem"
	desc = "A tightly furled roll of paper, covered with indecipherable runes."
	robotic = 2
	icon = 'icons/obj/wizard.dmi'
	icon_state = "scroll"


///////////////////////////////////////////BLACK BOX/////////////////////////////////////


/obj/item/organ/internal/brain/blackbox
	name = "Black Box"
	desc = "A cube of shining metal, four inches to a side and covered in shallow grooves."
	icon = 'icons/obj/assemblies.dmi'
	icon_state = "posibrain"
	health = -1
	vital = 1
	robotic = 2
	organ_tag = O_BRAIN
	parent_organ = BP_CHEST
	w_class = ITEM_SIZE_NORMAL
	origin_tech = list(TECH_ENGINEERING = 5, TECH_MATERIAL = 6, TECH_BLUESPACE = 5, TECH_DATA = 10)

	var/mecha = null//This does not appear to be used outside of reference in mecha.dm.

/obj/item/organ/internal/brain/blackbox/New()
	..()
	src.brainmob.real_name = src.brainmob.name
	update_icon()

/obj/item/organ/internal/brain/transfer_identity(var/mob/living/carbon/H)
	..()
	if(brainmob.mind)
		brainmob.mind.assigned_role = "Android lifeform"
	brainmob << "<span class='notify'>You feel slightly disoriented. That's normal when you're cut out of your main body and put into your black box.</span>"
	update_icon()
	return

/obj/item/organ/internal/brain/blackbox/update_icon()
	if(src.brainmob.stat == UNCONSCIOUS)
		icon_state = "posibrain-searching"
		name = "[initial(name)] ([brainmob.real_name])"
	else
		if(brainmob && brainmob.key)
			icon_state = "posibrain-occupied"
			name = "[initial(name)] ([brainmob.real_name])"
		else
			icon_state = "posibrain"
			name = initial(name)

/obj/item/organ/internal/brain/blackbox/examine(mob/user)
//	.=..() //Check this.

	var/msg = "<span class='info'>*---------*\nThis is \icon[src] \a <EM>[src]</EM>!\n[desc]\n"
	msg += "<span class='warning'>"

	if(src.brainmob && src.brainmob.key)
		switch(src.brainmob.stat)
			if(CONSCIOUS)
				if(!src.brainmob.client)	msg += "It appears to be in stand-by mode.\n" //afk
			if(UNCONSCIOUS)		msg += "<span class='warning'>It doesn't seem to be responsive.</span>\n"
			if(DEAD)			msg += "<span class='deadsay'>It appears to be completely inactive.</span>\n"
	else
		msg += "<span class='deadsay'>It appears to be completely inactive.</span>\n"
	msg += "<span class='info'>*---------*</span>"
	user << msg
	return
