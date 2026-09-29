; Runs double-tap.exe, presses Alt+X, and checks that exactly two X presses
; come out with a 45-120 ms gap. Writes the result to test-result.txt.
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
ih.KeyOpt("x", "N")
ih.OnKeyDown := (*) => events.Push({t: qpc(), alt: GetKeyState("Alt")})
ih.Start()

SendLevel 1
Send "!x"
Sleep 500
ih.Stop()
ProcessClose "double-tap.exe"

; Drop the Alt+X trigger itself, keep what the script sent.
sent := []
for e in events
    if !e.alt
        sent.Push(e.t)

gap := sent.Length = 2 ? sent[2] - sent[1] : 0
ok := sent.Length = 2 && gap >= 45 && gap <= 120
FileAppend (ok ? "PASS" : "FAIL") ": " sent.Length " x presses, gap " Round(gap) " ms`n", out
ExitApp ok ? 0 : 1
