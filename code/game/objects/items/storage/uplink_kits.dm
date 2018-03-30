/obj/item/storage/box/syndicate/populateContents()
	switch (pickweight(list("bloodyspai" = 1, "stealth" = 1, "screwed" = 1, "guns" = 1, "murder" = 1, "freedom" = 1, "hacker" = 1, "lordsingulo" = 1, "smoothoperator" = 1)))
		if("bloodyspai")
			PoolOrNew(/obj/item/chameleon/under, src)
			PoolOrNew(/obj/item/clothing/mask/gas/voice, src)
			PoolOrNew(/obj/item/weapon/card/id/syndicate, src)
			PoolOrNew(/obj/item/clothing/shoes/syndigaloshes, src)
			return

		if("stealth")
			PoolOrNew(/obj/item/weapon/gun/energy/crossbow, src)
			PoolOrNew(/obj/item/weapon/pen/reagent/paralysis, src)
			PoolOrNew(/obj/item/device/chameleon, src)
			return

		if("screwed")
			PoolOrNew(/obj/effect/spawner/newbomb/timer/syndicate, src)
			PoolOrNew(/obj/effect/spawner/newbomb/timer/syndicate, src)
			PoolOrNew(/obj/item/device/powersink, src)
			PoolOrNew(/obj/item/clothing/suit/space/syndicate, src)
			PoolOrNew(/obj/item/clothing/head/helmet/space/syndicate, src)
			PoolOrNew(/obj/item/clothing/mask/gas/syndicate, src)
			PoolOrNew(/obj/item/weapon/tank/emergency_oxygen/double, src)
			return

		if("guns")
			PoolOrNew(/obj/item/weapon/gun/projectile/revolver, src)
			PoolOrNew(/obj/item/ammo_magazine/a357, src)
			PoolOrNew(/obj/item/weapon/card/emag, src)
			PoolOrNew(/obj/item/weapon/plastique, src)
			PoolOrNew(/obj/item/weapon/plastique, src)
			return

		if("murder")
			PoolOrNew(/obj/item/weapon/melee/energy/sword, src)
			PoolOrNew(/obj/item/clothing/glasses/thermal/syndi, src)
			PoolOrNew(/obj/item/weapon/card/emag, src)
			PoolOrNew(/obj/item/clothing/shoes/syndigaloshes, src)
			return

		if("freedom")
			PoolOrNew(/obj/item/weapon/implanter, src)
			PoolOrNew(/obj/item/weapon/implanter/uplink, src)
			return

		if("hacker")
			PoolOrNew(/obj/item/device/encryptionkey/syndicate, src)
			PoolOrNew(/obj/item/weapon/aiModule/syndicate, src)
			PoolOrNew(/obj/item/weapon/card/emag, src)
			PoolOrNew(/obj/item/device/encryptionkey/binary, src)
			return

		if("lordsingulo")
			PoolOrNew(/obj/item/device/radio/beacon/syndicate, src)
			PoolOrNew(/obj/item/clothing/suit/space/syndicate, src)
			PoolOrNew(/obj/item/clothing/head/helmet/space/syndicate, src)
			PoolOrNew(/obj/item/clothing/mask/gas/syndicate, src)
			PoolOrNew(/obj/item/weapon/tank/emergency_oxygen/double, src)
			PoolOrNew(/obj/item/weapon/card/emag, src)
			return

		if("smoothoperator")
			PoolOrNew(/obj/item/storage/box/syndie_kit/g9mm, src)
			PoolOrNew(/obj/item/storage/bag/trash, src)
			PoolOrNew(/obj/item/weapon/soap/syndie, src)
			PoolOrNew(/obj/item/bodybag, src)
			PoolOrNew(/obj/item/clothing/under/suit_jacket, src)
			PoolOrNew(/obj/item/clothing/shoes/laceup, src)
			return


/obj/item/storage/box/syndie_kit
	name = "box"
	desc = "A sleek, sturdy box"
	icon_state = "box_of_doom"


/obj/item/storage/box/syndie_kit/imp_freedom
	name = "boxed freedom implant (with injector)"

/obj/item/storage/box/syndie_kit/imp_freedom/populateContents()
	..()
	var/obj/item/weapon/implanter/O = new(src)
	O.imp = PoolOrNew(/obj/item/weapon/implant/freedom, O)
	O.update_icon()


/obj/item/storage/box/syndie_kit/imp_compress
	name = "box (C)"
	preloaded = list(
		/obj/item/weapon/implanter/compressed
	)


/obj/item/storage/box/syndie_kit/imp_explosive
	name = "box (E)"
	preloaded = list(
		/obj/item/weapon/implanter/explosive
	)


/obj/item/storage/box/syndie_kit/imp_uplink
	name = "boxed uplink implant (with injector)"
	preloaded = list(
		/obj/item/weapon/implanter/uplink
	)


/obj/item/storage/box/syndie_kit/space
	name = "boxed space suit and helmet"
	preloaded = list(
		/obj/item/clothing/suit/space/syndicate,
		/obj/item/clothing/head/helmet/space/syndicate,
		/obj/item/clothing/mask/gas/syndicate,
		/obj/item/weapon/tank/emergency_oxygen/double,
	)


/obj/item/storage/box/syndie_kit/chameleon
	name = "chameleon kit"
	desc = "Comes with all the clothes you need to impersonate most people.  Acting lessons sold seperately."
	storage_slots = 10
	preloaded = list(
		/obj/item/chameleon/under,
		/obj/item/chameleon/head,
		/obj/item/chameleon/suit,
		/obj/item/chameleon/shoes,
		/obj/item/storage/backpack/chameleon,
		/obj/item/chameleon/gloves,
		/obj/item/chameleon/mask,
		/obj/item/chameleon/glasses,
		/obj/item/weapon/gun/projectile/chameleon,
	)


/obj/item/storage/box/syndie_kit/clerical
	name = "clerical kit"
	desc = "Comes with all you need to fake paperwork. Assumes you have passed basic writing lessons."
	preloaded = list(
		/obj/item/weapon/stamp/chameleon,
		/obj/item/weapon/pen/chameleon,
		/obj/item/device/destTagger,
		/obj/item/weapon/packageWrap,
		/obj/item/weapon/hand_labeler,
	)


/obj/item/storage/box/syndie_kit/spy
	name = "spy kit"
	desc = "For when you want to conduct voyeurism from afar."
	preloaded = list(
		/obj/item/device/spy_bug = 6,
		/obj/item/device/spy_monitor,
	)


/obj/item/storage/box/syndie_kit/g9mm
	name = "\improper Smooth operator"
	desc = "9mm with silencer kit."
	preloaded = list(
		/obj/item/weapon/gun/projectile/pistol,
		/obj/item/weapon/silencer,
	)


/obj/item/storage/box/syndie_kit/toxin
	name = "toxin kit"
	desc = "An apple will not be enough to keep the doctor away after this."
	preloaded = list(
		/obj/item/weapon/reagent_containers/glass/beaker/vial/random/toxin,
		/obj/item/weapon/reagent_containers/syringe,
	)


/obj/item/storage/box/syndie_kit/ewar_voice
	name = "Electrowarfare and Voice Synthesiser kit"
	desc = "Kit for confounding organic and synthetic entities alike."
	preloaded = list(
		/obj/item/rig_module/electrowarfare_suite,
		/obj/item/rig_module/voice,
	)


/obj/item/storage/box/syndie_kit/cigarette
	name = "\improper Tricky smokes"
	desc = "Comes with the following brands of cigarettes, in this order: 2xFlash, 2xSmoke, 1xMindBreaker, 1xTricordrazine. Avoid mixing them up."

/obj/item/storage/box/syndie_kit/cigarette/populateContents()
	..()
	var/obj/item/storage/fancy/cigarettes/pack
	pack = PoolOrNew(/obj/item/storage/fancy/cigarettes, src)
	fill_cigarre_package(pack, list("aluminum" = 5, "potassium" = 5, "sulfur" = 5))
	pack.desc += " 'F' has been scribbled on it."

	pack = PoolOrNew(/obj/item/storage/fancy/cigarettes, src)
	fill_cigarre_package(pack, list("aluminum" = 5, "potassium" = 5, "sulfur" = 5))
	pack.desc += " 'F' has been scribbled on it."

	pack = PoolOrNew(/obj/item/storage/fancy/cigarettes, src)
	fill_cigarre_package(pack, list("potassium" = 5, "sugar" = 5, "phosphorus" = 5))
	pack.desc += " 'S' has been scribbled on it."

	pack = PoolOrNew(/obj/item/storage/fancy/cigarettes, src)
	fill_cigarre_package(pack, list("potassium" = 5, "sugar" = 5, "phosphorus" = 5))
	pack.desc += " 'S' has been scribbled on it."

	pack = PoolOrNew(/obj/item/storage/fancy/cigarettes, src)
	// Dylovene. Going with 1.5 rather than 1.6666666...
	fill_cigarre_package(pack, list("potassium" = 1.5, "ammonia" = 1.5, "silicon" = 1.5))
	// Mindbreaker
	fill_cigarre_package(pack, list("silicon" = 4.5, "hydrazine" = 4.5))

	pack.desc += " 'MB' has been scribbled on it."

	pack = PoolOrNew(/obj/item/storage/fancy/cigarettes, src)
	pack.reagents.add_reagent("tricordrazine", 15 * pack.storage_slots)
	pack.desc += " 'T' has been scribbled on it."

	PoolOrNew(/obj/item/weapon/flame/lighter/zippo, src)

/proc/fill_cigarre_package(var/obj/item/storage/fancy/cigarettes/C, var/list/reagents)
	for(var/reagent in reagents)
		C.reagents.add_reagent(reagent, reagents[reagent] * C.storage_slots)

