#Author : mungle
#Description : Nifty framework that checks to see if a user tried to run a script/program as admin, and if not, calls to a server and tries to run the same script/program AS admin, prompting for admin credentials


$principal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
if($principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {



#Here you can add whatever code is supposed to run in case the tech is intelligent enough to remember to run as admin


 






}
else 
{
# elevates the script in case the tech can't remember right click exists
Start-Process -FilePath powershell -ArgumentList {-executionpolicy bypass -file \\servername\dir\dir\dir\Foo.ps1 } -verb Runas
#In the above filepath paste the path to what you want to run as admin including filename and extension like the above example
#keep below exit till sure script works, would otherwise exit parent shell in favor of elevated shell
exit
}
