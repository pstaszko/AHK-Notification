#SingleInstance, Off
SetBatchLines, -1
SetWinDelay, 1
CoordMode, Mouse, Screen-

; catch incoming params
notificationTitle = %1%
notificationText = %2%

; get the count of any existing notification windows
WinGet, winCount, Count, AHKNotification

; adjust this notification y offset according to the existing count
yPosition := 125*winCount

; set a unique notification title
winTitle := "AHKNotification - " newGuid_Small()

; notification display settings
Gui, +ToolWindow +AlwaysOnTop -Caption +Border
Gui, Color, 2A2B2F
Gui, Margin, 0, 0
Gui, Font, s30 c7FA2CF, Segoe UI Light
Gui, Add, Text, x10 vtxtMessageTitle, %notificationTitle%
Gui, Font
Gui, Font, s11 cWhite, Segoe UI
Gui, Add, Text, xm x15 r3 vtxtMessageText, %notificationText%
Gui, Add, Text, ym
Gui, Show, % "NA y" yPosition, %winTitle%

; start a 1 second timer to watch the position of the mouse
SetTimer, WatchMouse, 1000
return

; catch left clicks for copying the text
~$LButton::
{
	; get the id of the window the mouse is over
	MouseGetPos,,, mouseWin
	
	; get the window title
	WinGetTitle, win, ahk_id %mouseWin%
	
	; if the mouse is over this notification, send the title and text to the clipboard
	if (win == winTitle) {
		GuiControlGet, messageTitle,, txtMessageTitle
		GuiControlGet, messageText,, txtMessageText
		Clipboard := messageTitle " - " messageText
	}
	return
}

; watch the mouse to see if it's over the notification
WatchMouse:
{
	; start the transparency at full
	t := 255
	
	; loop 128 times (~1/2 of 255)
	Loop, 128
	{
		; get the id of the window the mouse is over
		MouseGetPos,,, mouseWin
		
		; get the window title
		WinGetTitle, win, ahk_id %mouseWin%
		
		; if the mouse is over this notification
		if (win == winTitle) {
			
			; set the transparency of the notification back to full and exit the loop
			WinSet, Trans, 255, %winTitle%
			break
		}
		
		; otherwise set a new transparency level
		WinSet, Trans, %t%, %winTitle%
		
		; adjust the transparency for the next iteration
		t := t-2
		
		; throttle the looping for performance
		Sleep, 1
		
		; if the current transparency level is less then or equal to 0, exit
		if (t <= 0) {
			ExitApp
		}
	}
	return
}

; quick and dirty function for creating a small pseudo-guid
newGuid_Small() {
	charList := ["0","1","2","3","4","5","6","7","8","9","a","b","c","d","e","f"]
	guid := ""
	Loop, 8
	{
		Random, var, 1, 16
		guid := guid . charList[var]
	}
	return guid