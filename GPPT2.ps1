#Author : mungle
#Description : Second part of a script designed to be a silver bullet for common GlobalProtect issues
	


###Part 2 below
Install-Package -Name "NuGet" -Force
Install-Module -Name wifiprofilemanagement
Install-Module -Name WiFiTools

#var creation/cleanup in case tech runs script multiple times
$i = $null
$x = $null
$wifiprofiles = $null


$wifiprofiles = Get-Wifiprofile -ClearKey #loads cached wifi profiles into array of objects
$i = $wifiprofiles.Length #assigns array length to variable that will be used later for looping through yes/no options
$i = $i/1 #convert System.String to Int32 the lazy way
$x = 0 #the increment var
$x = $x/1 #convert System.String to Int32 the lazy way


while($x -lt $i) #runs once per wifi profile
    {
        #var cleanup, needed?
        $ProfileName = $null
        $Password = $null
        $result = $null
        
        #meat
        $ProfileName = $wifiprofiles[$x].ProfileName
        $shell = new-object -comobject "WScript.Shell"
        $result = $shell.popup("Do you want to delete $ProfileName ?",0,"No Cowboy Action",0x4 + 32 + 4096) #spawns popup with infinite ttl locked on top for y/n on del
        
        #potatoes
        if($result -eq 6) #if user/tech clicks yes, reloads displayed wifi profile, doesn't work for domain accounts that use SSO.
            {
                $Password = $wifiprofiles[$x].Password
                $Password = ConvertTo-SecureString $Password -AsPlainText -Force
                NETSH WLAN DELETE PROFILE NAME=$ProfileName
                New-WiFiProfile -ProfileName $wifiprofiles[$x].ProfileName -ConnectionMode $wifiprofiles[$x].ConnectionMode -Authentication $wifiprofiles[$x].Authentication -Password $Password -Encryption $wifiprofiles[$x].Encryption
            }
        $x++ #increments through array of available wifiprofiles
    }


##Need to reinstall GP from desktop
& C:\Users\$localusername\Desktop\GlobalProtect\Foo.ps1

##Need to reinstall wi-fi adapter driver from desktop
Write-Host "Reloading Wi-Fi Driver, this will require a reboot, do not do so till GP is fully installed and tries to connect."
& C:\Users\$localusername\Desktop\WIFIDRIVER.exe

##Restart WlanSvc
powershell -Command "Restart-Service wlansvc -Force"

##Need message instructing user to test GP now.
Write-Host "Please test GP connection now."