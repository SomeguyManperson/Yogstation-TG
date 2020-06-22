/datum/antagonist/cult/agent
	name = "Blood Agent"
	antagpanel_category = "Blood Agent"
	make_team = FALSE
	agent = TRUE
	ignore_holy_water = TRUE
	var/datum/team/blood_agents/agent_team

/datum/antagonist/cult/agent/on_gain()
	SSticker.mode.bloodagents += owner
	SSticker.mode.update_servant_icons_added(owner)
	equip_cultist(FALSE)
	owner.special_role = ROLE_BLOOD_AGENT
	agent_team = SSticker.mode.blood_agent_team //only one agent team can exist for each side
	if(!agent_team)
		agent_team = new
		SSticker.mode.blood_agent_team = agent_team
		agent_team.add_member(owner)
		objectives += agent_team.objectives
	else
		agent_team.add_member(owner)
		objectives += agent_team.objectives

/datum/antagonist/cult/agent/greet()
	if(considered_alive(owner))
		to_chat(owner, "<span class='cultlarge'>\"These fools are in possession of some things I want. You are here to retrieve them for me.\
		 				The veil is not weak enough to allow much support in this area, so you will be unable to use constructs or some spells. \
		 				Additionally, you may be in contact with some heretical forces. Do not get yourselves killed.\"</span>")
	owner.current.playsound_local(get_turf(owner.current),'sound/ambience/antag/assimilation.ogg' , 100, FALSE, pressure_affected = FALSE)
	owner.announce_objectives()

/datum/antagonist/cult/agent/admin_add(datum/mind/new_owner, mob/admin)
	owner.add_antag_datum(/datum/antagonist/cult/agent)
	agent_team = SSticker.mode.blood_agent_team
	message_admins("[key_name_admin(admin)] has made [key_name_admin(new_owner)] into a Blood Agent.")
	log_admin("[key_name(admin)] has made [key_name(new_owner)] into a Blood Agent.")

/datum/antagonist/cult/agent/admin_remove(mob/user)
	owner.remove_antag_datum(/datum/antagonist/cult/agent)
	message_admins("[key_name_admin(user)] has removed blood agent status from [key_name_admin(owner)].")
	log_admin("[key_name(user)] has removed blood agent status from [key_name(owner)].")

/datum/antagonist/cult/agent/create_team(datum/team/blood_agents/new_team)
	if(!new_team)
		return
	if(!istype(new_team))
		stack_trace("Wrong team type passed to [type] initialization.")
	agent_team = new_team

/datum/team/blood_agents
	name = "Blood Agents"

/datum/team/blood_agents/proc/forge_blood_objectives()
	objectives = list()
	add_objective(new/datum/objective/soulshard)
	add_objective(new/datum/objective/implant/blood)
	add_objective(new/datum/objective/escape/onesurvivor/bloodagent)
	return

/datum/team/blood_agents/proc/add_objective(datum/objective/O)
	O.team = src
	O.update_explanation_text()
	objectives += O

/datum/objective/escape/onesurvivor/bloodagent
	name = "escape blood agent"
	explanation_text = "<span class='cultbold'>Escape alive and out of custody.</span>"
	team_explanation_text = "<span class='cultbold'>Escape with your entire team intact and at least one member alive. Do not get captured.</span>"
