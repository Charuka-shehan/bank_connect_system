# SmartBank Connect

A complete Web-Based Banking Management System prototype for LankaTrust Bank PLC, following real Sri Lankan commercial banking practices.

**Group 47 | SE2030 Software Engineering | SLIIT Faculty of Computing**

## Technology Stack

- Java 17
- Spring Boot 3.x
- Spring MVC + Spring Security
- Hibernate / JPA
- MySQL 8+
- JSP + Bootstrap 5
- Maven
- HikariCP
- JavaMail SMTP (Email OTP)
- Google OAuth 2.0
- Chart.js
- OpenPDF
- Docker

## Features

- **Real Sri Lankan account opening workflow**: Officer opens account, Manager approves, system auto-generates account number, customer ID, and ATM card.
- **Customer self-registration**: Only after an account has been opened and approved.
- **Email OTP login**: 6-digit OTP, 5-minute expiry, attempt limits.
- **Role-based dashboards**: Customer, Bank Officer, Bank Manager, System Administrator, Compliance Officer, Customer Relations Executive.
- **Manager approval workflows**: Account opening, freeze/close, transfers, loans.
- **Fund transfer**: Internal transfers with OTP step-up for high-value transactions.
- **Demo banking**: Simulated card payments and ATM withdrawals with DEMO MODE labels.
- **Reports**: PDF and CSV downloads for transactions, accounts, audit logs.
- **Charts & analytics**: Chart.js dashboards for transaction volume, deposits/withdrawals, loan ratios, account trends.
- **Document uploads**: NIC, proof of address, signature, profile photos.
- **Audit logging**: Immutable auto-generated logs.

## Prerequisites

- Java 17+ JDK
- Maven 3.8+
- MySQL 8.x running locally
- (Optional) Google OAuth2 credentials for Google Sign-In

## Setup

### 1. Create the database

```sql
CREATE DATABASE IF NOT EXISTS smartbank_connect;
```

The app can also create the database automatically (`createDatabaseIfNotExist=true`).

### 2. Configure `src/main/resources/application.properties`

Update MySQL credentials:

```properties
spring.datasource.username=root
spring.datasource.password=2002
```

For email OTP, configure Gmail SMTP credentials or use the console fallback (OTP is printed to the console in sandbox mode).

For Google Sign-In, replace:

```properties
spring.security.oauth2.client.registration.google.client-id=YOUR_GOOGLE_CLIENT_ID
spring.security.oauth2.client.registration.google.client-secret=YOUR_GOOGLE_CLIENT_SECRET
```

### 3. Build & run

```bash
mvn clean install
mvn spring-boot:run
```

Then open **http://localhost:8080**

On first run, `schema.sql` creates all tables and `DatabaseSeeder` creates demo users, a branch, and an active customer account with an ATM card.

## Demo Users

| Role | Email | Password |
|------|-------|----------|
| Bank Manager | manager@lankatrust.lk | Manager@123 |
| Bank Officer | officer@lankatrust.lk | Officer@123 |
| Customer | customer@lankatrust.lk | Customer@123 |
| System Administrator | admin@lankatrust.lk | Admin@123 |
| Compliance Officer | compliance@lankatrust.lk | Compliance@123 |
| Customer Relations Executive | cre@lankatrust.lk | Cre@123 |

All users must complete email OTP verification after password login. In sandbox mode the OTP is printed in the application console.

## Demo Workflow

1. **Login as Officer** (`officer@lankatrust.lk` / `Officer@123`).
2. Navigate to **Manage Accounts → Open New Account** and submit a new account opening request with customer details, documents, and initial deposit.
3. **Logout** and **login as Manager** (`manager@lankatrust.lk` / `Manager@123`).
4. Approve the pending account. The system activates the account and generates an ATM card.
5. **Logout** and **login as Customer** (`customer@lankatrust.lk` / `Customer@123`).
6. Use Fund Transfer, Demo Payment, Demo ATM, Beneficiaries, Loans, and Reports.

## Docker

```bash
docker-compose up --build
```

This starts MySQL and the Spring Boot application in containers.

## Testing

```bash
mvn test
```

Tests cover account approval, fund transfer logic, and password policy validation.

## Project Structure

- `src/main/java/com/lankatrust/smartbank/`
  - `config/` — Security, web, database seeding
  - `controller/` — MVC controllers
  - `service/` + `service/impl/` — Business logic
  - `repository/` — Spring Data JPA repositories
  - `entity/` — JPA entities
  - `dto/` — Data transfer objects
  - `security/` — Custom user details, OTP handlers
  - `audit/` — Audit aspect
  - `util/` — Utilities (password validator)
- `src/main/resources/` — Config, SQL scripts, static assets
- `src/main/webapp/WEB-INF/views/` — JSP views
- `src/test/` — Unit and integration tests
