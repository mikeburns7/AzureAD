$DestinationTenantId = read-host "Enter Azure AD Tenant ID"
$MsiName = read-host "Enter the displayname of your Managed Identity (as displayed in Enterprise Applications)"

#list permissions needed by Managed Identity
$oPermissions = @(
  "Group.ReadWrite.All"
  "User.ReadWrite.All"
)

$GraphAppId = "00000003-0000-0000-c000-000000000000" # Don't change this.

$oMsi = Get-MgServicePrincipal -Filter "displayName eq '$MsiName'"
$oGraphSpn = Get-MgServicePrincipal -Filter "appId eq '$GraphAppId'"

$oAppRoles = $oGraphSpn.AppRoles | Where-Object {($_.Value -in $oPermissions) -and ($_.AllowedMemberType -contains "Application")}

Connect-MgGraph -TenantId $DestinationTenantId

foreach($AppRole in $oAppRoles)
{
  $oAppRoleAssignment = @{
    "PrincipalId" = $oMSI.Id
    #"ResourceId" = $GraphAppId
    "ResourceId" = $oGraphSpn.Id
    "AppRoleId" = $AppRole.Id
  }
  
  New-MgServicePrincipalAppRoleAssignment `
    -ServicePrincipalId $oAppRoleAssignment.PrincipalId `
    -BodyParameter $oAppRoleAssignment `
    -Verbose
}
