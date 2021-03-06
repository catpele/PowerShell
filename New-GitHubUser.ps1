#############################
# PowerShell GitHub Invites #
#############################

Write-Output "This script invites a GitHub user to an organisation and stores their GitHub username in AD within the Info attribute"

$ADUser = Read-Host "Enter AD Username"
$GitUser = Read-Host "Enter GitHub Username"
$GitOrg = Read-Host "Enter GitHub Organisation"
$GitAccessToken = Read-Host "Enter Access Token"
$GitApiURL = "https://api.github.com/orgs/$GitOrg/"
$GitMemberships = "memberships/"

#Invites the GitHub user to the Organisation
Invoke-RestMethod -Uri $GitApiURL$GitMemberships$GitUser$GitAccessToken -Method Put

#Adds their GitHub username to the info AD Attribute
Set-ADUser $ADUser -Replace @{info="$GitUser"} 

# Obtains a current list of users
Write-Output "--- The following users were added and their 'info' attribute set ---"
Get-ADUser $ADUser -Property info | Select Name,info
