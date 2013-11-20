note
	description: "Summary description for {PERSON_EXPOSER_JSON}."
	author: ""
	date: "$Date: 2013-07-02 12:35:53 -0300 (mar 02 de jul de 2013) $"
	revision: "$Revision: 86 $"

class
	PERSON_EXPOSER_JSON

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
			pc : JSON_PERSON_CONVERTER
		do
			create pc.make
			json.add_converter (pc)
		end


feature -- From Exposure to JSON
	to_json (ep : PERSON_EXPOSER) : detachable JSON_VALUE
 		do
 			Result := json.value (ep.to_domain)
 		end


feature -- From JSON to Exposure
	from_json (a_json : STRING) : detachable PERSON_EXPOSER
		local
			parser : JSON_PARSER
		do
			create parser.make_parser (a_json)
			if attached parser.parse as jv and parser.is_parsed then
				if attached {PERSON} json.object (jv, "PERSON") as res then
					create Result.from_domain (res)
				end
			end
		end

end
