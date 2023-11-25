$csv = import-csv "c:\users\mike.burns\immbeyondL.csv"

foreach ($user in $csv){
    $username = $user.UserPrincipalName
    Invoke-MgGraphRequest -Method PATCH -uri "https://graph.microsoft.com/beta/users/$username" -Body @{OnPremisesImmutableId = $null}
}
