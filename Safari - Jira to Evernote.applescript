
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

on htmlDecode(theText)
	set sRet to theText
	set sRet to findAndReplaceInText(sRet, "&#xE7;", "ç")
	set sRet to findAndReplaceInText(sRet, "&#xC7;", "Ç")
	set sRet to findAndReplaceInText(sRet, "&#xF6;", "ö")
	set sRet to findAndReplaceInText(sRet, "&#xD6;", "Ö")
	set sRet to findAndReplaceInText(sRet, "&#xFC;", "ü")
	set sRet to findAndReplaceInText(sRet, "&#xDC;", "Ü")
	return sRet
end htmlDecode

# ______________________________
# Safari related functions

on getIssueDescriptionFromSafari()
	
	set sPrefix to "<div class=\"user-content-block\">"
	
	tell application "Safari"
		set sHTML to the source of front document
	end tell
	
	set iOffset to offset of sPrefix in sHTML
	set sTrim to characters iOffset thru -1 of sHTML as string
	
	set iPrefixLength to length of sPrefix
	set sTrim to characters (iPrefixLength + 22) thru -1 of sTrim as string
	
	set iOffset to offset of "</div>" in sTrim
	set sTrim to characters (iOffset - 14) thru 1 of sTrim as string
	set sTrim to htmlDecode(sTrim)
	
	return sTrim
	
end getIssueDescriptionFromSafari

on getSubIssueNumberFromSafari()
	
	tell application "Safari"
		set sName to name of front document
	end tell
	
	set sName to findAndReplaceInText(sName, " - Eczacıbaşı Tüketim Ürünleri Grubu JIRA", "")
	set sName to findAndReplaceInText(sName, "]", " -")
	set sName to findAndReplaceInText(sName, "[", "")
	
	set iOffset to offset of " " in sName
	set sName to characters (iOffset - 1) thru 1 of sName as string
	
	return sName
	
end getSubIssueNumberFromSafari

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

on getIssueSummaryFromSafari()
	
	tell application "Safari"
		set sName to the name of front document
	end tell
	
	set iOffset to offset of "]" in sName
	set sName to characters iOffset thru -1 of sName as string
	set sName to findAndReplaceInText(sName, "] ", "")
	set sName to findAndReplaceInText(sName, " - Eczacıbaşı Tüketim Ürünleri Grubu JIRA", "")
	
	return sName
	
end getIssueSummaryFromSafari

# ______________________________
# Evernote related functions

on buildJiraLink(theIssue)
	return "http://tugjira.eczacibasi.com.tr/browse/" & theIssue
end buildJiraLink

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

set sSubIssueNumber to getSubIssueNumberFromSafari()

if sIssueNumber = sSubIssueNumber then
	set sIssueLink to buildJiraLink(sIssueNumber)
	set sLinks to "Madde: <a href=\"" & sIssueLink & "\">" & sIssueLink & "</a>"
else
	set sIssueLink to buildJiraLink(sIssueNumber)
	set sSubIssueLink to buildJiraLink(sSubIssueNumber)
	set sLinks to "
		Madde: <a href=\"" & sIssueLink & "\">" & sIssueLink & "</a><br/>
		Alt madde: <a href=\"" & sSubIssueLink & "\">" & sSubIssueLink & "</a>
	"
end if

set sIssueDescription to getIssueDescriptionFromSafari()

set sTempContent to "
<br/>" & sLinks & "
<br/><br/>" & sIssueDescription & "<br/><br/><br/><hr/>
<b>Hazırlık</b><br/>
<br/>
<en-todo/>Jira'da durumu ilerlet<br/>
<en-todo/>İnceleyip iş listesi çıkar<br/>
<br/><hr/>
<b>Geliştirme</b><br/>
<br/><en-todo/><br/>
<br/><hr/>
<b>Test</b><br/>
<br/>
<en-todo/>Test<br/>
<en-todo/>EPC<br/>
<en-todo/>Task release<br/>
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

set sIssueSummary to getIssueSummaryFromSafari()
set sName to sIssueNumber & " - " & sIssueSummary

tell application "Evernote"
	set oNewNote to create note notebook "Active" tags "#ecz" title sName with enml sTempContent
end tell

searchAndActivateEvernote(sIssueNumber)
