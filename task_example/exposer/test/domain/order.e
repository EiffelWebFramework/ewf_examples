note
	description: "Objects that represent an Order"
	author: ""
	date: "$Date: 2013-07-04 15:33:47 -0300 (jue 04 de jul de 2013) $"
	revision: "$Revision: 96 $"

class
	ORDER

create
	make
feature -- Initialization
	make (a_number : like number; a_context : like persitent_context)
		do
			set_number (a_number)
			set_persistent_context (a_context)
		end

feature -- Access

	number : READABLE_STRING_GENERAL
		-- order number

	total : INTEGER_64
		-- order value

feature -- Element Change

	set_number (a_number : READABLE_STRING_GENERAL)
		do
			number := a_number
		ensure
			number_set : number.same_string (a_number)
		end


	set_total (a_total : INTEGER_64)
		do
			total := a_total
		ensure
			total_set : total = a_total
		end

feature -- persistent context

	persitent_context : PERSISTENT_CONTEXT

feature -- Set Provider

	set_persistent_context (a_context : like persitent_context)
		do
			persitent_context := a_context
		ensure
			context_set : persitent_context = a_context
		end

end
