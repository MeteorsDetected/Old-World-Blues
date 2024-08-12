/****************************************************
				EXTERNAL ORGANS
****************************************************/

/obj/item/organ/external
	name = "external"
	min_broken_damage = 30
	max_damage = 0
	dir = SOUTH
	organ_tag = "limb"
	icon = null
	icon_state = null
	var/tally = 0

	// Strings
	var/broken_description             // fracture string if any.
	var/damage_state = "00"            // Modifier used for generating the on-mob damage overlay for this limb.
	var/damage_msg = "\red You feel an intense pain"

	// Damage vars.
	var/brute_mod = 1                  // Multiplier for incoming brute damage.
	var/burn_mod = 1                   // As above for burn.
	var/brute_dam = 0                  // Actual current brute damage.
	var/burn_dam = 0                   // Actual current burn damage.
	var/last_dam = -1                  // used in healing/processing calculations.
	var/perma_injury = 0

	// Appearance vars.
	var/body_part = null               // Part flag
	var/icon_position = 0              // Used in mob overlay layering calculations.
	var/model                          // Used when caching robolimb icons.
	var/icon/default_icon              // Used to force override of species-specific limb icons (for prosthetics).
	var/icon/mob_icon                  // Cached icon for use in mob overlays.
	var/gendered = null
	var/s_tone				// Skin tone.
	var/s_col				// skin colour
	var/body_build
	var/tattoo = 0
	var/tattoo_color = ""
	var/tattoo2 = 0

	// Wound and structural data.
	var/wound_update_accuracy = 1		// how often wounds should be updated, a higher number means less often
	var/list/wounds = list()			// wound datum list.
	var/number_wounds = 0				// number of wounds, which is NOT wounds.len!
	var/list/children = list()			// Sub-limbs.
	var/list/internal_organs = list()	// Internal organs of this body part
	var/list/implants = list()			// Currently implanted objects.
	var/max_size = 0

	var/datum/unarmed_attack/attack = null
	var/list/drop_on_remove = null

	var/obj/item/organ_module/active/module = null

	// Joint/state stuff.
	var/can_grasp			// It would be more appropriate if these two were named "affects_grasp" and "affects_stand" at this point
	var/can_stand			// Modifies stance tally/ability to stand.
	var/disfigured = 0		// Scarred/burned beyond recognition.
	var/cannot_amputate		// Impossible to amputate.
	var/cannot_break		// Impossible to fracture.
	var/joint = "joint"		// Descriptive string used in dislocation.
	var/amputation_point	// Descriptive string used in amputation.
	var/dislocated = 0		// If you target a joint, you can dislocate the limb, impairing it's usefulness and causing pain
	var/encased				// Needs to be opened with a saw to access the organs.

	// Surgery vars.
	var/open = 0
	var/stage = 0
	var/cavity = 0

/obj/item/organ/external/New(mob/living/carbon/human/holder, var/datum/organ_description/desc = null)
	if(desc)
		// Mandatory part
		src.organ_tag = desc.organ_tag
		src.body_part = desc.body_part
		src.vital = desc.vital
		src.cannot_amputate = desc.cannot_amputate
		src.parent_organ = desc.parent_organ
		src.icon_position = desc.icon_position
		src.can_grasp = desc.can_grasp
		src.can_stand = desc.can_stand
		src.drop_on_remove = desc.drop_on_remove
		// Decorative part (depend on organ type)
		set_description(desc)

	..(holder)

/obj/item/organ/external/proc/set_description(var/datum/organ_description/desc)
	src.name = desc.name
	src.amputation_point = desc.amputation_point
	src.joint = desc.joint
	src.max_damage = desc.max_damage
	src.min_broken_damage = desc.min_broken_damage
	src.w_class = desc.w_class

/obj/item/organ/external/install(mob/living/carbon/human/H, var/redraw_mob = 1)
	if(..(H)) return 1

	owner.organs |= src
	var/obj/item/organ/external/outdated = H.organs_by_name[organ_tag]
	if(outdated)
		outdated.removed(H, 0)
	owner.organs_by_name[organ_tag] = src

	for(var/obj/item/organ/organ in src)
		organ.install(owner, 0)

	if(parent)
		if(!parent.children)
			parent.children = list()
		parent.children.Add(src)
		//Remove all stump wounds since limb is not missing anymore
		var/datum/wound/lost_limb/W = locate() in parent.wounds
		if(W)
			parent.wounds -= W
			qdel(W)
		parent.update_damages()

	if(module)
		module.organ_installed(src, owner)

	update_icon()
	owner.updatehealth()
	owner.UpdateDamageIcon(0)
	if(redraw_mob)
		owner.update_body()


/obj/item/organ/external/Destroy()
	if(parent)
		parent.children -= src

	if(children)
		for(var/obj/item/organ/external/C in children)
			qdel(C)

	if(internal_organs)
		for(var/obj/item/organ/O in internal_organs)
			qdel(O)

	if(module)
		qdel(module)
		module = null

	if(owner)
		//drop_items()
		owner.organs -= src
		owner.organs_by_name[organ_tag] = null
		owner.bad_external_organs -= src

	. = ..()

/obj/item/organ/external/removed(mob/living/user, var/redraw_mob = 1)
	if(!owner)
		return

	owner.organs -= src
	owner.organs_by_name[organ_tag] = null // Remove from owner's vars.
	owner.bad_external_organs -= src

	if(module)
		module.organ_removed(src, owner)

	drop_items()

	for(var/atom/movable/implant in implants)
		//large items and non-item objs fall to the floor, everything else stays
		var/obj/item/I = implant
		if(istype(I) && I.w_class < 3)
			implant.forceMove(get_turf(owner))
		else
			implant.forceMove(src)
	implants.Cut()

	if(children)
		for(var/obj/item/organ/external/child in children)
			child.removed(user, 0)
			child.forceMove(src)

	if(internal_organs)
		for(var/obj/item/organ/internal/organ in internal_organs)
			organ.removed(user, 0)
			organ.forceMove(src)

	// Remove parent references
	parent.children -= src

	var/mob/living/carbon/human/victim = owner
	..()

	if(redraw_mob) victim.update_body()

/obj/item/organ/external/proc/activate_module()
	set name = "Activate module"
	set category = "Organs"
	set src in usr

	if(module)
		module.activate(owner, src)

/obj/item/organ/external/attack_self(var/mob/user)
	if(!contents.len)
		return ..()
	var/list/removable_objects = list()
	for(var/obj/item/organ/external/E in (contents + src))
		if(!istype(E))
			continue
		for(var/obj/item/I in E.contents)
			if(istype(I,/obj/item/organ))
				continue
			removable_objects |= I
	if(removable_objects.len)
		var/obj/item/I = pick(removable_objects)
		I.forceMove(get_turf(user)) //just in case something was embedded that is not an item
		if(istype(I))
			user.put_in_hands(I)
		user.visible_message(SPAN_DANGER("\The [user] rips \the [I] out of \the [src]!"))
		return //no eating the limb until everything's been removed
	return ..()

/obj/item/organ/external/examine(mob/user, return_dist=1)
	.=..()
	if(.<=3)
		for(var/obj/item/I in contents)
			if(istype(I, /obj/item/organ))
				continue
			usr << SPAN_DANGER("There is \a [I] sticking out of it.")
	return

/obj/item/organ/external/attackby(obj/item/weapon/W as obj, mob/living/user as mob)
	switch(stage)
		if(0)
			if(istype(W,/obj/item/weapon/scalpel))
				user.visible_message(SPAN_DANGER("<b>[user]</b> cuts [src] open with [W]!"))
				stage++
				return
		if(1)
			if(istype(W,/obj/item/weapon/retractor))
				user.visible_message(SPAN_DANGER("<b>[user]</b> cracks [src] open like an egg with [W]!"))
				stage++
				return
		if(2)
			if(istype(W,/obj/item/weapon/hemostat))
				if(contents.len)
					var/obj/item/removing = pick(contents)
					user.put_in_hands(removing)
					user.visible_message(SPAN_DANGER("<b>[user]</b> extracts [removing] from [src] with [W]!"))
				else
					user.visible_message(SPAN_DANGER("<b>[user]</b> fishes around fruitlessly in [src] with [W]."))
				return
	..()

/obj/item/organ/external/proc/get_tally()
	if(status & ORGAN_SPLINTED)
		return 0.5
	else if(status & ORGAN_BROKEN)
		return 1.5
	else
		return tally

/obj/item/organ/external/proc/is_dislocated()
	if(dislocated > 0)
		return 1
	if(parent)
		return parent.is_dislocated()
	return 0

/obj/item/organ/external/proc/dislocate(var/primary)
	if(dislocated != -1)
		if(primary)
			dislocated = 2
		else
			dislocated = 1
	owner.verbs |= /mob/living/carbon/human/proc/undislocate
	if(children && children.len)
		for(var/obj/item/organ/external/child in children)
			child.dislocate()

/obj/item/organ/external/proc/undislocate()
	if(dislocated != -1)
		dislocated = 0
	if(children && children.len)
		for(var/obj/item/organ/external/child in children)
			if(child.dislocated == 1)
				child.undislocate()
	if(owner)
		owner.shock_stage += 20
		for(var/obj/item/organ/external/limb in owner.organs)
			if(limb.dislocated == 2)
				return
		owner.verbs -= /mob/living/carbon/human/proc/undislocate

/obj/item/organ/external/update_health()
	damage = min(max_damage, (brute_dam + burn_dam))
	return

/obj/item/organ/external/proc/drop_items()
	if(!owner) return
	var/obj/item/dropped = null
	for(var/slot in drop_on_remove)
		dropped = owner.get_equipped_item(slot)
		if(dropped)
			owner.visible_message(
				"\The [dropped] falls off of [owner.name].",
				"\The [dropped] falls off you."
			)
			owner.drop_from_inventory(dropped)

/*
This function completely restores a damaged organ to perfect condition.
*/
/obj/item/organ/external/rejuvenate()
	damage_state = "00"
	//Robotic organs stay robotic.  Fix because right click rejuvinate makes IPC's organs organic.
	status = 0
	perma_injury = 0
	brute_dam = 0
	burn_dam = 0
	germ_level = 0
	wounds.Cut()
	number_wounds = 0

	// handle internal organs
	for(var/obj/item/organ/internal/current_organ in internal_organs)
		current_organ.rejuvenate()

	// remove embedded objects and drop them on the floor
	for(var/obj/implanted_object in implants)
		if(!istype(implanted_object,/obj/item/weapon/implant))	// We don't want to remove REAL implants. Just shrapnel etc.
			implanted_object.forceMove(get_turf(src))
			implants -= implanted_object

	owner.updatehealth()


/obj/item/organ/external/proc/createwound(var/type = CUT, var/damage)

	if(damage == 0)
		return

	//moved this before the open_wound check
	// so that having many small wounds for example doesn't somehow protect you from taking internal damage
	// (because of the return)
	//Possibly trigger an internal wound, too.
	var/local_damage = brute_dam + burn_dam + damage
	if((damage > 15) && (type != BURN) && (local_damage > 30) && prob(damage) && (robotic < ORGAN_ROBOT))
		var/datum/wound/internal_bleeding/I = new (min(damage - 15, 15))
		wounds += I
		owner.custom_pain("You feel something rip in your [name]!", 1)

	// first check whether we can widen an existing wound
	if(wounds.len > 0 && prob(max(50+(number_wounds-1)*10,90)))
		if((type == CUT || type == BRUISE) && damage >= 5)
			//we need to make sure that the wound we are going to worsen is compatible with the type of damage...
			var/list/compatible_wounds = list()
			for (var/datum/wound/W in wounds)
				if (W.can_worsen(type, damage))
					compatible_wounds += W

			if(compatible_wounds.len)
				var/datum/wound/W = pick(compatible_wounds)
				W.open_wound(damage)
				if(prob(25))
					if(robotic >= ORGAN_ROBOT)
						owner.visible_message(
							SPAN_DANGER("The damage to [owner.name]'s [name] worsens."),
							SPAN_DANGER("The damage to your [name] worsens."),
							SPAN_DANGER("You hear the screech of abused metal.")
						)
					else
						owner.visible_message(
							SPAN_DANGER("The wound on [owner.name]'s [name] widens with a nasty ripping noise."),
							SPAN_DANGER("The wound on your [name] widens with a nasty ripping noise."),
							SPAN_DANGER("You hear a nasty ripping noise, as if flesh is being torn apart.")
						)
				return

	//Creating wound
	var/wound_type = get_wound_type(type, damage)

	if(wound_type)
		var/datum/wound/W = new wound_type(damage)

		//Check whether we can add the wound to an existing wound
		for(var/datum/wound/other in wounds)
			if(other.can_merge(W))
				other.merge_wound(W)
				W = null // to signify that the wound was added
				break
		if(W)
			wounds += W

/****************************************************
			   PROCESSING & UPDATING
****************************************************/

//external organs handle brokenness a bit differently when it comes to damage. Instead brute_dam is checked inside process()
//this also ensures that an external organ cannot be "broken" without broken_description being set.
/obj/item/organ/external/is_broken()
	return ((status & ORGAN_CUT_AWAY) || ((status & ORGAN_BROKEN) && !(status & ORGAN_SPLINTED)))

//Determines if we even need to process this organ.
/obj/item/organ/external/proc/need_process()
	if(status & (ORGAN_CUT_AWAY|ORGAN_BLEEDING|ORGAN_BROKEN|ORGAN_SPLINTED|ORGAN_DEAD|ORGAN_MUTATED))
		return 1
	if((brute_dam || burn_dam) && (robotic < ORGAN_ROBOT)) //Robot limbs don't autoheal and thus don't need to process when damaged
		return 1
	if(last_dam != brute_dam + burn_dam) // Process when we are fully healed up.
		last_dam = brute_dam + burn_dam
		return 1
	else
		last_dam = brute_dam + burn_dam
	if(germ_level)
		return 1
	return 0

/obj/item/organ/external/process()
	if(owner)

		// Process wounds, doing healing etc. Only do this every few ticks to save processing power
		if(owner.life_tick % wound_update_accuracy == 0)
			update_wounds()

		//Chem traces slowly vanish
		if(owner.life_tick % 10 == 0)
			for(var/chemID in trace_chemicals)
				trace_chemicals[chemID] = trace_chemicals[chemID] - 1
				if(trace_chemicals[chemID] <= 0)
					trace_chemicals.Remove(chemID)

		if(!(status & ORGAN_BROKEN))
			perma_injury = 0

		//Infections
		update_germs()
	else
		..()

//Updating germ levels. Handles organ germ levels and necrosis.
/*
The INFECTION_LEVEL values defined in setup.dm control the time it takes to reach the different
infection levels. Since infection growth is exponential, you can adjust the time it takes to get
from one germ_level to another using the rough formula:

desired_germ_level = initial_germ_level*e^(desired_time_in_seconds/1000)

So if I wanted it to take an average of 15 minutes to get from level one (100) to level two
I would set INFECTION_LEVEL_TWO to 100*e^(15*60/1000) = 245. Note that this is the average time,
the actual time is dependent on RNG.

INFECTION_LEVEL_ONE		below this germ level nothing happens, and the infection doesn't grow
INFECTION_LEVEL_TWO		above this germ level the infection will start to spread to internal and adjacent organs
INFECTION_LEVEL_THREE	above this germ level the player will take additional toxin damage per second, and will die in minutes without
						antitox. also, above this germ level you will need to overdose on spaceacillin to reduce the germ_level.

Note that amputating the affected organ does in fact remove the infection from the player's body.
*/
/obj/item/organ/external/proc/update_germs()

	//Robotic limbs shouldn't be infected, nor should nonexistant limbs.
	if(robotic >= ORGAN_ROBOT || (owner.species && owner.species.flags & IS_PLANT))
		germ_level = 0
		return

	if(owner.bodytemperature >= 170)	//cryo stops germs from moving and doing their bad stuffs
		//** Syncing germ levels with external wounds
		handle_germ_sync()

		//** Handle antibiotics and curing infections
		handle_antibiotics()

		//** Handle the effects of infections
		handle_germ_effects()

/obj/item/organ/external/proc/handle_germ_sync()
	var/antibiotics = owner.reagents.get_reagent_amount("spaceacillin")
	for(var/datum/wound/W in wounds)
		//Open wounds can become infected
		if (owner.germ_level > W.germ_level && W.infection_check())
			W.germ_level++

	if (antibiotics < 5)
		for(var/datum/wound/W in wounds)
			//Infected wounds raise the organ's germ level
			if (W.germ_level > germ_level)
				germ_level++
				break	//limit increase to a maximum of one per second

/obj/item/organ/external/handle_germ_effects()

	if(germ_level < INFECTION_LEVEL_TWO)
		return ..()

	var/antibiotics = owner.reagents.get_reagent_amount("spaceacillin")

	if(germ_level >= INFECTION_LEVEL_TWO)
		//spread the infection to internal organs
		//make internal organs become infected one at a time instead of all at once
		var/obj/item/organ/internal/target_organ = null
		for (var/obj/item/organ/internal/I in internal_organs)
			//once the organ reaches whatever we can give it, or level two, switch to a different one
			if (I.germ_level > 0 && I.germ_level < min(germ_level, INFECTION_LEVEL_TWO))
				//choose the organ with the highest germ_level
				if (!target_organ || I.germ_level > target_organ.germ_level)
					target_organ = I

		if (!target_organ)
			//figure out which organs we can spread germs to and pick one at random
			var/list/candidate_organs = list()
			for (var/obj/item/organ/internal/I in internal_organs)
				if (I.germ_level < germ_level)
					candidate_organs |= I
			if (candidate_organs.len)
				target_organ = pick(candidate_organs)

		if (target_organ)
			target_organ.germ_level++

		//spread the infection to child and parent organs
		if (children)
			for (var/obj/item/organ/external/child in children)
				if (child.germ_level < germ_level && child.robotic<ORGAN_ROBOT)
					if (child.germ_level < INFECTION_LEVEL_ONE*2 || prob(30))
						child.germ_level++

		if (parent)
			if (parent.germ_level < germ_level && parent.robotic < ORGAN_ROBOT)
				if (parent.germ_level < INFECTION_LEVEL_ONE*2 || prob(30))
					parent.germ_level++

	if(germ_level >= INFECTION_LEVEL_THREE && antibiotics < 30)	//overdosing is necessary to stop severe infections
		if (!(status & ORGAN_DEAD))
			status |= ORGAN_DEAD
			owner << SPAN_NOTE("You can't feel your [name] anymore...")
			owner.update_body(1)

		germ_level++
		owner.adjustToxLoss(1)

//Updating wounds. Handles wound natural I had some free spachealing, internal bleedings and infections
/obj/item/organ/external/proc/update_wounds()

	if(robotic >= ORGAN_ROBOT) //Robotic limbs don't heal or get worse.
		for(var/datum/wound/W in wounds) //Repaired wounds disappear though
			if(W.damage <= 0)        //and they disappear right away
				wounds -= W      //TODO: robot wounds for robot limbs
		return

	for(var/datum/wound/W in wounds)
		// wounds can disappear after 10 minutes at the earliest
		if(W.damage <= 0 && W.created + 10 * 10 * 60 <= world.time)
			wounds -= W
			continue
			// let the GC handle the deletion of the wound

		// Internal wounds get worse over time. Low temperatures (cryo) stop them.
		if(W.internal && owner.bodytemperature >= 170)
			var/bicardose = owner.reagents.get_reagent_amount("bicaridine")
			var/inaprovaline = owner.reagents.get_reagent_amount("inaprovaline")
			//bicaridine and inaprovaline stop internal wounds from growing bigger with time,
			// unless it is so small that it is already healing
			if(!(W.can_autoheal() || (bicardose && inaprovaline)))
				W.open_wound(0.1 * wound_update_accuracy)
			if(bicardose >= 30)	//overdose of bicaridine begins healing IB
				W.damage = max(0, W.damage - 0.2)

			//line should possibly be moved to handle_blood, so all the bleeding stuff is in one place.
			owner.vessel.remove_reagent("blood", wound_update_accuracy * W.damage/40)
			if(prob(1 * wound_update_accuracy))
				owner.custom_pain("You feel a stabbing pain in your [name]!",1)

		// slow healing
		var/heal_amt = 0

		// if damage >= 50 AFTER treatment then it's probably too severe to heal within the timeframe of a round.
		if (W.can_autoheal() && W.wound_damage() < 50)
			heal_amt += 0.5

		//we only update wounds once in [wound_update_accuracy] ticks so have to emulate realtime
		heal_amt = heal_amt * wound_update_accuracy
		//configurable regen speed woo, no-regen hardcore or instaheal hugbox, choose your destiny
		heal_amt = heal_amt * config.organ_regeneration_multiplier
		// amount of healing is spread over all the wounds
		heal_amt = heal_amt / (wounds.len + 1)
		// making it look prettier on scanners
		heal_amt = round(heal_amt,0.1)
		W.heal_damage(heal_amt)

		// Salving also helps against infection
		if(W.germ_level > 0 && W.salved && prob(2))
			W.disinfected = 1
			W.germ_level = 0

	// sync the organ's damage with its wounds
	src.update_damages()
	if (update_damstate())
		owner.UpdateDamageIcon(1)

//Updates brute_damn and burn_damn from wound damages. Updates BLEEDING status.
/obj/item/organ/external/proc/update_damages()
	number_wounds = 0
	brute_dam = 0
	burn_dam = 0
	stopBleeding()
	var/clamped = 0

	//update damage counts
	for(var/datum/wound/W in wounds)
		if(!W.internal) //so IB doesn't count towards crit/paincrit
			if(W.damage_type == BURN)
				burn_dam += W.damage
			else
				brute_dam += W.damage

		if(W.bleeding())
			W.bleed_timer--
			src.setBleeding()

		clamped |= W.clamped

		number_wounds += W.amount

	//things tend to bleed if they are CUT OPEN
	if (open && !clamped && owner)
		src.setBleeding()

	//Bone fractures
	if(config.bones_can_break && brute_dam > min_broken_damage * config.organ_health_multiplier && robotic<ORGAN_ROBOT)
		src.fracture()

//Returns 1 if damage_state changed
/obj/item/organ/external/proc/update_damstate()
	var/n_is = damage_state_text()
	if (n_is != damage_state)
		damage_state = n_is
		return 1
	return 0

// new damage icon system
// returns just the brute/burn damage code
/obj/item/organ/external/proc/damage_state_text()

	var/tburn = 0
	var/tbrute = 0

	if(burn_dam ==0)
		tburn =0
	else if (burn_dam < (max_damage * 0.25 / 2))
		tburn = 1
	else if (burn_dam < (max_damage * 0.75 / 2))
		tburn = 2
	else
		tburn = 3

	if (brute_dam == 0)
		tbrute = 0
	else if (brute_dam < (max_damage * 0.25 / 2))
		tbrute = 1
	else if (brute_dam < (max_damage * 0.75 / 2))
		tbrute = 2
	else
		tbrute = 3
	return "[tbrute][tburn]"

/****************************************************
			   DISMEMBERMENT
****************************************************/

//Handles dismemberment
/obj/item/organ/external/proc/droplimb(var/clean, var/disintegrate = DROPLIMB_EDGE, var/ignore_children = null)

	if(cannot_amputate || !owner)
		return

	switch(disintegrate)
		if(DROPLIMB_EDGE)
			if(!clean)
				var/gore_sound = "[(robotic >= ORGAN_ROBOT) ? "tortured metal" : "ripping tendons and flesh"]"
				owner.visible_message(
					SPAN_DANGER("\The [owner]'s [src.name] flies off in an arc!"),
					"<span class='moderate'><b>Your [src.name] goes flying off!</b></span>",
					SPAN_DANGER("You hear a terrible sound of [gore_sound].")
				)
		if(DROPLIMB_BURN)
			var/gore = "[(robotic >= ORGAN_ROBOT) ? "": " of burning flesh"]"
			owner.visible_message(
				SPAN_DANGER("\The [owner]'s [src.name] flashes away into ashes!"),
				"<span class='moderate'><b>Your [src.name] flashes away into ashes!</b></span>",
				SPAN_DANGER("You hear a crackling sound[gore]."))
		if(DROPLIMB_BLUNT)
			var/gore = "[(robotic >= ORGAN_ROBOT) ? "": " in shower of gore"]"
			var/gore_sound = "[(robotic >= ORGAN_ROBOT) ? "rending sound of tortured metal" : "sickening splatter of gore"]"
			owner.visible_message(
				SPAN_DANGER("\The [owner]'s [src.name] explodes[gore]!"),
				"<span class='moderate'><b>Your [src.name] explodes[gore]!</b></span>",
				SPAN_DANGER("You hear the [gore_sound]."))

	var/mob/living/carbon/human/victim = owner //Keep a reference for post-removed().
	var/obj/item/organ/external/parent_organ = parent

	var/use_flesh_colour = owner.get_flesh_colour()
	var/use_blood_colour = owner.get_blood_colour()

	removed(null, ignore_children)
	victim.traumatic_shock += 60

	if(parent_organ)
		var/datum/wound/lost_limb/W = new (src, disintegrate, clean)
		if(clean)
			parent_organ.wounds |= W
			parent_organ.update_damages()
		else
			var/obj/item/organ/external/stump/stump = new (victim, src)
			stump.wounds |= W
			stump.update_damages()

	spawn(1)
		victim.updatehealth()
		victim.UpdateDamageIcon()
		victim.regenerate_icons()
		dir = 2

	switch(disintegrate)
		if(DROPLIMB_EDGE)
			compile_icon()
			add_blood(victim)
			var/matrix/M = matrix()
			M.Turn(rand(180))
			src.transform = M
			if(!clean)
				// Throw limb around.
				if(src && istype(loc,/turf))
					throw_at(get_edge_target_turf(src,pick(alldirs)),rand(1,3),30)
				dir = 2
		if(DROPLIMB_BURN)
			new /obj/effect/decal/cleanable/ash(get_turf(victim))
			for(var/obj/item/I in src)
				if(I.w_class > ITEM_SIZE_SMALL && !istype(I,/obj/item/organ))
					I.forceMove(get_turf(src))
			qdel(src)
		if(DROPLIMB_BLUNT)
			var/obj/effect/decal/cleanable/blood/gibs/gore
			if(robotic >= ORGAN_ROBOT)
				gore = new /obj/effect/decal/cleanable/blood/gibs/robot(get_turf(victim))
			else
				gore = new /obj/effect/decal/cleanable/blood/gibs(get_turf(victim))
				gore.fleshcolor = use_flesh_colour
				gore.basecolor =  use_blood_colour
				gore.update_icon()

			gore.throw_at(get_edge_target_turf(src,pick(alldirs)),rand(1,3),30)

			for(var/obj/item/organ/internal/I in internal_organs)
				I.removed()
				if(istype(loc,/turf))
					I.throw_at(get_edge_target_turf(src,pick(alldirs)),rand(1,3),30)

			for(var/obj/item/I in src)
				I.forceMove(get_turf(src))
				I.throw_at(get_edge_target_turf(src,pick(alldirs)),rand(1,3),30)

			qdel(src)

/****************************************************
			   HELPERS
****************************************************/

/obj/item/organ/external/proc/is_stump()
	return 0

// checks if all wounds on the organ are bandaged
/obj/item/organ/external/proc/is_bandaged()
	for(var/datum/wound/W in wounds)
		if(W.internal) continue
		if(!W.bandaged)
			return 0
	return 1

// checks if all wounds on the organ are salved
/obj/item/organ/external/proc/is_salved()
	for(var/datum/wound/W in wounds)
		if(W.internal) continue
		if(!W.salved)
			return 0
	return 1

// checks if all wounds on the organ are disinfected
/obj/item/organ/external/proc/is_disinfected()
	for(var/datum/wound/W in wounds)
		if(W.internal) continue
		if(!W.disinfected)
			return 0
	return 1

/obj/item/organ/external/proc/bandage()
	var/rval = 0
	src.stopBleeding()
	for(var/datum/wound/W in wounds)
		if(W.internal) continue
		rval |= !W.bandaged
		W.bandaged = 1
	return rval

/obj/item/organ/external/proc/salve()
	var/rval = 0
	for(var/datum/wound/W in wounds)
		rval |= !W.salved
		W.salved = 1
	return rval

/obj/item/organ/external/proc/disinfect()
	var/rval = 0
	for(var/datum/wound/W in wounds)
		if(W.internal) continue
		rval |= !W.disinfected
		W.disinfected = 1
		W.germ_level = 0
	return rval

/obj/item/organ/external/proc/clamp_wounds()
	var/rval = 0
	src.stopBleeding()
	for(var/datum/wound/W in wounds)
		if(W.internal) continue
		rval |= !W.clamped
		W.clamped = 1
	return rval

/obj/item/organ/external/proc/setBleeding()
	if(robotic >= ORGAN_ROBOT || !owner.should_have_organ(O_HEART))
		return FALSE
	status |= ORGAN_BLEEDING
	return TRUE

/obj/item/organ/external/proc/stopBleeding()
	status &= ~ORGAN_BLEEDING


/obj/item/organ/external/proc/fracture()
	if(robotic >= ORGAN_ROBOT)
		return	//ORGAN_BROKEN doesn't have the same meaning for robot limbs
	if((status & ORGAN_BROKEN) || cannot_break)
		return

	if(owner)
		owner.visible_message(
			SPAN_DANGER("You hear a loud cracking sound coming from \the [owner]."),
			SPAN_DANGER("Something feels like it shattered in your [name]!"),
			SPAN_DANGER("You hear a sickening crack.")
		)
		if(owner.species && !(owner.species.flags & NO_PAIN))
			owner.emote("scream")

	status |= ORGAN_BROKEN
	broken_description = pick("broken","fracture","hairline fracture")
	perma_injury = brute_dam

	// Fractures have a chance of getting you out of restraints
	if (prob(25))
		drop_items()

	// This is mostly for the ninja suit to stop ninja being so crippled by breaks.
	// TODO: consider moving this to a suit proc or process() or something during
	// hardsuit rewrite.
	if(owner && !(status & ORGAN_SPLINTED) && ishuman(owner))

		var/mob/living/carbon/human/H = owner

		if(H.wear_suit && istype(H.wear_suit,/obj/item/clothing/suit/space))

			var/obj/item/clothing/suit/space/suit = H.wear_suit

			if(isnull(suit.supporting_limbs))
				return

			owner << SPAN_NOTE("You feel \the [suit] constrict about your [name], supporting it.")
			status |= ORGAN_SPLINTED
			suit.supporting_limbs |= src
	return

/obj/item/organ/external/proc/mend_fracture()
	if(robotic >= ORGAN_ROBOT)
		return 0	//ORGAN_BROKEN doesn't have the same meaning for robot limbs
	if(brute_dam > min_broken_damage * config.organ_health_multiplier)
		return 0	//will just immediately fracture again

	status &= ~ORGAN_BROKEN
	return 1

/obj/item/organ/external/proc/mutate()
	if(robotic >= ORGAN_ROBOT)
		return
	status |= ORGAN_MUTATED
	if(owner) owner.update_body()

/obj/item/organ/external/proc/unmutate()
	src.status &= ~ORGAN_MUTATED
	if(owner) owner.update_body()

/obj/item/organ/external/proc/get_damage()	//returns total damage
	return max(brute_dam + burn_dam - perma_injury, perma_injury)	//could use max_damage?

/obj/item/organ/external/proc/has_infected_wound()
	for(var/datum/wound/W in wounds)
		if(W.germ_level > INFECTION_LEVEL_ONE)
			return 1
	return 0

/obj/item/organ/external/is_usable()
	return !is_dislocated() && !(status & (ORGAN_MUTATED|ORGAN_DEAD))

/obj/item/organ/external/proc/is_malfunctioning()
	return ((robotic >= ORGAN_ROBOT) && (brute_dam + burn_dam) >= 10 && prob(brute_dam + burn_dam))

/obj/item/organ/external/proc/embed(var/obj/item/weapon/W, var/silent = 0)
	if(!owner || loc != owner)
		return
	if(ismob(W.loc))
		var/mob/living/H = W.loc
		if(!H.unEquip(W))
			return
	if(!silent)
		owner.visible_message(SPAN_DANGER("\The [W] sticks in the wound!"))
	implants += W
	owner.embedded_flag = 1
	W.add_blood(owner)
	owner.verbs += /mob/proc/yank_out_object
	W.forceMove(owner)

/obj/item/organ/external/proc/disfigure(var/type = "brute")
	if (disfigured)
		return
	if(owner)
		if(type == "brute")
			owner.visible_message(
				SPAN_DANGER("You hear a sickening cracking sound coming from \the [owner]'s [name]."),
				SPAN_DANGER("Your [name] becomes a mangled mess!"),
				SPAN_DANGER("You hear a sickening crack.")
			)
		else
			owner.visible_message(
				SPAN_DANGER("\The [owner]'s [name] melts away, turning into mangled mess!"),
				SPAN_DANGER("Your [name] melts away!"),
				SPAN_DANGER("You hear a sickening sizzle.")
			)
	disfigured = 1

/obj/item/organ/external/proc/get_wounds_desc()
	if(robotic >= ORGAN_ROBOT)
		var/list/descriptors = list()
		if(brute_dam)
			switch(brute_dam)
				if(0 to 20)
					descriptors += "some dents"
				if(21 to INFINITY)
					descriptors += pick("a lot of dents","severe denting")
		if(burn_dam)
			switch(burn_dam)
				if(0 to 20)
					descriptors += "some burns"
				if(21 to INFINITY)
					descriptors += pick("a lot of burns","severe melting")
		if(open)
			descriptors += "an open panel"

		return english_list(descriptors)

	. = ""
	if((status & ORGAN_CUT_AWAY) && !is_stump() && !(parent && parent.status & ORGAN_CUT_AWAY))
		. += "tear at [amputation_point] so severe that it hangs by a scrap of flesh"
	//Normal organic organ damage
	var/list/wound_descriptors = list()
	if(open > 1)
		wound_descriptors["an open incision"] = 1
	else if (open)
		wound_descriptors["an incision"] = 1
	for(var/datum/wound/W in wounds)
		if(W.internal && !open) continue // can't see internal wounds
		var/this_wound_desc = W.desc

		if(W.damage_type == BURN && W.salved)
			this_wound_desc = "salved [this_wound_desc]"

		if(W.bleeding())
			this_wound_desc = "bleeding [this_wound_desc]"
		else if(W.bandaged)
			this_wound_desc = "bandaged [this_wound_desc]"

		if(W.germ_level > 600)
			this_wound_desc = "badly infected [this_wound_desc]"
		else if(W.germ_level > 330)
			this_wound_desc = "lightly infected [this_wound_desc]"

		if(wound_descriptors[this_wound_desc])
			wound_descriptors[this_wound_desc] += W.amount
		else
			wound_descriptors[this_wound_desc] = W.amount

	if(wound_descriptors.len)
		var/list/flavor_text = list()
		var/list/no_exclude = list("gaping wound", "big gaping wound", "massive wound", "large bruise",\
		"huge bruise", "massive bruise", "severe burn", "large burn", "deep burn", "carbonised area") //note to self make this more robust
		for(var/wound in wound_descriptors)
			switch(wound_descriptors[wound])
				if(1)
					flavor_text += "[prob(10) && !(wound in no_exclude) ? "what might be " : ""]a [wound]"
				if(2)
					flavor_text += "[prob(10) && !(wound in no_exclude) ? "what might be " : ""]a pair of [wound]s"
				if(3 to 5)
					flavor_text += "several [wound]s"
				if(6 to INFINITY)
					flavor_text += "a ton of [wound]\s"
		return english_list(flavor_text)
