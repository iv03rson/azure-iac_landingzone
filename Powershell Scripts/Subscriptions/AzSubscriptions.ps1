# user name for foundations service principal is "22688031-35c6-431b-a5d1-7b5c0d8196d2", which is the enterprise application ID.
$credentials = Get-Credential

Connect-AzAccount -serviceprincipal -Credential $credentials -Tenant "2a7799fa-3705-4d9f-a766-ca37ccfafc06"

Import-Module "./AzSubscriptionFunctions.psm1"

New-AzCoreLogicSubscription -subscriptionalias "clgx-environment-hub" -subscriptionname "clgx-environment-hub" -managementgroupname "Management"