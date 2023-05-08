#Requires AutoHotkey v2.0  ; prefer 64-bit, Unicode.
 
; UIA Library: https://github.com/Descolada/UIA-v2
#include <UIA>

/**
 * Detecting the current audio status of Zoom Meetings.
 * @param {number} retry Number of retries.
 * @param {string} language If the language is "en", the function returns: (1: Unmuted/ 0: Muted)
 * @returns {Number/ String} If the language is not "en", the function returns the same tooltip texts that you will see when you are hovering on the audio icon. 
 */
ZoomAudio(retry := 5, language := "en")
{
	SetWinDelay -1

	myAudio   := ""  
	zoomMain  := "ahk_class ZPContentViewWndClass ahk_exe Zoom.exe"
	zoomFloat := "ahk_class ZPFloatVideoWndClass ahk_exe Zoom.exe"
	
	If !WinExist("ahk_exe Zoom.exe")
		Return TrayTip("Zoom Windows Not Found", , "0x3")

	Loop retry
	{
		Try (myAudio := (WinGetMinMax(zoomMain " ahk_exe Zoom.exe") != -1)
			? UIA.ElementFromHandle(zoomMain).WaitElementFromPath("XXY0", 3000).Name
			: UIA.ElementFromHandle(zoomFloat).WaitElementFromPath("YX0", 3000).Name)
		Catch 
			ControlSend "{Alt}", , zoomMain
	} Until myAudio != ""

	Return ((language = "en") ? (StrSplit(myAudio, A_Space, ",")[1] = "Unmute") : myAudio)
}
