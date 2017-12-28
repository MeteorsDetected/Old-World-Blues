
/obj/machinery/computer/station_alert
	name = "Station Alert Console"
	desc = "Used to access the station's automated alert system."
	screen_icon = "alert:0"
	light_color = "#e6ffff"
	circuit = /obj/item/weapon/circuitboard/stationalert_engineering
	var/obj/nano_module/alarm_monitor/alarm_monitor
	var/monitor_type = /obj/nano_module/alarm_monitor/engineering

/obj/machinery/computer/station_alert/security
	monitor_type = /obj/nano_module/alarm_monitor/security
	circuit = /obj/item/weapon/circuitboard/stationalert_security

/obj/machinery/computer/station_alert/all
	monitor_type = /obj/nano_module/alarm_monitor/all
	circuit = /obj/item/weapon/circuitboard/stationalert_all

/obj/machinery/computer/station_alert/New()
	..()
	alarm_monitor = new monitor_type(src)
	alarm_monitor.register(src, /obj/machinery/computer/station_alert/update_icon)

/obj/machinery/computer/station_alert/Destroy()
	alarm_monitor.unregister(src)
	qdel(alarm_monitor)
	..()

/obj/machinery/computer/station_alert/attack_ai(mob/user)
	add_fingerprint(user)
	if(stat & (BROKEN|NOPOWER))
		return
	interact(user)
	return

/obj/machinery/computer/station_alert/attack_hand(mob/user)
	add_fingerprint(user)
	if(stat & (BROKEN|NOPOWER))
		return
	interact(user)
	return

/obj/machinery/computer/station_alert/interact(mob/user)
	alarm_monitor.ui_interact(user)

/obj/machinery/computer/station_alert/update_icon()
	if( !(stat & (BROKEN|NOPOWER)) )
		var/list/alarms = alarm_monitor.major_alarms()
		if(alarms.len)
			screen_icon = "alert:2"
		else
			screen_icon = initial(screen_icon)
	..()
