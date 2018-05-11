/* First aid storage
 * Contains:
 *		First Aid Kits
 * 		Pill Bottles
 */

/*
 * First Aid Kits
 */
/obj/item/storage/firstaid
	name = "first-aid kit"
	desc = "It's an emergency medical kit for those serious boo-boos."
	icon_state = "firstaid"
	throw_speed = 2
	throw_range = 8
	storage_slots = 0
	max_w_class = ITEM_SIZE_SMALL
	max_storage_space = DEFAULT_BOX_STORAGE


/obj/item/storage/firstaid/fire
	name = "fire first-aid kit"
	desc = "It's an emergency medical kit for when the toxins lab <i>-spontaneously-</i> burns down."
	icon_state = "ointment"
	item_state = "firstaid-ointment"
	preloaded = list(
		/obj/item/device/healthanalyzer,
		/obj/item/weapon/reagent_containers/hypospray/autoinjector,
		/obj/item/stack/medical/ointment = 2,
		/obj/item/weapon/reagent_containers/pill/kelotane = 3
	)

/obj/item/storage/firstaid/fire/initialize()
	. = ..()
	icon_state = pick("ointment", "firefirstaid")


/obj/item/storage/firstaid/regular
	icon_state = "firstaid"
	preloaded = list(
		/obj/item/stack/medical/bruise_pack = 3,
		/obj/item/stack/medical/ointment = 2,
		/obj/item/device/healthanalyzer,
		/obj/item/weapon/reagent_containers/hypospray/autoinjector,
	)


/obj/item/storage/firstaid/toxin
	name = "toxin first aid"
	desc = "Used to treat when you have a high amoutn of toxins in your body."
	icon_state = "antitoxin"
	item_state = "firstaid-toxin"
	preloaded = list(
		/obj/item/weapon/reagent_containers/syringe/antitoxin = 3,
		/obj/item/weapon/reagent_containers/pill/antitox = 3,
		/obj/item/device/healthanalyzer,
	)

/obj/item/storage/firstaid/toxin/initialize()
	. = ..()
	icon_state = pick("antitoxin","antitoxfirstaid","antitoxfirstaid2","antitoxfirstaid3")


/obj/item/storage/firstaid/o2
	name = "oxygen deprivation first aid"
	desc = "A box full of oxygen goodies."
	icon_state = "o2"
	item_state = "firstaid-o2"
	preloaded = list(
		/obj/item/weapon/reagent_containers/pill/dexalin = 4,
		/obj/item/weapon/reagent_containers/hypospray/autoinjector,
		/obj/item/weapon/reagent_containers/syringe/inaprovaline,
		/obj/item/device/healthanalyzer
	)


/obj/item/storage/firstaid/adv
	name = "advanced first-aid kit"
	desc = "Contains advanced medical treatments."
	icon_state = "advfirstaid"
	item_state = "firstaid-advanced"
	preloaded = list(
		/obj/item/weapon/reagent_containers/hypospray/autoinjector,
		/obj/item/stack/medical/bruise_pack/advanced = 3,
		/obj/item/stack/medical/ointment/advanced = 2,
		/obj/item/stack/medical/splint
	)


/obj/item/storage/firstaid/combat
	name = "combat medical kit"
	desc = "Contains advanced medical treatments."
	icon_state = "bezerk"
	item_state = "firstaid-advanced"
	preloaded = list(
		/obj/item/storage/pill_bottle/bicaridine,
		/obj/item/storage/pill_bottle/dermaline,
		/obj/item/storage/pill_bottle/dexalin_plus,
		/obj/item/storage/pill_bottle/dylovene,
		/obj/item/storage/pill_bottle/tramadol,
		/obj/item/storage/pill_bottle/spaceacillin,
		/obj/item/stack/medical/splint
	)


/obj/item/storage/firstaid/surgery
	name = "surgery kit"
	desc = "Contains tools for surgery."
	max_storage_space = 21
	max_w_class = ITEM_SIZE_NORMAL
	preloaded = list(
		/obj/item/weapon/bonesetter,
		/obj/item/weapon/cautery,
		/obj/item/weapon/circular_saw,
		/obj/item/weapon/hemostat,
		/obj/item/weapon/retractor,
		/obj/item/weapon/scalpel,
		/obj/item/weapon/surgicaldrill,
		/obj/item/weapon/bonegel,
		/obj/item/weapon/FixOVein,
		/obj/item/stack/medical/bruise_pack/advanced,
	)


/*
 * Pill Bottles
 */
/obj/item/storage/pill_bottle
	name = "pill bottle"
	desc = "It's an airtight container for storing medication."
	icon_state = "pill_canister"
	icon = 'icons/obj/chemical.dmi'
	item_state = "contsolid"
	w_class = ITEM_SIZE_SMALL
	max_w_class = ITEM_SIZE_TINY
	max_storage_space = 14
	storage_slots = 14
	can_hold = list(
		/obj/item/weapon/reagent_containers/pill,
		/obj/item/weapon/dice,
		/obj/item/weapon/paper
	)
	allow_quick_gather = TRUE
	use_to_pickup = TRUE
	use_sound = null

/obj/item/storage/pill_bottle/antitox
	name = "bottle of Dylovene pills"
	desc = "Contains pills used to counter toxins."
	preloaded = list(
		/obj/item/weapon/reagent_containers/pill/antitox = 7
	)

/obj/item/storage/pill_bottle/bicaridine
	name = "bottle of Bicaridine pills"
	desc = "Contains pills used to stabilize the severely injured."
	preloaded = list(
		/obj/item/weapon/reagent_containers/pill/bicaridine = 7,
	)

/obj/item/storage/pill_bottle/dexalin_plus
	name = "bottle of Dexalin Plus pills"
	desc = "Contains pills used to treat extreme cases of oxygen deprivation."
	preloaded = list(
		/obj/item/weapon/reagent_containers/pill/dexalin_plus = 7
	)

/obj/item/storage/pill_bottle/dermaline
	name = "bottle of Dermaline pills"
	desc = "Contains pills used to treat burn wounds."
	preloaded = list(
		/obj/item/weapon/reagent_containers/pill/dermaline = 7,
	)

/obj/item/storage/pill_bottle/dylovene
	name = "bottle of Dylovene pills"
	desc = "Contains pills used to treat toxic substances in the blood."
	preloaded = list(
		/obj/item/weapon/reagent_containers/pill/dylovene = 7
	)

/obj/item/storage/pill_bottle/inaprovaline
	name = "bottle of Inaprovaline pills"
	desc = "Contains pills used to stabilize patients."
	preloaded = list(
		/obj/item/weapon/reagent_containers/pill/inaprovaline = 7
	)

/obj/item/storage/pill_bottle/kelotane
	name = "bottle of kelotane pills"
	desc = "Contains pills used to treat burns."
	preloaded = list(
		/obj/item/weapon/reagent_containers/pill/kelotane = 7
	)

/obj/item/storage/pill_bottle/spaceacillin
	name = "bottle of Spaceacillin pills"
	desc = "A theta-lactam antibiotic. Effective against many diseases likely to be encountered in space."
	preloaded = list(
		/obj/item/weapon/reagent_containers/pill/spaceacillin = 7
	)

/obj/item/storage/pill_bottle/tramadol
	name = "bottle of Tramadol pills"
	desc = "Contains pills used to relieve pain."
	preloaded = list(
		/obj/item/weapon/reagent_containers/pill/tramadol = 7
	)

/obj/item/storage/pill_bottle/citalopram
	name = "bottle of Citalopram pills"
	desc = "Contains pills used to stabilize a patient's mood."
	preloaded = list(
		/obj/item/weapon/reagent_containers/pill/citalopram = 7
	)
