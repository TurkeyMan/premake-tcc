Premake Extension to support the [Tiny C Compiler](http://bellard.org/tcc/)

### Features ###

* Support actions: gmake

### Usage ###

Simply specify:
```lua
toolset "tcc"
```
as your toolset.

### APIs ###

* flags
  * BoundsCheck
  * Verbose

### Example ###

The contents of your premake5.lua file would be:

```lua
solution "MySolution"
    configurations { "release", "debug" }

    project "MyProject"
        kind "ConsoleApp"
        language "C"
        toolset "tcc"
        files { "src/main.c" }
```
