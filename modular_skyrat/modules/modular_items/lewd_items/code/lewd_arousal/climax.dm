// ZH EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_zh/modules/i18n/readme.md
#define CLIMAX_VAGINA "Vagina"
#define CLIMAX_PENIS "Penis"
#define CLIMAX_BOTH "Both"

#define CLIMAX_ON_FLOOR "On the floor"
#define CLIMAX_IN_OR_ON "Climax in or on someone"
#define CLIMAX_OPEN_CONTAINER "Fill reagent container"
#define CLIMAX_PORTAL "Through the portal"

// both of these are pretty much arbitrary
#define MIN_CUM_THRESHOLD 5
#define MIN_VAGINA_WETNESS_THRESHOLD 3.33

/mob/living/carbon/human
	/// Used to prevent nightmare scenarios.
	var/refractory_period

/mob/living/carbon/human/proc/climax(manual = TRUE)
	if (CONFIG_GET(flag/disable_erp_preferences))
		return

	#ifndef TESTING
	if(!client?.prefs?.read_preference(/datum/preference/toggle/erp/autocum) && !manual)
		return
	#endif

	if(refractory_period > REALTIMEOFDAY)
		return
	refractory_period = REALTIMEOFDAY + 30 SECONDS

	#ifndef TESTING
	if(has_status_effect(/datum/status_effect/climax_cooldown) || !client?.prefs?.read_preference(/datum/preference/toggle/erp))
		return
	#endif

	if(HAS_TRAIT(src, TRAIT_NEVERBONER) || has_status_effect(/datum/status_effect/climax_cooldown) || (!has_vagina() && !has_penis()))
		visible_message(span_purple(LANG("mob.65eb8f7ff62cbbf1", list(src))), \
			span_purple(LANG("mob.59077c060edb0956", null)))
		return TRUE

	// Reduce pop-ups and make it slightly more frictionless (lewd).
	var/climax_choice = has_penis() ? CLIMAX_PENIS : CLIMAX_VAGINA

	if(manual)
		var/list/genitals = list()
		if(has_vagina())
			genitals.Add(CLIMAX_VAGINA)
			if(has_penis())
				genitals.Add(CLIMAX_PENIS)
				genitals.Add(CLIMAX_BOTH)
		else if(has_penis())
			genitals.Add(CLIMAX_PENIS)
		climax_choice = tgui_alert(src, LANG("mob.d2fdc32c9c731af9", null), LANG("mob.6136bced200ef277", null), genitals)

	switch(gender)
		if(MALE)
			conditional_pref_sound(get_turf(src), pick('modular_skyrat/modules/modular_items/lewd_items/sounds/final_m1.ogg',
										'modular_skyrat/modules/modular_items/lewd_items/sounds/final_m2.ogg',
										'modular_skyrat/modules/modular_items/lewd_items/sounds/final_m3.ogg'), 50, TRUE, pref_to_check = /datum/preference/toggle/erp/sounds)
		if(FEMALE)
			conditional_pref_sound(get_turf(src), pick('modular_skyrat/modules/modular_items/lewd_items/sounds/final_f1.ogg',
										'modular_skyrat/modules/modular_items/lewd_items/sounds/final_f2.ogg',
										'modular_skyrat/modules/modular_items/lewd_items/sounds/final_f3.ogg'), 50, TRUE, pref_to_check = /datum/preference/toggle/erp/sounds)

	var/self_orgasm = FALSE
	var/self_their = p_their()

	var/obj/item/organ/genital/testicles/testicles = get_organ_slot(ORGAN_SLOT_TESTICLES)
	testicles?.calculate_cumshot()

	if(climax_choice == CLIMAX_PENIS || climax_choice == CLIMAX_BOTH)
		var/obj/item/organ/genital/penis/penis = get_organ_slot(ORGAN_SLOT_PENIS)
		if(!testicles || testicles.reagents.total_volume < MIN_CUM_THRESHOLD) //If we have no god damn balls, we can't cum anywhere... GET BALLS! , OR theres so little in your balls that nothing comes out...
			visible_message(span_userlove(LANG("mob.6e0187edc6da1516", list(src, self_their))), \
				span_userlove(LANG("mob.f8c5d54c781159d4", null)))

		else if(is_wearing_condom())
			var/obj/item/clothing/sextoy/condom/condom = src.penis // bruh 💀⚰️💀⚰️💀⚰️💀⚰️💀
			condom.condom_use() // condoms probably should become reagent containers at some point
			visible_message(span_userlove(LANG("mob.a1e08d66ff49d273", list(src, self_their, condom))), \
				span_userlove(LANG("mob.02a031057c854063", list(condom))))
			testicles.reagents.remove_all(testicles.cumshot_size)

		else if(!is_bottomless() && penis.visibility_preference != GENITAL_ALWAYS_SHOW)
			visible_message(span_userlove(LANG("mob.64e23146aa57ab55", list(src, self_their))), \
				span_userlove(LANG("mob.d44b5efa0dc52cf0", null)))
			self_orgasm = TRUE
			testicles.reagents.remove_all(testicles.cumshot_size)

		else
			var/list/interactable_inrange_humans = list()
			// monkey see, monkey do
			var/list/interactable_inrange_open_containers = list()

			// Unfortunately prefs can't be checked here, because byond/tgstation moment.
			for(var/mob/living/carbon/human/iterating_human in (view(1, src) - src))
				interactable_inrange_humans[iterating_human.name] = iterating_human

			// this should be making a list of cups(?)
			for(var/obj/item/reagent_containers/cup/iterating_open_container in (view(1, src) - src))
				interactable_inrange_open_containers[iterating_open_container.name] = iterating_open_container

			var/list/buttons = list(CLIMAX_ON_FLOOR)
			if(interactable_inrange_humans.len)
				buttons += CLIMAX_IN_OR_ON

			if(interactable_inrange_open_containers.len)
				buttons += CLIMAX_OPEN_CONTAINER

			// If your using a LustWish portal lets you cum through it
			var/obj/structure/lewd_portal/portal = src.buckled
			if(istype(portal, /obj/structure/lewd_portal))
				buttons += CLIMAX_PORTAL

			var/penis_climax_choice = tgui_alert(src, LANG("mob.7cd3302cd4ec9632", null), LANG("mob.328dbd2f47a0bbd0", null), buttons)

			var/create_cum_decal = FALSE

			if(!penis_climax_choice || penis_climax_choice == CLIMAX_ON_FLOOR)
				create_cum_decal = TRUE
				visible_message(span_userlove(LANG("mob.47e60ad7a8ba60c4", list(src, self_their))), \
					span_userlove(LANG("mob.28062261be0abaec", null)))
				testicles.reagents.remove_all(testicles.cumshot_size)

			else if(penis_climax_choice == CLIMAX_OPEN_CONTAINER)
				var/target_choice = tgui_input_list(src, LANG("mob.78e89e0e585daf53", null), LANG("mob.93ab300d3b4b2851", null), interactable_inrange_open_containers)
				if(!target_choice)
					create_cum_decal = TRUE
					visible_message(span_userlove(LANG("mob.47e60ad7a8ba60c4", list(src, self_their))), \
						span_userlove(LANG("mob.28062261be0abaec", null)))
					testicles.reagents.remove_all(testicles.cumshot_size)
				else
					var/obj/item/reagent_containers/cup/target_open_container = interactable_inrange_open_containers[target_choice]
					if(target_open_container.is_refillable() && target_open_container.is_drainable())
						// here's where we actually do the cumming(?)
						var/cum_volume = testicles.cumshot_size
						var/total_volume_w_cum = cum_volume + target_open_container.reagents.total_volume
						conditional_pref_sound(get_turf(src), SFX_DESECRATION, 50, TRUE, pref_to_check = /datum/preference/toggle/erp/sounds)
						if(target_open_container.reagents.holder_full())
							// its full already
							add_cum_splatter_floor(get_turf(target_open_container))
							visible_message(span_userlove(LANG("mob.b19e3b70701833b5", list(src, target_open_container))), \
								span_userlove(LANG("mob.30345c748f32c46b", list(target_open_container))))
						else
							testicles.reagents.trans_to(target_open_container, testicles.cumshot_size, transferred_by = src)
							if(total_volume_w_cum > target_open_container.volume)
								// overflow, make the decal
								add_cum_splatter_floor(get_turf(target_open_container))
								visible_message(span_userlove(LANG("mob.6c963fa1f443d537", list(src, self_their, target_open_container))), \
									span_userlove(LANG("mob.de263d6cb4af9abc", list(target_open_container))))
							else
								visible_message(span_userlove(LANG("mob.a9928d9e3c4424d8", list(src, self_their, target_open_container))), \
									span_userlove(LANG("mob.00685b844c8fea1f", list(target_open_container))))
					else
						// cum fail
						create_cum_decal = TRUE
						visible_message(span_userlove(LANG("mob.47e60ad7a8ba60c4", list(src, self_their))), \
							span_userlove(LANG("mob.28062261be0abaec", null)))
						testicles.reagents.remove_all(testicles.cumshot_size)

			else if(penis_climax_choice == CLIMAX_PORTAL)
				to_chat(src, LANG("mob.1628f71d700da119", null))
				portal.relayed_body.visible_message(LANG("mob.ee477d961cef112d", list(portal.relayed_body)))
				add_cum_splatter_floor(get_turf(portal.relayed_body))

			else
				var/target_choice = tgui_input_list(src, LANG("mob.4beec21eb8965590", null), LANG("mob.93ab300d3b4b2851", null), interactable_inrange_humans)
				if(!target_choice)
					create_cum_decal = TRUE
					visible_message(span_userlove(LANG("mob.47e60ad7a8ba60c4", list(src, self_their))), \
						span_userlove(LANG("mob.28062261be0abaec", null)))
				else
					var/mob/living/carbon/human/target_human = interactable_inrange_humans[target_choice]
					var/target_human_them = target_human.p_them()

					var/list/target_buttons = list()

					if(!target_human.wear_mask)
						target_buttons += "mouth"
					if(target_human.has_vagina(REQUIRE_GENITAL_EXPOSED))
						target_buttons += ORGAN_SLOT_VAGINA
					if(target_human.has_anus(REQUIRE_GENITAL_EXPOSED))
						target_buttons += "asshole"
					if(target_human.has_penis(REQUIRE_GENITAL_EXPOSED))
						var/obj/item/organ/genital/penis/other_penis = target_human.get_organ_slot(ORGAN_SLOT_PENIS)
						if(other_penis.sheath != "None")
							target_buttons += "sheath"
					target_buttons += "On [target_human_them]"

					var/climax_into_choice = tgui_input_list(src, LANG("mob.a90ce281117696da", list(target_human)), LANG("mob.57ec68b8384177b5", null), target_buttons)

					if(!climax_into_choice)
						create_cum_decal = TRUE
						visible_message(span_userlove(LANG("mob.c112e520b16cc327", list(src))), \
							span_userlove(LANG("mob.28062261be0abaec", null)))
					else if(climax_into_choice == "On [target_human_them]")
						create_cum_decal = TRUE
						visible_message(span_userlove(LANG("mob.82a775d2165fb8ab", list(src, target_human))), \
							span_userlove(LANG("mob.967166cec24ac1cb", list(target_human))))
					else
						visible_message(
							span_userlove(LANG("mob.98f8dc62fa355055", list(src, self_their, target_human, climax_into_choice, target_human_them))),
							span_userlove(LANG("mob.8cccffb856944bd9", list(target_human, climax_into_choice, target_human_them))))
						to_chat(target_human, span_userlove(LANG("mob.a85881eb6949869a", list(climax_into_choice, src, self_their))))

						if(climax_into_choice == "mouth")
							testicles.reagents.trans_to(target_human, testicles.cumshot_size, transferred_by = src, methods = INGEST)

					// if someone wanted to, they could add code for actually putting cum inside of a vagina since it's a reagent container now...
					// would need to change up the fluid_generation.dm and tweak the organ itself for it to make sense though
					// same for other organs

			if(create_cum_decal)
				add_cum_splatter_floor(get_turf(src))

		try_lewd_autoemote("moan")
		if(climax_choice == CLIMAX_PENIS)
			apply_status_effect(/datum/status_effect/climax)
			apply_status_effect(/datum/status_effect/climax_cooldown)
			if(self_orgasm)
				add_mood_event("orgasm", /datum/mood_event/climaxself)
			return TRUE

	if(climax_choice == CLIMAX_VAGINA || climax_choice == CLIMAX_BOTH)
		var/obj/item/organ/genital/vagina/vagina = get_organ_slot(ORGAN_SLOT_VAGINA)
		if(is_bottomless() || vagina.visibility_preference == GENITAL_ALWAYS_SHOW)
			visible_message(
				span_userlove(LANG("mob.7afb4b0792818f02", list(src, p_they()))),
				span_userlove(LANG("mob.e21fd6a2b21e0f0f", null)))
			if(vagina.reagents.total_volume >= MIN_VAGINA_WETNESS_THRESHOLD)
				add_cum_splatter_floor(get_turf(src), female = TRUE)
		else
			if(vagina.reagents.total_volume >= MIN_VAGINA_WETNESS_THRESHOLD)
				visible_message(
					span_userlove(LANG("mob.945b0574d3346a04", list(src, self_their, self_their))),
					span_userlove(LANG("mob.e799c6ce774a1f4a", null)))
				self_orgasm = TRUE
			else
				visible_message(
					span_userlove(LANG("mob.945b0574d3346a04", list(src, self_their, self_their))),
					span_userlove(LANG("mob.839da9a6979ceff4", null)))

	apply_status_effect(/datum/status_effect/climax)
	apply_status_effect(/datum/status_effect/climax_cooldown)
	if(self_orgasm)
		add_mood_event("orgasm", /datum/mood_event/climaxself)
	return TRUE

#undef CLIMAX_VAGINA
#undef CLIMAX_PENIS
#undef CLIMAX_BOTH
#undef CLIMAX_ON_FLOOR
#undef CLIMAX_IN_OR_ON
#undef CLIMAX_OPEN_CONTAINER

#undef MIN_CUM_THRESHOLD
#undef MIN_VAGINA_WETNESS_THRESHOLD
#undef CLIMAX_PORTAL
