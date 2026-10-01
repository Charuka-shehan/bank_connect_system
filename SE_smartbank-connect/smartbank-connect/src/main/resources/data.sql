-- SmartBank Connect - Sample Seed Data
SET FOREIGN_KEY_CHECKS = 0;

-- Clean existing data from all tables
DELETE FROM communication_logs;
DELETE FROM support_tickets;
DELETE FROM app_meta;
DELETE FROM audit_logs;
DELETE FROM staff_creation_requests;
DELETE FROM approval_requests;
DELETE FROM notification_preferences;
DELETE FROM notification_templates;
DELETE FROM notifications;
DELETE FROM otp_codes;
DELETE FROM otp_verifications;
DELETE FROM password_reset_tokens;
DELETE FROM user_roles;
DELETE FROM roles;
DELETE FROM loan_documents;
DELETE FROM loans;
DELETE FROM loan_applications;
DELETE FROM reports;
DELETE FROM statement_requests;
DELETE FROM transaction_corrections;
DELETE FROM transactions;
DELETE FROM transfers;
DELETE FROM beneficiaries;
DELETE FROM customer_documents;
DELETE FROM atm_cards;
DELETE FROM accounts;
DELETE FROM officers;
DELETE FROM customers;
DELETE FROM users;
DELETE FROM branches;

-- ---------- Sample data (INSERT) ----------

-- Data for: branches
INSERT INTO branches (id, code, name, address) VALUES
(1,'CMB-MAIN','Colombo Main Branch','12 Galle Road, Colombo 03'),
(2,'KDY-BR','Kandy Branch','45 Peradeniya Road, Kandy'),
(3,'GLE-BR','Galle Branch','8 Main Street, Galle Fort'),
(4,'JAF-BR','Jaffna Branch','21 Hospital Road, Jaffna'),
(5,'KUR-BR','Kurunegala Branch','33 Colombo Road, Kurunegala');

-- Data for: users
INSERT INTO users (id, full_name, email, password, phone_number, nic, role, enabled, google_linked, failed_login_attempts, last_login) VALUES
(1,'Nimal Perera','nimal.perera@lankatrust.lk','$2a$10$DEMOHASHDEMOHASHDEMOHASHDEMOHASHDEMOHASHDEMOHASHDEMOa','0771000001','198012345678','BANK_MANAGER',TRUE,FALSE,0,'2026-09-20 08:15:00'),
(2,'Kasun Silva','kasun.silva@lankatrust.lk','$2a$10$DEMOHASHDEMOHASHDEMOHASHDEMOHASHDEMOHASHDEMOHASHDEMOb','0771000002','199023456789','BANK_OFFICER',TRUE,FALSE,0,'2026-09-21 09:00:00'),
(3,'Dilani Fernando','dilani.fernando@lankatrust.lk','$2a$10$DEMOHASHDEMOHASHDEMOHASHDEMOHASHDEMOHASHDEMOHASHDEMOc','0771000003','199234567890','BANK_OFFICER',TRUE,FALSE,0,'2026-09-21 09:30:00'),
(4,'Sanduni Jayasinghe','sanduni.j@lankatrust.lk','$2a$10$DEMOHASHDEMOHASHDEMOHASHDEMOHASHDEMOHASHDEMOHASHDEMOd','0771000004','198845678901','COMPLIANCE_OFFICER',TRUE,FALSE,0,'2026-09-19 10:10:00'),
(5,'Ruwan Bandara','ruwan.bandara@lankatrust.lk','$2a$10$DEMOHASHDEMOHASHDEMOHASHDEMOHASHDEMOHASHDEMOHASHDEMOe','0771000005','198556789012','SYSTEM_ADMINISTRATOR',TRUE,FALSE,0,'2026-09-22 07:45:00'),
(6,'Amal Wickramasinghe','amal.w@gmail.com','$2a$10$DEMOHASHDEMOHASHDEMOHASHDEMOHASHDEMOHASHDEMOHASHDEMOf','0712000001','199567890123','CUSTOMER',TRUE,FALSE,0,'2026-09-23 18:20:00'),
(7,'Nadeesha Rathnayake','nadeesha.r@gmail.com','$2a$10$DEMOHASHDEMOHASHDEMOHASHDEMOHASHDEMOHASHDEMOHASHDEMOg','0712000002','199678901234','CUSTOMER',TRUE,TRUE,0,'2026-09-24 12:05:00'),
(8,'Tharindu Gunawardena','tharindu.g@gmail.com','$2a$10$DEMOHASHDEMOHASHDEMOHASHDEMOHASHDEMOHASHDEMOHASHDEMOh','0712000003','199389012345','CUSTOMER',TRUE,FALSE,1,'2026-09-22 20:40:00'),
(9,'Ishara Herath','ishara.h@gmail.com','$2a$10$DEMOHASHDEMOHASHDEMOHASHDEMOHASHDEMOHASHDEMOHASHDEMOi','0712000004','200090123456','CUSTOMER',TRUE,FALSE,0,'2026-09-18 15:30:00'),
(10,'Chamara Dissanayake','chamara.d@gmail.com','$2a$10$DEMOHASHDEMOHASHDEMOHASHDEMOHASHDEMOHASHDEMOHASHDEMOj','0712000005','198701234567','CUSTOMER',TRUE,FALSE,0,'2026-09-24 09:50:00');

-- Data for: customers
INSERT INTO customers (id, customer_id, dob, address, kyc_status, profile_photo_path, branch_id) VALUES
(6,'CUST100001','1995-03-14','25 Temple Road, Nugegoda','APPROVED','/uploads/photos/c6.jpg',1),
(7,'CUST100002','1996-07-22','14 Lake Drive, Kandy','APPROVED','/uploads/photos/c7.jpg',2),
(8,'CUST100003','1993-11-05','9 Beach Road, Galle','APPROVED',NULL,3),
(9,'CUST100004','2000-01-30','77 Kandy Road, Jaffna','PENDING',NULL,4),
(10,'CUST100005','1987-09-18','5 Station Road, Kurunegala','APPROVED','/uploads/photos/c10.jpg',5);

-- Data for: officers
INSERT INTO officers (id, employee_id, branch) VALUES
(1,'EMP1001','CMB-MAIN'),
(2,'EMP1002','CMB-MAIN'),
(3,'EMP1003','KDY-BR'),
(4,'EMP1004','CMB-MAIN'),
(5,'EMP1005','CMB-MAIN');

-- Data for: accounts
INSERT INTO accounts (id, account_number, customer_id, account_type, balance, initial_deposit, status, branch_id, occupation, monthly_income, nominee_name, nominee_relationship, submitted_by, approved_by, created_at) VALUES
(1,'LTB012345678',6,'SAVINGS',150000.00,100000.00,'ACTIVE',1,'Software Engineer',220000.00,'Kamala Wickramasinghe','Mother',2,1,'2026-01-10 10:00:00'),
(2,'LTB012345679',7,'CURRENT',275000.00,200000.00,'ACTIVE',2,'Business Owner',450000.00,'Sunil Rathnayake','Father',3,1,'2026-02-05 11:30:00'),
(3,'LTB012345680',8,'SAVINGS',45000.00,25000.00,'ACTIVE',3,'Teacher',95000.00,'Menaka Gunawardena','Spouse',3,1,'2026-03-12 09:15:00'),
(4,'LTB012345681',9,'FIXED_DEPOSIT',500000.00,500000.00,'ACTIVE',4,'Doctor',600000.00,'Anura Herath','Father',2,1,'2026-04-01 14:00:00'),
(5,'LTB012345682',10,'SAVINGS',82000.00,50000.00,'ACTIVE',5,'Accountant',150000.00,'Kumari Dissanayake','Spouse',2,1,'2026-05-20 10:45:00'),
(6,'LTB012345683',6,'SAVINGS',0.00,20000.00,'PENDING_APPROVAL',1,'Software Engineer',220000.00,'Kamala Wickramasinghe','Mother',2,NULL,'2026-09-20 16:00:00');

-- Data for: atm_cards
INSERT INTO atm_cards (id, account_id, card_number, cvv_hash, expiry_date, status) VALUES
(1,1,'4111000000000001','$2a$10$DEMOCVVHASH000000000000000000000000000000000000001','2030-01-31','ACTIVE'),
(2,2,'4111000000000002','$2a$10$DEMOCVVHASH000000000000000000000000000000000000002','2030-02-28','ACTIVE'),
(3,3,'4111000000000003','$2a$10$DEMOCVVHASH000000000000000000000000000000000000003','2030-03-31','BLOCKED'),
(4,4,'4111000000000004','$2a$10$DEMOCVVHASH000000000000000000000000000000000000004','2030-04-30','ACTIVE'),
(5,5,'4111000000000005','$2a$10$DEMOCVVHASH000000000000000000000000000000000000005','2030-05-31','ACTIVE');

-- Data for: customer_documents
INSERT INTO customer_documents (id, customer_id, document_type, file_name, file_path, verified, verified_by, verified_at) VALUES
(1,6,'NIC','nic_amal.pdf','/uploads/kyc/6_nic.pdf',TRUE,4,'2026-01-09 15:00:00'),
(2,7,'NIC','nic_nadeesha.pdf','/uploads/kyc/7_nic.pdf',TRUE,4,'2026-02-04 12:00:00'),
(3,8,'ADDRESS_PROOF','bill_tharindu.pdf','/uploads/kyc/8_addr.pdf',TRUE,4,'2026-03-11 10:30:00'),
(4,9,'NIC','nic_ishara.pdf','/uploads/kyc/9_nic.pdf',FALSE,NULL,NULL),
(5,10,'ADDRESS_PROOF','bill_chamara.pdf','/uploads/kyc/10_addr.pdf',TRUE,4,'2026-05-19 14:20:00');

-- Data for: beneficiaries
INSERT INTO beneficiaries (id, user_id, beneficiary_name, beneficiary_account_number, beneficiary_bank, nickname) VALUES
(1,6,'Nadeesha Rathnayake','LTB012345679',NULL,'Nadee'),
(2,6,'Kamala Wickramasinghe','8001234567','Bank of Ceylon','Amma'),
(3,7,'Amal Wickramasinghe','LTB012345678',NULL,'Amal'),
(4,8,'Chamara Dissanayake','LTB012345682',NULL,'Chamara'),
(5,10,'Ishara Herath','LTB012345681',NULL,'Ishara');

-- Data for: transfers
INSERT INTO transfers (id, reference_number, from_account_id, to_account_number, to_account_bank, to_user_id, amount, status, requested_by, requested_at, approved_by, approved_at, high_value, daily_limit_exceeded) VALUES
(1,'TRF20260901001',1,'LTB012345679',NULL,7,25000.00,'COMPLETED',6,'2026-09-01 10:00:00',NULL,NULL,FALSE,FALSE),
(2,'TRF20260905002',2,'LTB012345678',NULL,6,150000.00,'COMPLETED',7,'2026-09-05 14:30:00',1,'2026-09-05 14:45:00',TRUE,FALSE),
(3,'TRF20260910003',3,'LTB012345682',NULL,10,5000.00,'COMPLETED',8,'2026-09-10 09:10:00',NULL,NULL,FALSE,FALSE),
(4,'TRF20260915004',5,'8001234567','Bank of Ceylon',NULL,12000.00,'CANCELLED',10,'2026-09-15 16:20:00',NULL,NULL,FALSE,FALSE),
(5,'TRF20260918005',1,'LTB012345681',NULL,9,60000.00,'OTP_PENDING',6,'2026-09-18 11:00:00',NULL,NULL,TRUE,FALSE);
UPDATE transfers SET cancelled_by=10, cancelled_at='2026-09-15 16:25:00' WHERE id=4;

-- Data for: transactions
INSERT INTO transactions (id, reference_number, source_account_id, destination_account_id, beneficiary_name, amount, type, status, remarks, otp_verified, created_at, processed_at) VALUES
(1,'TXN20260901001',1,2,'Nadeesha Rathnayake',25000.00,'TRANSFER','COMPLETED','Rent share',FALSE,'2026-09-01 10:00:00','2026-09-01 10:00:05'),
(2,'TXN20260905002',2,1,'Amal Wickramasinghe',150000.00,'TRANSFER','COMPLETED','Vehicle down payment',TRUE,'2026-09-05 14:30:00','2026-09-05 14:46:00'),
(3,'TXN20260910003',3,5,'Chamara Dissanayake',5000.00,'TRANSFER','COMPLETED','Loan repayment',FALSE,'2026-09-10 09:10:00','2026-09-10 09:10:04'),
(4,'TXN20260912004',4,NULL,NULL,10000.00,'WITHDRAWAL','COMPLETED','ATM withdrawal',FALSE,'2026-09-12 13:00:00','2026-09-12 13:00:02'),
(5,'TXN20260914005',5,NULL,'Keells Super',8500.00,'PAYMENT','COMPLETED','Card payment',FALSE,'2026-09-14 18:45:00','2026-09-14 18:45:03'),
(6,'TXN20260915006',5,NULL,'Kamala Wickramasinghe',12000.00,'TRANSFER','CANCELLED','Cancelled by customer',FALSE,'2026-09-15 16:20:00',NULL);

-- Data for: transaction_corrections
INSERT INTO transaction_corrections (id, transaction_id, requested_by, proposed_remarks, proposed_amount, reason, status, approved_by, processed_at) VALUES
(1,1,2,'Rent share - September',NULL,'Remark typo','APPROVED',1,'2026-09-02 09:00:00'),
(2,3,3,NULL,5500.00,'Amount keyed incorrectly','PENDING',NULL,NULL),
(3,4,2,'ATM withdrawal - Galle',NULL,'Missing location','APPROVED',1,'2026-09-13 10:00:00'),
(4,5,3,NULL,8000.00,'Merchant refund adjustment','REJECTED',1,'2026-09-15 11:00:00'),
(5,2,2,'Vehicle deposit',NULL,'Clarify purpose','PENDING',NULL,NULL);

-- Data for: statement_requests
INSERT INTO statement_requests (id, customer_id, account_id, period_from, period_to, status, handled_by, completed_at) VALUES
(1,6,1,'2026-08-01','2026-08-31','DOWNLOADED',2,'2026-09-02 10:30:00'),
(2,7,2,'2026-07-01','2026-09-01','GENERATED',3,'2026-09-03 12:00:00'),
(3,8,3,'2026-09-01','2026-09-15','PENDING',NULL,NULL),
(4,9,4,'2026-01-01','2026-06-30','GENERATED',2,'2026-07-05 09:00:00'),
(5,10,5,'2026-08-01','2026-09-15','PENDING',NULL,NULL);

-- Data for: reports
INSERT INTO reports (id, name, type, params, generated_by, file_path, status) VALUES
(1,'August Transaction Summary','TRANSACTION_SUMMARY','{"month":"2026-08"}',1,'/reports/aug_txn.pdf','PUBLISHED'),
(2,'Loan Pipeline Report','LOAN_PIPELINE','{"status":"ALL"}',1,'/reports/loan_pipe.pdf','PUBLISHED'),
(3,'KYC Pending List','KYC_PENDING','{"branch":"JAF-BR"}',4,NULL,'DRAFT'),
(4,'Daily Audit Extract','AUDIT_EXTRACT','{"date":"2026-09-20"}',5,'/reports/audit_0920.pdf','PUBLISHED'),
(5,'Branch Balances','BRANCH_BALANCE','{"branch":"ALL"}',1,NULL,'FAILED');

-- Data for: loans
INSERT INTO loans (id, application_number, customer_id, loan_type, requested_amount, purpose, term_months, monthly_income, employment_status, status, submitted_at, verified_by, verified_at, approved_by, approved_at, remarks) VALUES
(1,'LN20260801001',6,'VEHICLE',2500000.00,'Purchase of a car',60,220000.00,'Permanent','APPROVED','2026-08-01 10:00:00',2,'2026-08-03 11:00:00',1,'2026-08-10 15:00:00','Approved'),
(2,'LN20260815002',7,'PERSONAL',500000.00,'Business expansion',24,450000.00,'Self-employed','UNDER_VERIFICATION','2026-08-15 12:00:00',3,'2026-08-17 09:30:00',NULL,NULL,'Awaiting bank statements'),
(3,'LN20260820003',8,'EDUCATION',800000.00,'Masters degree fees',36,95000.00,'Permanent','REJECTED','2026-08-20 14:00:00',2,'2026-08-22 10:00:00',1,'2026-08-28 16:00:00','Income too low for amount'),
(4,'LN20260901004',9,'HOME',7500000.00,'Purchase of house',180,600000.00,'Permanent','COMPLIANCE_CHECK','2026-09-01 09:00:00',2,'2026-09-03 13:00:00',NULL,NULL,'Compliance review'),
(5,'LN20260910005',10,'PERSONAL',300000.00,'Medical expenses',12,150000.00,'Permanent','SUBMITTED','2026-09-10 17:30:00',NULL,NULL,NULL,NULL,NULL);

-- Data for: loan_documents
INSERT INTO loan_documents (id, loan_application_id, file_name, file_path, uploaded_by) VALUES
(1,1,'salary_slip_amal.pdf','/uploads/loans/1_salary.pdf',6),
(2,2,'bank_statement_nadeesha.pdf','/uploads/loans/2_stmt.pdf',7),
(3,3,'admission_letter.pdf','/uploads/loans/3_admit.pdf',8),
(4,4,'land_deed_ishara.pdf','/uploads/loans/4_deed.pdf',9),
(5,5,'medical_estimate.pdf','/uploads/loans/5_med.pdf',10);

-- Data for: roles
INSERT INTO roles (id, name, description) VALUES
(1,'CUSTOMER','Retail banking customer'),
(2,'BANK_OFFICER','Branch officer who submits requests'),
(3,'BANK_MANAGER','Approves requests (Four-Eyes principle)'),
(4,'SYSTEM_ADMINISTRATOR','Manages system configuration and users'),
(5,'COMPLIANCE_OFFICER','Performs KYC and loan compliance checks'),
(6,'CUSTOMER_RELATIONS_EXECUTIVE','Handles support tickets and communication');

-- Data for: user_roles
INSERT INTO user_roles (user_id, role_id) VALUES
(1,3),(2,2),(3,2),(4,5),(5,4),(6,1),(7,1),(8,1),(9,1),(10,1),(3,6);

-- Data for: password_reset_tokens
INSERT INTO password_reset_tokens (id, user_id, token, expires_at, used, created_at) VALUES
(1,6,'tok-6a1f9c2e-0001','2026-08-01 11:00:00',TRUE,'2026-08-01 10:00:00'),
(2,7,'tok-7b2e8d3f-0002','2026-09-10 13:00:00',TRUE,'2026-09-10 12:00:00'),
(3,8,'tok-8c3d7e4a-0003','2026-09-22 21:00:00',FALSE,'2026-09-22 20:00:00'),
(4,9,'tok-9d4c6f5b-0004','2026-09-01 10:00:00',FALSE,'2026-08-31 10:00:00'),
(5,2,'tok-2e5b5a6c-0005','2026-09-23 12:00:00',TRUE,'2026-09-23 11:00:00');

-- Data for: otp_codes
INSERT INTO otp_codes (id, user_id, transfer_id, code, purpose, expires_at, attempts, consumed, created_at) VALUES
(1,7,2,'482910','TRANSFER_CONFIRMATION','2026-09-05 14:40:00',0,TRUE,'2026-09-05 14:35:00'),
(2,6,5,'918234','TRANSFER_CONFIRMATION','2026-09-18 11:05:00',1,FALSE,'2026-09-18 11:00:00'),
(3,6,NULL,'553190','LOGIN_STEPUP','2026-09-23 18:25:00',0,TRUE,'2026-09-23 18:20:00'),
(4,8,NULL,'104829','LOGIN_STEPUP','2026-09-22 20:45:00',3,FALSE,'2026-09-22 20:40:00'),
(5,10,NULL,'773912','LOGIN_STEPUP','2026-09-24 09:55:00',0,TRUE,'2026-09-24 09:50:00');

-- Data for: notifications
INSERT INTO notifications (id, recipient_id, title, message, channel, is_read, created_at) VALUES
(1,6,'Transfer completed','LKR 25,000.00 transferred to Nadeesha Rathnayake.','IN_APP',TRUE,'2026-09-01 10:00:10'),
(2,7,'Money received','You received LKR 25,000.00 from Amal Wickramasinghe.','EMAIL',TRUE,'2026-09-01 10:00:12'),
(3,8,'Card blocked','Your ATM card ending 0003 has been blocked.','SMS',FALSE,'2026-09-08 08:00:00'),
(4,6,'Loan approved','Your loan application LN20260801001 has been approved.','EMAIL',FALSE,'2026-08-10 15:05:00'),
(5,10,'Transfer cancelled','Your transfer TRF20260915004 was cancelled.','IN_APP',FALSE,'2026-09-15 16:25:05');

-- Data for: notification_templates
INSERT INTO notification_templates (id, template_key, name, subject, body, channel, updated_by) VALUES
(1,'ACCOUNT_ACTIVATED','Account Activated','Your account is active','Dear {name}, your account {account} is now active.','EMAIL',1),
(2,'TRANSFER_SUCCESS','Transfer Successful','Transfer completed','LKR {amount} was transferred to {beneficiary}. Ref: {ref}.','IN_APP',1),
(3,'OTP_SMS','OTP Message','OTP code','Your SmartBank OTP is {otp}. It expires in 5 minutes.','SMS',1),
(4,'LOAN_APPROVED','Loan Approved','Loan approval','Your loan application {app_no} has been approved.','EMAIL',1),
(5,'CARD_BLOCKED','Card Blocked','Card blocked','Your card ending {last4} has been blocked.','SMS',NULL);

-- Data for: notification_preferences
INSERT INTO notification_preferences (id, user_id, email_notifications, sms_notifications, in_app_notifications) VALUES
(1,6,TRUE,TRUE,TRUE),(2,7,TRUE,FALSE,TRUE),(3,8,FALSE,TRUE,TRUE),(4,9,TRUE,FALSE,FALSE),(5,10,TRUE,TRUE,TRUE);

-- Data for: approval_requests
INSERT INTO approval_requests (id, request_type, target_id, target_reference, requester_id, status, approved_by, approved_at, remarks, execution_status, executed_at) VALUES
(1,'ACCOUNT_OPEN',1,'LTB012345678',2,'APPROVED',1,'2026-01-10 10:00:00','KYC verified','EXECUTED','2026-01-10 10:01:00'),
(2,'ACCOUNT_OPEN',2,'LTB012345679',3,'APPROVED',1,'2026-02-05 11:30:00','KYC verified','EXECUTED','2026-02-05 11:31:00'),
(3,'ACCOUNT_OPEN',6,'LTB012345683',2,'PENDING',NULL,NULL,'Second savings account','PENDING',NULL),
(4,'ACCOUNT_FREEZE',3,'LTB012345680',3,'PENDING',NULL,NULL,'Suspicious activity reported','PENDING',NULL),
(5,'STAFF_CREATE',5,'EMP1005',2,'REJECTED',1,'2026-08-15 09:00:00','Missing documents','FAILED',NULL);
UPDATE approval_requests SET rejected_at='2026-08-15 09:00:00', rejection_reason='Incomplete staff documents' WHERE id=5;

-- Data for: staff_creation_requests
INSERT INTO staff_creation_requests (id, full_name, email, password_hash, role, nic, employee_id, phone, branch, requested_by, status) VALUES
(1,'Pradeep Kumara','pradeep.k@lankatrust.lk','$2a$10$DEMOHASHSTAFF00000000000000000000000000000000000001','BANK_OFFICER','199111111111','EMP1006','0771000006','KDY-BR',2,'PENDING'),
(2,'Harini Senanayake','harini.s@lankatrust.lk','$2a$10$DEMOHASHSTAFF00000000000000000000000000000000000002','BANK_OFFICER','199222222222','EMP1007','0771000007','CMB-MAIN',2,'APPROVED'),
(3,'Lakmal Wijesekara','lakmal.w@lankatrust.lk','$2a$10$DEMOHASHSTAFF00000000000000000000000000000000000003','COMPLIANCE_OFFICER','198933333333','EMP1008','0771000008','GLE-BR',3,'REJECTED'),
(4,'Sithara Alwis','sithara.a@lankatrust.lk','$2a$10$DEMOHASHSTAFF00000000000000000000000000000000000004','CUSTOMER_RELATIONS_EXECUTIVE','199444444444','EMP1009','0771000009','KUR-BR',3,'PENDING'),
(5,'Roshan Abeysekara','roshan.a@lankatrust.lk','$2a$10$DEMOHASHSTAFF00000000000000000000000000000000000005','BANK_OFFICER','199555555555','EMP1010','0771000010','JAF-BR',2,'PENDING');

-- Data for: audit_logs
INSERT INTO audit_logs (id, actor_email, action, entity_type, entity_id, details, timestamp) VALUES
(1,'nimal.perera@lankatrust.lk','ACCOUNT_APPROVED','Account','1','Approved opening of LTB012345678','2026-01-10 10:00:00'),
(2,'kasun.silva@lankatrust.lk','ACCOUNT_SUBMITTED','Account','6','Submitted opening of LTB012345683','2026-09-20 16:00:00'),
(3,'amal.w@gmail.com','TRANSFER_INITIATED','Transfer','1','LKR 25000 to LTB012345679','2026-09-01 10:00:00'),
(4,'SYSTEM','LOGIN_LOCKED','User','8','Account temporarily locked after failed attempts','2026-09-22 20:39:00'),
(5,'nimal.perera@lankatrust.lk','LOAN_APPROVED','Loan','1','Approved LN20260801001','2026-08-10 15:00:00');

-- Data for: app_meta
INSERT INTO app_meta (meta_key, meta_value) VALUES
('manager_credentials_printed','true'),
('schema_version','2.0'),
('daily_transfer_limit','500000'),
('high_value_threshold','50000'),
('otp_expiry_minutes','5');

-- Data for: support_tickets
INSERT INTO support_tickets (id, ticket_number, customer_id, subject, message, status, created_by, assigned_to, resolution, updated_at) VALUES
(1,'TCK-20260901-001',6,'Unable to view statement','Statement page shows an error.','RESOLVED',6,3,'Cache issue fixed.','2026-09-02 10:00:00'),
(2,'TCK-20260908-002',8,'Card blocked','My ATM card was blocked without notice.','IN_PROGRESS',8,3,NULL,'2026-09-09 11:00:00'),
(3,'TCK-20260912-003',7,'Update phone number','Please update my registered mobile number.','OPEN',7,NULL,NULL,NULL),
(4,'TCK-20260915-004',10,'Cancelled transfer refund','Was the amount refunded?','CLOSED',10,3,'No debit occurred.','2026-09-16 09:00:00'),
(5,'TCK-20260920-005',9,'KYC status','When will my KYC be approved?','OPEN',9,NULL,NULL,NULL);

-- Data for: communication_logs
INSERT INTO communication_logs (id, customer_id, staff_id, channel, summary) VALUES
(1,6,3,'PHONE','Explained loan document requirements.'),
(2,8,3,'BRANCH_VISIT','Customer visited about blocked card.'),
(3,7,2,'EMAIL','Sent statement guidance.'),
(4,9,2,'PHONE','Reminded to upload NIC for KYC.'),
(5,10,3,'EMAIL','Confirmed cancelled transfer.');

SET FOREIGN_KEY_CHECKS = 1;
