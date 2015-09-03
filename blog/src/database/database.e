note
	description: "Summary description for {DATABASE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	DATABASE

create
	make

feature {NONE} -- Initialization

	make
		do
			create {ARRAYED_LIST [BLOG_POST]} db_blogs.make(0)
		end

feature -- Access


	blogs: LIST [BLOG_POST]
		do
			Result := db_blogs
		end

feature -- Access

	search (a_key: INTEGER_64): detachable BLOG_POST
		local
			l_status: BOOLEAN
		do
			from
				db_blogs.start
			until
				db_blogs.after or l_status
			loop
				if db_blogs.item.id = a_key then
					Result := db_blogs.item
					l_status := True
				end
				db_blogs.forth
			end
		end

feature -- Insert

	save_blog (a_item: BLOG_POST)
			-- Add `a_item' to the storage
		do
			a_item.set_id (db_blogs.count + 1)
			db_blogs.force (a_item)
		end


feature {NONE} -- Implementation

	db_blogs: LIST [BLOG_POST]

end
