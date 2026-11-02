-- ================================================================================
-- APPLESCRIPT DROPLET - again-n-again
-- ================================================================================
-- PROJECT: dpx_again-n-again
-- Purpose: Drag one or more installed apps onto this app's icon. For each one it
--          runs the bundled make-again.sh, which creates "<Name>Again.app" in
--          ~/Applications (open -n launcher that always opens a NEW instance).
-- ================================================================================

on run
	display dialog "Drag an installed app onto this icon and I'll make an \"Again\" launcher for it in ~/Applications." & return & return & "Each launch of that launcher opens another copy of the app." buttons {"OK"} default button 1 with title "again-n-again"
end run

on open theItems
	set helper to POSIX path of (path to resource "make-again.sh")
	set madeList to {}
	repeat with anItem in theItems
		set itemPath to POSIX path of anItem
		try
			-- make-again.sh prints the created app's path as its last line
			set resultPath to do shell script "/bin/sh " & quoted form of helper & " " & quoted form of itemPath
			set end of madeList to resultPath
		on error errMsg
			display alert "Couldn't make a launcher for that" message errMsg as critical
		end try
	end repeat
	if (count of madeList) > 0 then
		display notification "Created " & (count of madeList) & " launcher(s) in ~/Applications" with title "again-n-again"
		-- reveal the newest one so it can be dragged to the Dock
		do shell script "/usr/bin/open -R " & quoted form of (item -1 of madeList)
	end if
end open
