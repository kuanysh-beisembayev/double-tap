; Armlet double toggle. AutoHotkey v2.
; X     = Armlet slot normal hotkey in Dota 2, N = quickcast hotkey of the same slot.
; Alt+X = releases Alt, presses X, then N 60 ms later, toggling twice.
; F6    = same without Alt involved (diagnostic).
;@Ahk2Exe-SetName double-tap
;@Ahk2Exe-SetDescription double-tap
;@Ahk2Exe-SetVersion 0.0.0
;@Ahk2Exe-SetMainIcon armlet.ico
#Requires AutoHotkey v2.0
#SingleInstance Force

; Alt is released first so Dota sees plain X and N, not Alt+X and Alt+N.
!x:: {
    Send "{Blind}{Alt up}"
    Sleep 20
    tap()
    if GetKeyState("Alt", "P")
        Send "{Blind}{Alt down}"
}

F6:: tap()

tap() {
    Send "{Blind}{x down}"
    Sleep 30
    Send "{Blind}{x up}"
    Sleep 30
    Send "{Blind}{n down}"
    Sleep 30
    Send "{Blind}{n up}"
}
