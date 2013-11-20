note
	description: "Summary description for {MEMORY_ORDER_PROVIDER}."
	author: ""
	date: "$Date: 2013-07-04 15:33:47 -0300 (jue 04 de jul de 2013) $"
	revision: "$Revision: 96 $"

class
	MEMORY_ORDER_PROVIDER

inherit

	ORDER_PROVIDER
		undefine
			is_equal,
			copy
		end

	HASH_TABLE [TUPLE [customer: READABLE_STRING_GENERAL; number: READABLE_STRING_GENERAL; total: INTEGER_64], READABLE_STRING_GENERAL]

	MEMORY_PERSISTENT_CONTEXT
		undefine
			is_equal,
			copy
		end

create
	make

feature -- Access Order

	all_orders: LIST [ORDER]
			-- retrieve all orders from the storage
		local
			l_order: ORDER
		do
			create {ARRAYED_LIST [ORDER]} Result.make (0)
			across
				linear_representation as elem
			loop
				if attached {TUPLE [READABLE_STRING_GENERAL, READABLE_STRING_GENERAL, INTEGER_64]} elem.item as l_item and then
					attached {READABLE_STRING_GENERAL} l_item.at (2) as l_number and then attached {INTEGER_64} l_item.at (3) as l_total then
					create l_order.make (l_number, persistent_context)
					l_order.set_total (l_total)
					Result.force (l_order)
				end
			end
		end

	retrieve_orders_by_customer (name: READABLE_STRING_GENERAL): LIST [ORDER]
			-- retrieve all orders from the storage by the given customer name
		local
			l_order: ORDER
		do
			create {ARRAYED_LIST [ORDER]} Result.make (0)
			across
				linear_representation as elem
			loop
				if attached {TUPLE [READABLE_STRING_GENERAL, READABLE_STRING_GENERAL, INTEGER_64]} elem.item as l_item and then
					attached {READABLE_STRING_GENERAL} l_item.at (2) as l_number and then attached {INTEGER_64} l_item.at (3) as l_total and then
					attached {READABLE_STRING_GENERAL} l_item.at (1) as l_customer then
						if l_customer.same_string (name) then
							create l_order.make (l_number, persistent_context)
							l_order.set_total (l_total)
							Result.force (l_order)
						end
				end
			end
		end

	retrieve_order_by_number (number: READABLE_STRING_GENERAL): detachable ORDER
			-- get an order by number `number' if exists in the storage
		local
			l_order: ORDER
		do
			if attached {TUPLE [READABLE_STRING_GENERAL, READABLE_STRING_GENERAL, INTEGER_64]} item (number) as l_tuple then
				create l_order.make (number, persistent_context)
				if attached {INTEGER_64} l_tuple.at (3) as l_total then
					l_order.set_total (l_total)
				end
				Result := l_order
			end
		end

feature -- New Order

	new (customer: READABLE_STRING_GENERAL; order: ORDER)
		do
			force ([customer, order.number, order.total], order.number)
		end

feature -- Update Order

	update (order: ORDER)
		do
			if attached {TUPLE [READABLE_STRING_GENERAL, READABLE_STRING_GENERAL, INTEGER_64]} item (order.number) as l_tuple and then attached {READABLE_STRING_GENERAL} l_tuple.at (1) as l_customer then
				force ([l_customer, order.number, order.total], order.number)
			end
		end

feature -- Delete Order

	delete (order: ORDER)
		do
			remove (order.number)
		end

end
