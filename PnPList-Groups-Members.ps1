#Output All SharePoint Groups  with a list of members for Site Collection

#Connection
$me = Get-Credential
$siteURL = "https://tenet.sharepoint.com/sites/sitecollection"
Connect-PNPOnline -url $siteURL  -credential $me

#Formatting table and output https://poshoholic.com/2010/11/11/powershell-quick-tip-creating-wide-tables-with-powershell/
$FormatEnumerationLimit = -1

#Output groups- Credit to http://www.c-sharpcorner.com/blogs/get-group-users-from-sharepoint-site-using-pnp-powershell 
$groups = Get-PnPGroup | Select-Object Title,Users

# Output to file
$groups | Format-Table -Wrap -AutoSize @{Expression = {$_.Title};Label='Group'},@{Expression = {$_.Users.Title};Label='Users'},@{Expression = {$_.Users.Count};Label='UsersCount'} | Out-String -Width 4096 | Out-File C:\Users\Administrator.MOJAVE\Downloads\DENGroups.txt