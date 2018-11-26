/******************
* Central Command *
******************/
/proc/get_all_centcom_jobs()
	return list("VIP Guest",
		"Custodian",
		"Thunderdome Overseer",
		"Intel Officer",
		"Medical Officer",
		"Death Commando",
		"Research Officer",
		"BlackOps Commander",
		"Supreme Commander",
		"Emergency Response Team",
		"Emergency Response Team Leader")

/proc/get_centcom_access(job)
	switch(job)
		if("VIP Guest")
			return list(access_cent_general)
		if("Custodian")
			return list(access_cent_general, access_cent_living, access_cent_storage)
		if("Thunderdome Overseer")
			return list(access_cent_general, access_cent_thunder)
		if("Intel Officer")
			return list(access_cent_general, access_cent_living)
		if("Medical Officer")
			return list(access_cent_general, access_cent_living, access_cent_medical)
		if("Death Commando")
			return list(access_cent_general, access_cent_specops, access_cent_living, access_cent_storage)
		if("Research Officer")
			return list(access_cent_general, access_cent_specops, access_cent_medical, access_cent_teleporter, access_cent_storage)
		if("BlackOps Commander")
			return list(access_cent_general, access_cent_thunder, access_cent_specops, access_cent_living, access_cent_storage, access_cent_creed)
		if("Supreme Commander")
			return get_all_centcom_access()



/datum/access/centcomm
	access_type = ACCESS_TYPE_CENTCOM

var/const/access_cent_general = 101
/datum/access/centcomm/cent_general
	id = access_cent_general
	desc = "General facilities"

var/const/access_cent_thunder = 102
/datum/access/centcomm/cent_thunder
	id = access_cent_thunder
	desc = "Thunderdome"

var/const/access_cent_specops = 103
/datum/access/centcomm/cent_specops
	id = access_cent_specops
	desc = "Special Ops"

var/const/access_cent_medical = 104
/datum/access/centcomm/cent_medical
	id = access_cent_medical
	desc = "Medical facilities"

var/const/access_cent_living = 105
/datum/access/centcomm/cent_living
	id = access_cent_living
	desc = "Living quarters"

//Generic storage areas.
var/const/access_cent_storage = 106
/datum/access/centcomm/cent_storage
	id = access_cent_storage
	desc = "Storage"

var/const/access_cent_teleporter = 107
/datum/access/centcomm/cent_teleporter
	id = access_cent_teleporter
	desc = "Teleporter"

var/const/access_cent_creed = 108
/datum/access/centcomm/cent_creed
	id = access_cent_creed
	desc = "Creed's office"

//Captain's office/ID comp/AI.
var/const/access_cent_captain = 109
/datum/access/centcomm/cent_captain
	id = access_cent_captain
	desc = "Code Gold"


