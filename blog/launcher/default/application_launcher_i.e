note
	description: "[
			Specific application launcher

			DO NOT EDIT THIS CLASS

			you can customize APPLICATION_LAUNCHER
		]"
	date: "$Date: 2015-06-16 19:59:14 -0300 (ma. 16 de jun. de 2015) $"

deferred class
	APPLICATION_LAUNCHER_I [G -> WSF_EXECUTION create make end]

feature -- Execution

	launch (opts: detachable WSF_SERVICE_LAUNCHER_OPTIONS)
		local
			launcher: WSF_SERVICE_LAUNCHER [G]
		do
			create {WSF_DEFAULT_SERVICE_LAUNCHER[G]} launcher.make_and_launch (opts)
		end

end


