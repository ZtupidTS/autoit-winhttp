#AutoIt3Wrapper_Au3Check_Parameters=-d -w 1 -w 2 -w 3 -w 4 -w 5 -w 6

#include-once
#include "WinHttpConstants.au3"

; #INDEX# ===================================================================================
; Title ...............: WinHttp
; File Name............: WinHttp.au3
; File Version.........: 1.5.0.0
; Min. AutoIt Version..: v3.3.2.0
; Description .........: AutoIt wrapper for WinHttp functions
; Author... ...........: trancexx, ProgAndy
; Dll .................: winhttp.dll, kernel32.dll
; ===========================================================================================

; #CONSTANTS# ===============================================================================
Global Const $hWINHTTPDLL__WINHTTP = DllOpen("winhttp.dll")
DllOpen("winhttp.dll") ; making sure reference count never reaches 0
;============================================================================================

; #CURRENT# =================================================================================
;_WinHttpAddRequestHeaders
;_WinHttpBinaryConcat
;_WinHttpCheckPlatform
;_WinHttpCloseHandle
;_WinHttpConnect
;_WinHttpCrackUrl
;_WinHttpCreateUrl
;_WinHttpDetectAutoProxyConfigUrl
;_WinHttpGetDefaultProxyConfiguration
;_WinHttpGetIEProxyConfigForCurrentUser
;_WinHttpOpen
;_WinHttpOpenRequest
;_WinHttpQueryDataAvailable
;_WinHttpQueryHeaders
;_WinHttpQueryOption
;_WinHttpReadData
;_WinHttpReceiveResponse
;_WinHttpSendRequest
;_WinHttpSetCredentials
;_WinHttpSetDefaultProxyConfiguration
;_WinHttpSetOption
;_WinHttpSetStatusCallback
;_WinHttpSetTimeouts
;_WinHttpSimpleReadData
;_WinHttpSimpleRequest
;_WinHttpSimpleSendRequest
;_WinHttpSimpleSendSSLRequest
;_WinHttpSimpleSSLRequest
;_WinHttpTimeFromSystemTime
;_WinHttpTimeToSystemTime
;_WinHttpWriteData
; ===========================================================================================

; #FUNCTION# ;===============================================================================
; Name...........: _WinHttpAddRequestHeaders
; Description ...: Adds one or more HTTP request headers to the HTTP request handle.
; Syntax.........: _WinHttpAddRequestHeaders ($hRequest, $sHeaders [, $iModifiers = Default ])
; Parameters ....: $hRequest - Handle returned by _WinHttpOpenRequest function.
;                  $sHeader - [optional] String that contains the header(s) to append to the request.
;                  $iModifier - Contains the flags used to modify the semantics of this function. Default is $WINHTTP_ADDREQ_FLAG_ADD_IF_NEW.
; Return values .: Success - Returns 1
;                  Failure - Returns 0 and sets @error:
;                  |1 - DllCall failed.
; Author ........: trancexx
; Modified.......:
; Remarks .......: In case of multiple additions at once, must use @CRLF to separate each $hRequest and responded $sHeaders and $iModifiers.
; Related .......: _WinHttpOpenRequest, _WinHttpQueryHeaders
; Link ..........: http://msdn.microsoft.com/en-us/library/aa384087(VS.85).aspx
; Example .......:
;============================================================================================
Func _WinHttpAddRequestHeaders($hRequest, $sHeader, $iModifier = Default)
	If $iModifier = Default Or $iModifier = -1 Then $iModifier = $WINHTTP_ADDREQ_FLAG_ADD_IF_NEW
	Local $aCall = DllCall($hWINHTTPDLL__WINHTTP, "bool", "WinHttpAddRequestHeaders", _
			"handle", $hRequest, _
			"wstr", $sHeader, _
			"dword", -1, _
			"dword", $iModifier)
	If @error Or Not $aCall[0] Then Return SetError(1, 0, 0)
	Return 1
EndFunc   ;==>_WinHttpAddRequestHeaders

; #FUNCTION# ;===============================================================================
; Name...........: _WinHttpBinaryConcat
; Description ...: Concatenates two binary data returned by _WinHttpReadData() in binary mode.
; Syntax.........: _WinHttpBinaryConcat(ByRef $bBinary1, ByRef $bBinary2)
; Parameters ....: $bBinary1 - Binary data that is to be concatenated.
;                  $bBinary2 - Binary data to concat.
; Return values .: Success - Returns concatenated binary data.
;                  Failure - Returns empty binary and sets @error:
;                  |1 - Invalid input.
; Author ........: ProgAndy
; Modified.......: trancexx
; Remarks .......:
; Related .......: _WinHttpReadData
; Link ..........:
; Example .......:
;============================================================================================
Func _WinHttpBinaryConcat(ByRef $bBinary1, ByRef $bBinary2)
	Switch IsBinary($bBinary1) + 2 * IsBinary($bBinary2)
		Case 0
			Return SetError(1, 0, Binary(''))
		Case 1
			Return $bBinary1
		Case 2
			Return $bBinary2
	EndSwitch
	Local $tAuxiliary = DllStructCreate("byte[" & BinaryLen($bBinary1) & "];byte[" & BinaryLen($bBinary2) & "]")
	DllStructSetData($tAuxiliary, 1, $bBinary1)
	DllStructSetData($tAuxiliary, 2, $bBinary2)
	Local $tOutput = DllStructCreate("byte[" & DllStructGetSize($tAuxiliary) & "]", DllStructGetPtr($tAuxiliary))
	Return DllStructGetData($tOutput, 1)
EndFunc   ;==>_WinHttpBinaryConcat

; #FUNCTION# ;===============================================================================
; Name...........: _WinHttpCheckPlatform
; Description ...: Determines whether the current platform is supported by this version of Microsoft Windows HTTP Services (WinHttp).
; Syntax.........: _WinHttpCheckPlatform()
; Parameters ....: None
; Return values .: Success - Returns 1 if current platform is supported
;                          - Returns 0 if current platform is not supported
;                  Failure - Returns 0 and sets @error:
;                  |1 - DllCall failed.
; Author ........: trancexx
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........: http://msdn.microsoft.com/en-us/library/aa384089(VS.85).aspx
; Example .......:
;============================================================================================
Func _WinHttpCheckPlatform()
	Local $aCall = DllCall($hWINHTTPDLL__WINHTTP, "bool", "WinHttpCheckPlatform")
	If @error Then Return SetError(1, 0, 0)
	Return $aCall[0]
EndFunc   ;==>_WinHttpCheckPlatform

; #FUNCTION# ;===============================================================================
; Name...........: _WinHttpCloseHandle
; Description ...: Closes a single handle.
; Syntax.........: _WinHttpCloseHandle($hInternet)
; Parameters ....: $hInternet - Valid handle to be closed.
; Return values .: Success - Returns 1
;                          - Sets @error to 0
;                  Failure - Returns 0 and sets @error:
;                  |1 - DllCall failed.
; Author ........: trancexx
; Modified.......:
; Remarks .......:
; Related .......: _WinHttpConnect, _WinHttpOpen, _WinHttpOpenRequest
; Link ..........: http://msdn.microsoft.com/en-us/library/aa384090(VS.85).aspx
; Example .......:
;============================================================================================
Func _WinHttpCloseHandle($hInternet)
	Local $aCall = DllCall($hWINHTTPDLL__WINHTTP, "bool", "WinHttpCloseHandle", "handle", $hInternet)
	If @error Or Not $aCall[0] Then Return SetError(1, 0, 0)
	Return 1
EndFunc   ;==>_WinHttpCloseHandle

; #FUNCTION# ;===============================================================================
; Name...........: _WinHttpConnect
; Description ...: Specifies the initial target server of an HTTP request and returns connection handle to an HTTP session for that initial target.
; Syntax.........: _WinHttpConnect($hSession, $sServerName [, $iServerPort = Default ])
; Parameters ....: $hSession - Valid WinHttp session handle returned by a previous call to WinHttpOpen.
;                  $sServerName - String that contains the host name of an HTTP server.
;                  $iServerPort - [optional] Integer that specifies the TCP/IP port on the server to which a connection is made (default is $INTERNET_DEFAULT_PORT)
; Return values .: Success - Returns a valid connection handle to the HTTP session
;                  Failure - Returns 0 and sets @error:
;                  |1 - DllCall failed.
; Author ........: trancexx
; Modified.......:
; Remarks .......: $nServerPort can be defined via global constants $INTERNET_DEFAULT_PORT, $INTERNET_DEFAULT_HTTP_PORT or $INTERNET_DEFAULT_HTTPS_PORT
; Related .......: _WinHttpOpen
; Link ..........: http://msdn.microsoft.com/en-us/library/aa384091(VS.85).aspx
; Example .......:
;============================================================================================
Func _WinHttpConnect($hSession, $sServerName, $iServerPort = Default)
	If $iServerPort = Default Or $iServerPort = -1 Then $iServerPort = $INTERNET_DEFAULT_PORT
	Local $aCall = DllCall($hWINHTTPDLL__WINHTTP, "handle", "WinHttpConnect", _
			"handle", $hSession, _
			"wstr", $sServerName, _
			"dword", $iServerPort, _
			"dword", 0)
	If @error Or Not $aCall[0] Then Return SetError(1, 0, 0)
	Return $aCall[0]
EndFunc   ;==>_WinHttpConnect

; #FUNCTION# ;===============================================================================
; Name...........: _WinHttpCrackUrl
; Description ...: Separates a URL into its component parts such as host name and path.
; Syntax.........: _WinHttpCrackUrl($sURL [, $iFlag = Default ])
; Parameters ....: $sURL - String that contains the canonical URL to separate.
;                  $iFlag - [optional] Flag that control the operation. Default is $ICU_ESCAPE
; Return values .: Success - Returns array with 8 elements:
;                  |$array[0] - is scheme name,
;                  |$array[1] - is internet protocol scheme.,
;                  |$array[2] - is host name,
;                  |$array[3] - is port number,
;                  |$array[4] - is user name,
;                  |$array[5] - is password,
;                  |$array[6] - is URL path,
;                  |$array[7] - is extra information.
;                  Failure - Returns 0 and sets @error:
;                  |1 - DllCall failed.
; Author ........: ProgAndy
; Modified.......: trancexx
; Remarks .......: $iFlag is defined in WinHttpConstants.au3 and can be:
;                  |$ICU_DECODE - Converts characters that are "escape encoded" (%xx) to their non-escaped form.
;                  |$ICU_ESCAPE - Escapes certain characters to their escape sequences (%xx).
; Related .......: _WinHttpCreateUrl
; Link ..........: http://msdn.microsoft.com/en-us/library/aa384092(VS.85).aspx
; Example .......:
;============================================================================================
Func _WinHttpCrackUrl($sURL, $iFlag = Default)
	If $iFlag = Default Or $iFlag = -1 Then $iFlag = $ICU_ESCAPE
	Local $tURL_COMPONENTS = DllStructCreate("dword StructSize;" & _
			"ptr SchemeName;" & _
			"dword SchemeNameLength;" & _
			"int Scheme;" & _
			"ptr HostName;" & _
			"dword HostNameLength;" & _
			"word Port;" & _
			"ptr UserName;" & _
			"dword UserNameLength;" & _
			"ptr Password;" & _
			"dword PasswordLength;" & _
			"ptr UrlPath;" & _
			"dword UrlPathLength;" & _
			"ptr ExtraInfo;" & _
			"dword ExtraInfoLength")
	DllStructSetData($tURL_COMPONENTS, 1, DllStructGetSize($tURL_COMPONENTS))
	Local $tBuffers[6]
	Local $iURLLen = StringLen($sURL)
	For $i = 0 To 5
		$tBuffers[$i] = DllStructCreate("wchar[" & $iURLLen + 1 & "]")
	Next
	DllStructSetData($tURL_COMPONENTS, "SchemeNameLength", $iURLLen)
	DllStructSetData($tURL_COMPONENTS, "SchemeName", DllStructGetPtr($tBuffers[0]))
	DllStructSetData($tURL_COMPONENTS, "HostNameLength", $iURLLen)
	DllStructSetData($tURL_COMPONENTS, "HostName", DllStructGetPtr($tBuffers[1]))
	DllStructSetData($tURL_COMPONENTS, "UserNameLength", $iURLLen)
	DllStructSetData($tURL_COMPONENTS, "UserName", DllStructGetPtr($tBuffers[2]))
	DllStructSetData($tURL_COMPONENTS, "PasswordLength", $iURLLen)
	DllStructSetData($tURL_COMPONENTS, "Password", DllStructGetPtr($tBuffers[3]))
	DllStructSetData($tURL_COMPONENTS, "UrlPathLength", $iURLLen)
	DllStructSetData($tURL_COMPONENTS, "UrlPath", DllStructGetPtr($tBuffers[4]))
	DllStructSetData($tURL_COMPONENTS, "ExtraInfoLength", $iURLLen)
	DllStructSetData($tURL_COMPONENTS, "ExtraInfo", DllStructGetPtr($tBuffers[5]))
	Local $aCall = DllCall($hWINHTTPDLL__WINHTTP, "bool", "WinHttpCrackUrl", _
			"wstr", $sURL, _
			"dword", $iURLLen, _
			"dword", $iFlag, _
			"ptr", DllStructGetPtr($tURL_COMPONENTS))
	If @error Or Not $aCall[0] Then Return SetError(1, 0, 0)
	Local $aRet[8] = [DllStructGetData($tBuffers[0], 1), _
			DllStructGetData($tURL_COMPONENTS, "Scheme"), _
			DllStructGetData($tBuffers[1], 1), _
			DllStructGetData($tURL_COMPONENTS, "Port"), _
			DllStructGetData($tBuffers[2], 1), _
			DllStructGetData($tBuffers[3], 1), _
			DllStructGetData($tBuffers[4], 1), _
			DllStructGetData($tBuffers[5], 1)]
	Return $aRet
EndFunc   ;==>_WinHttpCrackUrl

; #FUNCTION# ;===============================================================================
; Name...........: _WinHttpCreateUrl
; Description ...: Creates a URL from array of components such as the host name and path.
; Syntax.........: _WinHttpCreateUrl($aURLArray)
; Parameters ....: $sURL - String that contains the canonical URL to separate.
; Return values .: Success - Returns created URL
;                  Failure - Returns empty string and sets @error:
;                  |1 - Invalid input.
;                  |2 - Initial DllCall failed.
;                  |3 - Main DllCall failed
; Author ........: ProgAndy
; Modified.......: trancexx
; Remarks .......: Input is one dimensional 8 elements in size array:
;                  |first element [0] is scheme name,
;                  |second element [1] is internet protocol scheme.,
;                  |third element [2] is host name,
;                  |fourth element [3] is port number,
;                  |fifth element [4] is user name,
;                  |sixth element [5] is password,
;                  |seventh element [6] is URL path,
;                  |eighth element [7] is extra information.
; Related .......: _WinHttpCrackUrl
; Link ..........: http://msdn.microsoft.com/en-us/library/aa384093(VS.85).aspx
; Example .......:
;============================================================================================
Func _WinHttpCreateUrl($aURLArray)
	If UBound($aURLArray) - 8 Then Return SetError(1, 0, "")
	Local $tURL_COMPONENTS = DllStructCreate("dword StructSize;" & _
			"ptr SchemeName;" & _
			"dword SchemeNameLength;" & _
			"int Scheme;" & _
			"ptr HostName;" & _
			"dword HostNameLength;" & _
			"word Port;" & _
			"ptr UserName;" & _
			"dword UserNameLength;" & _
			"ptr Password;" & _
			"dword PasswordLength;" & _
			"ptr UrlPath;" & _
			"dword UrlPathLength;" & _
			"ptr ExtraInfo;" & _
			"dword ExtraInfoLength;")
	DllStructSetData($tURL_COMPONENTS, 1, DllStructGetSize($tURL_COMPONENTS))
	Local $tBuffers[6][2]
	$tBuffers[0][1] = StringLen($aURLArray[0])
	If $tBuffers[0][1] Then
		$tBuffers[0][0] = DllStructCreate("wchar[" & $tBuffers[0][1] + 1 & "]")
		DllStructSetData($tBuffers[0][0], 1, $aURLArray[0])
	EndIf
	$tBuffers[1][1] = StringLen($aURLArray[2])
	If $tBuffers[1][1] Then
		$tBuffers[1][0] = DllStructCreate("wchar[" & $tBuffers[1][1] + 1 & "]")
		DllStructSetData($tBuffers[1][0], 1, $aURLArray[2])
	EndIf
	$tBuffers[2][1] = StringLen($aURLArray[4])
	If $tBuffers[2][1] Then
		$tBuffers[2][0] = DllStructCreate("wchar[" & $tBuffers[2][1] + 1 & "]")
		DllStructSetData($tBuffers[2][0], 1, $aURLArray[4])
	EndIf
	$tBuffers[3][1] = StringLen($aURLArray[5])
	If $tBuffers[3][1] Then
		$tBuffers[3][0] = DllStructCreate("wchar[" & $tBuffers[3][1] + 1 & "]")
		DllStructSetData($tBuffers[3][0], 1, $aURLArray[5])
	EndIf
	$tBuffers[4][1] = StringLen($aURLArray[6])
	If $tBuffers[4][1] Then
		$tBuffers[4][0] = DllStructCreate("wchar[" & $tBuffers[4][1] + 1 & "]")
		DllStructSetData($tBuffers[4][0], 1, $aURLArray[6])
	EndIf
	$tBuffers[5][1] = StringLen($aURLArray[7])
	If $tBuffers[5][1] Then
		$tBuffers[5][0] = DllStructCreate("wchar[" & $tBuffers[5][1] + 1 & "]")
		DllStructSetData($tBuffers[5][0], 1, $aURLArray[7])
	EndIf
	DllStructSetData($tURL_COMPONENTS, "SchemeNameLength", $tBuffers[0][1])
	DllStructSetData($tURL_COMPONENTS, "SchemeName", DllStructGetPtr($tBuffers[0][0]))
	DllStructSetData($tURL_COMPONENTS, "HostNameLength", $tBuffers[1][1])
	DllStructSetData($tURL_COMPONENTS, "HostName", DllStructGetPtr($tBuffers[1][0]))
	DllStructSetData($tURL_COMPONENTS, "UserNameLength", $tBuffers[2][1])
	DllStructSetData($tURL_COMPONENTS, "UserName", DllStructGetPtr($tBuffers[2][0]))
	DllStructSetData($tURL_COMPONENTS, "PasswordLength", $tBuffers[3][1])
	DllStructSetData($tURL_COMPONENTS, "Password", DllStructGetPtr($tBuffers[3][0]))
	DllStructSetData($tURL_COMPONENTS, "UrlPathLength", $tBuffers[4][1])
	DllStructSetData($tURL_COMPONENTS, "UrlPath", DllStructGetPtr($tBuffers[4][0]))
	DllStructSetData($tURL_COMPONENTS, "ExtraInfoLength", $tBuffers[5][1])
	DllStructSetData($tURL_COMPONENTS, "ExtraInfo", DllStructGetPtr($tBuffers[5][0]))
	DllStructSetData($tURL_COMPONENTS, "Scheme", $aURLArray[1])
	DllStructSetData($tURL_COMPONENTS, "Port", $aURLArray[3])
	Local $aCall = DllCall($hWINHTTPDLL__WINHTTP, "bool", "WinHttpCreateUrl", _
			"ptr", DllStructGetPtr($tURL_COMPONENTS), _
			"dword", $ICU_ESCAPE, _
			"ptr", 0, _
			"dword*", 0)
	If @error Then Return SetError(2, 0, "")
	Local $iURLLen = $aCall[4]
	Local $URLBuffer = DllStructCreate("wchar[" & ($iURLLen + 1) & "]")
	$aCall = DllCall($hWINHTTPDLL__WINHTTP, "bool", "WinHttpCreateUrl", _
			"ptr", DllStructGetPtr($tURL_COMPONENTS), _
			"dword", $ICU_ESCAPE, _
			"ptr", DllStructGetPtr($URLBuffer), _
			"dword*", $iURLLen)
	If @error Or Not $aCall[0] Then Return SetError(3, 0, "")
	Return DllStructGetData($URLBuffer, 1)
EndFunc   ;==>_WinHttpCreateUrl

; #FUNCTION# ;===============================================================================
; Name...........: _WinHttpDetectAutoProxyConfigUrl
; Description ...: Finds the URL for the Proxy Auto-Configuration (PAC) file.
; Syntax.........: _WinHttpDetectAutoProxyConfigUrl($iAutoDetectFlags)
; Parameters ....: $iAutoDetectFlags - Specifies what protocols to use to locate the PAC file.
; Return values .: Success - Returns URL for the PAC file.
;                  Failure - Returns empty string and sets @error:
;                  |1 - DllCall failed.
;                  |2 - Internal failure.
; Author ........: trancexx
; Modified.......:
; Remarks .......: $iAutoDetectFlags defined in WinHttpconstants.au3
; Related .......: _WinHttpGetDefaultProxyConfiguration, _WinHttpGetIEProxyConfigForCurrentUser, _WinHttpSetDefaultProxyConfiguration
; Link ..........: http://msdn.microsoft.com/en-us/library/aa384094(VS.85).aspx
; Example .......:
;============================================================================================
Func _WinHttpDetectAutoProxyConfigUrl($iAutoDetectFlags)
	Local $aCall = DllCall($hWINHTTPDLL__WINHTTP, "bool", "WinHttpDetectAutoProxyConfigUrl", "dword", $iAutoDetectFlags, "ptr*", 0)
	If @error Or Not $aCall[0] Then Return SetError(1, 0, "")
	Local $pString = $aCall[2]
	If $pString Then
		Local $iLen = __WinHttpPtrStringLenW($pString)
		If @error Then Return SetError(2, 0, "")
		Local $tString = DllStructCreate("wchar[" & $iLen + 1 & "]", $pString)
		Local $sString = DllStructGetData($tString, 1)
		__WinHttpMemGlobalFree($pString)
		Return $sString
	EndIf
	Return ""
EndFunc   ;==>_WinHttpDetectAutoProxyConfigUrl


; #FUNCTION# ;===============================================================================
; Name...........: _WinHttpGetDefaultProxyConfiguration
; Description ...: Retrieves the default WinHttp proxy configuration.
; Syntax.........: _WinHttpGetDefaultProxyConfiguration()
; Parameters ....: None.
; Return values .: Success - Returns array with 3 elements:
;                  |$array[0] - is integer value that contains the access type,
;                  |$array[1] - is string value that contains the proxy server list,
;                  |$array[2] - is string value that contains the proxy bypass list.
;                  Failure - Returns 0 and sets @error:
;                  |1 - DllCall failed.
; Author ........: trancexx
; Modified.......:
; Remarks .......: Access types are defined in WinHttpconstants.au3:
;                  |$WINHTTP_ACCESS_TYPE_DEFAULT_PROXY = 0
;                  |$WINHTTP_ACCESS_TYPE_NO_PROXY = 1
;                  |$WINHTTP_ACCESS_TYPE_NAMED_PROXY = 3
; Related .......: _WinHttpDetectAutoProxyConfigUrl, _WinHttpGetIEProxyConfigForCurrentUser, _WinHttpSetDefaultProxyConfiguration
; Link ..........: http://msdn.microsoft.com/en-us/library/aa384095(VS.85).aspx
; Example .......:
;============================================================================================
Func _WinHttpGetDefaultProxyConfiguration()
	Local $tWINHTTP_PROXY_INFO = DllStructCreate("dword AccessType;" & _
			"ptr Proxy;" & _
			"ptr ProxyBypass")
	Local $aCall = DllCall($hWINHTTPDLL__WINHTTP, "bool", "WinHttpGetDefaultProxyConfiguration", "ptr", DllStructGetPtr($tWINHTTP_PROXY_INFO))
	If @error Or Not $aCall[0] Then Return SetError(1, 0, 0)
	Local $iAccessType = DllStructGetData($tWINHTTP_PROXY_INFO, "AccessType")
	Local $pProxy = DllStructGetData($tWINHTTP_PROXY_INFO, "Proxy")
	Local $pProxyBypass = DllStructGetData($tWINHTTP_PROXY_INFO, "ProxyBypass")
	Local $sProxy
	If $pProxy Then
		Local $iProxyLen = __WinHttpPtrStringLenW($pProxy)
		If Not @error Then
			Local $tProxy = DllStructCreate("wchar[" & $iProxyLen + 1 & "]", $pProxy)
			$sProxy = DllStructGetData($tProxy, 1)
			__WinHttpMemGlobalFree($pProxy)
		EndIf
	EndIf
	Local $sProxyBypass
	If $pProxyBypass Then
		Local $iProxyBypassLen = __WinHttpPtrStringLenW($pProxyBypass)
		If Not @error Then
			Local $tProxyBypass = DllStructCreate("wchar[" & $iProxyBypassLen + 1 & "]", $pProxyBypass)
			$sProxyBypass = DllStructGetData($tProxyBypass, 1)
			__WinHttpMemGlobalFree($pProxyBypass)
		EndIf
	EndIf
	Local $aRet[3] = [$iAccessType, $sProxy, $sProxyBypass]
	Return $aRet
EndFunc   ;==>_WinHttpGetDefaultProxyConfiguration

; #FUNCTION# ;===============================================================================
; Name...........: _WinHttpGetIEProxyConfigForCurrentUser
; Description ...: Retrieves the Internet Explorer proxy configuration for the current user.
; Syntax.........: _WinHttpGetIEProxyConfigForCurrentUser()
; Parameters ....: None.
; Return values .: Success - Returns array with 4 elements:
;                  |$array[0] - if 1 indicates that the Internet Explorer proxy configuration for the current user specifies "automatically detect settings",
;                  |$array[1] - is string that contains the auto-configuration URL if the Internet Explorer proxy configuration for the current user specifies "Use automatic proxy configuration",
;                  |$array[2] - is string that contains the proxy URL if the Internet Explorer proxy configuration for the current user specifies "use a proxy server",
;                  |$array[3] - is string that contains the optional proxy by-pass server list.
;                  Failure - Returns 0 and sets @error:
;                  |1 - DllCall failed.
;                  |2 - Internal failure.
; Author ........: trancexx
; Modified.......:
; Remarks .......:
; Related .......: _WinHttpDetectAutoProxyConfigUrl, _WinHttpGetDefaultProxyConfiguration, _WinHttpSetDefaultProxyConfiguration
; Link ..........: http://msdn.microsoft.com/en-us/library/aa384096(VS.85).aspx
; Example .......:
;============================================================================================
Func _WinHttpGetIEProxyConfigForCurrentUser()
	Local $tWINHTTP_CURRENT_USER_IE_PROXY_CONFIG = DllStructCreate("int AutoDetect;" & _
			"ptr AutoConfigUrl;" & _
			"ptr Proxy;" & _
			"ptr ProxyBypass;")
	Local $aCall = DllCall($hWINHTTPDLL__WINHTTP, "bool", "WinHttpGetIEProxyConfigForCurrentUser", "ptr", DllStructGetPtr($tWINHTTP_CURRENT_USER_IE_PROXY_CONFIG))
	If @error Or Not $aCall[0] Then Return SetError(1, 0, 0)
	Local $iAutoDetect = DllStructGetData($tWINHTTP_CURRENT_USER_IE_PROXY_CONFIG, "AutoDetect")
	Local $pAutoConfigUrl = DllStructGetData($tWINHTTP_CURRENT_USER_IE_PROXY_CONFIG, "AutoConfigUrl")
	Local $pProxy = DllStructGetData($tWINHTTP_CURRENT_USER_IE_PROXY_CONFIG, "Proxy")
	Local $pProxyBypass = DllStructGetData($tWINHTTP_CURRENT_USER_IE_PROXY_CONFIG, "ProxyBypass")
	Local $sAutoConfigUrl
	If $pAutoConfigUrl Then
		Local $iAutoConfigUrlLen = __WinHttpPtrStringLenW($pAutoConfigUrl)
		If Not @error Then
			Local $tAutoConfigUrl = DllStructCreate("wchar[" & $iAutoConfigUrlLen + 1 & "]", $pAutoConfigUrl)
			$sAutoConfigUrl = DllStructGetData($tAutoConfigUrl, 1)
			__WinHttpMemGlobalFree($pProxyBypass)
		EndIf
	EndIf
	Local $sProxy
	If $pProxy Then
		Local $iProxyLen = __WinHttpPtrStringLenW($pProxy)
		If Not @error Then
			Local $tProxy = DllStructCreate("wchar[" & $iProxyLen + 1 & "]", $pProxy)
			$sProxy = DllStructGetData($tProxy, 1)
			__WinHttpMemGlobalFree($pProxy)
		EndIf
	EndIf
	Local $sProxyBypass
	If $pProxyBypass Then
		Local $iProxyBypassLen = __WinHttpPtrStringLenW($pProxyBypass)
		If Not @error Then
			Local $tProxyBypass = DllStructCreate("wchar[" & $iProxyBypassLen + 1 & "]", $pProxyBypass)
			$sProxyBypass = DllStructGetData($tProxyBypass, 1)
			__WinHttpMemGlobalFree($pProxyBypass)
		EndIf
	EndIf
	Local $aOutput[4] = [$iAutoDetect, $sAutoConfigUrl, $sProxy, $sProxyBypass]
	Return $aOutput
EndFunc   ;==>_WinHttpGetIEProxyConfigForCurrentUser

; #FUNCTION# ;===============================================================================
; Name...........: _WinHttpOpen
; Description ...: Initializes the use of WinHttp functions and returns a WinHttp-session handle.
; Syntax.........: _WinHttpOpen([$sUserAgent = Default [, $iAccessType = Default [, $sProxyName = Default [, $sProxyBypass = Default [, $iFlag = Default ]]]]])
; Parameters ....: $sUserAgent - [optional] String that contains the name of the application or entity calling the WinHttp functions.
;                  $iAccessType - [optional] Type of access required.
;                  $sProxyName - [optional] String that contains the name of the proxy server to use when proxy access is specified by setting $iAccessType to $WINHTTP_ACCESS_TYPE_NAMED_PROXY.
;                  $sProxyBypass - [optional] String that contains an optional list of host names or IP addresses, or both, that should not be routed through the proxy when $iAccessType is set to $WINHTTP_ACCESS_TYPE_NAMED_PROXY.
;                  $iFlag - [optional] Integer that contains the flags that indicate various options affecting the behavior of this function.
; Return values .: Success - Returns valid session handle.
;                  Failure - Returns 0 and sets @error:
;                  |1 - DllCall failed.
; Author ........: trancexx
; Modified.......:
; Remarks .......: For asynchronous mode set $iFlag to $WINHTTP_FLAG_ASYNC
; Related .......: _WinHttpCloseHandle, _WinHttpConnect
; Link ..........: http://msdn.microsoft.com/en-us/library/aa384098(VS.85).aspx
; Example .......:
;============================================================================================
Func _WinHttpOpen($sUserAgent = Default, $iAccessType = Default, $sProxyName = Default, $sProxyBypass = Default, $iFlag = Default)
	If $sUserAgent = Default Or $sUserAgent = -1 Then $sUserAgent = "AutoIt/3.3"
    If $iAccessType = Default Or $iAccessType = -1 Then $iAccessType = $WINHTTP_ACCESS_TYPE_NO_PROXY
    If $sProxyName = Default Or $sProxyName = -1 Then $sProxyName = $WINHTTP_NO_PROXY_NAME
    If $sProxyBypass = Default Or $sProxyBypass = -1 Then $sProxyBypass = $WINHTTP_NO_PROXY_BYPASS
    If $iFlag = Default Or $iFlag = -1 Then $iFlag = 0
    Local $aCall = DllCall($hWINHTTPDLL__WINHTTP, "handle", "WinHttpOpen", _
			"wstr", $sUserAgent, _
			"dword", $iAccessType, _
			"wstr", $sProxyName, _
			"wstr", $sProxyBypass, _
			"dword", $iFlag)
	If @error Or Not $aCall[0] Then Return SetError(1, 0, 0)
	Return $aCall[0]
EndFunc   ;==>_WinHttpOpen

; #FUNCTION# ;===============================================================================
; Name...........: _WinHttpOpenRequest
; Description ...: Creates an HTTP request handle.
; Syntax.........: _WinHttpOpenRequest($hConnect [, $sVerb = Default [, $sObjectName = Default [, $sVersion = Default [, $sReferrer = Default [, $sAcceptTypes = Default [, $iFlags = Default ]]]]]])
; Parameters ....: $hConnect - Handle to an HTTP session returned by _WinHttpConnect().
;                  $sVerb - [optional] String that contains the HTTP verb to use in the request. Default is "GET".
;                  $sObjectName - [optional] String that contains the name of the target resource of the specified HTTP verb.
;                  $sVersion - [optional] String that contains the HTTP version. Default is "HTTP/1.1"
;                  $sReferrer - [optional] String that specifies the URL of the document from which the URL in the request $sObjectName was obtained. Default is $WINHTTP_NO_REFERER.
;                  $sAcceptTypes - [optional] String that specifies media types accepted by the client. Default is $WINHTTP_DEFAULT_ACCEPT_TYPES
;                  $iFlags - [optional] Integer that contains the Internet flag values. Default is $WINHTTP_FLAG_ESCAPE_DISABLE
; Return values .: Success - Returns valid session handle.
;                  Failure - Returns 0 and sets @error:
;                  |1 - DllCall failed.
; Author ........: trancexx
; Modified.......:
; Remarks .......:
; Related .......: _WinHttpCloseHandle, _WinHttpConnect, _WinHttpSendRequest
; Link ..........: http://msdn.microsoft.com/en-us/library/aa384099(VS.85).aspx
; Example .......:
;============================================================================================
Func _WinHttpOpenRequest($hConnect, $sVerb = Default, $sObjectName = Default, $sVersion = Default, $sReferrer = Default, $sAcceptTypes = Default, $iFlags = Default)
	If $sVerb = Default Or $sVerb = -1 Then $sVerb = "GET"
	If $sObjectName = Default Or $sObjectName = -1 Then $sObjectName = ""
    If $sVersion = Default Or $sVersion = -1 Then $sVersion = "HTTP/1.1"
    If $sReferrer = Default Or $sReferrer = -1 Then $sReferrer = $WINHTTP_NO_REFERER
	If $sAcceptTypes = Default Or $sAcceptTypes = -1 Then $sAcceptTypes = $WINHTTP_DEFAULT_ACCEPT_TYPES
    If $iFlags = Default Or $iFlags = -1 Then $iFlags = $WINHTTP_FLAG_ESCAPE_DISABLE
    Local $aCall = DllCall($hWINHTTPDLL__WINHTTP, "handle", "WinHttpOpenRequest", _
			"handle", $hConnect, _
			"wstr", StringUpper($sVerb), _
			"wstr", $sObjectName, _
			"wstr", StringUpper($sVersion), _
			"wstr", $sReferrer, _
			"wstr*", $sAcceptTypes, _
			"dword", $iFlags)
	If @error Or Not $aCall[0] Then Return SetError(1, 0, 0)
	Return $aCall[0]
EndFunc   ;==>_WinHttpOpenRequest

; #FUNCTION# ;===============================================================================
; Name...........: _WinHttpQueryDataAvailable
; Description ...: Returns the availability to be read with _WinHttpReadData().
; Syntax.........: _WinHttpQueryDataAvailable($hRequest)
; Parameters ....: $hRequest - handle returned by _WinHttpOpenRequest().
; Return values .: Success - Returns 1 if data is available.
;                          - Returns 0 if no data is available.
;                          - @extended receives the number of available bytes.
;                  Failure - Returns 0 and sets @error:
;                  |1 - DllCall failed.
; Author ........: trancexx
; Modified.......: _WinHttpOpenRequest, _WinHttpQueryDataAvailable, _WinHttpReadData, _WinHttpReceiveResponse
; Remarks .......: _WinHttpReceiveResponse() must have been called for this handle and have completed before _WinHttpQueryDataAvailable is called.
; Related .......:
; Link ..........: http://msdn.microsoft.com/en-us/library/aa384101(VS.85).aspx
; Example .......:
;============================================================================================
Func _WinHttpQueryDataAvailable($hRequest)
	Local $aCall = DllCall($hWINHTTPDLL__WINHTTP, "bool", "WinHttpQueryDataAvailable", "handle", $hRequest, "dword*", 0)
	If @error Then Return SetError(1, 0, 0)
	Return SetExtended($aCall[2], $aCall[0])
EndFunc   ;==>_WinHttpQueryDataAvailable

; #FUNCTION# ;===============================================================================
; Name...........: _WinHttpQueryHeaders
; Description ...: Retrieves header information associated with an HTTP request.
; Syntax.........: _WinHttpQueryHeaders($hRequest [, $iInfoLevel = Default [, $sName = Default [, $iIndex = Default ]]])
; Parameters ....: $hRequest - handle returned by _WinHttpOpenRequest().
;                  $iInfoLevel - [optional] Specifies a combination of attribute and modifier flags. Default is $WINHTTP_QUERY_RAW_HEADERS_CRLF.
;                  $sName - [optional] String that contains the header name. Default is $WINHTTP_HEADER_NAME_BY_INDEX.
;                  $sName - [optional] Index used to enumerate multiple headers with the same name
; Return values .: Success - Returns string that contains header.
;                          - @extended is set to the index of the next header
;                  Failure - Returns empty string and sets @error:
;                  |1 - DllCall failed.
; Author ........: trancexx
; Modified.......:
; Remarks .......:
; Related .......: _WinHttpAddRequestHeaders, _WinHttpOpenRequest
; Link ..........: http://msdn.microsoft.com/en-us/library/aa384102(VS.85).aspx
; Example .......:
;============================================================================================
Func _WinHttpQueryHeaders($hRequest, $iInfoLevel = Default, $sName = Default, $iIndex = Default)
	If $iInfoLevel = Default Or $iInfoLevel = -1 Then $iInfoLevel = $WINHTTP_QUERY_RAW_HEADERS_CRLF
	If $sName = Default Or $sName = -1 Then $sName = $WINHTTP_HEADER_NAME_BY_INDEX
    If $iIndex = Default Or $iIndex = -1 Then $iIndex = $WINHTTP_NO_HEADER_INDEX
    Local $aCall = DllCall($hWINHTTPDLL__WINHTTP, "bool", "WinHttpQueryHeaders", _
			"handle", $hRequest, _
			"dword", $iInfoLevel, _
			"wstr", $sName, _
			"wstr", "", _
			"dword*", 65536, _
			"dword*", $iIndex)
	If @error Or Not $aCall[0] Then Return SetError(1, 0, "")
	Return SetExtended($aCall[6], $aCall[4])
EndFunc   ;==>_WinHttpQueryHeaders

; #FUNCTION# ;===============================================================================
; Name...........: _WinHttpQueryOption
; Description ...: Queries an Internet option on the specified handle.
; Syntax.........: _WinHttpQueryOption($hInternet, $iOption)
; Parameters ....: $hInternet - Handle on which to query information.
;                  $iOption - Integer value that contains the Internet option to query.
; Return values .: Success - Returns data containing requested information.
;                  Failure - Returns empty string and sets @error:
;                  |1 - Initial DllCall failed.
;                  |2 - Main DllCall failed.
; Author ........: trancexx
; Modified.......:
; Remarks .......: Type of the returned data varies on request.
; Related .......: _WinHttpSetOption
; Link ..........: http://msdn.microsoft.com/en-us/library/aa384103(VS.85).aspx
; Example .......:
;============================================================================================
Func _WinHttpQueryOption($hInternet, $iOption)
	Local $aCall = DllCall($hWINHTTPDLL__WINHTTP, "bool", "WinHttpQueryOption", _
			"handle", $hInternet, _
			"dword", $iOption, _
			"ptr", 0, _
			"dword*", 0)
	If @error Or $aCall[0] Then Return SetError(1, 0, "")
	Local $iSize = $aCall[4]
	Local $tBuffer
	Switch $iOption
		Case $WINHTTP_OPTION_CONNECTION_INFO, $WINHTTP_OPTION_PASSWORD, $WINHTTP_OPTION_PROXY_PASSWORD, $WINHTTP_OPTION_PROXY_USERNAME, $WINHTTP_OPTION_URL, $WINHTTP_OPTION_USERNAME, $WINHTTP_OPTION_USER_AGENT, _
				$WINHTTP_OPTION_PASSPORT_COBRANDING_TEXT, $WINHTTP_OPTION_PASSPORT_COBRANDING_URL
			$tBuffer = DllStructCreate("wchar[" & $iSize + 1 & "]")
		Case $WINHTTP_OPTION_PARENT_HANDLE, $WINHTTP_OPTION_CALLBACK
			$tBuffer = DllStructCreate("ptr")
		Case $WINHTTP_OPTION_CONNECT_TIMEOUT, $WINHTTP_AUTOLOGON_SECURITY_LEVEL_HIGH, $WINHTTP_AUTOLOGON_SECURITY_LEVEL_LOW, $WINHTTP_AUTOLOGON_SECURITY_LEVEL_MEDIUM, _
				$WINHTTP_OPTION_CONFIGURE_PASSPORT_AUTH, $WINHTTP_OPTION_CONNECT_RETRIES, $WINHTTP_OPTION_EXTENDED_ERROR, $WINHTTP_OPTION_HANDLE_TYPE, $WINHTTP_OPTION_MAX_CONNS_PER_1_0_SERVER, _
				$WINHTTP_OPTION_MAX_CONNS_PER_SERVER, $WINHTTP_OPTION_MAX_HTTP_AUTOMATIC_REDIRECTS, $WINHTTP_OPTION_RECEIVE_RESPONSE_TIMEOUT, $WINHTTP_OPTION_RECEIVE_TIMEOUT, _
				$WINHTTP_OPTION_RESOLVE_TIMEOUT, $WINHTTP_OPTION_SECURITY_FLAGS, $WINHTTP_OPTION_SECURITY_KEY_BITNESS, $WINHTTP_OPTION_SEND_TIMEOUT
			$tBuffer = DllStructCreate("int")
		Case Else
			$tBuffer = DllStructCreate("byte[" & $iSize & "]")
	EndSwitch
	$aCall = DllCall($hWINHTTPDLL__WINHTTP, "bool", "WinHttpQueryOption", _
			"handle", $hInternet, _
			"dword", $iOption, _
			"ptr", DllStructGetPtr($tBuffer), _
			"dword*", $iSize)
	If @error Or Not $aCall[0] Then Return SetError(2, 0, "")
	Return DllStructGetData($tBuffer, 1)
EndFunc   ;==>_WinHttpQueryOption

; #FUNCTION# ;===============================================================================
; Name...........: _WinHttpReadData
; Description ...: Reads data from a handle opened by the _WinHttpOpenRequest() function.
; Syntax.........: _WinHttpReadData($hRequest [, iMode = Default [, $iNumberOfBytesToRead = Default ]])
; Parameters ....: $hRequest - Valid handle returned from a previous call to _WinHttpOpenRequest().
;                  $iMode - [optional] Integer representing reading mode. Default is 0 (charset is decoded as it is ANSI).
;                  $iNumberOfBytesToRead - [optional] Integer value that contains the number of bytes to read. Default is 8192 bytes.
; Return values .: Success - Returns data read.
;                          - @extended receives the number of bytes read.
;                  Special: Sets @error to -1 if no more data to read (end reached).
;                  Failure - Returns empty string and sets @error:
;                  |1 - DllCall failed.
; Author ........: trancexx, ProgAndy
; Modified.......:
; Remarks .......: iMode can have these values:
;                  |0 - ANSI
;                  |1 - UTF8
;                  |2 - Binary
; Related .......: _WinHttpOpenRequest, _WinHttpWriteData
; Link ..........: http://msdn.microsoft.com/en-us/library/aa384104(VS.85).aspx
; Example .......:
;============================================================================================
Func _WinHttpReadData($hRequest, $iMode = Default, $iNumberOfBytesToRead = Default)
	If $iMode = Default Or $iMode = -1 Then $iMode = 0
	If $iNumberOfBytesToRead = Default Or $iNumberOfBytesToRead = -1 Then $iNumberOfBytesToRead = 8192
	Local $tBuffer
	Switch $iMode
		Case 1, 2
			$tBuffer = DllStructCreate("byte[" & $iNumberOfBytesToRead & "]")
		Case Else
			$iMode = 0
			$tBuffer = DllStructCreate("char[" & $iNumberOfBytesToRead & "]")
	EndSwitch
	Local $aCall = DllCall($hWINHTTPDLL__WINHTTP, "bool", "WinHttpReadData", _
			"handle", $hRequest, _
			"ptr", DllStructGetPtr($tBuffer), _
			"dword", $iNumberOfBytesToRead, _
			"dword*", 0)
	If @error Or Not $aCall[0] Then Return SetError(1, 0, "")
	If Not $aCall[4] Then Return SetError(-1, 0, "")
	If $aCall[4] < $iNumberOfBytesToRead Then
		Switch $iMode
			Case 0
				Return SetExtended($aCall[4], StringLeft(DllStructGetData($tBuffer, 1), $aCall[4]))
			Case 1
				Return SetExtended($aCall[4], BinaryToString(BinaryMid(DllStructGetData($tBuffer, 1), 1, $aCall[4]), 4))
			Case 2
				Return SetExtended($aCall[4], BinaryMid(DllStructGetData($tBuffer, 1), 1, $aCall[4]))
		EndSwitch
	Else
		Switch $iMode
			Case 0, 2
				Return SetExtended($aCall[4], DllStructGetData($tBuffer, 1))
			Case 1
				Return SetExtended($aCall[4], BinaryToString(DllStructGetData($tBuffer, 1), 4))
		EndSwitch
	EndIf
EndFunc   ;==>_WinHttpReadData

; #FUNCTION# ;===============================================================================
; Name...........: _WinHttpReceiveResponse
; Description ...: Waits to receive the response to an HTTP request initiated by WinHttpSendRequest().
; Syntax.........: _WinHttpReceiveResponse($hRequest)
; Parameters ....: $hRequest - Handle returned by _WinHttpOpenRequest() and sent by _WinHttpSendRequest().
; Return values .: Success - Returns 1.
;                  Failure - Returns 0 and sets @error:
;                  |1 - DllCall failed.
; Author ........: trancexx
; Modified.......:
; Remarks .......: Must call _WinHttpReceiveResponse() before _WinHttpQueryDataAvailable() and _WinHttpReadData().
; Related .......: _WinHttpOpenRequest, _WinHttpSetTimeouts
; Link ..........: http://msdn.microsoft.com/en-us/library/aa384105(VS.85).aspx
; Example .......:
;============================================================================================
Func _WinHttpReceiveResponse($hRequest)
	Local $aCall = DllCall($hWINHTTPDLL__WINHTTP, "bool", "WinHttpReceiveResponse", "handle", $hRequest, "ptr", 0)
	If @error Or Not $aCall[0] Then Return SetError(1, 0, 0)
	Return 1
EndFunc   ;==>_WinHttpReceiveResponse

; #FUNCTION# ;===============================================================================
; Name...........: _WinHttpSendRequest
; Description ...: Sends the specified request to the HTTP server.
; Syntax.........: _WinHttpSendRequest($hRequest [, $sHeaders = Default [, $sOptional = Default [, $iTotalLength = Default [, $iContext = Default ]]]])
; Parameters ....: $hRequest - Handle returned by _WinHttpOpenRequest().
;                  $sHeaders - [optional] String that contains the additional headers to append to the request. Default is $WINHTTP_NO_ADDITIONAL_HEADERS.
;                  $sOptional - [optional] String that contains any optional data to send immediately after the request headers. Default is $WINHTTP_NO_REQUEST_DATA.
;                  $iTotalLength - [optional] An unsigned long integer value that contains the length, in bytes, of the total optional data sent. Default is 0.
;                  $iContext - [optional] A pointer to a pointer-sized variable that contains an application-defined value that is passed, with the request handle, to any callback functions. Default is 0.
; Return values .: Success - Returns 1.
;                  Failure - Returns 0 and sets @error:
;                  |1 - DllCall failed.
; Author ........: trancexx
; Modified.......:
; Remarks .......: Specifying optional data ($sOptional) will cause $iTotalLength to receive the size of that data if left default value.
; Related .......: _WinHttpOpenRequest
; Link ..........: http://msdn.microsoft.com/en-us/library/aa384110(VS.85).aspx
; Example .......:
;============================================================================================
Func _WinHttpSendRequest($hRequest, $sHeaders = Default, $sOptional = Default, $iTotalLength = Default, $iContext = Default)
	If $sHeaders = Default Or $sHeaders = -1 Then $sHeaders = $WINHTTP_NO_ADDITIONAL_HEADERS
	If $sOptional = Default Or $sOptional = -1 Then $sOptional = $WINHTTP_NO_REQUEST_DATA
    If $iTotalLength = Default Or $iTotalLength = -1 Then $iTotalLength = 0
    If $iContext = Default Or $iContext = -1 Then $iContext = 0
	Local $pOptional = 0, $iOptionalLength = 0
	If @NumParams > 2 Then
		Local $tOptional
		If IsBinary($sOptional) Then
			$iOptionalLength = BinaryLen($sOptional)
			$tOptional = DllStructCreate("byte[" & $iOptionalLength & "]")
		Else
			$iOptionalLength = StringLen($sOptional)
			$tOptional = DllStructCreate("char[" & $iOptionalLength + 1 & "]")
		EndIf
		If $iOptionalLength Then $pOptional = DllStructGetPtr($tOptional)
		DllStructSetData($tOptional, 1, $sOptional)
	EndIf
	If Not $iTotalLength Or $iTotalLength < $iOptionalLength Then $iTotalLength += $iOptionalLength
	Local $aCall = DllCall($hWINHTTPDLL__WINHTTP, "bool", "WinHttpSendRequest", _
			"handle", $hRequest, _
			"wstr", $sHeaders, _
			"dword", 0, _
			"ptr", $pOptional, _
			"dword", $iOptionalLength, _
			"dword", $iTotalLength, _
			"ptr", $iContext)
	If @error Or Not $aCall[0] Then Return SetError(1, 0, 0)
	Return 1
EndFunc   ;==>_WinHttpSendRequest

; #FUNCTION# ;===============================================================================
; Name...........: _WinHttpSetCredentials
; Description ...: Passes the required authorization credentials to the server.
; Syntax.........: _WinHttpSetCredentials($hRequest, $iAuthTargets, $iAuthScheme, $sUserName, $sPassword)
; Parameters ....: $hRequest - Valid handle returned by _WinHttpOpenRequest().
;                  $iAuthTargets - Integer that specifies a flag that contains the authentication target.
;                  $iAuthScheme - Integer that specifies a flag that contains the authentication scheme.
;                  $sUserName - String that contains a valid user name.
;                  $sPassword - String that contains a valid password.
; Return values .: Success - Returns 1.
;                  Failure - Returns 0 and sets @error:
;                  |1 - DllCall failed.
; Author ........: trancexx
; Modified.......:
; Remarks .......:
; Related .......: _WinHttpOpenRequest
; Link ..........: http://msdn.microsoft.com/en-us/library/aa384112(VS.85).aspx
; Example .......:
;============================================================================================
Func _WinHttpSetCredentials($hRequest, $iAuthTargets, $iAuthScheme, $sUserName, $sPassword)
	Local $aCall = DllCall($hWINHTTPDLL__WINHTTP, "bool", "WinHttpSetCredentials", _
			"handle", $hRequest, _
			"dword", $iAuthTargets, _
			"dword", $iAuthScheme, _
			"wstr", $sUserName, _
			"wstr", $sPassword, _
			"ptr", 0)
	If @error Or Not $aCall[0] Then Return SetError(1, 0, 0)
	Return 1
EndFunc   ;==>_WinHttpSetCredentials

; #FUNCTION# ;===============================================================================
; Name...........: _WinHttpSetDefaultProxyConfiguration
; Description ...: Sets the default WinHttp proxy configuration.
; Syntax.........: _WinHttpSetDefaultProxyConfiguration($iAccessType, $Proxy, $ProxyBypass)
; Parameters ....: $iAccessType - Integer value that contains the access type.
;                  $Proxy - String value that contains the proxy server list.
;                  $ProxyBypass - String value that contains the proxy bypass list.
; Return values .: Success - Returns 1.
;                  Failure - Returns 0 and sets @error:
;                  |1 - DllCall failed.
; Author ........: trancexx
; Modified.......:
; Remarks .......:
; Related .......: _WinHttpDetectAutoProxyConfigUrl, _WinHttpGetDefaultProxyConfiguration, _WinHttpGetIEProxyConfigForCurrentUser
; Link ..........: http://msdn.microsoft.com/en-us/library/aa384113(VS.85).aspx
; Example .......:
;============================================================================================
Func _WinHttpSetDefaultProxyConfiguration($iAccessType, $Proxy, $ProxyBypass)
	Local $tProxy = DllStructCreate("wchar[" & StringLen($Proxy) + 1 & "]")
	DllStructSetData($tProxy, 1, $Proxy)
	Local $tProxyBypass = DllStructCreate("wchar[" & StringLen($ProxyBypass) + 1 & "]")
	DllStructSetData($tProxyBypass, 1, $ProxyBypass)
	Local $tWINHTTP_PROXY_INFO = DllStructCreate("dword AccessType;" & _
			"ptr Proxy;" & _
			"ptr ProxyBypass")
	DllStructSetData($tWINHTTP_PROXY_INFO, "AccessType", $iAccessType)
	DllStructSetData($tWINHTTP_PROXY_INFO, "Proxy", DllStructGetPtr($tProxy))
	DllStructSetData($tWINHTTP_PROXY_INFO, "ProxyBypass", DllStructGetPtr($tProxyBypass))
	Local $aCall = DllCall($hWINHTTPDLL__WINHTTP, "bool", "WinHttpSetDefaultProxyConfiguration", "ptr", DllStructGetPtr($tWINHTTP_PROXY_INFO))
	If @error Or Not $aCall[0] Then Return SetError(1, 0, 0)
	Return 1
EndFunc   ;==>_WinHttpSetDefaultProxyConfiguration

; #FUNCTION# ;===============================================================================
; Name...........: _WinHttpSetOption
; Description ...: Sets an Internet option.
; Syntax.........: _WinHttpSetOption($hInternet, $iOption, $vSetting [, $iSize = Default ])
; Parameters ....: $hInternet - Handle on which to set data.
;                  $iOption - Integer value that contains the Internet option to set.
;                  $vSetting - Value of setting
;                  $iSize    - [optional] Size of $vSetting, required if $vSetting is pointer to memory block
; Return values .: Success - Returns 1.
;                  Failure - Returns 0 and sets @error:
;                  |1 - Invalid Internet option
;                  |2 - Size required
;                  |3 - Datatype of value does not fit to option
;                  |4 - DllCall failed.
; Author ........: ProgAndy, trancexx
; Modified.......:
; Remarks .......:
; Related .......: _WinHttpQueryOption
; Link ..........: http://msdn.microsoft.com/en-us/library/aa384114(VS.85).aspx
; Example .......:
;============================================================================================
Func _WinHttpSetOption($hInternet, $iOption, $vSetting, $iSize = Default)
	If $iSize = Default Then $iSize = -1
	If IsBinary($vSetting) Then
		$iSize = DllStructCreate("byte[" & BinaryLen($vSetting) & "]")
		DllStructSetData($iSize, 1, $vSetting)
		$vSetting = $iSize
		$iSize = DllStructGetSize($vSetting)
	EndIf
	Local $sType
	Switch $iOption
		Case $WINHTTP_OPTION_AUTOLOGON_POLICY, $WINHTTP_OPTION_CODEPAGE, $WINHTTP_OPTION_CONFIGURE_PASSPORT_AUTH, $WINHTTP_OPTION_CONNECT_RETRIES, _
				$WINHTTP_OPTION_CONNECT_TIMEOUT, $WINHTTP_OPTION_DISABLE_FEATURE, $WINHTTP_OPTION_ENABLE_FEATURE, $WINHTTP_OPTION_ENABLETRACING, _
				$WINHTTP_OPTION_MAX_CONNS_PER_1_0_SERVER, $WINHTTP_OPTION_MAX_CONNS_PER_SERVER, $WINHTTP_OPTION_MAX_HTTP_AUTOMATIC_REDIRECTS, _
				$WINHTTP_OPTION_MAX_HTTP_STATUS_CONTINUE, $WINHTTP_OPTION_MAX_RESPONSE_DRAIN_SIZE, $WINHTTP_OPTION_MAX_RESPONSE_HEADER_SIZE, _
				$WINHTTP_OPTION_READ_BUFFER_SIZE, $WINHTTP_OPTION_RECEIVE_TIMEOUT, _
				$WINHTTP_OPTION_RECEIVE_RESPONSE_TIMEOUT, $WINHTTP_OPTION_REDIRECT_POLICY, $WINHTTP_OPTION_REJECT_USERPWD_IN_URL, _
				$WINHTTP_OPTION_REQUEST_PRIORITY, $WINHTTP_OPTION_RESOLVE_TIMEOUT, $WINHTTP_OPTION_SECURE_PROTOCOLS, $WINHTTP_OPTION_SECURITY_FLAGS, _
				$WINHTTP_OPTION_SECURITY_KEY_BITNESS, $WINHTTP_OPTION_SEND_TIMEOUT, $WINHTTP_OPTION_SPN, $WINHTTP_OPTION_USE_GLOBAL_SERVER_CREDENTIALS, _
				$WINHTTP_OPTION_WORKER_THREAD_COUNT, $WINHTTP_OPTION_WRITE_BUFFER_SIZE
			$sType = "dword*"
			$iSize = 4
		Case $WINHTTP_OPTION_CALLBACK, $WINHTTP_OPTION_PASSPORT_SIGN_OUT
			$sType = "ptr*"
			$iSize = 4
			If @AutoItX64 Then $iSize = 8
			If Not IsPtr($vSetting) Then Return SetError(3, 0, 0)
		Case $WINHTTP_OPTION_CONTEXT_VALUE
			$sType = "dword_ptr"
			$iSize = 4
			If @AutoItX64 Then $iSize = 8
		Case $WINHTTP_OPTION_PASSWORD, $WINHTTP_OPTION_PROXY_PASSWORD, $WINHTTP_OPTION_PROXY_USERNAME, $WINHTTP_OPTION_USER_AGENT, $WINHTTP_OPTION_USERNAME
			$sType = "wstr"
			If (IsDllStruct($vSetting) Or IsPtr($vSetting)) Then Return SetError(3, 0, 0)
			If $iSize < 1 Then $iSize = StringLen($vSetting)
		Case $WINHTTP_OPTION_CLIENT_CERT_CONTEXT, $WINHTTP_OPTION_GLOBAL_PROXY_CREDS, $WINHTTP_OPTION_GLOBAL_SERVER_CREDS, $WINHTTP_OPTION_HTTP_VERSION, _
				$WINHTTP_OPTION_PROXY
			$sType = "ptr"
			If Not (IsDllStruct($vSetting) Or IsPtr($vSetting)) Then Return SetError(3, 0, 0)
		Case Else
			Return SetError(1, 0, 0)
	EndSwitch
	If $iSize < 1 Then
		If IsDllStruct($vSetting) Then
			$iSize = DllStructGetSize($vSetting)
		Else
			Return SetError(2, 0, 0)
		EndIf
	EndIf
	Local $aCall
	If IsDllStruct($vSetting) Then
		$aCall = DllCall($hWINHTTPDLL__WINHTTP, "bool", "WinHttpSetOption", "handle", $hInternet, "dword", $iOption, $sType, DllStructGetPtr($vSetting), "dword", $iSize)
	Else
		$aCall = DllCall($hWINHTTPDLL__WINHTTP, "bool", "WinHttpSetOption", "handle", $hInternet, "dword", $iOption, $sType, $vSetting, "dword", $iSize)
	EndIf
	If @error Or Not $aCall[0] Then Return SetError(4, 0, 0)
	Return 1
EndFunc   ;==>_WinHttpSetOption

; #FUNCTION# ;===============================================================================
; Name...........: _WinHttpSetStatusCallback
; Description ...: Sets up a callback function that WinHttp can call as progress is made during an operation.
; Syntax.........: _WinHttpSetStatusCallback($hInternet, $hInternetCallback [, $iNotificationFlags = Default ])
; Parameters ....: $hInternet - Handle for which the callback is to be set.
;                  $hInternetCallback - Callback function to call when progress is made.
;                  $iNotificationFlags - [optional] Integer value that specifies flags to indicate which events activate the callback function. Default is $WINHTTP_CALLBACK_FLAG_ALL_NOTIFICATIONS.
; Return values .: Success - Returns a pointer to the previously defined status callback function or NULL if there was no previously defined status callback function.
;                  Failure - Returns 0 and sets @error:
;                  |1 - DllCall failed.
; Author ........: ProgAndy
; Modified.......: trancexx
; Remarks .......:
; Related .......:
; Link ..........: http://msdn.microsoft.com/en-us/library/aa384115(VS.85).aspx
; Example .......:
;============================================================================================
Func _WinHttpSetStatusCallback($hInternet, $hInternetCallback, $iNotificationFlags = Default)
	If $iNotificationFlags = Default Or $iNotificationFlags = -1 Then $iNotificationFlags = $WINHTTP_CALLBACK_FLAG_ALL_NOTIFICATIONS
	Local $aCall = DllCall($hWINHTTPDLL__WINHTTP, "ptr", "WinHttpSetStatusCallback", _
			"handle", $hInternet, _
			"ptr", DllCallbackGetPtr($hInternetCallback), _
			"dword", $iNotificationFlags, _
			"ptr", 0)
	If @error Then Return SetError(1, 0, 0)
	Return $aCall[0]
EndFunc   ;==>_WinHttpSetStatusCallback

; #FUNCTION# ;===============================================================================
; Name...........: _WinHttpSetTimeouts
; Description ...: Sets time-outs involved with HTTP transactions.
; Syntax.........: _WinHttpSetTimeouts($hInternet [, $iResolveTimeout = Default [, $iConnectTimeout = Default [, $iSendTimeout = Default [, $iReceiveTimeout = Default ]]]])
; Parameters ....: $hInternet - Handle returned by _WinHttpOpen() or _WinHttpOpenRequest().
;                  $iResolveTimeout - Integer that specifies the time-out value, in milliseconds, to use for name resolution.
;                  $iConnectTimeout - Integer that specifies the time-out value, in milliseconds, to use for server connection requests.
;                  $iSendTimeout - Integer that specifies the time-out value, in milliseconds, to use for sending requests.
;                  $iReceiveTimeout - integer that specifies the time-out value, in milliseconds, to receive a response to a request.
; Return values .: Success - Returns 1.
;                  Failure - Returns 0 and sets @error:
;                  |1 - DllCall failed.
; Author ........: trancexx
; Modified.......:
; Remarks .......: Initial values are: - $iResolveTimeout = 0
;                                      - $iConnectTimeout = 60000
;                                      - $iSendTimeout = 30000
;                                      - $iReceiveTimeout = 30000
; Related .......: _WinHttpReceiveResponse
; Link ..........: http://msdn.microsoft.com/en-us/library/aa384116(VS.85).aspx
; Example .......:
;============================================================================================
Func _WinHttpSetTimeouts($hInternet, $iResolveTimeout = Default, $iConnectTimeout = Default, $iSendTimeout = Default, $iReceiveTimeout = Default)
	If $iResolveTimeout = Default Or $iResolveTimeout = -1 Then $iResolveTimeout = 0
	If $iConnectTimeout = Default Or $iConnectTimeout = -1 Then $iConnectTimeout = 60000
	If $iSendTimeout = Default Or $iSendTimeout = -1 Then $iSendTimeout = 30000
	If $iReceiveTimeout = Default Or $iReceiveTimeout = -1 Then $iReceiveTimeout = 30000
	Local $aCall = DllCall($hWINHTTPDLL__WINHTTP, "bool", "WinHttpSetTimeouts", _
			"handle", $hInternet, _
			"int", $iResolveTimeout, _
			"int", $iConnectTimeout, _
			"int", $iSendTimeout, _
			"int", $iReceiveTimeout)
	If @error Or Not $aCall[0] Then Return SetError(1, 0, 0)
	Return 1
EndFunc   ;==>_WinHttpSetTimeouts

; #FUNCTION# ====================================================================================================================
; Name...........: _WinHttpSimpleReadData
; Description ...: Reads data from a request
; Syntax.........: _WinHttpSimpleReadData($hRequest [, $iMode = Default ])
; Parameters ....: $hRequest - request handle after _WinHttpReceiveResponse
;                  $iMode         - [optional] type of data returned (default: 0)
;                  |0 - ASCII-String
;                  |1 - UTF-8-String
;                  |2 - binary data
; Return values .: Success      - String or binary depending on $iMode
;                  Failure      - empty string or empty binary (mode 2) and set @error
;                  |1 - invalid mode
;                  |2 - no data availbale
; Author ........: ProgAndy
; Modified.......:
; Remarks .......:
; Related .......: _WinHttpReadData, _WinHttpSimpleRequest, _WinHttpSimpleSSLRequest
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _WinHttpSimpleReadData($hRequest, $iMode = Default)
	If $iMode = Default Or $iMode = -1 Then $iMode = 0
	If $iMode > 2 Or $iMode < 0 Then Return SetError(1, 0, '')
	Local $vData = ''
	If $iMode = 2 Then $vData = Binary('')
	If _WinHttpQueryDataAvailable($hRequest) Then
		If $iMode = 0 Then
			Do
				$vData &= _WinHttpReadData($hRequest, 0)
			Until @error
			Return $vData
		Else
			$vData = Binary('')
			Do
				$vData &= _WinHttpReadData($hRequest, 2)
			Until @error
			If $iMode = 1 Then Return BinaryToString($vData, 4)
			Return $vData
		EndIf
	EndIf
	Return SetError(2, 0, $vData)
EndFunc   ;==>_WinHttpSimpleReadData

; #FUNCTION# ====================================================================================================================
; Name...........: _WinHttpSimpleRequest
; Description ...: A function to send a request in a simpler form
; Syntax.........: _WinHttpSimpleRequest($hConnect, $sType, $sPath [, $sReferrer = Default [, $sData = Default [, $sHeader = Default [, $fGetHeaders = Default [, $iMode = Default ]]]]])
; Parameters ....: $hConnect  - Handle from _WinHttpConnect
;                  $sType       - GET or POST
;                  $sPath       - request path
;                  $sReferrer   - [optional] referrer (default: $WINHTTP_NO_REFERER)
;                  $sData       - [optional] POST-Data (default: $WINHTTP_NO_REQUEST_DATA)
;                  $sHeader     - [optional] additional Headers (default: $WINHTTP_NO_ADDITIONAL_HEADERS)
;                  $fGetHeaders - [optional] return response headers (default: False)
;                  $iMode       - [optional] reading mode of result (default: 0)
;                  |0 - ASCII-text
;                  |1 - UTF-8 text
;                  |2 - binary data
; Return values .: Success      - response data if $fGetHeaders = False (default)
;                  |Array if $fGetHeaders = True
;                  | [0] - response headers
;                  | [1] - response data
;                  Failure      - 0 and set @error
;                  |1 - could not open request
;                  |2 - could not send request
;                  |3 - could not receive response
;                  |4 - $iMode not in valid
; Author ........: ProgAndy
; Modified.......:
; Remarks .......:
; Related .......: _WinHttpSimpleSSLRequest, _WinHttpSimpleSendRequest, _WinHttpSimpleSendSSLRequest, _WinHttpQueryHeaders, _WinHttpSimpleReadData
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _WinHttpSimpleRequest($hConnect, $sType, $sPath, $sReferrer = Default, $sData = Default, $sHeader = Default, $fGetHeaders = Default, $iMode = Default)
	; Author: ProgAndy
	If $sReferrer = Default Or $sReferrer = -1 Then $sReferrer = $WINHTTP_NO_REFERER
	If $sData = Default Or $sData = -1 Then $sData = $WINHTTP_NO_REQUEST_DATA
	If $sHeader = Default Or $sHeader = -1 Then $sHeader = $WINHTTP_NO_ADDITIONAL_HEADERS
	If $fGetHeaders = Default Or $fGetHeaders = -1 Then $fGetHeaders = False
	If $iMode = Default Or $iMode = -1 Then $iMode = 0
	If $iMode > 2 Or $iMode < 0 Then Return SetError(4, 0, 0)
	Local $hRequest = _WinHttpSimpleSendRequest($hConnect, $sType, $sPath, $sReferrer, $sData, $sHeader)
	If @error Then Return SetError(@error, 0, 0)
	If $fGetHeaders Then
		Local $aData[2] = [_WinHttpQueryHeaders($hRequest), _WinHttpSimpleReadData($hRequest, $iMode)]
		Return $aData
	EndIf
	Return _WinHttpSimpleReadData($hRequest, $iMode)
EndFunc   ;==>_WinHttpSimpleRequest

; #FUNCTION# ====================================================================================================================
; Name...........: _WinHttpSimpleSendRequest
; Description ...: A function to send a request in a simpler form, but not read the data
; Syntax.........: _WinHttpSimpleSendRequest($hConnect, $sType, $sPath [, $sReferrer = Default [, $sData = Default [, $sHeader = Default ]]])
; Parameters ....: $hConnect  - Handle from _WinHttpConnect
;                  $sType       - GET or POST
;                  $sPath       - request path
;                  $sReferrer   - [optional] referrer (default: $WINHTTP_NO_REFERER)
;                  $sData       - [optional] POST-Data (default: $WINHTTP_NO_REQUEST_DATA)
;                  $sHeader     - [optional] additional Headers (default: $WINHTTP_NO_ADDITIONAL_HEADERS)
; Return values .: Success      - handle of request after _WinHttpReceiveResponse. Just start to read headers and data.
;                  Failure      - 0 and set @error
;                  |1 - could not open request
;                  |2 - could not send request
;                  |3 - could not receive response
; Author ........: ProgAndy
; Modified.......:
; Remarks .......:
; Related .......: _WinHttpSimpleRequest, _WinHttpSimpleSendSSLRequest, _WinHttpSimpleReadData
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _WinHttpSimpleSendRequest($hConnect, $sType, $sPath, $sReferrer = Default, $sData = Default, $sHeader = Default)
	; Author: ProgAndy
	If $sReferrer = Default Or $sReferrer = -1 Then $sReferrer = $WINHTTP_NO_REFERER
	If $sData = Default Or $sData = -1 Then $sData = $WINHTTP_NO_REQUEST_DATA
	If $sHeader = Default Or $sHeader = -1 Then $sHeader = $WINHTTP_NO_ADDITIONAL_HEADERS
	Local $hRequest = _WinHttpOpenRequest($hConnect, $sType, $sPath, Default, $sReferrer)
	If Not $hRequest Then Return SetError(1, @error, 0)
	If $sType = "POST" And $sHeader = $WINHTTP_NO_ADDITIONAL_HEADERS Then $sHeader = "Content-Type: application/x-www-form-urlencoded" & @CRLF
	_WinHttpSendRequest($hRequest, $sHeader, $sData)
	If @error Then Return SetError(2, 0 * _WinHttpCloseHandle($hRequest), 0)
	_WinHttpReceiveResponse($hRequest)
	If @error Then Return SetError(3, 0 * _WinHttpCloseHandle($hRequest), 0)
	Return $hRequest
EndFunc   ;==>_WinHttpSimpleSendRequest

; #FUNCTION# ====================================================================================================================
; Name...........: _WinHttpSimpleSendSSLRequest
; Description ...: A function to send a request in a simpler form, but not read the data
; Syntax.........: _WinHttpSimpleSendSSLRequest($hConnect, $sType, $sPath [, $sReferrer = Default [, $sData = Default [, $sHeader = Default ]]] )
; Parameters ....: $hConnect  - Handle from _WinHttpConnect
;                  $sType       - GET or POST
;                  $sPath       - request path
;                  $sReferrer   - [optional] referrer (default: $WINHTTP_NO_REFERER)
;                  $sData       - [optional] POST-Data (default: $WINHTTP_NO_REQUEST_DATA)
;                  $sHeader     - [optional] additional Headers (default: $WINHTTP_NO_ADDITIONAL_HEADERS)
; Return values .: Success      - handle of request after _WinHttpReceiveResponse. Just start to read headers and data.
;                  Failure      - 0 and set @error
;                  |1 - could not open request
;                  |2 - could not send request
;                  |3 - could not receive response
; Author ........: ProgAndy
; Modified.......:
; Remarks .......:
; Related .......: _WinHttpSimpleSSLRequest, _WinHttpSimpleSendRequest, _WinHttpSimpleReadData
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _WinHttpSimpleSendSSLRequest($hConnect, $sType, $sPath, $sReferrer = Default, $sData = Default, $sHeader = Default)
	; Author: ProgAndy
	If $sReferrer = Default Or $sReferrer = -1 Then $sReferrer = $WINHTTP_NO_REFERER
	If $sData = Default Or $sData = -1 Then $sData = $WINHTTP_NO_REQUEST_DATA
	If $sHeader = Default Or $sHeader = -1 Then $sHeader = $WINHTTP_NO_ADDITIONAL_HEADERS
	Local $hRequest = _WinHttpOpenRequest($hConnect, $sType, $sPath, Default, $sReferrer, Default, BitOR($WINHTTP_FLAG_SECURE, $WINHTTP_FLAG_ESCAPE_DISABLE))
	If Not $hRequest Then Return SetError(1, @error, 0)
	If $sType = "POST" And $sHeader = $WINHTTP_NO_ADDITIONAL_HEADERS Then $sHeader = "Content-Type: application/x-www-form-urlencoded" & @CRLF
	_WinHttpSendRequest($hRequest, $sHeader, $sData)
	If @error Then Return SetError(2, 0 * _WinHttpCloseHandle($hRequest), 0)
	_WinHttpReceiveResponse($hRequest)
	If @error Then Return SetError(3, 0 * _WinHttpCloseHandle($hRequest), 0)
	Return $hRequest
EndFunc   ;==>_WinHttpSimpleSendSSLRequest

; #FUNCTION# ====================================================================================================================
; Name...........: _WinHttpSimpleSSLRequest
; Description ...: A function to send a SSL request in a simpler form
; Syntax.........: _WinHttpSimpleSSLRequest($hConnect, $sType, $sPath [, $sReferrer = Default [, $sData = Default [, $sHeader = Default [, $fGetHeaders = Default [, $iMode = Default ]]]]])
; Parameters ....: $hConnect  - Handle from _WinHttpConnect
;                  $sType       - GET or POST
;                  $sPath       - request path
;                  $sReferrer   - [optional] referrer (default: $WINHTTP_NO_REFERER)
;                  $sData       - [optional] POST-Data (default: $WINHTTP_NO_REQUEST_DATA)
;                  $sHeader     - [optional] additional Headers (default: $WINHTTP_NO_ADDITIONAL_HEADERS)
;                  $fGetHeaders - [optional] return response headers (default: False)
;                  $iMode       - [optional] reading mode of result (default: 0)
;                  |0 - ASCII-text
;                  |1 - UTF-8 text
;                  |2 - binary data
; Return values .: Success      - response data if $fGetHeaders = False (default)
;                  |Array if $fGetHeaders = True
;                  | [0] - response headers
;                  | [1] - response data
;                  Failure      - 0 and set @error
;                  |1 - could not open request
;                  |2 - could not send request
;                  |3 - could not receive response
;                  |4 - $iMode not in valid
; Author ........: ProgAndy
; Modified.......:
; Remarks .......:
; Related .......: _WinHttpSimpleRequest, _WinHttpSimpleSendSSLRequest, _WinHttpSimpleSendRequest, _WinHttpQueryHeaders, _WinHttpSimpleReadData
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _WinHttpSimpleSSLRequest($hConnect, $sType, $sPath, $sReferrer = Default, $sData = Default, $sHeader = Default, $fGetHeaders = Default, $iMode = Default)
	; Author: ProgAndy
	If $sReferrer = Default Or $sReferrer = -1 Then $sReferrer = $WINHTTP_NO_REFERER
	If $sData = Default Or $sData = -1 Then $sData = $WINHTTP_NO_REQUEST_DATA
	If $sHeader = Default Or $sHeader = -1 Then $sHeader = $WINHTTP_NO_ADDITIONAL_HEADERS
	If $fGetHeaders = Default Or $fGetHeaders = -1 Then $fGetHeaders = False
	If $iMode = Default Or $iMode = -1 Then $iMode = 0
	If $iMode > 2 Or $iMode < 0 Then Return SetError(4, 0, 0)
	Local $hRequest = _WinHttpSimpleSendSSLRequest($hConnect, $sType, $sPath, $sReferrer, $sData, $sHeader)
	If @error Then Return SetError(@error, 0, 0)
	If $fGetHeaders Then
		Local $aData[2] = [_WinHttpQueryHeaders($hRequest), _WinHttpSimpleReadData($hRequest, $iMode)]
		Return $aData
	EndIf
	Return _WinHttpSimpleReadData($hRequest, $iMode)
EndFunc   ;==>_WinHttpSimpleSSLRequest

; #FUNCTION# ;===============================================================================
; Name...........: _WinHttpTimeFromSystemTime
; Description ...: Formats a system date and time according to the HTTP version 1.0 specification.
; Syntax.........: _WinHttpTimeFromSystemTime()
; Parameters ....: None.
; Return values .: Success - Returns time string.
;                  Failure - Returns empty string and sets @error:
;                  |1 - Initial DllCall failed.
;                  |2 - Main DllCall failed.
; Author ........: trancexx
; Modified.......:
; Remarks .......:
; Related .......: _WinHttpTimeToSystemTime
; Link ..........: http://msdn.microsoft.com/en-us/library/aa384117(VS.85).aspx
; Example .......:
;============================================================================================
Func _WinHttpTimeFromSystemTime()
	Local $SYSTEMTIME = DllStructCreate("word Year;" & _
			"word Month;" & _
			"word DayOfWeek;" & _
			"word Day;" & _
			"word Hour;" & _
			"word Minute;" & _
			"word Second;" & _
			"word Milliseconds")
	DllCall("kernel32.dll", "none", "GetSystemTime", "ptr", DllStructGetPtr($SYSTEMTIME))
	If @error Then Return SetError(1, 0, "")
	Local $tTime = DllStructCreate("wchar[62]")
	Local $aCall = DllCall($hWINHTTPDLL__WINHTTP, "bool", "WinHttpTimeFromSystemTime", "ptr", DllStructGetPtr($SYSTEMTIME), "ptr", DllStructGetPtr($tTime))
	If @error Or Not $aCall[0] Then Return SetError(2, 0, "")
	Return DllStructGetData($tTime, 1)
EndFunc   ;==>_WinHttpTimeFromSystemTime

; #FUNCTION# ;===============================================================================
; Name...........: _WinHttpTimeToSystemTime
; Description ...: Takes an HTTP time/date string and converts it to array (SYSTEMTIME structure values).
; Syntax.........: _WinHttpTimeToSystemTime($sHttpTime)
; Parameters ....: $sHttpTime - Date/time string to convert.
; Return values .: Success - Returns array with 8 elements:
;                  |$array[0] - is Year,
;                  |$array[1] - is Month,
;                  |$array[2] - is DayOfWeek,
;                  |$array[3] - is Day,
;                  |$array[4] - is Hour,
;                  |$array[5] - is Minute,
;                  |$array[6] - is Second.,
;                  |$array[7] - is Milliseconds.
;                  Failure - Returns 0 and sets @error:
;                  |1 - DllCall failed.
; Author ........: trancexx
; Modified.......:
; Remarks .......:
; Related .......: _WinHttpTimeFromSystemTime
; Link ..........: http://msdn.microsoft.com/en-us/library/aa384118(VS.85).aspx
; Example .......:
;============================================================================================
Func _WinHttpTimeToSystemTime($sHttpTime)
	Local $SYSTEMTIME = DllStructCreate("word Year;" & _
			"word Month;" & _
			"word DayOfWeek;" & _
			"word Day;" & _
			"word Hour;" & _
			"word Minute;" & _
			"word Second;" & _
			"word Milliseconds")
	Local $tTime = DllStructCreate("wchar[62]")
	DllStructSetData($tTime, 1, $sHttpTime)
	Local $aCall = DllCall($hWINHTTPDLL__WINHTTP, "bool", "WinHttpTimeToSystemTime", "ptr", DllStructGetPtr($tTime), "ptr", DllStructGetPtr($SYSTEMTIME))
	If @error Or Not $aCall[0] Then Return SetError(2, 0, 0)
	Local $aRet[8] = [DllStructGetData($SYSTEMTIME, "Year"), _
			DllStructGetData($SYSTEMTIME, "Month"), _
			DllStructGetData($SYSTEMTIME, "DayOfWeek"), _
			DllStructGetData($SYSTEMTIME, "Day"), _
			DllStructGetData($SYSTEMTIME, "Hour"), _
			DllStructGetData($SYSTEMTIME, "Minute"), _
			DllStructGetData($SYSTEMTIME, "Second"), _
			DllStructGetData($SYSTEMTIME, "Milliseconds")]
	Return $aRet
EndFunc   ;==>_WinHttpTimeToSystemTime

; #FUNCTION# ;===============================================================================
; Name...........: _WinHttpWriteData
; Description ...: Writes request data to an HTTP server.
; Syntax.........: _WinHttpWriteData($hRequest, $vData [, $iMode = Default ])
; Parameters ....: $hRequest - Valid handle returned by _WinHttpSendRequest().
;                  $vData - Data to write.
;                  $iMode - [optional] Integer representing writing mode. Default is 0 - write ANSI string.
; Return values .: Success - Returns 1
;                          - @extended receives the number of bytes written.
;                  Failure - Returns 0 and sets @error:
;                  |1 - DllCall failed.
; Author ........: trancexx, ProgAndy
; Modified.......:
; Remarks .......: $vData variable is either string or binary data to write.
;                  $iMode can have these values:
;                  |0 - to write ANSI string
;                  |1 - to write binary data
; Related .......: _WinHttpSendRequest, _WinHttpReadData
; Link ..........: http://msdn.microsoft.com/en-us/library/aa384120(VS.85).aspx
; Example .......:
;============================================================================================
Func _WinHttpWriteData($hRequest, $vData, $iMode = Default)
	If $iMode = Default Or $iMode = -1 Then $iMode = 0
	Local $iNumberOfBytesToWrite, $tData
	If $iMode = 1 Then
		$iNumberOfBytesToWrite = BinaryLen($vData)
		$tData = DllStructCreate("byte[" & $iNumberOfBytesToWrite & "]")
		DllStructSetData($tData, 1, $vData)
	ElseIf IsDllStruct($vData) Then
		$iNumberOfBytesToWrite = DllStructGetSize($vData)
		$tData = $vData
	Else
		$iNumberOfBytesToWrite = StringLen($vData)
		$tData = DllStructCreate("char[" & $iNumberOfBytesToWrite + 1 & "]")
		DllStructSetData($tData, 1, $vData)
	EndIf
	Local $aCall = DllCall($hWINHTTPDLL__WINHTTP, "bool", "WinHttpWriteData", _
			"handle", $hRequest, _
			"ptr", DllStructGetPtr($tData), _
			"dword", $iNumberOfBytesToWrite, _
			"dword*", 0)
	If @error Or Not $aCall[0] Then Return SetError(1, 0, 0)
	Return SetExtended($aCall[4], 1)
EndFunc   ;==>_WinHttpWriteData


; #INTERNAL FUNCTIONS# ;=====================================================================
Func __WinHttpMemGlobalFree($pMem)
	Local $aCall = DllCall("kernel32.dll", "ptr", "GlobalFree", "ptr", $pMem)
	If @error Or $aCall[0] Then Return SetError(1, 0, 0)
	Return 1
EndFunc   ;==>__WinHttpMemGlobalFree

Func __WinHttpPtrStringLenW($pString)
	Local $aCall = DllCall("kernel32.dll", "dword", "lstrlenW", "ptr", $pString)
	If @error Then Return SetError(1, 0, 0)
	Return $aCall[0]
EndFunc   ;==>__WinHttpPtrStringLenW
;============================================================================================
