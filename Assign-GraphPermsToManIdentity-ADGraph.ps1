#reference: https://stackoverflow.com/questions/74513868/can-i-assign-api-permissions-to-user-assigned-managed-identities

#Connect-AzureAD
Connect-Graph Application.ReadWrite.All

#$TenantID= read-host "Enter you Azure AD ID of your Azure AD Tenant"
$GraphAppId = "00000003-0000-0000-c000-000000000000"
$DisplayNameOfMSI = read-host "Enter the displayname of your Managed Idenitty (as displayed in Enterprise Applications)"

# Read the user's input one line at a time and add it to the variable.
$PermissionNames = while (1) {read-host "Enter in permissions. proivde blank entry when done (aka just hit enter)" | set r; if (!$r) {break}; $r}


#$MSI = (Get-AzureADServicePrincipal -Filter "displayName eq '$NameOfMSI'")
$MSI = Get-MgServicePrincipal -Filter "DisplayName eq '$DisplayNameOfMSI'"
$GraphServicePrincipal = Get-MgServicePrincipal -Filter "appId eq '$GraphAppId'"


# Iterate over the multiline variable and perform the desired actions.
foreach ($PermissionName in $PermissionNames.Split("`n")){
    $AppRole = $GraphServicePrincipal.AppRoles | Where-Object {($_.Value -eq $PermissionName) -and ($_.AllowedMemberTypes -contains "Application")}

    #New-AzureAdServiceAppRoleAssignment -ObjectId $MSI.ObjectId -PrincipalId $MSI.ObjectId -ResourceId $GraphServicePrincipal.ObjectId -Id $AppRole.Id
    New-MgServicePrincipalAppRoleAssignment -ServicePrincipalId $MSI.Id -principalId $MSI.Id -resourceId $GraphServicePrincipal.Id -appRoleId $AppRole.Id

}
