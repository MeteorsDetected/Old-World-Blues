

/datum/species/human/vatgrown
	name = "Vat-grown Human"
	name_plural = "Vat-grown Humans"
	blurb = "With cloning on the forefront of human scientific advancement, cheap mass production \
	of bodies is a very real and rather ethically grey industry. Vat-grown humans tend to be paler than \
	baseline, with no appendix and fewer inherited genetic disabilities, but a weakened metabolism."
	icobase = 'icons/mob/human_races/vatgrown.dmi'
	allow_slim_fem = 1

	flags = CAN_JOIN | HAS_UNDERWEAR | HAS_EYE_COLOR

	toxins_mod =   1.1
	has_organ = list(
		O_HEART =    /obj/item/organ/internal/heart,
		O_LUNGS =    /obj/item/organ/internal/lungs,
		O_LIVER =    /obj/item/organ/internal/liver,
		O_KIDNEYS =  /obj/item/organ/internal/kidneys,
		O_BRAIN =    /obj/item/organ/internal/brain,
		O_EYES =     /obj/item/organ/internal/eyes
		)

/datum/species/human/vatgrown/get_bodytype()
	return SPECIES_HUMAN


/datum/species/machine/android
	name = "Android"
	name_plural = "Androids"
	blurb = "Androids are an artificial lifeforms designed to look and act like a human.<br>\
	Most of them have a lab-grown bodies with artifical flesh in a way to copy Human physiology and mentality.\
	Androids have red biogel instead of blood and strong steel skeleton, what allows them to work in very hard conditions.<br><br>\
	Because Humans are their Creators, Androids almost worship them. However, they can still divide Humans on 'good' and 'bad',\
	and that speciality was used by their Masters in wars.<br><br>\
	Warning:<br>\
	Androids are being assembled only in a few factories in our galaxy, named Fortresses, their location is held secret and after Creation and Tests they have their memories deleted.\
	If Android dies - his last saved memory copy is transfered to a Fortress and then downloaded into a newly produced body. Howewer, there's no way to ressurect Android on station.\
	When Android dies - his personal data is lost and his place in a galaxy is taken by his copy from past."
	//Icons aren't ready, work needed.
	//icobase = 'icons/mob/human_races/android.dmi'
	//deform = 'icons/mob/human_races/android_def.dmi'
	icobase = 'icons/mob/human_races/human.dmi'
	deform = 'icons/mob/human_races/human_def.dmi'
	name_language = null


	allow_slim_fem = 1

	min_age = 1
	max_age = 400

	body_builds = list(
		new/datum/body_build,
		new/datum/body_build/slim
	)

	default_language = "Galactic Common"
	language = "Encoded Audio Language"
	rarity_value = 5
	virus_immune = 1

	warning_low_pressure = 50
	hazard_low_pressure = -1

	taste_sensitivity = TASTE_DULL

	flags = CAN_JOIN | NO_PAIN | NO_SCAN | HAS_UNDERWEAR | IS_WHITELISTED | NO_BREATHE | NO_BLOOD | IS_SYNTHETIC | HAS_SKIN_TONE | HAS_LIPS | HAS_EYE_COLOR

	//blood_color = "#2299FC"
	flesh_color = "#E7DADA"

	brute_mod = 0.5
	burn_mod = 0.8
	radiation_mod = 0
	toxins_mod = 0

	passive_temp_gain = 0
	cold_discomfort_level = 50
	cold_level_1 = -1
	cold_level_2 = -1
	cold_level_3 = -1
	list/cold_discomfort_strings = list(
		"You feel chilly.",
		"Your chilly flesh stands out in goosebumps."
		)

	heat_discomfort_level = 500
	heat_level_1 = 800
	heat_level_2 = 1000
	heat_level_3 = 1200
	list/heat_discomfort_strings = list(
		"You feel uncomfortably warm.",
		"Your artifical skin prickles in the heat."
		)

	//vision_organ = "optics"

	has_organ = list(
		/*O_BRAIN   = /obj/item/organ/mmi_holder/posibrain,
		"cell"    = /obj/item/organ/internal/cell,
		"optics"  = /obj/item/organ/eyes/optical_sensor,
		"ipc tag" = /obj/item/organ/ipc_tag*/
		O_HEART =    /obj/item/organ/internal/heart,
		O_LUNGS =    /obj/item/organ/internal/lungs,
		O_LIVER =    /obj/item/organ/internal/liver,
		O_KIDNEYS =  /obj/item/organ/internal/kidneys,
		//O_BRAIN =    /obj/item/organ/internal/brain,
		O_APPENDIX = /obj/item/organ/internal/appendix,
		O_EYES =     /obj/item/organ/internal/eyes
	)

	restricted_jobs = list(
		"Captain", "Head of Personnel", "Head of Security", "Chief Engineer",
		"Research Director", "Chief Medical Officer"
		)



/datum/species/machine/android/get_bodytype()
	return SPECIES_HUMAN

/datum/species/machine/android/organs_spawned(var/mob/living/carbon/human/H)
	..()
	for(var/obj/item/organ/O in H.organs)
		O.robotic = 2 //Which is equal to ORGAN_ROBOT define
	for(var/obj/item/organ/O in H.internal_organs)
		O.robotic = 2

/datum/species/machine/android/handle_death(var/mob/living/carbon/human/H)
	return