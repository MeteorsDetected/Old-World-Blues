/mob/living/simple_animal/hostile/zigota
	name = "The Thing"
	desc = "What the fuck is that!?"
	icon = 'icons/mob/animal.dmi'
	icon_state = "zigota_full"
	icon_living = "zigota_full"
	icon_dead = "zigota_dead"
	icon_gib = "v6"
	speak = list("AaaAaAaAaA!", "Screeeeeee!")
	speak_chance = 5
	speak_emote = list("screams", "screeches")
	emote_hear = list("screams", "screeches")
	turns_per_move = 5
	meat_type = /obj/item/weapon/reagent_containers/food/snacks/meat
	response_harm = "hits the"
	speed = 4
	maxHealth = 80
	health = 70
	harm_intent_damage = 40
	melee_damage_lower = 30
	melee_damage_upper = 35
	attacktext = "bitten"
	attack_sound =('sound/effects/zigot/screeches5.ogg')

	var/screams_ticks = 0

	var/list/sound_list = list(
				screams = list('sound/effects/zigot/screams5.ogg'),
				damage = 'sound/effects/zigot/damage.ogg',
				screeches = 'sound/effects/zigot/screeches5.ogg',
				death = 'sound/effects/zigot/death.ogg')

/mob/living/simple_animal/hostile/zigota/death()
	..()
	visible_message("[src] stops moving...")
	playsound(src, 'sound/effects/zigot/death.ogg', 100, 1)

mob/living/simple_animal/hostile/zigota/bullet_act(var/obj/item/projectile/Proj)
	..(Proj)
	playsound(src.loc, sound_list["damage"], 60, rand(-70, 70), 60, 1)

mob/living/simple_animal/hostile/zigota/attacked_with_item(var/obj/item/O, var/mob/user)
	if(!(..(O, user)) && O.force)
		playsound(src.loc, sound_list["damage"], 60, rand(-70, 70), 60, 1)

/mob/living/simple_animal/hostile/zigota/say()
	..()
	playsound(src, 'sound/effects/zigot/screams5.ogg', 'sound/effects/zigot/screeches5.ogg', 60, rand(-70, 70), 60, 1)

/mob/living/simple_animal/hostile/zigota/Life()
	..()


	if(target_mob)
		playsound(src.loc, 'sound/effects/zigot/screeches5.ogg', 'sound/effects/zigot/screams5.ogg', 60, rand(-70, 70), 60, 1)

	min_oxy = 0
	max_oxy = 0
	min_tox = 0
	max_tox = 0
	min_co2 = 0
	max_co2 = 0
	min_n2 = 0
	max_n2 = 0
	minbodytemp = 0

/mob/living/simple_animal/hostile/zigota/AttackingTarget()
    . =..()
    var/mob/living/L = .
    if(istype(L))
        if(prob(15))
            L.Weaken(3)

/mob/living/simple_animal/hostile/zigota/worm
	name = "Worm"
	icon_state = "worm"
	icon_living = "worm"
	icon_dead = "worm_dead"
	speak_emote = list("screams", "screeches")
	emote_hear = list("screams", "screeches")

	speed = 5
	health = 20
	melee_damage_lower = 15
	melee_damage_upper = 15

/mob/living/simple_animal/hostile/zigota/shit
	name = "The Berseker"
	icon_state = "shit"
	icon_living = "shit"
	icon_dead = "shit_dead"
	speak_emote = list("screams", "screeches")
	emote_hear = list("screams", "screeches")

	health = 90
	melee_damage_lower = 30
	melee_damage_upper = 20

/mob/living/simple_animal/hostile/zigota/crawling
	name = "The Crawler"
	icon_state = "crawling"
	icon_living = "crawling"
	icon_dead = "crawling_dead"
	speak_emote = list("screams", "screeches")
	emote_hear = list("screams", "screeches")

	speed = 6
	health = 40
	melee_damage_lower = 20
	melee_damage_upper = 15

/mob/living/simple_animal/hostile/zigota/anomaly
	name = "The Thing"
	icon_state = "anomaly"
	icon_living = "anomaly"
	icon_dead = "anomaly_ded"
	speak_emote = list("screams", "screeches")
	emote_hear = list("screams", "screeches")

	health = 50
	melee_damage_lower = 25
	melee_damage_upper = 20

/mob/living/simple_animal/hostile/zigota/nurse2
	name = "The Thing"
	icon_state = "nurse2"
	icon_living = "nurse2"
	icon_dead = "nurse2_ded"
	speak_emote = list("screams", "screeches")
	emote_hear = list("screams", "screeches")

	health = 55
	melee_damage_lower = 20
	melee_damage_upper = 18

/mob/living/simple_animal/hostile/zigota/lewd
	name = "The Thing"
	icon_state = "lewd"
	icon_living = "lewd"
	icon_dead = "lewd_ded"
	speak_emote = list("screams", "screeches")
	emote_hear = list("screams", "screeches")

	health = 80
	melee_damage_lower = 20
	melee_damage_upper = 17

/mob/living/simple_animal/hostile/zigota/zigota_four
	name = "The Thing"
	icon_state = "zigota_four"
	icon_living = "zigota_four"
	icon_dead = "zigota_four_ded"
	speak_emote = list("screams", "screeches")
	emote_hear = list("screams", "screeches")

	health = 40
	melee_damage_lower = 20
	melee_damage_upper = 25

/mob/living/simple_animal/hostile/zigota/cyb
	name = "The Thing"
	icon_state = "cyb"
	icon_living = "cyb"
	icon_dead = "cyb_ded"
	speak_emote = list("screams", "screeches")
	emote_hear = list("screams", "screeches")

	health = 85
	melee_damage_lower = 22
	melee_damage_upper = 20

/mob/living/simple_animal/hostile/zigota/fuck
	name = "The Thing"
	icon_state = "fuck"
	icon_living = "fuck"
	icon_dead = "fuck_ded"
	speak_emote = list("screams", "screeches")
	emote_hear = list("screams", "screeches")

	health = 85
	melee_damage_lower = 22
	melee_damage_upper = 20

/mob/living/simple_animal/hostile/zigota/floater
	name = "Floater"
	icon_state = "floater"
	icon_living = "floater"
	icon_dead = "floater_ded"
	speak_emote = list("screams", "screeches")
	emote_hear = list("screams", "screeches")

	speed = 5
	health = 20
	melee_damage_lower = 15
	melee_damage_upper = 15

/mob/living/simple_animal/hostile/zigota/mutant1
	name = "Mutant"
	icon_state = "mutant1"
	icon_living = "mutant1"
	icon_dead = "mutant1_dead"
	speak_emote = list("screams", "screeches")
	emote_hear = list("screams", "screeches")

	health = 75
	melee_damage_lower = 20
	melee_damage_upper = 18

/mob/living/simple_animal/hostile/zigota/mutant3
	name = "Mutant"
	icon_state = "mutant3"
	icon_living = "mutant3"
	icon_dead = "mutant3_dead"
	speak_emote = list("screams", "screeches")
	emote_hear = list("screams", "screeches")
	health = 75
	melee_damage_lower = 20
	melee_damage_upper = 18

/mob/living/simple_animal/hostile/zigota/horror1
	name = "Horror"
	icon_state = "horror1"
	icon_living = "horror1"
	icon_dead = "horror1_dead"
	speak_emote = list("screams", "screeches")
	emote_hear = list("screams", "screeches")
	health = 90
	melee_damage_lower = 30
	melee_damage_upper = 20

/mob/living/simple_animal/hostile/zigota/spacer1
	name = "Spacer"
	icon_state = "spacer1"
	icon_living = "spacer1"
	icon_dead = "zigota_dead"
	speak_emote = list("screams", "screeches")
	emote_hear = list("screams", "screeches")
	health = 50
	melee_damage_lower = 25
	melee_damage_upper = 20
