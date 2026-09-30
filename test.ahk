; Runs double-tap.exe and checks:
; 1. holding Alt and pressing X twice sends X then N (45+ ms apart) each time,
; 2. F6 sends X then N.
#Requires AutoHotkey v2.0

out := A_ScriptDir "\test-result.txt"
Run A_ScriptDir "\double-tap.exe"
Sleep 1500

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
Send "{F6}"
Sleep 400
ih.Stop()
ProcessClose "double-tap.exe"

; Drop the Alt+X triggers themselves, keep what the script sent.
sent := "", times := []
for e in events
    if !e.alt
        sent .= e.key, times.Push(e.t)

gap := times.Length >= 2 ? times[2] - times[1] : 0
ok := sent = "xnxnxn" && gap >= 45 && gap <= 120
FileAppend (ok ? "PASS" : "FAIL") ": keys sent [" sent "], X-N gap " Round(gap) " ms`n", out
ExitApp ok ? 0 : 1
