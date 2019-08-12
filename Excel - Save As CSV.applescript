tell application "Finder"
	set theFiles to files in folder "⁨Macintosh HD:Users:kerem⁩:Downloads" whose name ends with ".xlsx"
end tell


repeat with theFile in theFiles
	tell application "Microsoft Excel"
		activate
		open theFile
		set default file path to "⁨Macintosh HD:Users:kerem⁩:Downloads"
	end tell
	tell application "System Events"
		delay 5
		keystroke "S" using {shift down, command down}
		delay 3
		key code 48
		delay 1
		key code 48
		delay 1
		key code 48
		delay 1
		key code 48
		delay 1
		key code 48
		delay 1
		key code 48
		delay 1
		key code 48
		delay 1
		key code 48
		delay 1
		key code 48
		delay 1
		key code 48
		delay 1
		key code 49
		delay 1
		keystroke "C"
		keystroke "S"
		keystroke "V"
		delay 1
		key code 76
		delay 1
		key code 48
		delay 1
		key code 48
		delay 1
		key code 48
		delay 1
		key code 48
		delay 1
		key code 76
		delay 1
		delay 3
	end tell
	
	tell application "Microsoft Excel"
		quit
	end tell
	
end repeat
