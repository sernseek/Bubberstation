// ZH EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_zh/modules/i18n/readme.md
/obj/machinery/ore_silo/colony_lathe
	name = "colony ore silo"
	desc = "An all-in-one materials management solution. Connects resource-using machines \
		through a network of distribution systems."
	icon = 'modular_skyrat/modules/colony_fabricator/icons/ore_silo.dmi'
	circuit = null
	/// What this packs into
	var/packed_type = /obj/item/flatpacked_machine/ore_silo
	/// Has somebody shut the transfer beep up
	var/muted = FALSE

/obj/machinery/ore_silo/colony_lathe/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/repackable, packed_type, 10 SECONDS)

/obj/machinery/ore_silo/colony_lathe/silo_log(obj/machinery/machinery_in_question, action, amount, noun, list/mats)
	. = ..()
	if(!muted)
		playsound(src, 'sound/machines/beep/beep.ogg', 30, TRUE)

/obj/machinery/ore_silo/colony_lathe/examine(mob/user)
	. = ..()
	. += span_notice(LANG("obj.65fb25fbc4705e21", list(muted ? "muted" : "unmuted", EXAMINE_HINT("Alt-click"))))

/obj/machinery/ore_silo/colony_lathe/click_alt(mob/user)
	muted = !muted
	balloon_alert(user, LANG("obj.d5bfe5a575e925f1", list(muted ? "muted" : "unmuted")))
	playsound(src, 'sound/machines/click.ogg', 30, TRUE)
	return CLICK_ACTION_SUCCESS

/obj/machinery/ore_silo/colony_lathe/default_deconstruction_crowbar()
	return

// Item for deploying ore silos
/obj/item/flatpacked_machine/ore_silo
	name = "flat-packed ore silo"
	icon = 'modular_skyrat/modules/colony_fabricator/icons/ore_silo.dmi'
	icon_state = "ore_silo"
	type_to_deploy = /obj/machinery/ore_silo/colony_lathe
	custom_materials = list(
		/datum/material/iron = SHEET_MATERIAL_AMOUNT * 5,
		/datum/material/glass = SHEET_MATERIAL_AMOUNT * 5,
	)
