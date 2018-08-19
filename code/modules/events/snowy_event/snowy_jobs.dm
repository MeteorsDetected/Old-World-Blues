//Some colony jobs
//Need to add:
	//stuff and special warm clothes. They can looks bad as captain's new uniform... But ppl can change this at warehouse
	//Dweller. Survivor that lives here with his loyal dog Barky
	//Psycho. Man that loose his mind. Sometimes do something MAD


//Need to add to him:
//warm clothes
//robo version of smartdog?
//flaregun
//special discipline stick
//special hand clock
//some kind of good revolver
//special bottle of best stuff
datum/job/captain/snowy
	title = "Colony Captain"
	faction = "Colony"
	supervisors = "Common sense"
	minimal_player_age = 26
	economic_modifier = 20

	minimum_character_age = 26
	ideal_character_age = 42

	implanted = 0
	uniform = /obj/item/clothing/under/rank/snowycaptain
	shoes = /obj/item/clothing/shoes/men_shoes
	pda = /obj/item/device/pda
	hat = /obj/item/clothing/head/snowycapthat
	ear = /obj/item/device/radio/headset/heads/captain
	glasses = null
	suit = /obj/item/clothing/suit/snowycapcoat

	backpack  = /obj/item/storage/backpack/captain
	satchel_j = /obj/item/storage/backpack/satchel/cap
	dufflebag = /obj/item/storage/backpack/dufflebag/cap

	put_in_backpack = list(
		/obj/item/device/radio,
		/obj/item/storage/box/ids \
		)

//Need to add to him:
//warm clothes
//hand clock
//flaregun
//special discipline stick
//a big knife. A REAL BIG KNIFE
/datum/job/hop/chief_mate
	title = "Chief Mate"
	faction = "Colony"
	supervisors = "the colony captain and common sense"
	selection_color = "#ddddff"
	idtype = /obj/item/weapon/card/id/silver
	alt_titles = list()
	minimal_player_age = 10
	economic_modifier = 10

	minimum_character_age = 24
	ideal_character_age = 33

	implanted = 0
	uniform = /obj/item/clothing/under/rank/warden/dnavy
	shoes = /obj/item/clothing/shoes/men_shoes
	pda = /obj/item/device/pda
	ear = /obj/item/device/radio/headset


	put_in_backpack = list(
		/obj/item/device/radio,
		/obj/item/storage/box/ids
	)

//Need to add to him:
//warm clothes
//mechanical machine that prints cards of taked objects
/datum/job/qm/stockman
	title = "Quartermaster"
	faction = "Colony"
	supervisors = "the colony captain and chief mate"
	selection_color = "#dddddd"
	idtype = /obj/item/weapon/card/id/silver
	minimal_access = list(
		access_maint_tunnels, access_mailsorting, access_cargo, access_cargo_bot, access_qm, access_mining,
		access_mining_station
	)

	uniform = /obj/item/clothing/under/assistantformal
	shoes = /obj/item/clothing/shoes/brown
	pda = /obj/item/device/pda
	gloves = /obj/item/clothing/gloves/black
	ear = /obj/item/device/radio/headset
	hand = /obj/item/weapon/clipboard
	glasses = null

	put_in_backpack = list(
		/obj/item/device/radio
	)


//Need to add to him:
//warm clothes
//real multitool
/datum/job/engi/chief_engineer/snowy_ce
	title = "Chief Engineer"
	faction = "Colony"
	supervisors = "the colony captain and chief mate"
	selection_color = "#ffeeaa"

	uniform = /obj/item/clothing/under/rank/chief_engineer
	shoes = /obj/item/clothing/shoes/brown
	pda = /obj/item/device/pda
	hat = /obj/item/clothing/head/hardhat/white
	gloves = /obj/item/clothing/gloves/black
	belt = /obj/item/storage/belt/utility/full
	ear = /obj/item/device/radio/headset

	put_in_backpack = list(
		/obj/item/device/radio
	)


//Need to add to him:
//warm clothes
//something special
/datum/job/science/rd/snowy_rd
	title = "Research Director"
	faction = "Colony"
	supervisors = "the colony captain and chief mate"
	selection_color = "#ffddff"

	uniform = /obj/item/clothing/under/rank/research_director
	pda = /obj/item/device/pda
	ear = /obj/item/device/radio/headset
	shoes = /obj/item/clothing/shoes/brown
	suit = /obj/item/clothing/suit/storage/toggle/labcoat
	hand = /obj/item/weapon/clipboard

	put_in_backpack = list(
		/obj/item/device/radio
	)


//Need to add to him:
//warm clothes
//hypospray?
/datum/job/medical/cmo/snowy_doctor
	title = "Doctor"
	faction = "Colony"
	supervisors = "the colony captain, chief mate and research director"
	economic_modifier = 10
	idtype = /obj/item/weapon/card/id
	minimal_access = list(
		access_medical, access_medical_equip, access_morgue, access_genetics,
		access_chemistry, access_virology, access_surgery,  access_psychiatrist,
		access_external_airlocks, access_maint_tunnels)

	minimum_character_age = 18
	minimal_player_age = 3
	ideal_character_age = 38

	uniform = /obj/item/clothing/under/pants/sweaterj
	shoes = /obj/item/clothing/shoes/brown
	pda = /obj/item/device/pda/heads/cmo
	suit = /obj/item/clothing/suit/storage/toggle/labcoat
	suit_store = /obj/item/device/flashlight/pen
	ear = null
	hand = /obj/item/storage/firstaid/adv

	put_in_backpack = list(
		/obj/item/device/radio
	)


//Need to add to him:
//warm clothes
/datum/job/assistant/worker
	title = "Worker"
	flag = CARGOTECH
	faction = "Colony"
	supervisors = "all colony command"
	selection_color = "#dddddd"
	economic_modifier = 1
	minimal_access = list(access_maint_tunnels)
	alt_titles = list()

	uniform = /obj/item/clothing/under/serviceoveralls
	pda = /obj/item/device/pda
	ear = null
	shoes = /obj/item/clothing/shoes/workboots

	put_in_backpack = list(
		/obj/item/device/radio
	)


//Need to add to him:
//warm clothes
/datum/job/chef/cook
	title = "Cook"
	faction = "Colony"
	supervisors = "the colony captain, chief mate and quartermaster"
	selection_color = "#dddddd"
	minimal_access = list(access_kitchen, access_bar, access_hydroponics, access_maint_tunnels)
	alt_titles = list()

	uniform = /obj/item/clothing/under/rank/chef
	shoes = /obj/item/clothing/shoes/black
	pda = /obj/item/device/pda/chef
	hat = /obj/item/clothing/head/chefhat
	suit = /obj/item/clothing/suit/chef
	ear = null

	put_in_backpack = list(
		/obj/item/device/radio
	)


//Need to add to him:
//warm clothes
//real multitool
/datum/job/engi/engineer/snowy_eng
	title = "Colony Engineer"
	flag = ENGINEER
	faction = "Colony"
	total_positions = 5
	spawn_positions = 5
	minimum_character_age = 20
	addcional_access = list(access_atmospherics)
	minimal_access = list(
		access_eva, access_engine, access_engine_equip, access_tech_storage,
		access_maint_tunnels, access_external_airlocks, access_construction
	)
	alt_titles = list()

	uniform = /obj/item/clothing/under/rank/engineer
	shoes = /obj/item/clothing/shoes/workboots
	pda = /obj/item/device/pda
	hat = /obj/item/clothing/head/hardhat
	belt = /obj/item/storage/belt/utility/full
	ear = null

	put_in_backpack = list(
		/obj/item/device/radio,
		/obj/item/device/t_scanner
	)


//Need to add to him:
//warm clothes
/datum/job/science/scientist/snowy_scienceman
	title = "Academician"
	flag = SCIENTIST
	faction = "Colony"
	total_positions = 5
	spawn_positions = 3
	economic_modifier = 7
	addcional_access = list(access_robotics, access_xenobiology)
	minimal_access = list(access_tox, access_tox_storage, access_research, access_xenoarch)
	alt_titles = list()

	minimal_player_age = 14

	suit = /obj/item/clothing/suit/storage/toggle/labcoat
	uniform = /obj/item/clothing/under/rank/scientist
	pda = /obj/item/device/pda
	ear = null

	put_in_backpack = list(
		/obj/item/device/radio
	)


//Need to add to him:
//flaregun
//nice warm coat
//old gun Krauzer-801
//folding hatchet
//balaclava
//some warm clothes
//special zippo lighter
/datum/job/security/officer/jaeger
	title = "Jaeger"
	flag = OFFICER
	faction = "Colony"
	supervisors = "the colony captain and chief mate"
	alt_titles = list()
	addcional_access = list(access_morgue)
	minimal_access = list(
		access_security, access_eva, access_sec_doors, access_brig, access_court, access_maint_tunnels,
		access_external_airlocks
	)

	implanted = 0

	minimal_player_age = 7
	minimum_character_age = 20
	uniform = /obj/item/clothing/under/rank/tactical
	pda = /obj/item/device/pda
	shoes = /obj/item/clothing/shoes/workboots
	gloves = /obj/item/clothing/gloves/black
	ear = null

	put_in_backpack = list(
		/obj/item/device/radio
	)