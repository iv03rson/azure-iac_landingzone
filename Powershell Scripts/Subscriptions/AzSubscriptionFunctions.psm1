function New-AzCoreLogicSubscription ($subscriptionname, $subscriptionalias, $managementgroupname)
{
    New-AzSubscriptionAlias -AliasName $subscriptionalias -SubscriptionName $subscriptionname -BillingScope "/providers/Microsoft.Billing/BillingAccounts/<billingacount#>/enrollmentAccounts/<enrollmentaccount#>" -Workload "Production"
    Start-Sleep 20

    #Capture subscription ID.
    Select-AzSubscription -Subscription $subscriptionname
    $subscriptionId = (Get-AzContext).Subscription.Id

    # Move newly created subscription to management group
    Write-Host "Moving subscription to $managementgroupname"

    if ($managementgroupname)
    {
        New-AzManagementGroupSubscription -GroupId $managementgroup -SubscriptionId $subscriptionId
    }
    
    Start-Sleep 20
    Write-Output "New subscription completed successfully" -Verbose
}

function New-AzCoreLogicIacStorageAccount ($resourcegroupname, $location, $storageaccountname, $containernames) {

    # Set Context of the foundation subscription
    Set-AzContext -SubscriptionId "1bea2b18-ff34-482f-88f5-2c47aef31204" 
    
    # Create Storage Account
    New-AzStorageAccount -ResourceGroupName $resourcegroupname -Name $storageaccountname -Location $location -SkuName “Standard_RAGRS” -Kind StorageV2

    # Use (Enterprise app Object ID) Get Storage Account ID and assign Service Principal Storage Blob Data Contributor role (Role is need to write/read data to storage account)
    $storageaccountid = (Get-AzStorageAccount -name $storageaccountname -ResourceGroupName $resourcegroupname).Id 
    New-AzRoleAssignment -ObjectId "7d3ee0c1-a147-4cbf-9aea-5037ff62744c" -RoleDefinitionName "Storage Blob Data Contributor" -Scope $storageaccountid
    
    # Context is needed to authenticate to Storage Account
    $ctx = New-AzStorageContext -StorageAccountName $storageaccountname -UseConnectedAccount
    
    # Create multiple containers
    foreach ($containername in $containernames) {
        New-AzStorageContainer -Name $containername -Context $ctx
    }
}