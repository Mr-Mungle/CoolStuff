#Author: mungle
#Description: Small automation that ensures a user's home drive is mapped to their physical laptop per AD value, then, isolates the letter used for the user's home drive, concats that letter with the proper filepath needed to save something on the desktop of the user's XD
#############################################

 
#var cleanup
$homedrive = $null
$filepath = $null
$filepath1 = $null
$filepath2 = $null
$filepath3 = $null
$filepath4 = $null
$test1 = $null
$test2 = $null
$test3 = $null
$test4 = $null
$WholeFilepath = $null
$paths = $null


#checks if there is a drive with home_ in the root path, denoting home drive
$homedrive = Get-PSDrive | where{$_.DisplayRoot -like "*home_*"} | Select-Object -Property Name 

if($homedrive -eq $null) #if there is no drive found with home_ in root, this first if maps user's home drive from AD, else the script copies the shortcuts to the proper filepath
    {
        #Proprietary code that maps AD generated homedrive goes here
        Sleep 7
        #resets variable used to store letter value of homedrive
        $homedrive = $null
        #tries to find a drive with home_ in root after mapping homedrive per AD
        $homedrive = Get-PSDrive | where{$_.DisplayRoot -like "*home_*"} | Select-Object -Property Name 

    
        if($homedrive -eq $null)#if the script still can't locate a drive that contains home_, it displays a popup instructing the user to contact techbar or helpdesk for support verifying they have a valid homedrive in AD
            {
                $shell = new-object -comobject "WScript.Shell"
                $result = $shell.popup("No home drive found associated with this Active Directory account.  Please contact Help Desk and ask to have your homedrive verified.",5,"Warning",0 + 16 + 4096)
                Exit #exits the script after the user clicks "OK"
            }
        else
            {
                #for diag
                #Write-host $homedrive.Name
                #concats the two vars to make one filepath
                $filepath = ":\Desktop"
                $filepath = $filepath.ToString()
                $WholeFilepath = -join$(($homedrive.Name) + "$filepath")

                #for diag
                #Write-Host "` "
                #Write-Host $WholeFilepath

                #copies the shortcuts from my share to the XD Desktop
                Get-ChildItem \\servername\directory\directory\ | ForEach-Object {
                    copy-item -Path $_.FullName -Destination $WholeFilepath
                    Sleep 5
                    }
            }
    }
else
    {
        #for diag
        #Write-host $homedrive.Name
        #concats the two vars to make one filepath
        $filepath = ":\Desktop"
        $filepath = $filepath.ToString()
        $WholeFilepath = -join$(($homedrive.Name) + "$filepath")

        #for diag
        #Write-Host "` "
        #Write-Host $WholeFilepath

        #copies the shortcuts from my share to the XD Desktop
        Get-ChildItem \\servername\directory\directory\ | ForEach-Object {
            copy-item -Path $_.FullName -Destination $WholeFilepath
            Sleep 5
            }
    }

#this block assigns filepaths to vars based off what the proper shortcut filepaths will be
$filepath1 = -join$("$WholeFilepath" + "\file1.lnk")
$filepath2 = -join$("$WholeFilepath" + "\file2.lnk")
$filepath3 = -join$("$WholeFilepath" + "\file3.lnk")
$filepath4 = -join$("$WholeFilepath" + "\file4.lnk")
$test1 = Test-Path $filepath1
$test2 = Test-Path $filepath2
$test3 = Test-Path $filepath3
$test4 = Test-Path $filepath4

#creates array of the results of testing the path to the 4 shortcuts
$paths = ($test1, $test2, $test3, $test4)


if(($paths) -contains $false)#checks that the array does not contain a False boolean value
    {
        $shell = new-object -comobject "WScript.Shell"
        $result = $shell.popup("One or more shortcuts did not map properly, please rerun the application.",5,"Error",0 + 16 + 4096) 
    }
else
    {
        $shell = new-object -comobject "WScript.Shell"
        $result = $shell.popup("Shortcuts copied to your Virtual Desktop's Desktop.",5,"Success",0 + 64 + 4096)
    }