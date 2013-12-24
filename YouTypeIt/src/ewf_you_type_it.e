note
	description: "[
				application service
			]"
	date: "$Date$"
	revision: "$Revision$"

class
	EWF_YOU_TYPE_IT

inherit
	WSF_LAUNCHABLE_SERVICE
		redefine
			initialize
		end

	WSF_ROUTED_SERVICE

	WSF_URI_HELPER_FOR_ROUTED_SERVICE

	WSF_URI_TEMPLATE_HELPER_FOR_ROUTED_SERVICE

	APPLICATION_LAUNCHER

create
	make_and_launch

feature {NONE} -- Initialization

	initialize
			-- Initialize current service.
		do
			Precursor
			set_service_option ("port", 9090)
			create database.make
			initialize_router
		end

	setup_router
			-- Setup `router'
		local
			fhdl: WSF_FILE_SYSTEM_HANDLER
			doc: WSF_ROUTER_SELF_DOCUMENTATION_HANDLER
		do

				-- HTML uri/uri templates.
			map_uri_agent_with_request_methods ("/", agent handle_home_page, router.methods_GET)
			map_uri_agent_with_request_methods ("/about", agent handle_about_page, router.methods_GET)
			map_uri_agent_with_request_methods ("/messages", agent handle_messages_page, router.methods_get_post)
			map_uri_template_agent_with_request_methods ("/messages/{id}", agent handle_item_page, router.methods_get)

				-- API collection+json uri/uri templates.
			map_uri_agent_with_request_methods ("/api", agent handle_api_page, router.methods_get_post)
			map_uri_template_agent_with_request_methods ("/api/{id}", agent handle_api_item, router.methods_get_post)

			create doc.make (router)
			create fhdl.make_hidden ("www")
			fhdl.set_directory_index (<<"index.html">>)
			router.handle_with_request_methods ("/", fhdl, router.methods_GET)
			router.handle_with_request_methods ("/apis/doc", doc, router.methods_GET)
		end

feature -- Database Access

	database: DATABASE

feature -- Handle HTML pages

	handle_home_page (req: WSF_REQUEST; res: WSF_RESPONSE)
		local
			l_hp: HOME_PAGE
		do
			if attached req.http_host as l_host then
				create l_hp.make ("http://"+l_host)
				if attached l_hp.representation as l_home_page then
					compute_response_get (req, res, l_home_page)
				end
			end
		end


	handle_about_page (req: WSF_REQUEST; res: WSF_RESPONSE)
		local
			l_ap: ABOUT_PAGE
		do
			if attached req.http_host as l_host then
				create l_ap.make ("http://"+l_host)
				if attached l_ap.representation as l_about_page then
					compute_response_get (req, res, l_about_page)
				end
			end
		end



	handle_messages_page (req: WSF_REQUEST; res: WSF_RESPONSE)
		local
			l_lp: LIST_PAGE
			l_time: DATE_TIME
		do
			if attached req.http_host as l_host then
				if req.is_get_request_method then
					create l_lp.make ("http://"+ l_host, database.items)
					if attached l_lp.representation as l_list_page then
						compute_response_get (req, res, l_list_page )
					end
				elseif req.is_post_request_method then
					if attached {WSF_VALUE} req.form_parameter ("message") as l_value then
						create l_time.make_now_utc
						database.put (l_value.as_string.value, l_time)
						compute_response_redirect (req, res, "http://"+ l_host+"/messages/"+l_time.time.compact_time.out)
					end

				else
					-- Method not allowed.	
				end
			end
		end


	handle_item_page (req: WSF_REQUEST; res: WSF_RESPONSE)
		local
			l_ip: ITEM_PAGE
		do
			if attached req.http_host as l_host and then
			   attached req.path_parameter ("id") as l_id then
			   	if attached database.search (l_id.as_string.value.to_integer_64) as l_message then
			   		create l_ip.make ( "http://"+l_host, l_message)
			   		if attached l_ip.representation as l_item then
			   			compute_response_get (req, res, l_item)
			   		end
			   	end
			end
		end

feature -- Handle API cj pages

	handle_api_page (req: WSF_REQUEST; res: WSF_RESPONSE)
		local
			l_ap: CJ_API_PAGE
			parser: JSON_PARSER
			l_post: STRING
			l_time: DATE_TIME
		do
			if attached req.http_host as l_host then
					if req.is_get_request_method then
						create l_ap.make ("http://"+ l_host, database.items)
						if attached l_ap.representation as l_list_page then
							compute_response_cj_get (req, res, l_list_page )
						end
					elseif req.is_post_request_method then
							l_post := retrieve_data (req)
							create parser.make_parser (l_post)
							if attached {JSON_OBJECT} parser.parse as jv and parser.is_parsed then
								create l_time.make_now_utc
								if attached {JSON_OBJECT}jv.item ("template") as l_template and then
									attached {JSON_ARRAY}l_template.item ("data") as l_data and then
									attached {JSON_OBJECT} l_data.i_th (1) as l_form_data and then
									attached {JSON_VALUE} l_form_data.item ("value") as l_value then
										database.put (l_value.representation, l_time)
										compute_response_api_create (req, res, "http://"+ l_host+"/api/"+l_time.time.compact_time.out)
								end
							end
					else
						-- Method not allowed.
					end
			end
		end

	handle_api_item (req: WSF_REQUEST; res: WSF_RESPONSE)
		local
			l_ap: CJ_API_PAGE
			parser: JSON_PARSER
			l_post: STRING
			l_time: DATE_TIME
			l_messages : LIST [MESSAGES]
		do
			if attached req.http_host as l_host and then
				attached req.path_parameter ("id") as l_id then
			   		if req.is_get_request_method then
			   			if attached database.search (l_id.as_string.value.to_integer_64) as l_message then
							create {ARRAYED_LIST[MESSAGES]} l_messages.make (1)
							l_messages.force (l_message)
							create l_ap.make ("http://"+ l_host, l_messages)
							if attached l_ap.representation as l_list_page then
								compute_response_cj_get (req, res, l_list_page )
							end
						else
							create l_ap.make_with_error ("http://"+ l_host, "Resource not found", 404)
							if attached l_ap.representation as l_error_page then
								compute_response_cj_error (req, res, l_error_page )
							end
						end
					elseif req.is_post_request_method then
							l_post := retrieve_data (req)
							create parser.make_parser (l_post)
							if attached {JSON_OBJECT} parser.parse as jv and parser.is_parsed then
								create l_time.make_now_utc
								if attached {JSON_OBJECT}jv.item ("template") as l_template and then
									attached {JSON_ARRAY}l_template.item ("data") as l_data and then
									attached {JSON_OBJECT} l_data.i_th (1) as l_form_data and then
									attached {JSON_VALUE} l_form_data.item ("value") as l_value then
										database.put (l_value.representation, l_time)
										compute_response_api_create (req, res, "http://"+ l_host+"/api/"+l_time.time.compact_time.out)
								end
							end
					else
						-- Method not allowed.
					end
			end
		end


feature -- Read data

	retrieve_data  (req: WSF_REQUEST): STRING
			-- Retrieve the content from the input stream.
			-- Handle different transfers.
		require
			req_attached: req /= Void
		do
			create Result.make_empty
			req.read_input_data_into (Result)
		end


feature -- Response

	compute_response_get (req: WSF_REQUEST; res: WSF_RESPONSE; output: STRING)
		local
			h: HTTP_HEADER
			l_msg: STRING
			hdate: HTTP_DATE
		do
			create h.make
			create l_msg.make_from_string (output)
			h.put_content_type_text_html
			h.put_content_length (l_msg.count)
			if attached req.request_time as time then
				create hdate.make_from_date_time (time)
				h.add_header ("Date:" + hdate.rfc1123_string)
			end
			res.set_status_code ({HTTP_STATUS_CODE}.ok)
			res.put_header_text (h.string)
			res.put_string (l_msg)
		end


	compute_response_cj_get (req: WSF_REQUEST; res: WSF_RESPONSE; output: STRING)
		local
			h: HTTP_HEADER
			l_msg: STRING
			hdate: HTTP_DATE
		do
			create h.make
			create l_msg.make_from_string (output)
			h.put_content_type_application_json
			h.put_content_length (l_msg.count)
			if attached req.request_time as time then
				create hdate.make_from_date_time (time)
				h.add_header ("Date:" + hdate.rfc1123_string)
			end
			res.set_status_code ({HTTP_STATUS_CODE}.ok)
			res.put_header_text (h.string)
			res.put_string (l_msg)
		end


	compute_response_cj_error (req: WSF_REQUEST; res: WSF_RESPONSE; output: STRING)
		local
			h: HTTP_HEADER
			l_msg: STRING
			hdate: HTTP_DATE
		do
			create h.make
			create l_msg.make_from_string (output)
			h.put_content_type_application_json
			h.put_content_length (l_msg.count)
			if attached req.request_time as time then
				create hdate.make_from_date_time (time)
				h.add_header ("Date:" + hdate.rfc1123_string)
			end
			res.set_status_code ({HTTP_STATUS_CODE}.not_found)
			res.put_header_text (h.string)
			res.put_string (l_msg)
		end


	compute_response_redirect (req: WSF_REQUEST; res: WSF_RESPONSE; output: STRING)
		local
			h: HTTP_HEADER
			l_msg: STRING
			hdate: HTTP_DATE
		do
			create h.make
			create l_msg.make_from_string (output)
			h.put_content_type_text_html
			if attached req.request_time as time then
				create hdate.make_from_date_time (time)
				h.add_header ("Date:" + hdate.rfc1123_string)
				h.add_header ("Location:" + output)
			end
			res.set_status_code ({HTTP_STATUS_CODE}.see_other)
			res.put_header_text (h.string)
		end



	compute_response_api_create (req: WSF_REQUEST; res: WSF_RESPONSE; output: STRING)
		local
			h: HTTP_HEADER
			l_msg: STRING
			hdate: HTTP_DATE
		do
			create h.make
			create l_msg.make_from_string (output)
			h.put_content_type_application_json
			if attached req.request_time as time then
				create hdate.make_from_date_time (time)
				h.add_header ("Date:" + hdate.rfc1123_string)
				h.add_header ("Location:" + output)
			end
			res.set_status_code ({HTTP_STATUS_CODE}.created)
			res.put_header_text (h.string)
		end





end

