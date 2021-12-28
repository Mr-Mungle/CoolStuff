#Author : mungle
#Description : Deletes and reloads wi-fi profiles commonly corrupted by Global Protect VNA issues, works on everything that doesn't use SSO
                #*****Must be run as admin to install required NuGet ver/Module/remove profiles*****



#installs latest NuGet needed for module import, then imports module
Install-Package -Name "NuGet" -Force
Install-Module -Name wifiprofilemanagement -Force


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
        $result = $shell.popup("Do you want to delete $ProfileName ?",0,"No Cowboy Action",0x4 + 32 + 4096) #spawns popup with infinit ttl locked on top for y/n on del
        
        #potatoes
        if($result -eq 6) #if user/tech clicks yes, deletes displayed wifi profile
            {
                $Password = $wifiprofiles[$x].Password
                $Password = ConvertTo-SecureString $Password -AsPlainText -Force
                NETSH WLAN DELETE PROFILE NAME=$ProfileName
                New-WiFiProfile -ProfileName $wifiprofiles[$x].ProfileName -ConnectionMode $wifiprofiles[$x].ConnectionMode -Authentication $wifiprofiles[$x].Authentication -Password $Password -Encryption $wifiprofiles[$x].Encryption
            }
        $x++ #increments through array of available wifiprofiles
    }