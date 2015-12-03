--
-- Name:        tcc/_preload.lua
-- Purpose:     Define the TCC (Tiny C Compiler) tool.
-- Author:      Manu Evans
-- Created:     2015/12/01
-- Copyright:   (c) 2015 Manu Evans and the Premake project
--

	local p = premake
	local api = p.api


	api.addAllowed("flags", { "BoundsCheck", "Verbose" })

--
-- Provide information for the help output
--
	table.insert(p.option.get("cc").allowed, { "tcc", "Tiny C Compiler (tcc)" })


--
-- Decide when to load the full module
--

	return function (cfg)
		return (cfg.toolset == "tcc")
	end

