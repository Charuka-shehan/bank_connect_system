-- SmartBank Connect - Complete schema definition
SET FOREIGN_KEY_CHECKS = 0;

-- Drop existing tables to ensure clean schema
DROP TABLE IF EXISTS audit_logs;
DROP TABLE IF EXISTS transaction_corrections;
DROP TABLE IF EXISTS statement_requests;
DROP TABLE IF EXISTS communication_logs;
DROP TABLE IF EXISTS support_tickets;
DROP TABLE IF EXISTS reports;
DROP TABLE IF EXISTS app_meta;
DROP TABLE IF EXISTS otp_codes;
DROP TABLE IF EXISTS otp_verifications;
DROP TABLE IF EXISTS password_reset_tokens;
DROP TABLE IF EXISTS notification_preferences;
DROP TABLE IF EXISTS notification_templates;
DROP TABLE IF EXISTS notifications;
DROP TABLE IF EXISTS loan_documents;
DROP TABLE IF EXISTS loans;
DROP TABLE IF EXISTS transactions;
DROP TABLE IF EXISTS transfers;
DROP TABLE IF EXISTS beneficiaries;
DROP TABLE IF EXISTS atm_cards;
DROP TABLE IF EXISTS customer_documents;
DROP TABLE IF EXISTS approval_requests;
DROP TABLE IF EXISTS accounts;
DROP TABLE IF EXISTS officers;
DROP TABLE IF EXISTS customers;
DROP TABLE IF EXISTS branches;
DROP TABLE IF EXISTS user_roles;
DROP TABLE IF EXISTS users;
DROP TABLE IF EXISTS roles;

-- roles
CREATE TABLE roles (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(64) NOT NULL UNIQUE,
  description VARCHAR(255),
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- users
CREATE TABLE users (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  full_name VARCHAR(200) NOT NULL,
  email VARCHAR(255) NOT NULL UNIQUE,
  password VARCHAR(255),
  phone_number VARCHAR(30),
  nic VARCHAR(30),
  role VARCHAR(30) DEFAULT 'CUSTOMER',
  enabled BOOLEAN NOT NULL DEFAULT TRUE,
  google_linked BOOLEAN NOT NULL DEFAULT FALSE,
  otp_code VARCHAR(6) NULL,
  otp_expiry DATETIME NULL,
  failed_login_attempts INT NOT NULL DEFAULT 0,
  locked_until DATETIME NULL,
  last_login DATETIME NULL,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- user_roles
CREATE TABLE user_roles (
  user_id BIGINT NOT NULL,
  role_id INT NOT NULL,
  PRIMARY KEY (user_id, role_id),
  CONSTRAINT fk_user_roles_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
  CONSTRAINT fk_user_roles_role FOREIGN KEY (role_id) REFERENCES roles(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- branches
CREATE TABLE branches (
  id INT AUTO_INCREMENT PRIMARY KEY,
  code VARCHAR(20) NOT NULL UNIQUE,
  name VARCHAR(200) NOT NULL,
  address TEXT,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- customers (extension of users)
CREATE TABLE customers (
  id BIGINT PRIMARY KEY,
  customer_id VARCHAR(50) UNIQUE,
  dob DATE,
  address TEXT,
  kyc_status VARCHAR(30) DEFAULT 'PENDING',
  profile_photo_path VARCHAR(400),
  branch_id INT,
  CONSTRAINT fk_customers_user FOREIGN KEY (id) REFERENCES users(id) ON DELETE CASCADE,
  CONSTRAINT fk_customers_branch FOREIGN KEY (branch_id) REFERENCES branches(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- officers (extension of users)
CREATE TABLE officers (
  id BIGINT PRIMARY KEY,
  employee_id VARCHAR(50) NOT NULL UNIQUE,
  branch VARCHAR(100),
  CONSTRAINT fk_officers_user FOREIGN KEY (id) REFERENCES users(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- accounts
CREATE TABLE accounts (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  account_number VARCHAR(30) NOT NULL UNIQUE,
  customer_id BIGINT NOT NULL,
  account_type VARCHAR(30) NOT NULL,
  balance DECIMAL(18,2) NOT NULL DEFAULT 0.00,
  initial_deposit DECIMAL(18,2) NOT NULL DEFAULT 0.00,
  status VARCHAR(30) NOT NULL DEFAULT 'PENDING_APPROVAL',
  branch_id INT,
  occupation VARCHAR(100),
  monthly_income DECIMAL(18,2),
  nominee_name VARCHAR(200),
  nominee_relationship VARCHAR(100),
  signature_path VARCHAR(400),
  nic_front_path VARCHAR(400),
  nic_back_path VARCHAR(400),
  proof_of_address_path VARCHAR(400),
  rejection_reason VARCHAR(500),
  submitted_by BIGINT,
  approved_by BIGINT,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME NULL,
  CONSTRAINT fk_accounts_customer FOREIGN KEY (customer_id) REFERENCES users(id),
  CONSTRAINT fk_accounts_branch FOREIGN KEY (branch_id) REFERENCES branches(id),
  CONSTRAINT fk_accounts_submitted_by FOREIGN KEY (submitted_by) REFERENCES users(id),
  CONSTRAINT fk_accounts_approved_by FOREIGN KEY (approved_by) REFERENCES users(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE INDEX idx_accounts_customer ON accounts(customer_id);
CREATE INDEX idx_accounts_branch ON accounts(branch_id);
CREATE INDEX idx_accounts_status ON accounts(status);

-- atm_cards
CREATE TABLE atm_cards (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  account_id BIGINT NOT NULL UNIQUE,
  card_number VARCHAR(30) NOT NULL UNIQUE,
  cvv_hash VARCHAR(255) NOT NULL,
  expiry_date DATE NOT NULL,
  status VARCHAR(20) NOT NULL DEFAULT 'ACTIVE',
  issued_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_atm_cards_account FOREIGN KEY (account_id) REFERENCES accounts(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE INDEX idx_atm_cards_account ON atm_cards(account_id);

-- customer_documents
CREATE TABLE customer_documents (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  customer_id BIGINT NOT NULL,
  document_type VARCHAR(50) NOT NULL,
  file_name VARCHAR(255) NOT NULL,
  file_path VARCHAR(400) NOT NULL,
  verified BOOLEAN NOT NULL DEFAULT FALSE,
  verified_by BIGINT NULL,
  verified_at DATETIME NULL,
  uploaded_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_customer_documents_customer FOREIGN KEY (customer_id) REFERENCES customers(id) ON DELETE CASCADE,
  CONSTRAINT fk_customer_documents_verifier FOREIGN KEY (verified_by) REFERENCES users(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE INDEX idx_customer_documents_customer ON customer_documents(customer_id);

-- approval_requests
CREATE TABLE approval_requests (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  request_type VARCHAR(50) NOT NULL,
  target_id BIGINT NOT NULL,
  target_reference VARCHAR(100),
  requester_id BIGINT NOT NULL,
  status VARCHAR(30) NOT NULL DEFAULT 'PENDING',
  requested_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  approved_by BIGINT NULL,
  approved_at DATETIME NULL,
  remarks VARCHAR(500),
  CONSTRAINT fk_approval_requests_requester FOREIGN KEY (requester_id) REFERENCES users(id),
  CONSTRAINT fk_approval_requests_approver FOREIGN KEY (approved_by) REFERENCES users(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE INDEX idx_approval_requests_status ON approval_requests(status);
CREATE INDEX idx_approval_requests_type ON approval_requests(request_type);

-- beneficiaries
CREATE TABLE beneficiaries (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  user_id BIGINT NOT NULL,
  beneficiary_name VARCHAR(255) NOT NULL,
  beneficiary_account_number VARCHAR(64) NOT NULL,
  beneficiary_bank VARCHAR(128) NULL,
  nickname VARCHAR(100),
  added_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_beneficiaries_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE INDEX idx_beneficiaries_user ON beneficiaries(user_id);

-- transfers
CREATE TABLE transfers (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  reference_number VARCHAR(64) NOT NULL UNIQUE,
  from_account_id BIGINT NOT NULL,
  to_account_number VARCHAR(64) NOT NULL,
  to_account_bank VARCHAR(128) NULL,
  to_user_id BIGINT NULL,
  amount DECIMAL(18,2) NOT NULL,
  currency VARCHAR(8) DEFAULT 'LKR',
  status ENUM('PENDING','OTP_PENDING','PROCESSING','COMPLETED','CANCELLED','DECLINED') NOT NULL DEFAULT 'PENDING',
  requested_by BIGINT NOT NULL,
  requested_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  approved_by BIGINT NULL,
  approved_at DATETIME NULL,
  cancelled_by BIGINT NULL,
  cancelled_at DATETIME NULL,
  high_value BOOLEAN NOT NULL DEFAULT FALSE,
  daily_limit_exceeded BOOLEAN NOT NULL DEFAULT FALSE,
  CONSTRAINT fk_transfers_from_account FOREIGN KEY (from_account_id) REFERENCES accounts(id),
  CONSTRAINT fk_transfers_requested_by FOREIGN KEY (requested_by) REFERENCES users(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE INDEX idx_transfers_from_account ON transfers(from_account_id);
CREATE INDEX idx_transfers_requested_by ON transfers(requested_by);
CREATE INDEX idx_transfers_status ON transfers(status);

-- transactions
CREATE TABLE transactions (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  reference_number VARCHAR(30) NOT NULL UNIQUE,
  source_account_id BIGINT NOT NULL,
  destination_account_id BIGINT NULL,
  beneficiary_name VARCHAR(100) NULL,
  amount DECIMAL(18,2) NOT NULL,
  type VARCHAR(20) NOT NULL,
  status VARCHAR(20) NOT NULL,
  remarks VARCHAR(255) NULL,
  otp_verified BOOLEAN NOT NULL DEFAULT FALSE,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  processed_at DATETIME NULL,
  CONSTRAINT fk_transactions_source FOREIGN KEY (source_account_id) REFERENCES accounts(id),
  CONSTRAINT fk_transactions_destination FOREIGN KEY (destination_account_id) REFERENCES accounts(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE INDEX idx_transactions_source ON transactions(source_account_id);
CREATE INDEX idx_transactions_created_at ON transactions(created_at);

-- loan_applications (mapped by Loan entity to table 'loans')
CREATE TABLE loans (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  application_number VARCHAR(50) NOT NULL UNIQUE,
  customer_id BIGINT NOT NULL,
  loan_type VARCHAR(50),
  requested_amount DECIMAL(18,2) NOT NULL,
  purpose VARCHAR(255),
  term_months INT,
  monthly_income DECIMAL(18,2),
  employment_status VARCHAR(50),
  documents_summary TEXT,
  status ENUM('SUBMITTED','UNDER_VERIFICATION','COMPLIANCE_CHECK','APPROVED','REJECTED') DEFAULT 'SUBMITTED',
  submitted_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  verified_by BIGINT NULL,
  verified_at DATETIME NULL,
  approved_by BIGINT NULL,
  approved_at DATETIME NULL,
  remarks VARCHAR(500),
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME NULL,
  CONSTRAINT fk_loan_customer FOREIGN KEY (customer_id) REFERENCES users(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- loan_documents
CREATE TABLE loan_documents (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  loan_application_id BIGINT NOT NULL,
  file_name VARCHAR(255) NOT NULL,
  file_path VARCHAR(400) NOT NULL,
  uploaded_by BIGINT NOT NULL,
  uploaded_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_loan_documents_app FOREIGN KEY (loan_application_id) REFERENCES loans(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- notifications
CREATE TABLE notifications (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  recipient_id BIGINT NOT NULL,
  title VARCHAR(150) NOT NULL,
  message VARCHAR(500) NOT NULL,
  channel ENUM('EMAIL','SMS','IN_APP') NOT NULL DEFAULT 'IN_APP',
  is_read BOOLEAN NOT NULL DEFAULT FALSE,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_notifications_user FOREIGN KEY (recipient_id) REFERENCES users(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE INDEX idx_notifications_recipient_read ON notifications(recipient_id, is_read);

-- notification_templates
CREATE TABLE notification_templates (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  template_key VARCHAR(100) NOT NULL UNIQUE,
  name VARCHAR(150) NOT NULL,
  subject VARCHAR(255),
  body TEXT NOT NULL,
  channel ENUM('EMAIL','SMS','IN_APP') NOT NULL DEFAULT 'IN_APP',
  updated_by BIGINT NULL,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  CONSTRAINT fk_notification_templates_updater FOREIGN KEY (updated_by) REFERENCES users(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- notification_preferences
CREATE TABLE notification_preferences (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  user_id BIGINT NOT NULL,
  email_notifications BOOLEAN DEFAULT TRUE,
  sms_notifications BOOLEAN DEFAULT FALSE,
  in_app_notifications BOOLEAN DEFAULT TRUE,
  CONSTRAINT fk_notification_preferences_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- audit_logs
CREATE TABLE audit_logs (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  actor_email VARCHAR(150) NULL,
  action VARCHAR(200) NOT NULL,
  entity_type VARCHAR(200),
  entity_id VARCHAR(200),
  details TEXT NULL,
  timestamp DATETIME DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE INDEX idx_audit_logs_actor_timestamp ON audit_logs(actor_email, timestamp);

-- password_reset_tokens
CREATE TABLE password_reset_tokens (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  user_id BIGINT NOT NULL,
  token VARCHAR(255) NOT NULL UNIQUE,
  expires_at DATETIME NOT NULL,
  used BOOLEAN DEFAULT FALSE,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_prt_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE INDEX idx_prt_token ON password_reset_tokens(token);

-- otp_codes
CREATE TABLE otp_codes (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  user_id BIGINT NOT NULL,
  transfer_id BIGINT NULL,
  code VARCHAR(10) NOT NULL,
  purpose VARCHAR(50) NOT NULL,
  expires_at DATETIME NOT NULL,
  attempts INT DEFAULT 0,
  consumed BOOLEAN DEFAULT FALSE,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_otp_user FOREIGN KEY (user_id) REFERENCES users(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE INDEX idx_otp_user ON otp_codes(user_id);

-- otp_verifications
CREATE TABLE otp_verifications (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  email VARCHAR(150) NOT NULL,
  otp_hash VARCHAR(255) NOT NULL,
  operation_type VARCHAR(50) NULL,
  attempts INT DEFAULT 0,
  expires_at DATETIME NOT NULL,
  verified BOOLEAN DEFAULT FALSE,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  verified_at DATETIME NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- reports
CREATE TABLE reports (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  type VARCHAR(50),
  params JSON,
  generated_by BIGINT,
  file_path VARCHAR(400),
  status VARCHAR(30) DEFAULT 'DRAFT',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_reports_user FOREIGN KEY (generated_by) REFERENCES users(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- support_tickets (Customer Relations)
CREATE TABLE support_tickets (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  ticket_number VARCHAR(40) NOT NULL UNIQUE,
  customer_id BIGINT NOT NULL,
  subject VARCHAR(200) NOT NULL,
  message TEXT NOT NULL,
  status VARCHAR(30) NOT NULL DEFAULT 'OPEN',
  created_by BIGINT NOT NULL,
  assigned_to BIGINT NULL,
  resolution TEXT NULL,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME NULL,
  CONSTRAINT fk_support_tickets_customer FOREIGN KEY (customer_id) REFERENCES users(id),
  CONSTRAINT fk_support_tickets_created_by FOREIGN KEY (created_by) REFERENCES users(id),
  CONSTRAINT fk_support_tickets_assigned FOREIGN KEY (assigned_to) REFERENCES users(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE INDEX idx_support_tickets_status ON support_tickets(status);
CREATE INDEX idx_support_tickets_customer ON support_tickets(customer_id);

-- communication_logs
CREATE TABLE communication_logs (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  customer_id BIGINT NOT NULL,
  staff_id BIGINT NOT NULL,
  channel VARCHAR(30) NOT NULL,
  summary VARCHAR(500) NOT NULL,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_comm_logs_customer FOREIGN KEY (customer_id) REFERENCES users(id),
  CONSTRAINT fk_comm_logs_staff FOREIGN KEY (staff_id) REFERENCES users(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE INDEX idx_comm_logs_customer ON communication_logs(customer_id);

-- statement_requests
CREATE TABLE statement_requests (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  customer_id BIGINT NOT NULL,
  account_id BIGINT NOT NULL,
  period_from DATE NOT NULL,
  period_to DATE NOT NULL,
  status VARCHAR(30) NOT NULL DEFAULT 'PENDING',
  handled_by BIGINT NULL,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  completed_at DATETIME NULL,
  CONSTRAINT fk_statement_req_customer FOREIGN KEY (customer_id) REFERENCES users(id),
  CONSTRAINT fk_statement_req_account FOREIGN KEY (account_id) REFERENCES accounts(id),
  CONSTRAINT fk_statement_req_handler FOREIGN KEY (handled_by) REFERENCES users(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- transaction_corrections
CREATE TABLE transaction_corrections (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  transaction_id BIGINT NOT NULL,
  requested_by BIGINT NOT NULL,
  proposed_remarks VARCHAR(255),
  proposed_amount DECIMAL(18,2) NULL,
  reason VARCHAR(500) NOT NULL,
  status VARCHAR(30) NOT NULL DEFAULT 'PENDING',
  approved_by BIGINT NULL,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  processed_at DATETIME NULL,
  CONSTRAINT fk_txn_corr_txn FOREIGN KEY (transaction_id) REFERENCES transactions(id),
  CONSTRAINT fk_txn_corr_requester FOREIGN KEY (requested_by) REFERENCES users(id),
  CONSTRAINT fk_txn_corr_approver FOREIGN KEY (approved_by) REFERENCES users(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- application metadata table for runtime flags
CREATE TABLE app_meta (
  meta_key VARCHAR(100) PRIMARY KEY,
  meta_value VARCHAR(400),
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

SET FOREIGN_KEY_CHECKS = 1;
