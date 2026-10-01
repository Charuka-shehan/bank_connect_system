<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<c:set var="pageTitle" value="Compliance & AML" scope="request"/>
<jsp:include page="../common/app-frame-start.jsp"/>

<div class="row g-3 mb-4">
    <div class="col-md-4"><div class="sb-card text-center"><div class="fs-3">${pendingKyc.size()}</div><small>Pending KYC</small></div></div>
    <div class="col-md-4"><div class="sb-card text-center"><div class="fs-3">${suspicious.size()}</div><small>Suspicious transactions (≥ LKR 1,000,000)</small></div></div>
    <div class="col-md-4"><div class="sb-card text-center"><div class="fs-3">${frozenAccounts.size()}</div><small>Frozen accounts</small></div></div>
</div>

<div class="sb-card mb-4">
    <h6 class="mb-3">KYC / risk assessment</h6>
    <table class="table align-middle">
        <thead><tr><th>Customer</th><th>KYC</th><th></th></tr></thead>
        <tbody>
        <c:forEach var="cust" items="${customers}">
            <tr>
                <td><c:out value="${cust.fullName}"/> <div class="small text-muted"><c:out value="${cust.customerId}"/></div></td>
                <td><span class="badge ${cust.kycStatus == 'APPROVED' ? 'bg-success' : (cust.kycStatus == 'HIGH_RISK' ? 'bg-danger' : 'bg-warning text-dark')}"><c:out value="${cust.kycStatus}"/></span></td>
                <td class="d-flex gap-1">
                    <form method="post" action="<c:url value='/compliance/kyc/${cust.id}/verify'/>">
                        <c:if test="${not empty _csrf}"><input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" /></c:if>
                        <button class="btn btn-sm btn-success">Verify KYC</button>
                    </form>
                    <form method="post" action="<c:url value='/compliance/kyc/${cust.id}/flag'/>"
                          onsubmit="var r=prompt('Risk reason:'); if(!r) return false; this.querySelector('[name=reason]').value=r;">
                        <c:if test="${not empty _csrf}"><input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" /></c:if>
                        <input type="hidden" name="reason" value="">
                        <button class="btn btn-sm btn-outline-danger">Flag AML</button>
                    </form>
                </td>
            </tr>
        </c:forEach>
        </tbody>
    </table>
</div>

<div class="sb-card mb-4">
    <h6 class="mb-3">Document verification</h6>
    <table class="table">
        <thead><tr><th>Customer</th><th>Type</th><th>File</th><th></th></tr></thead>
        <tbody>
        <c:forEach var="d" items="${documents}">
            <tr>
                <td><c:out value="${d.customer.fullName}"/></td>
                <td><c:out value="${d.documentType}"/></td>
                <td><a href="<c:url value='${d.filePath}'/>" target="_blank"><c:out value="${d.fileName}"/></a></td>
                <td>
                    <c:if test="${!d.verified}">
                        <form method="post" action="<c:url value='/compliance/documents/${d.id}/verify'/>">
                            <c:if test="${not empty _csrf}"><input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" /></c:if>
                            <button class="btn btn-sm btn-outline-primary">Verify</button>
                        </form>
                    </c:if>
                    <c:if test="${d.verified}"><span class="badge bg-success">Verified</span></c:if>
                </td>
            </tr>
        </c:forEach>
        </tbody>
    </table>
</div>

<div class="sb-card mb-4">
    <h6 class="mb-3">Suspicious transaction monitoring</h6>
    <table class="table">
        <thead><tr><th>Reference</th><th>Amount</th><th>Type</th></tr></thead>
        <tbody>
        <c:forEach var="t" items="${suspicious}">
            <tr>
                <td><c:out value="${t.referenceNumber}"/></td>
                <td>LKR <fmt:formatNumber value="${t.amount}" maxFractionDigits="2"/></td>
                <td><c:out value="${t.type}"/></td>
            </tr>
        </c:forEach>
        <c:if test="${empty suspicious}"><tr><td colspan="3" class="text-muted">No transactions above the AML threshold.</td></tr></c:if>
        </tbody>
    </table>
</div>

<div class="sb-card">
    <h6 class="mb-3">Loan compliance queue</h6>
    <a class="btn btn-sm btn-primary" href="<c:url value='/loans/review'/>">Open loan review</a>
    <a class="btn btn-sm btn-outline-secondary" target="_blank" href="<c:url value='/reports/loans/status'/>">Loan report PDF</a>
    <a class="btn btn-sm btn-outline-secondary" target="_blank" href="<c:url value='/reports/audit/logs'/>">Audit report PDF</a>
</div>

<jsp:include page="../common/app-frame-end.jsp"/>
