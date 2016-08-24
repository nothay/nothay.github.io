birch.run("rom/programs/clear")
local arg = {...}
--os.loadAPI("system/api/edge")
if birch.release == true then
	os.pullEvent = os.pullEventRaw
end
birch.oldUI = false
l = 0
local installupdate = false
local osstate = ""
local edge_boot_dir = "sys16/edge/"
local OS_SYSTEM_VERSION = birch.osversion
local OS_SYSTEM_CREATOR = "BIRCH"
local OS_SHUTDOWN_MESSAGE = "SHUTTING DOWN"
local OS_REBOOT_MESSAGE = "REBOOTING"
local OS_UNLOCKED = settings.getVariable("system/settings","unlock")
local OS_ROOTLOGIN = false
local OS_BINARYBOOTCODE = settings.getVariable("system/settings","bootcode")
local OS_BINARYBOOTCODE_CHECK = "01000001"
local OS_ADMINLOGIN_PASSWORD = "01011"
local OS_SYSTEM_PREBOOT_VENDOR = ""
local bootPart = 0
 -- This is seriously not a good method for rendering the menu system, it looks cool though.
local CTHEME = tonumber(settings.getVariable("system/libraries/theme/theme.birchtheme","OS_DEFAULTBACKGROUNDCOLOR"))
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
function desktop()

	osstate = "desktop"
	term.clear()
	birch.systemcheck()
	shell.run("clear")
	edge.xprint(">",1,9,OS_TEXT_COLOR)
	edge.xprint("<",51,9,OS_TEXT_COLOR)
	edge.xprint("v",1,1,OS_TEXT_COLOR)
	edge.xprint(birch.osstate,1,2,OS_TEXT_COLOR)
	edge.xprint("c",51,1,OS_TEXT_COLOR)
	edge.xprint("u",term.getSize() / 2, 18,OS_TEXT_COLOR)
	if settings.getVariable("system/settings","autoupdate") == "true" and birch.release == true then
		v = http.get("http://pastebin.com/raw/4eM5vjvk")
		a = v.readAll()
		if tostring(a) == tostring(birch.osversion) then
			birch.sysLog("BirchOS is up to date.")
		else
			birch.sysLog("Updates to be installed on shutdown.")
			term.setTextColor(colors.green)
			edge.cprint("System update will install on shutdown.",2)
			term.setTextColor(OS_TEXT_COLOR)
			installupdate = true
		end
	elseif settings.getVariable("system/settings","autoupdate") == "true" and birch.release == false then
		--term.setTextColor(colors.red)
		--edge.cprint("UpdNotif Unavailable in this version",2)
		--edge.cprint("Disable in: settings>updates",3)
		--term.setTextColor(OS_TEXT_COLOR)
		edge.render(term.getSize() / 2 - 10,5,term.getSize() / 2 + 12,10,colors.cyan,OS_GUI_COLOR," Unhandled Exception")
		edge.render(term.getSize() /2 -8,7,term.getSize() / 2 + 1, 7,colors.cyan,OS_GUI_COLOR,"Could not get version")
		edge.render(term.getSize() /2 -8,8,term.getSize() / 2 +1 , 8, colors.cyan,OS_GUI_COLOR,"UpdNotif disabled.")
		edge.render(term.getSize() /2 -8,9,term.getSize() / 2 +1 , 9, colors.cyan,OS_GUI_COLOR,"ERR:0x3 InvalidUPD")
		edge.render(term.getSize() /2 - 1, 10, term.getSize() / 2 + 0, 10, colors.gray,OS_GUI_COLOR,"OK.")
		while(true) do
			local event, button, x, y = os.pullEvent("mouse_click")
			if x >= term.getSize() / 2 - 1 and x <= term.getSize() / 2 + 0 and y == 10 then
				settings.setVariable("system/settings","autoupdate","false")
				desktop()
			end
		end
	end

	while(true) do

		if settings.getVariable("system/settings","timeformat") == "12" then
			--edge.xtime(42,1)
			edge.xtime(term.getSize() / 2 - 3,1)
		else
			edge.xtime(term.getSize() / 2 - 3,1)
		end
		local event, button, x, y = os.pullEvent("mouse_click")
		if birch.oldUI == true then
			edge.xprint(x.." "..y.."    ",1,1,colors.red)
			edge.xprint("x",x,y,colors.red)
		end
		if x == 25 and y == 18 then
			edge.render(16,5,34,19,OS_STARTMENU_COLOR,OS_GUI_COLOR,"v")
			while(true) do
				local event, button, x, y = os.pullEvent("mouse_click")
				if x == 16 and y == 5 then
					desktop()
				end
			end
		end
		if x == 51 and y == 1 and button == 1 or button == 2 then
			commandline()
		end
    if x == 1 and y == 1 then
      edge.render(1,1,15,6,OS_STARTMENU_COLOR,OS_GUI_COLOR,"x Quick Sett.")
      edge.render(3,3,13,3,colors.gray,OS_GUI_COLOR,"Update")
      edge.render(3,5,13,5,colors.gray,OS_GUI_COLOR,"Fac. Reset")
      --local event, button, x, y = os.pullEvent("mouse_click")
      while(true) do
        local event, button, x, y = os.pullEvent("mouse_click")
        if x == 1 and y == 1 then
          desktop()
        end
				if x >= 3 and x <= 13 and y == 3 then
          shell.run("pastebin get eMqb3wXt")
        end
        if x >= 3 and x <= 13 and y == 5 then
          edge.render(3,5,13,5,colors.green,OS_GUI_COLOR,"Working..")
          settings.setVariable("system/settings","theme","bright")
          settings.setVariable("system/settings","loginkey","nil")
          settings.setVariable("system/settings","username","nil")
          settings.setVariable("system/settings","debug","false")
					settings.setVariable("system/settings","autoupdate","true")
          fs.delete("system/desktopcfg")
          sleep(2)
          os.reboot()
        end
      end
    end
		if x == 51 and y == 9 and button == 1 then
			edge.render(37,1,51,19,OS_STARTMENU_COLOR,OS_GUI_COLOR,"")
			edge.render(51,8,51,8,OS_STARTMENU_COLOR,OS_GUI_COLOR,"+")
			edge.render(51,10,51,10,OS_STARTMENU_COLOR,OS_GUI_COLOR,"+")
			edge.render(39,2,50,2,OS_STARTMENU_COLOR,OS_GUI_COLOR,"Day: "..os.day())
			edge.render(39,4,49,4,colors.gray,OS_GUI_COLOR,"VirtualOS")
			edge.render(39,6,49,6,colors.gray,OS_GUI_COLOR,"New file")
			if fs.exists(tostring(settings.getVariable("system/desktopcfg","customprogram"))) then
				if tostring(settings.getVariable("system/desktopcfg","customprogram")) == "system/libraries/bootloader" then
					edge.render(39,8,49,8,colors.gray,OS_GUI_COLOR,"SettEdit")
				elseif tostring(settings.getVariable("system/desktopcfg","customprogram")) == "system/os.lua" then
					edge.render(39,8,49,8,colors.gray,OS_GUI_COLOR,"Kernel")
				elseif tostring(settings.getVariable("system/desktopcfg","customprogram")) == "system/desktop_test.lua" then
					edge.render(39,8,49,8,colors.gray,OS_GUI_COLOR,"Desktop")
				else
					edge.render(39,8,49,8,colors.gray,OS_GUI_COLOR,string.sub(settings.getVariable("system/desktopcfg","customprogram"),-8,-5))
				end
			end
			if fs.exists(tostring(settings.getVariable("system/desktopcfg","customprogramtwo"))) then
				if settings.getVariable("system/desktopcfg","customprogramtwo") == "system/libraries/bootloader" then
					edge.render(39,10,49,10,colors.gray,OS_GUI_COLOR,"SettEdit")
				elseif tostring(settings.getVariable("system/desktopcfg","customprogramtwo")) == "system/os.lua" then
					edge.render(39,10,49,10,colors.gray,OS_GUI_COLOR,"Kernel")
				elseif tostring(settings.getVariable("system/desktopcfg","customprogramtwo")) == "system/desktop_test.lua" then
					edge.render(39,10,49,10,colors.gray,OS_GUI_COLOR,"Desktop")
				elseif tostring(settings.getVariable("system/desktopfcg","customprogramtwo")) == "system/libraries/update/temp" then
					edge.render(39,10,49,10,colors.gray,OS_GUI_COLOR,"Update")
				else
					edge.render(39,10,49,10,colors.gray,OS_GUI_COLOR,string.sub(settings.getVariable("system/desktopcfg","customprogramtwo"),1,-5))
				end
			end
			--edge.xtime(38,4)
			edge.xprint(">",36,9,OS_TEXT_COLOR)

			while(1 + 1 == 2) do
				local event, button, x, y = os.pullEvent("mouse_click")
				if x == 51 and y == 8 then
					edge.render(39,8,49,8,colors.white,OS_GUI_COLOR,"")
					term.setCursorPos(39,8)
					term.setTextColor(colors.black)
					local customp = io.read()
					settings.setVariable("system/desktopcfg","customprogram",customp)
					edge.render(39,8,49,8,colors.white,OS_GUI_COLOR,"Program set")
				end
				if x == 51 and y == 10 then
					edge.render(39,10,49,10,colors.white,OS_GUI_COLOR,"")
					term.setCursorPos(39,10)
					term.setTextColor(colors.black)
					local customp = io.read()
					settings.setVariable("system/desktopcfg","customprogramtwo",customp)
					edge.render(39,10,49,10,colors.white,OS_GUI_COLOR,"Program set")
				end
				if settings.getVariable("system/settings","debug") == "false" then
					os.setComputerLabel("[BirchOS "..settings.getVariable("system/settings","username").."]")
				else
					os.setComputerLabel("x:"..x.." , y:"..y)
				end
				if x == 36 and y == 9 then
					desktop()
				end
				if x >= 39 and x <= 49 and y == 4 then
					virtualos()
				end
				if x >= 39 and x <= 49 and y == 8 then
					if fs.exists(settings.getVariable("system/desktopcfg","customprogram")) or not settings.getVariable("system/settings","customprogram") == "" then
						shell.run(tostring(settings.getVariable("system/desktopcfg","customprogram")))
					end
				end
				if x >= 39 and x <= 49 and y == 10 then
					if fs.exists(settings.getVariable("system/desktopcfg","customprogramtwo")) or not settings.getVariable("system/settings","customprogramtwo") == "" then
						shell.run(tostring(settings.getVariable("system/desktopcfg","customprogramtwo")))
					end
				end
				if x >= 39 and x <= 49 and y == 6 then
					edge.render(39,6,49,6,colors.white,OS_GUI_COLOR,"")
					term.setCursorPos(39,6)
					term.setTextColor(colors.black)
					local file = io.read()
					local cfile = fs.open(file,"w")
					cfile.close()
					term.setTextColor(colors.white)
					shell.run("edit "..file)
					return desktop()
				end
			end
		end
		if x == 1 and y == 9 and button == 1 then
			-- search function
			edge.xprint("<",16,9,OS_TEXT_COLOR)
			edge.render(1,1,15,19,OS_STARTMENU_COLOR,OS_GUI_COLOR,"     Start")
			edge.render(3,3,13,3,colors.white,OS_GUI_COLOR,"Run..")
			edge.render(3,5,13,5,colors.gray,OS_GUI_COLOR,"Monitor")
			edge.render(3,7,13,7,colors.gray,OS_GUI_COLOR,"Info")
			edge.render(3,9,13,9,colors.gray,OS_GUI_COLOR,"Settings")
			edge.render(3,14,13,14,OS_STARTMENU_SHUTDOWNCOLOR,OS_GUI_COLOR,"Shut down")
			edge.render(3,16,13,16,OS_STARTMENU_LOGOUTCOLOR,OS_GUI_COLOR,"Log out")
			edge.render(3,18,13,18,OS_STARTMENU_REBOOTCOLOR,OS_GUI_COLOR,"Reboot")
			--term.setCursorPos(3,3)
			--term.setTextColor(colors.black)
			--searhquery = io.read()
			--term.setTextColor(colors.white)
			while(true) do
				local event, button, x, y = os.pullEvent("mouse_click")
        if x >= 3 and x <= 13 and y == 14 then
          shell.run("clear")
					if installupdate == true then

						shell.run("clear")
						term.setBackgroundColor(OS_GUI_COLOR)
						term.setTextColor(OS_TEXT_COLOR)
						printcenter("Installing system updates..",10)

						a = http.get("https://www.dropbox.com/s/u8ybnccylnqj3a2/os.lua?dl=1")
						b = fs.open("system/os.lua","w")
						b.write(a.readAll())
						b.close()
						a.close()

						local a = http.get("https://www.dropbox.com/s/5zzs9v9s5ez3w3y/startup?dl=1")
						local b = fs.open("startup","w")
						b.write(a.readAll())
						b.close()
						a.close()

						a = http.get("https://www.dropbox.com/s/darz4juxx07fmd4/birch?dl=1")
						b = fs.open("system/api/birch","w")
						b.write(a.readAll())
						b.close()
						a.close()

						local a = http.get("https://www.dropbox.com/s/wa8gweawmj6cbk2/edge?dl=1")
						local b = fs.open("system/api/edge","w")
						b.write(a.readAll())
						b.close()
						a.close()

						local a = http.get("https://www.dropbox.com/s/r3lxdp53optt0eq/network?dl=1")
						local b = fs.open("system/api/network","w")
						b.write(a.readAll())
						b.close()
						a.close()

						local a = http.get("https://www.dropbox.com/s/tb22kn8fnfwa1wm/operation?dl=1")
						local b = fs.open("system/api/operation","w")
						b.write(a.readAll())
						b.close()
						a.close()

						local a = http.get("https://www.dropbox.com/s/j1sq88cd3e7e8mj/sc?dl=1")
						local b = fs.open("system/api/sc","w")
						b.write(a.readAll())
						b.close()
						a.close()

						local a = http.get("https://www.dropbox.com/s/9raac5zaeml1pt6/settings?dl=1")
						local b = fs.open("system/api/settings","w")
						b.write(a.readAll())
						b.close()
						a.close()

						local a = http.get("https://www.dropbox.com/s/o8xmqj5nfyqywuj/theme.birchtheme?dl=1")
						local b = fs.open("system/libraries/theme/theme.birchtheme","w")
						b.write(a.readAll())
						b.close()
						a.close()

						if fs.exists("system/libraries/update/temp") then
						  fs.delete("system/libraries/update/temp")
						end
						if fs.exists("system/log.txt") then
						  fs.delete("system/log.txt")
						end

						sleep(0.5)
						shell.run("clear")
						printcenter("Shutting down..",10)
						sleep(3)
						os.shutdown()
					else
						shell.run("clear")
						term.setBackgroundColor(OS_GUI_COLOR)
						term.setTextColor(OS_TEXT_COLOR)
						printcenter("Shutting down..",10)
						sleep(3)
						os.shutdown()
					end
        end
				if x >= 3 and x <= 13 and y == 7 then
					edge.render(1,1,15,19,OS_STARTMENU_COLOR,OS_GUI_COLOR,"     Info")
					birch.sysLog("Rendering")
					--edge.render(3,3,13,3,colors.gray,OS_GUI_COLOR,"< BACK")
					edge.render(3,3,13,3,colors.gray,OS_GUI_COLOR,"System")
					edge.render(3,5,13,5,colors.gray,OS_GUI_COLOR,"Edition")
					edge.render(3,7,13,7,colors.gray,OS_GUI_COLOR,"Advanced")
					while(true) do
						local event, button, x, y = os.pullEvent("mouse_click")
							if x == 16 and y == 9 then
								desktop()
							end
							if x >= 3 and x <= 13 and y == 7 then
								edge.render(16,1,52,19,colors.gray,OS_GUI_COLOR,"   Advanced Information")
								edge.render(17,3,25,3,colors.gray,OS_GUI_COLOR,"BirchOS_Amethyst "..tostring(birch.osversion))
								edge.render(17,5,25,3,colors.gray,OS_GUI_COLOR,"BirchAPI version: "..tostring(birch.apiversion))
								edge.render(17,7,25,3,colors.gray,OS_GUI_COLOR,"EdgeAPI version: "..tostring(edge.version))
								if fs.exists("system/libraries") then
									edge.render(17,9,25,9,colors.gray,OS_GUI_COLOR,"Libraries: OK")
								else
									edge.render(17,9,25,9,colors.gray,OS_GUI_COLOR,"Libraries: NOT FOUND")
								end
								if fs.exists("system/api") then
									edge.render(17,11,25,11,colors.gray,OS_GUI_COLOR,"APIs: OK")
								else
									edge.render(17,11,25,11,colors.gray,OS_GUI_COLOR,"APIs: NOT FOUND")
								end
								if fs.exists("system/") then
									edge.render(17,13,25,13,colors.gray,OS_GUI_COLOR,"System: OK")
								else
									edge.render(17,13,25,13,colors.gray,OS_GUI_COLOR,"System: NOT FOUND")
								end
								if fs.getFreeSpace("") / 1024 <= 1 then
									edge.render(17,15,25,3,colors.gray,OS_GUI_COLOR,"Free space: "..tostring(math.floor(fs.getFreeSpace("/")/1024)).."KB [Low]")
								else
									edge.render(17,15,25,3,colors.gray,OS_GUI_COLOR,"Free space: "..tostring(math.floor(fs.getFreeSpace("/")/1024)).."KB")
								end
								if fs.exists("system/") and fs.exists("system/api") and fs.exists("system/libraries") and fs.exists("startup") then
									if birch.release == true or birch.release == false then
										v = http.get("http://pastebin.com/raw/4eM5vjvk")
										a = v.readAll()
										if not tostring(a) == birch.osversion then
											edge.render(17,18,25,3,colors.gray,OS_GUI_COLOR,"System state: Outdated")
										else
											edge.render(17,18,25,3,colors.gray,OS_GUI_COLOR,"System state: Healthy")
										end
									else
										edge.render(17,18,25,3,colors.gray,OS_GUI_COLOR,"System state: Healthy")
									end
								else
									edge.render(17,18,25,3,colors.gray,OS_GUI_COLOR,"System state: Missing files")
								end
								edge.xprint("<",16,9,OS_TEXT_COLOR)
							end
							if x >= 3 and x <= 13 and y == 3 then
								edge.render(16,1,52,19,colors.gray,OS_GUI_COLOR,"   System Information")
								edge.render(17,3,25,3,colors.gray,OS_GUI_COLOR,"System version: "..tostring(birch.osversion))
								edge.render(17,5,25,3,colors.gray,OS_GUI_COLOR,"BirchAPI version: "..tostring(birch.apiversion))
								edge.render(17,7,25,3,colors.gray,OS_GUI_COLOR,"EdgeAPI version: "..tostring(edge.version))
								edge.render(17,11,25,3,colors.gray,OS_GUI_COLOR,"Username: "..tostring(settings.getVariable("system/settings","username")))
								if fs.getFreeSpace("") / 1024 <= 1 then
									edge.render(17,15,25,3,colors.gray,OS_GUI_COLOR,"Free space: "..tostring(math.floor(fs.getFreeSpace("/")/1024)).."KB [Low]")
								else
									edge.render(17,15,25,3,colors.gray,OS_GUI_COLOR,"Free space: "..tostring(math.floor(fs.getFreeSpace("/")/1024)).."KB")
								end
								if fs.exists("system/") and fs.exists("system/api") and fs.exists("system/libraries") and fs.exists("startup") then
									edge.render(17,18,25,3,colors.gray,OS_GUI_COLOR,"System: Healthy")
								else
									edge.render(17,18,25,3,colors.gray,OS_GUI_COLOR,"System: Damaged")
								end
								edge.xprint("<",16,9,OS_TEXT_COLOR)
							end
							if x >= 3 and x <= 13 and y == 5 then
								edge.render(16,1,52,19,colors.gray,OS_GUI_COLOR,"   System Edition")
								edge.render(17,3,25,3,colors.gray,OS_GUI_COLOR,"Amethyst Home Edition")
								edge.render(17,18,25,18,colors.gray,OS_GUI_COLOR,"BirchOS by Nothy")
								edge.xprint("<",16,9,OS_TEXT_COLOR)
							end
							if x == 4 and y == 1 then
								edge.render(16,1,52,19,colors.gray,OS_GUI_COLOR,"     OS3x BETA")
								edge.render(23,6,35,6,colors.gray,OS_GUI_COLOR,"OS3x BETA CODE:")
								edge.render(25,7,35,7,colors.white,OS_GUI_COLOR,"")
								edge.xprint("<",16,9,OS_TEXT_COLOR)
								while(true) do
										local event, button, x, y = os.pullEvent("mouse_click")
										if x == 16 and y == 9 then
											desktop()
										end
										if x >= 25 and x <= 34 and y == 7 then
											edge.render(25,7,35,7,colors.white,OS_GUI_COLOR,"")
											term.setCursorPos(25,7)
											term.setTextColor(colors.black)
											code = io.read()
											if code == "JGGR3" or code == "uBR6X" or code == "KAZ6v" or code == "QXL2q" or code == "3WgkK" then

												end
											end
									end
							end
					end
					--edge.render(15,1,52,19,colors.gray,OS_GUI_COLOR," System information")
				end
				if x == 16 and y == 9 then
					desktop()
				end
				if x >= 3 and x <= 13 and y == 16 then
					OS_LOGIN_SCREEN()
				end
				if x >= 3 and x <= 13 and y == 18 then
						os.reboot()
				end
				if x >= 3 and x <= 13 and y == 9 then
					--shell.run("clear")
					edge.render(1,1,15,19,OS_STARTMENU_COLOR,OS_GUI_COLOR,"  Settings")
					edge.render(3,3,13,3,colors.gray,OS_GUI_COLOR,"Theme")
					edge.render(3,5,13,5,colors.gray,OS_GUI_COLOR,"Password")
					edge.render(3,7,13,7,colors.gray,OS_GUI_COLOR,"Username")
					edge.render(3,9,13,9,colors.gray,OS_GUI_COLOR,"Updates")
          edge.render(3,11,13,11,colors.gray,OS_GUI_COLOR,"Time")
					--edge.render(3,9,13,9,colors.gray,OS_GUI_COLOR,"TestSetting2")
					edge.render(3,14,13,14,OS_STARTMENU_SHUTDOWNCOLOR,OS_GUI_COLOR,"Shut down")
					edge.render(3,16,13,16,OS_STARTMENU_LOGOUTCOLOR,OS_GUI_COLOR,"Log out")
					edge.render(3,18,13,18,OS_STARTMENU_REBOOTCOLOR,OS_GUI_COLOR,"Reboot")
					edge.render(16,9,16,9,OS_GUI_COLOR,OS_GUI_COLOR,"<")
					while(true) do
						local event, button, x, y = os.pullEvent("mouse_click")
						if x == 16 and y == 9 then
							desktop()
							birch.sysLog("User closed MenuItem1")
						end
						if x >= 3 and y <= 13 and y == 14 then
								os.shutdown()
						end
						if x >= 3 and x >= 13 and y == 16 then
              OS_LOGIN_SCREEN()
						end
						if x >= 3 and x <= 13 and y == 18 then
								os.reboot()
						end
            if x >= 3 and x <= 13 and y == 11 then
              edge.render(1,1,15,19,OS_STARTMENU_COLOR,OS_GUI_COLOR," Time Settings")
              edge.render(3,3,13,3,colors.gray,OS_GUI_COLOR,"12-hour")
              edge.render(3,5,13,5,colors.gray,OS_GUI_COLOR,"24-hour")
              edge.xprint("<",16,9,colors.black)
              while(true) do
								local event, button, x, y = os.pullEvent("mouse_click")
                if x >= 3 and x <= 13 and y == 3 then
                  settings.setVariable("system/settings","timeformat","12")
                  edge.render(3,3,13,3,colors.green,OS_GUI_COLOR,"12-hour")
                end
                if x >= 3 and x <= 13 and y == 5 then
                  settings.setVariable("system/settings","timeformat","24")
                  edge.render(3,5,13,5,colors.green,OS_GUI_COLOR,"24-hour")
                end
                if x == 16 and y == 9 then
                  desktop()
                end
              end
            end
						if x >= 3 and x <= 13 and y == 9 then
							edge.render(1,1,15,19,OS_STARTMENU_COLOR,OS_GUI_COLOR,"   Updates")
							edge.render(2,3,13,3,OS_STARTMENU_COLOR,OS_GUI_COLOR,"Install:")
							edge.render(3,5,13,5,colors.gray,OS_GUI_COLOR,"Latest")
							edge.render(3,7,13,7,colors.gray,OS_GUI_COLOR,"Unreleased")
							edge.render(2,9,13,9,OS_STARTMENU_COLOR,OS_GUI_COLOR,"Update Notif.")
							edge.render(3,10,13,10,colors.gray,OS_GUI_COLOR,"Enable")
							edge.render(3,12,13,12,colors.gray,OS_GUI_COLOR,"Disable")
							while(true) do
								local event, button, x, y = os.pullEvent("mouse_click")

								if x == 16 and y == 9 then
									desktop()
								end
								if x >= 3 and x <= 13 and y == 10 then
									settings.setVariable("system/settings","autoupdate","true")
								end
								if x >= 3 and x <= 13 and y == 12 then
									settings.setVariable("system/settings","autoupdate","false")
								end
								if x >= 3 and x <= 13 and y == 5 then
									shell.run("pastebin run eMqb3wXt")
								end
								if x >= 3 and x <= 13 and y == 7 then
									shell.run("pastebin run eMqb3wXt exp")
								end
							end
						end
						if x >= 3 and x <= 13 and y == 5 then
							edge.render(3,5,13,5,colors.white,colors.white,"")
							term.setCursorPos(3,5)
							term.setTextColor(colors.black)
							newp = read("*")
							settings.setVariable("system/settings","loginkey",newp)
							desktop()
						end
						if x >= 3 and x <= 13 and y == 3 then
							edge.render(1,1,15,19,OS_STARTMENU_COLOR,OS_GUI_COLOR,"   Theme")
							edge.render(2,3,15,3,OS_STARTMENU_COLOR,OS_GUI_COLOR,"Pick a theme:")
							edge.render(3,5,13,5,colors.gray,OS_GUI_COLOR,"Dark")
							edge.render(3,7,13,7,colors.white,OS_GUI_COLOR,"Bright")
							edge.render(3,9,13,9,CTHEME,OS_GUI_COLOR,"Custom")
							if settings.getVariable("system/settings","theme") == "bright" then
								edge.render(14,7,14,7,OS_STARTMENU_COLOR,OS_GUI_COLOR,"<")
							end
							if settings.getVariable("system/settings","theme") == "dark" then
								edge.render(14,5,14,5,OS_STARTMENU_COLOR,OS_GUI_COLOR,"<")
							end
							if settings.getVariable("system/settings","theme") == "custom" then
								edge.render(14,9,14,9,OS_STARTMENU_COLOR,OS_GUI_COLOR,"<")
							end
							--edge.render(3,11,13,11,colors.gray,OS_GUI_COLOR,"Edit Custom")
							while(true) do
								local event, button, x, y = os.pullEvent("mouse_click")
								if x == 16 and y == 9 then
									desktop()
								end

								if x >= 3 and x <= 13 and y == 9 then  --x == 3 and y == 9 or x == 4 and y == 9 or x == 5 and y == 9 or x == 6 and y == 9 or x == 7 and y == 9 or x == 8 and y == 9 or x == 9 and y == 9 or x == 10 and y == 9 or x == 11 and y == 9 or x == 12 and y == 9 or x == 13 and y == 9 then
									settings.setVariable("system/settings","theme","custom")
									edge.render(3,9,13,9,CTHEME,OS_GUI_COLOR,"Theme set!")
									end
								if x >= 3 and x <= 13 and y == 5 then -- x == 3 and y == 5 or x == 4 and y == 5 or x == 5 and y == 5 or x == 6 and y == 5 or x == 7 and y == 5 or x == 8 and y == 5 or x == 9 and y == 5 or x == 10 and y == 5 or x == 11 and y == 5 or x == 12 and y == 5 or x == 13 and y == 5 then
									settings.setVariable("system/settings","theme","dark")
									edge.render(3,5,13,5,colors.gray,OS_GUI_COLOR,"Theme set!")
								end
								if x >= 3 and x <= 13 and y == 7 then -- x == 3 and y == 7 or x == 4 and y == 7 or x == 5 and y == 7 or x == 6 and y == 7 or x == 7 and y == 7 or x == 8 and y == 7 or x == 9 and y == 7 or x == 10 and y == 7 or x == 11 and y == 7 or x == 12 and y == 7 or x == 13 and y == 7 then
									settings.setVariable("system/settings","theme","bright")
									edge.render(3,7,13,7,colors.white,OS_GUI_COLOR,"Theme set!")
								end
								if x >= 3 and x <= 13 and y == 11 then -- x == 3 and y == 11 or x == 4 and y == 11 or x == 5 and y == 11 or x == 6 and y == 11 or x == 7 and y == 11 or x == 8 and y == 11 or x == 9 and y == 11 or x == 10 and y == 11 or x == 11 and y == 11 or x == 12 and y == 7 or x == 13 and y == 11 then
									edge.render(15,1,52,19,colors.gray,OS_GUI_COLOR,"  Edit Theme")
									edge.xprint("WIP",20,5,colors.red)
									sleep(5)
									desktop()
								end
							end

						end
						if x >= 3 and x <= 13 and y == 7 then  -- x == 3 and y == 7 or x == 4 and y == 7 or x == 5 and y == 7 or x == 6 and y == 7 or x == 7 and y == 7 or x == 8 and y == 7 or x == 9 and y == 7 or x == 10 and y == 7 or x == 11 and y == 7 or x == 12 and y == 7 or x == 13 and y == 7 then
							edge.render(3,7,13,7,colors.white,colors.white,"")
							term.setCursorPos(3,7)
							term.setTextColor(colors.black)
							usr = read()
							settings.setVariable("system/settings","username",usr)
							desktop()
						end
					end
				end
				if x >= 3 and x <= 13 and y == 5 then -- x == 3 and y == 5 or x == 4 and y == 5 or x == 5 and y == 5 or x == 6 and y == 5 or x == 7 and y == 5 or x == 8 and y == 5 or x == 9 and y == 5 or x == 10 and y == 5 or x == 11 and y == 5 or x == 12 and y == 5 or x == 13 and y == 5 then
					edge.render(3,5,13,5,colors.white,colors.white,"Side:")
					term.setCursorPos(3+5,5)
					term.setTextColor(colors.black)
					side = io.read()
					term.setTextColor(colors.white)
					if peripheral.isPresent(side) == true then
						shell.run("monitor "..side.." startup")
					else
						edge.render(3,5,13,5,colors.red,colors.white,"No monitor")
					end
				end
				if x >= 3 and x <= 13 and y == 3 then -- x == 3 and y == 3 or x == 4 and y == 3 or x == 5 and y == 3 or x == 6 and y == 3 or x == 7 and y == 3 or x == 8 and y == 3 or x == 9 and y == 3 or x == 10 and y == 3 or x == 11 and y == 3 or x == 12 and y == 3 or x == 13 and y == 3 then
					edge.render(3,3,13,3,colors.white,colors.white,"")
					term.setCursorPos(3,3)
					term.setTextColor(colors.black)

					searhquery = io.read()
					if searhquery == "home" then
						term.setTextColor(colors.white)
						return OS_DESKTOP()
					elseif searhquery == "log out" then
						return OS_LOGIN_SCREEN()
					elseif searhquery == "info" then
						return SYSTEM_INFO()
					elseif searhquery == "shut down" then
						birch.off()
					elseif searhquery == "restart" then
						birch.restart()
					elseif searhquery == "delete" then
						edge.render(3,3,13,3,colors.white,colors.white,"File:")
						term.setCursorPos(8,3)
						term.setTextColor(colors.black)
						local dir = io.read()
						edge.makeFile(dir)
						shell.run("rm "..dir)
					elseif searhquery == "cmd" then
						desktop() -- 420 blaze it
					elseif searhquery == "force oldUISys" then
						birch.oldUI = true
						return OS_DESKTOP()
					elseif searhquery == "force noBoot" then
						settings.setVariable("system/settings","disablebootan","true")
					elseif searhquery == "force Boot" then
						settings.setVariable("system/settings","disablebootan","false")
					elseif searhquery == "create" then
						edge.render(3,3,13,3,colors.white,colors.white,"Dir:")
						term.setCursorPos(7,3)
						term.setTextColor(colors.black)
						local dir = io.read()
						edge.makeFile(dir)
						shell.run("edit "..dir)
					elseif searhquery == "run" then
						edge.render(3,3,13,3,colors.white,colors.white,"Dir:")
						term.setCursorPos(7,3)
						term.setTextColor(colors.black)
						local dir = io.read()
						shell.run(dir)
					elseif searhquery == "command" then
						commandline()
					else
					term.setTextColor(colors.white)
					if searchquery == "update" or fs.exists(searhquery) then
						shell.run("edit "..searhquery)
						return desktop()
						else
						desktop()
					end
					--if x == 3 and y == 7
					--end
				end
			end
		end --????
		end
	end
end
function OS_LOGIN_SCREEN()
  osstate = "loginscreen"
	if fs.exists("system/crashlog") then
		if settings.getVariable("system/crashlog","crash") == "true" then
			term.setTextColor(colors.white)
			edge.render(1,1,42,5,OS_STARTMENU_COLOR,OS_GUI_COLOR,"[x] SYSTEM CRASH REPORT")
			edge.render(5,2,42,5,OS_STARTMENU_COLOR,OS_GUI_COLOR,"BirchOS has recently crashed due to")
			edge.render(5,3,42,5,OS_STARTMENU_COLOR,OS_GUI_COLOR,"missing files or errors in the system.")
			edge.render(5,4,42,5,OS_STARTMENU_COLOR,OS_GUI_COLOR,"Reason: "..tostring(settings.getVariable("system/crashlog","crash_reason")))
			term.setTextColor(OS_TEXT_COLOR)
			while(true) do
				local event, button, x, y = os.pullEvent("mouse_click")
				if x == 2 and y == 1 then
					settings.setVariable("system/crashlog","crash","false")
					OS_LOGIN_SCREEN()
				end
			end
		end
	end
	term.clear()
	birch.sysLog("Login screen loaded.")
	local time = os.time()
	if settings.getVariable("system/settings","timeformat") == "12" then
		formattedTime = textutils.formatTime(time, false)
	else
		formattedTime = textutils.formatTime(time, true)
	end
	local day = os.day()
  local sx = (term.getSize() - string.len("Username")) / 2 + 1
	shell.run("clear")
	local announ_url = http.get("http://pastebin.com/raw/9HMmGNiF")
	local t = announ_url.readAll()
	if tostring(t) == "-" then
		birch.sysLog("No announcement.")
	else
		term.setTextColor(OS_ANNOUNCEMENT_COLOR)
		edge.cprint(tostring(t),14)
		term.setTextColor(OS_TEXT_COLOR)
	end

  edge.render(51,1,51,1,OS_GUI_COLOR,OS_GUI_COLOR,"c")
  edge.render(49,1,49,1,OS_GUI_COLOR,OS_GUI_COLOR,"x")
	edge.render(sx,6,term.getSize() - string.len("Username") / 2,6,OS_GUI_COLOR,OS_GUI_COLOR,"Username")
	edge.render(term.getSize() / 2 - 8,7,term.getSize() / 2 + 9,7,colors.lightGray,OS_GUI_COLOR,"")
	edge.render(sx,8,term.getSize() - string.len("Password") / 2,8,OS_GUI_COLOR,OS_GUI_COLOR,"Password")
	edge.render(term.getSize() / 2 - 8,9,term.getSize() / 2 + 9,9,colors.lightGray,OS_GUI_COLOR,"")
	while(1) do
		local event, button, x, y = os.pullEvent("mouse_click")
    if x == 49 and y == 1 then
      birch.off()
    end
    if x == 51 and y == 1 then
      commandline()
    end
		if x >= 14 and x <= 37 and y == 7 then -- x == 14 and y == 7 or x == 18 and y == 7 or x == 19 and y == 7 or x == 20 and y == 7 or x == 21 and y == 7 or x == 22 and y == 7 or x == 23 and y == 7 or x == 24 and y == 7 or x == 25 and y == 7 or x == 26 and y == 7 or x == 27 and y == 7 then
			edge.render(term.getSize() / 2 - 8,7,term.getSize() / 2 -1 + 10,7,colors.lightGray,OS_GUI_COLOR,"")
			term.setCursorPos(term.getSize() / 2 - 8,7)
			term.setBackgroundColor(colors.lightGray)
			term.setTextColor(colors.black)

			username = io.read()
			if username == string.lower("theflamingsky") or username == string.lower("Nothy") then
				edge.xprint("This user is banned.",1,1,colors.red)
				sleep(5)
				fs.delete("system/api/edge")
				fs.delete("system/api/operation")
				birch.crash("UNHANDLED EXCEPTION")
			end
			if username == "root_nocredentials" then
				edge.render(term.getSize() / 2 - 8,8,term.getSize() / 2 -1 + 12,8,OS_STARTMENU_COLOR,OS_GUI_COLOR,"Password")
				edge.render(term.getSize() / 2 - 8,9,term.getSize() / 2 + 10,9,colors.lightGray,OS_GUI_COLOR,"")
				term.setCursorPos(term.getSize() / 2 -8 ,9)
				term.setTextColor(colors.black)
				p = read("*")
				if p == "root_sysLoginAdm" then
					desktop()
				else
					edge.render(term.getSize() / 2 - 8,9,term.getSize() / 2 -1 + 10,9,colors.red,OS_GUI_COLOR,"")
				end
			end
			if username == settings.getVariable("system/settings","username") then
				if settings.getVariable("system/settings","loginkey") == "nil" or settings.getVariable("system/settings","loginkey") == "" or settings.getVariable("system/settings","loginkey") == nil then
					term.setBackgroundColor(OS_GUI_COLOR)
					desktop()
				end
				--edge.render(term.getSize() / 2 - 8,8,term.getSize() / 2 + 12,8,OS_GUI_COLOR,OS_GUI_COLOR,"Password")
				edge.render(term.getSize() / 2 - 8,9,term.getSize() / 2 -1 + 10,9,colors.lightGray,OS_GUI_COLOR,"")
				term.setCursorPos(term.getSize() / 2 -8 ,9)
				term.setTextColor(colors.black)
				term.setBackgroundColor(colors.lightGray)
				p = read("*")
				if p == settings.getVariable("system/settings","loginkey") then
					term.setBackgroundColor(OS_GUI_COLOR)
					desktop()
				else
					edge.render(term.getSize() / 2 - 8,9,term.getSize() / 2 + 10,9,colors.red,OS_GUI_COLOR,"")
				end
			else
				edge.render(term.getSize() / 2 - 8,7,term.getSize() / 2 + 10,7,colors.red,OS_GUI_COLOR,"")
			end
		end
	end
end
function virtualos()
	edge.render(1,1,15,19,OS_STARTMENU_COLOR,OS_GUI_COLOR," VirtualOS")
	edge.render(3,5,13,5,colors.gray,OS_GUI_COLOR,"Boot")
	while(true) do
		local event, button, x, y = os.pullEvent("mouse_click")
		if x >= 3 and x <= 13 and y == 5 then
			if fs.exists("system/libraries/virtualos/virtualos.lua") then
				shell.run("system/libraries/virtualos/virtualos.lua")
			else
				edge.render(term.getSize() / 2 - 10,5,term.getSize() / 2 + 12,10,colors.cyan,OS_GUI_COLOR," Uh oh!")
				edge.render(term.getSize() /2 -8,7,term.getSize() / 2 + 1, 7,colors.cyan,OS_GUI_COLOR,"BirchOS was unable")
				edge.render(term.getSize() /2 -8,8,term.getSize() / 2 +1 , 8, colors.cyan,OS_GUI_COLOR,"to load VirtualOS")
				edge.render(term.getSize() /2 -8,9,term.getSize() / 2 +1 , 9, colors.cyan,OS_GUI_COLOR,"ERR:0x1 NO LIB")
				edge.render(term.getSize() /2 - 1, 10, term.getSize() / 2 + 0, 10, colors.gray,OS_GUI_COLOR,"OK.")
				birch.sysLog("MissingLibraryException: VirtualOS libraries not found")
				while(true) do
					local event, button, x, y = os.pullEvent("mouse_click")
					if x >= term.getSize() / 2 - 1 and x <= term.getSize() / 2 + 0 and y == 10 then
						desktop()
					end
				end
			end
		end
	end
end
function commandline()
	if term.isColor() then
  	edge.render(1,1,51,2,colors.gray,OS_GUI_COLOR,"BA-Terminal")
	else
		edge.render(1,1,51,2,colors.gray,OS_GUI_COLOR,"Amethyst Basic Terminal")
		--birch.sysLog("Terminal is unfortunately unsupported.")
	end
  edge.render(1,2,51,19,colors.black,OS_GUI_COLOR,"")
  local line = 2
  while(true) do
  term.setBackgroundColor(colors.black)
	if line == 19 then
		edge.render(1,2,51,19,colors.black,OS_GUI_COLOR,"")
		line = 2
	end
  edge.xprint("root@Amethyst$:",1,line,tonumber(settings.getVariable("system/settings","terminalcolor")))
  term.setCursorPos(17,line)
  term.setTextColor(colors.lightGray)
  cmd = io.read()
  line = line + 1
  if cmd == "sudo apt-get lib-virtualos" then
      edge.xprint("sudo: Not yet implemented.",1,line,colors.green)
      line = line + 1
			edge.render(term.getSize() / 2 - 10,5,term.getSize() / 2 + 12,10,colors.cyan,OS_GUI_COLOR," Unhandled exception")
			edge.render(term.getSize() /2 -8,7,term.getSize() / 2 + 1, 7,colors.cyan,OS_GUI_COLOR,"An unknown error has")
			edge.render(term.getSize() /2 -8,8,term.getSize() / 2 +1 , 8, colors.cyan,OS_GUI_COLOR,"occured.")
			edge.render(term.getSize() /2 -8,9,term.getSize() / 2 +1 , 9, colors.cyan,OS_GUI_COLOR,"ERR:0x2 CMD-FAILED")
			edge.render(term.getSize() /2 - 1, 10, term.getSize() / 2 + 0, 10, colors.gray,OS_GUI_COLOR,"OK.")
			birch.sysLog("MissingLibraryException: VirtualOS libraries not found")
			while(true) do
				local event, button, x, y = os.pullEvent("mouse_click")
				if x >= term.getSize() / 2 - 1 and x <= term.getSize() / 2 + 0 and y == 10 then
					desktop()
				end
			end
	elseif cmd == "sudo get sysInternals.true_friends" then
		edge.xprint("I wouldn't hold my breath if I was you.",1,line,colors.red)
		line = line + 1
		edge.xprint("Cause I forget but I'll never forgive you.",1,line,colors.red)
		line = line + 1
		edge.xprint("Don't you know? Don't you know?",1,line,colors.red)
		line = line + 1
		edge.xprint("True friends stab you in the front!",1,line,colors.red)
		line = line + 1
	elseif cmd == "what is love?" then
		edge.xprint("A brick wall.",1,line,colors.green)
		line = line + 1
  elseif cmd == "apt-get lib-virtualos" then
    edge.xprint("apt-get: Command could not be completed without elevated rights",1,line,colors.green)
    line = line + 2
  elseif cmd == "login" then
    edge.xprint("login: Command could not be completed without elevated rights",1,line,colors.green)
    line = line + 2
  elseif cmd == "logout" then
    edge.xprint("logout: Command could not be completed without elevated rights",1,line,colors.green)
    line = line + 2
  elseif cmd == "sudo logout" then
    edge.xprint("Logging out..",1,line,colors.lightGray)
    osstate = "loginscreen"
    line = line + 1
    sleep(1)
    term.setBackgroundColor(OS_GUI_COLOR)
    term.setTextColor(OS_TEXT_COLOR)
    shell.run("clear")
    OS_LOGIN_SCREEN()
	elseif cmd == "redeem" then
		edge.render(1,1,52,19,colors.gray,OS_GUI_COLOR,"     PRO EDITION")
		edge.render(23,6,35,6,colors.gray,OS_GUI_COLOR,"PRO EDITION CODE:")
		edge.render(25,7,35,7,colors.white,OS_GUI_COLOR,"")
		edge.xprint("<",16,9,OS_TEXT_COLOR)
		while(true) do
				local event, button, x, y = os.pullEvent("mouse_click")
				if x == 16 and y == 9 then
					desktop()
				end
				if x >= 25 and x <= 34 and y == 7 then
					edge.render(25,7,35,7,colors.white,OS_GUI_COLOR,"")
					term.setCursorPos(25,7)
					term.setTextColor(colors.black)
					code = io.read()
					if code == "JGGR3" or code == "uBR6X" or code == "KAZ6v" or code == "QXL2q" or code == "3WgkK" or code == "C3E14" or code == "21265" or code == "586DE" or code == "9B358" then
							birch.downloadpro()
						end
					end
			end
  elseif cmd == "sudo login" then
    sleep(0.5)
    edge.xprint("Username:",1,line,colors.white)
    line = line + 1
    edge.xprint("Password:",1,line,colors.white)
    term.setCursorPos(10,line - 1)
    username = io.read()
    term.setCursorPos(10,line)
    password = read("*")
    line = line + 1
		if username == string.lower("theflamingsky") then
			edge.xprint("This user is banned.",1,line,colors.red)
		end
    if username == tostring(settings.getVariable("system/settings","username")) and password == tostring(settings.getVariable("system/settings","loginkey")) then
      osstate = "desktop"
      edge.xprint("Login successful!",1,line,colors.green)
      line = line + 1
    else
      osstate = "loginscreen"
      edge.xprint("Login failed.",1,line,colors.red)
      line = line + 1
    end
	elseif cmd == "repair" then
			edge.xprint("Downloading repair tool..",1,line,colors.green)
			file = http.get("http://www.pastebin.com/raw/eMqb3wXt")
			f = fs.open("repair","w")
			f.write(file.readAll())
			f.close()
			shell.run("repair")
	elseif cmd == "themeproperties" then
		local theme = fs.open("system/libraries/theme/theme.birchtheme","r")
		edge.xprint(theme.readAll(),1,line,colors.white)
		line = line + 10
		theme.close()
	elseif cmd == "factory-reset" then
    edge.xprint("factory-reset: Elevated rights required to perform a factory reset.",1,line,colors.green)
    line = line + 2
  elseif cmd == "sudo factory-reset" then
    if osstate == "loginscreen" then
      sleep(0.5)
      edge.xprint("Username:",1,line,colors.white)
      line = line + 1
      edge.xprint("Password:",1,line,colors.white)
      term.setCursorPos(10,line - 1)
      username = io.read()
      term.setCursorPos(10,line)
      password = read("*")
      line = line + 1
      if username == tostring(settings.getVariable("system/settings","username")) and password == tostring(settings.getVariable("system/settings","loginkey")) then
        osstate = "desktop"
        edge.xprint("Working..",1,line,colors.red)
        line = line + 1
				edge.xprint("Clearing settings..",1,line,colors.red)
				line = line + 1
        settings.setVariable("system/settings","theme","bright")
        settings.setVariable("system/settings","loginkey","nil")
        settings.setVariable("system/settings","username","nil")
        settings.setVariable("system/settings","debug","false")
        fs.delete("system/desktopcfg")
				if fs.exists("system/libraries/update") then
					edge.xprint("Clearing system/libraries",1,line,colors.red)
					line = line + 1
					fs.delete("system/libraries/update")
				end
				edge.xprint("Updating, please wait.",1,line,colors.white)
				line = line + 1
						if not term.isColor() then
						  printcenter("Birch OS Amethyst",8)
						  printcenter("Terminal not supported",10)
						  sleep(10)
						  os.reboot()
						end
						if not fs.exists("system/settings") then
						  if fs.getFreeSpace("/") <= 60000 then
						    shell.run("clear")
						    printcenter(math.floor(fs.getFreeSpace("/")/1024) .."KB out of required 80KB",9)
						    printcenter("Birch OS Amethyst",8)
						    printcenter("Not enough space on disk! :(",10)
						    sleep(10)
						    os.reboot()
						  end
						end

						if arg[1] == "exp" then
						  a = http.get("https://www.dropbox.com/s/8pb8ohxvkkxtz0j/os_unreleased.lua?dl=1")
						  b = fs.open("system/os.lua","w")
						elseif arg[1] == nil then
						  a = http.get("https://www.dropbox.com/s/u8ybnccylnqj3a2/os.lua?dl=1")
						  b = fs.open("system/os.lua","w")
						end
						b.write(a.readAll())
						b.close()
						a.close()

						--printcenter("BirchOS Amethyst",9)

						local a = http.get("https://www.dropbox.com/s/5zzs9v9s5ez3w3y/startup?dl=1")
						local b = fs.open("startup","w")
						b.write(a.readAll())
						b.close()
						a.close()
						if not fs.exists("system/settings") then
						  --printcenter("BirchOS Amethyst",9)
							edge.xprint("Downloading factory settings",1,line,colors.white)
							line = line + 1
						  local a = http.get("https://www.dropbox.com/s/3o5ztpmu79823kq/settings?dl=1")
						  local b = fs.open("system/settings","w")
						  b.write(a.readAll())
						  b.close()
						  a.close()

						end

						--printcenter("BirchOS Amethyst",9)

						if arg[1] == "exp" then
						  a = http.get("https://www.dropbox.com/s/da45aqm9h3h308v/birch_unreleased?dl=1")
						  b = fs.open("system/api/birch","w")
						elseif arg[1] == nil then
						  a = http.get("https://www.dropbox.com/s/darz4juxx07fmd4/birch?dl=1")
						  b = fs.open("system/api/birch","w")
						end
						b.write(a.readAll())
						b.close()
						a.close()

						local a = http.get("https://www.dropbox.com/s/wa8gweawmj6cbk2/edge?dl=1")
						local b = fs.open("system/api/edge","w")
						b.write(a.readAll())
						b.close()
						a.close()

						local a = http.get("https://www.dropbox.com/s/r3lxdp53optt0eq/network?dl=1")
						local b = fs.open("system/api/network","w")
						b.write(a.readAll())
						b.close()
						a.close()

						local a = http.get("https://www.dropbox.com/s/tb22kn8fnfwa1wm/operation?dl=1")
						local b = fs.open("system/api/operation","w")
						b.write(a.readAll())
						b.close()
						a.close()
						local a = http.get("https://www.dropbox.com/s/j1sq88cd3e7e8mj/sc?dl=1")
						local b = fs.open("system/api/sc","w")
						b.write(a.readAll())
						b.close()
						a.close()

						local a = http.get("https://www.dropbox.com/s/9raac5zaeml1pt6/settings?dl=1")
						local b = fs.open("system/api/settings","w")
						b.write(a.readAll())
						b.close()
						a.close()
						local a = http.get("https://www.dropbox.com/s/o8xmqj5nfyqywuj/theme.birchtheme?dl=1")
						local b = fs.open("system/libraries/theme/theme.birchtheme","w")
						b.write(a.readAll())
						b.close()
						a.close()
						edge.xprint("OK",1,line,colors.green)
						line = line + 1
						edge.xprint("Cleaning up..",1,line,colors.white)
						line = line + 1
						if fs.exists("system/libraries/update/temp") then
						  fs.delete("system/libraries/update/temp")
						end
						if fs.exists("system/log.txt") then
						  fs.delete("system/log.txt")
						end

        sleep(1)
        edge.xprint("Factory reset finished successfully!",1,line,colors.green)
        line = line + 1
				edge.xprint("You can restart now.",1,line,colors.green)
				line = line + 1
				osstate = "loginscreen"
      else
        osstate = "loginscreen"
        edge.xprint("Login failed. Reset not authorized.",1,line,colors.red)
        line = line + 1
      end
    else
			osstate = "desktop"
			edge.xprint("Working..",1,line,colors.red)
			line = line + 1
			edge.xprint("Clearing settings..",1,line,colors.red)
			line = line + 1
			settings.setVariable("system/settings","theme","bright")
			settings.setVariable("system/settings","loginkey","nil")
			settings.setVariable("system/settings","username","nil")
			settings.setVariable("system/settings","debug","false")
			fs.delete("system/desktopcfg")
			if fs.exists("system/libraries/update") then
				edge.xprint("Clearing system/libraries",1,line,colors.red)
				line = line + 1
				fs.delete("system/libraries/update")
			end
			sleep(1)
			edge.xprint("Factory reset finished successfully!",1,line,colors.green)
			line = line + 1
			edge.xprint("You can restart now.",1,line,colors.green)
			line = line + 1
			osstate = "loginscreen"
    end
  elseif cmd == "update" then
		edge.xprint("Downloading core files..",1,line,colors.white)
		line = line + 1
		if arg[1] == "exp" then
		  a = http.get("https://www.dropbox.com/s/8pb8ohxvkkxtz0j/os_unreleased.lua?dl=1")
		  b = fs.open("system/os.lua","w")
		elseif arg[1] == nil then
		  a = http.get("https://www.dropbox.com/s/u8ybnccylnqj3a2/os.lua?dl=1")
		  b = fs.open("system/os.lua","w")
		end
		b.write(a.readAll())
		b.close()
		a.close()
		edge.xprint("OK",1,line,colors.green)
		line = line + 1
		--printcenter("BirchOS Amethyst",9)

		edge.xprint("Downloading boot files..",1,line,colors.white)
		line = line + 1
		local a = http.get("https://www.dropbox.com/s/5zzs9v9s5ez3w3y/startup?dl=1")
		local b = fs.open("startup","w")
		b.write(a.readAll())
		b.close()
		a.close()
		edge.xprint("OK",1,line,colors.green)
		line = line + 1

		if not fs.exists("system/settings") then
		  --printcenter("BirchOS Amethyst",9)
			edge.xprint("Downloading factory settings",1,line,colors.white)
			line = line + 1
		  local a = http.get("https://www.dropbox.com/s/3o5ztpmu79823kq/settings?dl=1")
		  local b = fs.open("system/settings","w")
		  b.write(a.readAll())
		  b.close()
		  a.close()
			edge.xprint("OK",1,line,colors.green)
			line = line + 1
		end

		--printcenter("BirchOS Amethyst",9)
		edge.xprint("Downloading APIs..",1,line,colors.white)
		line = line + 1
		if arg[1] == "exp" then
		  a = http.get("https://www.dropbox.com/s/da45aqm9h3h308v/birch_unreleased?dl=1")
		  b = fs.open("system/api/birch","w")
		elseif arg[1] == nil then
		  a = http.get("https://www.dropbox.com/s/darz4juxx07fmd4/birch?dl=1")
		  b = fs.open("system/api/birch","w")
		end
		b.write(a.readAll())
		b.close()
		a.close()

		local a = http.get("https://www.dropbox.com/s/wa8gweawmj6cbk2/edge?dl=1")
		local b = fs.open("system/api/edge","w")
		b.write(a.readAll())
		b.close()
		a.close()

		local a = http.get("https://www.dropbox.com/s/r3lxdp53optt0eq/network?dl=1")
		local b = fs.open("system/api/network","w")
		b.write(a.readAll())
		b.close()
		a.close()

		local a = http.get("https://www.dropbox.com/s/tb22kn8fnfwa1wm/operation?dl=1")
		local b = fs.open("system/api/operation","w")
		b.write(a.readAll())
		b.close()
		a.close()
		local a = http.get("https://www.dropbox.com/s/j1sq88cd3e7e8mj/sc?dl=1")
		local b = fs.open("system/api/sc","w")
		b.write(a.readAll())
		b.close()
		a.close()

		local a = http.get("https://www.dropbox.com/s/9raac5zaeml1pt6/settings?dl=1")
		local b = fs.open("system/api/settings","w")
		b.write(a.readAll())
		b.close()
		a.close()
		edge.xprint("OK",1,line,colors.green)
		line = line + 1
		edge.xprint("Preparing libraries..",1,line,colors.orange)
		line = line + 1
		local a = http.get("https://www.dropbox.com/s/o8xmqj5nfyqywuj/theme.birchtheme?dl=1")
		local b = fs.open("system/libraries/theme/theme.birchtheme","w")
		b.write(a.readAll())
		b.close()
		a.close()
		edge.xprint("OK",1,line,colors.green)
		line = line + 1
		edge.xprint("Cleaning up..",1,line,colors.white)
		line = line + 1
		if fs.exists("system/libraries/update/temp") then
		  fs.delete("system/libraries/update/temp")
		end
		if fs.exists("system/log.txt") then
		  fs.delete("system/log.txt")
		end
		edge.xprint("Update finished without errors, a restart is required.",1,line,colors.green)
		line = line + 1
	elseif cmd == "update -exp" then

			edge.xprint("Downloading core files..",1,line,colors.white)
			line = line + 1
			if arg[1] == "exp" then
				a = http.get("https://www.dropbox.com/s/8pb8ohxvkkxtz0j/os_unreleased.lua?dl=1")
				b = fs.open("system/os.lua","w")
			elseif arg[1] == nil then
				edge.xprint("Mode: Experimental",1,line,colors.red)
				line = line + 1
				a = http.get("https://www.dropbox.com/s/8pb8ohxvkkxtz0j/os_unreleased.lua?dl=1")
				b = fs.open("system/os.lua","w")
			end
			b.write(a.readAll())
			b.close()
			a.close()
			edge.xprint("OK",1,line,colors.green)
			line = line + 1
			--printcenter("BirchOS Amethyst",9)
			edge.xprint("Downloading boot files..",1,line,colors.white)
			line = line + 1
			local a = http.get("https://www.dropbox.com/s/5zzs9v9s5ez3w3y/startup?dl=1")
			local b = fs.open("startup","w")
			b.write(a.readAll())
			b.close()
			a.close()
			edge.xprint("OK",1,line,colors.green)
			line = line + 1
			if not fs.exists("system/settings") then
				--printcenter("BirchOS Amethyst",9)
				edge.xprint("Downloading factory settings",1,line,colors.white)
				line = line + 1
				local a = http.get("https://www.dropbox.com/s/3o5ztpmu79823kq/settings?dl=1")
				local b = fs.open("system/settings","w")
				b.write(a.readAll())
				b.close()
				a.close()
				edge.xprint("OK",1,line,colors.green)
				line = line + 1
			end

			--printcenter("BirchOS Amethyst",9)
			edge.xprint("Downloading APIs..",1,line,colors.white)
			line = line + 1
			if arg[1] == "exp" then
				a = http.get("https://www.dropbox.com/s/da45aqm9h3h308v/birch_unreleased?dl=1")
				b = fs.open("system/api/birch","w")
			elseif arg[1] == nil then
				edge.xprint("Mode: Experimental",1,line,colors.red)
				line = line + 1
				a = http.get("https://www.dropbox.com/s/da45aqm9h3h308v/birch_unreleased?dl=1")
				b = fs.open("system/api/birch","w")
			end
			b.write(a.readAll())
			b.close()
			a.close()

			local a = http.get("https://www.dropbox.com/s/wa8gweawmj6cbk2/edge?dl=1")
			local b = fs.open("system/api/edge","w")
			b.write(a.readAll())
			b.close()
			a.close()

			local a = http.get("https://www.dropbox.com/s/r3lxdp53optt0eq/network?dl=1")
			local b = fs.open("system/api/network","w")
			b.write(a.readAll())
			b.close()
			a.close()

			local a = http.get("https://www.dropbox.com/s/tb22kn8fnfwa1wm/operation?dl=1")
			local b = fs.open("system/api/operation","w")
			b.write(a.readAll())
			b.close()
			a.close()
			local a = http.get("https://www.dropbox.com/s/j1sq88cd3e7e8mj/sc?dl=1")
			local b = fs.open("system/api/sc","w")
			b.write(a.readAll())
			b.close()
			a.close()

			local a = http.get("https://www.dropbox.com/s/9raac5zaeml1pt6/settings?dl=1")
			local b = fs.open("system/api/settings","w")
			b.write(a.readAll())
			b.close()
			a.close()
			edge.xprint("OK",1,line,colors.green)
			line = line + 1
			edge.xprint("Preparing libraries..",1,line,colors.orange)
			line = line + 1
			local a = http.get("https://www.dropbox.com/s/o8xmqj5nfyqywuj/theme.birchtheme?dl=1")
			local b = fs.open("system/libraries/theme/theme.birchtheme","w")
			b.write(a.readAll())
			b.close()
			a.close()
			edge.xprint("OK",1,line,colors.green)
			line = line + 1
			edge.xprint("Cleaning up..",1,line,colors.white)
			line = line + 1
			if fs.exists("system/libraries/update/temp") then
				fs.delete("system/libraries/update/temp")
			end
			if fs.exists("system/log.txt") then
				fs.delete("system/log.txt")
			end
			edge.xprint("Update finished without errors.",1,line,colors.green)
			line = line + 1
			sleep(1)
			os.reboot()
  elseif cmd == "version" then
    edge.xprint("BirchOS Amethyst "..birch.osversion,1,line,colors.white)
    line = line + 1
    edge.xprint("By Nothy/Linus Ramneborg",1,line,colors.lightGray)
    line = line + 1
		if term.color == false then
			edge.xprint("Computer isn't advanced, Commandline only.",1,line,colors.lightGray)
			line = line + 1
		end
  elseif cmd == "update" then
    edge.xprint("update: Command could not be completed without elevated rights",1,line,colors.green)
    line = line + 2
  elseif cmd == "clear" then
    commandline()
  elseif cmd == "uninstall" then
    edge.xprint("Are you sure you would like to uninstall BirchOS? (Y/N)",1,line,colors.red)
    line = line + 2
    term.setCursorPos(1,line)
    i = io.read()
    if string.lower(i) == "y" then
      edge.xprint("Uninstalling.",1,line,colors.red)
      line = line + 1
      fs.delete("system")
      fs.delete("startup")
      sleep(3)
      edge.xprint("Uninstall finished.",1,line,colors.red)
      line = line + 1
    end

  elseif cmd == "sudo new username" then
		if not osstate == "loginscreen" then
    edge.xprint("Enter a new name:",1,line,colors.green)
    line = line + 1
    term.setCursorPos(1,line)
    i = io.read()
    settings.setVariable("system/settings","username",i)
    edge.xprint("Username set to "..i,1,line,colors.green)
    line = line + 1
	else
		edge.xprint("Username:",1,line,colors.white)
		line = line + 1
		edge.xprint("Password:",1,line,colors.white)
		term.setCursorPos(10,line - 1)
		username = io.read()
		term.setCursorPos(10,line)
		password = read("*")
		line = line + 1
		if username == settings.getVariable("system/settings","username") and password == settings.getVariable("system/settings","loginkey") then
			osstate = "desktop"
			edge.xprint("Enter a new name:",1,line,colors.green)
			line = line + 1
			term.setCursorPos(1,line)
			i = io.read()
			settings.setVariable("system/settings","username",i)
			edge.xprint("Username set to "..i,1,line,colors.green)
			line = line + 1
		end
	end
  elseif cmd == "exit" or cmd == "quit" then
    term.setBackgroundColor(OS_GUI_COLOR)
    term.setTextColor(OS_TEXT_COLOR)
    shell.run("clear")
    if osstate == "desktop" then
      desktop()
    end
    if osstate == "loginscreen" then
      OS_LOGIN_SCREEN()
    end
  elseif cmd == "BACKWARDS MESSAGE!" then
    edge.xprint("EGASSEM SDRAWKCAB!",1,line,colors.lightGray)
    line = line + 1
  elseif cmd == "sudo reboot" then
    edge.xprint("Reboot is imminent in 3 seconds.",1,line,colors.green)
    sleep(3)
    os.reboot()
  elseif cmd == "reboot" then
    edge.xprint("reboot: Command could not be completed without elevated rights",1,line,colors.green)
    line = line + 2
  elseif cmd == "color" then
    edge.xprint("Current color is "..tostring(settings.getVariable("system/settings","terminalcolor")),1,line,colors.green)
    line = line + 1
  elseif cmd == "sudo change color" then
    edge.xprint("Enter color number:",1,line,colors.green)
    term.setCursorPos(20,line)
    local c = io.read()
    settings.setVariable("system/settings","terminalcolor",c)
    line = line + 1
    commandline()
	elseif cmd == "announcement" then
		local announ_url = http.get("http://pastebin.com/raw/9HMmGNiF")
		local t = announ_url.readAll()
		if tostring(t) == "-" then
			edge.xprint("Announcement:",1,line,colors.white)
			line = line + 1
			edge.xprint("Suprisingly enough, there's nothing to show! :D",1,line,colors.orange)
			line = line + 1
		else
			edge.xprint("Announcement:",1,line,colors.white)
			line = line + 1
			edge.xprint(tostring(t),1,line,colors.white)
			line = line + 1
		end
	elseif cmd == "credits" then
		edge.xprint(":::Credits:::",1,line,colors.white)
		line = line + 1
		edge.xprint("Developed using Atom by GitHub",1,line,colors.white)
		line = line + 1
		edge.xprint("   www.atom.io/",1,line,colors.green)
		line = line + 2
		edge.xprint("Emulated with CCEmuRedux by Xtansia",1,line,colors.white)
		line = line + 2
		edge.xprint("Settings API by Vick",1,line,colors.white)
		line = line + 2
		edge.xprint("Hosted with Dropbox",1,line,colors.white)
		line = line + 1
		edge.xprint("   www.dropbox.com/",1,line,colors.green)
		line = line + 2
		edge.xprint("Special thanks to Blue (Glass UI) for inspiration",1,line,colors.blue)
		line = line + 1
	elseif cmd == "repair" then
		file = http.get("https://www.dropbox.com/s/1do5cf0q86y79f5/repair?dl=1")
		f = fs.open("repair","w")
		f.write(file.readAll())
		f.close()
		os.run({},"repair")
	elseif cmd == "swedish" then
		edge.xprint("abcdefghijklmnopqrstuvwxyzåäö",1,line,colours.green)
		line = line + 1
	elseif cmd == "potato" then
		birch.crash("Too much nutrition!!")
	elseif cmd == "installrom" then
			if birch.customromsupport == true then
				edge.xprint("INSTALLER: Where is your ROM downloaded?",1,line,colors.white)
				line = line + 1
				term.setCursorPos(1,line)
				local dir = io.read()
				line = line + 1
				fs.move(dir,"system/libraries/1a/rom.img")
				settings.setVariable("system/libraries/romConfig","enabled","true")
				edge.xprint("INSTALLER: ROM successfully installed!",1,line,colors.green)
				line = line + 1
			else
				edge.xprint("Unable to install rom! BirchOS version not supported!",1,line,colors.red)
				line = line + 2
			end
	elseif cmd == "checkromsupport" then
		if birch.customromsupport == true then
			edge.xprint("ROMs supported!",1,line,colors.green)
			line = line + 1
		else
			edge.xprint("ROMs unsupported!",1,line,colors.red)
			line = line + 1
			edge.xprint(tostring(birch.customromsupport),1,line,colors.red)
			line = line + 1
		end
	elseif cmd == "downloadrom" then
		edge.xprint("Enter URL: ",1,line,colors.white)
		term.setCursorPos(11,line)
		url = io.read()
		line = line + 1
		local download_url = http.get(url)
		local t = fs.open("rom.img","w")
		t.write(download_url.readAll())
		t.close()
		edge.xprint("Downloaded as 'rom.img'!",1,line,colors.white)
		line = line + 1
	elseif cmd == "uninstallrom" then
		edge.xprint("Uninstalling ROM.",1,line,colors.white)
		line = line + 1
		if fs.exists("system/libraries/1a") then
			fs.delete("system/libraries/1a")
			fs.delete("system/libraries/romConfig")
	  end
		edge.xprint("ROM uninstall successful!",1,line,colors.green)
		line = line + 1
	elseif cmd == "crash" then
		fs.delete("system/api/edge")
		birch.crash("FORCED CRASH + REPAIR")
  else
			if fs.exists(cmd) then
				print("Running "..cmd)
				shell.run(cmd)
			else
	      edge.xprint("Command not found: "..cmd,1,line,colors.green)
	      line = line + 1
			end
    end
  end
end
function boot()
  if bootPart == 0 then
    term.setBackgroundColor(OS_GUI_COLOR)
    term.setTextColor(OS_TEXT_COLOR)
    shell.run("clear")
    birch.printcenter("Birch OS Amethyst",9)
    --birch.printcenter("[==        ]",10)
    --sleep(0.3)
    shell.run("clear")
    if fs.exists("system/api/sc") then
    os.loadAPI("system/api/sc")
    else
      birch.crash("MISSING_API: API/SC")
    end
    birch.printcenter("Birch OS Amethyst",9)
    --birch.printcenter("[====      ]",10)
    --sleep(0.15)
    shell.run("clear")
    if fs.exists("system/api/network") then
    os.loadAPI("system/api/network")
    else
      birch.crash("MISSING_API: API/NETWORK")
    end
    birch.printcenter("Birch OS Amethyst",9)
    --birch.printcenter("[======    ]",10)
    --sleep(0.17)
    shell.run("clear")
    if fs.exists("system/api/operation") then
    os.loadAPI("system/api/operation")
    else
      birch.crash("MISSING_API: API/OPERATION")
    end
    birch.printcenter("Birch OS Amethyst",9)
    --birch.printcenter("[========  ]",10)
    --sleep(0.1)
    shell.run("clear")
    birch.printcenter("Birch OS Amethyst",9)
    --birch.printcenter("[==========]",10)
    --sleep(0.2)
    shell.run("clear")
    if fs.exists("system/api/edge") then
    os.loadAPI("system/api/edge")
    else
      birch.crash("MISSING_API: Edge Graphics API")
    end
    birch.printcenter("Birch OS Amethyst",9)
    --birch.printcenter("[ULTIMATE]",9)
    --birch.printcenter("[==========]",10)
    birch.sysLog("Finished loading")
    --sleep(0.3)
    if settings.getVariable("system/settings","username") == "nil"  then
      OS_FIRST_BOOT()
    end
		if settings.getVariable("system/settings","loginkey") == "nil" or settings.getVariable("system/settings","loginkey") == "" or settings.getVariable("system/settings","loginkey") == nil then
			term.setBackgroundColor(OS_GUI_COLOR)
			OS_LOGIN_SCREEN()
		else
			term.setBackgroundColor(OS_GUI_COLOR)
			OS_LOGIN_SCREEN()
		end
  end
end
function printcenter( text, y )
	 local x = term.getSize()
	 local centerXPos = ( x - string.len(text) ) / 2
	 term.setCursorPos( centerXPos, y )
	 write( text )
 end
function OS_FIRST_BOOT()
	local OS_GUI_COLOR = colors.white
	local usrnm = false
	local thm = false
	local tfm = false
	shell.run("clear")
  edge.render(1,1,19,51,colors.white,OS_GUI_COLOR,"")
  term.setTextColor(colors.black)
	edge.cprint("Welcome to Birch OS Amethyst!",10)
  term.setTextColor(colors.white)
  sleep(0.05)
  shell.run("clear")
  edge.render(1,1,19,51,colors.white,OS_GUI_COLOR,"")
  term.setTextColor(colors.black)
  edge.cprint("Welcome to Birch OS Amethyst!",9)
  term.setTextColor(colors.white)
  sleep(0.05)
  shell.run("clear")
  edge.render(1,1,19,51,colors.white,OS_GUI_COLOR,"")
  term.setTextColor(colors.black)
  edge.cprint("Welcome to Birch OS Amethyst!",8)
  term.setTextColor(colors.white)
  sleep(0.05)
  shell.run("clear")
  edge.render(1,1,19,51,colors.white,OS_GUI_COLOR,"")
  term.setTextColor(colors.black)
  edge.cprint("Welcome to Birch OS Amethyst!",7)
  term.setTextColor(colors.white)
  sleep(2)
  shell.run("clear")
  edge.render(1,1,19,51,colors.white,OS_GUI_COLOR,"")
  term.setTextColor(colors.black)
	edge.cprint("Enter a username",7)
  edge.render(34,10,34,10,colors.white,OS_GUI_COLOR,"")
  edge.render(17,10,33,10,colors.lightGray,OS_GUI_COLOR,"")
  term.setCursorPos(17,10)
  term.setTextColor(colors.black)
  term.setBackgroundColor(colors.lightGray)
  local username = io.read()
  settings.setVariable("system/settings","username",username)
  edge.render(1,1,19,51,colors.white,OS_GUI_COLOR,"")
  term.setTextColor(colors.black)
  edge.cprint("Select a password.",7)
  edge.render(17,10,33,10,colors.lightGray,OS_GUI_COLOR)
  term.setCursorPos(17,10)
  term.setTextColor(colors.black)
  term.setBackgroundColor(colors.lightGray)
  local password = read("*")
	if password == "" then settings.setVariable("system/settings","loginkey","nil") else settings.setVariable("system/settings","loginkey",password) end
  term.setBackgroundColor(colors.white)
  shell.run("clear")
  edge.render(1,1,19,51,colors.white,OS_GUI_COLOR,"")
  term.setTextColor(colors.black)
  edge.cprint("Which theme would you like?",7)
  edge.cprint("[bright]   [dark]   [custom]",10)
  local  event, button, x, y = os.pullEvent("mouse_click")
  if x >= 11 and x <= 18 and y == 10 then
    settings.setVariable("system/settings","theme","bright")
  end
  if x >= 22 and x <= 27 and y == 10 then
    settings.setVariable("system/settings","theme","dark")
  end
  if x >= 31 and x <= 38 and y == 10 then
    settings.setVariable("system/settings","theme","custom")
  end
  shell.run("clear")
  term.clear()
  edge.render(1,1,19,51,colors.white,OS_GUI_COLOR,"")
  sleep(1)
  edge.render(1,1,19,51,colors.white,OS_GUI_COLOR,"")
  term.setTextColor(colors.black)
  edge.cprint("Setting up Birch OS..",10)
  term.setTextColor(colors.white)
  sleep(2)
	desktop()
end
if birch.release == false then
	print("WARNING: THIS VERSION OS BIRCH OS AMETHYST IS UNSTABLE AND IS LIKELY TO BREAK!")
	print("")
	print("(C) NOTHY 2016-2017")
	sleep(2.5)
	shell.run("clear")
	birch.oldUI = true
	sleep(1)
end
if birch.release == false and fs.exists("system/libraries/1a/rom.img") then
	if settings.getVariable("system/libraries/romConfig","enabled") == "true" then
		shell.run("clear")
		sleep(1)
		shell.run("system/libraries/1a/rom.img")
	end
end
if fs.exists("repair") then
	shell.run("repair")
else
	if term.isColor() then
		boot()
	else
		birch.sysLog("[WARN] So uh.. Your terminal isn't really supported, so.. you can have a commandline until we've got this figured out.")
		commandline()
	end
end
