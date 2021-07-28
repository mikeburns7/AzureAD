$data = @()
$filename = Read-Host "Enter File Name without extension"
$groupdescription = Read-Host "Enter a description for the group you are about to create
New-AzureADGroup -DisplayName $filename -MailEnabled $false -SecurityEnabled $true -Description $groupdescription -MailNickName "NotSet"

Start-Sleep -s 30
$groupObjectID = (Get-AzureADGroup -SearchString $filename).ObjectID

#$filename = Read-Host "Enter File Name without extension"

$csv = Import-Csv .\import\$filename.csv

$csv | ForEach-Object {
    $row = New-Object PSObject
    $email = $_.email
    $ObjectId = (Get-AzureADUser -SearchString $_.email).ObjectId
    Try{
        If ($ObjectId -ne $null) {
            Add-AzureADGroupMember -ObjectId $groupObjectID -RefObjectId $ObjectId
            $row | Add-Member -MemberType NoteProperty -Name "emailaddress" -Value $email
            $row | Add-Member -MemberType NoteProperty -Name "AADUPN" -Value (Get-AzureADUser -ObjectID $ObjectId).UserPrincipalName
            $row | Add-Member -MemberType NoteProperty -Name "ImportResult" -Value "Success"
    } else {
        #write-host "Error: " $email " - Username not found"
        $row | Add-Member -MemberType NoteProperty -Name "emailaddress" -Value $email
        $row | Add-Member -MemberType NoteProperty -Name "AADUPN" -Value ""
        $row | Add-Member -MemberType NoteProperty -Name "ImportResult" -Value "Username not found"
        
    }
}
    Catch{
        #write-host "Error: " $email " - " $_.Exception.ErrorContent.message.Value
        $row | Add-Member -MemberType NoteProperty -Name "emailaddress" -Value $email
        $row | Add-Member -MemberType NoteProperty -Name "AADUPN" -Value (Get-AzureADUser -ObjectID $ObjectId).UserPrincipalName
        $row | Add-Member -MemberType NoteProperty -Name "ImportResult" -Value $_.Exception.ErrorContent.message.Value
        
    }

    $data += $row
}
$data | Export-Csv .\logs\$filename.csv -NoTypeInformation
