note
	description: "{TASK_EXPOSER_JSON} json media type mapping for an EXPOSER_TASK"
	author: ""
	date: "$Date: 2013-07-04 08:25:37 -0300 (jue 04 de jul de 2013) $"
	revision: "$Revision: 93 $"

class
	TASK_EXPOSER_JSON
inherit

	SHARED_EJSON

create
	make

feature {NONE} -- Initialization
	make
		do
			initialize_json_converter
		end


	initialize_json_converter
		local
			tc : JSON_TASK_CONVERTER
		do
			create tc.make
			json.add_converter (tc)
		end


feature -- From Exposure to JSON
	to_json (et : TASK_EXPOSER) : detachable JSON_VALUE
 		do
 			Result := json.value (et.to_domain)
 		end


feature -- From JSON to Exposure
	from_json (a_json : STRING) : detachable TASK_EXPOSER
		local
			parser : JSON_PARSER
		do
			create parser.make_parser (a_json)
			if attached parser.parse as jv and parser.is_parsed then
				if attached {TASK} json.object (jv, "TASK") as res then
					create Result.from_domain (res)
				end
			end
		end

end
