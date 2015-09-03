note
	description: "Summary description for {COMMENT_POST}."
	date: "$Date$"
	revision: "$Revision$"

class
	COMMENT_POST

inherit

	ANY
		redefine
			default_create
		end

create
	default_create


feature {NONE} -- Initialize

	default_create
		do
			set_id (0)
			set_content ("")
			set_author_id (0)
			set_blog_post_id (0)
		end

feature -- Access

	id: INTEGER_64
			-- comment unique id,

	blog_post_id: INTEGER_64
			-- blog's unique id

	content: STRING
			-- comment's content
		attribute check False then end end --| Remove line when `content' is initialized in creation procedure.

	author_id: INTEGER_64
			-- author's unique id.

feature -- Element change

	set_id (an_id: like id)
			-- Assign `id' with `an_id'.
		do
			id := an_id
		ensure
			id_assigned: id = an_id
		end

	set_blog_post_id (a_blog_post_id: like blog_post_id)
			-- Assign `blog_post_id' with `a_blog_post_id'.
		do
			blog_post_id := a_blog_post_id
		ensure
			blog_post_id_assigned: blog_post_id = a_blog_post_id
		end

	set_content (a_content: like content)
			-- Assign `content' with `a_content'.
		do
			content := a_content
		ensure
			content_assigned: content = a_content
		end

	set_author_id (an_author_id: like author_id)
			-- Assign `author_id' with `an_author_id'.
		do
			author_id := an_author_id
		ensure
			author_id_assigned: author_id = an_author_id
		end

end
