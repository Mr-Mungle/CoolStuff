#Author : mungle
#Description : This is a self elevating parent script for some stage of updates for a Dell laptop, it checks user state to see if tech remembered to run as admin, if so, runs script below, if not, runs script from share as admin




$principal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
if($principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) 
    {
Write-Host "This install script will install 8 driver/firmware updates, please allow each driver to install fully before proceeding to the next."
Get-ChildItem '\\servername\dir\dir\InstallMedia' | ForEach-Object {  
Write-Host ''
Write-Host "Now running "$_.Name
  & $_.FullName
Write-Host ''
Write-Host "Done loading "$_.Name
  Read-Host "`Please wait for each popup before proceeding to the next updater 
                `After the updater runs, wait for the success popup then close
                `do not restart if requested till all updaters have run
		`
		`Press enter to load the next file"
}
Write-Host "Your computer will now restart in 15 seconds"
Sleep 15
Restart-Computer -force

    }
else 
    {
        Start-Process -FilePath powershell -ArgumentList {-executionpolicy bypass -file \\servername\dir\dir\dir\ClearlyNamedFoo.ps1 } -verb Runas
    }