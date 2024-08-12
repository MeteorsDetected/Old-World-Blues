var/global/list/rkeys = list(
	"а" = "f", "в" = "d", "г" = "u", "д" = "l",
	"е" = "t", "з" = "p", "и" = "b", "й" = "q",
	"к" = "r", "л" = "k", "м" = "v", "н" = "y",
	"о" = "j", "п" = "g", "р" = "h", "с" = "c",
	"т" = "n", "у" = "e", "ф" = "a", "ц" = "w",
	"ч" = "x", "ш" = "i", "щ" = "o", "ы" = "s",
	"ь" = "m", "я" = "z"
)

//Transform keys from russian keyboard layout to eng analogues and lowertext it.
/proc/sanitize_key(t)
	t = lowertext(t)
	return (t in rkeys)?rkeys[t]:t


var/list/department_radio_keys = list(
	"r" = "right ear",
	"l" = "left ear",
	"i" = "intercom",
	"h" = "department",
	"+" = "special",	//activate radio-specific special functions
	"c" = "Command",
	"n" = "Science",
	"m" = "Medical",
	"e" = "Engineering",
	"s" = "Security",
	"w" = "whisper",
	"t" = "Mercenary",
	"u" = "Supply",
	"v" = "Service",
	"p" = "AI Private"
)


var/list/channel_to_radio_key = new
/proc/get_radio_key_from_channel(var/channel)
	var/key = channel_to_radio_key[channel]
	if(!key)
		for(var/radio_key in department_radio_keys)
			if(department_radio_keys[radio_key] == channel)
				key = radio_key
				break
		if(!key)
			key = ""
		channel_to_radio_key[channel] = key

	return key


/mob/living/proc/binarycheck()

	if(ispAI(src))
		return

	if(!ishuman(src))
		return

	var/mob/living/carbon/human/H = src
	if(H.l_ear || H.r_ear)
		var/obj/item/device/radio/headset/dongle
		if(istype(H.l_ear, /obj/item/device/radio/headset))
			dongle = H.l_ear
		else
			dongle = H.r_ear
		if(!istype(dongle))
			return FALSE
		if(dongle.translate_binary)
			return TRUE

/mob/living/proc/get_default_language()
	return default_language

/mob/living/proc/is_muzzled()
	return 0

/mob/living/proc/handle_speech_problems(var/message, var/verb)
	message = html_decode(message)
	var/list/returns[3]
	var/speech_problem_flag = 0

	if(slurring)
		message = slur(message)
		verb = pick("slobbers","slurs")
		speech_problem_flag = 1
	if(stuttering)
		message = stutter(message)
		verb = pick("stammers","stutters")
		speech_problem_flag = 1

	returns[1] = message
	returns[2] = verb
	returns[3] = speech_problem_flag
	return returns

/mob/living/proc/handle_message_mode(message_mode, message, verb, speaking, used_radios, alt_name)
	if(message_mode == "intercom")
		for(var/obj/item/device/radio/intercom/I in view(1, null))
			I.talk_into(src, message, verb, speaking)
			used_radios += I
	return 0

/mob/living/proc/handle_speech_sound()
	var/list/returns[2]
	returns[1] = null
	returns[2] = null
	return returns

/mob/living/proc/get_speech_ending(verb, var/ending)
	if(ending=="!")
		return pick("exclaims", "shouts", "yells")
	if(ending=="?")
		return "asks"
	return verb

/mob/living/say(var/message, var/datum/language/speaking = null, var/verb="says", var/alt_name="")
	if(client)
		if(client.prefs.muted&MUTE_IC)
			src << SPAN_WARN("You cannot speak in IC (Muted).")
			return

	if(stat)
		if(stat == DEAD)
			return say_dead(message)
		return

	if(is_muzzled())
		src << SPAN_DANGER("You're muzzled and cannot speak!")
		return

	var/message_mode = parse_message_mode(message, "headset")

	switch(message[1])
		if("*")
			return emote(copytext_char(message, 2))
		if("^")
			return custom_emote(MESSAGE_VISIBLE, copytext_char(message, 2))

	//parse the radio code and consume it
	if(message_mode)
		//it would be really nice if the parse procs could do this for us.
		if(message_mode == "headset")
			message = copytext_char(message, 2)
		else
			message = copytext_char(message, 3)

	message = trim_left(message)

	//Log of what we've said, plain message, no spans or junk
	say_log += message

	//parse the language code and consume it
	if(!speaking)
		speaking = parse_language(message)
	if(speaking)
		message = copytext_char(message, 2 + length(speaking.key))
	else
		speaking = get_default_language()

	if(ishuman(src))
		var/mob/living/carbon/human/H = src
		if(!(speaking == all_languages[H.species.language] || (speaking.flags&(NO_STUTTER|HIVEMIND)) || speaking == all_languages["Noise"]))
			message = H.species.handle_accent(message)

	if(speaking != all_languages["Noise"])
		message = capitalize(message)

	if (speaking)
		// This is broadcast to all mobs with the language,
		// irrespective of distance or anything else.
		if(speaking.flags & HIVEMIND)
			speaking.broadcast(src,trim(message))
			return 1
		//If we've gotten this far, keep going!
		if(speaking.flags & COMMON_VERBS)
			verb = say_quote(message)
		else
			verb = speaking.get_spoken_verb(message[length(message)])
	else
		verb = say_quote(message)

	message = trim_left(message)

	if(!(speaking && speaking.flags&NO_STUTTER))

		var/list/handle_s = handle_speech_problems(message, verb)
		message = handle_s[1]
		verb = handle_s[2]

	if(!message)
		return 0

	var/list/obj/item/used_radios = new
	if(handle_message_mode(message_mode, message, verb, speaking, used_radios, alt_name))
		return TRUE

	var/list/handle_v = handle_speech_sound()
	var/sound/speech_sound = handle_v[1]
	var/sound_vol = handle_v[2]

	var/italics = FALSE
	var/message_range = (message[length(message)]=="!") ? world.view+4 : world.view

	//speaking into radios
	if(used_radios.len)
		italics = TRUE
		message_range = 1
		if(speaking)
			message_range = speaking.get_talkinto_msg_range(message)
		var/msg
		if(!speaking || !(speaking.flags&NO_TALK_MSG))
			msg = SPAN_NOTE("\The [src] talks into \the [used_radios[1]]")
		for(var/mob/living/M in hearers(5, src))
			if((M != src) && msg)
				M.show_message(msg)
			if(speech_sound)
				sound_vol *= 0.5

	var/turf/T = get_turf(src)

	//handle nonverbal and sign languages here
	if(speaking)
		if(speaking.flags&NONVERBAL)
			if(prob(30))
				src.custom_emote(MESSAGE_VISIBLE, "[pick(speaking.signlang_verb)].")

		if(speaking.flags&SIGNLANG)
			return say_signlang(message, pick(speaking.signlang_verb), speaking)

	var/list/listening = list()
	var/list/listening_obj = list()

	if(T)
		//make sure the air can transmit speech - speaker's side
		var/datum/gas_mixture/environment = T.return_air()
		var/pressure = (environment) ? environment.return_pressure() : 0
		if(pressure < SOUND_MINIMUM_PRESSURE)
			message_range = 1

		//Air is nearing minimum levels, make text italics as a hint, and muffle sound
		if (pressure < ONE_ATMOSPHERE*0.4)
			italics = 1
			sound_vol *= 0.5

		var/list/hearturfs = hear(message_range, T)

		for(var/mob/M in mob_list)
			if(M.loc && M.locs[1] in hearturfs)
				listening += M
			else if(M.stat == DEAD && M.client && (M.client.prefs.chat_toggles & CHAT_GHOSTEARS))
				listening += M

		for(var/obj/O in hearing_objects)
			if(O.loc && O.locs[1] in hearturfs)
				listening_obj += O

	var/speech_bubble_test = say_test(message)
	var/image/speech_bubble = image('icons/mob/talk.dmi', src, "h[speech_bubble_test]")
	spawn(30)
		qdel(speech_bubble)

	for(var/mob/M in listening)
		M << speech_bubble
		M.hear_say(message, verb, speaking, alt_name, italics, src, speech_sound, sound_vol)

	for(var/obj/O in listening_obj)
		spawn(0)
			if(O) //It's possible that it could be deleted in the meantime.
				O.hear_talk(src, message, verb, speaking)

	if(!usr || usr == src)
		log_say("[key]/[name] : [message]")
	else
		log_say("[key]/[name] (usr: [key_name(usr)]) : [message]")
	return TRUE

/mob/living/proc/say_signlang(var/message, var/verb="gestures", var/datum/language/language)
	for (var/mob/O in viewers(src, null))
		O.hear_signlang(message, verb, language, src)
	return 1

/obj/effect/speech_bubble
	var/mob/parent

/mob/living/proc/GetVoice()
	return name

/mob/living/hear_say(message, verb = "says", datum/language/language = null, alt_name = "", italics = FALSE,\
		mob/speaker = null, speech_sound, sound_vol)
	if(!client)
		return

	if(sdisabilities&DEAF || ear_deaf)
		// INNATE is the flag for audible-emote-language, so we don't want to show an "x talks but you cannot hear them" message if it's set
		if(!language || !language.flags&INNATE)
			if(speaker == src)
				src << SPAN_WARN("You cannot hear yourself speak!")
			else
				src << "<span class='name'>[speaker.name]</span>[alt_name] talks but you cannot hear \him."
		return

	//make sure the air can transmit speech - hearer's side
	var/turf/T = get_turf(src)
	if(T)
		var/datum/gas_mixture/environment = T.return_air()
		var/pressure = (environment) ? environment.return_pressure() : 0
		if(pressure < SOUND_MINIMUM_PRESSURE && get_dist(speaker, src) > 1)
			return

		//sound distortion pressure, to help clue people in that the air is thin, even if it isn't a vacuum yet
		if(pressure < ONE_ATMOSPHERE * 0.4)
			italics = TRUE
			sound_vol *= 0.5 //muffle the sound a bit, so it's like we're actually talking through contact

	if(sleeping || stat == UNCONSCIOUS)
		hear_sleep(message)
		return

	//non-verbal languages are garbled if you can't see the speaker. Yes, this includes if they are inside a closet.
	if(language)
		if(language.flags&NONVERBAL)
			if(!speaker || (src.sdisabilities&BLIND || src.blinded) || !(speaker in view(src)))
				message = stars(message)

	if(!(language && language.flags&INNATE)) // skip understanding checks for INNATE languages
		if(!say_understands(speaker, language))
			if(isanimal(speaker))
				var/mob/living/simple_animal/S = speaker
				message = pick(S.speak)
			else
				if(language)
					message = language.scramble(message)
				else
					message = stars(message)

	..()


/mob/living/hear_radio(message, verb="says", datum/language/language=null, part_a, part_b, speaker = null, hard_to_hear = 0, voice_name ="")
	if(!client)
		return

	if(sdisabilities&DEAF || ear_deaf)
		if(prob(20))
			src << SPAN_WARN("You feel your headset vibrate but can hear nothing from it!")
		return

	if(sleeping || stat == UNCONSCIOUS) //If unconscious or sleeping
		hear_sleep(message)
		return

	//non-verbal languages are garbled if you can't see the speaker. Yes, this includes if they are inside a closet.
	if(language && language.flags&NONVERBAL)
		if(!speaker || (src.sdisabilities&BLIND || src.blinded) || !(speaker in view(src)))
			message = stars(message)

	// skip understanding checks for INNATE languages
	if(!(language && language.flags&INNATE))
		if(!say_understands(speaker, language))
			if(isanimal(speaker))
				var/mob/living/simple_animal/S = speaker
				if(S.speak && S.speak.len)
					message = pick(S.speak)
				else
					return
			else
				if(language)
					message = language.scramble(message)
				else
					message = stars(message)

		if(hard_to_hear)
			message = stars(message)

	..()

/mob/living/proc/hear_sleep(var/message)
	var/heard = ""
	if(prob(15))
		var/list/punctuation = list(",", "!", ".", ";", "?")
		var/list/messages = splittext(message, " ")
		var/R = rand(1, messages.len)
		var/heardword = messages[R]
		if(heardword[1] in punctuation)
			heardword = copytext_char(heardword, 2)
		if(heardword[length(heardword)] in punctuation)
			heardword = copytext_char(heardword, 1, length(heardword)-1)
		heard = "<span class = 'game_say'>...You hear something about...[heardword]</span>"

	else
		heard = "<span class = 'game_say'>...<i>You almost hear someone talking</i>...</span>"

	src << heard
