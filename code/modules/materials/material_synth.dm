// These objects are used by cyborgs to get around a lot of the limitations on stacks
// and the weird bugs that crop up when expecting borg module code to behave sanely.
/obj/item/stack/material/cyborg
	uses_charge = 1
	charge_costs = list(1000)
	gender = NEUTER
	matter = null // Don't shove it in the autholathe.

/obj/item/stack/material/cyborg/initialize()
	. = ..()
	name = "[material.display_name] synthesiser"
	desc = "A device that synthesises [material.display_name]."
	matter = null

/obj/item/stack/material/cyborg/plastic
	icon_state = "sheet-plastic"
	material = MATERIAL_PLASTIC

/obj/item/stack/material/cyborg/steel
	icon_state = "sheet-metal"
	material = "steel"

/obj/item/stack/material/cyborg/plasteel
	icon_state = "sheet-plasteel"
	material = MATERIAL_PLASTEEL

/obj/item/stack/material/cyborg/wood
	icon_state = "sheet-wood"
	material = MATERIAL_WOOD

/obj/item/stack/material/cyborg/glass
	icon_state = "sheet-glass"
	material = MATERIAL_GLASS

/obj/item/stack/material/cyborg/glass/reinforced
	icon_state = "sheet-rglass"
	material = MATERIAL_RGLASS
	charge_costs = list(500, 1000)