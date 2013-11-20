note
	description: "Summary description for {APPLICATION_FACTORY}."
	author: ""
	date: "$Date: 2013-07-04 15:33:47 -0300 (jue 04 de jul de 2013) $"
	revision: "$Revision: 96 $"
	EIS: "name=Persistence Ignorant Object, lazy Loading", "src=http://programmers.stackexchange.com/questions/156585/are-persistence-ignorant-objects-able-to-implement-lazy-loading", "protocol=url"

class
	APPLICATION_FACTORY

create
	make_memory

feature {NONE}-- Initialization
	make_memory
		do
			persistent_context := (create {MEMORY_PERSISTENT_CONTEXT}).persistent_context
		end

feature -- Factories

	new_default_customer: CUSTOMER
			-- create a new customer
		do
			create Result.make ("default", persistent_context )
		end

	new_default_order: ORDER
			-- create a new customer
		do
			create Result.make ("0", persistent_context )
		end

	new_customer ( name : READABLE_STRING_GENERAL) : CUSTOMER
		do
			Result := new_default_customer
			Result.set_name (name)
		end


	new_order (number : READABLE_STRING_GENERAL) : ORDER
		do
			Result := new_default_order
			Result.set_number (number)
		end

	new_order_with_total (number :READABLE_STRING_GENERAL; total : INTEGER_64) : ORDER
		do
			Result := new_order (number)
			Result.set_total (total)
		end

feature -- Persistent Context

	persistent_context : PERSISTENT_CONTEXT

end
