#outputs list of site collection subsites along with built-in properties
#In future versions of PnP SharePoint Powershell the -include modifier will output specified spweb properties 

#Connection
$me = Get-Credential
Connect-PNPOnline -url  https://tenent.sharepoint.com/sites/sitecollection -credential $me

#Get the sites and output
Get-PnPSubWebs -Recurse | Export-Csv -Path C:\Subsites.csv -Encoding ascii -NoTypeInformation
