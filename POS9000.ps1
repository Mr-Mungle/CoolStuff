#Author: mungle
#Description: enables you to be lazy in a tech support environment that uses ServiceNow

#Var loading
$IssueCleared = 'Issue cleared'
$Resolved = 'Resolved'
$AwaitingCaller = 'Awaiting caller'
$TicketPended = 'Ticket pended'
$AwaitingChange = 'Awaiting change'
$Cancelled = 'Cancelled'
$Pending = 'Pending'
$HardwareRepaired = 'Hardware repaired'
$SoftwareReConfigured = 'Software reconfigured'
$RequestInitiated = 'Request initiated'
$HardwareReplaced = 'Hardware replaced'
$WordArray = @($IssueCleared,$Resolved,$AwaitingCaller,$TicketPended,$AwaitingChange,$Cancelled,$Pending,$HardwareRepaired,$SoftwareReConfigured,$RequestInitiated,$HardwareRepaired)


Do{
    #cleans
    $RandomInt = $null
    $RandomWord = $null
    $RandomInterval = $null
    $Time = $null
 
    #grabs system time in HOUR:MIN:SEC AM/PM format
    $Time = Get-Date -DisplayHint Time
    $RandomInt = Get-Random -Minimum 0 -Maximum 11
    $RandomWord = $wordArray[$RandomInt]
    Add-Type -AssemblyName System.Windows.Forms
    $RandomWord.ToCharArray() | ForEach-Object {#this part types at random speeds through an array of the keyword
                                                    $sleeptime = $null
                                                    $sleeptime = Get-Random -Minimum 0 -Maximum 2
                                                    sleep $sleeptime
                                                    [System.Windows.Forms.SendKeys]::SendWait("$_")
                                                }
    $sleeptime2 = $null
    $sleeptime2 = Get-Random -Minimum 300 -Maximum 400
    sleep $sleeptime2 #waits between 300 and 400 seconds before refreshing page
    [System.Windows.Forms.SendKeys]::SendWait("{F5}")
}while($Time -lt "5:00:00 PM") #stops running at 5pm system time