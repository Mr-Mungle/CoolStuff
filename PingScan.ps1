#Author : mungle
#Description : Side project idea for recording all active IPs inside a corporate network without tripping any security programs

##You need to edit all write-host lines, Test-connection line, and add-content line to match first set of the octet you want to test

New-Item C:\Users\foo\desktop\ActiveIPs.csv -ItemType File #need to modify this filepath to match your local environment

#$a=Read-Host -Prompt 'IP start value for xx.**.**.**'   seems to break if you don't have at least part of a string in -computername arg, need to find a way to force that to work so user can enter full custom octet without editing source code
#$a=[int]$a
$b=Read-Host -Prompt 'IP start value for **.xx.**.**'
$b=[int]$b
$c=Read-Host -Prompt 'IP start value for **.**.xx.**'
$c=[int]$c
$d=Read-Host -Prompt 'IP start value for **.**.**.xx'
$d=[int]$d
#$e=Read-Host -Prompt 'IP end value for xx.**.**.**'    same error as above, end range for first 1/4 of octet not needed if it is specified in -computername argument
#$e=[int]$e
$f=Read-Host -Prompt 'IP end value for **.xx.**.**'
$f=[int]$f
$g=Read-Host -Prompt 'IP end value for **.**.xx.**'
$g=[int]$g
$h=Read-Host -Prompt 'IP end value for **.**.**.xx'
$h=[int]$h


do
    {
do
    {
do
    {
        Write-Host "Testing 10.$b.$c.$d" ##print current IP being tested here
        #$CurrentIP="10.$b.$c.$d"
        #$CurrentIP=$CurrentIP.ToString()
        #$pingTest=Test-Connection -ComputerName 192.$b.$c.$d -AsJob -count 1  
        if(Test-Connection -ComputerName 10.$b.$c.$d -count 1 -quiet) #set octet, -quiet returns boolean value
            {
                Write-Host "10.$b.$c.$d is active" #print current IP being tested here
                Add-content C:\users\foo\desktop\ActiveIPs.csv "10.$b.$c.$d" #writes active IP to csv file, need to modfy to match local environment
                Sleep 10  #shhh
            }
        else
            {
                Write-Host "10.$b.$c.$d is inactive" #print current IP being tested here as not being up
                Sleep 10
            }
    $d++
    }while ($d -le $h) #set upper bound of **.xx.**.** to ping
    $d=0 #need to reset value every time do-while runs
    $c++
    }while ($c -le $g) #set upper bound of **.**.xx.** to ping
    $c=0 #need to reset value every time do-while runs
    $b++
    }while ($b -le $f) #set upper bound of **.**.**.xx to ping
