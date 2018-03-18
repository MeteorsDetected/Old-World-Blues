/datum/slot
	var/mob/living/owner
	var/obj/item/captured_item
	var/max_w_class = 0
	var/reqed_slot_flags = null
	var/slot_name = ""
	var/slot_id = 0
/*
slot_handcuffed
slot_in_backpack
slot_legcuffed
slot_tie
slot_socks
slot_underwear
slot_undershirt
slot_legs
*/
/datum/slot/l_hand
	slot_id = slot_l_hand

/datum/slot/r_hand
	slot_id = slot_r_hand

/datum/slot/backpack
	slot_id = slot_back

/datum/slot/head
	slot_id = slot_head

/datum/slot/mask
	slot_id = slot_wear_mask

/datum/slot/uniform
	slot_id = slot_w_uniform

/datum/slot/suit
	slot_id = slot_wear_suit

/datum/slot/gloves
	slot_id = slot_gloves

/datum/slot/shoes
	slot_id = slot_shoes

/datum/slot/glasses
	slot_id = slot_glasses

/datum/slot/belt
	slot_id = slot_belt

/datum/slot/id
	slot_id = slot_wear_id

/datum/slot/l_ear
	slot_id = slot_l_ear

/datum/slot/r_ear
	slot_id = slot_r_ear

/datum/slot/l_pocket
	slot_id = slot_l_store

/datum/slot/r_pocket
	slot_id = slot_r_store

/datum/slot/shoulders

/datum/slot/suit_storage
	slot_id = slot_s_store


