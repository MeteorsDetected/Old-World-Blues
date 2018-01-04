
/client/verb/who()
	set name = "Who"
	set category = "OOC"

	var/msg = "<b>Current Players:</b>\n"

	var/list/Lines = list()

//for admins
	var/living = 0 //Currently alive and in the round (possibly unconscious, but not officially dead)
	var/dead = 0 //Have been in the round but are now deceased
	var/observers = 0 //Have never been in the round (thus observing)
	var/lobby = 0 //Are currently in the lobby
	var/living_antags = 0 //Are antagonists, and currently alive
	var/dead_antags = 0 //Are antagonists, and have finally met their match

	if(holder && holder.rights&(R_MOD|R_ADMIN))
		for(var/client/C in clients)
			var/entry = "\t[C.key]"
			if(C.holder && C.holder.fakekey)
				entry += " <i>(as [C.holder.fakekey])</i>"
			entry += " - Playing as [C.mob.real_name]"
			switch(C.mob.stat)
				if(UNCONSCIOUS)
					entry += " - <font color='darkgray'><b>Unconscious</b></font>"
				if(DEAD)
					if(isobserver(C.mob))
						var/mob/observer/dead/O = C.mob
						if(O.started_as_observer)
							entry += " - <font color='gray'>Observing</font>"
							observers++
						else
							entry += " - <font color='black'><b>DEAD</b></font>"
							dead++
					else if (isnewplayer(C.mob))
						entry += " - <font color='black'><b>Lobby</b></font>"
						lobby++
					else
						entry += " - <b>DEAD</b>"
						dead++
				else
					living++

			var/age
			if(isnum(C.player_age))
				age = C.player_age
			else
				age = 0

			if(age <= 1)
				age = "<font color='#ff0000'><b>[age]</b></font>"
			else if(age < 10)
				age = "<font color='#ff8c00'><b>[age]</b></font>"

			entry += " - [age]"

			if(C.is_afk())
				var/seconds = C.last_activity_seconds()
				entry += " (AFK - "
				entry += "[round(seconds / 60)] minutes, "
				entry += "[seconds % 60] seconds)"

			if(is_special_character(C.mob))
				entry += " - <b><font color='red'>Antagonist</font></b>"
				if (istype(C.mob, /mob/observer/dead))  ///obj/item/organ/brain //
					dead_antags++
				else
					living_antags++
			entry += " (<A HREF='?_src_=holder;adminmoreinfo=\ref[C.mob]'>?</A>)"
			Lines += entry
	else
		for(var/client/C in clients)
			if(C.holder && C.holder.fakekey)
				Lines += C.holder.fakekey
			else
				Lines += C.key

	for(var/line in sortList(Lines))
		msg += "[line]\n"

	if(holder && (R_ADMIN & holder.rights || R_MOD & holder.rights))
		msg += "<b><span class='notice'>Total Living: [living]</span> | Total Dead: [dead] | <span style='color:gray'>Observing: [observers]</span> | <span style='color:gray'><i>In Lobby: [lobby]</i></span> | <span class='red'>Living Antags: [living_antags]</span> | <span class='green'>Dead Antags: [dead_antags]</span></b>\n"
		msg += "<b>Total Players: [length(Lines)]</b>\n"
		src << msg
	else
		msg += "<b>Total Players: [length(Lines)]</b>"
		src << msg

/client/verb/adminwho()
	set category = "Admin"
	set name = "Adminwho"

	var/msg = "<b>Current Admins:</b>\n"
	if(holder)
		for(var/client/C in admins)
			msg += "\t[C] is a [C.holder.rank]"

			if(C.holder.fakekey)
				msg += " <i>(as [C.holder.fakekey])</i>"

			if(isobserver(C.mob))
				msg += " - Observing"
			else if(isnewplayer(C.mob))
				msg += " - Lobby"
			else
				msg += " - Playing"


			if(C.is_afk())
				var/seconds = C.last_activity_seconds()
				msg += " (AFK - "
				msg += "[round(seconds / 60)] minutes, "
				msg += "[seconds % 60] seconds)"
			msg += "\n"
	else
		for(var/client/C in admins)
			if(!C.holder.fakekey)
				msg += "\t[C] is a [C.holder.rank]\n"

	src << msg
