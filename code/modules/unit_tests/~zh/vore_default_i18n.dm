/datum/unit_test/vore_default_i18n

/datum/unit_test/vore_default_i18n/Run()
	if(GLOB.i18n_server_locale != LANGUAGE_LOCALE_ZH_HANS)
		return
	var/mob/living/carbon/human/consistent/predator = allocate(/mob/living/carbon/human/consistent)
	var/mob/living/carbon/human/consistent/prey = allocate(/mob/living/carbon/human/consistent)
	prey.name = "Yes"
	var/datum/component/vore/vore = predator.AddComponent(/datum/component/vore)
	var/obj/vore_belly/belly = new(predator, vore)
	TEST_ASSERT_EQUAL(belly.get_absorb_messages_owner(prey), "你感觉到Yes正成为你的一部分。", "Built-in templates must be translated before substituting the player's name.")
	belly.absorb_messages_owner = list("You feel %prey becoming part of you.")
	TEST_ASSERT_EQUAL(belly.get_absorb_messages_owner(prey), "You feel Yes becoming part of you.", "A player-written message must not be translated even when it matches a default.")
