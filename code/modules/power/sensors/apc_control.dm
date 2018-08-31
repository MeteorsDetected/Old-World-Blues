/obj/machinery/computer/apc_control
	name = "APC Remote Control Console"
	desc = "Computer designed to remotely control apcs."
	icon = 'icons/obj/computer.dmi'
	screen_icon = "power"
	light_color = "#ffcc33"
	var/datum/powernet/Powernet
	var/list/apcs_list = list()


/obj/machinery/computer/apc_control/New()
	..()
	connectToPowernet()


/obj/machinery/computer/apc_control/attack_hand(mob/living/user)
	..()
	if(stat & (BROKEN|MAINT|NOPOWER))
		return
	user.set_machine(src)
	var/t = "<body bgcolor='#bbbbbb'><br>"
	if(Powernet)
		for(var/obj/machinery/power/terminal/T in Powernet.nodes)
			if(istype(T.master, /obj/machinery/power/apc))
				var/obj/machinery/power/apc/APC = T.master
				apcs_list.Add(APC)
	if(!apcs_list || !apcs_list.len)
		t += "No connection<br>"
		t += "<A href='?src=\ref[src];action=reconnect'>Reconnect</A>"
	else
		if(apcs_list.len > 0)
			for(var/obj/machinery/power/apc/A in apcs_list)
				t += "[A.area.name] APC:<br>"
				t += "Charge: [A.cell ? A.cell.charge : "NO CELL"]<br>"
				t += "<A href='?src=\ref[src];apc=\ref[A];action=access'>Access [A.locked ? "denied" : "granted"]</A> |"
				t += "<A href='?src=\ref[src];apc=\ref[A];action=cover'>Cover [A.coverlocked ? "closed" : "opened"]</A> |"
				t += "<A href='?src=\ref[src];apc=\ref[A];action=power'>Power [A.shorted ? "cutted" : "connected"]</A><br>"
	t += "</body>"
	user << browse(t, "window=apc_remote;size=400x450")
	onclose(user, "apc_remote")

/obj/machinery/computer/apc_control/Topic(var/href, var/list/href_list)
	if(stat & (BROKEN|MAINT|NOPOWER))
		return
	var/obj/machinery/power/apc/APC = locate(href_list["apc"]) in apcs_list

	switch(href_list["action"])

		if("access")
			APC.locked = !APC.locked
			APC.visible_message("The [APC.locked ? "red" : "green"] diod on [APC.name]'s access panel has flashed.")
		if("cover")
			APC.coverlocked = !APC.coverlocked
			APC.visible_message("The [APC.coverlocked ? "red" : "green"] diod on [APC.name]'s cover panel has flashed.")
		if("power")
			APC.shorted = !APC.shorted
			APC.visible_message("The [APC.shorted ? "red" : "green"] signal at [APC.name] has flashed.")
		if("reconnect")
			connectToPowernet()
	updateUsrDialog()


/obj/machinery/computer/apc_control/proc/connectToPowernet()
	var/obj/structure/cable/C = locate() in src.loc
	if(C)
		if(C.powernet)
			Powernet = C.powernet