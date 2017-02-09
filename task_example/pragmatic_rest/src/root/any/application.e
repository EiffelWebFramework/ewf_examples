note
	description: "Summary description for {APPLICATION}."
	author: ""
	date: "$Date: 2013-06-28 16:12:39 -0300 (vie 28 de jun de 2013) $"
	revision: "$Revision: 80 $"

class
	APPLICATION

inherit
	PRAGMATIC_REST_SERVER
		rename
			launch as launch_ds
		redefine
			initialize
		end
	SHARED_EXECUTION_ENVIRONMENT


create
	make_and_launch

feature {NONE} -- Initialization

	initialize
			-- Initialize current service.
		do
			initialize_launcher_nature
			Precursor
		end

	initialize_launcher_nature
			-- Initialize the launcher nature
			-- either cgi, libfcgi, or nino.
			--| We could extend with more connector if needed.
			--| and we could use WSF_DEFAULT_SERVICE_LAUNCHER to configure this at compilation time.
		local
			p: PATH
			l_entry_name: READABLE_STRING_32
		do
			create p.make_from_string (execution_environment.arguments.command_name)
			if attached p.entry as l_entry then
				l_entry_name := l_entry.name
				if attached l_entry.extension as l_extension then
					l_entry_name := l_entry_name.substring (1, l_entry_name.count - l_extension.count - 1)
				end
				if l_entry_name.ends_with_general ("-cgi") then
					is_cgi := True
				elseif l_entry_name.ends_with_general ("-libfcgi") then
					is_libfcgi := True
				end
			end
			is_standalone := not (is_cgi or is_libfcgi)
		end

feature {NONE} -- Launcher

	is_standalone: BOOLEAN

	is_cgi: BOOLEAN

	is_libfcgi: BOOLEAN

	launch (opts: detachable WSF_SERVICE_LAUNCHER_OPTIONS)
		local
			launcher: WSF_SERVICE_LAUNCHER[PRAGMATIC_REST_EXECUTION]
		do
			if is_cgi then
				create {WSF_CGI_SERVICE_LAUNCHER[PRAGMATIC_REST_EXECUTION]} launcher.make_and_launch (opts)
			elseif is_libfcgi then
				create {WSF_LIBFCGI_SERVICE_LAUNCHER[PRAGMATIC_REST_EXECUTION]} launcher.make_and_launch (opts)
			else
				create {WSF_STANDALONE_SERVICE_LAUNCHER[PRAGMATIC_REST_EXECUTION]} launcher.make_and_launch (opts)
			end
		end

end
