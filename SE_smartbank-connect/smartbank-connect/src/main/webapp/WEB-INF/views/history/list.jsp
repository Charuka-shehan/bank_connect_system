<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <title>Transaction History | SmartBank Connect</title>
    <jsp:include page="../common/app-head.jsp"/>
</head>
<body>
<div class="sb-shell">
    <jsp:include page="../common/sidebar.jsp"/>
    <div class="sb-main">
        <div class="sb-topbar">
            <h5 class="mb-0">Transaction History</h5>
            <a href="<c:url value='/reports/statement/download'/>" class="btn btn-outline-primary btn-sm">
                <i class="bi bi-file-earmark-pdf me-1"></i>Download Statement (PDF)
            </a>
        </div>
        <div class="sb-content">
            <div class="sb-card mb-4">
                <form action="<c:url value='/history'/>" method="get" class="row g-2 align-items-end">
                    <div class="col-md-4">
                        <label class="form-label small">Select Account</label>
                        <select name="accountId" class="form-select" onchange="this.form.submit()">
                            <c:forEach var="a" items="${accounts}">
                                <option value="${a.id}" ${a.id == selectedAccountId ? 'selected' : ''}>${a.accountNumber} — ${a.accountType} (Rs. <fmt:formatNumber value="${a.balance}" maxFractionDigits="2"/>)</option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="col-md-3">
                        <label class="form-label small">From</label>
                        <input type="date" name="startDate" class="form-control">
                    </div>
                    <div class="col-md-3">
                        <label class="form-label small">To</label>
                        <input type="date" name="endDate" class="form-control">
                    </div>
                    <div class="col-md-2">
                        <button type="submit" class="btn btn-gold w-100">Filter</button>
                    </div>
                </form>
            </div>

            <div class="sb-card">
                <div class="table-responsive">
                    <table class="table align-middle">
                        <thead><tr><th>Reference</th><th>Type</th><th>Beneficiary</th><th>Amount (Rs.)</th><th>Status</th><th>Date</th></tr></thead>
                        <tbody>
                        <c:forEach var="t" items="${transactions}">
                            <tr>
                                <td>${t.referenceNumber}</td>
                                <td>${t.type}</td>
                                <td>${t.beneficiaryName}</td>
                                <td><fmt:formatNumber value="${t.amount}" maxFractionDigits="2"/></td>
                                <td><span class="sb-badge sb-badge-${t.status.toString().toLowerCase()}">${t.status}</span></td>
                                <td>${t.createdAt}</td>
                            </tr>
                        </c:forEach>
                        <c:if test="${empty transactions}"><tr><td colspan="6" class="text-muted text-center py-3">No transactions found.</td></tr></c:if>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
