
<#
function BlastFromThePast([switch]$EndOfLine, [switch]$Finished){
    $EscChar = "`r"
    if($EndOfLine){ $EscChar = "`b" }
    if($Finished){Write-Host "$EscChar"; return;}
    if(!$tickcounter){ Set-Variable -Name "tickcounter" -Scope global -Value 0 -Force -Option AllScope }
    if(!$tickoption){ Set-Variable -Name "tickoption" -Scope global -Value 0 -Force -Option AllScope }
    $chance = Get-Random -Minimum 1 -Maximum 10
    if($chance -eq 5){ if($tickoption -eq 1){$tickoption = 0}else{$tickoption = 1} }
    switch($tickoption){
        0 {
            switch($tickcounter){
                0 { Write-Host "$EscChar|" -NoNewline }
                1 { Write-Host "$EscChar/" -NoNewline }
                2 { Write-Host "$EscChar-" -NoNewline }
                3 { Write-Host "$EscChar\" -NoNewline }
            }
            break;
        }
        1 {
            switch($tickcounter){
                0 { Write-Host "$EscChar|" -NoNewline }
                1 { Write-Host "$EscChar\" -NoNewline }
                2 { Write-Host "$EscChar-" -NoNewline }
                3 { Write-Host "$EscChar/" -NoNewline }
            }
            break;
        }
    }
    if($tickcounter -eq 3){ $tickcounter = 0 }
    else{ $tickcounter++ }
}    

Write-Host "  Ticker at front of line" -NoNewline
for($i=0;$i -lt 20; $i++){BlastFromThePast; Start-Sleep -Milliseconds 100}
BlastFromThePast -Finished;

Write-Host "Ticker at end of line  " -NoNewline
for($i=0;$i -lt 20; $i++){BlastFromThePast -EndOfLine; Start-Sleep -Milliseconds 100}
BlastFromThePast -EndOfLine -Finished;
#>

# animation frames separated by "#"

$animation = @"
(>'-')>
#
^('-')^
#
<('-'<)
#
^('-')^
"@

$frames = $animation.Split("#").Trim()

$animationLoopNumber = 50 # number of times to loop animation

$animationSpeed = 250 # time in milliseconds to show each frame

$i = 0

do {

    foreach ($frame in $frames) {

        Clear-Host
        
        Write-Output "$frame`n`n`n"
    
        Start-Sleep -Milliseconds $animationSpeed
    }

    $i++
    
} until ($i -eq $animationLoopNumber)