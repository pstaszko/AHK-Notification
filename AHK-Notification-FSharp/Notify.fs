namespace AHK_Notification_FSharp
open System
module internal Utils =
    let str (o: Object) = o |> function null -> "" | x -> x.ToString()
    let isNotEmpty = str >> fun x -> x.Trim().Length > 0

module Notify =
    open Utils
    type Parameters =
        {
            titleSize: int
            titleColor: string
            titleFont: string
            messageSize: int
            messageColor: string
            logPath: string
            messageFont: string
            notificationTitle: string
            notificationText: string
            backgroundColor: string
            padSize: int
            ignoreHover: bool
        }
        static member Default title message =
            {
                titleSize = 30
                titleColor = "7FA2CF"
                logPath = ""
                titleFont = "Segoe UI Light"
                messageSize = 11
                messageColor = "White"
                messageFont = "Segoe UI"
                backgroundColor = "2A2B2F"
                padSize = 30
                ignoreHover = false
                notificationTitle = title
                notificationText = message
            }
    (*

titleSize := 30
titleColor := "7FA2CF"
titleFont := "Segoe UI Light"
messageSize := 11
messageColor := "White"
messageFont := "Segoe UI"
backgroundColor := "2A2B2F"
padSize := 30
ignoreHover := 0

    *)
    (*
	notificationTitle
	notificationText
	titleSize
	titleColor
	titleFont
	messageSize
	messageColor
	messageFont
	backgroundColor
	logPath (save a record of notification calls)
	padSize
    *)
    let private log exePath args =
        let exe = System.IO.Path.GetFullPath(exePath)
        let logMessage = $@"{exe} {args}"
        //System.IO.File.AppendAllText(logPath, logMessage + Environment.NewLine) |> ignore
        let q = logMessage
        ()
    let Notify (parameters: Parameters) =
        let exePath = @"Notification.exe"
        if System.IO.File.Exists(exePath) then
            //let title = parameters.notificationTitle.Replace("\\", "\\\\")
            let message = parameters.notificationText.Replace("\\", "\\\\").Substring(0, Math.Min(parameters.notificationText.Length, 100))
            let args =
                [
                   //Op: Auto
                   "notificationText" , message
                   "notificationTitle", parameters.notificationTitle
                   "logFile"          , parameters.logPath
                   "backgroundColor"  , parameters.backgroundColor
                   "padSize"          , parameters.padSize |> str
                   "titleSize"        , parameters.titleSize |> str
                   "titleColor"       , parameters.titleColor
                   "titleFont"        , parameters.titleFont
                   "messageSize"      , parameters.messageSize |> str
                   "messageColor"     , parameters.messageColor
                   "messageFont"      , parameters.messageFont
                   "ignoreHover"      , if parameters.ignoreHover then "1" else "0"
                   //Op: End
                ]
                |> Seq.filter (snd >> isNotEmpty)
                |> Seq.map (fun (k, v) -> 
                    let v = v.Replace("\\", "\\\\")
                    $@"""%s{k}=%s{v}""")
                |> String.concat " "
                //|> fun x -> $@"""%s{exePath}"" {x}"
            log exePath args
            System.Diagnostics.Process.Start(exePath, args) |> ignore
        else
            failwithf "%s doesn't exist." exePath

    //let NotifyBasic (title: string) (message: string) =
    //    Notify "4e5057" title message