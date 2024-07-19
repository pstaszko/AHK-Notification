namespace AHK_Notification_FSharp
open System
open System.Text.RegularExpressions
module Notify =
    let growl (title: string) (message: string) =
        let regex = new Regex("^[0| ]+$")
        if regex.IsMatch(message) then
            printfn "Message contains only zeros or spaces."
        else
            let notifScript = @"C:\Dev\Releases\AHK-Notification\Stable\Notification.ahk"
            if System.IO.File.Exists(notifScript) then
                let title = title.Replace("\\", "\\\\")
                let message = message.Replace("\\", "\\\\").Substring(0, Math.Min(message.Length, 100))
                let exePath = @""
                let args = sprintf "\"%s\" \"notificationText=%s\" \"notificationTitle=%s\" \"logFile=c:\\temp\\notification.txt\" backgroundColor=4e5057 padsize=0 ignoreHover=1" notifScript message title
                System.Diagnostics.Process.Start(exePath, args) |> ignore
            else
                printfn "%s doesn't exist." notifScript