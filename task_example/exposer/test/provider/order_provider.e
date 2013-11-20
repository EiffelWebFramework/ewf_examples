note
	description: "Provider Interface Independent of the storage implementation"
	author: ""
	date: "$Date: 2013-07-04 15:33:47 -0300 (jue 04 de jul de 2013) $"
	revision: "$Revision: 96 $"

deferred class
	ORDER_PROVIDER

feature -- Access Order

	all_orders: LIST [ORDER]
			-- retrieve all orders from the storage
		deferred
		end

	count : INTEGER
			-- number of elements form the storage
		deferred
		end

	retrieve_order_by_number (number: READABLE_STRING_GENERAL): detachable ORDER
			-- get an order by number `number' if exists in the storage
		deferred
		end

	retrieve_orders_by_customer (name: READABLE_STRING_GENERAL): LIST [ORDER]
		 	-- retrieve all orders from the storage by the given customer name
		deferred
		end

	exist_order (order: ORDER): BOOLEAN
			-- exist the `order' in the storage?
		do
			Result := attached retrieve_order_by_number (order.number)
		end

feature -- New Order

	new (customer:READABLE_STRING_GENERAL; order: ORDER)
		require
			not_exist: not exist_order (order)
		deferred
		ensure
			exist: exist_order (order)
		end

feature -- Update Order

	update (order : ORDER)
		require
			exist : exist_order (order)
		deferred
		end

feature -- Delete Order

	delete (order : ORDER)
		require
			exist : exist_order (order)
		deferred
		ensure
			not_exist : not exist_order (order)
		end
end
