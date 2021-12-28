#Author : mungle
#Description : This script runs gpupdate, writes system info to a desktop folder of the local (nonelevated) user profile, and corrects any corrupt system files the image process may leave behind, self elevating
#              Meant to be run post image

$principal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
if($principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {

##This script pulls username, serial number, BIOS version, amount of installed RAM and speed, HDD Model number, and updates group policy

Write-Host "We are now going to force an update to group policy, one moment please"
gpupdate /force

##This block pulls only local user name and assigns it to $localusername var
$entireusername = $(Get-WMIObject -class Win32_ComputerSystem | select username).username
$separator = "\"
$localusernamearray = $entireusername.split($separator)
$localusername = $localusernamearray[1]
##This block pulls the smbios version and assigns the 3rd array member (bios version) to var $BIOSversion
#for later use
$BIOS = wmic bios get smbiosbiosversion
$BIOSversion = $BIOS[2]
##this block pulls unit serial number and reassigns it to var
$Serial = wmic bios get serialnumber
$Serialnumber = $Serial[2]
##this block gets RAM in MB and converts it to GB
$totalphysicalmemory = (Get-CimInstance -ClassName 'Cim_PhysicalMemory' | Measure-Object -Property Capacity -Sum).Sum/1000000000
$totalphysicalmemory = [math]::Round($totalphysicalmemory,2)
##This block gets the HDD model number so you can check if the user is still using HDD and not SSD in cases
##where you get a complaint about a slow system, helps identify potential bottlenecks you can upgrade
$harddrivemodel = wmic diskdrive get Model
##this will list all drives formatted in a way that windows can see in an array
##this line grabs the clock speed of the installed RAM sticks as an array
$RAMclock = Get-CimInstance -Class CIM_PhysicalMemory -ComputerName localhost -ErrorAction Stop | Select-Object Speed

##now for File I/O fun times
$file = "C:\users\$localusername\Desktop\ClearlyNamedDir"
$file2 = "C:\Users\$localusername\Desktop\ClearlyNamedDir\SystemInfo.txt"

#checks to see if file already exists
if (-not(Test-Path -Path $file -PathType Container)) #checks if folder exists
    {
     try {
         $null = New-Item -ItemType Directory -Path $file -Force -ErrorAction Stop #if it doesn't exist, it makes a new folder
         $null = New-Item -ItemType File -Path $file2 -Force -ErrorAction Stop #as long as folder doesn't exist it also makes the file
         #file input section
         "Username = $localusername `nService Tag = $Serialnumber `nBIOS version = $BIOSversion `nHDD = $harddrivemodel `nRAM in GB = $totalphysicalmemory `nRAM clock below per slot $RAMclock" | out-file -filepath $file2
         $Ramclock | out-file -FilePath $file2 -append
         Write-Host "The folder $file has been created and your data of interest has been added in text format in a file titled SystemInfoHemm.txt."
         }
    catch {
            throw $_.Exception.Message
            }      
         }
else {#main else section

        if (-not(Test-Path -Path $file2 -PathType Leaf)) #if folder exists it checks if the file exists in the folder
               {
                 try {
                       $null = New-Item -ItemType File -Path $file2 -Force -ErrorAction Stop
                        Write-Host "The file $file2 has been created."
                        #file input section here
                        "Username = $localusername `nService Tag = $Serialnumber `nBIOS version = $BIOSversion `nHDD = $harddrivemodel `nRAM in GB = $totalphysicalmemory `nRAM clock below per slot $RAMclock" | out-file -filepath $file2
                        $Ramclock | out-file -FilePath $file2 -append
                      }
                  catch {
                        throw $_.Exception.Message
                        }
                    }
         else {#this else asks if you would like to overwrite the existing file data, and then overwrites the existing SystemInfoHemm.txt file     
                 $title    = "Warning!"
                 $question = "$file2 already exists, are you sure you want to overwrite it?"
                 $choices  = '&Yes', '&No'

                 $decision = $Host.UI.PromptForChoice($title, $question, $choices, 1)
                 if ($decision -eq 0) ##takes value of answer
                     {
                      Write-Host "$file2 has been overwritten."
                       #file input section here
                      "Username = $localusername `nService Tag = $Serialnumber `nBIOS version = $BIOSversion `nHDD = $harddrivemodel `nRAM in GB = $totalphysicalmemory `nRAM clock below per slot $RAMclock" | out-file -filepath $file2
                      $Ramclock | out-file -FilePath $file2 -append
                      }
                  else {
                       Write-Host 'Process cancelled'
                        }
             }
    }
Write-Host "System will now check Windows File Integrity, please wait, this will take some time."
sfc /scannow
Read-Host "Press Enter to exit"
}


else 
{
# elevates the script in case the tech can't remember right click exists
Start-Process -FilePath powershell -ArgumentList {-executionpolicy bypass -file \\servername\dir\dir\dir\Foo.ps1 } -verb Runas
#keep below exit till sure script works, would otherwise exit parent shell in favor of elevated shell
#exit
}

