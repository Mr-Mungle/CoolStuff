#Author: mungle
#Description: Passes event logs to an excel document with pivot tables to make it easier to search by keywords, create graphs, etc


Install-PackageProvider -Name Nuget -RequiredVersion 2.8.5.208 -Scope CurrentUser -Force
Install-Module -Name ImportExcel -RequiredVersion 7.4.0 -Scope CurrentUser -Force

 

$c = @{Autosize = $true; Autofilter = $true; IncludePivotTable = $true} #hash table to save time on stringing out parameter to export-excel cmdlet

$c.PivotRows = 'Source'

$c.PivotRows = 'Message'

$c.PivotData = 'CategoryNumber'

$data = Get-EventLog -LogName Application | Select-Object -Property *

$data | Export-Excel C:\Users\cstrout\Desktop\LogSortTest.xlsx @c