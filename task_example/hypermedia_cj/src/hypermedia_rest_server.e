note
	description: "Hypermedia API REST Server"
	date: "$Date$"
	revision: "$Revision$"
	EIS: "name=REST APIs", "src=http://roy.gbiv.com/untangled/2008/rest-apis-must-be-hypertext-driven", "protocol=url"
	EIS: "name=Hypermedia Controls", "src=http://blueprintforge.com/blog/2012/01/01/a-short-explanation-of-hypermedia-controls-in-restful-services/", "protocol=url"

deferred class
	HYPERMEDIA_REST_SERVER
inherit
	WSF_DEFAULT_SERVICE[HYPERMEDIA_REST_EXECUTION]

end
