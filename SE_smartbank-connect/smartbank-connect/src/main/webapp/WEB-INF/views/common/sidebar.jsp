<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<aside class="bd-sidebar">
    <div class="bd-sidebar-logo">
        <i class="bi bi-bank2" style="font-size: 1.6rem; color: #1814F3;"></i>
        <span>SmartBank Connect.</span>
    </div>
    <ul class="bd-nav">
        <c:set var="sidebarUser" value="${not empty user ? user : userDto}"/>
        <c:if test="${not empty sidebarUser}">
            <c:choose>
                <c:when test="${sidebarUser.role == 'CUSTOMER'}">
                    <li class="bd-nav-item"><a href="<c:url value='/customer/dashboard'/>"><i class="bi bi-house-door-fill"></i> Dashboard</a></li>
                </c:when>
                <c:when test="${sidebarUser.role == 'BANK_OFFICER'}">
                    <li class="bd-nav-item"><a href="<c:url value='/officer/dashboard'/>"><i class="bi bi-house-door-fill"></i> Dashboard</a></li>
                </c:when>
                <c:when test="${sidebarUser.role == 'BANK_MANAGER'}">
                    <li class="bd-nav-item"><a href="<c:url value='/manager/dashboard'/>"><i class="bi bi-house-door-fill"></i> Dashboard</a></li>
                </c:when>
                <c:when test="${sidebarUser.role == 'SYSTEM_ADMINISTRATOR'}">
                    <li class="bd-nav-item"><a href="<c:url value='/admin/dashboard'/>"><i class="bi bi-house-door-fill"></i> Dashboard</a></li>
                </c:when>
                <c:when test="${sidebarUser.role == 'COMPLIANCE_OFFICER'}">
                    <li class="bd-nav-item"><a href="<c:url value='/compliance/dashboard'/>"><i class="bi bi-house-door-fill"></i> Dashboard</a></li>
                </c:when>
                <c:when test="${sidebarUser.role == 'CUSTOMER_RELATIONS_EXECUTIVE'}">
                    <li class="bd-nav-item"><a href="<c:url value='/cre/dashboard'/>"><i class="bi bi-house-door-fill"></i> Dashboard</a></li>
                </c:when>
                <c:otherwise>
                    <li class="bd-nav-item"><a href="<c:url value='/bankdash/overview'/>"><i class="bi bi-house-door-fill"></i> Dashboard</a></li>
                </c:otherwise>
            </c:choose>

            <c:if test="${sidebarUser.role == 'CUSTOMER' || sidebarUser.role == 'BANK_MANAGER'}">
                <li class="bd-nav-item"><a href="<c:url value='/transfer'/>"><i class="bi bi-arrow-left-right"></i> Fund Transfer</a></li>
                <li class="bd-nav-item"><a href="<c:url value='/customer/beneficiaries'/>"><i class="bi bi-people"></i> Beneficiaries</a></li>
                <li class="bd-nav-item"><a href="<c:url value='/history'/>"><i class="bi bi-clock-history"></i> Transactions</a></li>
                <li class="bd-nav-item"><a href="<c:url value='/loans'/>"><i class="bi bi-cash-coin"></i> My Loans</a></li>
                <li class="bd-nav-item"><a href="<c:url value='/demo/payment'/>"><i class="bi bi-credit-card"></i> Demo Payment</a></li>
                <li class="bd-nav-item"><a href="<c:url value='/customer/documents'/>"><i class="bi bi-folder"></i> Documents</a></li>
            </c:if>

            <c:if test="${sidebarUser.role == 'BANK_OFFICER' || sidebarUser.role == 'BANK_MANAGER'}">
                <li class="bd-nav-item"><a href="<c:url value='/accounts/open'/>"><i class="bi bi-plus-circle"></i> Open Account</a></li>
                <li class="bd-nav-item"><a href="<c:url value='/accounts/manage'/>"><i class="bi bi-wallet2"></i> Manage Accounts</a></li>
                <li class="bd-nav-item"><a href="<c:url value='/officer/customers'/>"><i class="bi bi-search"></i> Customer Search</a></li>
                <li class="bd-nav-item"><a href="<c:url value='/officer/transfers'/>"><i class="bi bi-arrow-left-right"></i> Transfer Queue</a></li>
                <li class="bd-nav-item"><a href="<c:url value='/officer/corrections'/>"><i class="bi bi-pencil-square"></i> Corrections</a></li>
                <li class="bd-nav-item"><a href="<c:url value='/officer/templates'/>"><i class="bi bi-envelope"></i> Templates</a></li>
                <li class="bd-nav-item"><a href="<c:url value='/officer/reports'/>"><i class="bi bi-bar-chart"></i> Reports</a></li>
            </c:if>

            <c:if test="${sidebarUser.role == 'BANK_OFFICER' || sidebarUser.role == 'COMPLIANCE_OFFICER' || sidebarUser.role == 'BANK_MANAGER'}">
                <li class="bd-nav-item"><a href="<c:url value='/loans/review'/>"><i class="bi bi-file-earmark-check"></i> Loan Review</a></li>
            </c:if>

            <c:if test="${sidebarUser.role == 'BANK_MANAGER'}">
                <li class="bd-nav-item"><a href="<c:url value='/approvals'/>"><i class="bi bi-check2-square"></i> Approvals</a></li>
                <li class="bd-nav-item"><a href="<c:url value='/branches'/>"><i class="bi bi-building"></i> Branches</a></li>
                <li class="bd-nav-item"><a href="<c:url value='/officer/dashboard'/>"><i class="bi bi-briefcase"></i> Officer Console</a></li>
                <li class="bd-nav-item"><a href="<c:url value='/compliance/dashboard'/>"><i class="bi bi-shield-check"></i> Compliance</a></li>
                <li class="bd-nav-item"><a href="<c:url value='/cre/dashboard'/>"><i class="bi bi-chat-dots"></i> Relations</a></li>
                <li class="bd-nav-item"><a href="<c:url value='/admin/dashboard'/>"><i class="bi bi-gear"></i> Admin</a></li>
            </c:if>

            <c:if test="${sidebarUser.role == 'SYSTEM_ADMINISTRATOR' || sidebarUser.role == 'BANK_MANAGER'}">
                <li class="bd-nav-item"><a href="<c:url value='/admin/staff'/>"><i class="bi bi-people"></i> User Management</a></li>
                <li class="bd-nav-item"><a href="<c:url value='/admin/settings'/>"><i class="bi bi-sliders"></i> Settings</a></li>
                <li class="bd-nav-item"><a href="<c:url value='/admin/sessions'/>"><i class="bi bi-laptop"></i> Sessions</a></li>
                <li class="bd-nav-item"><a href="<c:url value='/admin/monitoring'/>"><i class="bi bi-activity"></i> Monitoring</a></li>
                <li class="bd-nav-item"><a href="<c:url value='/admin/audit-logs'/>"><i class="bi bi-journal-text"></i> Audit Logs</a></li>
            </c:if>

            <c:if test="${sidebarUser.role == 'COMPLIANCE_OFFICER'}">
                <li class="bd-nav-item"><a href="<c:url value='/compliance/dashboard'/>"><i class="bi bi-shield-check"></i> KYC / AML</a></li>
            </c:if>

            <c:if test="${sidebarUser.role == 'CUSTOMER_RELATIONS_EXECUTIVE'}">
                <li class="bd-nav-item"><a href="<c:url value='/cre/dashboard'/>"><i class="bi bi-headset"></i> Support Desk</a></li>
            </c:if>

            <li class="bd-nav-item"><a href="<c:url value='/customer/profile'/>"><i class="bi bi-person"></i> Profile</a></li>
            <li class="bd-nav-item"><a href="<c:url value='/notifications'/>"><i class="bi bi-bell"></i> Notifications</a></li>
            <li class="bd-nav-item">
                <form action="<c:url value='/logout'/>" method="post" id="logoutForm_sidebar" style="display:none;"><c:if test="${not empty _csrf}"><input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" /></c:if></form>
                <a href="javascript:document.getElementById('logoutForm_sidebar').submit();"><i class="bi bi-box-arrow-right"></i> Log Out</a>
            </li>
        </c:if>
    </ul>
</aside>
