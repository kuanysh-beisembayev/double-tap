; Armlet double toggle. AutoHotkey v2.
; D     = Armlet slot normal hotkey in Dota 2, K = quickcast hotkey of the same slot.
; Alt+X = releases Alt, presses X, and N together, toggling twice within one server tick.
;@Ahk2Exe-SetName double-tap
;@Ahk2Exe-SetDescription double-tap
;@Ahk2Exe-SetVersion 0.0.0
;@Ahk2Exe-SetMainIcon armlet.ico
#Requires AutoHotkey v2.0
#SingleInstance Force

SetKeyDelay -1, -1

; Track the physical Alt key ourselves. Our own Alt up/down sends below are
; ignored by hotkeys, so this stays correct while the script fiddles with Alt.
altHeld := false
~*Alt::global altHeld := true
~*Alt up::global altHeld := false

; Alt is released first so Dota sees plain D and K, not Alt+D and Alt+K.
#HotIf altHeld
*d:: {
    Send "{Blind}{Alt up}"
    Sleep 50
    tap()
    if altHeld
        Send "{Blind}{Alt down}"
}
#HotIf

tap() {
    Send "{Blind}{d down}{k down}"
    wait(5)
    Send "{Blind}{d up}{k up}"
}

; Windows cannot sleep for less than ~16 ms reliably, so spin on the high-resolution counter.
wait(ms) {
    DllCall("QueryPerformanceFrequency", "Int64*", &f := 0)
    DllCall("QueryPerformanceCounter", "Int64*", &start := 0)
    loop
        DllCall("QueryPerformanceCounter", "Int64*", &now := 0)
    until (now - start) * 1000 / f >= ms
}
