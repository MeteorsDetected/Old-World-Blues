/datum/access/security
	region = ACCESS_REGION_SECURITY

var/const/access_security = 1 // Security equipment
/datum/access/security/equipment
	id = access_security
	desc = "Security Equipment"

var/const/access_brig = 2 // Brig timers and permabrig
/datum/access/security/holding
	id = access_brig
	desc = "Holding Cells"

var/const/access_armory = 3
/datum/access/security/armory
	id = access_armory
	desc = "Armory"

var/const/access_forensics_lockers = 4
/datum/access/security/forensics_lockers
	id = access_forensics_lockers
	desc = "Forensics"

var/const/access_hos = 58
/datum/access/security/hos
	id = access_hos
	desc = "Head of Security"

var/const/access_sec_doors = 63 // Security front doors
/datum/access/security/sec_doors
	id = access_sec_doors
	desc = "Security"

var/const/access_court = 42
/datum/access/security/courtroom
	id = access_court
	desc = "Courtroom"
