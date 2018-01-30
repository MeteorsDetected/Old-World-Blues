/mob/living
	var/stunned = 0.0
	var/sleeping = 0
	var/resting = 0
	var/paralysis = 0.0
	var/weakened = 0.0


/mob/living/proc/Stun(amount)
	if(status_flags & CANSTUN)
		facing_dir = null
		//can't go below 0, getting a low amount of stun doesn't lower your current stun
		stunned = max(max(stunned,amount),0)

/mob/living/proc/SetStunned(amount)
	if(status_flags & CANSTUN)
		//if you REALLY need to set stun to a set amount without the whole "can't go below current stunned"
		stunned = max(amount,0)

/mob/living/proc/AdjustStunned(amount)
	if(status_flags & CANSTUN)
		stunned = max(stunned + amount,0)

/mob/living/proc/Weaken(amount)
	if(status_flags & CANWEAKEN)
		facing_dir = null
		weakened = max(max(weakened,amount),0)
		update_canmove()	//updates lying, canmove and icons

/mob/living/proc/SetWeakened(amount)
	if(status_flags & CANWEAKEN)
		weakened = max(amount,0)
		update_canmove()	//updates lying, canmove and icons

/mob/living/proc/AdjustWeakened(amount)
	if(status_flags & CANWEAKEN)
		weakened = max(weakened + amount,0)
		update_canmove()	//updates lying, canmove and icons

/mob/living/proc/Paralyse(amount)
	if(status_flags & CANPARALYSE)
		facing_dir = null
		paralysis = max(max(paralysis,amount),0)

/mob/living/proc/SetParalysis(amount)
	if(status_flags & CANPARALYSE)
		paralysis = max(amount,0)

/mob/living/proc/AdjustParalysis(amount)
	if(status_flags & CANPARALYSE)
		paralysis = max(paralysis + amount,0)

/mob/living/proc/Sleeping(amount)
	facing_dir = null
	sleeping = max(max(sleeping,amount),0)

/mob/living/proc/SetSleeping(amount)
	sleeping = max(amount,0)

/mob/living/proc/AdjustSleeping(amount)
	sleeping = max(sleeping + amount,0)

/mob/living/proc/Resting(amount)
	facing_dir = null
	resting = max(max(resting,amount),0)

/mob/living/proc/SetResting(amount)
	resting = max(amount,0)

/mob/living/proc/AdjustResting(amount)
	resting = max(resting + amount,0)

