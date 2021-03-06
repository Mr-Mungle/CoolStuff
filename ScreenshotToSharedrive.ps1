#Author : mungle
#Description : This version saves a screenshot to a share drive to make it easier to grab later and concats the filename with localusername


$entireusername = $(Get-WMIObject -class Win32_ComputerSystem | select username).username
$separator = "\"
$localusernamearray = $entireusername.split($separator)
$localusername = $localusernamearray[1]

Add-Type -AssemblyName System.Windows.Forms,System.Drawing

	$screens = [Windows.Forms.Screen]::AllScreens
	$top    = ($screens.Bounds.Top    | Measure-Object -Minimum).Minimum
	$left   = ($screens.Bounds.Left   | Measure-Object -Minimum).Minimum
	$width  = ($screens.Bounds.Right  | Measure-Object -Maximum).Maximum
	$height = ($screens.Bounds.Bottom | Measure-Object -Maximum).Maximum
	$bounds   = [Drawing.Rectangle]::FromLTRB($left, $top, $width, $height)
	$bmp      = New-Object System.Drawing.Bitmap ([int]$bounds.width), ([int]$bounds.height)
	$graphics = [Drawing.Graphics]::FromImage($bmp)
	$graphics.CopyFromScreen($bounds.Location, [Drawing.Point]::Empty, $bounds.size)

	$bmp.Save("$env:USERPROFILE\Desktop\TechbarScreenshot.png")
	$bmp.Save("\\somerservername\foo\Screenshots\$localusername Screenshot.png")
    $graphics.Dispose()
	$bmp.Dispose()