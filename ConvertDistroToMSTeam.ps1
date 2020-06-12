
function append-text { 
  process{
   foreach-object {$_ + $domain}
    } 
  }

Connect-MicrosoftTeams

#Use this script to export users to a .csv, create a Team, and import the users to the team

$domain = Read-host "Enter domain, such as @contoso.com"


#Get users from AD distribution, append email.
$groupName = Read-host "Enter the name of the group you would like to pull users from"
$memberlist = (Get-AdGroupMember -identity $groupName | Select SamAccountName | ft -HideTableHeader | Format-List | Out-string).Trim()
$memberlist | out-file -FilePath C:\scripts\users.txt
$x = Get-Content C:\scripts\users.txt
$emailList = ($x | append-text)
$emaillist = $emailList -replace '\s', ''
$emailList | Out-GridView


#create team with members
$team = Read-Host "What would you like to name your new Team?"
$group = New-Team -MailNickname $team -displayname $team -Visibility "private" 

foreach($email in $emailList) 
{
    Add-TeamUser -GroupId $group.GroupId -User $email
}