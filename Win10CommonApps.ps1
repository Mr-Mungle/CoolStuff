#Author : mungle
#Description : Loads a directory of whatever you want to a computer, written to detect if a specific c++ redist is installed to cater to older call center programs
#              Written for a series of call centers that all get slightly different post image configurations, internet browser shortcuts, profile configs, programs, program configs, data files, program shortcuts, etc


#beginning of self elevate frame
$principal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
if($principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) 
    {
        #This creates the function used to create the yes/no popups
        function Check-InstallSoftware #defines function that creates a popup asking if you would like to install extra software during the build
            {
                [CmdletBinding()]
                param([Parameter(Mandatory)][string] $filepath)
                Write-Host "You are currently loading $filepath from the share."

                $shell = new-object -comobject "WScript.Shell"
                $result = $shell.popup("Do you want to install $filepath ?",0,"Do you wannaaaaaa?",0x4 + 32 + 4096)
    
                If($result -eq "6")
                    {
                        Write-Host "Installing $filepath"
                        Write-Host "` "
                        & $filepath
                        $shell = new-object -comobject "WScript.Shell"
                        $catch = $shell.popup("Please wait till $filepath is done installing/configuring before continuing.",0,"Whoa Nelly",0 + 16 + 4096) #I put $catch here so it doesn't print "1" to the command line
                    }
                else
                     {
                        Write-Host "You picked no ` "
                        Write-Host "` "
                     }
            }


#This block seaches for c++ redist 2019 x86
    $Redist = $null
    $Redist = Get-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\*',
                                     'HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*',
                                     'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\*',
                                     'HKCU:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*' -ErrorAction Ignore | 
                    #this part below checks display name of the installed program against the args in the script block
    Where-Object DisplayName | where{($_.DisplayName -like "*C++*" -and $_.DisplayName -like "*2019*" -and $_.DisplayName -like "*x86*")} | 
    Select-Object -Property DisplayName, DisplayVersion, Publisher, UninstallString, InstallDate -unique | 
    Sort-Object -Property DisplayName

#this part determines what route the program takes, whether it installs the win10 common apps or if it throws error message and exits
    if($Redist)
        {
            $shell = new-object -comobject "WScript.Shell"
            $catch = $shell.popup("Looks like C++ 2015-2019 x86 is still installed, you need to uninstall via control panel then reboot",0,"Pointless Popup Window",0+4096)
            appwiz.cpl #opens control panel
            exit #exits entire script as you cannot proceed with install
        }
    else #else that iterates through the Main Dir for whatever programs you want installed
        {
            $shell = new-object -comobject "WScript.Shell"
            $catch = $shell.popup("You are clear to proceed with the Windows 10 Common Apps Install",10,"Great Success!",0+4096)
            $shell = new-object -comobject "WScript.Shell"
            $catch = $shell.popup("This script will install Windows 10 Common Apps for y'all, please allow each segment to install fully before proceeding to the next.",10,"Commencing Countdown Engines On",0+4096)
        
            Get-ChildItem '\\servername\DirectoryContainingShortcutsToInstallMedia' | ForEach-Object {  

                Check-InstallSoftware $_.FullName
            }
            Write-Host "Hold please"
            Sleep 5
        }

    $result = $null #cleans $result from the function iterations earlier
    $shell = new-object -comobject "WScript.Shell"
    $result = $shell.popup("Do you want to install the ancillary programs ?",0,"Do you wannaaaaaa?",0x4 + 32 + 4096) #checks if tech wants to install the ancillary call center apps

    If($result -eq "6") #if tech says yes, iterates through some other directory where you'd host extra shortcuts for, perhaps another project
        {
            Get-ChildItem '\\servername\DirectoryContainingShortcutsToInstallMedia\AncillaryDirectory' | ForEach-Object {  

            Check-InstallSoftware $_.FullName
            }
        }

    }#closing curly bracket for opening if statement
else #closing else for the self elevate framework
    {
        Start-Process -FilePath powershell -ArgumentList {-executionpolicy bypass -file \\servername\Directory\AwesomeTimeSaver.ps1 } -verb Runas
    }