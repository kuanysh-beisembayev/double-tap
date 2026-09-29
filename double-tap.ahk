; Huskar armlet double toggle. AutoHotkey v2.
; X     = armlet slot hotkey in Dota settings (normal cast). Plain X toggles once as usual.
; Alt+X = double toggle.
#Requires AutoHotkey v2.0
#SingleInstance Force
#HotIf WinActive("ahk_exe dota2.exe")

!x:: {
    Send "x"
    Sleep 60
    Send "x"
}

#HotIf
