//HTML ENCODE/DECODE + RUS TO CP1251 TODO: OVERRIDE html_encode after fix
/proc/rhtml_encode(var/msg)
	msg = replacetext(msg, "<", "&lt;")
	msg = replacetext(msg, ">", "&gt;")
	msg = replacetext(msg, "ÿ", "&#255;")
	return msg

/proc/rhtml_decode(var/msg)
	msg = replacetext(msg, "&gt;", ">")
	msg = replacetext(msg, "&lt;", "<")
	msg = replacetext(msg, "&#255;", "ÿ")
	return msg



//RUS CONVERTERS
/proc/russian_to_cp1251(var/msg)//CHATBOX
	return replacetext(msg, "ÿ", "&#255;")

/proc/russian_to_utf8(var/msg)//PDA PAPER POPUPS
	return replacetext(msg, "ÿ", "&#1103;")

/proc/utf8_to_cp1251(msg)
	return replacetext(msg, "&#1103;", "&#255;")

/proc/cp1251_to_utf8(msg)
	return replacetext(msg, "&#255;", "&#1103;")

//Prepare text for edit. Replace "ÿ" with "\ß" for edition. Don't forget to call post_edit().
/proc/edit_cp1251(msg)
	return replacetext(msg, "&#255;", "\\ß")

/proc/edit_utf8(msg)
	return replacetext(msg, "&#1103;", "\\ß")

/proc/post_edit_cp1251(msg)
	return replacetext(msg, "\\ß", "&#255;")

/proc/post_edit_utf8(msg)
	return replacetext(msg, "\\ß", "&#1103;")

//input

/proc/input_cp1251(var/mob/user = usr, var/message, var/title, var/default, var/type = "message")
	var/msg = ""
	switch(type)
		if("message")
			msg = input(user, message, title, edit_cp1251(default)) as message
		if("text")
			msg = input(user, message, title, default) as text
	msg = russian_to_cp1251(msg)
	return post_edit_cp1251(msg)

/proc/input_utf8(var/mob/user = usr, var/message, var/title, var/default, var/type = "message")
	var/msg = ""
	switch(type)
		if("message")
			msg = input(user, message, title, edit_utf8(default)) as message
		if("text")
			msg = input(user, message, title, default) as text
	msg = russian_to_utf8(msg)
	return post_edit_utf8(msg)
