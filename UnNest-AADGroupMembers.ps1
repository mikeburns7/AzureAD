$TopLevelGroup = Read-Host "Enter DisplayName of Top level group"
$TLGObjectID = (Get-AzureADGroup -Filter "DisplayName eq '${TopLevelGroup}'").ObjectID
$ChildGroups = (Get-AzureADGroupMember -ObjectId $TLGObjectID -all $true | Where-Object {($_.ObjectType -like "Group")}).ObjectID

foreach($ChildGroup in $ChildGroups){
    $ChildGroupMembers = (Get-AzureADGroupMember -ObjectId $ChildGroup -all $true | Where-Object {($_.ObjectType -like "User")}).ObjectID
    foreach($member in $ChildGroupMembers){
        Add-AzureADGroupMember -ObjectId $TLGObjectID -RefObjectId $member
    }
}
