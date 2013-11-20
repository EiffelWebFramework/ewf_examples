note
	description: "Summary description for {MEMORY_CUSTOMER_PROVIDER}."
	author: ""
	date: "$Date: 2013-07-04 15:33:47 -0300 (jue 04 de jul de 2013) $"
	revision: "$Revision: 96 $"

class
	MEMORY_CUSTOMER_PROVIDER

inherit
	CUSTOMER_PROVIDER
		undefine
			is_equal, copy
		end
	HASH_TABLE[TUPLE[READABLE_STRING_GENERAL],READABLE_STRING_GENERAL]
	MEMORY_PERSISTENT_CONTEXT
		undefine
			is_equal, copy
		end

create
	make

feature -- Access Customer

	all_customer: LIST [CUSTOMER]
			-- retrieve all customers from the storage
		local
			l_customer : CUSTOMER
		do
			--	Result := linear_representation
			create {ARRAYED_LIST[CUSTOMER]}Result.make (0)
			across linear_representation as elem  loop
				if attached {TUPLE[READABLE_STRING_GENERAL]}elem.item as l_item and then
					attached {READABLE_STRING_GENERAL} l_item.at (1) as l_name then
					create l_customer.make (l_name, persistent_context)
					Result.force (l_customer)
				end
			end
		end

	retrieve_customer_by_name (name: READABLE_STRING_GENERAL): detachable CUSTOMER
			-- get a customer by name `name' if exists in the storage
		local
			l_customer : CUSTOMER
		do
			Current.compare_objects
			if attached {TUPLE[READABLE_STRING_GENERAL]}item (name) as l_item and then
			   attached {READABLE_STRING_GENERAL} l_item.at (1) as l_name then
				create l_customer.make (l_name, persistent_context)
				Result := l_customer
			end
		end


feature -- New Customer

	new (customer: CUSTOMER)
		do
			force ([customer.name], customer.name)
		end

feature -- Update Customer

	update (customer : CUSTOMER)
		do
			force ([customer.name], customer.name)
		end

feature -- Delete Customer

	delete (customer : CUSTOMER)
		do
			remove (customer.name)
		end

end

