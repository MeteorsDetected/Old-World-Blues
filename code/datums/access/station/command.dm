/datum/access/command
	region = ACCESS_REGION_COMMAND

var/const/access_change_ids = 15
/datum/access/command/change_ids
	id = access_change_ids
	desc = "ID Computer"

var/const/access_ai_upload = 16
/datum/access/command/ai_upload
	id = access_ai_upload
	desc = "AI Upload"

var/const/access_teleporter = 17
/datum/access/command/teleporter
	id = access_teleporter
	desc = "Teleporter"

var/const/access_eva = 18
/datum/access/command/eva
	id = access_eva
	desc = "EVA"

var/const/access_heads = 19
/datum/access/command/bridge
	id = access_heads
	desc = "Bridge"

var/const/access_captain = 20
/datum/access/command/command/captain
	id = access_captain
	desc = "Captain"

var/const/access_all_personal_lockers = 21
/datum/access/command/all_personal_lockers
	id = access_all_personal_lockers
	desc = "Personal Lockers"

var/const/access_lawyer = 38
/datum/access/command/lawyer
	id = access_lawyer
	desc = "Internal Affairs"

var/const/access_heads_vault = 53
/datum/access/command/heads_vault
	id = access_heads_vault
	desc = "Main Vault"

var/const/access_hop = 57
/datum/access/command/hop
	id = access_hop
	desc = "Head of Personnel"

//Request console announcements
var/const/access_RC_announce = 59
/datum/access/command/RC_announce
	id = access_RC_announce
	desc = "RC Announcements"

//Used for events which require at least two people to confirm them
var/const/access_keycard_auth = 60
/datum/access/command/keycard_auth
	id = access_keycard_auth
	desc = "Keycode Auth. Device"

// has access to the entire telecomms satellite / machinery
var/const/access_tcomsat = 61
/datum/access/command/tcomsat
	id = access_tcomsat
	desc = "Telecommunications"

var/const/access_gateway = 62
/datum/access/command/gateway
	id = access_gateway
	desc = "Gateway"

