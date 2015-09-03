note
	description: "Summary description for {BLOG_POST}."
	date: "$Date$"
	revision: "$Revision$"

class
	BLOG_POST

inherit

	ANY
		redefine
			default_create
		end

create
	default_create

feature {NONE} -- Initialization

	default_create
		do
			create {ARRAYED_LIST [STRING]}	tags.make (0)
			set_published_date (create {DATE_TIME}.make_now_utc)
			unmark_published
			set_title ("")
			set_content ("")
			set_author_id (0)
		end

feature -- Access

	id: INTEGER_64
			-- blog unique id

	tags: LIST [STRING]
			-- possible list of tags

	published_date: DATE_TIME
			-- published date

	published: BOOLEAN
			-- is blog pusblished?

	title: STRING
			-- blog title

	content: STRING
			-- blog content

	author_id: INTEGER_64
			-- author unique id

feature -- Status Report

	has_id: BOOLEAN
			-- Is id > 0?
		do
			Result := id > 0
		end

feature -- Element change

	mark_published
			-- Mark blog as published.
		do
			published := True
		ensure
			is_published_true: published = True
		end

	unmark_published
			-- Mark blog as not published.
		do
			published := False
		ensure
			is_published_false: published = False
		end

	set_id (an_id: like id)
			-- Assign `id' with `an_id'.
		do
			id := an_id
		ensure
			id_assigned: id = an_id
		end

	set_tags (a_tags: like tags)
			-- Assign `tags' with `a_tags'.
		do
			tags := a_tags
		ensure
			tags_assigned: tags = a_tags
		end

	set_published_date (a_published_date: like published_date)
			-- Assign `published_date' with `a_published_date'.
		do
			published_date := a_published_date
		ensure
			published_date_assigned: published_date = a_published_date
		end

	set_title (a_title: like title)
			-- Assign `title' with `a_title'.
		do
			title := a_title
		ensure
			title_assigned: title = a_title
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
