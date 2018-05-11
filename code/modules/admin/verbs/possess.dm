ADMIN_VERB_ADD(/proc/possess, R_POSSESS)
/proc/possess(obj/O as obj in world)
	set name = "Possess Obj"
	set category = "Object"

	if(istype(O,/obj/singularity))
		if(config.forbid_singulo_possession)
			usr << "It is forbidden to possess singularities."
			return

	log_admin("[key_name(usr)] has possessed [O] ([O.type])", O)

	if(!usr.control_object) //If you're not already possessing something...
		usr.name_archive = usr.real_name

	usr.forceMove(O)
	usr.real_name = O.name
	usr.name = O.name
	usr.reset_view(O)
	usr.control_object = O

	usr.client.verbs += /client/proc/object_talk

ADMIN_VERB_ADD(/proc/release, R_POSSESS)
/proc/release(obj/O as obj in world)
	set name = "Release Obj"
	set category = "Object"
	//usr.forceMove(get_turf(usr))

	//if you have a name archived and if you are actually relassing an object
	if(usr.control_object && usr.name_archive)
		usr.real_name = usr.name_archive
		usr.name = usr.real_name
		if(ishuman(usr))
			var/mob/living/carbon/human/H = usr
			H.name = H.get_visible_name()
//		usr.regenerate_icons() //So the name is updated properly

	usr.forceMove(O.loc) // Appear where the object you were controlling is -- TLE
	usr.reset_view()
	usr.control_object = null

	usr.client.verbs -= /client/proc/object_talk

/client/proc/object_talk(var/msg as text)
	set category = "Special Verbs"
	set name = "oSay"
	set desc = "Display a message to everyone who can hear the target"
	if(mob.control_object)
		if(!msg)
			return
		//todo hearable message
		for (var/mob/V in hearers(mob.control_object))
			V.show_message("<b>[mob.control_object.name]</b> says: \"" + msg + "\"", 2)
/*
/proc/givetestverbs(mob/M as mob in mob_list)
	set desc = "Give this guy possess/release verbs"
	set category = "Debug"
	set name = "Give Possessing Verbs"
	M.verbs += /proc/possess
	M.verbs += /proc/release
*/