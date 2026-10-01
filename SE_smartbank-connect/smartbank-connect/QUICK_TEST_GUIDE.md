# SmartBank Connect - Quick Testing Guide
## Step-by-Step End-to-End Test Scenarios

---

## SETUP REQUIREMENTS

### Prerequisites
- Java 17 or higher
- MySQL 8.0 running on localhost:3306
- Database: `smartbank_connect`
- Username: `root`
- Password: `2002`

### Starting the Application
```bash
cd smartbank-connect
mvn clean install
mvn spring-boot:run
```

The application will start at **http://localhost:8080**

---

## TEST SCENARIO 1: LOGIN & ERROR HANDLING

### Test 1.1: Invalid Credentials
**Steps:**
1. Navigate to http://localhost:8080/login
2. Enter username: `test@invalid.com`
3. Enter password: `WrongPassword123`
4. Click "Log In"

**Expected Result:**
- ✅ Error message displays: "Invalid username/email or password. Please try again."
- ✅ User remains on login page
- ✅ No sensitive information leaked
- ✅ Error is in RED background

---

### Test 1.2: Account Lockout After Failed Attempts
**Steps:**
1. Try logging in with wrong password 5 times
2. Attempt login on 6th try

**Expected Result:**
- ✅ After 5th failed attempt: Account is locked
- ✅ On 6th attempt: Error shows "Account locked due to too many failed login attempts"
- ✅ Cannot login for 30 minutes (even with correct password)
- ✅ Can reset password to unlock via /forgot-password

---

### Test 1.3: Successful Login with OTP
**Steps:**
1. Navigate to http://localhost:8080/login
2. Enter username: `customer@lankatrust.lk`
3. Enter password: `Customer@123`
4. Click "Log In"
5. Check console output for OTP code
6. Enter OTP on /login/otp page
7. Click "Verify & Proceed"

**Expected Result:**
- ✅ Redirected to /login/otp after password entry
- ✅ OTP code visible in console (sandbox mode)
- ✅ Entering correct OTP redirects to customer dashboard
- ✅ Session established for 15 minutes
- ✅ User email and role visible in topbar

---

### Test 1.4: OTP Expiration
**Steps:**
1. Go to login and enter credentials
2. Receive OTP (shown in console)
3. Wait 5 minutes without entering OTP
4. Try to enter OTP after expiration

**Expected Result:**
- ✅ Error message: "OTP expired"
- ✅ "Resend OTP" button available
- ✅ Can request new OTP

---

## TEST SCENARIO 2: CUSTOMER DASHBOARD & ACCOUNTS

### Test 2.1: View Customer Dashboard
**Steps:**
1. Login as `customer@lankatrust.lk` / `Customer@123`
2. Verify OTP
3. Land on /customer/dashboard

**Expected Result:**
- ✅ Dashboard displays customer accounts
- ✅ Shows account balances
- ✅ Shows recent transactions (last 5)
- ✅ Shows loan applications status
- ✅ ATM/debit card information visible
- ✅ Quick action buttons available
- ✅ Sidebar with proper menu items
- ✅ Logo displays correctly (not invisible)

---

### Test 2.2: View Transaction History
**Steps:**
1. On customer dashboard, click "Transactions" or navigate to /history
2. View default transaction list
3. Try filtering by date range
4. Try downloading statement

**Expected Result:**
- ✅ List shows all transactions for customer's accounts
- ✅ Date filter works correctly
- ✅ PDF statement downloads successfully
- ✅ Filename: `statement.pdf`
- ✅ PDF is readable and contains transaction data

---

### Test 2.3: Profile Management
**Steps:**
1. Navigate to /customer/profile
2. Update full name
3. Update phone number
4. Click "Save Profile"

**Expected Result:**
- ✅ Changes saved successfully
- ✅ Success message displayed
- ✅ Changes persist after logout/login
- ✅ Audit log created for update

---

### Test 2.4: Change Password
**Steps:**
1. Navigate to /customer/change-password
2. Enter current password: `Customer@123`
3. Enter new password: `NewPassword456!`
4. Confirm new password: `NewPassword456!`
5. Click "Change Password"

**Expected Result:**
- ✅ Success message displayed
- ✅ New password works on next login
- ✅ Old password no longer works
- ✅ Email notification sent
- ✅ Audit log created

---

## TEST SCENARIO 3: FUND TRANSFER

### Test 3.1: Simple Internal Transfer
**Steps:**
1. Navigate to /transfer
2. Select source account
3. Create new beneficiary (or use existing):
   - Account Number: `LTB000000001` (must exist)
   - Bank: LankaTrust Bank
   - Nickname: Test Account
4. Enter amount: `5000.00`
5. Click "Continue"
6. Enter OTP (shown in console, if transfer > 500000)
7. Confirm transfer

**Expected Result:**
- ✅ Transaction created with PENDING status
- ✅ Balance decremented from source account
- ✅ Beneficiary added to list
- ✅ Email notification sent
- ✅ Transaction appears in history
- ✅ Audit log created

---

### Test 3.2: OTP Required for Large Transfers
**Steps:**
1. Navigate to /transfer
2. Select source account
3. Enter amount: `600000.00` (above LKR 500,000 threshold)
4. Click "Continue"

**Expected Result:**
- ✅ Redirected to OTP verification page
- ✅ OTP code shown in console
- ✅ Must enter OTP to complete transfer
- ✅ Transfer fails if wrong OTP entered
- ✅ Transfer succeeds if correct OTP entered

---

## TEST SCENARIO 4: LOAN APPLICATION

### Test 4.1: Apply for Loan
**Steps:**
1. Navigate to /loans/apply
2. Select loan type: "PERSONAL_LOAN"
3. Enter amount: `500000.00`
4. Enter monthly income: `100000.00`
5. Select employment status: "EMPLOYED"
6. Enter documents summary: "All documents provided"
7. Click "Submit Application"

**Expected Result:**
- ✅ Application created with SUBMITTED status
- ✅ Application number generated
- ✅ Redirected to /loans (my loans)
- ✅ Application visible in list
- ✅ Email notification sent

---

### Test 4.2: View Loan Status
**Steps:**
1. Navigate to /loans
2. View "My Loans" list

**Expected Result:**
- ✅ Shows all customer's loan applications
- ✅ Status shown for each (SUBMITTED, APPROVED, REJECTED, etc.)
- ✅ Amount and type clearly displayed
- ✅ Application date shown

---

## TEST SCENARIO 5: BANK OFFICER FUNCTIONS

### Test 5.1: Login as Officer
**Steps:**
1. Navigate to /logout if already logged in
2. Login as `officer@lankatrust.lk` / `Officer@123`
3. Verify OTP
4. Land on /officer/dashboard

**Expected Result:**
- ✅ Officer dashboard loads
- ✅ Sidebar shows officer menu items
- ✅ No "Fund Transfer" or "My Loans" options for officers
- ✅ No customer dashboard access

---

### Test 5.2: Open New Customer Account
**Steps:**
1. Navigate to /accounts/open
2. Fill form with:
   - Customer ID: `CUST999999`
   - Full Name: `John Doe`
   - Email: `john@example.com`
   - Phone: `0771234567`
   - NIC: `123456789V`
   - DOB: `1990-01-15`
   - Address: `123 Main Street`
   - Account Type: `SAVINGS`
   - Initial Deposit: `10000.00`
   - Branch: `CMB-MAIN`
3. Upload documents (signatures, NIC, proof of address)
4. Click "Submit Account Opening"

**Expected Result:**
- ✅ New customer record created
- ✅ New account created in PENDING_APPROVAL status
- ✅ Account number auto-generated
- ✅ Approval request created
- ✅ Officer sees success message
- ✅ Account appears in /accounts/manage

---

### Test 5.3: View Customer Records
**Steps:**
1. Navigate to /officer/customers
2. Search for existing customer
3. View customer details

**Expected Result:**
- ✅ Search returns matching customers
- ✅ Customer detail page shows all info
- ✅ Shows associated accounts
- ✅ Shows documents
- ✅ Can view/download documents

---

## TEST SCENARIO 6: BANK MANAGER FUNCTIONS

### Test 6.1: Login as Manager
**Steps:**
1. Navigate to /logout if already logged in
2. Login as `manager@lankatrust.lk` / `Manager@123`
3. Verify OTP
4. Land on /manager/dashboard

**Expected Result:**
- ✅ Manager dashboard loads
- ✅ Shows quick statistics
- ✅ Shows pending approvals count
- ✅ Manager has access to all dashboards

---

### Test 6.2: Approve Account Request
**Steps:**
1. Navigate to /approvals
2. Find pending account opening request
3. Click "Approve" button
4. (Optional) Add remarks
5. Confirm approval

**Expected Result:**
- ✅ Account status changes to ACTIVE
- ✅ ATM card auto-generated
- ✅ Customer receives notification
- ✅ Approval request marked as APPROVED
- ✅ Audit log created
- ✅ Success message displayed

---

### Test 6.3: Access Other Dashboards
**Steps:**
1. On manager dashboard, click "View Officer Dashboard"
2. Verify officer dashboard loads
3. Go back to manager dashboard
4. Click "View Customer Dashboard"
5. Verify customer dashboard loads

**Expected Result:**
- ✅ Manager can view all role dashboards
- ✅ No permission errors
- ✅ Can perform all actions available to that role
- ✅ Role hierarchy working correctly

---

## TEST SCENARIO 7: ADMIN & COMPLIANCE

### Test 7.1: Login as Admin
**Steps:**
1. Navigate to /logout if already logged in
2. Login as `admin@lankatrust.lk` / `Admin@123`
3. Verify OTP
4. Land on /admin/dashboard

**Expected Result:**
- ✅ Admin dashboard loads
- ✅ Shows system statistics
- ✅ Navigation to staff management, settings, audit logs

---

### Test 7.2: View Audit Logs
**Steps:**
1. Navigate to /admin/audit-logs
2. View all system actions
3. Download audit logs as PDF or CSV

**Expected Result:**
- ✅ All actions logged with timestamps
- ✅ Actor (user) identified for each action
- ✅ Action type and entity recorded
- ✅ Download in PDF/CSV format
- ✅ Immutable record (no editing)

---

### Test 7.3: Login as Compliance Officer
**Steps:**
1. Navigate to /logout if already logged in
2. Login as `compliance@lankatrust.lk` / `Compliance@123`
3. Verify OTP
4. Land on /compliance/dashboard

**Expected Result:**
- ✅ Compliance dashboard loads
- ✅ Shows KYC verification queue
- ✅ Shows suspicious transactions
- ✅ Can approve/flag KYC status

---

## TEST SCENARIO 8: REPORTS & ANALYTICS

### Test 8.1: Generate Reports
**Steps:**
1. Login as any staff member
2. Navigate to /reports
3. Click "Daily Transactions Report"

**Expected Result:**
- ✅ PDF downloads successfully
- ✅ Contains real data from database
- ✅ Properly formatted
- ✅ Contains headers and footers

---

### Test 8.2: Download CSV Export
**Steps:**
1. Navigate to /reports/transactions/daily/csv

**Expected Result:**
- ✅ CSV file downloads
- ✅ Contains proper headers
- ✅ Data formatted correctly
- ✅ Can open in Excel/Sheets

---

## TEST SCENARIO 9: DEMO FUNCTIONS

### Test 9.1: Demo ATM Withdrawal
**Steps:**
1. Login as customer
2. Navigate to /demo/atm
3. Select account
4. Enter amount: `50000.00`
5. Click "Withdraw"

**Expected Result:**
- ✅ ATM withdrawal successful page shown
- ✅ Reference number generated
- ✅ Transaction in history marked as DEMO
- ✅ Balance reduced
- ✅ Clearly labeled as demo transaction

---

### Test 9.2: Demo Card Payment
**Steps:**
1. Login as customer
2. Navigate to /demo/payment
3. Select account and ATM card
4. Enter merchant name: "DEMO Store"
5. Enter amount: `5000.00`
6. Enter card number and CVV (use card number from DB)
7. Click "Process Payment"

**Expected Result:**
- ✅ Payment successful page shown
- ✅ Balance reduced
- ✅ Transaction created and marked DEMO
- ✅ Email notification sent
- ✅ Clearly labeled as demo transaction

---

## TEST SCENARIO 10: SECURITY TESTS

### Test 10.1: Unauthorized URL Access
**Steps:**
1. Logout or open new incognito window
2. Try to access /customer/dashboard directly
3. Try to access /manager/dashboard directly

**Expected Result:**
- ✅ Redirected to /login
- ✅ No page content visible
- ✅ Session not created

---

### Test 10.2: Role-Based Access Control
**Steps:**
1. Login as customer
2. Try to access /accounts/manage (officer-only page)
3. Try to access /approvals (manager-only page)

**Expected Result:**
- ✅ Redirected to /access-denied page
- ✅ Permission error shown
- ✅ No data leaked

---

### Test 10.3: CSRF Protection
**Steps:**
1. Login to application
2. Open developer console (F12)
3. Try to POST a form without CSRF token
4. Try to POST a form with correct CSRF token

**Expected Result:**
- ✅ POST without CSRF fails with 403
- ✅ POST with CSRF succeeds
- ✅ CSRF protection working

---

## TEST SCENARIO 11: CSS & UI VALIDATION

### Test 11.1: Check All Page Styling
**Steps:**
1. Check /login - properly styled
2. Check /register - properly styled
3. Check /customer/dashboard - logo visible (blue #1814F3)
4. Check /officer/dashboard - logo visible
5. Check /manager/dashboard - logo visible
6. Check responsive design on mobile (F12 > Device Toolbar)

**Expected Result:**
- ✅ All CSS files load (no 404 errors)
- ✅ Logos visible with correct color
- ✅ Proper spacing and alignment
- ✅ Responsive on mobile devices
- ✅ No console CSS errors

---

### Test 11.2: Bootstrap Components
**Steps:**
1. Check alert messages (red for errors, green for success)
2. Check buttons (primary, outline, gold colors)
3. Check tables (proper styling)
4. Check forms (proper input styling)
5. Check navbar/topbar

**Expected Result:**
- ✅ All colors applied correctly
- ✅ No broken layouts
- ✅ Professional appearance
- ✅ Consistent across pages

---

## TEST SCENARIO 12: NOTIFICATION TESTING

### Test 12.1: In-App Notifications
**Steps:**
1. Perform actions that generate notifications (transfer, loan, etc.)
2. Navigate to /notifications
3. View notification inbox

**Expected Result:**
- ✅ Notifications appear in list
- ✅ Unread count shown in topbar
- ✅ Can mark as read
- ✅ Timestamp displayed

---

### Test 12.2: Email Notifications
**Steps:**
1. Check Gmail inbox (charukashehanrs@gmail.com)
2. Perform action that sends email
3. Check for email receipt

**Expected Result:**
- ✅ Email arrives (check spam folder if needed)
- ✅ Email content is readable
- ✅ Contains relevant information
- ✅ Professional formatting

---

## FINAL CHECKLIST

After completing all tests, verify:
- ✅ All login flows work with proper error handling
- ✅ All dashboards load without errors
- ✅ All CRUD operations work correctly
- ✅ Approval workflows function properly
- ✅ Role-based access is enforced
- ✅ CSS and styling is consistent
- ✅ Static resources load correctly
- ✅ No 500 errors occur
- ✅ No 404 errors for implemented pages
- ✅ Audit logs all actions
- ✅ Notifications are sent
- ✅ Reports generate and download correctly
- ✅ Demo functions work as expected
- ✅ Security controls prevent unauthorized access

---

## TROUBLESHOOTING

### Issue: Database Connection Failed
**Solution:**
- Check MySQL is running: `mysql -u root -p2002 smartbank_connect`
- Verify connection string in application.properties
- Ensure database exists

### Issue: OTP Not Showing in Console
**Solution:**
- Check console output (should say "[DEVELOPER/SANDBOX FALLBACK]")
- Enable DEBUG logging for mail service

### Issue: Pages Return 404
**Solution:**
- Verify JSP files exist in /WEB-INF/views
- Check view resolver configuration
- Check servlet mapping

### Issue: Styling Not Applied
**Solution:**
- Clear browser cache (Ctrl+Shift+Delete)
- Check CSS file paths in network tab (F12)
- Verify static resource mapping in application.properties

---

**Happy Testing! 🚀**

