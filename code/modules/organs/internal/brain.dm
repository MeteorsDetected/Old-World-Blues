/obj/item/organ/internal/brain_holder
	name = "brain"
	desc = "A piece of juicy meat found in a person's head."
	organ_tag = O_BRAIN
	parent_organ = BP_HEAD
	vital = 1
	icon_state = "brain2"
	w_class = ITEM_SIZE_SMALL
	origin_tech = list(TECH_BIO = 3)
	attack_verb = list("attacked", "slapped", "whacked")
	var/mob/living/carbon/brain/brainmob = null

/obj/item/organ/internal/brain_holder/New()
	..()
	health = config.default_brain_health
	create_reagents(10)
	spawn(5)
		if(brainmob && brainmob.client)
			brainmob.client.screen.len = null //clear the hud

/obj/item/organ/internal/brain_holder/Destroy()
	if(brainmob)
		qdel(brainmob)
		brainmob = null
	..()

/obj/item/organ/internal/brain_holder/proc/transfer_identity(var/mob/living/carbon/H)
	name = "\the [H]'s [initial(src.name)]"
	brainmob = new(src)
	brainmob.name = H.real_name
	brainmob.real_name = H.real_name
	brainmob.dna = H.dna.Clone()
	brainmob.timeofhostdeath = H.timeofdeath
	if(H.mind)
		H.mind.transfer_to(brainmob)

	brainmob << "<span class='notice'>You feel slightly disoriented. That's normal when you're just a [initial(src.name)].</span>"
	callHook("debrain", list(brainmob))

	for(var/datum/language/L in H.languages)
		brainmob.add_language(L.name)


/obj/item/organ/internal/brain_holder/pariah
	name = "brain remnants"
	desc = "Did someone tread on this? It looks useless for cloning or cyborgification."
	icon = 'icons/mob/alien.dmi'
	icon_state = "chitin"

/obj/item/organ/internal/brain_holder/xeno
	name = "thinkpan"
	desc = "It looks kind of like an enormous wad of purple bubblegum."
	icon = 'icons/mob/alien.dmi'
	icon_state = "chitin"



