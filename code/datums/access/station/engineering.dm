/datum/access/engine
	region = ACCESS_REGION_ENGINEERING

//engineering hallways
var/const/access_engine = 10
/datum/access/engine/main
	id = access_engine
	desc = "Engineering"

var/const/access_engine_equip = 11
/datum/access/engine/equip
	id = access_engine_equip
	desc = "Engine Room"

var/const/access_maint_tunnels = 12
/datum/access/engine/maint_tunnels
	id = access_maint_tunnels
	desc = "Maintenance"

var/const/access_external_airlocks = 13
/datum/access/engine/external_airlocks
	id = access_external_airlocks
	desc = "External Airlocks"

var/const/access_emergency_storage = 14
/datum/access/engine/emergency_storage
	id = access_emergency_storage
	desc = "Emergency Storage"

var/const/access_tech_storage = 23
/datum/access/engine/tech_storage
	id = access_tech_storage
	desc = "Technical Storage"

var/const/access_atmospherics = 24
/datum/access/engine/atmospherics
	id = access_atmospherics
	desc = "Atmospherics"

var/const/access_construction = 32
/datum/access/engine/construction
	id = access_construction
	desc = "Construction Areas"

var/const/access_ce = 56
/datum/access/engine/ce
	id = access_ce
	desc = "Chief Engineer"

