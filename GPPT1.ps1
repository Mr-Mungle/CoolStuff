#Author : mungle
#Description : First part of a script designed to be a silver bullet for common Global Protect issues

##Pull localusername
$entireusername = $(Get-WMIObject -class Win32_ComputerSystem | select username).username
$separator = "\"
$localusernamearray = $entireusername.split($separator)
$localusername = $localusernamearray[1]

##Need to load wi-fi driver for machine onto desktop
Read-Host "Save Wi-Fi Driver to desktop as file labeled WIFIDRIVER.exe, press any key to continue once done."

##Need to load GLO GP folder onto desktop
Read-Host "Build file system for Global Protect install media on your desktop in a folder named GlobalProtect.`
Press any key to continue once done."

##Need to run sfc/scannow
Write-Host "Running Windows System File Checker"
#sfc /scannow
Sleep 5
##Need to uninstall Global protect
Write-Host "We are now uninstalling Global Protect"
$MyApp = Get-WmiObject -Class Win32_Product | Where-Object{$_.Name -eq "GlobalProtect"}
$MyApp.Uninstall()
Sleep 2
Write-Host "We are now going to delete related files."

##Need to delete HKEY_CURRENT_USER\Software\Palo Alto Networks
Get-Item 'HKCU:\Software\Palo Alto Networks' | Remove-Item -Force -Verbose -Recurse

##Need to delete HKEY_LOCAL_MACHINE\SOFTWARE\Palo Alto Networks
Get-Item 'HKLM:\SOFTWARE\Palo Alto Networks' | Remove-Item -Force -Verbose -Recurse

##Need to delete C:\Program Files\Palo Alto Networks
Get-Item 'C:\Program Files\Palo Alto Networks' | Remove-Item -Force -Verbose -Recurse

##Need to delete C:\Users\User\AppData\Local\Palo Alto Networks
Get-Item C:\Users\$localusername\AppData\Local\'Palo Alto Networks' | Remove-Item -Force -Verbose -Recurse

##Need to delete driver+data for whatever adapters potentially have corrupt config files and then reboot
do
{
    $DeviceName = "Gibberish"
    $DriverProviderName = "Gibberish"
    $drivers = "Gibberish"
    $drivertotaldescription = "Gibberish"
    $DriverVersion = "Gibberish"
    $DriverName = "Gibberish"
        $DeviceName = Read-Host " ` 
Please enter a keyword to describe the networking device whose driver you are searching for. `
For example, ethernet, wifi, wi-fi, dual band, bluetooth, it differs by unit model. `
If you get an error, try another name. ` 
` 
*******I HIGHLY suggest deleting the unused NIC driver first as it will kill your remote support session and the user will be driving for the rest*******"
        $DriverProviderName = Read-Host "Please enter the name of the company who makes the other driver or device in question. For example, Intel, or Realtek"

    $drivers = get-wmiobject win32_PnpsignedDriver | where{$_.DeviceName -like "*$DeviceName*" -and $_.DriverProviderName -like "*$DriverProviderName*"}
    $DriverVersion = $drivers.DriverVersion.ToString()
    $DriverName = $drivers.DeviceName.ToString()

    $drivertotaldescription = $DriverName + " : Version " + $DriverVersion 
    #Write-Host $drivertotaldescription
    $shell = new-object -comobject "WScript.Shell"
    $result = $shell.popup($drivertotaldescription + "` Is this the right driver?",0,"Driver Verification",0x4+32+4096)#create a popup that displays the selected driver to verify it is right
    if($result -eq "6")#first if else that checks with user if the program grabbed the right driver
        {
            Write-Host "Looks like you picked yes, here goes uninstall in 5 seconds"#if they click yes, program deletes selected driver from machine
            Sleep 5
            pnputil.exe /delete-driver $drivers.InfName /uninstall /force
        }
    else
        {
            Write-Host "Looks like that wasn't quite it, let's try again."

        }
}while($result -eq "7")#exits if you click yes


$shell = new-object -comobject "WScript.Shell"
$result2 = $shell.popup("Would you like to remove another driver?",0,"Insert Title Here",0x4+32+4096)#creates a popup that asks if tech wants to remove another driver


if($result2 -eq "6")
{
    do #second do-while loop for the second driver
    {
        $DeviceName = "Gibberish"
        $DriverProviderName = "Gibberish"
        $drivers = "Gibberish"
        $drivertotaldescription = "Gibberish"
        $DriverVersion = "Gibberish"
        $DriverName = "Gibberish"
        
        
        $DeviceName = Read-Host " ` 
Please enter a keyword to describe the networking device whose driver you are searching for. `
For example, ethernet, wifi, wi-fi, dual band, bluetooth, it differs by unit model. `
If you get an error, try another name. ` 
` 
*******I HIGHLY suggest deleting the unused NIC driver first as it will kill your remote support session and the user will be driving for the rest*******"
        $DriverProviderName = Read-Host "Please enter the name of the company who makes the other driver or device in question. For example, Intel, or Realtek"

        $drivers = get-wmiobject win32_PnpsignedDriver | where{$_.DeviceName -like "*$DeviceName*" -and $_.DriverProviderName -like "*$DriverProviderName*"}
        $DriverVersion = $drivers.DriverVersion.ToString()
        $DriverName = $drivers.DeviceName.ToString()

        $drivertotaldescription = $DriverName + " : Version " + $DriverVersion 
        #Write-Host $drivertotaldescription
        $shell = new-object -comobject "WScript.Shell"
        $result = $shell.popup($drivertotaldescription + "` Is this the right driver?",0,"Driver Verification",0x4+32+4096)#creates a popup that asks for a yes/no on the second driver            
        if($result -eq "6")#checks with user if program grabbed right driver
            {
                Write-Host "Looks like you picked yes, here goes second uninstall in 5 seconds"
                Sleep 5
                pnputil.exe /delete-driver $drivers.InfName /uninstall /force
            }
        else 
            {
                Write-Host "Looks like that wasn't quite it, let's try again."
            }
    }while($result -eq "7")
}
else
{

}
$shell = new-object -comobject "WScript.Shell"
$shell.popup("Goodbye, restarting machine in 20 seconds or once you click Ok",20,"Pointless Popup Window",0 + 4096)
restart-computer -force