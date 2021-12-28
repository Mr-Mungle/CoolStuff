#Author: mungle
#Description: calculates average CPU/RAM util rate over a user specified time, at user specified intervals, then displays values to command line

$MaxSamples = Read-Host 'Enter the number of cycles to run for average, use whole numbers:'
$SampleInterval = Read-Host 'Enter interval between cycles in seconds, use whole numbers:'
Write-Host "The hamster is getting on his treadmill, script runs once for processor usage and once for memory usage"
###grabs current CPU util, creates rolling average
$CPUAveragePerformance = (GET-COUNTER -Counter "\Processor(_Total)\% Processor Time" -SampleInterval $SampleInterval -MaxSamples $MaxSamples |select -ExpandProperty countersamples | select -ExpandProperty cookedvalue | Measure-Object -Average).average
###grabs current RAM usage, creates rolling average
$memorycounter = (Get-Counter "\Memory\Available MBytes" -MaxSamples $MaxSamples -SampleInterval $SampleInterval | select -expand countersamples | measure cookedvalue -average).average
### Memory Average Formatting
$freememavg = "{0:N0}" -f $memorycounter
### Get total Physical Memory & Calculate Percentage
$physicalmemory = (Get-WMIObject -class Win32_PhysicalMemory | Measure-Object -Property capacity -Sum).Sum / 1mb     ###grabs system RAM
$usedmem = $physicalmemory-$freememavg     ###calculates how much memory is being used on average
$percentphysicalmemory = $usedmem/$physicalmemory     ###creates a decimal value
$percentphysicalmemory = $percentphysicalmemory*100     ###converts decimal to percent format
$freememGB = $usedmem/1000     ###converts Mb to Gb
$physicalmemoryGB = $physicalmemory/1000     ###converts Mb to Gb

Write-Host ""
Write-Host ""
Write-Host "Average CPU usage calculated with"$MaxSamples" samples taken at "$SampleInterval" second intervals :" $CPUAveragePerformance.tostring("#.##")" %"
Write-Host "Average RAM usage calculated with"$MaxSamples" samples taken at "$SampleInterval" second intervals :" $freememGB.tostring("#.##")"GB/"$physicalmemoryGB.ToString("#.##")"GB total which equates to", $percentphysicalmemory.tostring("#.##") "% utilization"
Read-Host "Press enter to exit"