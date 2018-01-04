/obj/item/organ/internal/cell
	name = "microbattery"
	desc = "A small, powerful cell for use in fully prosthetic bodies."
	icon = 'icons/obj/power.dmi'
	icon_state = "scell"
	organ_tag = "cell"
	parent_organ = BP_CHEST
	vital = 1
	robotic = ORGAN_ROBOT

/obj/item/organ/internal/cell/install()
	if(..()) return 1

	// This is very ghetto way of rebooting an IPC. TODO better way.
	if(owner && owner.stat == DEAD)
		owner.stat = 0
		owner.visible_message("<span class='danger'>\The [owner] twitches visibly!</span>")


/obj/item/organ/cell/Initialize()
	//robotize()
	. = ..()

/obj/item/organ/cell/install()
	. = ..()
	// This is very ghetto way of rebooting an IPC. TODO better way.
	if(owner && owner.stat == DEAD)
		owner.stat = 0
		owner.visible_message("<span class='danger'>\The [owner] twitches visibly!</span>")

/obj/item/organ/eyes/optical_sensor
	name = "optical sensor"
	organ_tag = "optics"
	icon = 'icons/obj/robot_component.dmi'
	icon_state = "camera"
	robotic = ORGAN_LIFELIKE

/obj/item/organ/eyes/optical_sensor/Initialize()
	//robotize()
	. = ..()

/obj/item/organ/ipc_tag
	name = "identification tag"
	organ_tag = "ipc tag"
	parent_organ = BP_CHEST
	icon = 'icons/obj/telescience.dmi'
	icon_state = "gps-c"

/obj/item/organ/ipc_tag/Initialize()
	//robotize()
	. = ..()

// Used for an MMI or posibrain being installed into a human.
/obj/item/organ/mmi_holder
	name = "brain"
	organ_tag = O_BRAIN
	parent_organ = BP_HEAD
	vital = 1
	robotic = ORGAN_ROBOT
	var/obj/item/device/mmi/stored_mmi

/obj/item/organ/mmi_holder/proc/update_from_mmi()
	if(!stored_mmi)
		return
	name = stored_mmi.name
	desc = stored_mmi.desc
	icon = stored_mmi.icon
	icon_state = stored_mmi.icon_state

/obj/item/organ/mmi_holder/removed(var/mob/living/user)

	if(stored_mmi)
		stored_mmi.loc = get_turf(src)
		if(owner.mind)
			owner.mind.transfer_to(stored_mmi.brainmob)
	. = ..()

	var/mob/living/holder_mob = loc
	if(istype(holder_mob))
		holder_mob.drop_from_inventory(src)
	qdel(src)

/obj/item/organ/mmi_holder/Initialize(mapload)
	. = ..()
	// This is very ghetto way of rebooting an IPC. TODO better way.
	if (!mapload)
		CALLBACK(src, .proc/attempt_revive)

/obj/item/organ/mmi_holder/proc/attempt_revive()
	if (owner && owner.stat == DEAD)
		owner.stat = 0
		owner.visible_message("<span class='danger'>\The [owner] twitches visibly!</span>")

/obj/item/organ/mmi_holder/posibrain/Initialize()
	robotize()
	stored_mmi = new /obj/item/device/mmi/digital/posibrain(src)
	. = ..()
	CALLBACK(src, .proc/setup_brain)

/obj/item/organ/mmi_holder/posibrain/proc/setup_brain()
	if(owner)
		stored_mmi = new /obj/item/device/mmi/digital/posibrain(src)
		stored_mmi.name = "positronic brain ([owner.name])"
		stored_mmi.brainmob.real_name = owner.name
		stored_mmi.brainmob.name = stored_mmi.brainmob.real_name
		stored_mmi.icon_state = "posibrain-occupied"
		update_from_mmi()
	else
		stored_mmi.loc = get_turf(src)
		qdel(src)