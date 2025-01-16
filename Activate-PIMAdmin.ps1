#Function to activate PIM Admin role
#Remember to not store passwords in plain text. Use credential manager or Azure Key Vault

#Required modules: (use Install-Module) AzureADPreview, AZ

$CloudUser = "PIMAdmin@m365x353582.onmicrosoft.com"
$CloudPassword = ""
$TenantID ="daa018fe-d551-49d9-a237-fe6cdd5c5009"
$RoleToActivate = "Teams Administrator"

function ActivatePIM{
    [SecureString]$ksecureString = $CloudPassword | ConvertTo-SecureString -AsPlainText -Force 
    [PSCredential]$Cred = New-Object System.Management.Automation.PSCredential -ArgumentList $CloudUser, $ksecureString
    Connect-AzureAD -Credential $cred
    $SubjectId = Get-AzureADUSer -SearchString $CloudUser | select-object ObjectId
    $schedule = New-Object Microsoft.Open.MSGraph.Model.AzureADMSPrivilegedSchedule
    $schedule.Type = "Once"
    $schedule.StartDateTime = (Get-Date).ToUniversalTime().ToString("yyyy-MM-ddTHH:mm:ss.fffZ")
    $schedule.EndDateTime = (Get-Date).AddHours(1).ToUniversalTime().ToString("yyyy-MM-ddTHH:mm:ss.fffZ")
    
    $RoleID = "69091246-20e8-4a56-aa4d-066075b2a7a8" #Get-AzRoleDefinition -Name $RoleToActivate | Select-Object Id
    Open-AzureADMSPrivilegedRoleAssignmentRequest -ProviderId aadroles -Schedule $schedule -ResourceId $TenantID -RoleDefinitionId $RoleID -SubjectId $SubjectId.ObjectId -Type 'UserAdd' -AssignmentState 'Active' -Reason "Auto Activation"
}

ActivatePIM

# Adding this new line to check Jenkins Alert to Microsoft Teams
