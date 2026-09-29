; Armlet double toggle. AutoHotkey v2.
; X     = Armlet slot hotkey in Dota 2. Plain X toggles once.
; Alt+X = toggles twice.
#Requires AutoHotkey v2.0
#SingleInstance Force

!x:: {
    Send "x"
    Sleep 60
    Send "x"
}
