#SingleInstance, Off
SetBatchLines, -1
SetWinDelay, 1
CoordMode, Mouse, Screen

notificationTitle = %1%
notificationText = %2%

WinGet, winCount, Count, AHKNotification
yPosition := 125*winCount

winTitle := "AHKNotification - " newGuid_Small()
Gui, +ToolWindow +AlwaysOnTop -Caption +Border
Gui, Color, 2A2B2F
Gui, Margin, 0, 0
Gui, Font, s30 c7FA2CF, Segoe UI Light
Gui, Add, Text, x10 vtxtMessageTitle, %notificationTitle%
Gui, Font
Gui, Font, s11 cWhite, Segoe UI
Gui, Add, Text, xm x15 r3 vtxtMessageText, %notificationText%
Gui, Add, Text, ym
Gui, Show, % "y" yPosition, %winTitle%
SetTimer, WatchMouse, 1000
sleep, 10000
return

~$LButton::
{
	MouseGetPos,,, mouseWin
	WinGetTitle, win, ahk_id %mouseWin%
	if (win == winTitle) {
		GuiControlGet, messageTitle,, txtMessageTitle
		GuiControlGet, messageText,, txtMessageText
		Clipboard := messageTitle " - " messageText
	}
	return
}

WatchMouse:
{
	t := 255
	Loop, 128
	{
		MouseGetPos,,, mouseWin
		WinGetTitle, win, ahk_id %mouseWin%
		if (win == winTitle) {
			WinSet, Trans, 255, %winTitle%
			break
		}
		WinSet, Trans, %t%, %winTitle%
		t := t-2
		Sleep, 1
		if (t <= 0) {
			ExitApp
		}
	}
	return
}

newGuid_Small() {
	charList := ["0","1","2","3","4","5","6","7","8","9","a","b","c","d","e","f"]
	guid := ""
	Loop, 8
	{
		Random, var, 1, 16
		guid := guid . charList[var]
	}
	return guid
}