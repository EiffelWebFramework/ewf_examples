note
	description: "Summary description for {APPLICATION}."
	author: ""
	date: "$Date: 2013-07-09 17:38:42 -0300 (mar, 09 jul 2013) $"
	revision: "$Revision: 119 $"

class
	APPLICATION_LAUNCHER[G -> WSF_EXECUTION create make end]

feature -- Launcher

	launch (a_opts: detachable WSF_SERVICE_LAUNCHER_OPTIONS)
		local
			launcher: WSF_SERVICE_LAUNCHER [EWF_PERSON_EXECUTION]
		do
			create {WSF_DEFAULT_SERVICE_LAUNCHER [EWF_PERSON_EXECUTION]} launcher.make_and_launch ( a_opts)
		end

end

