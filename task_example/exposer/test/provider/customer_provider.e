note
	description: "Summary description for {CUSTOMER_PROVIDER}."
	author: ""
	date: "$Date: 2013-07-04 15:33:47 -0300 (jue 04 de jul de 2013) $"
	revision: "$Revision: 96 $"

deferred class
	CUSTOMER_PROVIDER

feature -- Access Customer

	all_customer: LIST [CUSTOMER]
			-- retrieve all customer from the storage
		deferred
		end


	count : INTEGER
			-- number of elements form the storage
		deferred
		end

	retrieve_customer_by_name (name: READABLE_STRING_GENERAL): detachable CUSTOMER
			-- get an customer by `name' if exists in the storage
		deferred
		end

	exist_customer (customer: CUSTOMER): BOOLEAN
			-- exist the `customer' in the storage?
		do
			Result := attached retrieve_customer_by_name (customer.name)
		end

feature -- New Customer

	new (customer: CUSTOMER)
		require
			not_exist: not exist_customer (customer)
		deferred
		ensure
			exist: exist_customer (customer)
		end

feature -- Update Customer

	modify (customer: CUSTOMER)
			-- modify an customer, if the customer already exist
			-- update it if not create a new customer.
		do
			if exist_customer (customer) then
				update (customer)
			else
				new (customer)
			end
		end

	update (customer : CUSTOMER)
		require
			exist : exist_customer (customer)
		deferred
		end

feature -- Delete Customer

	delete (customer : CUSTOMER)
		require
			exist : exist_customer (customer)
		deferred
		ensure
			not_exist : not exist_customer (customer)
		end

end
