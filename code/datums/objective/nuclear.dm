/datum/objective/nuclear
	explanation_text = "Destroy the station with a nuclear device."

/datum/objective/nuclear/check_completion()
	return ticker.mode.station_was_nuked


