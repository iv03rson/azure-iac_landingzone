Import-Module AzureAD

# Azure subscription and tenant details
$tenantId = ""

# Service principal details
$servicePrincipalId = "" # Object ID

# Authenticate using Azure CLI credentials
Connect-AzureAD -TenantId $tenantId

# Azure AD Application Administrator role details
$roleDefinition = Get-AzureADMSRoleDefinition -Filter "displayName eq 'Application Administrator'"

# Assign the Application Administrator role to the service principal
New-AzureADMSRoleAssignment -DirectoryScopeId '/' -RoleDefinitionId $roleDefinition.id -PrincipalId $serviceprincipalid

Write-Host "Azure AD Application Administrator role assigned to service principal successfully."
