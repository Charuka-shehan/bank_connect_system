# Running SmartBank Connect in IntelliJ IDEA

Follow these steps **in order** — most build errors people hit are from skipping
step 2 (Lombok) or step 3 (JDK version).

## 1. Open the project
`File → Open` → select the `smartbank-connect` folder (the one containing
`pom.xml`, NOT the outer zip-extracted folder). IntelliJ will detect it as a
Maven project and start downloading dependencies automatically — wait for the
progress bar at the bottom right to finish (this needs internet access).

## 2. Install & enable the Lombok plugin (REQUIRED)
This project uses Lombok (`@Data`, `@Builder`, etc.) to generate getters/setters.
Without this step you'll see errors like `cannot find symbol: method getFullName()`.

- `File → Settings → Plugins` → search **"Lombok"** → Install → Restart IDE
- `File → Settings → Build, Execution, Deployment → Compiler → Annotation Processors`
  → check **"Enable annotation processing"** → OK

## 3. Set the Project SDK to Java 17+
`File → Project Structure → Project` → set **SDK** to a Java 17 (or newer) JDK.
If you don't have one installed, IntelliJ can download one for you from that
same dropdown (`Download JDK...`).

## 4. Reload Maven
Click the Maven icon on the right sidebar → click the 🔄 **Reload All Maven
Projects** button. This re-downloads any dependency that failed earlier
(this is the IDE equivalent of `mvn clean install -U`).

## 5. Set up MySQL
- Make sure MySQL is running locally.
- Open `src/main/resources/application.properties` and update:
  ```properties
  spring.datasource.username=root
  spring.datasource.password=YOUR_MYSQL_PASSWORD
  ```
  The database `smartbank_connect` is created automatically on first run.

## 6. Run the app
Open `SmartBankConnectApplication.java`
(`src/main/java/com/lankatrust/smartbank/`) → click the green ▶ Run arrow next
to the `main` method.

You should see Spring Boot's startup banner in the Run console, ending with
something like:
```
Tomcat started on port 8080
Started SmartBankConnectApplication in X.XXX seconds
```

Then open **http://localhost:8080** in your browser.

## 7. If you still get red/underlined errors after all this
- `Build → Rebuild Project`
- If a specific package is still "does not exist": right-click `pom.xml` →
  **Maven → Reload Project**, then check the **Maven tool window → Dependencies**
  tab to confirm `spring-security-oauth2-client` and `spring-security-oauth2-core`
  actually appear in the list. If they're missing, your `.m2` cache didn't
  download them — delete
  `C:\Users\<you>\.m2\repository\org\springframework\security\spring-security-oauth2-client`
  and `...\spring-security-oauth2-core`, then Reload Maven again.

## 8. Demo logins
Password for all seeded accounts: `Password@123`

| Role | Email |
|------|-------|
| Administrator | admin@lankatrust.lk |
| Manager | manager@lankatrust.lk |
| Officer | officer@lankatrust.lk |
| Compliance Officer | compliance@lankatrust.lk |
| Customer | customer@lankatrust.lk |
