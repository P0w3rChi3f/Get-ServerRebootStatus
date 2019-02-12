$servers = Get-ADComputer -Filter 'OperatingSystem -like "Windows Server *"' -SearchBase "OU=NGPE,OU=States,DC=ng,DC=ds,DC=army,DC=mil"
$date = Get-Date -Format m

foreach ($server in $Servers) {

    $SN = $Server.SamAccountName.Trim('$')

    Invoke-Command -ComputerName $SN -ScriptBlock {

        $path = 'HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\'
        $name = 'PendingFileRenameOperations'
        $keyPresent = Get-ItemProperty -Path $path -Name $name -ErrorAction SilentlyContinue

        if ($keyPresent -ne $null) {

        $keyPresent | Select-Object pscomputername, @{Label='RebootRequired'; Expression={$true}}
        
        }

        else {$keyPresent | Select-Object pscomputername, @{Label='RebootRequired'; Expression={$false}}}

    } | Export-Csv C:\AGMLogs\RebootRequired_$date.csv -Append





}
<#

Send-MailMessage -to eric.l.johnson256.civ@mail.mil, michael.a.halter.civ@mail.mil -cc james.j.honeycutt.civ@mail.mil `
 -from HoneycuttPowerShell@mail.mil `
 -Subject "Server Reboot" `
 -body "The following need to be rebooted: 
 $lockedusers" `
 -Attachments C:\AGMLogs\RebootRequired_$date.csv `
 -SmtpServer NGPEB3-MAILRELAY

 #>