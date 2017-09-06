/datum/power/changeling/self_respiration
	name = "Self Respiration"
	desc = "We evolve our body to no longer require drawing oxygen from the atmosphere."
	helptext = "We will no longer require internals, and we cannot inhale any gas, including harmful ones."
	genomecost = 0
	isVerb = 0
	verbpath = /mob/living/proc/changeling_self_respiration

//No breathing required
/mob/living/proc/changeling_self_respiration()
	if(iscarbon(src))
		var/mob/living/carbon/C = src
		C.does_not_breathe = 1
		src << SPAN_NOTE("We stop breathing, as we no longer need to.")
		return 1
	return 0