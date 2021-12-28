#Author : mungle
#Description : This tool accepts user input to search for a specific driver with the aim of deleting that driver and files associated with it via command line and popups.
                #long term goal is to have it accept keywords from the user, run a search of installed drivers, grab the description of the driver and feed it back to user
                # to verify if that is in fact the correct driver.
                #If it isn't, in fact, the correct driver, the script will then prompt user to re-enter a better string value to search against $_.DeviceName
                #In future, after three tries, script will then insult user's intelligence and ability to guess word combinations.

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
If you get an error, try another name. "
    $DriverProviderName = Read-Host "Please enter the name of the company who makes the driver or device in question. For example, Intel, or Realtek"

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
*******I HIGHLY suggest deleting the unused NIC driver first as it will kill your bomgar session and the user will be driving for the rest*******"
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