// DRONE ABILITIES
/mob/living/silicon/robot/drone/verb/set_mail_tag()
	set name = "Set Mail Tag"
	set desc = "Tag yourself for delivery through the disposals system."
	set category = "Robot Commands"

	var/new_tag = input("Select the desired destination.", "Set Mail Tag", null) as null|anything in tagger_locations

	if(!new_tag)
		mail_destination = ""
		return

	src << SPAN_NOTE("You configure your internal beacon, tagging yourself for delivery to '[new_tag]'.")
	mail_destination = new_tag

	//Auto flush if we use this verb inside a disposal chute.
	var/obj/machinery/disposal/D = src.loc
	if(istype(D))
		src << SPAN_NOTE("\The [D] acknowledges your signal.")
		D.flush_count = D.flush_every_ticks

	return

//Actual picking-up event.
/mob/living/silicon/robot/drone/attack_hand(mob/living/carbon/human/M as mob)

	if(M.a_intent == I_HELP)
		get_scooped(M)
	..()