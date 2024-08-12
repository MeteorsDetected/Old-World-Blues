/obj/item/prosthesis/runner
	desc = "Full limb runner prosthesis module."
	matter = list(MATERIAL_STEEL = 9000)

/obj/item/prosthesis/runner/l_leg
	name = "R.U.N.N.E.R. left leg"
	icon_state = "l_leg"
	part = list(
		BP_L_LEG = /obj/item/organ/external/robotic/limb/runner,
		BP_L_FOOT = /obj/item/organ/external/robotic/limb/runner/tiny
	)

/obj/item/prosthesis/runner/r_leg
	name = "R.U.N.N.E.R. right leg"
	icon_state = "r_leg"
	part = list(
		BP_R_LEG = /obj/item/organ/external/robotic/limb/runner,
		BP_R_FOOT = /obj/item/organ/external/robotic/limb/runner/tiny
	)
