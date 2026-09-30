; Armlet double toggle. AutoHotkey v2.
; X     = Armlet slot normal hotkey in Dota 2, N = quickcast hotkey of the same slot.
; Alt+X = releases Alt, presses X, then N 10 ms later, toggling twice.
;@Ahk2Exe-SetName double-tap
;@Ahk2Exe-SetDescription double-tap
;@Ahk2Exe-SetVersion 0.0.0
;@Ahk2Exe-SetMainIcon armlet.ico
#Requires AutoHotkey v2.0
#SingleInstance Force

; Windows sleeps in ~16 ms steps by default. Ask for 1 ms resolution so short Sleeps are real.
DllCall("winmm\timeBeginPeriod", "UInt", 1)

; Track the physical Alt key ourselves. Our own Alt up/down sends below are
; ignored by hotkeys, so this stays correct while the script fiddles with Alt.
altHeld := false
~*Alt::global altHeld := true
~*Alt up::global altHeld := false

; Alt is released first so Dota sees plain X and N, not Alt+X and Alt+N.
#HotIf altHeld
*x:: {
    Send "{Blind}{Alt up}"
    Sleep 50
    tap()
    if altHeld
        Send "{Blind}{Alt down}"
}
#HotIf

tap() {
    Send "{Blind}{x down}"
    Sleep 5
    Send "{Blind}{x up}"
    Sleep 5
    Send "{Blind}{n down}"
    Sleep 5
    Send "{Blind}{n up}"
}
