note
	description: "Summary description for {APPLICATION}."
	author: ""
	date: "$Date: 2013-08-20 17:37:45 -0300 (mar, 20 ago 2013) $"
	revision: "$Revision: 204 $"

class
	APPLICATION

inherit
	PRAGMATIC_REST_SERVER
		redefine
			initialize
		end

create
	make_and_launch

feature {NONE} -- Initialization

	initialize
			-- Initialize current service.
		do
			set_service_option ("port", 9999)
			set_service_option ("verbose", True)
		end


end
