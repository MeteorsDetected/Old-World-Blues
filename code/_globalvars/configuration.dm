GLOBAL_REAL(config, /datum/controller/configuration)

var/host = null
var/station_name   = "NSS Exodus"
var/game_version   = "Old World Blues"
var/changelog_hash = ""

var/join_motd = null

var/custom_event_msg = null

var/shuttle_frozen = 0
var/shuttle_left   = 0
var/shuttlecoming  = 0

// Debug is used exactly once (in living.dm) but is commented out in a lot of places.  It is not set anywhere and only checked.
// Debug2 is used in conjunction with a lot of admin verbs and therefore is actually legit.
var/Debug  = FALSE // Global debug switch.
var/Debug2 = FALSE

var/eventchance = 10 // Percent chance per 5 minutes.

// Bomb cap!
var/max_explosion_range = 14


