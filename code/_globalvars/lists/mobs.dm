// Noises made when hit while typing.
var/list/hit_appends = list("-OOF", "-ACK", "-UGH", "-HRNK", "-HURGH", "-GLORF")

var/global/list/active_diseases          = list()
var/global/list/med_hud_users            = list() // List of all entities using a medical HUD.
var/global/list/sec_hud_users            = list() // List of all entities using a security HUD.
var/global/list/hud_icon_reference       = list()

var/list/reg_dna       = list()

// Chemistry lists.
var/list/tachycardics  = list("coffee", "inaprovaline", "hyperzine", "nitroglycerin", "thirteenloko", "nicotine") // Increase heart rate.
var/list/bradycardics  = list("neurotoxin", "cryoxadone", "clonexadone", "space_drugs", "stoxin")                 // Decrease heart rate.
var/list/heartstopper  = list("potassium_phorochloride", "zombie_powder") // This stops the heart.
var/list/cheartstopper = list("potassium_chloride")                       // This stops the heart when overdose is met. -- c = conditional

