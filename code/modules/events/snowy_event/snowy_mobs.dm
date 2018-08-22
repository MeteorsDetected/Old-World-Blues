/////////////////////Animals\\\\\\\\\\\\\\\\\\\\\\\\

//Well, simple_animal have some useful things that can save a lot of time. And atmos effect is nice
//So... We take it as parent
//And yes. Coded in one day. Uh holy deers... I know, this is shit and need to rework it later
//For now, used as test
//Need to add moving proc...

//Time to simplify this lagish piece of shit

/mob/living/simple_animal/snowy_animal
	name = "snowy animal"
	icon = 'icons/obj/snowy_event/mobs_icons.dmi'
	icon_state = "deer"
	icon_living = "deer"
	icon_dead = ""
	var/icon_sleep = "deer_sleep"
	pass_flags = PASSTABLE //Sure. Why not?..

	speak = list()
	speak_emote = list()
	emote_hear = list("howls")
	emote_see = list("looks around with care")
	health = 80
	maxHealth = 80
	var/list/sound_list = list(
				howl = list('sound/effects/snowy/deer_howl1.ogg', 'sound/effects/snowy/deer_howl2.ogg'),
				damage = 'sound/effects/snowy/deer_damage.ogg',
				warn_howl = 'sound/effects/snowy/deer_warn.ogg',
				death = 'sound/effects/snowy/deer_death.ogg')
	var/corpse = /obj/structure/butcherable
	var/turf/new_place
	var/go_away_ticks = 60 //then this lower to 0, animal will go away to another place
	var/ticks_to_move = 60
	var/howl_ticks = 0
//	var/footprints
	var/bleeding = 0

	var/turf/last_pos
	var/cornered = 0
	var/position_tick = 3
	var/panic_mode = "run"
	var/life_mode = "living"
	var/atom/target //running from or hunting for //Later i make multiple targets

	var/vision = 6
	var/hearing = 12

	speed = 6 //here this is not speed, yeah. Thats lag param


	response_help  = "pets"
	response_disarm = "gently moves aside"
	response_harm   = "swats"
	stop_automated_movement = 1



/mob/living/simple_animal/snowy_animal/Life()
	if(!..())
		return

	mobDetection()
	switch(life_mode)
		if("panic")
			panicRun(target)
			//eating and sleeping no need. They are just the shooting targets now. Maybe this will changed later
		if("living")
			living()

	if(bleeding)
		health--
		if(prob(50))
			var/obj/effect/decal/cleanable/blood/drip/D = new(src.loc)
			spawn(1200)
				qdel(D)

	for(var/turf/simulated/floor/plating/chasm/C in range(1, src)) //Beware the chasms!
		walk_away(src, C, 1, speed)
	for(var/obj/structure/fence/F in range(1, src)) //And this. Yeah, i rework all of this later
		walk_away(src, F, 1, speed)

	howl_ticks++
	if(howl_ticks >= 40)
		howl()


/mob/living/simple_animal/snowy_animal/proc/living()
	if(go_away_ticks && !bleeding)
		go_away_ticks--
	else
		new_place = getNewPlace(12)
	if(new_place)
		walk_to(src, new_place, 0, speed) //I know, no need to call walks every time, but i remake it later
		for(var/turf/simulated/floor/plating/chasm/C in range(1, src))
			walk_away(src, C, 1, speed)
		go_away_ticks = ticks_to_move
		if(new_place in range(1, src.loc))
			new_place = null
	update_icon()



//meeh. Shhh
/mob/living/simple_animal/snowy_animal/proc/update_icon()
	..()
	if(life_mode == "sleep")
		icon_state = icon_sleep
	else
		icon_state = icon_living



//Animal will run away from target
//I know, maybe use this byond walk procs - is not good idea... But the time is clamp my ass and i cant write my own right now
//Later, i made my own walk based on A*
//And byond walks works with corners very bad. Well. Better than nothing now
/mob/living/simple_animal/snowy_animal/proc/panicRun(var/atom/target)
	if(target)
		if(target in range(1, src))
			selfDefense(target)
		if(panic_mode == "run")
			walk_away(src, target, 16, speed)
			if(last_pos && cornered)
				walk_away(src, last_pos, 6, speed) //stay away from last corner
				cornered = 0
		else
			if(get_dist(src.loc, target.loc) <= vision && istype(target, /mob/living))
				var/mob/living/L = target
				if(!L.weakened)
					src.visible_message(SPAN_WARN("<b>[name] is in rage!</b>"))
					walk_to(src, target, 1, speed) //Initiate self defense proc
			else
				cornered = 1
	else
		Calm()
		return

	position_tick--
	if(position_tick <= 0)
		position_tick = 3
		if(last_pos)
			if(last_pos in range(src.loc, 2))
				src.visible_message("<b>[name]</b> swiftly looks around.")
				if(target in range(hearing, src))
					panic_mode = "defense"
					cornered = 1
				else
					Calm()
		last_pos = src.loc

	if(get_dist(src.loc, target.loc) >= 16)
		Calm()


/mob/living/simple_animal/snowy_animal/proc/selfDefense(var/atom/target)
	if(istype(target, /mob/living))
		var/mob/living/L = target
		if(target in range(1, src))
			src.visible_message(SPAN_WARN("[name] knocks [target]."))
			L.Weaken(5)
			src.do_attack_animation(target)
			panic_mode = "run"
	else
		panic_mode = "run"
		//if this is not living creature... Well. Run?


/mob/living/simple_animal/snowy_animal/proc/mobDetection()
	for(var/mob/living/L in view(hearing, src))
		if(!istype(L, /mob/living/simple_animal/snowy_animal))
			if(istype(L, /mob/living/carbon/human))
				var/mob/living/carbon/human/H = L
				if(H.m_intent == "run")
					setPanic(L)
					return 1
				else
					if(get_dist(src, H) <= vision)
						if(!(locate(/obj/structure/flora/snowybush) in L.loc))
							setPanic(L)
							return 1
			else
				setPanic(L)
				return 1
	return 0



/mob/living/simple_animal/snowy_animal/proc/setPanic(var/atom/T)
	if(life_mode != "panic" && !target)
		src.visible_message("<b>[name]</b> jumps at place in scare.")
		playsound(src.loc, sound_list["warn_howl"], 60, rand(-70, 70), 60, 1)
		speed = 4
	life_mode = "panic"
	target = T
	new_place = null
	update_icon()


/mob/living/simple_animal/snowy_animal/proc/Calm()
	panic_mode = "run"
	last_pos = null
	target = null
	life_mode = "living"
	speed = 6
	go_away_ticks = 0


/mob/living/simple_animal/snowy_animal/proc/getNewPlace(var/step_dist)
	var/turf/new_place
	var/our_dirs = shuffle(alldirs)
	for(var/D in our_dirs)
		new_place = get_ranged_target_turf(src, D, step_dist) //A* is too slow for us, so...
		if(new_place)
			return new_place


/mob/living/simple_animal/snowy_animal/proc/howl()
	playsound(src.loc, pick(sound_list["howl"]), 60, rand(-70, 70), 60, 1)
	howl_ticks = 0


/mob/living/simple_animal/snowy_animal/hear_say(var/message)
	if(message)
		setPanic(src.loc)
		return


/mob/living/simple_animal/snowy_animal/death()
	..()
	walk(src, 0)
	playsound(src.loc, sound_list["death"], 60, rand(-70, 70), 60, 1)
	new corpse(src.loc)
	qdel(src)



/mob/living/simple_animal/snowy_animal/bullet_act(var/obj/item/projectile/Proj)
	..(Proj)
	bleeding = 1
	playsound(src.loc, sound_list["damage"], 60, rand(-70, 70), 60, 1)
	setPanic(src.loc)


/mob/living/simple_animal/snowy_animal/attacked_with_item(var/obj/item/O, var/mob/user)
	if(!(..(O, user)) && O.force)
		bleeding = 1
		playsound(src.loc, sound_list["damage"], 60, rand(-70, 70), 60, 1)
		setPanic(user)



//For chasm detection
//Used in A* pathfind at migration
/turf/proc/AdjacentTurfsSnowy()
	var/L[] = new()
	for(var/turf/simulated/t in oview(src,1))
		if(!t.density && !istype(t, /turf/simulated/floor/plating/chasm))
			if(!LinkBlocked(src, t) && !TurfBlockedNonWindow(t))
				L.Add(t)
	return L


/mob/living/simple_animal/snowy_animal/deer
	name = "Deer"
	desc = "Medium-sized creature with branch-like horns on head. Wait, how it got here?"

	New()
		..()
		howl_ticks = rand(10, 30)
		go_away_ticks = rand(25, 60)







//Hell... My time is over
//Wolf. Without my shit-like ai. Maybe it's better
/mob/living/simple_animal/hostile/creature/wolf
	name = "Enraged wolf"
	desc = "Wolf-like creature that loosed own mind."
	icon = 'icons/obj/snowy_event/mobs_icons.dmi'
	speak_emote = list("howl", "barks")
	icon_state = "wolf"
	icon_living = "wolf"
	icon_dead = ""
	health = 60
	maxHealth = 60
	melee_damage_lower = 15
	melee_damage_upper = 25
	see_in_dark = 8
	meat_type = /obj/item/weapon/reagent_containers/food/snacks/ingredient/meat/natural
	attacktext = "bitted"
	attack_sound = 'sound/weapons/bite.ogg'
	faction = "syndicate"
	speed = 2
	var/howl_count = 1



/mob/living/simple_animal/hostile/creature/wolf/Life()
	if(!(..()))
		return

	if(howl_count)
		if(prob(10))
			howl()
	else
		if(prob(1))
			howl_count++



/mob/living/simple_animal/hostile/creature/wolf/proc/howl()
	playsound(src.loc, 'sound/effects/snowy/wolf_howl.ogg', 90, rand(-70, 70), 90, 1)
	howl_count--
	if(howl_count < 0)
		howl_count = 0
	for(var/mob/living/simple_animal/hostile/creature/wolf/W in range(15, src))
		if(W.howl_count && prob(40))
			spawn(rand(3, 6)*10)
				W.howl()


/mob/living/simple_animal/hostile/creature/wolf/death()
	..()
	new /obj/structure/butcherable/wolf(src.loc)
	qdel(src)



//Experimental
//Unfinished. Need to polish some procs
//Need to add: friend list, good sprite and animations, more specialized commands (like search by fingerprints), simple teach menu

/mob/living/var/mob/living/simple_animal/smartdog/Pet

/mob/living/simple_animal/smartdog
	name = "Barky"
	desc = "A wolf? A dog? A smart doggy!"
	icon = 'icons/obj/snowy_event/mobs_icons.dmi'
	icon_state = "wolf"
	icon_living = "wolf"
	icon_dead = "wolf"
	pass_flags = PASSTABLE
	small = 0

	speak = list()
	speak_emote = list()
	emote_hear = list()
	emote_see = list()

	speak_chance = 1//1% (1 in 100) chance every tick; So about once per 150 seconds, assuming an average tick is 1.5s
	turns_per_move = 5

	response_help  = "pets"
	response_disarm = "gently moves aside"
	response_harm   = "swats"
	stop_automated_movement = 1
	universal_speak = 1
	health = 220
	maxHealth = 220
	var/hunger = 30
	var/energy = 100
	var/atom/Target = null
	var/task = null
	var/turf/food_place
	var/turf/sleep_place
	var/playing = 0
	var/chill = 0
	var/mob/living/Master = null
	var/friendship = 1
	var/list/commands = list("voice" = list("голос!", "пошуми!"),
							"sit" = list("сидеть!", "сесть!"),
							"calm" = list("отдыхай!", "свободен!", "нельз€!"),
							"master" = list("хоз€ин!"),
							"play" = list("апорт!"),
							"follow" = list("за мной!", "р€дом!"),
							"overwatch" = list("охран€ть!", "следить!", "сторожить!"),
							"haul" = list("принеси!", "неси!"),
							"attack" = list("вз€ть!"),
							"to me" = list("ко мне!"),
							"go to" = list("туда!"),
							"set food place" = list("ешь здесь!", "миска!"),
							"set sleep place" = list("спи здесь!", "лежбище!", "коморка!")
							)

	//helpers
	var/turf/last_loc = null


/mob/living/simple_animal/smartdog/examine(mob/user as mob)
	..(user)
	if(user == Master)
		user << SPAN_NOTE("Looks at you with love.")
		user << SPAN_NOTE("Health: [health]/[maxHealth].")
	else
		user << SPAN_WARN("Looks at you with <b>anger and bloodthirst</b>.")


/mob/living/simple_animal/smartdog/death()
	cry()
	..()
	if(Master && locate(Master) in view(12, src))
		Master << SPAN_WARN(sanitize("ќ не-е-ет! ћой любимец, [name], умер!"))
	if(Master && Master.Pet)
		Master.Pet = null
	Master = null
	new /obj/structure/butcherable/wolf(src.loc)
	qdel(src)


/mob/living/simple_animal/smartdog/hear_say(var/message, var/verb = "says", var/datum/language/language = null, var/alt_name = "", var/italics = 0, var/mob/speaker = null, var/sound/speech_sound, var/sound_vol)
	if(message && !istype(speaker, /mob/living/simple_animal/smartdog)) //another doges not required
		for(var/C in commands)
			var/list/v_cmds = commands[C]
			for(var/word in v_cmds)
				if(findtextEx(rlowertext(sanitize(message)), rlowertext(sanitize(word))))
					task = C
					if(task == "master")
						cmd_setMaster(speaker)

		..(message,verb,language,alt_name,italics,speaker)


/mob/living/simple_animal/smartdog/proc/register(var/mob/living/L, var/atom/T)
	if(task == "haul" && istype(T, /obj/item))
		Target = T
	else if(task == "attack" && (istype(T, /mob/living) || istype(T, /obj/mecha)))
		if(T == Master)
			cry() // :c
			return
		Target = T
	else if(task == "go to" || task == "set food place" || task == "set sleep place")
		Target = T
	else
		say("Woof?")


/mob/living/simple_animal/smartdog/attackby(obj/item/I as obj, mob/user as mob)
	if(user.a_intent == I_HELP)
		if(Master && Master == user)
			if(istype(I, /obj/item/weapon/reagent_containers/food/snacks))
				eat(I)
				return
			else
				visible_message(SPAN_NOTE("<b>[src.name]</b> sniffs the [I.name]"))
				Target = I
				return
		else
			say("Gr-r-r...")
			if(prob(30))
				user.attack_generic(src, rand(5, 10), "bites the hand of")
				return
	else
		if(Master != user)
			Target = user
			task = "attack"
		..(I, user)


/mob/living/simple_animal/smartdog/attack_hand(mob/living/carbon/human/M as mob)
	if(M.a_intent == I_HELP)
		if(!Master || !Master == M)
			say("Gr-r-r...")
			if(prob(30))
				M.attack_generic(src, rand(5, 10), "bites the hand of")
				return
		else
			..(M)
	else
		if(Master != M)
			Target = M
			task = "attack"
		..(M)


/mob/living/simple_animal/smartdog/proc/protect_from(var/mob/living/L)
	if((Master in view(16)) && Master != L)
		Target = L
		task = "attack"


/mob/living/simple_animal/smartdog/proc/bark()
	say(pick("bark!", "bark-bark!", "woof!", "wuf!"))
	var/B = pick('sound/effects/snowy/dog_bark1.ogg', 'sound/effects/snowy/dog_bark2.ogg')
	playsound(src.loc, B, 60, rand(-70, 70), 30, 1)

/mob/living/simple_animal/smartdog/proc/cry()
	say(pick("Wooo...", "Awo-o-o..."))
	var/C = pick('sound/effects/snowy/dog_cry1.ogg', 'sound/effects/snowy/dog_cry2.ogg')
	playsound(src.loc, C, 60, rand(-70, 70), 30, 1)

/mob/living/simple_animal/smartdog/proc/alarm_bark()
	say(pick("BARK! BARK! BARK!", "BARK! WOOF! WOOF!", "BARK! BARK!", "WOOOOF! WOOF! BARK! WUF!"))
	playsound(src.loc, 'sound/effects/snowy/dog_alarm.ogg', 60, rand(-70, 70), 30, 1)


/mob/living/simple_animal/smartdog/Life()
	if(!..())
		return


	hunger_tick()
	energy_tick()

	switch(task)
		if("voice") 			cmd_getVoice()
//		if("sit")   			cmd_sit()
		if("follow")  			cmd_follow()
		if("calm")  			cmd_calm()
		if("play")				cmd_play()
		if("overwatch")			cmd_overwatch()
		if("haul")				cmd_haul()
		if("attack")			cmd_attack()
		if("to me")				cmd_to_me()
		if("go to")				cmd_goTo()
		if("set food place")	cmd_setFoodPlace()
		if("set sleep place")	cmd_setSleepPlace()

		else
			if(prob(5))
				var/me = pick("sits on the floor and looks around", "laying at floor and gnawing the bone", "stick out the tongue and wags with his tail")
				visible_message("<b>[name]</b> [me].")
			if(prob(1))
				playsound(src.loc, 'sound/effects/snowy/wolf_howl.ogg', 70, rand(-70, 70), 90, 1)

			if(prob(5))
				random_moving()


	last_loc = get_turf(src)


/mob/living/simple_animal/smartdog/proc/is_stopped()
	return (last_loc == get_turf(src))


/mob/living/simple_animal/smartdog/proc/hunger_tick()
	if(prob(70))
		hunger++
	if(hunger >= 100)
		hunger = 100
		if(prob(5))
			maxHealth -= 10
			if(maxHealth < 220)
				maxHealth = 220
	if(hunger >= 80)
		find_for_food()


/mob/living/simple_animal/smartdog/proc/energy_tick()
	if(chill)
		sleeping()
		return
	if(prob(70))
		energy--
	if(energy < 0)
		energy = 0
	else if(energy > 100)
		energy = 100
	if(energy <= 10)
		find_for_sleep()


/mob/living/simple_animal/smartdog/proc/find_for_food()
	if(Target && istype(Target, /obj/item/weapon/reagent_containers/food/snacks)) //here we have food that we find last time
		if(src in range(1, Target))
			eat(Target)
		else
			walk_to(src, Target, 1, 5)
	else if(food_place && get_dist(src, food_place) < 30 && (locate(/obj/item/weapon/reagent_containers/food/snacks) in food_place)) //if we have special place, find food there and eat
		if(src in range(1, food_place))
			var/obj/item/weapon/reagent_containers/food/snacks/S = locate(/obj/item/weapon/reagent_containers/food/snacks) in food_place
			eat(S)
		else
			walk_to(src, food_place, 1, 5)
	else if(Master && Master in view(12, src)) //no food place or food, so we ask our Master to feed us
		if(src in range(1, Master))
			if(prob(30))
				visible_message("<b>[name]</b> touches the <b>[Master.name]</b> with paw and makes baby eyes.")
				cry()
		else
			walk_to(src, Master, 1, 5)
	else //Master gone and there's no food. This is bad, let's find some food
		var/obj/item/weapon/reagent_containers/food/snacks/S = locate(/obj/item/weapon/reagent_containers/food/snacks) in view(16, src)
		if(S) //bingo!
			Target = S


/mob/living/simple_animal/smartdog/proc/eat(var/obj/item/weapon/reagent_containers/food/snacks/Food)
	if(hunger > 30)
		visible_message(SPAN_NOTE("<b>[src.name]</b> eats [Food.name]."))
		health += 50
		hunger -= 50
		energy += 20
		if(hunger < 0)
			hunger = 0
			if(maxHealth+10 < 1000)
				maxHealth += 10
		if(Food == Target)
			Target = null
			walk_to(src, 0)
		qdel(Food)


/mob/living/simple_animal/smartdog/proc/find_for_sleep()
	if(sleep_place)
		if(src in range(1, sleep_place))
			loc = sleep_place
			sleeping()
		else
			walk_to(src, sleep_place, 1, 5)
	else
		sleeping()



/mob/living/simple_animal/smartdog/proc/sleeping()
	if(task == "overwatch" || !task)
		if(!chill)
			chill = 1
			visible_message(SPAN_NOTE("<b>[name]</b> lays down, close eyes but raise up the ears."))
		energy++
		icon_state = "wolf-sleep[pick(1, 2)]" //actively sprite changing every tick. Sleeping move simulation heh //need the animation here, yes
		if(energy >= 90)
			wake_up()
	else
		if(chill)
			wake_up()

/mob/living/simple_animal/smartdog/proc/wake_up()
	chill = 0
	icon_state = "wolf"


/mob/living/simple_animal/smartdog/proc/random_moving()
	if(!task && !chill)
		var/turf/r_place = get_ranged_target_turf(get_turf(src), pick(alldirs), rand(1, 5))
		walk_to(src, r_place, 1, 3)

////////////////////////COMMANDS>>>

/mob/living/simple_animal/smartdog/proc/cmd_getVoice()
	bark()
	task = null


//mob/living/simple_animal/smartdog/proc/cmd_sit()
//	visible_message(SPAN_NOTE("<b>[src.name]</b> sits on the ground and looking on [Master.name]"))
//	task = null


/mob/living/simple_animal/smartdog/proc/cmd_calm()
	cry()
	task = null
	Target = null

/mob/living/simple_animal/smartdog/proc/cmd_setMaster(var/mob/living/M as mob)
	if(!Master)
		bark()
		Master = M
		M.Pet = src
		Master << SPAN_NOTE(sanitize("“еперь у мен€ есть любимец - [name]!"))

/mob/living/simple_animal/smartdog/proc/cmd_to_me()
	if(Master && !(src in range(1, Master)))
		walk_to(src, get_turf(Master), 1, 5)
	else
		bark()
		Target = null
		task = null


/mob/living/simple_animal/smartdog/proc/cmd_follow()
	if(Master && !(src in range(1, Master)))
		walk_to(src, get_turf(Master), 1, 5)


/mob/living/simple_animal/smartdog/proc/cmd_overwatch()
	if(Master)
		for(var/mob/living/L in view(12, src))
			if(!(istype(L, /mob/living/simple_animal/smartdog)) && L != Master && isliving(L))
				if(chill)
					wake_up()
				alarm_bark()
				do_attack_animation(L)
				break
		if(prob(5))
			visible_message("<b>[src.name]</b> looks around.")


/mob/living/simple_animal/smartdog/proc/cmd_haul()
	if(Master)
		if(Target && !(locate(Target) in range(1, Master)) && istype(Target, /obj/item))
			pick_and_send()
			if(locate(Target) in range(1, Master) && !(Target in src))
				task = null
				Target = null


/mob/living/simple_animal/smartdog/proc/cmd_play()
	if(Target && Master && !(locate(Target) in range(1, Master)) && istype(Target, /obj/item))
		pick_and_send()


/mob/living/simple_animal/smartdog/proc/cmd_attack()
	if(Master)
		if(Target)
			if(src in range(1, Target))
				if(isliving(Target))
					var/mob/living/L = Target
					L.attack_generic(src, rand(15, 25), "bites with mad anger")
				else
					task = null
					Target = null
				if(istype(Target, /obj/mecha))
					var/obj/mecha/M = Target
					M.attack_generic(src, rand(15, 25), "rip and tear the weakest spots of")
				say("RAWR-R-R!", "OUR-RW-W!", "OUGR-R!")
			else
				walk_to(src, Target, 0, 5)


/mob/living/simple_animal/smartdog/proc/cmd_goTo()
	if(Master)
		if(Target)
			walk_to(src, get_turf(Target), 1, 5)
			task = null
			Target = null


/mob/living/simple_animal/smartdog/proc/cmd_setFoodPlace()
	if(Master)
		if(Target && istype(Target, /turf))
			food_place = Target
			bark()
			task = null
			Target = null

/mob/living/simple_animal/smartdog/proc/cmd_setSleepPlace()
	if(Master)
		if(Target && istype(Target, /turf))
			sleep_place = Target
			bark()
			task = null
			Target = null


/mob/living/simple_animal/smartdog/proc/pick_and_send()
	var/obj/item/T = locate(Target) in Target.loc
	walk_to(src, get_turf(T), 1, 5)
	if(locate(src) in range(1, T))
		if(!(T in src))
			T.loc = src
			walk_to(src, get_turf(Master), 1, 5)
	if(T.loc == src && locate(src) in range(1, Master))
		T.loc = src.loc
		bark()