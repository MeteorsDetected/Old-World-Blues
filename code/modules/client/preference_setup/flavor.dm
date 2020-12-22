/datum/preferences
	var/list/flavor_texts = list()
	var/list/flavor_texts_robot = list()


/datum/preferences/proc/GetFlavorPage()
	var/list/dat = new
	dat += "<tt><center><b>Set Flavour Text</b> <hr /></center>"
	for(var/flavor in flavs_list)
		dat += "<a href='?src=\ref[src];flavor=[flavor]'>[flavs_list[flavor]]:</a> "
		dat += TextPreview(flavor_texts[flavor],58)
		dat += "<br>"
	dat += "<br><hr />"

	dat += "<center><b>Set Robot Flavour Text</b> <hr /></center>"
	dat += "<a href ='?src=\ref[src];preference=flavour_text_robot;task=Default'>Default:</a> "
	dat += TextPreview(flavor_texts_robot["Default"])
	dat += "<br>"
	for(var/module in robot_modules)
		dat += "<a href='?src=\ref[src];robot_flavor=[module]'>[module]:</a> "
		dat += TextPreview(flavor_texts_robot[module],50)
		dat += "<br>"
	dat += "</tt>"
	return dat.Join(null)


/datum/preferences/proc/HandleFlavorTopic(mob/user, list/href_list)
	if(href_list["flavor"])
		var/task = href_list["flavor"]
		var/flav = flavor_texts[task]
		var/msg = ""

		switch(task)
			if("general")
				var/description = {"
					Give a general description of your character. \
					This will be shown regardless of clothing, and may include OOC notes and preferences.
				"}
				msg = input(usr, description,"Flavor Text", flav) as message
			else
				msg = input(usr,"Set the flavor text for your [task].","Flavor Text",flav) as message

		flavor_texts[task] = html_encode(msg)

	else if(href_list["robot_flavor"])
		var/task = href_list["robot_flavor"]
		var/flav = flavor_texts_robot[task]
		var/msg = ""

		msg = input(usr,"Set the flavor text for your [task].","Flavor Text",flav) as message

		flavor_texts_robot[task] = html_encode(msg)