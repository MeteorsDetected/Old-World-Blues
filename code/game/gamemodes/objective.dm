/datum/objective/anti_revolution/execute
	find_target()
		..()
		if(target && target.current)
			explanation_text = "[target.current.real_name], the [target.assigned_role] has extracted confidential information above their clearance. Execute \him[target.current]."
		else
			explanation_text = "Free Objective"
		return target

	check_completion()
		if(!target)//If it's a free objective.
			return 1
		if(target && target.current)
			if(target.current.stat == DEAD || !ishuman(target.current))
				return 1
			return 0
		return 1

/datum/objective/anti_revolution/brig
	var/already_completed = 0

	find_target()
		..()
		if(target && target.current)
			explanation_text = "Brig [target.current.real_name], the [target.assigned_role] for 20 minutes to set an example."
		else
			explanation_text = "Free Objective"
		return target

	check_completion()
		if(!target)//If it's a free objective.
			return 1
		if(already_completed)
			return 1
		if(target && target.current)
			if(target.current.stat == DEAD)
				return 0
			var/area/check_area = get_area(target.current)
			if( istype(check_area,/area/security/prison) || istype(check_area, /area/security/brig) )
				for(var/obj/item/weapon/card/id/card in target.current)
					return 0
				for(var/obj/item/device/pda/P in target.current)
					if(P.id)
						return 0
				return 1
			return 0
		return 0

/datum/objective/anti_revolution/demote
	find_target()
		..()
		if(target && target.current)
			explanation_text = "[target.current.real_name], the [target.assigned_role] has been classified as harmful to NanoTrasen's goals. Demote \him[target.current] to assistant."
		else
			explanation_text = "Free Objective"
		return target

	check_completion()
		if(!target)//If it's a free objective.
			return 1
		if(target && target.current && ishuman(target))
			var/obj/item/weapon/card/id/I = target.current:wear_id
			if(istype(I, /obj/item/device/pda))
				var/obj/item/device/pda/P = I
				I = P.id

			if(!istype(I)) return 1

			if(I.assignment == "Assistant")
				return 1
			else
				return 0
		return 1


// Heist objectives.
/datum/objective/heist/preserve_crew
	explanation_text = "Do not leave anyone behind, alive or dead."

	check_completion()
		if(raiders && raiders.is_raider_crew_safe()) return 1
		return 0

