// ZH EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_zh/modules/i18n/readme.md
//Bonks the target, making them squashed for 30 seconds.
/datum/smite/bonk
	name = "Bonk"

/datum/smite/bonk/effect(client/user, mob/living/target)
	. = ..()
	playsound(target, 'modular_zubbers/code/modules/emotes/sound/effects/bonk.ogg', 100, 1)
	target.AddElement(/datum/element/squish, 30 SECONDS)
	to_chat(target, span_warning(span_big(LANG("datum.9722c0cd32301eea", null))))
