/mob/living/simple_animal/hostile/zigota
	name = "The Thing"
	desc = "What the fuck is that!?"
	icon = 'icons/mob/animal.dmi'
	icon_state = "zigota_full"
	icon_living = "zigota_full"
	icon_dead = "zigota_dead"
	icon_gib = "v6"
	speak_chance = 1
	turns_per_move = 0
	meat_type = /obj/item/weapon/reagent_containers/food/snacks/meat
	response_harm = "hits the"
	speed = 4
	maxHealth = 80
	health = 70
	harm_intent_damage = 40
	melee_damage_lower = 30
	melee_damage_upper = 35
	attacktext = "bitten"
	attack_sound = 'sound/effects/blobattack.ogg'


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
	speed = 5
	health = 20
	melee_damage_lower = 15
	melee_damage_upper = 15

/mob/living/simple_animal/hostile/zigota/shit
	name = "Bersek"
	icon_state = "shit"
	icon_living = "shit"
	icon_dead = "shit_dead"
	health = 90
	melee_damage_lower = 30
	melee_damage_upper = 20

/mob/living/simple_animal/hostile/zigota/crawling
	name = "Crawl"
	icon_state = "crawling"
	icon_living = "crawling"
	icon_dead = "crawling_dead"
	speed = 6
	health = 40
	melee_damage_lower = 20
	melee_damage_upper = 15

/mob/living/simple_animal/hostile/zigota/mutant1
	name = "Lucky Guy"
	icon_state = "anomaly"
	icon_living = "anomaly_dead"
	icon_dead = "mutant1"
	health = 50
	melee_damage_lower = 25
	melee_damage_upper = 20

/mob/living/simple_animal/hostile/zigota/mutant3
	name = "Lily"
	icon_state = "nurse"
	icon_living = "nurse"
	icon_dead = "nurse_dead"
	health = 55
	melee_damage_lower = 20
	melee_damage_upper = 18

/mob/living/simple_animal/hostile/zigota/fuck
	name = "Mike"
	icon_state = "lewd"
	icon_living = "lewd_dead"
	icon_dead = "fuck"
	health = 80
	melee_damage_lower = 20
	melee_damage_upper = 17

/mob/living/simple_animal/hostile/zigota/zigota_four
	name = "Beagle"
	icon_state = "zigota_four"
	icon_living = "zigota_four"
	icon_dead = "zigota_four_dead"
	health = 40
	melee_damage_lower = 20
	melee_damage_upper = 25