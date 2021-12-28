#Author : mungle
#Description : POC that feeds everything installed on a machine and passes it through to an excel file, could later be used to compare results against a master list hosted on a server to vet units post image for compliance.

##This block pulls only local user name and assigns it to $localusername var
$entireusername = $(Get-WMIObject -class Win32_ComputerSystem | select username).username
$separator = "\"
$localusernamearray = $entireusername.split($separator)
$localusername = $localusernamearray[1]     
      
#This block installs the required module/nuget
Install-PackageProvider -Name Nuget -RequiredVersion 2.8.5.208 -Scope CurrentUser -Force
Install-Module -Name ImportExcel -RequiredVersion 7.4.0 -Scope CurrentUser -Force

# read everything with an Uninstall key from all four locations and hides errors if they don't exist
Get-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\*',
                    'HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*',
                    'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\*',
                    'HKCU:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*' -ErrorAction Ignore |
# list only items with a displayname
Where-Object DisplayName |
# show these registry values per item: Then sort out duplicates that may be in more than one registry location at once
Select-Object -Property DisplayName, DisplayVersion, Publisher, UninstallString, InstallDate -unique |
# sort by displayname: Then feed to an excel file simultaneously creating a pivot table breaking down programs by publisher
Sort-Object -Property DisplayName | Export-Excel C:\Users\$localusername\Desktop\InstalledApps.xlsx -AutoSize -AutoFilter -IncludePivotTable -PivotRows Publisher, DisplayName
