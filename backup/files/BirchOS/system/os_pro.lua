local arg = {...}
l = 0
local installupdate = false
local osstate = ""
local edge_boot_dir = "sys16/edge/"
local OS_SYSTEM_VERSION = birch.osversion
local OS_SYSTEM_CREATOR = "BIRCH"
local OS_SHUTDOWN_MESSAGE = "SHUTTING DOWN"
local OS_REBOOT_MESSAGE = "REBOOTING"

local OS_ROOTLOGIN = false

local OS_BINARYBOOTCODE_CHECK = "01000001"
local OS_ADMINLOGIN_PASSWORD = "01011"
local OS_SYSTEM_PREBOOT_VENDOR = ""
local bootPart = 0
 -- This is seriously not a good method for rendering the menu system, it looks cool though.


function loginscreen()


end
function desktop()


end
function commandline()


end
function boot()
	a = 0
	print("BirchOS is now loading.")
	for _, filename in ipairs(fs.list("system/api/")) do
		if not a == 7 then
			os.loadAPI(filename)
			a = a + 1
			sleep(0.5)
		else
			OS_UNLOCKED = settings.getVariable("system/settings","unlock")
			OS_BINARYBOOTCODE = settings.getVariable("system/settings","bootcode")
			OS_SYSTEM_VERSION = birch.osversion
			CTHEME = tonumber(settings.getVariable("system/libraries/theme/theme.birchtheme","OS_DEFAULTBACKGROUNDCOLOR"))
			if settings.getVariable("system/settings","theme") == "dark" then
				OS_GUI_COLOR = colors.gray
				OS_TEXT_COLOR = colors.white
				OS_WELCOME_COLOR = colors.white
				OS_STARTMENU_SHUTDOWNCOLOR = colors.gray
				OS_STARTMENU_LOGOUTCOLOR = colors.gray
				OS_STARTMENU_REBOOTCOLOR = colors.gray
				OS_STARTMENU_COLOR = colors.lightGray
				OS_CMD_COLOR = colors.black
				OS_ANNOUNCEMENT_COLOR = colors.black
				--OS_BAR_DESIGN = "-======["..formattedTime.."]======-"
				--OS_BAR_BOTTOM_DESIGN = "-o================o-"
				elseif settings.getVariable("system/settings","theme") == "bright" then
				OS_GUI_COLOR = colors.white
				OS_TEXT_COLOR = colors.black
				OS_WELCOME_COLOR = colors.green
				OS_STARTMENU_SHUTDOWNCOLOR = colors.red
				OS_STARTMENU_LOGOUTCOLOR = colors.lime
				OS_STARTMENU_REBOOTCOLOR = colors.yellow
				OS_STARTMENU_COLOR = colors.lightGray
				OS_CMD_COLOR = colors.black
				OS_ANNOUNCEMENT_COLOR = colors.gray
				--OS_BAR_DESIGN = "-======["..formattedTime.."]======-"
				--OS_BAR_BOTTOM_DESIGN = "-o================o-"
				elseif settings.getVariable("system/settings","theme") == "custom" then
				OS_GUI_COLOR = tonumber(settings.getVariable("system/libraries/theme/theme.birchtheme","OS_DEFAULTBACKGROUNDCOLOR"))
				OS_TEXT_COLOR = tonumber(settings.getVariable("system/libraries/theme/theme.birchtheme","OS_DEFAULTTEXTCOLOR"))
				OS_WELCOME_COLOR = tonumber(settings.getVariable("system/libraries/theme/theme.birchtheme","OS_LOGINSCREEN_WELCOMECOLOR"))
				OS_STARTMENU_SHUTDOWNCOLOR = tonumber(settings.getVariable("system/libraries/theme/theme.birchtheme","OS_STARTMENU_SHUTDOWNCOLOR"))
				OS_STARTMENU_LOGOUTCOLOR = tonumber(settings.getVariable("system/libraries/theme/theme.birchtheme","OS_STARTMENU_LOGOUTCOLOR"))
				OS_STARTMENU_REBOOTCOLOR = tonumber(settings.getVariable("system/libraries/theme/theme.birchtheme","OS_STARTMENU_REBOOTCOLOR"))
				OS_STARTMENU_COLOR = tonumber(settings.getVariable("system/libraries/theme/theme.birchtheme","OS_STARTMENU_COLOR"))
				OS_CMD_COLOR = tonumber(settings.getVariable("system/libraries/theme/theme.birchtheme","OS_CMD_BGCOLOR"))
				OS_ANNOUNCEMENT_COLOR = tonumber(settings.getVariable("system/libraries/theme/theme.birchtheme","OS_ANNOUNCEMENT_COLOR"))
				--OS_BAR_DESIGN = "-======["..formattedTime.."]======-"
				--OS_BAR_BOTTOM_DESIGN = "~o================o~"
			elseif settings.getVariable("system/settings","theme") == "basic" then
				OS_GUI_COLOR = colors.white
				OS_TEXT_COLOR = colors.black
				OS_WELCOME_COLOR = colors.black
				OS_STARTMENU_SHUTDOWNCOLOR = colors.gray
				OS_STARTMENU_LOGOUTCOLOR = colors.gray
				OS_STARTMENU_REBOOTCOLOR = colors.gray
				OS_STARTMENU_COLOR = colors.lightGray
				OS_CMD_COLOR = colors.black
				OS_ANNOUNCEMENT_COLOR = colors.gray
				settings.setVariable("system/settings","terminalcolor","1")
			end
			loginscreen()
		end
	end
end
boot()
