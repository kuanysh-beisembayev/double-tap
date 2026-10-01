; Runs double-tap.exe, holds Alt and presses D twice. Expects to see, in order:
; the first trigger D, then X and K from the script (under 20 ms apart), and the same again.
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
ih.KeyOpt("dxk", "N")
ih.OnKeyDown := (ih, vk, sc) => events.Push({t: qpc(), key: GetKeyName(Format("vk{:x}", vk)), alt: GetKeyState("Alt")})
ih.Start()

SendLevel 1
Send "{Alt down}"
Sleep 50
Send "{d}"
Sleep 400
Send "{d}"
Sleep 400
altRestored := GetKeyState("Alt")
Send "{Alt up}"
Sleep 200
ih.Stop()
ProcessClose "double-tap.exe"

sent := ""
for e in events
    sent .= e.key

gap := events.Length >= 3 ? events[3].t - events[2].t : 0
ok := sent = "dxkdxk" && gap >= 0 && gap <= 20
FileAppend (ok ? "PASS" : "FAIL") ": keys seen [" sent "], X-K gap " Round(gap) " ms, Alt restored " altRestored "`n", out
ExitApp ok ? 0 : 1
