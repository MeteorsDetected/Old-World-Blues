// Checks whether or not the target can be affected by a vampire's abilities.
/mob/proc/vampire_can_affect_target(var/mob/living/carbon/human/T, var/notify = 1, var/account_loyalty_implant = 0)
	if (!T || !istype(T))
		return 0

	if (T.isSynthetic())
		if (notify)
			to_chat(src, "<span class='warning'>You lack the power interact with mechanical constructs.</span>")
		return 0

	return 1


/mob/living/carbon/human/proc/finish_chang_timeout(chang_flags = 0)
	if (!usr.mind || !usr.mind.changeling)
		return FALSE

	if (chang_flags && !(usr.mind.changeling & chang_flags))
		return FALSE

	return TRUE


/obj/item/weapon/card/id/proc/update_name()
	name = "[src.registered_name]'s ID Card ([src.assignment])"


/mob/proc/set_id_info(var/obj/item/weapon/card/id/id_card)
//	id_card.age = 0
	id_card.registered_name		= real_name
//	id_card.sex 				= capitalize(gender)
//	id_card.set_id_photo(src)

	if(dna)
		id_card.blood_type		= dna.b_type
		id_card.dna_hash		= dna.unique_enzymes
		id_card.fingerprint_hash= md5(dna.uni_identity)
	id_card.update_name()


/mob

	var/seedarkness = 1