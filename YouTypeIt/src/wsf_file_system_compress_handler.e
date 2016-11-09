note
	description: "Summary description for {WSF_FILE_SYSTEM_COMPRESS_HANDLER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	WSF_FILE_SYSTEM_COMPRESS_HANDLER

inherit

	WSF_FILE_SYSTEM_HANDLER
		redefine
			process_transfert
		end

	SHARED_COMPRESSION

create
	make_with_path,
	make_hidden_with_path,
	make,
	make_hidden

feature -- process

	process_transfert (f: FILE; req: WSF_REQUEST; res: WSF_RESPONSE)
		local
			ext: READABLE_STRING_32
			ct: detachable READABLE_STRING_8
			fres: WSF_FILE_RESPONSE
			dt: DATE_TIME
			h: HTTP_HEADER
		do
			ext := extension (f.path.name)
			ct := extension_mime_mapping.mime_type (ext)
			if ct = Void then
				ct := {HTTP_MIME_TYPES}.application_force_download
			end
				-- Compression
			create h.make
			if attached apply_file_compression (req, f, h) as l_content  then
				h.put_content_type (ct)
				h.put_content_length (l_content.count)

			 		-- cache control
				create dt.make_now_utc
				h.put_utc_date (dt)
				if max_age >= 0 then
					h.put_cache_control ("max-age=" +max_age.out)
					if max_age > 0 then
						dt := dt.twin
						dt.second_add (max_age)
					end
					h.put_expires_date (dt)
				end

			 	res.set_status_code ({HTTP_STATUS_CODE}.ok)
			 	res.put_header_text (h.string)
			 	res.put_string (l_content)
			else
				create fres.make_with_content_type (ct, f.path.name)

				fres.set_status_code ({HTTP_STATUS_CODE}.ok)

					-- cache control
				create dt.make_now_utc
				fres.header.put_utc_date (dt)
				if max_age >= 0 then
					fres.set_max_age (max_age)
					if max_age > 0 then
						dt := dt.twin
						dt.second_add (max_age)
					end
					fres.set_expires_date (dt)
				end

				fres.set_answer_head_request_method (req.request_method.same_string ({HTTP_REQUEST_METHODS}.method_head))
				res.send (fres)
			end
		end


feature -- Process File



feature -- Support Compress

	apply_file_compression (req: WSF_REQUEST; f:FILE; h: HTTP_HEADER): detachable STRING
			-- If the client support compression and the server support one of the algorithms
			-- compress it and update the response header.
		local
			l_file: RAW_FILE
		do
			if is_compression_supported then
				create l_file.make_with_path (create {PATH}.make_from_string (f.path.name))
				if l_file.exists then
					l_file.open_read
				 -- As part of an HTTP Client request, we need to check if the Header contains accpet-encoding and if our server support it.
	 			 -- For example:
	 			 -- Accept-Encoding: gzip, deflate
	 			 	h.put_last_modified (create {DATE_TIME}.make_from_epoch (l_file.date))

	 				-- Check the CLIENT request
		 			if
		 				attached req.http_accept_encoding as l_encoding and then
		 				l_encoding.has_substring ("deflate")
		 			then
		 				-- If the client support compression and one of the algorithms is `deflate' we can do compression.
		 				-- and we need to add the corresponding 'Content-Ecoding' witht the supported algorithm.
		 				l_file.read_stream (l_file.count)
		 				Result := do_compress (l_file.last_string)
		 				h.add_header ("Content-Encoding:deflate")
		 				l_file.close
		 			end
	 			end
	 		end
 		end

feature -- Compress Data

 	do_compress (a_string: STRING): STRING
 			-- Compress `a_string' using `deflate'
		local
			dc: ZLIB_STRING_COMPRESS
		do
			create Result.make_empty
			create dc.string_stream_with_size (Result, 32_768) -- chunk size 32k
			dc.put_string_with_options (a_string, {ZLIB_CONSTANTS}.Z_default_compression, 15, 9, {ZLIB_CONSTANTS}.z_default_strategy.to_integer_32)
				-- We use the default compression level
				-- We use the default value for windows bits, the range is 8..15. Higher values use more memory, but produce smaller output.
				-- Memory: Higher values use more memory, but are faster and produce smaller output. The default is 8, we use 9.
		end


end
