<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Administrator Dashboard" scope="request"/>
<jsp:include page="../common/app-frame-start.jsp"/>

<div class="row g-3 mb-4">
    <div class="col-md-3"><div class="sb-card text-center"><div class="display-6">${totalUsers}</div><small>Users</small></div></div>
    <div class="col-md-3"><div class="sb-card text-center"><div class="display-6">${totalAccounts}</div><small>Accounts</small></div></div>
    <div class="col-md-3"><div class="sb-card text-center"><div class="display-6">${totalTransactions}</div><small>Transactions</small></div></div>
    <div class="col-md-3"><div class="sb-card text-center"><div class="display-6">${pendingLoans}</div><small>Pending loans</small></div></div>
</div>

<div class="row g-3">
    <div class="col-md-4"><a class="sb-card d-block text-decoration-none" href="<c:url value='/admin/staff'/>"><h6>User &amp; role management</h6><p class="small text-muted mb-0">Create staff, enable or disable accounts.</p></a></div>
    <div class="col-md-4"><a class="sb-card d-block text-decoration-none" href="<c:url value='/admin/settings'/>"><h6>Security / OTP / Email</h6><p class="small text-muted mb-0">Password policy, OTP and session settings.</p></a></div>
    <div class="col-md-4"><a class="sb-card d-block text-decoration-none" href="<c:url value='/admin/sessions'/>"><h6>Session management</h6><p class="small text-muted mb-0">View and expire active sessions.</p></a></div>
    <div class="col-md-4"><a class="sb-card d-block text-decoration-none" href="<c:url value='/admin/monitoring'/>"><h6>System monitoring</h6><p class="small text-muted mb-0">Heap ${heapUsedMb} / ${heapMaxMb} MB · uptime ${uptimeMinutes} min</p></a></div>
    <div class="col-md-4"><a class="sb-card d-block text-decoration-none" href="<c:url value='/admin/backup'/>"><h6>Backup</h6><p class="small text-muted mb-0">Download CSV snapshot of core records.</p></a></div>
    <div class="col-md-4"><a class="sb-card d-block text-decoration-none" href="<c:url value='/admin/audit-logs'/>"><h6>Audit monitoring</h6><p class="small text-muted mb-0">Immutable activity log.</p></a></div>
</div>

<jsp:include page="../common/app-frame-end.jsp"/>
