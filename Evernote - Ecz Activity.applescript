tell application "Evernote"
	
	set newContent to "<table><tr><td>Hours</td><td>Note</td></tr>"
	
	set searchResults to find notes "tag:ecz updated:day"
	
	repeat with searchResult in searchResults
		set noteTitle to title of searchResult
		set noteUrl to note link of searchResult
		set newContent to newContent & ("<tr><td></td><td><a href=" & noteUrl & ">" & noteTitle & "</a></td></tr>")
	end repeat
	
	set newContent to newContent & ("<tr><td></td><td><a href=http://tugjira.eczacibasi.com.tr/browse/VOL-245>VOL-245</a></td></tr>")
	
	set newContent to newContent & ("</table>")
	
	create note title "EczActivity" with html newContent notebook "Inbox"
	set query string of window 1 to "EczActivity"
	activate
	
end tell