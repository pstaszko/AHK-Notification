/*
	feature requets:
		* mouse over stop fade out
		* click -> copy message to clipboard
		* specify location with param
*/


SetBatchLines, -1
SetWinDelay, 1

notificationTitle = %1%
notificationText = %2%
Gui, +ToolWindow +AlwaysOnTop -Caption +Border
Gui, Color, 2A2B2F
Gui, Margin, 0, 0
Gui, Font, s30 c7FA2CF, Segoe UI Light
Gui, Add, Text, x10, %notificationTitle%
Gui, Font
Gui, Font, s11 cWhite, Segoe UI
Gui, Add, Text, xm x15 r3, %notificationText%
Gui, Add, Text, ym
Gui, Show, NA, AHKNotification

Sleep, 1000
t := 255
Loop, 128
{
	WinSet, Trans, %t%, AHKNotification
	t := t-2
	Sleep, 1
}
ExitApp