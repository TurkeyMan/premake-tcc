--
-- tcc/tcc.lua
-- Define the tcc toolset.
-- Copyright (c) 2015 Manu Evans, and the Premake project
--

	local p = premake

	p.modules.tcc = {}

	local m = p.modules.tcc

	m._VERSION = p._VERSION
	m.elements = {}

	include( "tools/tcc.lua" )

	return m
