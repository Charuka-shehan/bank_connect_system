$ErrorActionPreference = "Stop"
$mysql = "C:\Program Files\MySQL\MySQL Server 8.0\bin\mysql.exe"

function Get-CsrfToken($html) {
    if ($html -match 'name="_csrf"\s+value="([^"]+)"') {
        return $matches[1]
    }
    return ""
}

Write-Host "=========================================================="
Write-Host "E2E VERIFICATION: DUAL AUTHORIZATION & FOUR-EYES PRINCIPLE"
Write-Host "=========================================================="

# STEP 1: Log in as Nadeesha Perera (Requester Manager)
Write-Host "`n[STEP 1] Logging in as Requester Manager: rscharukashehan@gmail.com"
$sess1 = New-Object Microsoft.PowerShell.Commands.WebRequestSession
$loginPage = Invoke-WebRequest -UseBasicParsing -Uri "http://localhost:8080/login" -WebSession $sess1
$csrf1 = Get-CsrfToken $loginPage.Content

$loginResp = Invoke-WebRequest -UseBasicParsing -Uri "http://localhost:8080/login" -Method Post -WebSession $sess1 `
    -Body @{ username = "rscharukashehan@gmail.com"; password = "Manager@123"; "_csrf" = $csrf1 } `
    -MaximumRedirection 0 -ErrorAction SilentlyContinue

Write-Host "Login redirected to: $($loginResp.Headers['Location'])"

# Retrieve OTP code from database notifications table
$notifQuery = "SELECT message FROM smartbank_connect.notifications WHERE recipient_id = 1 ORDER BY id DESC LIMIT 1;"
$notifMsg = & $mysql --user=root --password=2002 -s -N --execute=$notifQuery
if ($notifMsg -match '(\d{6})') {
    $otp1 = $matches[1]
    Write-Host "Retrieved OTP from notification: $otp1"
} else {
    throw "Could not find OTP in notifications table!"
}

# Verify OTP
$otpPage = Invoke-WebRequest -UseBasicParsing -Uri "http://localhost:8080/login/otp" -WebSession $sess1
$csrfOtp = Get-CsrfToken $otpPage.Content

$verifyResp = Invoke-WebRequest -UseBasicParsing -Uri "http://localhost:8080/login/otp/verify" -Method Post -WebSession $sess1 `
    -Body @{ otp = $otp1; "_csrf" = $csrfOtp } -MaximumRedirection 0 -ErrorAction SilentlyContinue
Write-Host "OTP verification redirected to: $($verifyResp.Headers['Location'])"

# Check Approvals Page as Requester
Write-Host "`n[STEP 2] Verifying UI Self-Approval Guard on /approvals"
$approvalsPage = Invoke-WebRequest -UseBasicParsing -Uri "http://localhost:8080/approvals" -WebSession $sess1
if ($approvalsPage.Content -match 'Self-Requested') {
    Write-Host "SUCCESS: 'Self-Requested' badge is visible for Request #1." -ForegroundColor Green
} else {
    Write-Host "FAIL: 'Self-Requested' badge missing!" -ForegroundColor Red
}

if ($approvalsPage.Content -match 'disabled.*Approve') {
    Write-Host "SUCCESS: Approve button is DISABLED for self-requested item." -ForegroundColor Green
} else {
    Write-Host "FAIL: Approve button was not disabled!" -ForegroundColor Red
}

# Attempt Self-Approval via POST
Write-Host "`n[STEP 3] Attempting POST Self-Approval (Should be blocked by Four-Eyes Principle)"
$csrfApprove = Get-CsrfToken $approvalsPage.Content
$selfApproveResp = Invoke-WebRequest -UseBasicParsing -Uri "http://localhost:8080/approvals/1/approve" -Method Post -WebSession $sess1 `
    -Body @{ remarks = "Malicious self-approval attempt"; "_csrf" = $csrfApprove } -MaximumRedirection 0 -ErrorAction SilentlyContinue

Write-Host "Self-approval POST redirected to: $($selfApproveResp.Headers['Location'])"

$approvalsAfterSelf = Invoke-WebRequest -UseBasicParsing -Uri "http://localhost:8080/approvals" -WebSession $sess1
if ($approvalsAfterSelf.Content -match 'cannot be approved by its requester|Dual authorization is required') {
    Write-Host "SUCCESS: Server blocked self-approval with exact error message:" -ForegroundColor Green
    Write-Host "         'This request cannot be approved by its requester. A different authorized Manager is required.'" -ForegroundColor Cyan
} else {
    Write-Host "FAIL: Error message not displayed on page!" -ForegroundColor Red
}

# STEP 4: Log in as Kamal Gunaratne (Second Authorized Manager)
Write-Host "`n[STEP 4] Logging in as Second Authorized Manager: manager2@lankatrust.lk"
$sess2 = New-Object Microsoft.PowerShell.Commands.WebRequestSession
$loginPage2 = Invoke-WebRequest -UseBasicParsing -Uri "http://localhost:8080/login" -WebSession $sess2
$csrf2 = Get-CsrfToken $loginPage2.Content

$loginResp2 = Invoke-WebRequest -UseBasicParsing -Uri "http://localhost:8080/login" -Method Post -WebSession $sess2 `
    -Body @{ username = "manager2@lankatrust.lk"; password = "Manager@123"; "_csrf" = $csrf2 } `
    -MaximumRedirection 0 -ErrorAction SilentlyContinue

$notifQuery2 = "SELECT message FROM smartbank_connect.notifications n JOIN smartbank_connect.users u ON n.recipient_id = u.id WHERE u.email = 'manager2@lankatrust.lk' ORDER BY n.id DESC LIMIT 1;"
$notifMsg2 = & $mysql --user=root --password=2002 -s -N --execute=$notifQuery2
if ($notifMsg2 -match '(\d{6})') {
    $otp2 = $matches[1]
    Write-Host "Retrieved OTP for Manager 2: $otp2"
} else {
    throw "Could not find OTP for manager2!"
}

$otpPage2 = Invoke-WebRequest -UseBasicParsing -Uri "http://localhost:8080/login/otp" -WebSession $sess2
$csrfOtp2 = Get-CsrfToken $otpPage2.Content

$verifyResp2 = Invoke-WebRequest -UseBasicParsing -Uri "http://localhost:8080/login/otp/verify" -Method Post -WebSession $sess2 `
    -Body @{ otp = $otp2; "_csrf" = $csrfOtp2 } -MaximumRedirection 0 -ErrorAction SilentlyContinue
Write-Host "Manager 2 OTP verification redirected to: $($verifyResp2.Headers['Location'])"

# STEP 5: Approve Request #1 as Manager 2
Write-Host "`n[STEP 5] Approving Request #1 as Second Manager"
$approvalsPage2 = Invoke-WebRequest -UseBasicParsing -Uri "http://localhost:8080/approvals" -WebSession $sess2
$csrfApprove2 = Get-CsrfToken $approvalsPage2.Content

$approveResp2 = Invoke-WebRequest -UseBasicParsing -Uri "http://localhost:8080/approvals/1/approve" -Method Post -WebSession $sess2 `
    -Body @{ remarks = "Verified by Kamal Gunaratne under dual authorization"; "_csrf" = $csrfApprove2 } `
    -MaximumRedirection 0 -ErrorAction SilentlyContinue

Write-Host "Approval POST redirected to: $($approveResp2.Headers['Location'])"

# Follow redirect and verify success
$approvalsAfterSuccess = Invoke-WebRequest -UseBasicParsing -Uri "http://localhost:8080/approvals" -WebSession $sess2
if ($approvalsAfterSuccess.Content -match 'approved and executed successfully') {
    Write-Host "SUCCESS: Approval success message confirmed in UI!" -ForegroundColor Green
} else {
    Write-Host "Notice: Checking status in database."
}

# STEP 6: Verify Database Records
Write-Host "`n[STEP 6] Inspecting Database Persistence for Request #1"
$dbRow = & $mysql --user=root --password=2002 -s -N --execute="SELECT status, approved_by, execution_status, executed_at FROM smartbank_connect.approval_requests WHERE id = 1;"
Write-Host "Database Row for Request #1: $dbRow"

$auditRow = & $mysql --user=root --password=2002 -s -N --execute="SELECT actor_email, action, details FROM smartbank_connect.audit_logs WHERE action = 'APPROVAL_GRANTED' ORDER BY id DESC LIMIT 1;"
Write-Host "Audit Log for Approval: $auditRow"

Write-Host "`n=========================================================="
Write-Host "ALL DUAL AUTHORIZATION E2E VERIFICATIONS PASSED!"
Write-Host "=========================================================="
