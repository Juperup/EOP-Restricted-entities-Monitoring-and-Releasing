$OutputTimeStamp = (get-date).tostring("yyyyMMdd_HHmmss")
#Recording Script excetue Logs
Start-Transcript -path "D:\logs\Log-$OutputTimeStamp.txt"

Add-PSSnapin Microsoft.Exchange.Management.PowerShell.SnapIn
#Connect to Exo Powershell
$LiveCred = Get-Credential
Connect-ExchangeOnline -Credential $LiveCred
#Smtp send mail informations
$SMTP = "smtp.office365.com"
$username = "svc-it.dep@contoso.com"
$password = "xxxx@3993"
#[SecureString]$securepassword = $password | ConvertTo-SecureString -AsPlainText -Force
$From = "svc-it.dep@contoso.com"
$to = "itadmin@contoso.com"
$Userlist = Get-BlockedSenderAddress
if ($Userlist -eq $null)
{

    $DisplayName = $User.Name
    #$To = $user.UserPrincipalName
    $Subject = "BlockedSender Notification"
    $Body = "restriced enties is null !"
    #$credential = New-Object System.Management.Automation.PSCredential -ArgumentList $username, $securepassword
    $Email = New-Object Net.Mail.SmtpClient($SMTP, 587)
    $Email.EnableSsl = $true
    $Email.Credentials = New-Object System.Net.NetworkCredential("$username","$password");
    $Email.Send($From, $To, $Subject, $Body)
}
else {

    foreach ($user in $Userlist)
    {
    #$DisplayName = $User.Name
    #$To = $user.UserPrincipalName
    $Subject = "BlockedSender Notification"
    $Body = "restriced enties is $user.Userprincipalname !"
    #$credential = New-Object System.Management.Automation.PSCredential -ArgumentList $username, $securepassword
    $Email = New-Object Net.Mail.SmtpClient($SMTP, 587)
    $Email.EnableSsl = $true
    $Email.Credentials = New-Object System.Net.NetworkCredential("$username","$password");
    $Email.Send($From, $To, $Subject, $Body)
    Remove-BlockedSenderAddress -SenderAddress $user.UserPrincipalName
    }
}
stop-transcript