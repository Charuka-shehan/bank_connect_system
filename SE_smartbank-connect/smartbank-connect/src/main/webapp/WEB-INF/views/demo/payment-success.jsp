<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <title>Payment Receipt | SmartBank Connect</title>
    <jsp:include page="../common/app-head.jsp"/>
</head>
<body>
<div class="sb-shell">
    <jsp:include page="../common/sidebar.jsp"/>
    <div class="sb-main">
        <div class="sb-topbar"><h5 class="mb-0">Demo Payment Receipt</h5></div>
        <div class="sb-content">
            <div class="alert alert-warning"><strong>DEMO MODE</strong> — Simulated receipt.</div>
            <div class="sb-card" style="max-width: 500px;">
                <div class="text-center mb-4">
                    <i class="bi bi-check-circle-fill text-success" style="font-size: 3rem;"></i>
                    <h4 class="mt-2">Payment Successful</h4>
                </div>
                <ul class="list-group list-group-flush">
                    <li class="list-group-item d-flex justify-content-between"><span>Merchant</span><strong>${merchantName}</strong></li>
                    <li class="list-group-item d-flex justify-content-between"><span>Amount</span><strong>LKR <fmt:formatNumber value="${transaction.amount}" maxFractionDigits="2"/></strong></li>
                    <li class="list-group-item d-flex justify-content-between"><span>Reference</span><strong>${transaction.referenceNumber}</strong></li>
                    <li class="list-group-item d-flex justify-content-between"><span>Status</span><strong>${transaction.status}</strong></li>
                </ul>
                <div class="mt-4 text-center">
                    <a href="<c:url value='/bankdash/overview'/>" class="btn btn-primary">Back to Dashboard</a>
                </div>
            </div>
        </div>
    </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
