note
	description: "[
		Eiffel tests that can be executed by testing tool.
	]"
	author: "EiffelStudio test wizard"
	date: "$Date: 2013-07-05 10:52:10 -0300 (vie 05 de jul de 2013) $"
	revision: "$Revision: 104 $"
	testing: "type/manual"

class
	TEST_PERSISTENCE

inherit
	EQA_TEST_SET
		redefine
			on_prepare,
			on_clean
		end

feature {NONE} -- Events

	on_prepare
		note
				testing:"execution/isolated"
		local
			l_customer : CUSTOMER

		do
			-- create a customer1
			l_customer := application_context.new_customer ("customer1")
			customer_provider.new (l_customer)
		end

	on_clean
			-- <Precursor>
		note
				testing:"execution/isolated"
		do
		end

feature -- Test routines
	test_default_context_only_one_customer
		note
			testing:"execution/isolated"
		do
			assert ("Expected 1",customer_provider.all_customer.count = 1)
		end

	test_add_new_customer
		note
				testing:"execution/isolated"
		local
			l_count : INTEGER
		do
			l_count := customer_provider.count
			customer_provider.new (application_context.new_customer ("customer2"))
			assert ("Expected l_count + 1",customer_provider.count = l_count + 1)
		end

	test_not_exist_customer
		note
				testing:"execution/isolated"
		do
			assert("False", not customer_provider.exist_customer (application_context.new_customer ("Test")))
		end

	test_exist_customer
		note
				testing:"execution/isolated"
		do
			assert("True", customer_provider.exist_customer (application_context.new_customer ("customer1")))
		end

	test_retrieve_a_valid_customer_without_orders
		note
			testing:"execution/isolated"
		local
			l_customer : detachable CUSTOMER
		do
			l_customer := customer_provider.retrieve_customer_by_name ("customer1");
			assert ("Exist", l_customer /= Void)
			if l_customer /= Void then
				assert ("Empty orders", l_customer.orders.is_empty)
			end
		end

	test_retrieve_a_not_valid_customer
		note
			testing:"execution/isolated"
		local
			l_customer : detachable CUSTOMER
		do
			l_customer := customer_provider.retrieve_customer_by_name ("test");
			assert ("Not Exist", l_customer = Void)
		end


	test_remove_customer
		note
				testing:"execution/isolated"
		do
			if attached customer_provider.retrieve_customer_by_name ("customer1") as l_customer then
				customer_provider.delete (l_customer)
				assert ("Not exist",not customer_provider.exist_customer (l_customer))
			end
		end


	test_customer_add_order
		do
			assert("Empty Orders", order_provider.count = 0)
			if attached customer_provider.retrieve_customer_by_name ("customer1") as l_customer_1 then
				l_customer_1.add_order (application_context.new_order_with_total ("1", 10))
				l_customer_1.add_order (application_context.new_order_with_total ("2", 50))
				l_customer_1.add_order (application_context.new_order_with_total ("3", 50))
				l_customer_1.add_order (application_context.new_order_with_total ("4", 50))

			end
			customer_provider.new (application_context.new_customer ("customer3"))
			if attached customer_provider.retrieve_customer_by_name ("customer3") as l_customer_3 then
				l_customer_3.add_order (application_context.new_order_with_total ("6", 10))
				l_customer_3.add_order (application_context.new_order_with_total ("7", 50))
			end
			-- check order provider
			assert ("Expected 6 order", order_provider.count = 6)
			assert ("Customer 3 Expected 2 Orders",order_provider.retrieve_orders_by_customer ("customer3").count = 2)
			assert ("Customer 1 Expected 4 Orders",order_provider.retrieve_orders_by_customer ("customer1").count = 4)

			-- check using customer_provider
			if attached customer_provider.retrieve_customer_by_name ("customer3") as l_customer_3 then
				assert ("Expected 2 orders", l_customer_3.orders.count = 2)
			end

			-- check using customer_provider
			if attached customer_provider.retrieve_customer_by_name ("customer1") as l_customer_1 then
				assert ("Expected 6 orders", l_customer_1.orders.count = 4)
			end


		end


feature {NONE}-- Implementation
	application_context : APPLICATION_FACTORY

		once
			create Result.make_memory
		end


	customer_provider : CUSTOMER_PROVIDER
		once
			Result := application_context.persistent_context.customer_provider;
		end

	order_provider : ORDER_PROVIDER
		once
			Result := application_context.persistent_context.order_provider
		end
end


