/obj/item/organ/external/robotic
	name = "robotic"
	default_icon = 'icons/mob/human_races/cyberlimbs/robotic.dmi'
	desc = "A skeletal limb wrapped in pseudomuscles, with a low-conductivity case."
	dislocated = -1
	cannot_break = 1
	robotic = ORGAN_ROBOT
	brute_mod = 0.8
	burn_mod = 0.8
	var/list/forced_children = null

/obj/item/organ/external/robotic/set_description(var/datum/organ_description/desc)
	src.name = "[name] [desc.name]"
	src.amputation_point = desc.amputation_point
	src.joint = desc.joint
	src.max_damage = desc.max_damage
	src.min_broken_damage = desc.min_broken_damage
	src.w_class = desc.w_class

/obj/item/organ/external/robotic/install()
	if(..()) return 1
	if(islist(forced_children) && forced_children[organ_tag])
		var/list/spawn_part = forced_children[organ_tag]
		var/child_type
		for(var/name in spawn_part)
			child_type = spawn_part[name]
			new child_type(owner, owner.species.has_limbs[name])

/obj/item/organ/external/robotic/sync_to_owner()
	for(var/obj/item/organ/I in internal_organs)
		I.sync_to_owner()

	if(gendered)
		gendered = (owner.gender == MALE)? "_m": "_f"
	body_build = owner.body_build.index

/obj/item/organ/external/robotic/get_icon()
	icon_state = "[organ_tag][gendered][body_build]"

	mob_icon = new /icon(default_icon, icon_state)
	return mob_icon

/obj/item/organ/external/robotic/apply_colors()
	return

/obj/item/organ/external/robotic/get_icon_key()
	. = "robotic[model]"

/obj/item/organ/external/robotic/Destroy()
	deactivate()
	..()

/obj/item/organ/external/robotic/removed()
	deactivate(1)
	..()

/obj/item/organ/external/robotic/update_germs()
	germ_level = 0
	return

/obj/item/organ/external/robotic/proc/can_activate()
	if(owner.sleeping || owner.stunned || owner.restrained())
		owner << SPAN_WARN("You can't do that now!")
		return

	for(var/obj/item/weapon/implant/prosthesis_inhibition/I in owner)
		if(I.malfunction)
			continue
		owner << SPAN_WARN("[I] in your [I.part] prevent [src] activation!")
		return FALSE
	return TRUE

/obj/item/organ/external/robotic/proc/activate()
/obj/item/organ/external/robotic/proc/deactivate()

/obj/item/organ/external/robotic/limb
	max_damage = 50
	min_broken_damage = 30
	w_class = ITEM_SIZE_NORMAL

/obj/item/organ/external/robotic/tiny
	min_broken_damage = 15
	w_class = ITEM_SIZE_SMALL

//Helper proc used by various tools for repairing robot limbs
/obj/item/organ/external/robotic/proc/robo_repair(var/repair_amount, var/damage_type, var/damage_desc, obj/item/tool, mob/living/user)
	if((src.robotic < ORGAN_ROBOT))
		return 0

	var/damage_amount
	switch(damage_type)
		if(BRUTE)   damage_amount = brute_dam
		if(BURN)    damage_amount = burn_dam
		if("omni")  damage_amount = max(brute_dam,burn_dam)
		else return 0

	if(!damage_amount)
		user << "<span class='notice'>Nothing to fix!</span>"
		return 0

	if(damage_amount >= 15)//ROBOLIMB_REPAIR_CAP)
		user << SPAN_DANG("The damage is far too severe to patch over externally.")
		return 0

	if(user == src.owner)
		var/obj/item/organ/used
		if(user.l_hand == tool && (src.body_part & (ARM_LEFT|HAND_LEFT)))
			used = owner.get_organ(BP_L_HAND)
		else if(user.r_hand == tool && (src.body_part & (ARM_RIGHT|HAND_RIGHT)))
			used = owner.get_organ(BP_R_HAND)

		if(used)
			user << SPAN_WARN("You can't reach your [src.name] while holding [tool] in your [used].")
			return 0

	user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
	if(!do_mob(user, owner, 10))
		user << SPAN_WARN("You must stand still to do that.")
		return 0

	switch(damage_type)
		if(BRUTE)
			sleep(35)
			src.heal_damage(repair_amount, 0, 0, 1)
		if(BURN)
			sleep(35)
			src.heal_damage(0, repair_amount, 0, 1)
		if("omni")src.heal_damage(repair_amount, repair_amount, 0, 1)

	if(damage_desc)
		if(user == src.owner)
			user.visible_message(
				SPAN_NOTE("\The [user] patches [damage_desc] on \his [src.name] with [tool].")
			)
		else
			user.visible_message(
				SPAN_NOTE("\The [user] patches [damage_desc] on [owner]'s [src.name] with [tool].")
			)

	return 1
