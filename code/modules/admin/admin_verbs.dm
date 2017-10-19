/proc/cmd_registrate_verb(var/verb_path, var/rights)
	if(!rights)
		admin_verbs_default += verb_path
	else
		if(rights&R_ADMIN)
			admin_verbs_admin += verb_path
		if(rights&R_BAN)
			admin_verbs_ban += verb_path
		if(rights&R_FUN)
			admin_verbs_fun += verb_path
		if(rights&R_SERVER)
			admin_verbs_server += verb_path
		if(rights&R_SOUNDS)
			admin_verbs_sounds += verb_path
		if(rights&R_POSSESS)
			admin_verbs_possess += verb_path
		if(rights&R_PERMISSIONS)
			admin_verbs_permissions += verb_path
		if(rights&R_REJUVINATE)
			admin_verbs_rejuv += verb_path
		if(rights&R_SPAWN)
			admin_verbs_spawn += verb_path
		if(rights&R_MOD)
			admin_verbs_mod += verb_path
		if(rights&R_DEBUG)
			admin_verbs_debug += verb_path

/hook/startup/proc/registrate_verbs()
	world.registrate_verbs()
	return TRUE

/world/proc/registrate_verbs()


//admin verb groups - They can overlap if you so wish. Only one of each verb will exist in the verbs list regardless
var/list/admin_verbs_default = list()
var/list/admin_verbs_admin = list()
var/list/admin_verbs_ban = list()
var/list/admin_verbs_sounds = list()
var/list/admin_verbs_fun = list()
var/list/admin_verbs_spawn = list()
var/list/admin_verbs_server = list()
var/list/admin_verbs_debug = list()

var/list/admin_verbs_paranoid_debug = list(
	/client/proc/callproc,
	/client/proc/debug_controller,
	/client/proc/callproc_target,
	)

var/list/admin_verbs_possess = list()
var/list/admin_verbs_permissions = list()
var/list/admin_verbs_rejuv = list()

//verbs which can be hidden - needs work
var/list/admin_verbs_hideable = list(
	/client/proc/deadmin_self,
	/client/proc/toggleprayers,
	/client/proc/toggle_hear_radio,
	/datum/admins/proc/show_traitor_panel,
	/datum/admins/proc/toggleenter,
	/datum/admins/proc/announce,
	/client/proc/colorooc,
	/client/proc/admin_ghost,
	/client/proc/toggle_view_range,
	/datum/admins/proc/view_txt_log,
	/datum/admins/proc/view_atk_log,
	/client/proc/cmd_admin_subtle_message,
	/client/proc/cmd_admin_check_contents,
	/datum/admins/proc/access_news_network,
	/client/proc/admin_call_shuttle,
	/client/proc/admin_cancel_shuttle,
	/client/proc/cmd_admin_direct_narrate,
	/client/proc/cmd_admin_world_narrate,
	/client/proc/check_words,
	/client/proc/play_local_sound,
	/client/proc/play_sound,
	/client/proc/play_server_sound,
	/client/proc/object_talk,
	/client/proc/cmd_admin_dress,
	/client/proc/cmd_admin_gib_self,
	/client/proc/drop_bomb,
	/client/proc/cinematic,
	/datum/admins/proc/toggle_aliens,
	/datum/admins/proc/toggle_space_ninja,
	/client/proc/cmd_admin_add_freeform_ai_law,
	/client/proc/cmd_admin_add_random_ai_law,
	/client/proc/cmd_admin_create_centcom_report,
	/client/proc/make_sound,
	/client/proc/toggle_random_events,
	/client/proc/cmd_admin_add_random_ai_law,
	/client/proc/Set_Holiday,
	/client/proc/ToRban,
	/datum/admins/proc/startnow,
	/datum/admins/proc/restart,
	/datum/admins/proc/delay,
	/datum/admins/proc/toggleaban,
	/client/proc/toggle_log_hrefs,
	/datum/admins/proc/immreboot,
	/client/proc/everyone_random,
	/datum/admins/proc/toggleAI,
	/datum/admins/proc/adrev,
	/datum/admins/proc/adspawn,
	/datum/admins/proc/adjump,
//	/client/proc/restart_controller,
	/client/proc/cmd_admin_list_open_jobs,
	/client/proc/callproc,
	/client/proc/Debug2,
	/client/proc/reload_admins,
	/client/proc/kill_air,
	/client/proc/cmd_debug_make_powernets,
//	/client/proc/kill_airgroup,
	/client/proc/debug_controller,
	/client/proc/startSinglo,
	/client/proc/cmd_debug_mob_lists,
	/client/proc/cmd_debug_del_all,
	/client/proc/cmd_debug_tog_aliens,
	/client/proc/air_report,
	/client/proc/enable_debug_verbs,
	/client/proc/roll_dices,
	/client/proc/time_to_respawn,
	/client/proc/toggle_dead_vote,
	/proc/possess,
	/proc/release
	)
var/list/admin_verbs_mod = list()

/client/proc/add_admin_verbs()
	if(holder)
		verbs += admin_verbs_default
		if(holder.rights & R_BUILDMODE)		verbs += /client/proc/togglebuildmodeself
		if(holder.rights & R_ADMIN)			verbs += admin_verbs_admin
		if(holder.rights & R_BAN)			verbs += admin_verbs_ban
		if(holder.rights & R_FUN)			verbs += admin_verbs_fun
		if(holder.rights & R_SERVER)		verbs += admin_verbs_server
		if(holder.rights & R_DEBUG)
			verbs += admin_verbs_debug
			if(config.debugparanoid && !(holder.rights & R_ADMIN))
				verbs.Remove(admin_verbs_paranoid_debug)			//Right now it's just callproc but we can easily add others later on.
		if(holder.rights & R_POSSESS)		verbs += admin_verbs_possess
		if(holder.rights & R_PERMISSIONS)	verbs += admin_verbs_permissions
		if(holder.rights & R_STEALTH)		verbs += /client/proc/stealth
		if(holder.rights & R_REJUVINATE)	verbs += admin_verbs_rejuv
		if(holder.rights & R_SOUNDS)		verbs += admin_verbs_sounds
		if(holder.rights & R_SPAWN)			verbs += admin_verbs_spawn
		if(holder.rights & R_MOD)			verbs += admin_verbs_mod

/client/proc/remove_admin_verbs()
	verbs.Remove(
		admin_verbs_default,
		/client/proc/togglebuildmodeself,
		admin_verbs_admin,
		admin_verbs_ban,
		admin_verbs_fun,
		admin_verbs_server,
		admin_verbs_debug,
		admin_verbs_possess,
		admin_verbs_permissions,
		/client/proc/stealth,
		admin_verbs_rejuv,
		admin_verbs_sounds,
		admin_verbs_spawn,
		debug_verbs
		)


ADMIN_VERB_ADD(/client/proc/hide_most_verbs, null)
/*hides all our hideable adminverbs*/
/client/proc/hide_most_verbs()//Allows you to keep some functionality while hiding some verbs
	set name = "Adminverbs - Hide Most"
	set category = "Admin"

	verbs.Remove(/client/proc/hide_most_verbs, admin_verbs_hideable)
	verbs += /client/proc/show_verbs

	src << "<span class='interface'>Most of your adminverbs have been hidden.</span>"

ADMIN_VERB_ADD(/client/proc/hide_verbs, null)
/*hides all our adminverbs*/
/client/proc/hide_verbs()
	set name = "Adminverbs - Hide All"
	set category = "Admin"

	remove_admin_verbs()
	verbs += /client/proc/show_verbs

	src << "<span class='interface'>Almost all of your adminverbs have been hidden.</span>"
	return

/client/proc/show_verbs()
	set name = "Adminverbs - Show"
	set category = "Admin"

	verbs -= /client/proc/show_verbs
	add_admin_verbs()

	src << "<span class='interface'>All of your adminverbs are now visible.</span>"



ADMIN_VERB_ADD(/client/proc/admin_ghost, R_ADMIN|R_MOD)
/*allows us to ghost/reenter body at will*/
/client/proc/admin_ghost()
	set category = "Admin"
	set name = "Aghost"
	if(!holder)	return
	if(isobserver(mob))
		//re-enter
		var/mob/observer/dead/ghost = mob
		ghost.reenter_corpse()

	else if(isnewplayer(mob))
		src << "<font color='red'>Error: Aghost: Can't admin-ghost whilst in the lobby. Join or Observe first.</font>"
	else
		//ghostize
		var/mob/body = mob
		var/mob/observer/dead/ghost = body.ghostize(1)
		ghost.admin_ghosted = 1
		if(body)
			body.teleop = ghost
			if(!body.key)
				body.key = "@[key]"	//Haaaaaaaack. But the people have spoken. If it breaks; blame adminbus


ADMIN_VERB_ADD(/client/proc/invisimin, R_ADMIN)
/*allows our mob to go invisible/visible*/
/client/proc/invisimin()
	set name = "Invisimin"
	set category = "Admin"
	set desc = "Toggles ghost-like invisibility (Don't abuse this)"
	if(holder && mob)
		if(mob.invisibility == INVISIBILITY_OBSERVER)
			mob.invisibility = initial(mob.invisibility)
			mob << "\red <b>Invisimin off. Invisibility reset.</b>"
			mob.alpha = max(mob.alpha + 100, 255)
		else
			mob.invisibility = INVISIBILITY_OBSERVER
			mob << SPAN_NOTE("<b>Invisimin on. You are now as invisible as a ghost.</b>")
			mob.alpha = max(mob.alpha - 100, 0)

ADMIN_VERB_ADD(/client/proc/time_to_respawn, R_SERVER)
/client/proc/time_to_respawn()
	set category = "Server"
	set name = "Edit time to respawn"

	if(!check_rights(R_SERVER))
		return

	var/temp = 0
	switch(alert("Which type of respawn we going to edit?","Edit time to respawn","Human","Mouse","Cancel"))
		if ("Human")
			temp = input(usr,"Set time (in minutes)","Time to respawn",initial(config.respawn_time)) as num|null
			if (temp >= 0)
				config.respawn_time = temp
				log_admin("[usr.key] edit humans respawn time to [config.respawn_time]")
		if ("Mouse")
			temp = input(usr,"Set time (in minutes)?","Time to respawn",initial(config.respawn_time_mouse)) as num|null
			if (temp >= 0)
				config.respawn_time_mouse = temp
				log_admin("[usr.key] edit mice respawn time to [config.respawn_time_mouse]")
		if ("Cancel")
			return

ADMIN_VERB_ADD(/client/proc/toggle_dead_vote, R_SERVER)
/client/proc/toggle_dead_vote()
	set category = "Server"
	set name = "Toggle Dead Vote"
	if(!check_rights(R_SERVER))	return
	config.vote_no_dead = !config.vote_no_dead
	message_admins("[key_name(usr)] [config.vote_no_dead?"disallow":"allow"] dead voting", 1)

ADMIN_VERB_ADD(/client/proc/player_panel, null)
/client/proc/player_panel()
	set name = "Player Panel"
	set category = "Admin"
	if(holder)
		holder.player_panel_old()

ADMIN_VERB_ADD(/client/proc/player_panel_new, R_ADMIN|R_MOD)
/*shows an interface for all players, with links to various panels*/
/client/proc/player_panel_new()
	set name = "Player Panel New"
	set category = "Admin"
	if(holder)
		holder.player_panel_new()

ADMIN_VERB_ADD(/client/proc/check_antagonists, R_ADMIN|R_MOD)
/client/proc/check_antagonists()
	set name = "Check Antagonists"
	set category = "Admin"
	if(holder)
		holder.check_antagonists()
		log_admin("[usr.key] checked antagonists.", null, 0)

ADMIN_VERB_ADD(/client/proc/unban_panel, R_BAN)
/client/proc/unban_panel()
	set name = "Unban Panel"
	set category = "Admin"
	if(holder)
		if(config.ban_legacy_system)
			holder.unbanpanel()
		else
			holder.DB_ban_panel()

ADMIN_VERB_ADD(/client/proc/game_panel, R_ADMIN)
/*game panel, allows to change game-mode etc*/
/client/proc/game_panel()
	set name = "Game Panel"
	set category = "Admin"
	if(holder)
		holder.Game()

ADMIN_VERB_ADD(/client/proc/secrets, R_ADMIN)
/client/proc/secrets()
	set name = "Secrets"
	set category = "Admin"
	if (holder)
		holder.Secrets()

ADMIN_VERB_ADD(/client/proc/colorooc, R_ADMIN)
/*allows us to set a custom colour for everythign we say in ooc*/
/client/proc/colorooc()
	set category = "Fun"
	set name = "OOC Text Color"
	if(!holder)	return
	var/response = alert(src, "Please choose a distinct color that is easy to read and doesn't mix with all the other chat and radio frequency colors.", "Change own OOC color", "Pick new color", "Reset to default", "Cancel")
	if(response == "Pick new color")
		prefs.ooccolor = input(src, "Please select your OOC colour.", "OOC colour") as color
	else if(response == "Reset to default")
		prefs.ooccolor = initial(prefs.ooccolor)
	prefs.save_preferences()

/client/proc/stealth()
	set category = "Admin"
	set name = "Stealth Mode"
	if(holder)
		if(holder.fakekey)
			holder.fakekey = null
			if(isnewplayer(src.mob))
				mob.name = capitalize(ckey)
		else
			var/new_key = sanitizeName(input("Enter your desired display name.", "Fake Key", key) as text|null, allow_numbers = 1)
			if(!new_key)	return
			if(length(new_key) >= 26)
				new_key = copytext(new_key, 1, 26)
			holder.fakekey = new_key
			if(isnewplayer(mob))
				mob.name = new_key
		log_admin("[usr.key] has turned stealth mode [holder.fakekey ? "ON" : "OFF"]", null, 0)

#define MAX_WARNS 3
#define AUTOBANTIME 30

/client/proc/warn(warned_ckey)
	if(!check_rights(R_ADMIN))	return

	if(!warned_ckey || !istext(warned_ckey))	return
	if(warned_ckey in admin_datums)
		usr << "<font color='red'>Error: warn(): You can't warn admins.</font>"
		return

	var/datum/preferences/D
	var/client/C = directory[warned_ckey]
	if(C)	D = C.prefs
	else	D = preferences_datums[warned_ckey]

	if(!D)
		src << "<font color='red'>Error: warn(): No such ckey found.</font>"
		return

	if(++D.warns >= MAX_WARNS)					//uh ohhhh...you'reee iiiiin trouuuubble O:)
		ban_unban_log_save("[ckey] warned [warned_ckey], resulting in a [AUTOBANTIME] minute autoban.")
		var/datum/admins/Admin = admin_datums[usr.key]
		if(!Admin || !Admin.DB_ban_record(BANTYPE_TEMP, C.mob, AUTOBANTIME, "Autobanning due to too many formal warnings", null, null, C.key))
			AddBan(warned_ckey, D.last_id, "Autobanning due to too many formal warnings", ckey, 1, AUTOBANTIME)
		if(C)
			message_admins("[key_name_admin(src)] has warned [key_name_admin(C)] resulting in a [AUTOBANTIME] minute ban.")
			C << "<font color='red'><BIG><B>You have been autobanned due to a warning by [ckey].</B></BIG><br>This is a temporary ban, it will be removed in [AUTOBANTIME] minutes.</font>"
			del(C)
		else
			message_admins("[key_name_admin(src)] has warned [warned_ckey] resulting in a [AUTOBANTIME] minute ban.")
	else
		if(C)
			C << "<font color='red'><BIG><B>You have been formally warned by an administrator.</B></BIG><br>Further warnings will result in an autoban.</font>"
			message_admins("[key_name_admin(src)] has warned [key_name_admin(C)]. They have [MAX_WARNS-D.warns] strikes remaining.")
		else
			message_admins("[key_name_admin(src)] has warned [warned_ckey] (DC). They have [MAX_WARNS-D.warns] strikes remaining.")
	return


#undef MAX_WARNS
#undef AUTOBANTIME

ADMIN_VERB_ADD(/client/proc/drop_bomb, R_FUN)
/client/proc/drop_bomb() // Some admin dickery that can probably be done better -- TLE
	set category = "Special Verbs"
	set name = "Drop Bomb"
	set desc = "Cause an explosion of varying strength at your location."

	var/turf/epicenter = mob.loc
	var/list/choices = list("Small Bomb", "Medium Bomb", "Big Bomb", "Custom Bomb")
	var/choice = input("What size explosion would you like to produce?") in choices
	switch(choice)
		if(null)
			return 0
		if("Small Bomb")
			explosion(epicenter, 1, 2, 3, 3)
		if("Medium Bomb")
			explosion(epicenter, 2, 3, 4, 4)
		if("Big Bomb")
			explosion(epicenter, 3, 5, 7, 5)
		if("Custom Bomb")
			var/devastation_range = input("Devastation range (in tiles):") as num
			var/heavy_impact_range = input("Heavy impact range (in tiles):") as num
			var/light_impact_range = input("Light impact range (in tiles):") as num
			var/flash_range = input("Flash range (in tiles):") as num
			explosion(epicenter, devastation_range, heavy_impact_range, light_impact_range, flash_range)
	message_admins(SPAN_NOTE("[ckey] creating an admin explosion at [epicenter.loc]."))

/client/proc/give_disease2(mob/T as mob in mob_list) // -- Giacom
	set category = "Fun"
	set name = "Give Disease"
	set desc = "Gives a Disease to a mob."

	var/datum/disease2/disease/D = new /datum/disease2/disease()

	var/severity = 1
	var/greater = input("Is this a lesser, greater, or badmin disease?", "Give Disease") in list("Lesser", "Greater", "Badmin")
	switch(greater)
		if ("Lesser") severity = 1
		if ("Greater") severity = 2
		if ("Badmin") severity = 99

	D.makerandom(severity)
	D.infectionchance = input("How virulent is this disease? (1-100)", "Give Disease", D.infectionchance) as num

	if(ishuman(T))
		var/mob/living/carbon/human/H = T
		if (H.species)
			D.affected_species = list(H.species.get_bodytype())
			if(H.species.primitive_form)
				D.affected_species |= H.species.primitive_form
			if(H.species.greater_form)
				D.affected_species |= H.species.greater_form
	infect_virus2(T,D,1)

	log_admin("[usr.key] gave [key_name(T)] a [greater] disease2 with infection chance [D.infectionchance].", T)

ADMIN_VERB_ADD(/client/proc/make_sound, R_FUN)
/client/proc/make_sound(var/obj/O in world) // -- TLE
	set category = "Special Verbs"
	set name = "Make Sound"
	set desc = "Display a message to everyone who can hear the target"
	if(O)
		var/message = sanitize(input("What do you want the message to be?", "Make Sound") as text|null)
		if(!message)
			return
		for (var/mob/V in hearers(O))
			V.show_message(message, 2)
		log_admin("[usr.key] made [O] make a sound \"[message]\".", O, 0)


/client/proc/togglebuildmodeself()
	set name = "Toggle Build Mode Self"
	set category = "Special Verbs"
	if(src.mob)
		togglebuildmode(src.mob)

ADMIN_VERB_ADD(/client/proc/object_talk, R_FUN)
/client/proc/object_talk(var/msg as text) // -- TLE
	set category = "Special Verbs"
	set name = "oSay"
	set desc = "Display a message to everyone who can hear the target"
	if(mob.control_object)
		if(!msg)
			return
		for (var/mob/V in hearers(mob.control_object))
			V.show_message("<b>[mob.control_object.name]</b> says: \"" + msg + "\"", 2)

ADMIN_VERB_ADD(/client/proc/kill_air, R_DEBUG)
/client/proc/kill_air() // -- TLE
	set category = "Debug"
	set name = "Kill Air"
	set desc = "Toggle Air Processing"
	if(air_processing_killed)
		air_processing_killed = 0
		usr << "<b>Enabled air processing.</b>"
	else
		air_processing_killed = 1
		usr << "<b>Disabled air processing.</b>"
	log_admin("[usr.key] used 'kill air'.")

/client/proc/readmin_self()
	set name = "Re-Admin self"
	set category = "Admin"

	if(deadmin_holder)
		deadmin_holder.reassociate()
		log_admin("[src] re-admined themself.")
		src << "<span class='interface'>You now have the keys to control the planet, or atleast a small space station</span>"
		verbs -= /client/proc/readmin_self

ADMIN_VERB_ADD(/client/proc/deadmin_self, null)
/*destroys our own admin datum so we can play as a regular player*/
/client/proc/deadmin_self()
	set name = "De-admin self"
	set category = "Admin"

	if(holder)
		if(alert("Confirm self-deadmin for the round? You can't re-admin yourself without someont promoting you.",,"Yes","No") == "Yes")
			log_admin("[src] deadmined themself.")
			deadmin()
			src << "<span class='interface'>You are now a normal player.</span>"
			verbs |= /client/proc/readmin_self

ADMIN_VERB_ADD(/client/proc/toggle_log_hrefs, R_SERVER)
/client/proc/toggle_log_hrefs()
	set name = "Toggle href logging"
	set category = "Server"
	if(!holder)	return
	if(config)
		if(config.log_hrefs)
			config.log_hrefs = 0
			src << "<b>Stopped logging hrefs</b>"
		else
			config.log_hrefs = 1
			src << "<b>Started logging hrefs</b>"

ADMIN_VERB_ADD(/client/proc/check_ai_laws, R_ADMIN)
/*shows AI and borg laws*/
/client/proc/check_ai_laws()
	set name = "Check AI Laws"
	set category = "Admin"
	if(holder)
		src.holder.output_ai_laws()

ADMIN_VERB_ADD(/client/proc/rename_silicon, R_ADMIN)
/*properly renames silicons*/
/client/proc/rename_silicon()
	set name = "Rename Silicon"
	set category = "Admin"

	if(!check_rights(R_ADMIN)) return

	var/mob/living/silicon/S = input("Select silicon.", "Rename Silicon.") as null|anything in silicon_mob_list
	if(!S) return

	var/new_name = sanitizeSafe(input(src, "Enter new name. Leave blank or as is to cancel.", "[S.real_name] - Enter new silicon name", S.real_name))
	if(new_name && new_name != S.real_name)
		log_admin("[usr.ckey] has renamed the silicon '[S.real_name]' to '[new_name]'")
		S.SetName(new_name)

ADMIN_VERB_ADD(/client/proc/manage_silicon_laws, R_ADMIN)
/* Allows viewing and editing silicon laws. */
/client/proc/manage_silicon_laws()
	set name = "Manage Silicon Laws"
	set category = "Admin"

	if(!check_rights(R_ADMIN)) return

	var/mob/living/silicon/S = input("Select silicon.", "Manage Silicon Laws") as null|anything in silicon_mob_list
	if(!S) return

	var/obj/nano_module/law_manager/L = new(S)
	L.ui_interact(usr, state = admin_state)
	log_and_message_admins("has opened [S]'s law manager.")

ADMIN_VERB_ADD(/client/proc/change_human_appearance_admin, R_ADMIN)
/* Allows an admin to change the basic appearance of human-based mobs */
/client/proc/change_human_appearance_admin()
	set name = "Change Mob Appearance - Admin"
	set desc = "Allows you to change the mob appearance"
	set category = "Admin"

	if(!check_rights(R_FUN)) return

	var/mob/living/carbon/human/H = input("Select mob.", "Change Mob Appearance - Admin") as null|anything in human_mob_list
	if(!H) return

	log_and_message_admins("is altering the appearance of [H].")
	H.change_appearance(APPEARANCE_ALL, usr, usr, check_species_whitelist = 0, state = admin_state)


ADMIN_VERB_ADD(/client/proc/change_human_appearance_self, R_ADMIN)
/* Allows the human-based mob itself change its basic appearance */
/client/proc/change_human_appearance_self()
	set name = "Change Mob Appearance - Self"
	set desc = "Allows the mob to change its appearance"
	set category = "Admin"

	if(!check_rights(R_FUN)) return

	var/mob/living/carbon/human/H = input("Select mob.", "Change Mob Appearance - Self") as null|anything in human_mob_list
	if(!H) return

	if(!H.client)
		usr << "Only mobs with clients can alter their own appearance."
		return

	switch(alert("Do you wish for [H] to be allowed to select non-whitelisted races?","Alter Mob Appearance","Yes","No","Cancel"))
		if("Yes")
			log_and_message_admins("has allowed [H] to change \his appearance, without whitelisting of races.")
			H.change_appearance(APPEARANCE_ALL, H.loc, check_species_whitelist = 0)
		if("No")
			log_and_message_admins("has allowed [H] to change \his appearance, with whitelisting of races.")
			H.change_appearance(APPEARANCE_ALL, H.loc, check_species_whitelist = 1)

ADMIN_VERB_ADD(/client/proc/change_security_level, R_ADMIN)
/client/proc/change_security_level()
	set name = "Set security level"
	set desc = "Sets the station security level"
	set category = "Admin"

	if(!check_rights(R_ADMIN))	return
	var sec_level = input(usr, "It's currently code [get_security_level()].", "Select Security Level")  as null|anything in (list("green","blue","red","delta")-get_security_level())
	if(alert("Switch from code [get_security_level()] to code [sec_level]?","Change security level?","Yes","No") == "Yes")
		set_security_level(sec_level)
		log_admin("[usr.key] changed the security level to code [sec_level].")

/client/proc/playernotes()
	set name = "Show Player Info"
	set category = "Admin"
	if(holder)
		holder.PlayerNotes()
	return

ADMIN_VERB_ADD(/client/proc/free_slot, R_ADMIN)
/*frees slot for chosen job*/
/client/proc/free_slot()
	set name = "Free Job Slot"
	set category = "Admin"
	if(holder)
		var/list/jobs = list()
		for (var/datum/job/J in job_master.occupations)
			if (J.current_positions >= J.total_positions && J.total_positions != -1)
				jobs += J.title
		if (!jobs.len)
			usr << "There are no fully staffed jobs."
			return
		var/job = input("Please select job slot to free", "Free job slot")  as null|anything in jobs
		if (job)
			job_master.FreeRole(job)
			message_admins("A job slot for [job] has been opened by [key_name_admin(usr)]")
			return

ADMIN_VERB_ADD(/client/proc/toggleattacklogs, R_ADMIN)
/client/proc/toggleattacklogs()
	set name = "Toggle Attack Log Messages"
	set category = "Preferences"

	prefs.chat_toggles ^= CHAT_ATTACKLOGS
	if (prefs.chat_toggles & CHAT_ATTACKLOGS)
		usr << "You now will get attack log messages"
	else
		usr << "You now won't get attack log messages"


ADMIN_VERB_ADD(/client/proc/toggleghostwriters, R_ADMIN)
/client/proc/toggleghostwriters()
	set name = "Toggle ghost writers"
	set category = "Server"
	if(!holder)	return
	if(config)
		if(config.cult_ghostwriter)
			config.cult_ghostwriter = 0
			src << "<b>Disallowed ghost writers.</b>"
			message_admins("Admin [key_name_admin(usr)] has disabled ghost writers.", 1)
		else
			config.cult_ghostwriter = 1
			src << "<b>Enabled ghost writers.</b>"
			message_admins("Admin [key_name_admin(usr)] has enabled ghost writers.", 1)

ADMIN_VERB_ADD(/client/proc/toggledrones, R_ADMIN)
/client/proc/toggledrones()
	set name = "Toggle maintenance drones"
	set category = "Server"
	if(!holder)	return
	if(config)
		if(config.allow_drone_spawn)
			config.allow_drone_spawn = 0
			src << "<b>Disallowed maint drones.</b>"
			message_admins("Admin [key_name_admin(usr)] has disabled maint drones.", 1)
		else
			config.allow_drone_spawn = 1
			src << "<b>Enabled maint drones.</b>"
			message_admins("Admin [key_name_admin(usr)] has enabled maint drones.", 1)

ADMIN_VERB_ADD(/client/proc/toggledebuglogs, R_ADMIN|R_MOD|R_DEBUG)
/client/proc/toggledebuglogs()
	set name = "Toggle Debug Log Messages"
	set category = "Preferences"

	prefs.chat_toggles ^= CHAT_DEBUGLOGS
	if (prefs.chat_toggles & CHAT_DEBUGLOGS)
		usr << "You now will get debug log messages"
	else
		usr << "You now won't get debug log messages"

ADMIN_VERB_ADD(/client/proc/togglemodelogs, R_ADMIN|R_MOD)
/client/proc/togglemodelogs()
	set name = "Toggle GameMode Log Messages"
	set category = "Preferences"

	prefs.chat_toggles ^= CHAT_GAMEMODELOGS
	if (prefs.chat_toggles & CHAT_GAMEMODELOGS)
		usr << "You now will get game mode log messages"
	else
		usr << "You now won't get game mode log messages"


ADMIN_VERB_ADD(/client/proc/add_supply_pack, R_SPAWN)
/client/proc/add_supply_pack()
	set category = "Fun"
	set name = "Add supply pack"
	set desc = "Add custom supply pack, it will be available in cargo"

	if( !src.holder ) return
	var/obj/structure/closet/MD = src.holder.marked_datum
	if( src.holder.marked_datum==null || (!istype(MD)&&!istype(MD, /obj/structure/largecrate)) )
		alert( "You must select any object with type \"/obj/structure/closet\" as \"Marked object\" ( VV-> mark object) before we can start", "Error", "Ok" )
		return

	var/name = "Custom supply pack"
	var/cost = 8
	var/access = MD.req_access.len?MD:req_access[1]:0
	var/containername = MD.name
	var/containertype = MD.type
	var/group = "Operations"
	var/hide = 0
	var/contains = list()
	var/error = 1

	for( var/atom/movable/AM in MD.contents )
		contains += AM.type

	while( error )
		name = input( "Enter supply pack new name\nIt will be displayed in cargo cosole\nNo name for exit", "Name", name ) as text|null
		var/clear_name = sanitizeName(name, 1, 50)
		if( !name == clear_name )
			if(alert("Inputed name have bad symbols! New name is [clear_name]", "Warning", "Ok", "Enter new name") == "Ok")
				name = clear_name
			else
				continue
		if( !name && alert( "Name is requied!", "Error", "Retry", "Abort") == "Abort") return
		else if( supply_controller.supply_packs.Find(name) )
			if (alert( "Name must be unic!", "Error", "Retry", "Abort") == "Abort") return
		else
			error = 0

	error = 1
	while( error )
		cost = input( "Enter supply pack new cost (in supply points)\nIt must be >= 8", "Cost", cost) as num|null
		if( cost >= 8 ) error = 0
		else if (alert( "Cost must be >= 8!", "Error", "Retry", "Abort") == "Abort") return

	if(istype(MD, /obj/structure/closet/crate/secure))
		error = 1
		while( error )
			access = input( "Enter req access level (sorry only digit form for now).\nSee code/game/jobs/access.dm for help", "Access", access) as num|null
			if( access >= 0 ) error = 0
			else if (alert( "Access can't be < 0", "Error", "Retry", "Abort") == "Abort") return
	else
		access = 0

	group = input( "Select group for pack", "Group", group) in all_supply_groups

	hide = alert( "Pack must be visiable only in hacked console?", "Hide", "No", "Yes")=="Yes" ? 1 : 0

	var/datum/supply_packs/custom/CP = new( \
		name, cost, access, containername, \
		containertype, group, hide, contains )

	if( supply_controller.supply_packs.Find(name) )
		log_debug("Supply pack [name] already exist!")
	else
		supply_controller.supply_packs[name] = CP
		usr << "Supply pack [name] successfully created!"
		log_admin("[usr.key] has add custom supply pack [name]", null, 0)


ADMIN_VERB_ADD(/client/proc/man_up, R_ADMIN)
/client/proc/man_up(mob/T as mob in mob_list)
	set category = "Fun"
	set name = "Man Up"
	set desc = "Tells mob to man up and deal with it."

	T << SPAN_NOTE("<b><font size=3>Man up and deal with it.</font></b>")
	T << SPAN_NOTE("Move on.")
	T << 'sound/voice/ManUp1.ogg'

	log_admin("[usr.key] told [key_name(T)] to man up and deal with it.", T)

ADMIN_VERB_ADD(/client/proc/global_man_up, R_ADMIN)
/client/proc/global_man_up()
	set category = "Fun"
	set name = "Man Up Global"
	set desc = "Tells everyone to man up and deal with it."

	for (var/mob/T as mob in mob_list)
		T << "<br><center><span class='notice'><b><font size=4>Man up.<br> Deal with it.</font></b><br>Move on.</span></center><br>"
		T << 'sound/voice/ManUp1.ogg'

	log_admin("[usr.key] told everyone to man up and deal with it.", usr)

/client/proc/give_spell(mob/T as mob in mob_list) // -- Urist
	set category = "Fun"
	set name = "Give Spell"
	set desc = "Gives a spell to a mob."
	var/spell/S = input("Choose the spell to give to that guy", "ABRAKADABRA") as null|anything in spells
	if(!S) return
	T.spell_list += new S
	log_admin("[usr.key] gave [key_name(T)] the spell [S].", T)


ADMIN_VERB_ADD(/datum/admins/proc/paralyze_mob, R_ADMIN)
/datum/admins/proc/paralyze_mob(mob/living/carbon/human/H as mob)
	set category = "Admin"
	set name = "Toggle Paralyze"
	set desc = "Paralyzes a player. Or unparalyses them."

	if(check_rights(R_ADMIN|R_MOD))
		if (H.paralysis == 0)
			H.paralysis = 1000
			log_admin("[usr.key] has paralyzed [key_name(H)].", H)
		else
			H.paralysis = 0
			log_admin("[usr.key] has unparalyzed [key_name(H)].", H)

