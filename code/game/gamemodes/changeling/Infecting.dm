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


///proc/infect_mob(var/mob/living/carbon/M, var/datum/disease2/disease/D)
//	infect_virus2(M,D,1)
//	M.hud_updateflag |= 1 << STATUS_HUD




// Gives a lethal disease to the target.
/datum/power/changeling/Infection
	name = "Infection"
	desc = "We can produce dangerous viral diseases in our bodies."
	helptext = "Touch the victim and it will be infected."
	enhancedtext = "We produce a powerful virus, capable of killing the victim in the shortest possible time."
//	ability_icon_state = "ling_camoflage"
	genomecost = 6
	verbpath = /mob/proc/Infection


/mob/proc/Infection()
	set category = "Changeling"
	set name = "Infection (30)"
	set desc = "Infects the victim with a dangerous virus that causes organ failure."

	var/datum/changeling/changeling = changeling_power(30,0,100,CONSCIOUS)
	if (!changeling)
		return 0

	var/list/victims = list()
	for (var/mob/living/carbon/human/H in view(1))
		if (H == src)
			continue
		victims += H

	if (!victims.len)
		to_chat(src, "<span class='warning'>No suitable targets.</span>")
		return

	var/mob/living/carbon/human/T = input(src, "Select Victim") as null|mob in victims

	if (!vampire_can_affect_target(T))
		return

	to_chat(src, "<span class='notice'>You infect [T] with a deadly disease. They will soon fade away.</span>")

	T.help_shake_act(src)

	var/datum/disease2/disease/lethal = new
	lethal.makerandom(3)
	lethal.infectionchance = 1
	lethal.stage = lethal.max_stage
	lethal.spreadtype = "None"

	infect_mob(T, lethal)

	admin_attack_log(src, T, "used diseased touch on [key_name(T)]", "was given a lethal disease by [key_name(src)]", "used diseased touch (<a href='?src=\ref[lethal];info=1'>virus info</a>) on")

	changeling.chem_charges -= 30

//	verbs -= /mob/proc/Infection

//	ADD_VERB_IN_IF(src, 1800, /mob/proc/Infection, CALLBACK(src, .proc/finish_chang_timeout))