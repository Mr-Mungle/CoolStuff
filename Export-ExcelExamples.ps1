get-service | Export-Excel C:\Users\cstrout\Desktop\testdemo.xlsx -show #exports output from get-service to excel sheet then opens it sans formatting and filtering
get-service | Export-Excel C:\users\cstrout\Desktop\testdemo2.xlsx -show -AutoSize -AutoFilter #exports output from get-service to excel sheet then opens it, autosizing columns and aoutfiltering content

$Text1 = New-ConditionalText Stop
get-service | Export-Excel C:\Users\cstrout\Desktop\testdemo3.xlsx -show -autosize -ConditionalText $Text1 # exports output and color codes stopped processes based off $Text1 var
$Text2 = New-ConditionalText runn Blue Cyan #runn is keyword, Blue is text color (foreground), cyan is cell color (background)
get-service | Export-Excel C:\Users\cstrout\Desktop\testdemo4.xlsx -show -AutoSize -ConditionalText $Text1, $Text2 # exports output and color codes stopped versus running processes based on $Text1/Text2
$Text3 = New-ConditionalText svc Wheat Green
get-service |Export-Excel C:\Users\cstrout\Desktop\testdemo5.xlsx -Show -AutoSize -ConditionalText $Text1, $Text2, $Text3 #we are just playing around now.


$data = get-process |Where Company | Select Company, Name, PM, Handles, *mem*
$cfmt = New-ConditionalFormattingIconSet -Range "C:C" -ConditionalFormat ThreeIconSet -IconType Arrows
$data | Export-Excel C:\Users\cstrout\Desktop\testdemo6.xlsx -show -AutoSize -conditionalformat $cfmt #example for sorting PM with three arrow types, need to research more

$ctext = New-ConditionalText Microsoft Wheat Green

$data | Export-Excel C:\Users\cstrout\Desktop\testdemo7.xlsx -show -AutoSize -ConditionalFormat $cfmt -ConditionalText $ctext



#function example
function Remove-DemoXlsx {Remove-Item '.\demo.xlsx' -ErrorAction ingore }

$data2 = get-service | Select-Object Status, Name, DisplayName, StartType | Sort-Object StartType

#pivot table example
$data | Export-Excel C:\Users\cstrout\Desktop\testdemo8.xlsx -Show -AutoSize -Autofilter -IncludePivotTable   #attaches pivottable to data sheet where you can parse data out of the sheet

$data | Export-Excel C:\Users\cstrout\Desktop\testdemo9.xlsx -show -AutoSize -AutoFilter -IncludePivotTable -PivotRows StartType #autoadds data to pivot table for you from cli



$p = @{Show =$true; Autosize = $true; Autofilter = $true; IncludePivotTable = $true} #hash table to save time on stringing out parameter to export-excel cmdlet
$p.PivotRows = 'StartType'
$p.PivotData = 'StartType'

#this is called splatting

$data | Export-Excel C:\Users\cstrout\Desktop\testdemo10.xlsx @p

$c = @{Show =$true; Autosize = $true; Autofilter = $true; IncludePivotTable = $true} #hash table to save time on stringing out parameter to export-excel cmdlet
$c.PivotRows = 'StartType'
$c.PivotColumns = 'Status'
$c.PivotData = 'StartType'

$data | Export-Excel C:\Users\cstrout\Desktop\testdemo11.xlsx @c -IncludePivotChart -ChartType PieExploded3D -showcategory -showpercent # creates a pie chart inside the excel pivot table sheet running off the numbers from the pivot table, adds labels to chart


