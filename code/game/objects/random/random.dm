/obj/random
	name = "random object"
	desc = "This item type is used to spawn random objects at round-start"
	icon = 'icons/misc/mark.dmi'
	icon_state = "rup"
	var/spawn_nothing_percentage = 0 // this variable determines the likelyhood that this random object will not spawn anything


// creates a new object and deletes itself
/obj/random/New()
	..()
	if (!prob(spawn_nothing_percentage))
		spawn_item()
	qdel(src)


// this function should return a specific item to spawn
/obj/random/proc/item_to_spawn()
	return 0


// creates the random item
/obj/random/proc/spawn_item()
	var/build_path = item_to_spawn()
	return (new build_path(src.loc))


/obj/random/single
	name = "randomly spawned object"
	desc = "This item type is used to randomly spawn a given object at round-start"
	icon_state = "x3"
	var/spawn_object = null
	item_to_spawn()
		return ispath(spawn_object) ? spawn_object : text2path(spawn_object)

/obj/random/single/cards
	name = "deck of cards"
	icon = 'icons/obj/playing_cards.dmi'
	icon_state = "deck"
	spawn_object = /obj/item/weapon/deck/cards

/obj/random/single/oil
	name = "oil"
	spawn_nothing_percentage = 30
	icon = 'icons/mob/robots.dmi'
	icon_state = "floor2"
	spawn_object = /obj/effect/decal/cleanable/blood/oil/streak


/obj/random/tool
	name = "random tool"
	desc = "This is a random tool"
	icon = 'icons/obj/items.dmi'
	icon_state = "welder"
	item_to_spawn()
		return pick(/obj/item/weapon/screwdriver,
					/obj/item/weapon/wirecutters,
					/obj/item/weapon/weldingtool,
					/obj/item/weapon/weldingtool/largetank,
					/obj/item/weapon/crowbar,
					/obj/item/weapon/wrench,
					/obj/item/device/flashlight,
					/obj/item/device/multitool)


/obj/random/technology_scanner
	name = "random scanner"
	desc = "This is a random technology scanner."
	icon = 'icons/obj/device.dmi'
	icon_state = "atmos"
	item_to_spawn()
		return pick(prob(5);/obj/item/device/t_scanner,
					prob(2);/obj/item/device/radio,
					prob(5);/obj/item/device/analyzer)

/obj/random/armor
	name = "random plate carrier"
	desc = "This is a random plate carrier."
	icon = 'icons/inv_slots/suits/icon.dmi'
	icon_state = "secheavyvest_badge"
	item_to_spawn()
		return pick(prob(3);/obj/item/clothing/suit/storage/vest/seclight,
					prob(3);/obj/item/clothing/suit/storage/vest/heavy/securitymedium,
					prob(3);/obj/item/clothing/suit/storage/vest/heavy/security)


/obj/random/pistol
	name = "random pistol"
	desc = "This is a random .45 pistol."
	icon = 'icons/obj/gun.dmi'
	icon_state = "secguncomp"
	item_to_spawn()
		return pick(prob(2);/obj/item/weapon/gun/projectile/sec,
					prob(2);/obj/item/weapon/gun/projectile/sec/wood,
					prob(2);/obj/item/weapon/gun/projectile/sec/longbarrel,
					prob(2);/obj/item/weapon/gun/projectile/sec/shortbarrel,
					prob(2);/obj/item/weapon/gun/projectile/sec/tactical)


/obj/random/powercell
	name = "random powercell"
	desc = "This is a random powercell."
	icon = 'icons/obj/power.dmi'
	icon_state = "cell"
	item_to_spawn()
		return pick(prob(10);/obj/item/weapon/cell/crap,
					prob(40);/obj/item/weapon/cell,
					prob(40);/obj/item/weapon/cell/high,
					prob(9);/obj/item/weapon/cell/super,
					prob(1);/obj/item/weapon/cell/hyper)


/obj/random/bomb_supply
	name = "bomb supply"
	desc = "This is a random bomb supply."
	icon = 'icons/obj/assemblies/new_assemblies.dmi'
	icon_state = "signaller"
	item_to_spawn()
		return pick(/obj/item/device/assembly/igniter,
					/obj/item/device/assembly/prox_sensor,
					/obj/item/device/assembly/signaler,
					/obj/item/device/assembly/timer,
					/obj/item/device/multitool)


/obj/random/toolbox
	name = "random toolbox"
	desc = "This is a random toolbox."
	icon = 'icons/obj/storage.dmi'
	icon_state = "red"
	item_to_spawn()
		return pick(prob(6);/obj/item/storage/toolbox/mechanical,
					prob(6);/obj/item/storage/toolbox/electrical,
					prob(2);/obj/item/storage/toolbox/emergency,
					prob(1);/obj/item/storage/toolbox/syndicate)


/obj/random/tech_supply
	name = "random tech supply"
	desc = "This is a random piece of technology supplies."
	icon = 'icons/obj/power.dmi'
	icon_state = "cell"
	spawn_nothing_percentage = 50
	item_to_spawn()
		return pick(prob(3);/obj/random/powercell,
					prob(2);/obj/random/technology_scanner,
					prob(1);/obj/item/weapon/packageWrap,
					prob(2);/obj/random/bomb_supply,
					prob(1);/obj/item/weapon/extinguisher,
					prob(1);/obj/item/clothing/gloves/fyellow,
					prob(3);/obj/item/stack/cable_coil/random,
					prob(2);/obj/random/toolbox,
					prob(2);/obj/item/storage/belt/utility,
					prob(1);/obj/item/storage/belt/utility/full,
					prob(5);/obj/random/tool,
					prob(2);/obj/item/weapon/tape_roll,
					prob(2);/obj/item/taperoll/engineering)

/obj/random/medical
	name = "Random Medicine"
	desc = "This is a random medical item."
	icon = 'icons/obj/items.dmi'
	icon_state = "traumakit"
	item_to_spawn()
		return pick(prob(21);/obj/random/medical/lite,
					prob(5);/obj/random/medical/pillbottle,
					prob(1);/obj/item/storage/pill_bottle/tramadol,
					prob(1);/obj/item/storage/pill_bottle/antitox,
					prob(3);/obj/item/bodybag/cryobag,
					prob(3);/obj/item/weapon/reagent_containers/syringe/antiviral,
					prob(5);/obj/item/weapon/reagent_containers/syringe/inaprovaline,
					prob(1);/obj/item/weapon/reagent_containers/hypospray,
					prob(1);/obj/item/storage/box/freezer,
					prob(2);/obj/item/stack/nanopaste)

/obj/random/medical/pillbottle
	name = "Random Pill Bottle"
	desc = "This is a random pill bottle."
	icon = 'icons/obj/chemical.dmi'
	icon_state = "pill_canister"
	item_to_spawn()
		return pick(prob(1);/obj/item/storage/pill_bottle/spaceacillin,
					prob(1);/obj/item/storage/pill_bottle/dermaline,
					prob(1);/obj/item/storage/pill_bottle/dexalin_plus,
					prob(1);/obj/item/storage/pill_bottle/bicaridine)

/obj/random/medical/lite
	name = "Random Medicine"
	desc = "This is a random simple medical item."
	icon = 'icons/obj/items.dmi'
	icon_state = "brutepack"
	spawn_nothing_percentage = 25
	item_to_spawn()
		return pick(prob(4);/obj/item/stack/medical/bruise_pack,
					prob(4);/obj/item/stack/medical/ointment,
					prob(1);/obj/item/stack/medical/splint,
					prob(4);/obj/item/device/healthanalyzer,
					prob(1);/obj/item/bodybag,
					prob(3);/obj/item/weapon/reagent_containers/hypospray/autoinjector,
					prob(2);/obj/item/storage/pill_bottle/kelotane,
					prob(2);/obj/item/storage/pill_bottle/antitox)

/obj/random/firstaid
	name = "Random First Aid Kit"
	desc = "This is a random first aid kit."
	icon = 'icons/obj/storage.dmi'
	icon_state = "firstaid"
	item_to_spawn()
		return pick(prob(4);/obj/item/storage/firstaid/regular,
					prob(3);/obj/item/storage/firstaid/toxin,
					prob(3);/obj/item/storage/firstaid/o2,
					prob(2);/obj/item/storage/firstaid/adv,
					prob(3);/obj/item/storage/firstaid/fire,
					prob(1);/obj/item/storage/firstaid/combat)


/obj/random/contraband
	name = "Random Illegal Item"
	desc = "Hot Stuff."
	icon = 'icons/obj/items.dmi'
	icon_state = "purplecomb"
	spawn_nothing_percentage = 50
	item_to_spawn()
		return pick(prob(6);/obj/item/storage/pill_bottle/tramadol,
					prob(8);/obj/item/weapon/haircomb,
					prob(4);/obj/item/storage/pill_bottle/happy,
					prob(4);/obj/item/storage/pill_bottle/zoom,
					prob(10);/obj/item/weapon/contraband/poster,
					prob(4);/obj/item/weapon/material/butterfly,
					prob(6);/obj/item/weapon/material/butterflyblade,
					prob(6);/obj/item/weapon/material/butterflyhandle,
					prob(6);/obj/item/weapon/material/wirerod,
					prob(2);/obj/item/weapon/material/butterfly/switchblade,
					prob(1);/obj/item/clothing/suit/storage/vest/heavy/merc,
					prob(1);/obj/item/weapon/beartrap,
					prob(1);/obj/item/weapon/handcuffs,
					prob(2);/obj/item/weapon/reagent_containers/syringe/drugs)

/obj/random/soap
	name = "Random Soap"
	desc = "This is a random bar of soap."
	icon = 'icons/obj/items.dmi'
	icon_state = "soap"
	item_to_spawn()
		return pick(prob(3);/obj/item/weapon/soap,
					prob(2);/obj/item/weapon/soap/nanotrasen,
					prob(2);/obj/item/weapon/soap/deluxe,
					prob(1);/obj/item/weapon/soap/syndie,)

/obj/random/drinkbottle
	name = "random drink"
	desc = "This is a random drink."
	icon = 'icons/obj/drinks.dmi'
	icon_state = "whiskeybottle"
	item_to_spawn()
		return pick(/obj/item/weapon/reagent_containers/food/drinks/bottle/whiskey,
					/obj/item/weapon/reagent_containers/food/drinks/bottle/gin,
					/obj/item/weapon/reagent_containers/food/drinks/bottle/specialwhiskey,
					/obj/item/weapon/reagent_containers/food/drinks/bottle/vodka,
					/obj/item/weapon/reagent_containers/food/drinks/bottle/tequilla,
					/obj/item/weapon/reagent_containers/food/drinks/bottle/absinthe,
					/obj/item/weapon/reagent_containers/food/drinks/bottle/wine,
					/obj/item/weapon/reagent_containers/food/drinks/bottle/cognac,
					/obj/item/weapon/reagent_containers/food/drinks/bottle/rum,
					/obj/item/weapon/reagent_containers/food/drinks/bottle/patron)

/obj/random/energy
	name = "Random Energy Weapon"
	desc = "This is a random security weapon."
	icon = 'icons/obj/gun.dmi'
	icon_state = "energykill100"
	item_to_spawn()
		return pick(prob(3);/obj/item/weapon/gun/energy/laser,
					prob(4);/obj/item/weapon/gun/energy/gun,
					prob(3);/obj/item/weapon/gun/energy/gun/burst,
					prob(1);/obj/item/weapon/gun/energy/gun/nuclear,
					prob(2);/obj/item/weapon/gun/energy/retro,
					prob(2);/obj/item/weapon/gun/energy/lasercannon,
					prob(3);/obj/item/weapon/gun/energy/xray,
					prob(1);/obj/item/weapon/gun/energy/sniperrifle,
					prob(1);/obj/item/weapon/gun/energy/plasmastun,
					prob(2);/obj/item/weapon/gun/energy/ionrifle,
					prob(2);/obj/item/weapon/gun/energy/ionrifle/pistol,
					prob(3);/obj/item/weapon/gun/energy/toxgun,
					prob(4);/obj/item/weapon/gun/energy/taser,
					prob(2);/obj/item/weapon/gun/energy/crossbow/largecrossbow,
					prob(4);/obj/item/weapon/gun/energy/stunrevolver)

/obj/random/energy/sec
	name = "Random Security Energy Weapon"
	desc = "This is a random security weapon."
	icon = 'icons/obj/gun.dmi'
	icon_state = "energykill100"
	item_to_spawn()
		return pick(prob(2);/obj/item/weapon/gun/energy/laser,
					prob(2);/obj/item/weapon/gun/energy/gun)

/obj/random/projectile
	name = "Random Projectile Weapon"
	desc = "This is a random security weapon."
	icon = 'icons/obj/gun.dmi'
	icon_state = "revolver"
	item_to_spawn()
		return pick(prob(3);/obj/item/weapon/gun/projectile/automatic/wt550,
					prob(3);/obj/item/weapon/gun/projectile/automatic/mini_uzi,
					prob(2);/obj/item/weapon/gun/projectile/automatic/c20r,
					prob(2);/obj/item/weapon/gun/projectile/automatic/sts35,
					prob(2);/obj/item/weapon/gun/projectile/automatic/z8,
					prob(4);/obj/item/weapon/gun/projectile/colt,
					prob(2);/obj/item/weapon/gun/projectile/deagle,
					prob(1);/obj/item/weapon/gun/projectile/deagle/camo,
					prob(1);/obj/item/weapon/gun/projectile/deagle/gold,
					prob(1);/obj/item/weapon/gun/projectile/heavysniper,
					prob(4);/obj/item/weapon/gun/projectile/sec,
					prob(3);/obj/item/weapon/gun/projectile/sec/wood,
					prob(4);/obj/item/weapon/gun/projectile/pistol,
					prob(5);/obj/item/weapon/gun/projectile/pirate,
					prob(2);/obj/item/weapon/gun/projectile/revolver,
					prob(4);/obj/item/weapon/gun/projectile/revolver/deckard,
					prob(4);/obj/item/weapon/gun/projectile/revolver/detective,
					prob(2);/obj/item/weapon/gun/projectile/revolver/mateba,
					prob(4);/obj/item/weapon/gun/projectile/shotgun/doublebarrel,
					prob(3);/obj/item/weapon/gun/projectile/shotgun/doublebarrel/sawn,
					prob(3);/obj/item/weapon/gun/projectile/shotgun/pump,
					prob(2);/obj/item/weapon/gun/projectile/shotgun/pump/combat,
					prob(2);/obj/item/weapon/gun/projectile/silenced)

/obj/random/projectile/sec
	name = "Random Security Projectile Weapon"
	desc = "This is a random security weapon."
	icon = 'icons/obj/gun.dmi'
	icon_state = "revolver"
	item_to_spawn()
		return pick(prob(3);/obj/item/weapon/gun/projectile/shotgun/pump,
					prob(2);/obj/item/weapon/gun/projectile/automatic/wt550,
					prob(1);/obj/item/weapon/gun/projectile/shotgun/pump/combat)

/obj/random/handgun_more
	name = "Random Handgun"
	desc = "This is a random sidearm."
	icon = 'icons/obj/gun.dmi'
	icon_state = "secgundark"
	item_to_spawn()
		return pick(prob(4);/obj/item/weapon/gun/projectile/sec,
					prob(3);/obj/item/weapon/gun/projectile/sec/wood,
					prob(3);/obj/item/weapon/gun/projectile/colt,
					prob(2);/obj/item/weapon/gun/energy/gun,
					prob(2);/obj/item/weapon/gun/projectile/pistol,
					prob(1);/obj/item/weapon/gun/energy/retro)

/obj/random/handgun
	name = "Random Security Handgun"
	desc = "This is a random security sidearm."
	icon = 'icons/obj/gun.dmi'
	icon_state = "secgundark"
	item_to_spawn()
		return pick(prob(3);/obj/item/weapon/gun/projectile/sec,
					prob(1);/obj/item/weapon/gun/projectile/sec/wood)



/obj/random/armory
	name = "Random Armory Weapon"
	desc = "This is a random security weapon."
	icon = 'icons/obj/gun.dmi'
	icon_state = "revolver"
	item_to_spawn()
		return pick(prob(2);/obj/item/weapon/gun/projectile/pistol/carbine,
					prob(2);/obj/item/weapon/gun/projectile/automatic/nx6,
					prob(2);/obj/item/weapon/gun/projectile/shotgun/pump/combat)

/obj/random/ammo
	name = "Random Ammunition"
	desc = "This is random ammunition."
	icon = 'icons/obj/ammo.dmi'
	icon_state = "45-10"
	item_to_spawn()
		return pick(prob(6);/obj/item/storage/box/beanbags,
					prob(2);/obj/item/storage/box/shotgunammo,
					prob(4);/obj/item/storage/box/shotgunshells,
					prob(1);/obj/item/storage/box/stunshells)


/obj/random/action_figure
	name = "random action figure"
	desc = "This is a random action figure."
	icon = 'icons/obj/toy.dmi'
	icon_state = "assistant"
	item_to_spawn()
		return pick(/obj/item/toy/figure/cmo,
					/obj/item/toy/figure/assistant,
					/obj/item/toy/figure/atmos,
					/obj/item/toy/figure/bartender,
					/obj/item/toy/figure/borg,
					/obj/item/toy/figure/gardener,
					/obj/item/toy/figure/captain,
					/obj/item/toy/figure/cargotech,
					/obj/item/toy/figure/ce,
					/obj/item/toy/figure/chaplain,
					/obj/item/toy/figure/chef,
					/obj/item/toy/figure/chemist,
					/obj/item/toy/figure/clown,
					/obj/item/toy/figure/corgi,
					/obj/item/toy/figure/detective,
					/obj/item/toy/figure/dsquad,
					/obj/item/toy/figure/engineer,
					/obj/item/toy/figure/geneticist,
					/obj/item/toy/figure/hop,
					/obj/item/toy/figure/hos,
					/obj/item/toy/figure/qm,
					/obj/item/toy/figure/janitor,
					/obj/item/toy/figure/agent,
					/obj/item/toy/figure/librarian,
					/obj/item/toy/figure/md,
					/obj/item/toy/figure/mime,
					/obj/item/toy/figure/miner,
					/obj/item/toy/figure/ninja,
					/obj/item/toy/figure/wizard,
					/obj/item/toy/figure/rd,
					/obj/item/toy/figure/roboticist,
					/obj/item/toy/figure/scientist,
					/obj/item/toy/figure/syndie,
					/obj/item/toy/figure/secofficer,
					/obj/item/toy/figure/warden,
					/obj/item/toy/figure/psychologist,
					/obj/item/toy/figure/paramedic,
					/obj/item/toy/figure/ert)


/obj/random/plushie
	name = "random plushie"
	desc = "This is a random plushie."
	icon = 'icons/obj/toy.dmi'
	icon_state = "nymphplushie"
	item_to_spawn()
		return pick(
			/obj/structure/plushie/ian,
			/obj/structure/plushie/drone,
			/obj/structure/plushie/carp,
			/obj/structure/plushie/beepsky,
			/obj/item/toy/plushie/nymph,
			/obj/item/toy/plushie/mouse,
			/obj/item/toy/plushie/kitten,
			/obj/item/toy/plushie/animal,
			/obj/item/toy/plushie/lizard,
		)

/obj/random/musical_device
	name = "random musical device"
	desc = "This is a random stuff that plays music"
	icon = 'icons/obj/musician.dmi'
	icon_state = "minimoog"
	item_to_spawn()
		return pick(prob(7);/obj/structure/device/piano,
					prob(1);/obj/structure/synthesized_instrument/synthesizer,
					prob(3);/obj/machinery/media/jukebox
		)

/obj/random/trash //Mostly remains and cleanable decals. Stuff a janitor could clean up
	name = "random trash"
	desc = "This is some random trash."
	icon = 'icons/effects/effects.dmi'
	icon_state = "greenglow"
	item_to_spawn()
		return pick(/obj/effect/decal/remains/lizard,
					/obj/effect/decal/cleanable/blood/gibs/robot,
					/obj/effect/decal/cleanable/blood/oil,
					/obj/effect/decal/cleanable/blood/oil/streak,
					/obj/effect/decal/cleanable/spiderling_remains,
					/obj/effect/decal/remains/mouse,
					/obj/effect/decal/cleanable/vomit,
					/obj/effect/decal/cleanable/blood/splatter,
					/obj/effect/decal/cleanable/ash,
					/obj/effect/decal/cleanable/generic,
					/obj/effect/decal/cleanable/flour,
					/obj/effect/decal/cleanable/dirt,
					/obj/effect/decal/remains/robot)

/obj/random/obstruction //Large objects to block things off in maintenance
	name = "random obstruction"
	desc = "This is a random obstruction."
	icon = 'icons/obj/cult.dmi'
	icon_state = "cultgirder"
	item_to_spawn()
		return pick(/obj/structure/barricade,
					/obj/structure/girder,
					/obj/structure/girder/displaced,
					/obj/structure/girder/reinforced,
					/obj/structure/grille,
					/obj/structure/grille/broken,
					/obj/structure/foamedmetal,
					/obj/structure/inflatable,
					/obj/structure/inflatable/door)

/obj/random/material //Random materials for building stuff
	name = "random material"
	desc = "This is a random material."
	icon = 'icons/obj/items.dmi'
	icon_state = "sheet-metal"
	item_to_spawn()
		return pick(/obj/item/stack/material/steel{amount = 10},
					/obj/item/stack/material/glass{amount = 10},
					/obj/item/stack/material/glass/reinforced{amount = 10},
					/obj/item/stack/material/plastic{amount = 10},
					/obj/item/stack/material/wood{amount = 10},
					/obj/item/stack/material/cardboard{amount = 10},
					/obj/item/stack/rods{amount = 10},
					/obj/item/stack/material/plasteel{amount = 10})

/obj/random/toy
	name = "random toy"
	desc = "This is a random toy."
	icon = 'icons/obj/toy.dmi'
	icon_state = "ship"
	item_to_spawn()
		return pick(/obj/item/toy/bosunwhistle,
					/obj/item/toy/cultsword,
					/obj/item/toy/katana,
					/obj/item/toy/snappop,
					/obj/item/toy/sword,
					/obj/item/toy/balloon,
					/obj/item/toy/crossbow,
					/obj/item/toy/blink,
					/obj/item/toy/waterflower,
					/obj/item/toy/prize/ripley,
					/obj/item/toy/prize/fireripley,
					/obj/item/toy/prize/deathripley,
					/obj/item/toy/prize/gygax,
					/obj/item/toy/prize/durand,
					/obj/item/toy/prize/honk,
					/obj/item/toy/prize/marauder,
					/obj/item/toy/prize/seraph,
					/obj/item/toy/prize/mauler,
					/obj/item/toy/prize/odysseus,
					/obj/item/toy/prize/phazon)

/obj/random/tank
	name = "random tank"
	desc = "This is a tank."
	icon = 'icons/obj/tank.dmi'
	icon_state = "canister"
	item_to_spawn()
		return pick(prob(5);/obj/item/weapon/tank/oxygen,
					prob(4);/obj/item/weapon/tank/oxygen/yellow,
					prob(4);/obj/item/weapon/tank/oxygen/red,
					prob(3);/obj/item/weapon/tank/air,
					prob(1);/obj/item/device/suit_cooling_unit)

/obj/random/cigarettes
	name = "random cigarettes"
	desc = "This is a cigarette."
	icon = 'icons/obj/cigarettes.dmi'
	icon_state = "cigpacket"
	item_to_spawn()
		return pick(prob(5);/obj/item/storage/fancy/cigarettes,
					prob(4);/obj/item/storage/fancy/cigarettes/dromedaryco,
					prob(1);/obj/item/storage/fancy/cigar,
					prob(1);/obj/item/clothing/mask/smokable/cigarette/cigar,
					prob(1);/obj/item/clothing/mask/smokable/cigarette/cigar/cohiba,
					prob(1);/obj/item/clothing/mask/smokable/cigarette/cigar/havana)

/obj/random/maintenance //Clutter and loot for maintenance and away missions
	name = "random maintenance item"
	desc = "This is a random maintenance item."
	icon = 'icons/obj/items.dmi'
	icon_state = "gift1"
	item_to_spawn()
		return pick(prob(300);/obj/random/tech_supply,
					prob(200);/obj/random/medical,
					prob(100);/obj/random/firstaid,
					prob(10);/obj/random/contraband,
					prob(50);/obj/random/action_figure,
					prob(50);/obj/random/plushie,
					prob(200);/obj/random/material,
					prob(50);/obj/random/toy,
					prob(100);/obj/random/tank,
					prob(50);/obj/random/soap,
					prob(60);/obj/random/drinkbottle,
					prob(500);/obj/random/maintenance/clean)

/obj/random/maintenance/clean
/*Maintenance loot lists without the trash, for use inside things.
Individual items to add to the maintenance list should go here, if you add
something, make sure it's not in one of the other lists.*/
	name = "random clean maintenance item"
	desc = "This is a random clean maintenance item."
	icon = 'icons/obj/items.dmi'
	icon_state = "gift1"
	item_to_spawn()
		return pick(prob(10);/obj/random/contraband,
					prob(2);/obj/item/device/flashlight/flare,
					prob(2);/obj/item/device/flashlight/glowstick,
					prob(2);/obj/item/device/flashlight/glowstick/blue,
					prob(1);/obj/item/device/flashlight/glowstick/orange,
					prob(1);/obj/item/device/flashlight/glowstick/red,
					prob(1);/obj/item/device/flashlight/glowstick/yellow,
					prob(1);/obj/item/device/flashlight/pen,
					prob(4);/obj/item/weapon/cell,
					prob(4);/obj/item/weapon/cell/device,
					prob(3);/obj/item/weapon/cell/high,
					prob(2);/obj/item/weapon/cell/super,
					prob(5);/obj/random/cigarettes,
					prob(3);/obj/item/clothing/mask/gas,
					prob(4);/obj/item/clothing/mask/breath,
					prob(4);/obj/item/weapon/reagent_containers/food/snacks/liquidfood,
					prob(2);/obj/item/storage/secure/briefcase,
					prob(4);/obj/item/storage/briefcase,
					prob(5);/obj/item/storage/backpack,
					prob(5);/obj/item/storage/backpack/satchel/norm,
					prob(4);/obj/item/storage/backpack/satchel,
					prob(3);/obj/item/storage/backpack/dufflebag,
					prob(1);/obj/item/storage/backpack/dufflebag/syndie,
					prob(5);/obj/item/storage/box,
					prob(3);/obj/item/storage/box/donkpockets,
					prob(2);/obj/item/storage/box/sinpockets,
					prob(1);/obj/item/storage/box/cups,
					prob(3);/obj/item/storage/box/mousetraps,
					prob(3);/obj/item/storage/box/engineer,
					prob(3);/obj/item/storage/wallet,
					prob(1);/obj/item/device/paicard,
					prob(2);/obj/item/clothing/shoes/galoshes,
					prob(1);/obj/item/clothing/shoes/syndigaloshes,
					prob(4);/obj/item/clothing/shoes/black,
					prob(4);/obj/item/clothing/shoes/laceup,
					prob(4);/obj/item/clothing/shoes/black,
					prob(4);/obj/item/clothing/shoes/leather,
					prob(1);/obj/item/clothing/gloves/yellow,
					prob(3);/obj/item/clothing/gloves/botanic_leather,
					prob(5);/obj/item/clothing/gloves/white,
					prob(5);/obj/item/clothing/gloves/rainbow,
					prob(2);/obj/item/clothing/gloves/fyellow,
					prob(1);/obj/item/clothing/glasses/sunglasses,
					prob(3);/obj/item/clothing/glasses/meson,
					prob(2);/obj/item/clothing/glasses/meson/prescription,
					prob(1);/obj/item/clothing/glasses/welding,
					prob(1);/obj/item/clothing/head/bio_hood/general,
					prob(4);/obj/item/clothing/head/hardhat,
					prob(3);/obj/item/clothing/head/hardhat/red,
					prob(1);/obj/item/clothing/head/ushanka,
					prob(2);/obj/item/clothing/head/welding,
					prob(4);/obj/item/clothing/suit/storage/hazardvest,
					prob(1);/obj/item/clothing/suit/space/emergency,
					prob(3);/obj/item/clothing/suit/storage/toggle/bomber,
					prob(1);/obj/item/clothing/suit/bio_suit/general,
					prob(3);/obj/item/clothing/suit/storage/toggle/hoodie/black,
					prob(3);/obj/item/clothing/suit/storage/toggle/brown_jacket,
					prob(3);/obj/item/clothing/suit/storage/toggle/leather_jacket,
					prob(4);/obj/item/clothing/under/color/grey,
					prob(2);/obj/item/clothing/under/syndicate/tacticool,
					prob(2);/obj/item/clothing/under/pants/camo,
					prob(3);/obj/item/clothing/accessory/storage/webbing,
					prob(4);/obj/item/weapon/spacecash/c1,
					prob(3);/obj/item/weapon/spacecash/c10,
					prob(3);/obj/item/weapon/spacecash/c20,
					prob(1);/obj/item/weapon/spacecash/c50,
					prob(1);/obj/item/weapon/spacecash/c100,
					prob(3);/obj/item/weapon/camera_assembly,
					prob(4);/obj/item/weapon/caution,
					prob(3);/obj/item/weapon/caution/cone,
					prob(1);/obj/item/weapon/card/emag_broken,
					prob(2);/obj/item/device/camera,
					prob(3);/obj/item/device/pda,
					prob(3);/obj/item/device/radio/headset)

/obj/random/maintenance/security
/*Maintenance loot list. This one is for around security areas*/
	name = "random security maintenance item"
	desc = "This is a random security maintenance item."
	icon = 'icons/obj/items.dmi'
	icon_state = "gift1"
	item_to_spawn()
		return pick(prob(320);/obj/random/maintenance/clean,
					prob(2);/obj/item/device/flash,
					prob(1);/obj/item/weapon/cell/device/weapon,
					prob(1);/obj/item/clothing/mask/gas/swat,
					prob(1);/obj/item/clothing/mask/gas/syndicate,
					prob(2);/obj/item/clothing/mask/balaclava,
					prob(1);/obj/item/clothing/mask/balaclava/tactical,
					prob(3);/obj/item/storage/backpack/security,
					prob(3);/obj/item/storage/backpack/satchel/sec,
					prob(2);/obj/item/storage/backpack/messenger/sec,
					prob(2);/obj/item/storage/backpack/dufflebag/sec,
					prob(1);/obj/item/storage/backpack/dufflebag/syndie/ammo,
					prob(1);/obj/item/storage/backpack/dufflebag/syndie/med,
					prob(2);/obj/item/storage/box/swabs,
					prob(2);/obj/item/storage/belt/security,
					prob(1);/obj/item/weapon/grenade/flashbang,
					prob(1);/obj/item/weapon/melee/baton,
					prob(1);/obj/item/weapon/reagent_containers/spray/pepper,
					prob(1);/obj/item/clothing/glasses/sunglasses/big,
					prob(2);/obj/item/clothing/glasses/hud/security,
					prob(1);/obj/item/clothing/glasses/sunglasses/sechud,
					prob(1);/obj/item/clothing/glasses/sunglasses/sechud/tactical,
					prob(3);/obj/item/clothing/head/beret/sec,
					prob(2);/obj/item/clothing/head/helmet,
					prob(4);/obj/item/clothing/head/soft/sec,
					prob(4);/obj/item/clothing/head/soft/sec/corp,
					prob(3);/obj/item/clothing/suit/armor/vest,
					prob(2);/obj/item/clothing/suit/armor/vest/security,
					prob(2);/obj/item/clothing/suit/storage/vest/officer,
					prob(1);/obj/item/clothing/suit/storage/vest/detective,
					prob(2);/obj/item/clothing/ears/earmuffs,
					prob(2);/obj/item/weapon/handcuffs,)

/obj/random/maintenance/medical
/*Maintenance loot list. This one is for around medical areas*/
	name = "random medical maintenance item"
	desc = "This is a random medical maintenance item."
	icon = 'icons/obj/items.dmi'
	icon_state = "gift1"
	item_to_spawn()
		return pick(prob(320);/obj/random/maintenance/clean,
					prob(25);/obj/random/medical/lite,
					prob(2);/obj/item/clothing/mask/breath/medical,
					prob(2);/obj/item/clothing/mask/surgical,
					prob(5);/obj/item/storage/backpack/medic,
					prob(5);/obj/item/storage/backpack/satchel/med,
					prob(5);/obj/item/storage/backpack/messenger/med,
					prob(3);/obj/item/storage/backpack/dufflebag/med,
					prob(1);/obj/item/storage/backpack/dufflebag/syndie/med,
					prob(2);/obj/item/storage/box/autoinjectors,
					prob(3);/obj/item/storage/box/beakers,
					prob(2);/obj/item/storage/box/bodybags,
					prob(3);/obj/item/storage/box/syringes,
					prob(3);/obj/item/storage/box/gloves,
					prob(2);/obj/item/storage/belt/medical/emt,
					prob(2);/obj/item/storage/belt/medical,
					prob(3);/obj/item/clothing/shoes/white,
					prob(5);/obj/item/clothing/gloves/white,
					prob(2);/obj/item/clothing/glasses/hud/health,
					prob(1);/obj/item/clothing/glasses/hud/health/prescription,
					prob(1);/obj/item/clothing/head/bio_hood/virology,
					prob(4);/obj/item/clothing/suit/storage/toggle/labcoat,
					prob(1);/obj/item/clothing/suit/bio_suit/general,
					prob(2);/obj/item/clothing/accessory/storage/black_vest,
					prob(2);/obj/item/clothing/accessory/storage/white_vest,
					prob(2);/obj/item/clothing/accessory/stethoscope)

/obj/random/maintenance/engineering
/*Maintenance loot list. This one is for around medical areas*/
	name = "random engineering maintenance item"
	desc = "This is a random engineering maintenance item."
	icon = 'icons/obj/items.dmi'
	icon_state = "gift1"
	item_to_spawn()
		return pick(prob(320);/obj/random/maintenance/clean,
					prob(2);/obj/item/clothing/mask/balaclava,
					prob(2);/obj/item/storage/briefcase/inflatable,
					prob(5);/obj/item/storage/backpack/industrial,
					prob(5);/obj/item/storage/backpack/satchel/eng,
					prob(5);/obj/item/storage/box,
					prob(3);/obj/item/storage/box/engineer,
					prob(2);/obj/item/storage/belt/utility/full,
					prob(3);/obj/item/storage/belt/utility,
					prob(3);/obj/item/clothing/head/soft/yellow,
					prob(2);/obj/item/clothing/head/orangebandana,
					prob(2);/obj/item/clothing/head/hardhat/dblue,
					prob(2);/obj/item/clothing/head/hardhat/orange,
					prob(1);/obj/item/clothing/glasses/welding,
					prob(2);/obj/item/clothing/head/welding,
					prob(4);/obj/item/clothing/suit/storage/hazardvest,
					prob(2);/obj/item/clothing/under/overalls,
					prob(1);/obj/item/clothing/shoes/magboots,
					prob(2);/obj/item/clothing/accessory/storage/black_vest,
					prob(2);/obj/item/clothing/accessory/storage/brown_vest,
					prob(3);/obj/item/clothing/ears/earmuffs,
					prob(1);/obj/item/weapon/beartrap,
					prob(2);/obj/item/weapon/handcuffs)

/obj/random/maintenance/research
/*Maintenance loot list. This one is for around medical areas*/
	name = "random research maintenance item"
	desc = "This is a random research maintenance item."
	icon = 'icons/obj/items.dmi'
	icon_state = "gift1"
	item_to_spawn()
		return pick(prob(320);/obj/random/maintenance/clean,
					prob(3);/obj/item/device/analyzer/plant_analyzer,
					prob(1);/obj/item/device/flash/synthetic,
					prob(1);/obj/item/weapon/cell/device/weapon,
					prob(5);/obj/item/storage/backpack/toxins,
					prob(5);/obj/item/storage/backpack/satchel/tox,
					prob(5);/obj/item/storage/backpack/messenger/tox,
					prob(1);/obj/item/storage/backpack/holding,
					prob(3);/obj/item/storage/box/beakers,
					prob(3);/obj/item/storage/box/syringes,
					prob(3);/obj/item/storage/box/gloves,
					prob(4);/obj/item/clothing/glasses/science,
					prob(3);/obj/item/clothing/glasses/material,
					prob(1);/obj/item/clothing/head/bio_hood/scientist,
					prob(4);/obj/item/clothing/suit/storage/toggle/labcoat,
					prob(4);/obj/item/clothing/suit/storage/toggle/labcoat/science,
					prob(1);/obj/item/clothing/suit/bio_suit/scientist,
					prob(4);/obj/item/clothing/under/rank/scientist,
					prob(2);/obj/item/clothing/under/rank/scientist_new)

/obj/random/maintenance/cargo
/*Maintenance loot list. This one is for around cargo areas*/
	name = "random cargo maintenance item"
	desc = "This is a random cargo maintenance item."
	icon = 'icons/obj/items.dmi'
	icon_state = "gift1"
	item_to_spawn()
		return pick(prob(320);/obj/random/maintenance/clean,
					prob(3);/obj/item/device/flashlight/lantern,
					prob(4);/obj/item/weapon/pickaxe,
					prob(5);/obj/item/storage/backpack/industrial,
					prob(5);/obj/item/storage/backpack/satchel/norm,
					prob(3);/obj/item/storage/backpack/dufflebag,
					prob(1);/obj/item/storage/backpack/dufflebag/syndie/ammo,
					prob(1);/obj/item/storage/toolbox/syndicate,
					prob(1);/obj/item/storage/belt/utility/full,
					prob(2);/obj/item/storage/belt/utility,
					prob(4);/obj/item/device/toner,
					prob(1);/obj/item/device/destTagger,
					prob(3);/obj/item/clothing/glasses/material,
					prob(3);/obj/item/clothing/head/soft/yellow,
					prob(4);/obj/item/clothing/suit/storage/hazardvest,
					prob(2);/obj/item/clothing/under/syndicate/tacticool,
					prob(1);/obj/item/clothing/under/syndicate/combat,
					prob(2);/obj/item/clothing/accessory/storage/black_vest,
					prob(2);/obj/item/clothing/accessory/storage/brown_vest,
					prob(3);/obj/item/clothing/ears/earmuffs,
					prob(1);/obj/item/weapon/beartrap,
					prob(2);/obj/item/weapon/handcuffs,)

/obj/random/rigsuit
	name = "Random rigsuit"
	desc = "This is a random rigsuit."
	icon = 'icons/obj/rig_modules.dmi'
	icon_state = "generic"
	item_to_spawn()
		return pick(prob(4);/obj/item/weapon/rig/light/hacker,
					prob(5);/obj/item/weapon/rig/industrial,
					prob(5);/obj/item/weapon/rig/eva,
					prob(4);/obj/item/weapon/rig/light/stealth,
					prob(3);/obj/item/weapon/rig/hazard,
					prob(1);/obj/item/weapon/rig/merc/empty)

/*
/obj/random/glowstick
	name = "random glowstick."
	desc = "A glowstick of random color"
	icon = 'icons/obj/glowsticks.dmi'
	icon_state = "glowstick"
	item_to_spawn()
		return pick(/obj/item/device/flashlight/glowstick,
					/obj/item/device/flashlight/glowstick/red,
					/obj/item/device/flashlight/glowstick/orange,
					/obj/item/device/flashlight/glowstick/yellow,
					/obj/item/device/flashlight/glowstick/blue
		)
		*/