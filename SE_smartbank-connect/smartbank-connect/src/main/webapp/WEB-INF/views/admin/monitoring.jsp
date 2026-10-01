<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="System Monitoring" scope="request"/>
<jsp:include page="../common/app-frame-start.jsp"/>

<div class="row g-3">
    <div class="col-md-4"><div class="sb-card"><h6>Heap</h6><p class="mb-0">${heapUsedMb} / ${heapMaxMb} MB</p></div></div>
    <div class="col-md-4"><div class="sb-card"><h6>Uptime</h6><p class="mb-0">${uptimeMinutes} minutes</p></div></div>
    <div class="col-md-4"><div class="sb-card"><h6>Processors</h6><p class="mb-0">${processors}</p></div></div>
    <div class="col-md-4"><div class="sb-card"><h6>Users</h6><p class="mb-0">${users}</p></div></div>
    <div class="col-md-4"><div class="sb-card"><h6>Accounts</h6><p class="mb-0">${accounts}</p></div></div>
    <div class="col-md-4"><div class="sb-card"><h6>Transactions</h6><p class="mb-0">${transactions}</p></div></div>
</div>
<p class="small text-muted mt-3">Snapshot at ${now}</p>

<jsp:include page="../common/app-frame-end.jsp"/>
