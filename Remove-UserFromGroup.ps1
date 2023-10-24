
#filter users based on given identity attribute
$users = Get-MgUser -Filter "[ENTER ATTRIBUTE NAME] eq '[ENTER ATTRIBUTE VALUE]'" -All

foreach ($user in $users){
    
    try {
        Remove-MgGroupMemberByRef -GroupId "[ENTER IN GROUP GUID]" -DirectoryObjectId $user.Id -ErrorAction SilentlyContinue -ErrorVariable $MyError
        
        $json = @{
            "user" = $user.UserPrincipalName
            "opertion" = "Remove User From Group"
            "group" = "[ENTER GROUP DISPLAY NAME]"
            "time" = $currentUTCtime
        }
    }
    catch {
        $json = @{
            "user" = $user.UserPrincipalName
            "opertion" = "ERROR: $($MyError)"
            "group" = "[ENTER GROUP DISPLAY NAME]"
            "time" = $currentUTCtime
        }
    }
    
    $jsonString = ConvertTo-Json -InputObject $json

    write-host $jsonString
}
