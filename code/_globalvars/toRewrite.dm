// Items that ask to be called every cycle.
var/global/list/all_areas                = list()
var/global/list/machines                 = list()
var/global/list/processing_objects       = list()
var/global/list/processing_power_items   = list()

var/datum/nanomanager/nanomanager		= new() // NanoManager, the manager for Nano UIs.
var/datum/event_manager/event_manager	= new() // Event Manager, the manager for events.
var/datum/subsystem/alarm/alarm_manager	= new() // Alarm Manager, the manager for alarms.


var/list/station_departments = list("Command", "Medical", "Engineering", "Science", "Security", "Cargo", "Civilian")

var/global/const/TICKS_IN_DAY = 864000
var/global/const/TICKS_IN_SECOND = 10

// Some scary sounds.
var/static/list/scarySounds = list(
	'sound/weapons/thudswoosh.ogg',
	'sound/weapons/Taser.ogg',
	'sound/weapons/armbomb.ogg',
	'sound/voice/hiss1.ogg',
	'sound/voice/hiss2.ogg',
	'sound/voice/hiss3.ogg',
	'sound/voice/hiss4.ogg',
	'sound/voice/hiss5.ogg',
	'sound/voice/hiss6.ogg',
	'sound/effects/Glassbr1.ogg',
	'sound/effects/Glassbr2.ogg',
	'sound/effects/Glassbr3.ogg',
	'sound/items/Welder.ogg',
	'sound/items/Welder2.ogg',
	'sound/machines/airlock.ogg',
	'sound/effects/clownstep1.ogg',
	'sound/effects/clownstep2.ogg'
)

// Announcer intercom, because too much stuff creates an intercom for one message then hard del()s it.
var/global/obj/item/device/radio/intercom/global_announcer = new(null)

