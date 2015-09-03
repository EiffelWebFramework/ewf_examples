note
	description: "Summary description for {MESSAGES}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	MESSAGES

create
	make

feature {NONE} -- Initialization

	make (a_message: READABLE_STRING_32; a_date: DATE_TIME)
		do
			message := a_message
			date := a_date
			id := date.time.compact_time
		end

feature -- Access

	id: INTEGER_64

	message: READABLE_STRING_32

	date: DATE_TIME


end
