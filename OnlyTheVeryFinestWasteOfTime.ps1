#Author: mungle
#Description: Proof of concept for testing Tanium to see if you can tell if a human is doing the typing via logs
#AlternateDescription: Something hilarious to run on someone's computer if you compile with the -noconsole switch after removing the notepad line, bonus points if you run it and open their Teams




#If you want to be evil, remove the notepad line
notepad.exe
$1 =        "Stop exploding, you cowards."
$2 =        "Uh-huh.Uh-huh. That's whatever you were talking about for ya."
$3 =        "Kif! Where's the little umbrella? That's what makes it a scotch on the rocks."
$4 =        "If we hit that bullseye, the rest of the dominoes should fall like a house of cards. Checkmate."
$5 =        "I am the man with no name, Zapp Brannigan at your service!"
$6 =        "Don't be such a chicken, Kif. Teenagers smoke, and they seem pretty on-the-ball."
$7 =        "Fire all weapons and set a transmission frequency for my victory yodel."
$8 =        "I got your distress call and came here as soon as I wanted to."
$9 =        "We'll just set a new course for that empty region over there, near that blackish, holeish thing."
$10 =        "In the game of Chess, you must never let your adversary see your pieces."
$11 =        "I've always thought of myself as a father figure to some of my more pathetic men."
$12 =        "You win again, Gravity!"
$13 =        "Has my fame preceded me? Or was I too quick for it?"
$14 =        "Care for some champaggin?"
$15 =       "I have made it with a woman. Inform the men!"
$16 =        "If there's an alien out there I can't kill, I haven't met them and killed them yet"
$17 =        "As you all know, the key to victory is the element of surprise.  ...surprise!"
$18 =        "When I'm in command, every mission is a suicide mission."
$19 =        "Come on girdle... hold!"
$20 =        "Fly the white flag of war."

$WordArray = @($1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11,$12,$13,$14,$15,$16,$17,$18,$19,$20)


Do{
    $RandomInt = $null
    $RandomWord = $null
    $RandomInterval = $null
    $Time = $null

    $Time = Get-Date -DisplayHint Time
    $RandomInt = Get-Random -Minimum 0 -Maximum 20
    $RandomWord = $wordArray[$RandomInt]
    $RandomInterval = Get-Random -Minimum 3 -Maximum 10
    sleep $RandomInterval

    Add-Type -AssemblyName System.Windows.Forms
    $RandomWord.ToCharArray() | ForEach-Object {
                                                    $sleeptime = $null
                                                    $sleeptime = Get-Random -Minimum 0 -Maximum 2
                                                    sleep $sleeptime
                                                    [System.Windows.Forms.SendKeys]::SendWait("$_")
                                                }
[System.Windows.Forms.SendKeys]::SendWait("{ENTER}")
}while($Time -lt "5:00:00 PM")