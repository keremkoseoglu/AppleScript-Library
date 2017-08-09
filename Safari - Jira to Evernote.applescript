
# ______________________________
# Generic functions

on findAndReplaceInText(theText, theSearchString, theReplacementString)
	set AppleScript's text item delimiters to theSearchString
	set theTextItems to every text item of theText
	set AppleScript's text item delimiters to theReplacementString
	set theText to theTextItems as string
	set AppleScript's text item delimiters to ""
	return theText
end findAndReplaceInText

# ______________________________
# Safari related functions

on getIssueNumberFromSafari()
	
	set sPrefix to "<a class=\"issue-link\" data-issue-key=\""
	
	tell application "Safari"
		set sHTML to the source of front document
	end tell
	
	set iOffset to offset of sPrefix in sHTML
	set sTrim to characters iOffset thru -1 of sHTML as string
	
	set iPrefixLength to length of sPrefix
	set sTrim to characters iPrefixLength thru -1 of sTrim as string
	
	set iOffset to offset of "href" in sTrim
	set sTrim to characters (iOffset - 2) thru 1 of sTrim as string
	
	set sTrim to findAndReplaceInText(sTrim, "\"", "")
	
	return sTrim
	
end getIssueNumberFromSafari

on getIssueDescriptionFromSafari()
	
	tell application "Safari"
		set sName to the name of front document
	end tell
	
	set iOffset to offset of "]" in sName
	set sName to characters iOffset thru -1 of sName as string
	set sName to findAndReplaceInText(sName, "] ", "")
	set sName to findAndReplaceInText(sName, " - Eczacıbaşı Tüketim Ürünleri Grubu JIRA", "")
	
	return sName
	
end getIssueDescriptionFromSafari

# ______________________________
# Evernote related functions

on searchAndActivateEvernote(theText)
	tell application "Evernote"
		set query string of window 1 to theText
		activate
	end tell
end searchAndActivateEvernote

# ______________________________
# Main Flow

-- Get Jira issue number from Safari

set sIssueNumber to getIssueNumberFromSafari()

-- If note exists in Evernote, locate it

tell application "Evernote"
	set oNotes to find notes "intitle:\"" & sIssueNumber & "\""
end tell

if length of oNotes > 0 then
	searchAndActivateEvernote(sIssueNumber)
	return
end if

-- Create & locate note in Evernote

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

set sIssueDescription to getIssueDescriptionFromSafari()
set sName to sIssueNumber & " - " & sIssueDescription

tell application "Evernote"
	set oNewNote to create note notebook "Active" tags "#ecz" title sName with enml sTempContent
end tell

searchAndActivateEvernote(sIssueNumber)