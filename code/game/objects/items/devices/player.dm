#define MP3_CHANNEL 4

/obj/item/device/player
	name = "Player"
	var/current_track = ""
	var/obj/item/holder = null
	var/list/songs = list(
		"Beyond" = 'sound/ambience/ambispace.ogg',
		"Edith Piaf"= 'sound/jukebox/Edith_Piaf.ogg',
		"D`Bert" = 'sound/music/title2.ogg',
		"D`Fort" = 'sound/ambience/song_game.ogg',
		"Floating" = 'sound/music/main.ogg',
		"Endless Space" = 'sound/music/space.ogg',
		"Part A" = 'sound/misc/TestLoop1.ogg',
		"Scratch" = 'sound/music/title1.ogg',
		"Space Song" = 'sound/jukebox/Space_Song.ogg',
		"Sweet Jane" = 'sound/jukebox/Sweet_Jane.ogg',
		"Funnel of Love" = 'sound/jukebox/FunnelofLove.ogg',
		"Nowhere to Run" = 'sound/jukebox/Nowhere_to_Run.ogg',
		"Sad Song" = 'sound/jukebox/Look_On_Down_From_The_Bridge.ogg',
		"Detective Blues" = 'sound/jukebox/Blade_Runner_Blues.ogg',
		"Space Oddity" = 'sound/music/david_bowie-space_oddity_original.ogg',
		"Lotsa Luck!" = 'sound/jukebox/Who_Do_You_Love.ogg',
		"Resist" = 'sound/jukebox/Old_Friends.ogg',
		"Turf" = 'sound/jukebox/Turf.ogg',
		"Don't You Want?" = 'sound/jukebox/Somebody_to_Love.ogg',
		"Heroes" = 'sound/jukebox/Heroes.ogg',
		"See You Tomorrow?" = 'sound/jukebox/See_You_Tomorrow.ogg',
		"Lovesong" = 'sound/jukebox/lovesong.ogg',
		"Judge" = 'sound/jukebox/Judge_Bitch.ogg',
		"Drive" = 'sound/jukebox/Real_Hero.ogg',
		"Mystyrious Song" = 'sound/jukebox/Pumpit.ogg',
		"Bob" = 'sound/jukebox/TheTimesTheyArAChangin.ogg'
	)

/obj/item/device/player/New(var/obj/item/holder)
	..()
	if(istype(holder))
		src.holder = holder

/obj/item/device/player/update_icon()
	holder.update_icon()

/obj/item/device/player/proc/stop(var/mob/affected)
	current_track = null
	update_icon()
	if(!affected)
		if(ismob(holder.loc))
			affected = holder.loc
		else
			return
	affected << sound(null, channel = MP3_CHANNEL)

/obj/item/device/player/proc/play()
	if(!current_track || !(current_track in songs))
		stop(usr)

	update_icon()
	if(ishuman(holder.loc))
		var/mob/living/carbon/human/H = holder.loc
		if(holder in list(H.l_ear, H.r_ear))
			H << sound(songs[current_track], channel = MP3_CHANNEL, volume=100)

/obj/item/device/player/proc/OpenInterface(mob/user as mob)

	var/dat = "MP3 player<BR><br>"

	for(var/song in songs)
		if(song == current_track)
			dat += "<a href='byond://?src=\ref[src];play=[song]'><b>[song]</b></a><br>"
		else
			dat += "<a href='byond://?src=\ref[src];play=[song]'>[song]</a><br>"
	dat += "<br><a href='byond://?src=\ref[src];stop=1'>Stop Music</a>"

	user << browse(dat, "window=mp3")
	onclose(user, "mp3")
	return

/obj/item/device/player/Topic(href, href_list)
	if(!holder in usr) return
	if(href_list["play"])
		current_track = href_list["play"]
		play()
	else if(href_list["stop"])
		stop(holder.loc)
	spawn OpenInterface(usr)

#undef MP3_CHANNEL
