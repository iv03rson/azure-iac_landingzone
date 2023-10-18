$subscriptionId = "1bea2b18-ff34-482f-88f5-2c47aef31204"
$servicePrincipalName = "tf-clgx-foundation-az"
$kvSecretName = "foundationsecret"
$keyVaultName = "clgx-foundation-az-kv"

# Set the subscription context
Select-AzSubscription -SubscriptionId $subscriptionId

# Get the Service Principal
$sp = Get-AzADApplication -DisplayName $servicePrincipalName

if ($sp) {
    # Generate a new secret
    $newSecret = New-AzADAppCredential -ObjectId $sp.Id -EndDate (Get-Date).AddYears(1)

    if ($newSecret) {
        Write-Output "New secret created for Service Principal."
        Write-Output $newSecret.SecretText
        $kvSecretValue = ConvertTo-SecureString -String $newSecret.SecretText -AsPlainText -Force         
        Set-AzKeyVaultSecret -VaultName $keyVaultName -Name $kvSecretName -SecretValue $kvSecretValue 
        Write-Output "Secret updated in Key Vault."
    } else {
        Write-Error "Failed to create a new secret for Service Principal."
    }
    
    $newSecret = ""
} else {
    Write-Error "Service Principal not found."
}