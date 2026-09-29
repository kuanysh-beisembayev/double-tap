; Armlet double toggle. AutoHotkey v2.
; X     = Armlet slot hotkey in Dota 2. Plain X toggles once.
; Alt+X = toggles twice.
;@Ahk2Exe-SetName double-tap
;@Ahk2Exe-SetDescription double-tap
;@Ahk2Exe-SetVersion 0.0.0
#Requires AutoHotkey v2.0
#SingleInstance Force

; {x} sends the key by virtual code, so it works with any keyboard layout.
!x:: {
    Send "{x down}"
    Sleep 30
    Send "{x up}"
    Sleep 30
    Send "{x down}"
    Sleep 30
    Send "{x up}"
}
