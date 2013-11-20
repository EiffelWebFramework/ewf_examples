note
	description: "Summary description for {APP_FS_DATABASE}."
	author: ""
	date: "$Date: 2013-06-11 16:19:59 -0300 (mar 11 de jun de 2013) $"
	revision: "$Revision: 33 $"

class
	APP_FS_DATABASE

inherit
	APP_DATABASE

create
	make

feature {NONE} -- Initialization

	make (p: like path)
		do
			path := p
		end

	path: PATH

feature -- Access

	item (a_id: READABLE_STRING_GENERAL; a_session: APP_SESSION): detachable READABLE_STRING_32
		local
			d: DIRECTORY
			f: RAW_FILE
			utf: UTF_CONVERTER
		do
			create d.make_with_path (path.extended (a_session.id))
			if d.exists then
				create f.make_with_path (d.path.extended (a_id))
				if f.exists and then f.is_access_readable then
					f.open_read
					if not f.exhausted then
						f.read_line
						Result := utf.utf_8_string_8_to_escaped_string_32 (f.last_string)
					else
						Result := ""
					end
					f.close
				end
			end
		end

	put (a_id: READABLE_STRING_GENERAL; a_text: READABLE_STRING_32; a_session: APP_SESSION)
		local
			d: DIRECTORY
			f: RAW_FILE
			utf: UTF_CONVERTER
		do
			create d.make_with_path (path.extended (a_session.id))
			if not d.exists then
				d.recursive_create_dir
			end
			if d.exists then
				create f.make_with_path (d.path.extended (a_id))
				if not f.exists or else f.is_access_writable then
					f.open_write
					f.put_string (utf.utf_32_string_to_utf_8_string_8 (a_text))
					f.put_new_line
					f.close
				end
			end
		end

	only_numeric_items (a_session: APP_SESSION): BOOLEAN
		local
			d: DIRECTORY
			nb: INTEGER
		do
			create d.make_with_path (path.extended (a_session.id))
			if d.exists then
				nb := 0
				Result := True
				across
					d.entries as e
				until
					not Result
				loop
					if
						not (e.item.is_current_symbol or e.item.is_parent_symbol) and then
						attached item (e.item.name, a_session) as v
					then
						nb := nb + 1
						Result := v.is_number_sequence
					end
				end
				if nb = 0 then
					Result := False
				end
			end
		end

end
