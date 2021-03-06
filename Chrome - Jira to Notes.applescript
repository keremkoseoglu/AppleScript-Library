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
# Chrome related functions

on getIssueDescriptionFromChrome()
	
	set sPrefix to "<div class=\"user-content-block\">"
	
	tell application "Google Chrome"
		tell active tab of window 1
			set sHTML to execute javascript "document.getElementsByTagName('html')[0].innerHTML"
		end tell
	end tell
	
	set iOffset to offset of sPrefix in sHTML
	set sTrim to characters iOffset thru -1 of sHTML as string
	
	set iPrefixLength to length of sPrefix
	set sTrim to characters (iPrefixLength + 22) thru -1 of sTrim as string
	
	set iOffset to offset of "</div>" in sTrim
	set sTrim to characters (iOffset - 14) thru 1 of sTrim as string
	set sTrim to htmlDecode(sTrim)
	
	return sTrim
	
end getIssueDescriptionFromChrome

on getSubIssueNumberFromChrome()
	
	tell application "Google Chrome"
		set sName to title of active tab of front window
	end tell
	
	set sName to findAndReplaceInText(sName, " - Tüketim Jira", "")
	set sName to findAndReplaceInText(sName, "]", " -")
	set sName to findAndReplaceInText(sName, "[", "")
	
	set iOffset to offset of " " in sName
	set sName to characters (iOffset - 1) thru 1 of sName as string
	
	return sName
	
end getSubIssueNumberFromChrome

on getIssueNumberFromChrome()
	
	set sPrefix to "<a class=\"issue-link\" data-issue-key=\""
	
	tell application "Google Chrome"
		tell active tab of window 1
			set sHTML to execute javascript "document.getElementsByTagName('html')[0].innerHTML"
		end tell
	end tell
	
	set iOffset to offset of sPrefix in sHTML
	set sTrim to characters iOffset thru -1 of sHTML as string
	
	set iPrefixLength to length of sPrefix
	set sTrim to characters iPrefixLength thru -1 of sTrim as string
	
	set iOffset to offset of "href" in sTrim
	set sTrim to characters (iOffset - 2) thru 1 of sTrim as string
	
	set sTrim to findAndReplaceInText(sTrim, "\"", "")
	
	return sTrim
	
end getIssueNumberFromChrome

on getIssueSummaryFromChrome()
	
	tell application "Google Chrome"
		set sName to title of active tab of front window
	end tell
	
	set iOffset to offset of "]" in sName
	set sName to characters iOffset thru -1 of sName as string
	set sName to findAndReplaceInText(sName, "] ", "")
	set sName to findAndReplaceInText(sName, " - Eczacıbaşı Tüketim Ürünleri Grubu JIRA", "")
	set sName to findAndReplaceInText(sName, " - Tüketim Jira", "")
	
	return sName
	
end getIssueSummaryFromChrome

# ______________________________
# Notes related functions

on buildJiraLink(theIssue)
	return "http://tugjira.eczacibasi.com.tr/browse/" & theIssue
end buildJiraLink

# ______________________________
# Main Flow

-- Get Jira issue number from Chrome

set sIssueNumber to getIssueNumberFromChrome()

-- Create & locate note

set sSubIssueNumber to getSubIssueNumberFromChrome()

if sIssueNumber = sSubIssueNumber then
	set sMainLink to buildJiraLink(sIssueNumber)
else
	set sMainLink to buildJiraLink(sSubIssueNumber)
end if

set sIssueDescription to getIssueDescriptionFromChrome()

set sTempContent to "<br><br>" & sIssueDescription & "<br><br>" & "<a href=" & sMainLink & ">" & sMainLink & "<br><br>"

set sIssueSummary to getIssueSummaryFromChrome()
set sName to sIssueNumber & " - " & sIssueSummary

tell application "Notes"
	tell account "iCloud"
		make new note at folder "ecz" with properties {name:sName, body:sTempContent}
	end tell
end tell
