/obj/structure/table

	standard
		icon_state = "plain_preview"
		color = "#EEEEEE"
		material = DEFAULT_TABLE_MATERIAL

	steel
		icon_state = "plain_preview"
		color = "#666666"
		material = MATERIAL_STEEL

	marble
		icon_state = "stone_preview"
		color = "#CCCCCC"
		material = MATERIAL_MARBLE

	reinforced
		icon_state = "reinf_preview"
		color = "#EEEEEE"
		material = DEFAULT_TABLE_MATERIAL
		reinforced = DEFAULT_WALL_MATERIAL

	steel_reinforced
		icon_state = "reinf_preview"
		color = "#666666"
		material = MATERIAL_STEEL
		reinforced = MATERIAL_STEEL

	wooden_reinforced
		icon_state = "reinf_wood_preview"
		color = "#CF570D"
		material = MATERIAL_WOOD
		reinforced = MATERIAL_WOOD

	woodentable
		icon_state = "plain_preview"
		color = "#824B28"
		material = MATERIAL_WOOD

	gamblingtable
		icon_state = "gamble_preview"
		initialize()
		material = MATERIAL_WOOD
		carpeted = 1

	glass
		icon_state = "plain_preview"
		color = "#00E1FF"
		alpha = 77 // 0.3 * 255
		material = MATERIAL_GLASS

	holotable
		icon_state = "holo_preview"
		color = "#EEEEEE"
		initialize()
			if(!material)
				material = "holo[MATERIAL_STEEL]"
			. = ..()

	holotable/wood
		color = "#824B28"
		material = "holowood"
