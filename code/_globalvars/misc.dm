var/global/datum/datacore/data_core      = null

// It's a conversion constant. power_used*CELLRATE = charge_provided, or charge_used/CELLRATE = power_provided
var/CELLRATE = 0.002 // Multiplier for watts per tick <> cell storage (e.g., 0.02 means if there is a load of 1000 watts, 20 units will be taken from a cell per second)
var/CHARGELEVEL = 0.0005 // Cap for how fast cells charge, as a percentage-per-tick (0.01 means cellcharge is capped to 1% per second)

var/list/powernets = list()
