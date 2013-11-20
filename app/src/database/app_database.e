note
	description: "Summary description for {APP_DATABASE}."
	author: ""
	date: "$Date: 2013-06-11 16:19:59 -0300 (mar 11 de jun de 2013) $"
	revision: "$Revision: 33 $"

deferred class
	APP_DATABASE

feature -- Access

	item (a_id: READABLE_STRING_GENERAL; a_session: APP_SESSION): detachable READABLE_STRING_32
		deferred
		end

	put (a_id: READABLE_STRING_GENERAL; a_text: READABLE_STRING_32; a_session: APP_SESSION)
		deferred
		end

	only_numeric_items (a_session: APP_SESSION): BOOLEAN
		deferred
		end

end
