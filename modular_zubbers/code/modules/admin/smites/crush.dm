// ZH EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_zh/modules/i18n/readme.md
//Smites to crush someone with an anvil. First one prompts for a damage value. Second has a preset damage value and shouldn't kill if the person is healthy.
/datum/smite/crush
	name = "Crush with Anvil"
	var/hurty = 120

/datum/smite/crush/configure(client/user)
	hurty = tgui_input_number(user, LANG("datum.abafb3655e1a9bfa", null), LANG("datum.bf734d7a92e5d9a8", null), 120, 600, 0)

/datum/smite/crush/effect(client/user, mob/living/target)
	. = ..()
	var/obj/structure/reagent_anvil/crushing_thing = new /obj/structure/reagent_anvil(target.loc)
	crushing_thing.SpinAnimation(3,2)
	crushing_thing.layer = ABOVE_MOB_LAYER

	target.emote("scream")
	target.AddElement(/datum/element/squish, 30 SECONDS)
	target.Paralyze(0.05 SECONDS * hurty)
	target.Knockdown(0.1 SECONDS * hurty)
	target.apply_damage(damage = hurty, damagetype = BRUTE, blocked = 0, spread_damage = TRUE, wound_clothing = FALSE)
	
	playsound(target, 'sound/effects/splat.ogg', 50, TRUE)
	playsound(target, 'sound/effects/bang.ogg', 60, TRUE)
	if(hurty > 110)
		playsound(target, 'modular_skyrat/modules/gladiator/Clang_cut.ogg', 100, TRUE)

	target.visible_message(span_danger(LANG("datum.a1f607163830989c", list(crushing_thing, target))))
	if(target.stat == DEAD)
		target.visible_message(span_danger(LANG("datum.7041aca4ab75b3bf", list(target))))
