tell application "Evernote"

	set newContent to ""

	set searchResults to find notes "tag:ecz updated:day"
	
	repeat with searchResult in searchResults
		set noteTitle to title of searchResult
		set noteUrl to note link of searchResult
		set newContent to newContent & ("<a href=" & noteUrl & ">" & noteTitle & "</a><br><br>")
	end repeat

	create note title "EczActivity" with html newContent notebook "Inbox"
	set query string of window 1 to "EczActivity"
	activate

end tell