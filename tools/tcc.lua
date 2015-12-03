--
-- tcc/tools/tcc.lua
-- Provides tcc-specific configuration strings.
-- Copyright (c) 2015 Manu Evans, and the Premake project
--

	premake.tools.tcc = { }

	local tcc = premake.tools.tcc
	local project = premake.project
	local config = premake.config

	--
	-- Set default tools
	--

	tcc.cc = "tcc"


--
-- Returns list of C preprocessor flags for a configuration.
--

	tcc.cppflags = {
	}

	function tcc.getcppflags(cfg)
		local flags = config.mapFlags(cfg, tcc.cppflags)
		return flags
	end


--
-- Returns list of C compiler flags for a configuration.
--

	tcc.cflags = {
		flags = {
			BoundsCheck		= "-b",
			FatalWarnings	= "-Werror",
			Symbols			= "-g",
			Verbose			= "-v",
		},
		warnings = {
			Off = "-w",
			Extra = "-Wall",
		}
	}

	function tcc.getcflags(cfg)
		return config.mapFlags(cfg, tcc.cflags)
	end

	function tcc.getcxxflags(cfg)
		return {} -- TCC doesn't support C++!
	end


--
-- Decorate defines for the tcc command line.
--

	function tcc.getdefines(defines)
		local result = {}
		for _, define in ipairs(defines) do
			table.insert(result, '-D' .. define)
		end
		return result
	end

	function tcc.getundefines(undefines)
		local result = {}
		for _, undefine in ipairs(undefines) do
			table.insert(result, '-U' .. undefine)
		end
		return result
	end


--
-- Returns a list of forced include files, decorated for the compiler
-- command line.
--
-- @param cfg
--    The project configuration.
-- @return
--    An array of force include files with the appropriate flags.
--

	function tcc.getforceincludes(cfg)
		local result = {}
		return result
	end


--
-- Decorate include file search paths for the tcc command line.
--

	function tcc.getincludedirs(cfg, dirs, sysdirs)
		local result = {}
		for _, dir in ipairs(table.join(dirs, sysdirs)) do
			dir = project.getrelative(cfg.project, dir)
			table.insert(result, '-I' .. premake.quoted(dir))
		end
		return result
	end


--
-- Returns the target name specific to compiler
--

	function tcc.gettarget(name)
		return "-o " .. name
	end


--
-- Return a list of LDFLAGS for a specific configuration.
--

	tcc.ldflags = {
		kind = {
			SharedLib = "-shared",
			WindowedApp = "-static",
			ConsoleApp = "-static",
		},
	}

	function tcc.getldflags(cfg)
		local flags = config.mapFlags(cfg, tcc.ldflags)
		return flags
	end


--
-- Return a list of decorated additional libraries directories.
--

	tcc.libraryDirectories = {
		architecture = {
			x86 = "-L/usr/lib",
		}
	}

	function tcc.getLibraryDirectories(cfg)
		local flags = config.mapFlags(cfg, tcc.libraryDirectories)

		-- Scan the list of linked libraries. If any are referenced with
		-- paths, add those to the list of library search paths
		for _, dir in ipairs(config.getlinks(cfg, "system", "directory")) do
			table.insert(flags, '-L' .. project.getrelative(cfg.project, dir))
		end

		return flags
	end


--
-- Return the list of libraries to link, decorated with flags as needed.
--

	function tcc.getlinks(cfg, systemonly)
		local result = {}

		local links
		if not systemonly then
			links = config.getlinks(cfg, "siblings", "object")
			for _, link in ipairs(links) do
				-- skip external project references, since I have no way
				-- to know the actual output target path
				if not link.project.external then
					if link.kind == premake.STATICLIB then
						-- Don't use "-l" flag when linking static libraries; instead use
						-- path/libname.a to avoid linking a shared library of the same
						-- name if one is present
						table.insert(result, project.getrelative(cfg.project, link.linktarget.abspath))
					else
						table.insert(result, "-l" .. link.linktarget.basename)
					end
				end
			end
		end

		-- The "-l" flag is fine for system libraries
		links = config.getlinks(cfg, "system", "fullpath")
		for _, link in ipairs(links) do
			if path.isobjectfile(link) then
				table.insert(result, link)
			else
				table.insert(result, "-l" .. path.getbasename(link))
			end
		end

		return result
	end


--
-- Returns makefile-specific configuration rules.
--

	tcc.makesettings = {
	}

	function tcc.getmakesettings(cfg)
		local settings = config.mapFlags(cfg, tcc.makesettings)
		return table.concat(settings)
	end


--
-- Retrieves the executable command name for a tool, based on the
-- provided configuration and the operating environment.
--
-- @param cfg
--    The configuration to query.
-- @param tool
--    The tool to fetch, one of "cc" for the C compiler, or "ar" for the static linker.
-- @return
--    The executable command name for a tool, or nil if the system's
--    default value should be used.
--

	function tcc.gettoolname(cfg, tool)
		return tcc[tool]
	end

