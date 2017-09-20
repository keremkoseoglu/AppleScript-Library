	tell application "Safari"
		set sName to name of front document
		set sURL to URL of front document
	end tell
	
	tell application "Evernote"
		set sText to sName & " " & sURL
		create note notebook "✅ Active" tags "#tweet" title sName with text sText
		set query string of window 1 to sName
		
		activate
	end tell