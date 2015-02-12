function Get-Times() {
    #Generates times 30 minutes apart for a whole day.
    1..48 | % {
        $start=([DateTime]::Today).AddMinutes(30 * $_)
        $end=$start.AddMinutes(30)
        New-Object PSObject -Property @{Start=$start;End=$end}
    }
}

function Get-RandomTimeSpan() {
    $starthour = 1..23 | Get-Random
    $endhour = ($starthour + 1)..($starthour + 3) | Get-Random
    
    $start=([DateTime]::Today).AddHours($starthour).AddMinutes((0,30 | Get-Random))
    $end=([DateTime]::Today).AddHours($endhour)
    New-Object PSObject -Property @{Start=$start;End=$end}
}
#Count the returning rows the number will depend if there's an overlap.
function Get-OverlappingTimes() {
    $timespan=Get-RandomTimeSpan
    
    Out-Host -in $timespan
    Get-Times | 
    ?{$_.End -gt $timespan.Start -and $_.Start -lt $timespan.End} |
}




#Overlapping rows foreach record how do I make fast? return rows that are done that can be paswed to query?
#Use one macro to return a list like 1,2,3 to do in search query and determine if there are overlaps with null
