var/global/datum/controller/occupations/job_master

#define GET_RANDOM_JOB 0
#define BE_ASSISTANT 1
#define RETURN_TO_LOBBY 2

/datum/controller/occupations
		//List of all jobs
	var/list/occupations = list()
	var/list/occupations_by_name = list()
		//Players who need jobs
	var/list/unassigned = list()
		//Debug info
	var/list/job_debug = list()
	 	//used for checking against population caps
	var/initial_players_to_assign = 0


	proc/SetupOccupations(var/faction = "Station")
		occupations.Cut()
		occupations_by_name.Cut()
		var/list/all_jobs = typesof(/datum/job)
		if(!all_jobs.len)
			world << "<span class='warning'>Error setting up jobs, no job datums found!</span>"
			return 0
		for(var/J in all_jobs)
			var/datum/job/job = new J()
			if(!job)	continue
			if(job.title == "BASIC") continue
			if(job.faction != faction)	continue
			occupations += job
			occupations_by_name[job.title] = job
		return 1


	proc/Debug(var/text)
		if(!Debug2)	return 0
		job_debug.Add(text)
		return 1

	proc/GetJob(var/rank)
		if(!rank)	return null
		return occupations_by_name[rank]

	proc/GetPlayerAltTitle(mob/new_player/player, rank)
		return player.client.prefs.GetPlayerAltTitle(GetJob(rank))

	proc/CanJoinJob(var/mob/player, var/rank)
		if(!rank)
			return 0
		if(!player)
			return 0

		var/datum/job/job = GetJob(rank)

		if(!job)
			return 0
		if(!job.available_to(player))
			return 0
		return 1

	proc/AssignRole(var/mob/new_player/player, var/rank, var/latejoin = 0)
		Debug("Running AR, Player: [player], Rank: [rank], LJ: [latejoin]")
		if(player && player.mind && rank)
			var/datum/job/job = GetJob(rank)
			/*
			if(!job)
				Debug("AR has failed. Job can't be found. Player: [player], Rank: [rank]")
				return 0
			if(job.minimum_character_age && (player.client.prefs.age < job.minimum_character_age))
				Debug("AR has failed, Player too young")
				return 0
			if(jobban_isbanned(player, rank))
				Debug("AR has failed, Player is jobbaned")
				return 0
			if(player.IsJobRestricted(rank))
				Debug("AR has failed, Job restricted.")
				return 0
			if(!job.player_old_enough(player.client))
				Debug("AR has failed, Player account is not old enough.")
				return 0
				*/

			if(!CanJoinJob(player, rank))
				return 0

			if(job.is_position_available(latejoin))
				Debug("Player: [player] is now Rank: [rank], JCP:[job.current_positions]")
				player.mind.assigned_role = rank
				player.mind.role_alt_title = rank
				if(GetPlayerAltTitle(player, rank) in job.alt_titles)
					player.mind.role_alt_title = GetPlayerAltTitle(player, rank)
				unassigned -= player
				job.current_positions++
				return 1
		Debug("AR has failed, Player: [player], Rank: [rank]")
		return 0

	proc/FreeRole(var/rank)	//making additional slot on the fly
		var/datum/job/job = GetJob(rank)
		if(job && job.current_positions >= job.total_positions && job.total_positions != -1)
			job.total_positions++
			return 1
		return 0

	proc/FindOccupationCandidates(datum/job/job, level)
		Debug("Running FOC, Job: [job], Level: [level]")
		var/list/candidates = list()
		for(var/mob/new_player/player in unassigned)
			if(jobban_isbanned(player, job.title))
				Debug("FOC isbanned failed, Player: [player]")
				continue
			if(player.IsJobRestricted(job.title))
				Debug("FOC IsJobRestricted failed, Player: [player]")
				continue
			if(!job.player_old_enough(player.client))
				Debug("FOC player not old enough, Player: [player]")
				continue
			if(job.minimum_character_age && (player.client.prefs.age < job.minimum_character_age))
				Debug("FOC character not old enough, Player: [player]")
				continue
			if(player.client.prefs.GetJobDepartment(job, level) & job.flag)
				Debug("FOC pass, Player: [player], Level:[level]")
				candidates += player
		return candidates

	proc/GiveRandomJob(var/mob/new_player/player)
		Debug("GRJ Giving random job, Player: [player]")
		for(var/datum/job/job in shuffle(occupations))
			if(!job)
				continue

			if(job.minimum_character_age && (player.client.prefs.age < job.minimum_character_age))
				continue

			if(istype(job, GetJob("Assistant"))) // We don't want to give him assistant, that's boring!
				continue

			if(job.title in command_positions) //If you want a command position, select it!
				continue

			if(jobban_isbanned(player, job.title))
				Debug("GRJ isbanned failed, Player: [player], Job: [job.title]")
				continue

			if(player.IsJobRestricted(job.title))
				Debug("GRJ IsJobRestricted failed, Player: [player]")
				continue

			if(!job.player_old_enough(player.client))
				Debug("GRJ player not old enough, Player: [player]")
				continue

			if((job.current_positions < job.spawn_positions) || job.spawn_positions == -1)
				Debug("GRJ Random job given, Player: [player], Job: [job]")
				AssignRole(player, job.title)
				unassigned -= player
				break

	proc/ResetOccupations()
		for(var/mob/new_player/player in player_list)
			if((player) && (player.mind))
				player.mind.assigned_role = null
				player.mind.special_role = null
		SetupOccupations()
		unassigned = list()
		return


	///This proc is called before the level loop of DivideOccupations() and will try to select a head, \
	ignoring ALL non-head preferences for every level until it locates a head or runs out of levels to check
	proc/FillHeadPosition()
		for(var/level = 1 to 3)
			for(var/command_position in command_positions)
				var/datum/job/job = GetJob(command_position)
				if(!job)	continue
				var/list/candidates = FindOccupationCandidates(job, level)
				if(!candidates.len)	continue

				// Build a weighted list, weight by age.
				var/list/weightedCandidates = list()
				for(var/mob/V in candidates)
					// Log-out during round-start? What a bad boy, no head position for you!
					if(!V.client) continue
					var/age = V.client.prefs.age

					if(age < job.minimum_character_age) // Nope.
						continue

					if (age > (job.ideal_character_age+20))
						weightedCandidates[V] = 3
					else if (age > (job.ideal_character_age+10))
						weightedCandidates[V] = 6 // Still good.
					else if (age > (job.ideal_character_age-10))
						weightedCandidates[V] = 10 // Great.
					else if (age > (job.minimum_character_age+10))
						weightedCandidates[V] = 6 // Better.
					else if (age > job.minimum_character_age)
						weightedCandidates[V] = 3 // Still a bit young.
					else if(candidates.len == 1)
						weightedCandidates[V] = 1 // If there's ABSOLUTELY NOBODY ELSE


				var/mob/new_player/candidate = pickweight(weightedCandidates)
				if(AssignRole(candidate, command_position))
					return 1
		return 0


	///This proc is called at the start of the level loop of DivideOccupations() and \
	will cause head jobs to be checked before any other jobs of the same level
	proc/CheckHeadPositions(var/level)
		for(var/command_position in command_positions)
			var/datum/job/job = GetJob(command_position)
			if(!job)	continue
			var/list/candidates = FindOccupationCandidates(job, level)
			if(!candidates.len)	continue
			var/mob/new_player/candidate = pick(candidates)
			AssignRole(candidate, command_position)
		return


	proc/FillAIPosition()
		var/ai_selected = 0
		var/datum/job/job = GetJob("AI")
		if(!job)	return 0
		if(config && !config.allow_ai)	return 0

		for(var/i = job.total_positions, i > 0, i--)
			for(var/level = 1 to 3)
				var/list/candidates = list()
				candidates = FindOccupationCandidates(job, level)

				if(ticker.mode.name == "AI malfunction")
					for(var/mob/player in candidates)
						if(!ROLE_MALFUNCTION in player.client.prefs.special_toggles)
							candidates -= player

				if(candidates.len)
					var/mob/new_player/candidate = pick(candidates)
					if(AssignRole(candidate, "AI"))
						ai_selected++
						break
			if((ticker.mode.name == "AI malfunction")&&(!ai_selected))
				unassigned = shuffle(unassigned)
				for(var/mob/new_player/player in unassigned)
					if(jobban_isbanned(player, "AI"))
						continue
					if(AssignRole(player, "AI"))
						ai_selected++
						break
			if(ai_selected)	return 1
			return 0


/** Proc DivideOccupations
 *  fills var "assigned_role" for all ready players.
 *  This proc must not have any side effect besides of modifying "assigned_role".
 **/
	proc/DivideOccupations()
		//Setup new player list and get the jobs list
		Debug("Running DO")
		SetupOccupations()

		//Get the players who are ready
		for(var/mob/new_player/player in player_list)
			if(jobban_isbanned(player, player.client.prefs.species))
				player.ready = 0
				player << "<span class='warning'>You are banned from playing as [player.client.prefs.species]</span>"
				continue
			if(player.ready && player.mind && !player.mind.assigned_role)
				unassigned += player

		Debug("DO, Len: [unassigned.len]")
		if(unassigned.len == 0)	return 0

		//Shuffle players and jobs
		unassigned = shuffle(unassigned)

		HandleFeedbackGathering()

		//People who wants to be assistants, sure, go on.
		Debug("DO, Running Assistant Check 1")
		var/datum/job/assist = GetJob("Assistant")
		var/list/assistant_candidates = FindOccupationCandidates(assist, 3)
		Debug("AC1, Candidates: [assistant_candidates.len]")
		for(var/mob/new_player/player in assistant_candidates)
			Debug("AC1 pass, Player: [player]")
			AssignRole(player, "Assistant")
			assistant_candidates -= player
		Debug("DO, AC1 end")

		//Select one head
		Debug("DO, Running Head Check")
		FillHeadPosition()
		Debug("DO, Head Check end")

		//Check for an AI
		Debug("DO, Running AI Check")
		FillAIPosition()
		Debug("DO, AI Check end")

		//Other jobs are now checked
		Debug("DO, Running Standard Check")


		// New job giving system by Donkie
		// This will cause lots of more loops, but since it's only done once it shouldn't really matter much at all.
		// Hopefully this will add more randomness and fairness to job giving.

		// Loop through all levels from high to low
		var/list/shuffledoccupations = shuffle(occupations)
		for(var/level = 1 to 3)
			//Check the head jobs first each level
			CheckHeadPositions(level)

			// Loop through all unassigned players
			for(var/mob/new_player/player in unassigned)
				if(PopcapReached())
					RejectPlayer(player)

				// Loop through all jobs
				for(var/datum/job/job in shuffledoccupations) // SHUFFLE ME BABY
					if(!job)
						continue

					if(jobban_isbanned(player, job.title))
						Debug("DO isbanned failed, Player: [player], Job:[job.title]")
						continue

					if(player.IsJobRestricted(job.title))
						Debug("DO IsJobRestricted failed, Player: [player]")
						continue

					if(!job.player_old_enough(player.client))
						Debug("DO player not old enough, Player: [player], Job:[job.title]")
						continue

					// If the player wants that job on this level, then try give it to him.
					if(player.client.prefs.GetJobDepartment(job, level) & job.flag)

						// If the job isn't filled
						if((job.current_positions < job.spawn_positions) || job.spawn_positions == -1)
							Debug("DO pass, Player: [player], Level:[level], Job:[job.title]")
							AssignRole(player, job.title)
							unassigned -= player
							break

		// Hand out random jobs to the people who didn't get any in the last check
		// Also makes sure that they got their preference correct
		for(var/mob/new_player/player in unassigned)
			if(player.client.prefs.alternate_option == GET_RANDOM_JOB)
				GiveRandomJob(player)

		Debug("DO, Standard Check end")

		Debug("DO, Running AC2")

		// For those who wanted to be assistant if their preferences were filled, here you go.
		for(var/mob/new_player/player in unassigned)
			if(player.client.prefs.alternate_option == BE_ASSISTANT)
				Debug("AC2 Assistant located, Player: [player]")
				AssignRole(player, "Assistant")

		//For ones returning to lobby
		for(var/mob/new_player/player in unassigned)
			if(player.client.prefs.alternate_option == RETURN_TO_LOBBY)
				player.ready = 0
				player.new_player_panel_proc()
				unassigned -= player
		return 1


	proc/EquipRank(var/mob/living/carbon/human/H, var/rank)
		if(!H)	return null

		H.job = rank

		var/datum/job/job = GetJob(rank)
		var/list/put_in_storage = list()

		if(!job)
			H << "Your job is [rank] and the game just can't handle it! Please report this bug to an administrator."
			return H

		var/hidden_type = all_socks[H.client.prefs.socks]
		if(hidden_type)
			H.equip_to_slot_or_del(new hidden_type, slot_socks)
		hidden_type = all_underwears[H.client.prefs.underwear]
		if(hidden_type)
			H.equip_to_slot_or_del(new hidden_type, slot_underwear)
		hidden_type = all_undershirts[H.client.prefs.undershirt]
		if(hidden_type)
			H.equip_to_slot_or_del(new hidden_type, slot_undershirt)

		//Equip custom gear loadout.
		var/list/custom_equip_slots = list(slot_in_backpack) //If more than one item takes the same slot, all after the first one spawn in storage.
		var/list/custom_equip_leftovers = list()
		if(H.client.prefs.gear && H.client.prefs.gear.len)
			for(var/thing in H.client.prefs.gear)
				var/datum/gear/G = gear_datums[thing]
				if(!G)
					continue
				var/obj/item/I = G.spawn_for(H, H.client.prefs.gear[thing])
				if(!I)
					continue

				if(G.slot && !(G.slot in custom_equip_slots))
					// This is a miserable way to fix the loadout overwrite bug, but the alternative requires
					// adding an arg to a bunch of different procs. Will look into it after this merge. ~ Z
					if(G.slot in list(slot_wear_mask,  slot_wear_suit, slot_head))
						custom_equip_leftovers.Add(I)
					else if(H.equip_to_slot_if_possible(I, G.slot))
						H << SPAN_NOTE("Equipping you with [I]!")
						custom_equip_slots.Add(G.slot)
					else
						custom_equip_leftovers.Add(I)
				else
					put_in_storage.Add(I)

		//Equip job items.
		job.equip(H)
		job.setup_account(H)
		job.apply_fingerprints(H)

		//If some custom items could not be equipped before, try again now.
		for(var/obj/item/I in custom_equip_leftovers)
			if(H.equip_to_appropriate_slot(I))
				H << SPAN_NOTE("Equipping you with \the [I]!")
			else
				put_in_storage.Add(I)

		// If they're head, give them the account info for their department
		if(H.mind && job.head_position)
			var/remembered_info = ""
			var/datum/money_account/department_account = department_accounts[job.department]

			if(department_account)
				remembered_info += "<b>Your department's account number is:</b> #[department_account.account_number]<br>"
				remembered_info += "<b>Your department's account pin is:</b> [department_account.remote_access_pin]<br>"
				remembered_info += "<b>Your department's account funds are:</b> $[department_account.money]<br>"

			H.mind.store_memory(remembered_info)

		var/alt_title = null
		if(H.mind)
			H.mind.assigned_role = rank
			alt_title = H.mind.role_alt_title

		//Deferred item spawning.
		if(put_in_storage.len)
			var/obj/item/storage/B
			if(istype(H.back, /obj/item/storage))
				B = H.back
			else
				B = locate(/obj/item/storage) in H.contents

			if(isnull(B))
				H << "<span class='danger'>Failed to locate a storage object on your mob, either you spawned with no arms and no backpack or this is a bug.</span>"
			else
				for(var/obj/item/I in put_in_storage)
					H << SPAN_NOTE("Placing \the [I] in your [B.name]!")
					B.handle_item_insertion(I, 1)
					I.forceMove(B)

		if(istype(H) && !H.buckled) //give humans wheelchairs, if they need them.
			if(!H.get_organ(BP_L_FOOT) && !H.get_organ(BP_R_FOOT))
				var/obj/structure/material/chair/wheelchair/W = new (H.loc)
				W.set_dir(H.dir)
				W.buckle_mob(H)
				W.add_fingerprint(H)

		H << "<B>You are [job.total_positions == 1 ? "the" : "a"] [alt_title ? alt_title : rank].</B>"

		if(job.supervisors)
			H << "<b>As the [alt_title ? alt_title : rank] you answer directly to [job.supervisors]. \
				  Special circumstances may change this.</b>"

		if(job.idtype)
			spawnId(H, rank, alt_title)

		if(job.req_admin_notify)
			H << "<b>You are playing a job that is important for Game Progression. \
				  If you have to disconnect, please notify the admins via adminhelp.</b>"

		//Gives glasses to the vision impaired
		if(H.disabilities & NEARSIGHTED)
			var/equipped = H.equip_to_slot_or_del(new /obj/item/clothing/glasses/regular(H), slot_glasses)
			if(equipped != 1)
				var/obj/item/clothing/glasses/G = H.glasses
				G.prescription = 1

		H.update_icons() //Draw PDA, ID, glasses, etc.

		BITSET(H.hud_updateflag, ID_HUD)
		BITSET(H.hud_updateflag, IMPLOYAL_HUD)
		BITSET(H.hud_updateflag, SPECIALROLE_HUD)
		return H

	proc/MoveAtSpawnPoint(var/mob/living/carbon/human/H, rank)
		if(!H || rank == "AI")	return 0

		var/obj/S = null
		for(var/obj/effect/landmark/start/sloc in landmarks_list)
			if(sloc.name != rank)	continue
			if(locate(/mob/living) in sloc.loc)	continue
			S = sloc
			break
		if(!S)
			S = locate("start*[rank]") // use old stype
		if(istype(S, /obj/effect/landmark/start) && istype(S.loc, /turf))
			H.forceMove(S.loc)
		// Moving wheelchair if they have one
		if(H.buckled && istype(H.buckled, /obj/structure/material/chair/wheelchair))
			H.buckled.forceMove(H.loc)
			H.buckled.set_dir(H.dir)

	proc/spawnId(var/mob/living/carbon/human/H, rank, title)
		if(!H || rank == "Cyborg")	return 0
		var/obj/item/weapon/card/id/C = null

		var/datum/job/job = GetJob(rank)

		if(job)
			C = new job.idtype(H)
			C.access = job.get_access()
		else
			C = new /obj/item/weapon/card/id(H)
		if(C)
			C.registered_name = H.real_name
			C.rank = rank
			C.assignment = title ? title : rank
			C.name = "[C.registered_name]'s ID Card ([C.assignment])"

			//put the player's account number onto the ID
			if(H.mind && H.mind.initial_account)
				C.associated_account_number = H.mind.initial_account.account_number

			H.equip_to_slot_or_del(C, slot_wear_id)

		var/obj/item/device/pda/P = locate() in H
		if(P)
			P.owner = H.real_name
			P.ownjob = C.assignment
			P.ownrank = C.rank
			P.name = "PDA-[H.real_name] ([P.ownjob])"

		return 1


	proc/HandleFeedbackGathering()
		for(var/datum/job/job in occupations)
			var/tmp_str = "|[job.title]|"

			var/level1 = 0 //high
			var/level2 = 0 //medium
			var/level3 = 0 //low
			var/level4 = 0 //never
			var/level5 = 0 //banned
			var/level6 = 0 //account too young
			for(var/mob/new_player/player in player_list)
				if(!(player.ready && player.mind && !player.mind.assigned_role))
					continue //This player is not ready
				if(jobban_isbanned(player, job.title))
					level5++
					continue
				if(!job.player_old_enough(player.client))
					level6++
					continue
				if(player.client.prefs.GetJobDepartment(job, 1) & job.flag)
					level1++
				else if(player.client.prefs.GetJobDepartment(job, 2) & job.flag)
					level2++
				else if(player.client.prefs.GetJobDepartment(job, 3) & job.flag)
					level3++
				else level4++ //not selected

			tmp_str += "HIGH=[level1]|MEDIUM=[level2]|LOW=[level3]|NEVER=[level4]|BANNED=[level5]|YOUNG=[level6]|-"


	proc/PopcapReached()
		if(config.hard_popcap || config.extreme_popcap)
			var/relevent_cap = max(config.hard_popcap, config.extreme_popcap)
			if((initial_players_to_assign - unassigned.len) >= relevent_cap)
				return 1
		return 0


	proc/RejectPlayer(mob/new_player/player)
		if(player.mind && player.mind.special_role)
			return
		Debug("Popcap overflow Check observer located, Player: [player]")
		player << "<b>You have failed to qualify for any job you desired.</b>"
		unassigned -= player
		player.ready = 0