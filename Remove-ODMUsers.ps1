#Get the ODMAPI module from Quest Support
Import-Module .\ODMAPI

#Use your credentials
Connect-OdmService
Select-OdmOrganization -OrganizationId XXXXXXXXXXXXXXXXXXXXXXXX
Select-OdmProject 'XXXXXXXXXXXXXXXXXXXXXXX-XX'

#FInd all collections
$collections = Get-OdmCollection -ResultSize 100


#define wave to find
$wave = "Wave 1"

$UsersToRemove = @(
"user1@example.com",
"user2@example.com"
)

$Users = @()
foreach($collection in $collections){
    if($collection.name.contains($wave)){
        $Users += Get-OdmObject -FilterObject $collection
    }
}

foreach($user in $users){
    if($User.SourceUserPrincipalName -in $UsersToRemove){
        write-host "Removing "$user.SourceUserPrincipalName -ForegroundColor Green
        foreach($collection in $collections){
            if($collection.name.contains($wave)){
                Remove-OdmObject -From $collection -Objects $user
            }
        }
    }
}
