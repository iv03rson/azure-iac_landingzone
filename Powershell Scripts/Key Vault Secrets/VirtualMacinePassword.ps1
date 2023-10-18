param (
    [Parameter(Position=0,Mandatory=$true,HelpMessage="The name of the secret to create in key vault")]
    [string]$keyvaultname,

    [Parameter(Position=1,Mandatory=$true,HelpMessage="The name of the secret to create in key vault")]
    [string]$secretname,

    [Parameter(Position=2,Mandatory=$true,HelpMessage="The value of the secret to create in key vault")]
    [string]$secretvalue
)

$credentials = Get-Credential

Connect-AzAccount -serviceprincipal -Credential $credentials -Tenant "2a7799fa-3705-4d9f-a766-ca37ccfafc06"

$securesecret = convertto-securestring -string $secretvalue -AsPlainText -Force 

Set-AzKeyVaultSecret -VaultName $keyvaultname -Name $secretname -SecretValue $securesecret