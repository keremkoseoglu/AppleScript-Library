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
			set newContent to newContent & ("<a href=" & noteUrl & ">" & noteTitle & "</a><br><br>")
		end repeat
		
	end tell
	
	set newContent to newContent & "</td>"
	
end appendPrio

------------------------------
-- Subroutine to add a line
------------------------------

on appendHat(tag)
	
	set newContent to newContent & "<tr><td>" & tag & "</td>"
	
	set searchString to "notebook:Active tag:" & tag
	appendPrio("k1")
	appendPrio("k2")
	appendPrio("k3")
	appendPrio("k4")
	
	set newContent to newContent & "</tr>"
	
end appendHat

------------------------------
-- Subroutine to add untagged notes
------------------------------

on appendUntagged()
	
	set newContent to newContent & "Untagged notes: "
	
	set localSearchString to "notebook:Active -tag:k* -tag:ai -tag:ecz"
	
	tell application "Evernote"
		set searchResults to find notes localSearchString
		
		repeat with searchResult in searchResults
			set noteTitle to title of searchResult
			set noteUrl to note link of searchResult
			set newContent to newContent & ("<a href=" & noteUrl & ">" & noteTitle & "</a>, ")
		end repeat
		
		set resultCount to count of searchResults
		if resultCount � 0 then set newContent to newContent & " - "
		
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

set newContent to newContent & "<br><br><table><tr><td>Tag</td><td>k1</td><td>k2</td><td>k3</td><td>k4</td></tr>"

appendHat("tweet")
appendHat("life")
appendHat("shopping")
appendHat("dev")
appendHat("music")
appendHat("writing")
appendHat("psm")
appendHat("trivia")

set newContent to newContent & "</table>"

-- Create new note

tell application "Evernote"
	create note title "Map" with html newContent notebook "Inbox"
	set query string of window 1 to "Map"
	activate
end tell