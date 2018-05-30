workspace "MySQLOO"

	language "C++"
	location ( "solutions/" .. os.target() .. "-" .. _ACTION )
	symbols "On"
	editandcontinue "Off"
	vectorextensions "SSE"
	flags { "NoPCH", "NoImportLib" }
	targetdir ( "out/" .. os.target() .. "/" )
	includedirs {	"MySQLOO/include/",
					"GmodLUA/include/",
					"Boost/",
					"MySQL/include/"	 }

	if os.istarget( "macosx" ) or os.istarget( "linux" ) then

		buildoptions { "-std=c++11 -fPIC" }
		linkoptions { "-fPIC -static-libstdc++" }

	end

	if _ACTION == "vs2017" then
		toolset "v141_xp"
	end

	configurations
	{
		"Release"
	}
	platforms
	{
		"x32",
		"x64"
	}

	filter "platforms:x32"
		architecture "x32"
		libdirs { "MySQL/lib/" .. os.target() }

	filter "platforms:x64"
		architecture "x64"
		libdirs { "MySQL/lib/" .. os.target() .. "/x64" }

	filter { "platforms:x32", "system:windows" }
		targetsuffix "_win32"

	filter { "platforms:x64", "system:windows" }
		targetsuffix "_win64"

	filter { "platforms:x32", "system:macosx" }
		targetsuffix "_osx"

	filter { "platforms:x64", "system:macosx" }
		targetsuffix "_osx64"

	filter { "platforms:x32", "system:linux" }
		targetsuffix "_linux"

	filter { "platforms:x64", "system:linux" }
		targetsuffix "_linux64"

	configuration "Release"
		defines { "NDEBUG" }
		optimize "On"
		floatingpoint "Fast"

	project "MySQLOO"
		defines { "GMMODULE" }
		files { "MySQLOO/source/**.*", "MySQLOO/include/**.*" }
		kind "SharedLib"

		targetname "gmsv_mysqloo"
		targetextension ".dll"
		targetdir ( "out/" .. os.target() )

		if os.istarget( "windows" ) then
			links { "libmysql" }
		elseif os.istarget( "macosx" ) or os.istarget( "linux" ) then
			links { "mysqlclient" }
		end