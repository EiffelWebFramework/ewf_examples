note
	description : "exposer application root class"
	date        : "$Date: 2013-07-02 08:43:49 -0300 (mar 02 de jul de 2013) $"
	revision    : "$Revision: 84 $"

class
	APPLICATION

inherit
	ARGUMENTS

create
	make

feature {NONE} -- Initialization

	make
			-- Run application.
		do
			--| Add your code here
			print ("Hello Eiffel World!%N")
		end

end
