note
	description: "Summary description for {MEMORY_PERSISTENT_CONTEXT}."
	author: ""
	date: "$Date: 2013-07-04 15:33:47 -0300 (jue 04 de jul de 2013) $"
	revision: "$Revision: 96 $"

class
	MEMORY_PERSISTENT_CONTEXT

feature -- Persistent Context
	persistent_context : PERSISTENT_CONTEXT
		once
			create Result.make_memory
		end
end
