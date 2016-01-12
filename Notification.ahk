/*
	feature requets:
		* click -> copy message to clipboard
		* specify location with param
*/

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
Gui, Add, Text, x10, %notificationTitle%
Gui, Font
Gui, Font, s11 cWhite, Segoe UI
Gui, Add, Text, xm x15 r3, %notificationText%
Gui, Add, Text, ym
Gui, Show, % "y" yPosition, %winTitle%
SetTimer, WatchMouse, 1000
return

WatchMouse:
{
	t := 255
	Loop, 128
	{
		MouseGetPos, mouseX, mouseY
		WinGetPos, winX, winY, winW, winH, %winTitle%
		if ((mouseX >= winX && mouseX <= (winX+winW))
			&& (mouseY >= winY && mouseY <= (winY+winH))) {
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