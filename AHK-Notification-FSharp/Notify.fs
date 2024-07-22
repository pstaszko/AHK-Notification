namespace AHK_Notification_FSharp
open System
module internal Utils =
    let str (o: Object) = o |> function null -> "" | x -> x.ToString()
    let isNotEmpty = str >> fun x -> x.Trim().Length > 0

module Notify =
    open Utils
    type Parameters =
        {
            TitleSize: int
            TitleColor: string
            TitleFont: string
            MessageSize: int
            MessageColor: string
            LogPath: string
            MessageFont: string
            NotificationTitle: string
            NotificationText: string
            BackgroundColor: string
            PadSize: int
            IgnoreHover: bool
            MaximumMessageLength: int
        }
        static member Default title message =
            {
                TitleSize = 30
                TitleColor = "7FA2CF"
                LogPath = ""
                TitleFont = "Segoe UI Light"
                MessageSize = 11
                MessageColor = "White"
                MessageFont = "Segoe UI"
                BackgroundColor = "2A2B2F"
                PadSize = 30
                IgnoreHover = false
                NotificationTitle = title
                NotificationText = message
                MaximumMessageLength = 100
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

    //let private log exePath args =
    //    let exe = System.IO.Path.GetFullPath(exePath)
    //    let logMessage = $@"{exe} {args}"
    //    //System.IO.File.AppendAllText(logPath, logMessage + Environment.NewLine) |> ignore
    //    let q = logMessage
    //    ()

    let Notify (parameters: Parameters) =
        let exePath = @"Notification.exe"
        if System.IO.File.Exists(exePath) then
            let message = parameters.NotificationText.Replace("\\", "\\\\").Substring(0, Math.Min(parameters.NotificationText.Length, parameters.MaximumMessageLength))
            let args =
                [
                   //Op: Auto
                   "notificationText" , message
                   "notificationTitle", parameters.NotificationTitle
                   "logFile"          , parameters.LogPath
                   "backgroundColor"  , parameters.BackgroundColor
                   "padSize"          , parameters.PadSize |> str
                   "titleSize"        , parameters.TitleSize |> str
                   "titleColor"       , parameters.TitleColor
                   "titleFont"        , parameters.TitleFont
                   "messageSize"      , parameters.MessageSize |> str
                   "messageColor"     , parameters.MessageColor
                   "messageFont"      , parameters.MessageFont
                   "ignoreHover"      , if parameters.IgnoreHover then "1" else "0"
                   //Op: End
                ]
                |> Seq.filter (snd >> isNotEmpty)
                |> Seq.map (fun (k, v) -> 
                    let v = v.Replace("\\", "\\\\")
                    $@"""%s{k}=%s{v}""")
                |> String.concat " "
                //|> fun x -> $@"""%s{exePath}"" {x}"
            //log exePath args
            System.Diagnostics.Process.Start(exePath, args) |> ignore
        else
            failwithf "%s doesn't exist." exePath

    //let NotifyBasic (title: string) (message: string) =
    //    Notify "4e5057" title message