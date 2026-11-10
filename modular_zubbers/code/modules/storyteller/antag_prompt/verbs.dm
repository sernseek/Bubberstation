// ZH EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_zh/modules/i18n/readme.md
GAME_VERB_DESC(/client, clear_poll_ignores, "清除投票忽略", "Undo every \"Never For This Round\" choice you have made.", "OOC")
	var/list/cleared = list()
	for(var/ignore_category in GLOB.poll_ignore)
		var/list/ignored = GLOB.poll_ignore[ignore_category]
		if(!(ckey in ignored))
			continue
		ignored -= ckey
		cleared += GLOB.poll_ignore_desc[ignore_category] || ignore_category

	if(!length(cleared))
		to_chat(src, span_warning(LANG("client.4c3193563af77d4b", null)))
		return
	to_chat(src, span_notice(LANG("client.11f12452629a0a87", list(english_list(cleared)))))
