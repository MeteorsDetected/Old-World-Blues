/obj/structure/closet/cabinet/underwear
	name = "underwear wardrobe"
	desc = "Holds item of clothing you shouldn't be showing off in the hallways."

/obj/structure/closet/cabinet/underwear/PopulateContents()
	var/tmp_type
	for(var/i in 1 to 6)
		tmp_type = pick(subtypesof(/obj/item/clothing/hidden/underwear))
		new tmp_type(src)
	for(var/i in 1 to 6)
		tmp_type = pick(subtypesof(/obj/item/clothing/hidden/undershirt))
		new tmp_type(src)
	for(var/i in 1 to 6)
		tmp_type = pick(subtypesof(/obj/item/clothing/hidden/socks))
		new tmp_type(src)

/obj/structure/closet/wardrobe
	name = "wardrobe"
	desc = "It's a storage unit for standard-issue attire."
	icon_state = "blue"

/obj/structure/closet/wardrobe/red
	name = "security wardrobe"
	icon_state = "red"

/obj/structure/closet/wardrobe/red/willContatin()
	. = list(
		/obj/item/clothing/under/rank/security = 3,
		/obj/item/clothing/shoes/jackboots = 3,
		/obj/item/clothing/head/soft/sec = 3,
		/obj/item/clothing/head/beret/sec = 3,
		/obj/item/clothing/mask/bandana/red = 3,
		/obj/item/clothing/accessory/armband = 3,
		/obj/item/clothing/accessory/holster/gun/armpit,
		/obj/item/clothing/accessory/holster/gun/waist = 2,
		/obj/item/clothing/accessory/holster/gun/hip
	)
	for(var/i in 1 to 3)
		. += pick(\
			/obj/item/storage/backpack/security,
			/obj/item/storage/backpack/satchel/sec,
			/obj/item/storage/backpack/dufflebag/sec,
			/obj/item/storage/backpack/messenger/sec,
		)

/obj/structure/closet/wardrobe/redalt
	name = "alternative security wardrobe"
	desc = "It's a storage unit for not-so-standard-issue Nanotrasen attire. Still allowed though."
	icon_state = "red"

/obj/structure/closet/wardrobe/redalt/willContatin()
	return list(
		/obj/item/clothing/under/rank/cadet = 3,
		/obj/item/clothing/under/rank/dispatch = 2,
		/obj/item/clothing/head/beret/sec/alt = 3,
		/obj/item/clothing/under/rank/security/jeans = 2,
		/obj/item/clothing/under/rank/security/dnavy = 2,
	)

/obj/structure/closet/wardrobe/pink
	name = "pink wardrobe"
	icon_state = "pink"

/obj/structure/closet/wardrobe/pink/willContatin()
	return list(
		/obj/item/clothing/under/color/pink = 3,
		/obj/item/clothing/shoes/brown = 3,
	)

/obj/structure/closet/wardrobe/black
	name = "black wardrobe"
	icon_state = "black"

/obj/structure/closet/wardrobe/black/willContatin()
	return list(
		/obj/item/clothing/under/color/black = 3,
		/obj/item/clothing/shoes/black = 3,
		/obj/item/clothing/head/that = 3,
		/obj/item/clothing/head/soft/black = 3,
		/obj/item/clothing/mask/bandana = 3,
		/obj/item/storage/backpack/messenger/black,
	)

/obj/structure/closet/wardrobe/chaplain_black
	name = "chapel wardrobe"
	desc = "It's a storage unit for approved religious attire."
	icon_state = "black"

/obj/structure/closet/wardrobe/chaplain_black/willContatin()
	return list(
		/obj/item/clothing/under/rank/chaplain,
		/obj/item/clothing/shoes/black,
		/obj/item/clothing/suit/nun,
		/obj/item/clothing/head/nun_hood,
		/obj/item/clothing/suit/storage/chaplain_hoodie,
		/obj/item/clothing/head/chaplain_hood,
		/obj/item/clothing/suit/holidaypriest,
		/obj/item/clothing/under/wedding/bride_white,
		/obj/item/storage/backpack/cultpack ,
		/obj/item/storage/fancy/candle_box = 2
	)


/obj/structure/closet/wardrobe/green
	name = "green wardrobe"
	icon_state = "green"

/obj/structure/closet/wardrobe/green/willContatin()
	return list(
		/obj/item/clothing/under/color/green = 3,
		/obj/item/clothing/shoes/black = 3,
		/obj/item/clothing/mask/bandana/green = 3,
	)

/obj/structure/closet/wardrobe/xenos
	name = "xenos wardrobe"
	icon_state = "green"

/obj/structure/closet/wardrobe/xenos/willContatin()
	return list(
		/obj/item/clothing/suit/unathi/mantle,
		/obj/item/clothing/suit/unathi/robe,
		/obj/item/clothing/shoes/sandal = 3,
	)


/obj/structure/closet/wardrobe/orange
	name = "prison wardrobe"
	desc = "It's a storage unit for regulation prisoner attire."
	icon_state = "orange"

/obj/structure/closet/wardrobe/orange/willContatin()
	return list(
		/obj/item/clothing/under/color/orange = 3,
		/obj/item/clothing/shoes/orange = 3,
	)


/obj/structure/closet/wardrobe/yellow
	name = "yellow wardrobe"
	icon_state = "yellow"

/obj/structure/closet/wardrobe/yellow/willContatin()
	return list(
		/obj/item/clothing/under/color/yellow = 3,
		/obj/item/clothing/shoes/orange = 3,
		/obj/item/clothing/mask/bandana/gold = 3,
	)


/obj/structure/closet/wardrobe/atmospherics_yellow
	name = "atmospherics wardrobe"
	icon_state = "yellow"

/obj/structure/closet/wardrobe/atmospherics_yellow/willContatin()
	return list(
		/obj/item/clothing/under/rank/atmospheric_technician = 3,
		/obj/item/clothing/under/rank/atmospheric_technician/skirt = 3,
		/obj/item/clothing/shoes/black = 3,
		/obj/item/clothing/head/hardhat/red = 3,
		/obj/item/clothing/head/beret/eng = 3,
		/obj/item/clothing/mask/bandana/gold = 3,
	)

/obj/structure/closet/wardrobe/engineering_yellow
	name = "engineering wardrobe"
	icon_state = "yellow"

/obj/structure/closet/wardrobe/engineering_yellow/willContatin()
	return list(
		/obj/item/clothing/under/rank/engineer,
		/obj/item/clothing/under/rank/engineer/maintenance_tech,
		/obj/item/clothing/under/rank/engineer/engine_tech,
		/obj/item/clothing/under/rank/engineer/electrician,
		/obj/item/clothing/under/rank/engineer/skirt = 2,
		/obj/item/clothing/shoes/orange = 3,
		/obj/item/clothing/head/hardhat = 3,
		/obj/item/clothing/head/beret/eng = 3,
		/obj/item/clothing/mask/bandana/gold = 3,
		/obj/item/clothing/shoes/workboots = 3,
	)


/obj/structure/closet/wardrobe/white
	name = "white wardrobe"
	icon_state = "white"

/obj/structure/closet/wardrobe/white/willContatin()
	return list(
		/obj/item/clothing/under/color/white = 3,
		/obj/item/clothing/shoes/white = 3,
	)


/obj/structure/closet/wardrobe/pjs
	name = "pajama wardrobe"
	icon_state = "white"

/obj/structure/closet/wardrobe/pjs/willContatin()
	return list(
		/obj/item/clothing/under/pj = 2,
		/obj/item/clothing/under/pj/blue = 2,
		/obj/item/clothing/shoes/white = 2,
		/obj/item/clothing/shoes/slippers = 2,
	)


/obj/structure/closet/wardrobe/research
	name = "science wardrobe"
	icon_state = "white"

/obj/structure/closet/wardrobe/research/willContatin()
	. = list(
		/obj/item/clothing/under/rank/scientist = 2,
		/obj/item/clothing/under/rank/xenoarch = 2,
		/obj/item/clothing/under/rank/plasmares = 2,
		/obj/item/clothing/under/rank/xenobio = 2,
		/obj/item/clothing/under/rank/anomalist = 2,
		/obj/item/clothing/suit/storage/toggle/labcoat = 3,
		/obj/item/clothing/shoes/white = 3,
	)
	for(var/i in 1 to 2)
		. += pick(\
			/obj/item/storage/backpack/toxins,
			/obj/item/storage/backpack/satchel/tox,
			/obj/item/storage/backpack/messenger/tox,
		)

/obj/structure/closet/wardrobe/robotics_black
	name = "robotics wardrobe"
	icon_state = "black"

/obj/structure/closet/wardrobe/robotics_black/willContatin()
	. = list(
		/obj/item/clothing/under/rank/roboticist,
		/obj/item/clothing/under/rank/roboticist/skirt,
		/obj/item/clothing/under/rank/biomechanical,
		/obj/item/clothing/under/rank/mechatronic,
		/obj/item/clothing/suit/storage/toggle/labcoat/science,
		/obj/item/clothing/suit/storage/toggle/labcoat/science,
		/obj/item/clothing/shoes/black,
		/obj/item/clothing/shoes/black,
		/obj/item/clothing/gloves/black,
		/obj/item/clothing/gloves/black,
		/obj/item/device/radio/headset/rob,
		/obj/item/device/radio/headset/rob,
	)
	for(var/i in 1 to 2)
		. += pick(\
			/obj/item/storage/backpack/toxins,
			/obj/item/storage/backpack/satchel/tox,
			/obj/item/storage/backpack/messenger/tox,
		)


/obj/structure/closet/wardrobe/chemistry_white
	name = "chemistry wardrobe"
	icon_state = "white"

/obj/structure/closet/wardrobe/chemistry_white/willContatin()
	. = list(
		/obj/item/clothing/under/rank/chemist,
		/obj/item/clothing/under/rank/pharma,
		/obj/item/clothing/under/rank/chemist_new,
		/obj/item/clothing/shoes/white = 2,
		/obj/item/clothing/suit/storage/toggle/labcoat/chemist = 2,
	)
	for(var/i in 1 to 2)
		. += pick(
			/obj/item/storage/backpack/chemistry,
			/obj/item/storage/backpack/satchel/chem,
			/obj/item/storage/backpack/dufflebag/med,
			/obj/item/storage/backpack/messenger/chem,
		)


/obj/structure/closet/wardrobe/genetics_white
	name = "genetics wardrobe"
	icon_state = "white"

/obj/structure/closet/wardrobe/genetics_white/willContatin()
	. = list(
		/obj/item/clothing/under/rank/geneticist,
		/obj/item/clothing/under/rank/geneticist_new,
		/obj/item/clothing/shoes/white = 2,
		/obj/item/clothing/suit/storage/toggle/labcoat/genetics = 2
	)
	for(var/i in 1 to 2)
		. += pick(\
			/obj/item/storage/backpack/genetics,
			/obj/item/storage/backpack/satchel/gen,
			/obj/item/storage/backpack/dufflebag/med,
			/obj/item/storage/backpack/messenger/med,
		)


/obj/structure/closet/wardrobe/virology_white
	name = "virology wardrobe"
	icon_state = "white"

/obj/structure/closet/wardrobe/virology_white/willContatin()
	. = list(
		/obj/item/clothing/under/rank/virologist,
		/obj/item/clothing/under/rank/virologist_new,
		/obj/item/clothing/shoes/white = 2,
		/obj/item/clothing/suit/storage/toggle/labcoat/virologist = 2,
		/obj/item/clothing/mask/surgical = 2
	)
	for(var/i in 1 to 2)
		. += pick(
			/obj/item/storage/backpack/virology,
			/obj/item/storage/backpack/satchel/vir,
			/obj/item/storage/backpack/dufflebag/med,
			/obj/item/storage/backpack/messenger/vir,
		)


/obj/structure/closet/wardrobe/medic_white
	name = "medical wardrobe"
	icon_state = "white"

/obj/structure/closet/wardrobe/medic_white/willContatin()
	return list(
		/obj/item/clothing/under/rank/medical = 2,
		/obj/item/clothing/under/rank/medical/sleeveless/blue,
		/obj/item/clothing/under/rank/medical/sleeveless/green,
		/obj/item/clothing/under/rank/medical/sleeveless/purple,
		/obj/item/clothing/shoes/white = 2,
		/obj/item/clothing/suit/storage/toggle/labcoat = 2,
		/obj/item/clothing/mask/surgical = 2,
	)


/obj/structure/closet/wardrobe/grey
	name = "grey wardrobe"
	icon_state = "grey"

/obj/structure/closet/wardrobe/grey/willContatin()
	return list(
		/obj/item/clothing/under/color/grey = 3,
		/obj/item/clothing/shoes/black = 3,
		/obj/item/clothing/head/soft/grey = 3,
	)


/obj/structure/closet/wardrobe/mixed
	name = "mixed wardrobe"
	icon_state = "mixed"

/obj/structure/closet/wardrobe/mixed/willContatin()
	return list(
		/obj/item/clothing/under/color/blue,
		/obj/item/clothing/under/color/yellow,
		/obj/item/clothing/under/color/green,
		/obj/item/clothing/under/color/orange,
		/obj/item/clothing/under/color/pink,
		/obj/item/clothing/under/dress/plaid_blue,
		/obj/item/clothing/under/dress/plaid_red,
		/obj/item/clothing/under/dress/plaid_purple,
		/obj/item/clothing/under/dress/plaid_black,
		/obj/item/clothing/shoes/blue,
		/obj/item/clothing/shoes/yellow,
		/obj/item/clothing/shoes/green,
		/obj/item/clothing/shoes/orange,
		/obj/item/clothing/shoes/purple,
		/obj/item/clothing/shoes/red,
		/obj/item/clothing/shoes/leather,
		/obj/item/clothing/mask/bandana/blue,
		/obj/item/clothing/mask/bandana/blue,
	)

/obj/structure/closet/wardrobe/tactical
	name = "tactical equipment"
	icon_state = "syndicate1"
	icon_opened = "syndicate1open"

/obj/structure/closet/wardrobe/tactical/willContatin()
	. = list(
		/obj/item/clothing/under/rank/tactical,
		/obj/item/clothing/suit/armor/tactical,
		/obj/item/clothing/head/helmet/tactical,
		/obj/item/clothing/mask/balaclava/tactical,
		/obj/item/clothing/mask/balaclava,
		/obj/item/clothing/glasses/sunglasses/sechud/tactical,
		/obj/item/storage/belt/security/tactical,
		/obj/item/clothing/shoes/jackboots,
		/obj/item/clothing/gloves/black,
		/obj/item/clothing/under/pants/camo
	)
	if(prob(10))
		. += /obj/item/clothing/mask/bandana/skull

/obj/structure/closet/wardrobe/ert
	name = "emergency response team equipment"
	icon_state = "syndicate1"
	icon_opened = "syndicate1open"

/obj/structure/closet/wardrobe/ert/willContatin()
	return list(
		/obj/item/clothing/under/rank/centcom,
		/obj/item/clothing/under/ert,
		/obj/item/clothing/under/syndicate/combat,
		/obj/item/clothing/glasses/sunglasses,
		/obj/item/clothing/shoes/swat,
		/obj/item/clothing/gloves/black/swat,
		/obj/item/clothing/mask/balaclava/tactical,
		/obj/item/clothing/mask/balaclava,
		/obj/item/clothing/mask/bandana/skull = 2
	)

/obj/structure/closet/wardrobe/suit
	name = "suit locker"
	icon_state = "mixed"

/obj/structure/closet/wardrobe/suit/willContatin()
	return list(
		/obj/item/clothing/under/assistantformal,
		/obj/item/clothing/under/with_suit/charcoal,
		/obj/item/clothing/under/with_suit/navy,
		/obj/item/clothing/under/with_suit/burgundy,
		/obj/item/clothing/under/with_suit/checkered,
		/obj/item/clothing/under/with_suit/tan,
		/obj/item/clothing/under/sl_suit,
		/obj/item/clothing/under/suit_jacket,
		/obj/item/clothing/under/suit_female,
		/obj/item/clothing/under/really_black,
		/obj/item/clothing/under/librarian,
		/obj/item/clothing/under/scratch,
		/obj/item/storage/backpack/satchel = 2
	)

/obj/structure/closet/cabinet/captain
	name = "captaing's wardrobe"

/obj/structure/closet/wardrobe/captain/willContatin()
	. = list(
		/obj/item/clothing/suit/captunic,
		/obj/item/clothing/suit/captunic/capjacket,
		/obj/item/clothing/under/rank/captain,
		/obj/item/clothing/shoes/brown,
		/obj/item/clothing/gloves/captain,
		/obj/item/clothing/under/rank/captain/dress,
		/obj/item/clothing/under/captainformal,
		/obj/item/clothing/head/beret/centcom/captain,
		/obj/item/clothing/under/rank/captain/green,
		/obj/item/clothing/glasses/sunglasses
	)
	for(var/i in 1 to 2)
		. += pick(
			/obj/item/storage/backpack/captain,
			/obj/item/storage/backpack/satchel/cap,
			/obj/item/storage/backpack/dufflebag/cap,
		)


/obj/structure/closet/wardrobe/ems
	name = "EMS wardrobe"
	icon_state = "ems"

/obj/structure/closet/wardrobe/ems/willContatin()
	return list(
		/obj/item/clothing/head/soft/emt = 2,
		/obj/item/clothing/head/soft/emt/emerald = 2,
		/obj/item/clothing/under/rank/medical/sleeveless/paramedic = 2,
		/obj/item/clothing/under/rank/medical/sleeveless/black = 2,
		/obj/item/clothing/suit/storage/paramedic = 2,
		/obj/item/clothing/suit/storage/fr_jacket/emerald = 2,
		/obj/item/clothing/shoes/jackboots = 2,
	)

