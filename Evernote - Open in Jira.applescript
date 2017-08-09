tell application "Evernote"
	set oNotes to selection
	set sName to title of item 1 of oNotes
	set sWords to words of sName
	set sURL to "http://tugjira.eczacibasi.com.tr/browse/" & item 1 of sWords & "-" & item 2 of sWords
end tell

set sCommand to "open " & sURL
do shell script sCommand