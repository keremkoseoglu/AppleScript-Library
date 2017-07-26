on findAndReplaceInText(theText, theSearchString, theReplacementString)
	set AppleScript's text item delimiters to theSearchString
	set theTextItems to every text item of theText
	set AppleScript's text item delimiters to theReplacementString
	set theText to theTextItems as string
	set AppleScript's text item delimiters to ""
	return theText
end findAndReplaceInText
	
	tell application "Safari"
		set sName to name of front document
	end tell
	
	set sName to findAndReplaceInText(sName, " - Eczacıbaşı Tüketim Ürünleri Grubu JIRA", "")
	set sName to findAndReplaceInText(sName, "]", " -")
	set sName to findAndReplaceInText(sName, "[", "")
	
	tell application "Evernote"
		
		set sTempContent to "
		<br/><br/><hr/>
		<b>Hazırlık</b><br/>
		<br/>
		<en-todo/>Jira'da durumu ilerlet<br/>
		<br/><hr/>
		<b>Geliştirme</b><br/>
		<br/>
		<en-todo/>İncele<br/>
		<en-todo/>İş listesi çıkar<br/>
		<br/><hr/>
		<b>Test</b><br/>
		<br/>
		<en-todo/>EPC<br/>
		<en-todo/>Task release<br/>
		<en-todo/>Text<br/>
		<br/><hr/>
		<b>İlerleme</b><br/>
		<br/>
		<en-todo/>Jira'yı ilerletip not yaz<br/>
		<br/><hr/>
		<b>Kapanış</b><br/>
		<br/>
		<en-todo/>Son saat girişini tamamla<br/>
		<en-todo/>Evernote maddesini sil<br/>
	"
		
		set oNewNote to create note notebook "Active" tags "#ecz" title sName with enml sTempContent
		set query string of window 1 to sName
		
		activate
		
	end tell