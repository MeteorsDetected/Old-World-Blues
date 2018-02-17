/////////////////////Animals\\\\\\\\\\\\\\\\\\\\\\\\

//Well, simple_animal have some useful things that can save a lot of time. And atmos effect is nice
//So... We take it as parent
//And yes. Coded in one day. Uh holy deers... I know, this is shit and need to rework it later
//For now, used as test
//Need to add moving proc...
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
	health = 350
	maxHealth = 350
	//Memorization is not done yet. I make it later
	//"enemy" - panic run
	//"mate" - ignore. For now...
//	var/list/memorized_mobs = list(/mob/living/carbon/human = "enemy", /mob/living/simple_animal/snowy_animal = "mate")
	var/list/flock = list() //mobs of one type can bond into groups. This need to optimize all of it. And for something else
	var/list/migration_path = list()
	var/list/allowed_food = list(/obj/structure/flora/snowybush)
	var/list/sound_list = list(
				howl = list('sound/effects/snowy/deer_howl1.ogg', 'sound/effects/snowy/deer_howl2.ogg'),
				damage = 'sound/effects/snowy/deer_damage.ogg',
				warn_howl = 'sound/effects/snowy/deer_warn.ogg',
				death = 'sound/effects/snowy/deer_death.ogg')
	var/corpse = /obj/structure/butcherable
	var/turf/new_place
	var/go_away_ticks = 30 //then this lower to 0, animal will go away to another place
	var/ticks_to_move = 30
//	var/footprints

	nutrition = 0
	var/nutrition_max = 50
	var/chew_ticks = 0
	var/howl_ticks = 38

	var/sleep_need = 48
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
			update_icon()
		if("hungry")
			hungry()
		if("sleep")
			sleeping()
		if("living")
			living()

	if(bleeding)
		health--
		if(prob(50))
			var/obj/effect/decal/cleanable/blood/drip/D = new(src.loc)
			spawn(1200)
				qdel(D)

	howl_ticks++
	if(howl_ticks >= 40)
		howl()
	for(var/turf/simulated/floor/plating/chasm/C in range(1, src)) //Beware the chasms!
		walk_away(src, C, 1, speed)
	for(var/obj/structure/fence/F in range(1, src)) //And this. Yeah, i rework all of this later
		walk_away(src, F, 1, speed)


/mob/living/simple_animal/snowy_animal/proc/hungry()
	if(chew_ticks)
		chew_ticks--
		if(prob(35))
			src.visible_message("<b>[name]</b> chews.")
	else
		if(nutrition >= nutrition_max)
			life_mode = "living"
			return
		for(var/F in allowed_food)
			var/obj/feed = locate(F) in view(vision, src)
			if(feed)
				if(feed in range(1, src))
					src.visible_message("<b>[name]</b> puts his head into the [feed] and eat some roots.")
					nutrition = nutrition + 5
					chew_ticks = 3
				else
					walk_to(src, feed, 1, speed)
				break
			else
				go_away_ticks = 0
				life_mode = "living"
	update_icon()


/mob/living/simple_animal/snowy_animal/proc/sleeping()
	sleep_need--
	if(health >= maxHealth)
		bleeding = 0
		health = maxHealth
	else
		health = health+2
	if(sleep_need <= 0)
		sleep_need = 0
		life_mode = "living"
	update_icon()


/mob/living/simple_animal/snowy_animal/proc/living()
	if(sleep_need >= 50)
		life_mode = "sleep"
		icon_state = icon_sleep
		src.visible_message("<b>[name]</b> lay down and close eyes.")
		walk(src, 0)
		update_icon()
		return
	else
		sleep_need++
	if(go_away_ticks && !bleeding)
		go_away_ticks--
	else
		new_place = getNewPlace(16)
	if(nutrition)
		nutrition--
	else
		if(!new_place)
			life_mode = "hungry"
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



/mob/living/simple_animal/snowy_animal/proc/targetIsVisible(var/atom/T)
	if(T in view(vision, src))
		return 1
	return 0



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
	for(var/mob/living/L in view(vision, src))
		if(L != src)
			if(!istype(L, /mob/living/simple_animal/snowy_animal) && !(locate(/obj/structure/flora/snowybush) in L.loc))
				setPanic(L)
				return

	if(!(life_mode == "panic"))
		for(var/mob/living/L in range(hearing, src))
			if(L != src)
				if(istype(L, /mob/living/carbon/human))
					var/mob/living/carbon/human/H = L
					if(H.m_intent == "run") //Where is my freaking brain!?
						setPanic(L)
						return
				else if(!istype(L, /mob/living/simple_animal/snowy_animal))
					setPanic(L)
					return



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
		new_place = get_ranged_target_turf(src, D, step_dist)
		if(isReachable(new_place))
			return new_place


/mob/living/simple_animal/snowy_animal/proc/isReachable(var/turf/to_T)
	var/list/path = AStar(src.loc, to_T, /turf/proc/AdjacentTurfsSnowy, /turf/proc/Distance, max_nodes=60)
	if(path && path[path.len] == to_T)
		return 1
	return 0


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
		nutrition = rand(10, 60)
		howl_ticks = rand(10, 30)
		sleep_need = rand(10, 30)






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
	health = 160
	maxHealth = 160
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