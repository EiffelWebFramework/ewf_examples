note
	description: "Summary description for {APP_SESSION}."
	author: ""
	date: "$Date: 2013-06-11 16:19:59 -0300 (mar 11 de jun de 2013) $"
	revision: "$Revision: 33 $"

class
	APP_SESSION

create
	make

feature {NONE} -- Initialization

	make (a_id: READABLE_STRING_GENERAL)
		do
			if attached {IMMUTABLE_STRING_32} a_id as imm_s32 then
				id := imm_s32
			else
				create id.make_from_string_general (a_id)
			end
		end

feature -- Access

	id: IMMUTABLE_STRING_32

end
