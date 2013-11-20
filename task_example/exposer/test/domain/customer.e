note
	description: "Summary description for {CUSTOMER}."
	author: ""
	date: "$Date: 2013-07-04 15:33:47 -0300 (jue 04 de jul de 2013) $"
	revision: "$Revision: 96 $"

class
	CUSTOMER

create
	make
feature {NONE} -- Initialization
	make (a_name : like name ; a_context : like persitent_context)
		do
			set_name (a_name)
			set_persistent_context (a_context)
		end

feature -- Access
	name : READABLE_STRING_GENERAL
		-- customer name

	orders : LIST[ORDER]
		-- customer order's
		do
			Result :=persitent_context.order_provider.retrieve_orders_by_customer (name)
		end

feature -- Element Change

	set_name (a_name : READABLE_STRING_GENERAL)
		do
			name := a_name
		ensure
			name_set : name.same_string (a_name)
		end

feature -- Add Order

	add_order (an_order : ORDER)
		do
			if not persitent_context.order_provider.exist_order (an_order) then
				persitent_context.order_provider.new (name, an_order)
			end
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
