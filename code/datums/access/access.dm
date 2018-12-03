/obj
	var/list/req_access = list()
	var/list/req_one_access = list()

//returns TRUE if this mob has sufficient access to use this object
/obj/proc/allowed(mob/living/M)
	//check if it doesn't require any access at all
	if(src.check_access(null))
		return TRUE
	if(!istype(M))
		return FALSE
	return check_access_list(M.GetAccess())

/atom/movable/proc/GetAccess()
	var/obj/item/weapon/card/id/id = GetIdCard()
	return id ? id.GetAccess() : list()

/atom/movable/proc/GetIdCard()
	return null

/obj/proc/check_access(obj/item/I)
	return check_access_list(I ? I.GetAccess() : list())

/obj/proc/check_access_list(var/list/L)
	if(!istype(L, /list))
		return FALSE
	if(!req_access)
		req_access = list()
	if(!req_one_access)
		req_one_access = list()
	return has_access(req_access, req_one_access, L)

/proc/has_access(var/list/req_access, var/list/req_one_access, var/list/accesses)
	for(var/req in req_access)
		if(!(req in accesses)) //doesn't have this access
			return FALSE
	if(req_one_access.len)
		for(var/req in req_one_access)
			if(req in accesses) //has an access from the single access list
				return TRUE
		return FALSE
	return TRUE

var/list/priv_all_access_datums
/proc/get_all_access_datums()
	if(!priv_all_access_datums)
		priv_all_access_datums = init_subtypes(/datum/access)
		priv_all_access_datums = dd_sortedObjectList(priv_all_access_datums)

	return priv_all_access_datums.Copy()

var/list/priv_all_access_datums_id
/proc/get_all_access_datums_by_id()
	if(!priv_all_access_datums_id)
		priv_all_access_datums_id = list()
		for(var/datum/access/A in get_all_access_datums())
			priv_all_access_datums_id["[A.id]"] = A

	return priv_all_access_datums_id.Copy()

var/list/priv_all_access_datums_region
/proc/get_all_access_datums_by_region()
	if(!priv_all_access_datums_region)
		priv_all_access_datums_region = list()
		for(var/datum/access/A in get_all_access_datums())
			if(!priv_all_access_datums_region[A.region])
				priv_all_access_datums_region[A.region] = list()
			priv_all_access_datums_region[A.region] += A

	return priv_all_access_datums_region.Copy()


/proc/get_access_ids(var/access_types = ACCESS_TYPE_ALL)
	var/list/L = new()
	for(var/datum/access/A in get_all_access_datums())
		if(A.access_type & access_types)
			L += A.id
	return L

var/list/priv_all_access
/proc/get_all_accesses()
	if(!priv_all_access)
		priv_all_access = get_access_ids()

	return priv_all_access.Copy()

var/list/priv_station_access
/proc/get_all_station_access()
	if(!priv_station_access)
		priv_station_access = get_access_ids(ACCESS_TYPE_STATION)

	return priv_station_access.Copy()

var/list/priv_centcom_access
/proc/get_all_centcom_access()
	if(!priv_centcom_access)
		priv_centcom_access = get_access_ids(ACCESS_TYPE_CENTCOM)

	return priv_centcom_access.Copy()

var/list/priv_syndicate_access
/proc/get_all_syndicate_access()
	if(!priv_syndicate_access)
		priv_syndicate_access = get_access_ids(ACCESS_TYPE_SYNDICATE)

	return priv_syndicate_access.Copy()

var/list/priv_region_access
/proc/get_region_accesses(var/code)
	if(code == ACCESS_REGION_ALL)
		return get_all_station_access()

	if(!priv_region_access)
		priv_region_access = list()
		for(var/datum/access/A in get_all_access_datums())
			if(!priv_region_access["[A.region]"])
				priv_region_access["[A.region]"] = list()
			priv_region_access["[A.region]"] += A.id

	var/list/region = priv_region_access["[code]"]
	return region.Copy()

/proc/get_region_accesses_name(var/code)
	switch(code)
		if(ACCESS_REGION_ALL)
			return "All"
		if(ACCESS_REGION_SECURITY) //security
			return "Security"
		if(ACCESS_REGION_MEDBAY) //medbay
			return "Medbay"
		if(ACCESS_REGION_RESEARCH) //research
			return "Research"
		if(ACCESS_REGION_ENGINEERING) //engineering and maintenance
			return "Engineering"
		if(ACCESS_REGION_COMMAND) //command
			return "Command"
		if(ACCESS_REGION_GENERAL) //station general
			return "General"
		if(ACCESS_REGION_SUPPLY) //supply
			return "Supply"
		if(ACCESS_REGION_NT) //nt
			return "Nanotrasen"

/proc/get_access_desc(id)
	var/list/AS = priv_all_access_datums_id || get_all_access_datums_by_id()
	var/datum/access/A = AS["[id]"]

	return A ? A.desc : ""

/proc/get_centcom_access_desc(A)
	return get_access_desc(A)

/proc/get_access_by_id(id)
	var/list/AS = priv_all_access_datums_id || get_all_access_datums_by_id()
	return AS[num2text(id)]

/proc/get_access_region_by_id(id)
	var/datum/access/AD = get_access_by_id(id)
	return AD.region


