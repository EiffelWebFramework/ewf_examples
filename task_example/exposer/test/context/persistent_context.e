note
	description: "[
					This context has a set of Provider / repository classes
					Each provider class would be responsible for using the storage implementation (Memory, SQL, etc) 
					and to move data back and forth. The provider class will be responsible to create domain Objects. 
					
					Domain objects will use the persistent context. They will be agnostic to the storage implementation.
					
				]"
	author: ""
	date: "$Date: 2013-07-04 15:33:47 -0300 (jue 04 de jul de 2013) $"
	revision: "$Revision: 96 $"

class
	PERSISTENT_CONTEXT

create
	make_memory
feature {NONE} -- Initialization
	make_memory
		do
			create context.make(2)
			context.force (memory_customer_provider, "CUSTOM_PROVIDER")
			context.force (memory_order_provider, "ORDER_PROVIDER")
		end


feature -- Access
	customer_provider : CUSTOMER_PROVIDER
		do
			if attached {MEMORY_CUSTOMER_PROVIDER} context.at ("CUSTOM_PROVIDER") as l_provider then
				Result := l_provider
			else
				Result := memory_customer_provider
			end
		end

	order_provider : ORDER_PROVIDER
		do
			if attached {MEMORY_ORDER_PROVIDER} context.at ("ORDER_PROVIDER") as l_provider then
				Result := l_provider
			else
				Result := memory_order_provider
			end
		end

feature {NONE}-- Memory Context

	memory_customer_provider : MEMORY_CUSTOMER_PROVIDER
		once
			create Result.make (10)
		end

	memory_order_provider : MEMORY_ORDER_PROVIDER
		once
			create Result.make (10)
		end

feature -- Context
	context : HASH_TABLE[ANY,STRING]
		-- provider context
end
