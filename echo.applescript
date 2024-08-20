on open objects
	tell application "Terminal"
		activate
		repeat with obj in objects
			-- do script with command "./every.sh " & obj
			do script with command "echo " & (POSIX path of obj)
		end repeat
	end tell
end open