note
	description : "test_exposer application root class"
	date        : "$Date: 2013-07-04 15:33:47 -0300 (jue 04 de jul de 2013) $"
	revision    : "$Revision: 96 $"

class
	APPLICATION

inherit
	ARGUMENTS

create
	make

feature {NONE} -- Initialization

	make
		do
			print ("%N Person Example %N")
			example_person
			print ("%N Task Example %N")
			example_task
		end


	example_task
		local
			t : TASK
			et : TASK_EXPOSER
			etj : TASK_EXPOSER_JSON
			l_json : STRING
		do
			l_json := "[
							{
    							"description": "Testing",
							    "completed": "False"
								}
							]"
			-- domain
			create t
			t.set_description ("Testing exposer")

			-- exposer from domain
			create et.from_domain (t)
			print ("%NExposer from domain:" + et.is_valid.out)

				-- exposer to json
			create etj.make
			if attached etj.to_json (et) as ll_json then
				print ("%NExposer to JSON : %N" + ll_json.representation)
			end

			-- from json to exposer
			if attached etj.from_json (l_json) as l_exp then
				et := l_exp
				-- from exposer to domain
				t := et.to_domain
				print ("%NTask Object :" + t.debug_output)
			end
		end



	example_person
		local
			p : PERSON
			ep : PERSON_EXPOSER
			epj : PERSON_EXPOSER_JSON
			l_json : STRING
		do
			l_json := "[
						{ "age":50, "salary":55 }
						]"
			-- domain
			create p
			p.set_age (10)
			p.set_salary (5)

			-- exposer from domain
			create ep.from_domain (p)
			print (ep.is_valid)

			-- exposer to json
			create epj.make
			if attached epj.to_json (ep) as ll_json then
				print (ll_json.representation)
			end

			-- from json to exposer
			if attached epj.from_json (l_json) as l_exp then
				ep := l_exp

				-- from exposer to domain
				p := ep.to_domain
				print ("%Nage:" + p.age.out)
				print ("%Nsalary:" + p.salary.out)
			end
		end



end
