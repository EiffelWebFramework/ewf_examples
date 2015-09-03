note
	description: "Summary description for {HAL_ROOT_RESOURCE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	HAL_ROOT_RESOURCE

inherit

	SHARED_EJSON

feature -- Access

	build (a_path: STRING_8): STRING
		local
			l_hal: JSON_HAL_RESOURCE_CONVERTER
			l_res: HAL_RESOURCE
			l_link: HAL_LINK
			l_attribute: HAL_LINK_ATTRIBUTE
		do
			create Result.make_empty
			create l_hal.make
			json.add_converter (l_hal)
			create l_attribute.make (a_path + "/rels/{rel}")
			l_attribute.set_name ("ht")
			create l_res.make
			l_res.add_curie_link (l_attribute)

			create l_attribute.make (a_path + "/")
			create l_link.make_with_attribute ("self",l_attribute )
			l_res.add_link (l_link)

			create l_attribute.make (a_path +"/blogs")
			l_attribute.set_href (a_path +"/blogs")
			create l_link.make_with_attribute ("ht:blogs",l_attribute)
			l_res.add_link (l_link)

			if attached json.value (l_res) as ll_hal then
				 Result := ll_hal.representation
			end
		end
end
