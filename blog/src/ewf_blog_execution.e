note
	description: "[
				application service
			]"
	date: "$Date$"
	revision: "$Revision$"

class
	EWF_BLOG_EXECUTION

inherit

	WSF_ROUTED_EXECUTION
		redefine
			initialize
		end

	WSF_URI_HELPER_FOR_ROUTED_EXECUTION

	WSF_URI_TEMPLATE_HELPER_FOR_ROUTED_EXECUTION

	SHARED_DATABASE

	SHARED_EJSON


create
	make

feature {NONE} -- Initialization

	initialize
			-- Initialize current service.
		do
			Precursor
			initialize_router
		end

	setup_router
			-- Setup `router'
		local
			fhdl: WSF_FILE_SYSTEM_HANDLER
			doc: WSF_ROUTER_SELF_DOCUMENTATION_HANDLER
		do

				-- HTML uri/uri templates.
			map_uri_agent ("/", agent handle_root_api, router.methods_GET)
			map_uri_template_agent ("/rels/{rel}", agent handle_rels, router.methods_GET)
			map_uri_agent ("/blogs", agent handle_blogs, router.methods_get_post)




--/blogs: collection of public BlogPost resources.
--/blogs/{blogId}: single BlogPost resource.
--/blogs/{blogId}/comments: collection of approved CommentPost resources of a particular BlogPost.
--/blogs/{blogId}/comments/{commentId}: single CommentPost resource of a particular BlogPost.



			create doc.make (router)
			create fhdl.make_hidden ("www")
			fhdl.set_directory_index (<<"browser.html">>)
			router.handle ("/", fhdl, router.methods_GET)

		end


feature -- Handle HTML pages

	handle_root_api (req: WSF_REQUEST; res: WSF_RESPONSE)
		local
			l_root: HAL_ROOT_RESOURCE
		do
			create l_root
			compute_response_get (req, res, l_root.build (req.absolute_script_url ("")), "application/json")
		end


	handle_blogs (req: WSF_REQUEST; res: WSF_RESPONSE)
			-- When GET collection of public Blog Post resources.
			-- When POST: Factory of resources of type blog.
		local
			l_root: HAL_ROOT_RESOURCE
		do
			if req.is_post_request_method then
				blog_factory (req, res)
			elseif req.is_get_request_method then
				create l_root
				compute_response_get (req, res, l_root.build(req.absolute_script_url ("")), "application/json")
			end
		end

	handle_rels (req: WSF_REQUEST; res: WSF_RESPONSE)
		do
			if attached {WSF_STRING} req.path_parameter ("rel") as l_rel then
				if l_rel.value.same_string ("blogs") then
					compute_response_get (req, res, rel_blogs, "text/html")
				end
			end
		end

feature {NONE} -- Blog factory

	blog_factory (req: WSF_REQUEST; res: WSF_RESPONSE)
		local
			l_data: STRING
			l_json_parser: JSON_PARSER
			l_blog: BLOG_POST
		do
			l_data := retrieve_data (req)
			create l_json_parser.make_with_string (l_data)
			l_json_parser.parse_content
			if l_json_parser.is_parsed then
				if attached {JSON_OBJECT} l_json_parser.parsed_json_object as j_blog then
					if
						attached {JSON_STRING} j_blog.item (create {JSON_STRING}.make_from_string ("content")) as l_content and then
						attached {JSON_STRING} j_blog.item (create {JSON_STRING}.make_from_string ("title")) as l_title
					then
						create l_blog
						l_blog.set_content (l_content.item)
						l_blog.set_title (l_title.item)
						database.save_blog (l_blog)
						compute_response_post (req, res, req.absolute_script_url ("") +"/blog/"+l_blog.id.out, "application/json")
					end
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

	compute_response_get (req: WSF_REQUEST; res: WSF_RESPONSE; output: STRING; media_type: STRING)
		local
			h: HTTP_HEADER
			l_msg: STRING
			hdate: HTTP_DATE
		do
			create h.make
			create l_msg.make_from_string (output)
			h.put_content_type (media_type)
			h.put_content_length (l_msg.count)
			if attached req.request_time as time then
				create hdate.make_from_date_time (time)
				h.add_header ("Date:" + hdate.rfc1123_string)
			end
			res.set_status_code ({HTTP_STATUS_CODE}.ok)
			res.put_header_text (h.string)
			res.put_string (l_msg)
		end


	compute_response_post (req: WSF_REQUEST; res: WSF_RESPONSE; a_location: STRING; media_type: STRING)
		local
			h: HTTP_HEADER
			hdate: HTTP_DATE
		do
			create h.make
			h.put_location (a_location)
			h.put_content_type (media_type)
			h.put_content_length (3)
			if attached req.request_time as time then
				create hdate.make_from_date_time (time)
				h.add_header ("Date:" + hdate.rfc1123_string)
			end
			res.set_status_code ({HTTP_STATUS_CODE}.created)
			res.put_header_text (h.string)
			res.put_string ("n/a")
		end





feature -- Rels Definitions

	rel_blogs: STRING = "[
<!DOCTYPE html>
<html>
<head>
	<link href="/rels.css" media="all" rel="stylesheet" type="text/css">
</head>
<body>
<h1 class="page-header">blogs <small>relation</small> </h1>

<div class="well method"><h2>GET</h2>
	<p class="description">Fetch a list of the blogs</p>

	<div class="response"><h3>Responses</h3>
		<div class="code">
			<h4>200 OK</h4>
			<div class="body">
				<h5>Body</h5>
				<div class="links"><h6>LINKS</h6>
					<ul>
						<li><a href="/rels/blog">ht:blog</a> - an array of blog links (REQUIRED)</li>
						<li>next (OPTIONAL)</li>
						<li>prev (OPTIONAL)</li>
					</ul>
				</div>
			</div>
		</div>
	</div>
</div>

<div class="well method"><h2>POST</h2>
	<p class="description">Create an blog</p>

	<div class="request"><h3>Responses</h3>
		<div class="headers">
			<h4>Request Headers</h4>
			<div class="type">
				The request should have the Content-Type application/json
			</div>
		</div>

		<div class="body">
			<h4>Body</h4>
			<div class="required">
				<h5>Required properties</h5>
				<ul>
					<li><stong>content</strong> : "The string containing the content of the blog"
					</li>
					<li><stong>title</strong> : "The string containing the title of the blog"
					</li>
				</ul>
				<h5>Optional properties</h5>
				<ul>
					<li><stong>tags</strong> : "The string containing the tags of the blog"
					</li>
				</ul>
				<h5>Example</h5>
				<pre>
"{
	"title": "Learning Eiffel",
	"content": "To learn Eiffel"
}"
				</pre>
			</div>
		</div>
	</div>
	<div class="response">
    	<h3>Responses</h3>
    	<div class="code">
      	<h4>201 Created</h4>
    	  <div class="headers">
       	 <h5>Headers</h5>
       	 <ul>
          <li>Location: URI of the created <a href="/rels/blog">blog</a></li>
        </ul>
      </div>
    </div>
    <div class="code">
      <h4>401 Unauthorized</h4>
      <div class="headers">
        <h5>Headers</h5>
        <ul>
          <li>WWW-Authenticate: indicates the Auth method (typically HTTP Basic)</li>
        </ul>
      </div>
    </div>
  </div>
</div>
</body>
</html>
]"
end

