; Runs double-tap.exe and checks:
; 1. an older copy with a different exe name gets closed,
; 2. holding Alt and pressing X twice sends X, N, X, N with X and N at least 45 ms apart.
#Requires AutoHotkey v2.0

out := A_ScriptDir "\test-result.txt"
FileCopy A_ScriptDir "\double-tap.exe", A_ScriptDir "\double-tap-old.exe", true
Run A_ScriptDir "\double-tap-old.exe"
Sleep 1500
Run A_ScriptDir "\double-tap.exe"
Sleep 1500
oldClosed := !ProcessExist("double-tap-old.exe")

qpc() {
    DllCall("QueryPerformanceCounter", "Int64*", &c := 0)
    DllCall("QueryPerformanceFrequency", "Int64*", &f := 0)
    return c * 1000 / f
}

events := []
ih := InputHook("V")
ih.KeyOpt("xn", "N")
ih.OnKeyDown := (ih, vk, sc) => events.Push({t: qpc(), key: GetKeyName(Format("vk{:x}", vk)), alt: GetKeyState("Alt")})
ih.Start()

SendLevel 1
Send "{Alt down}"
Sleep 50
Send "{x}"
Sleep 400
Send "{x}"
Sleep 400
Send "{Alt up}"
Sleep 200
ih.Stop()
ProcessClose "double-tap.exe"

; Drop the Alt+X triggers themselves, keep what the script sent.
sent := "", times := []
for e in events
    if !e.alt
        sent .= e.key, times.Push(e.t)

gap := times.Length >= 2 ? times[2] - times[1] : 0
ok := oldClosed && sent = "xnxn" && gap >= 45 && gap <= 120
FileAppend (ok ? "PASS" : "FAIL") ": old copy closed " oldClosed ", keys sent [" sent "], X-N gap " Round(gap) " ms`n", out
ExitApp ok ? 0 : 1
