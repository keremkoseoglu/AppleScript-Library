global newContent, searchResults, searchString

------------------------------
-- Subroutine to add a cell to the current line
------------------------------

on appendPrio(tag)
	
	set newContent to newContent & "<td>"
	set localSearchString to searchString & " tag:" & tag
	
	tell application "Evernote"
		set searchResults to find notes localSearchString
		
		repeat with searchResult in searchResults
			set noteTitle to title of searchResult
			set noteUrl to note link of searchResult
			set noteDate to modification date of searchResult
			set now to current date
			set dateDiff to round ((now - noteDate) / 86400)
			set newContent to newContent & ("▪️<a href=" & noteUrl & ">" & noteTitle & "</a> <span style=\"font-size: 75%; \">(" & dateDiff & "d)</span><br>")
		end repeat
		
	end tell
	
	set newContent to newContent & "</td>"
	
end appendPrio

------------------------------
-- Subroutine to add a line
------------------------------

on appendHat(tag, desc)
	
	set newContent to newContent & "<tr><td>" & desc & " " & tag & "&nbsp;</td>"
	
	set searchString to "notebook:Active tag:" & tag
	appendPrio("p1")
	appendPrio("p2")
	appendPrio("p3")
	
	set newContent to newContent & "</tr>"
	
end appendHat

------------------------------
-- Subroutine to add untagged notes
------------------------------

on appendUntagged()
	
	set newContent to newContent & "Untagged notes: "
	
	set localSearchString to "notebook:Active -tag:p* -tag:ai -tag:ecz"
	
	tell application "Evernote"
		set searchResults to find notes localSearchString
		
		repeat with searchResult in searchResults
			set noteTitle to title of searchResult
			set noteUrl to note link of searchResult
			set newContent to newContent & ("<a href=" & noteUrl & ">" & noteTitle & "</a>, ")
		end repeat
		
		set resultCount to count of searchResults
		if resultCount ≤ 0 then set newContent to newContent & " - "
		
	end tell
	
end appendUntagged

------------------------------
-- Script entry point
------------------------------

-- Initialization

set newContent to ""

-- Catch untagged notes

appendUntagged()

-- Matrix of tagged notes

set newContent to newContent & "<br><br><table><tr><td>&nbsp;</td><td>🥇</td><td>🥈</td><td>🥉</td></tr>"

appendHat("tweet", "🗣")
appendHat("life", "🌍")
appendHat("shop", "🛒")
appendHat("dev", "💻")
appendHat("music", "🎸")
appendHat("write", "✒️")
appendHat("fun", "🎉")

set newContent to newContent & "</table>"

-- Create new note

tell application "Evernote"
	create note title "TagMatrix" with html newContent notebook "Inbox"
	set query string of window 1 to "TagMatrix"
	activate
end tell