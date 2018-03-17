/obj/structure/sign/double/barsign
	icon = 'icons/obj/barsigns.dmi'
	icon_state = "empty"
	anchored = 1
	var/cult = 0
	var/list/possibleIcons = list(
		"On" = "on", "Off" = "off", "Pink Flamingo" = "pinkflamingo", "Magma Sea" = "magmasea", "Limbo" = "limbo",
		"Rusty Axe" = "rustyaxe", "Armok Bar" = "armokbar", "Broken Drum" = "brokendrum", "Mead Bay" = "meadbay",
		"The Damn Wall" = "thedamnwall", "The Cavern" = "thecavern", "Cindi Kate" = "cindikate",
		"The Orchard" = "theorchard", "The Saucy Clown" = "thesaucyclown", "The Clowns Head" = "theclownshead",
		"Whiskey Implant" = "whiskeyimplant", "Carpe Carp" = "carpecarp", "Robust Roadhouse" = "robustroadhouse",
		"Greytide" = "greytide", "The Redshirt" = "theredshirt", "The Bark" = "thebark",
		"The Harm Baton" = "theharmbaton", "The Harmed Baton" = "theharmedbaton", "The Singulo" = "thesingulo",
		"The Druk Carp" = "thedrukcarp", "The Drunk Carp" = "thedrunkcarp", "Scotch" = "scotch",
		"Officer Beersky" = "officerbeersky"
	)

/obj/structure/sign/double/barsign/initialize()
	. = ..()
	ChangeSign(possibleIcons[pick(possibleIcons)])

/obj/structure/sign/double/barsign/proc/ChangeSign(var/Text)
		src.icon_state = "[Text]"
		//on = 0
		//brightness_on = 4 //uncomment these when the lighting fixes get in

/obj/structure/sign/double/barsign/attackby(obj/item/I, mob/user)
	if(cult)
		return

	if(istype(I, /obj/item/weapon/card/id))
		var/obj/item/weapon/card/id/card = I
		if(access_bar in card.GetAccess())
			var/sign_type = input(user, "What would you like to change the barsign to?") as null|anything in possibleIcons
			if(sign_type == null)
				return
			else
				src.ChangeSign(possibleIcons[sign_type])
				user << "You change the barsign."
