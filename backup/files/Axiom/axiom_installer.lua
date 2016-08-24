print(shell.getRunningProgram()..": Preparing to install AXIOM.")
args = {...}
filesDeleted = 0
filesProtected = 0
print(shell.getRunningProgram()..": CHECKING HTTP")
if not http then
  print("HTTP is not enabled")
  error("AXIOM-HttpException")
end
print(shell.getRunningProgram()..": HTTP OK")
print(shell.getRunningProgram()..": CHECKING COLOR")
if not term.isColor() then
  error("Your system does not meet the requirements to run AXIOM (not advanced)")
end
print(shell.getRunningProgram()..": COLOR OK")
function download(url, file)

  fdl = http.get(url)
  if not fdl then
    --if not args[1] == "silent" and args[1] == nil then
      error("AXIOM-ConnectionNotEstablished")
    --end
  end
  f = fs.open(file,"w")
  --if not args[1] == "silent" and args[1] == nil then

  f.write(fdl.readAll())
  f.close()
  if args[1] == "-nogui" or args[2] == "-nogui" or args[3] == "-nogui" or args[4] == "-nogui" then

  else
    print(shell.getRunningProgram()..":FDL:"..file)
  end
end
function cprint( text, y )
  local x = term.getSize()
  local centerXPos = ( x - string.len(text) ) / 2
  term.setCursorPos( centerXPos, y )
  write( text )
end
print(shell.getRunningProgram()..": INITIALIZING..")
if args[1] == "-newgui" or args[2] == "-newgui" or args[3] == "-newgui" or args[4] == "-newgui" then
  args[2] = "-nogui"
  term.setBackgroundColor(colors.cyan)
  term.setTextColor(colors.white)
  shell.run("clear")
  cprint(".        ",10)
  sleep(0.1)
  cprint(" .       ",10)
  sleep(0.1)
  cprint("  .      ",10)
  sleep(0.1)
  cprint("   .     ",10)
  sleep(0.1)
  cprint("    .    ",10)
  sleep(0.1)
  cprint("     .   ",10)
  sleep(0.1)
  cprint("      .  ",10)
  sleep(0.1)
  cprint("       . ",10)
  sleep(0.1)
  cprint("        .",10)
  sleep(0.1)
  cprint(".       .",10)
  sleep(0.2)
  cprint("  .   .  ",10)
  sleep(0.2)
  cprint("    I    ",9)
  cprint("    .    ",10)
  sleep(0.3)
  cprint("    .    ",10)
  sleep(0.2)
  cprint("  X I O  ",9)
  cprint("  . . .  ",10)
  sleep(0.2)
  cprint("A X I O M",9)
  cprint(". . . . .",10)
end
if args[1] == "-format" or args[2] == "-format" or args[3] == "-format" or args[3] == "-format" then
  if args[1] == "-nogui" or args[2] == "-nogui" or args[3] == "-nogui" or args[4] == "-nogui" then

  else
    print(shell.getRunningProgram()..": Formatting computer")
  end
  --print("Formatting computer")
--  if fs.exists("os/settings") then
  --  fs.move("os/settings","os/backup/settings")
  --end
  local fileList = fs.list("/")
  for _, file in ipairs(fileList) do
    if file == "rom" or file == shell.getRunningProgram() or file == "protectedFiles" then
      if args[1] == "-nogui" or args[2] == "-nogui" or args[3] == "-nogui" or args[4] == "-nogui" then

      else
        term.setTextColor(colors.red)
        if file == shell.getRunningProgram() then
          print(shell.getRunningProgram()..": Found self, ignoring")
        else
          print(shell.getRunningProgram()..": Protected file found, ignoring..")
        end
        term.setTextColor(colors.white)
        filesProtected = filesProtected + 1
      end
      --print("ROM or install file detected, ignoring..")
    else
      if fs.isDir(file) then
        if args[1] == "-nogui" or args[2] == "-nogui" or args[3] == "-nogui" or args[4] == "-nogui" then

        else
          print(shell.getRunningProgram()..": Deleted folder "..file)
        end
      else
        if args[1] == "-nogui" or args[2] == "-nogui" or args[3] == "-nogui" or args[4] == "-nogui" then

        else
          if file == "penis" then
            print(shell.getRunningProgram()..": Attempting to delete file "..file)
            term.setTextColor(colors.red)
            sleep(5)
            print(shell.getRunningProgram()..": Could not delete file "..file.." - File size is less than or equal to 0 bytes.")
            sleep(8.5)
            print(shell.getRunningProgram()..": Deleted file "..file)
            term.setTextColor(colors.white)
          else
            print(shell.getRunningProgram()..": Deleted file "..file)
          end
        end
      end
      fs.delete(file)
      filesDeleted = filesDeleted + 1
      sleep(0.079)
    end
    --print("Loaded: os/libraries/"..file)
  end
end
if args[1] == "-nogui" or args[2] == "-nogui" or args[3] == "-nogui" or args[4] == "-nogui" then

else
  print(shell.getRunningProgram()..": Downloading files, this may take seveal minutes. ")
end
download("https://www.dropbox.com/s/a7fp2jo6tgm7xsy/startup?dl=1","startup")
download("https://www.dropbox.com/s/7mzhcfe53dm2rq5/sys.axs?dl=1","os/sys.axs")
if args[1] == "-noapi" or args[2] == "-noapi" or args[3] == "-noapi" or args[4] == "-noapi" then
  --nothing
else
  download("https://www.dropbox.com/s/hbmt6bf1tjl8z4z/settings?dl=1","os/libraries/settings")
  download("https://www.dropbox.com/s/a5kxzjl6122uti2/edge?dl=1","os/libraries/edge")
  download("https://www.dropbox.com/s/p3kgkzhe27vr9lj/encryption?dl=1","os/libraries/encryption")
end
if not fs.exists("os/settings.0") then
  download("https://www.dropbox.com/s/ynyrs22t1hh2mry/settings?dl=1","os/settings.0")
end
if args[1] == "-noapi" or args[2] == "-noapi" or args[3] == "-noapi" or args[4] == "-noapi" then

else
  download("https://www.dropbox.com/s/aqyif3fsu6jy65g/next?dl=1","os/libraries/next")
end
sleep(1)
if fs.exists("os/backup/settings") then
  fs.delete("os/settings.0")
  fs.move("os/backup/settings","os/settings.0")
  local installLog = fs.open("installLog.txt","a")
  installLog.writeLine("Setup reverted to old system settings.\n")
  installLog.close()
  if args[1] == "-nogui" or args[2] == "-nogui" or args[3] == "-nogui" or args[4] == "-nogui" then

  else
    print(shell.getRunningProgram()..": Reverted to old system settings.")
  end
  fs.delete("protectedFiles")
end
local installLog = fs.open("installLog.txt","a")
installLog.writeLine("Files protected: "..filesProtected.."\n")
installLog.writeLine("Files deleted: "..filesDeleted.."\n")
installLog.writeLine("Install was successful.")
installLog.close()
if args[1] == "-debug" or args[2] == "-debug" or args[3] == "-debug" or args[4] == "-debug" then
  fs.makeDir("safeStart")
end
if args[1] == "-format" or args[2] == "-format" or args[3] == "-format" or args[4] == "-format" then
  os.reboot()
else
  shell.run("os/sys.axs")
end
