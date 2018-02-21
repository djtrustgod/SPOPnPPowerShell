#Export list of all site collection webs with groups and permission level 
#Derived From https://gallery.technet.microsoft.com/office/Get-SharePoint-Online-and-7e6afce2
#Note - For larger site collections this script is very slow
#A better way in the future might be Get-PnPSubWebs -Recurse will be able to output -include argument and may provide a faster method
#See https://github.com/SharePoint/PnP-PowerShell/commit/ce3652388860328c26f7be6edb0ba9a7e012f48e  

function connect-site($webs, $creds) { 
 
    Connect-PNPonline -Url $webs -Credentials $cred 
 
} 
 
function get-sitepermission($web, $cred) { 
 
    $rec = @() 
 
    connect-site -webs $web -creds $cred 
 
    if ($web -eq $parentsitename) { 
        #Write-Host "Parent site permission" $web 
        $Pgroups = Get-PNPGroup 
        foreach ($Pgroup in $Pgroups) { 
            $DLGP = "" | Select "SiteUrl", "GroupName", "Permission" 
            $pPerm = Get-PNPGroupPermissions -Identity $Pgroup.loginname -ErrorAction SilentlyContinue |Where-Object {$_.Hidden -like "False"} 
            if ($pPerm -ne $null) { 
                $DLGP.SiteUrl = $web 
                $DLGP.GroupName = $Pgroup.loginname 
                $DLGP.Permission = $pPerm.Name 
                $rec += $DLGP 
            } 
        } 
    } 
    $subwebs = Get-PNPSubWebs 
    foreach ($subweb in $subwebs) { 
        connect-site -webs $subweb.Url -creds $cred 
        #Write-Host $subweb.Url 
        $groups = Get-PNPGroup 
        foreach ($group in $groups) { 
            $DLGP = "" | Select "SiteUrl", "GroupName", "Permission" 
            $sPerm = Get-PNPGroupPermissions -Identity $group.loginname -ErrorAction SilentlyContinue |Where-Object {$_.Hidden -like "False"} 
            if ($sPerm -ne $null) { 
                $DLGP.SiteUrl = $subweb.Url 
                $DLGP.GroupName = $group.loginname 
                $DLGP.Permission = $sPerm.Name 
                $rec += $DLGP 
            } 
        } 
        Write-Host $subweb.Url "permission fetched!" 
        get-sitepermission -web $subweb.Url -cred $cred 
 
    } 
    return $rec 
} 

#Input parameter 
$cred = Get-Credential 
$parentsitename = "https://mytenent.sharepoint.com/sites/SiteCollection" 
$outputPath = "C:\SubsitesPermissions.csv" 
 
$Sitepermission = get-sitepermission -web $parentsitename -cred $cred 
$Sitepermission |Export-Csv -Path $outputPath