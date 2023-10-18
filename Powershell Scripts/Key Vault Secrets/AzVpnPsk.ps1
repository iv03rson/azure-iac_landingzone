param (
    [Parameter(Position=0,Mandatory=$true,HelpMessage="The name of the secret to create in key vault")]
    [string]$secretname,

    [Parameter(Position=1,Mandatory=$true,HelpMessage="The value of the secret to create in key vault")]
    [string]$secretvalue
)

# user name for foundations service principal is "22688031-35c6-431b-a5d1-7b5c0d8196d2", which is the enterprise application ID.
 $credentials = Get-Credential

 Connect-AzAccount -serviceprincipal -Credential $credentials -Tenant "2a7799fa-3705-4d9f-a766-ca37ccfafc06"

$securesecret = convertto-securestring -string $secretvalue -AsPlainText -Force 

Set-AzKeyVaultSecret -VaultName "clgx-foundation-az-kv" -Name $secretname -SecretValue $securesecret