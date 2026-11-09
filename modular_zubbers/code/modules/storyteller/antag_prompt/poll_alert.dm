// ZH EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_zh/modules/i18n/readme.md
/// Whether the alert shows a running count of how many people have signed up so far.
/datum/candidate_poll/var/show_candidate_amount = TRUE

/// Closes the alert. Opting out for the round is Alt-click or the chat link.
/atom/movable/screen/alert/poll_alert/proc/dismiss_poll()
	if(isnull(poll))
		return
	owner.clear_alert("[poll.poll_key]_poll_alert")

/atom/movable/screen/alert/poll_alert/proc/confirm_never_round()
	if(isnull(poll))
		return
	if(poll.ignoring_category != ANTAG_PROMPT_IGNORE_CATEGORY || (owner.ckey in GLOB.poll_ignore[poll.ignoring_category]))
		set_never_round()
		return

	var/mob/asked = owner
	var/choice = tgui_alert(
		asked,
		LANG("atom.a769b9a2a7467e33", null),
		LANG("atom.4166d8078aa2dd2e", null),
		list("Yes", "No"),
	)
	if(choice != "Yes" || isnull(poll) || owner != asked)
		return
	set_never_round()
