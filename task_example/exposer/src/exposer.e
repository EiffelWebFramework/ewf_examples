note
	description: "rendering and editing mechanism for objects of type `G'"
	EIS : "name=Design Document", "src=https://docs.google.com/a/eiffel.com/document/d/1Gu3xyng9W8dbqJlnbuqPqP5flrEUJA6XfCCQagbpeZw/edit#heading=h.9m7purkr0nt" , "protocol=url"
deferred class
	EXPOSER [G]


feature -- Access
	fields: STRING_TABLE [ANY]
			-- Attributes to be exposed.

feature -- Validation

	is_valid : BOOLEAN
			-- validity condition for values in each field
		deferred
		end

feature -- Exposer to Domain
	to_domain: G
			-- Object built from `fields'.
		deferred
		end

feature -- From Domain to Exposer
	from_domain (obj: like to_domain)
			-- Set `fields' from `obj'.
		deferred
		end


feature {NONE} -- Implementation

	add_key (a_key : READABLE_STRING_GENERAL; a_value : ANY)
			-- add a key `a_key' with value `a_value' to the table of fields
		do
			fields.force (a_value, a_key)
		end

end
