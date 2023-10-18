# This script will create a custom role, defined as specified in the inputfile. 
# This script is separate from the foundations module and parent script because this script must be run using an account that is an owner on the root tenant group.
# Any changes to the custom role need to made in the json file.

param (
    [Parameter(Position=0,Mandatory=$true,HelpMessage="The name of the custom role")]
    [string]$Rolename
)

$Inputfile = ".\$Rolename.json"
New-AzRoleDefinition -InputFile $Inputfile -Debug