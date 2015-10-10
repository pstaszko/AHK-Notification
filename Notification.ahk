/*
	feature requets:
		* mouse over stop fade out
		* click -> copy message to clipboard
		* specify location with param
*/

SetBatchLines, -1
SetWinDelay, 1
CoordMode, Mouse, Screen

notificationTitle = %1%
notificationText = %2%
Gui, +ToolWindow +AlwaysOnTop -Caption +Border +
Gui, Color, 2A2B2F
Gui, Margin, 0, 0
Gui, Font, s30 c7FA2CF, Segoe UI Light
Gui, Add, Text, x10, %notificationTitle%
Gui, Font
Gui, Font, s11 cWhite, Segoe UI
Gui, Add, Text, xm x15 r3, %notificationText%
Gui, Add, Text, ym
Gui, Show, NA, AHKNotification
WinGet, winId, ID, AHKNotification

SetTimer, WatchMouse, 1000
return

WatchMouse:
{
	t := 255
	Loop, 128
	{
		MouseGetPos, mouseX, mouseY
		WinGetPos, winX, winY, winW, winH, AHKNotification
		if ((mouseX >= winX && mouseX <= (winX+winW))
			&& (mouseY >= winY && mouseY <= (winY+winH))) {
			WinSet, Trans, 255, AHKNotification
			break
		}
		WinSet, Trans, %t%, AHKNotification
		t := t-2
		Sleep, 1
		if (t <= 0) {
			ExitApp
		}
	}
	return
}