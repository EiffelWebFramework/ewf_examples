note
	description: "Summary description for {DATABASE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	DATABASE

create
	make

feature {NONE} -- Initialization

	make
		do
			create {ARRAYED_LIST[MESSAGES]} db.make(0)
		end

feature -- Access

	items: LIST[MESSAGES]
		do
			Result := db
		end

feature -- Access

	search (a_key: INTEGER_64): detachable MESSAGES
		local
			l_status: BOOLEAN
		do
			from
				db.start
			until
				db.after or l_status
			loop
				if db.item.id = a_key then
					Result := db.item
					l_status := True
				end
				db.forth
			end
		end

feature -- Insert

	put (a_item: READABLE_STRING_32; a_date: DATE_TIME)
			-- Add `a_item' to the storage
		local
			l_message: MESSAGES
		do
			create l_message.make (a_item, a_date)
			db.force (l_message)
		end


feature {NONE} -- Implementation

	db: LIST[MESSAGES]

end
