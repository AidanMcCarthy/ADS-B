function timestamp {
    Process{"$(Get-Date -Format G): $_"}
}

# Load location data from .\location.txt
# Must be in the following format:
# 
# --------------------------------------
# HomeLat = "40.123456"
# Homelong = "-70.123456"
# -------------------------------------- 

Get-Content .\location.txt | Where-Object {$_.length -gt 0} | Where-Object {!$_.StartsWith("#")} | ForEach-Object {
    $var = $_.Split('=',2).Trim()
    New-Variable -Scope Script -Name $var[0] -Value $var[1] -Force
}

$global:aircraft = 'http://10.0.2.29/tar1090/data/aircraft.json'
$global:dist = "0.02"                    # Distance in Decimal Degrees (DD). ".16" is approx. 1nm
$global:distsq = [math]::pow($dist, 2)    # Squaring the distance for use in the comparison later on

Write-host `b`b"Starting flight monitor >>>" -ForegroundColor Green
Write-host `t"Home Lat: $homeLat" -ForegroundColor DarkGray
Write-host `t"Home Lon: $homeLon"`b -ForegroundColor DarkGray

While ($true) {
    $json = Invoke-WebRequest $aircraft | ConvertFrom-Json

    if ($json.aircraft.flight -like '*N14*NE*') {

        $aircraftLat = $json.aircraft.Where({$_.flight -like '*N14*NE*'}).lat
        $aircraftLon = $json.aircraft.Where({$_.flight -like '*N14*NE*'}).lon

        # formula to find all points on a cirle using pythagorean theorem
        # assuming (h,k) are your Home coordinates
        # (x−h)^2+(y−k)^2 = r^2
        # r^2 is the distance (r)

        $aircraftDist = ([math]::pow(($homeLat - $aircraftLat),2)) + ([math]::pow(($homeLon - $aircraftLon),2))

        if ($aircraftDist -lt $distsq) {
            $status = "Boston MedFlight Approaching!"
    
            add-type -assembly presentationcore 
            $audio = new-object system.windows.media.mediaplayer
            $audio.open("C:\aidan\warning_medflight.mp3")
            $audio.Play();
        } else {
            $Status = "Boston MedFlight detected... Outside of search area"
        }
    } else {
        $status = "No overhead flights detected..." 
    }

    $status | timestamp
    Start-Sleep -Seconds 10
    $json = $null
}


<#

$progressBar = '|','/','-','\' 
$jobName = Start-Job -ScriptBlock { GUI CMD here }
while($jobName.JobStateInfo.State -eq "Running") {
    Write-Host "$_`b"
    Start-Sleep -Milliseconds 125
}

#>


# To Do 
# Unable to connect to server error message
