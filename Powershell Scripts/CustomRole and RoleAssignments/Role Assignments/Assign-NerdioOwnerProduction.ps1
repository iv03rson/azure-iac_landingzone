param (
    [Parameter(Position=0,Mandatory=$true,HelpMessage="The name of the role to assign")]
    [string]$Rolename,

    [Parameter(Position=1,Mandatory=$true,HelpMessage="The name of the app group the role is assigned to")]
    [string]$AppGroupName
)

$TenantID = ""

$credentials = Get-Credential

Connect-AzAccount -serviceprincipal -Credential $credentials -Tenant $TenantID

New-AzRoleAssignment -ObjectId "" -RoleDefinitionName $Rolename -Scope "/subscriptions/<SubID>/resourceGroups/<rgnamehere>/providers/Microsoft.DesktopVirtualization/applicationgroups/$AppGroupName"



