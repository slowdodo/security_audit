# Check for common security vulnerabilities

# Check for weak passwords
Write-Output "Checking for weak passwords..."
$users = Get-CimInstance -ClassName Win32_UserAccount
foreach ($user in $users) {
    if ($user.Name -ne "Administrator") {
        $password = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR
    }
}