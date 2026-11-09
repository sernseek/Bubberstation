// ZH EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_zh/modules/i18n/readme.md
//////////////////////////////////////
/////////////// SYNDIE ///////////////
//////////////////////////////////////

/datum/round_event_control/drop_troopers_syndicate
	name = "Drop Troopers: Syndicate"
	description = "The Syndicate sends large numbers of drop pod soldiers to fight the station."
	typepath = /datum/round_event/droppod_airraid/syndicate
	weight = 5
	max_occurrences = 2
	min_players = 30
	admin_setup = list()
	//do this later admin_setup = list(/datum/event_admin_setup/multiple_choice/droppod_troopers)
	category = EVENT_CATEGORY_ENTITIES
	track = EVENT_TRACK_MAJOR
	tags = list(TAG_COMMUNAL, TAG_COMBAT, TAG_NPC_ANTAG)

/datum/round_event/droppod_airraid/syndicate
	turf_droppods_ratio = 50
	spawn_wave_total_lower = 3
	spawn_wave_total_upper = 5
	droppod_density = 3
	enemy_types = list(
		/mob/living/basic/viscerator, \
		/mob/living/basic/trooper/syndicate/melee,\
		/mob/living/basic/trooper/syndicate/melee/sword/space, \
		/mob/living/basic/trooper/syndicate/ranged, \
		/mob/living/basic/trooper/syndicate/ranged/smg, \
		/mob/living/basic/trooper/syndicate/ranged/shotgun/space, \
	)
	boss_types = list(
		/mob/living/basic/trooper/syndicate/melee/sword/space/stormtrooper, \
		/mob/living/basic/trooper/syndicate/ranged/shotgun/space/stormtrooper, \
		/mob/living/basic/trooper/syndicate/ranged/smg/space/stormtrooper, \
		/mob/living/basic/bot/secbot/grievous, \
	)
	max_boss_pods = 1
	time_to_next_wave_droppod_factor = 20

	droppod_style = /datum/pod_style/syndicate
	max_droppod_dropdelay = 10
	min_droppod_dropdelay = 30

/datum/round_event/droppod_airraid/syndicate/announce(fake)
	priority_announce(LANG("datum.b4b8805888fddce9", list(GLOB.station_name)), "Incoming Enemy Signatures", 'sound/announcer/alarm/airraid.ogg',color_override = "red")

/datum/round_event/droppod_airraid/syndicate/new_boss_spawn()
	. = ..()
	if(istype(., /mob/living/basic/bot/secbot/grievous))
		var/mob/living/basic/bot/secbot/grievous = .
		grievous.emag_act()
		grievous.emag_act() //need to double up cause the first one only unlocks it
		grievous.add_faction(ROLE_SYNDICATE)

/datum/round_event/droppod_airraid/syndicate/announce_end()
	priority_announce(LANG("datum.8547036433550edc", list(GLOB.station_name)))
