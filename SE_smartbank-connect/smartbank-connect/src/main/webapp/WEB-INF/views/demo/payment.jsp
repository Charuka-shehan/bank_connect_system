<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <title>Demo / Simulated Card Payment | SmartBank Connect</title>
    <jsp:include page="../common/app-head.jsp"/>
</head>
<body>
<div class="sb-shell">
    <jsp:include page="../common/sidebar.jsp"/>
    <div class="sb-main">
        <div class="sb-topbar">
            <h5 class="mb-0"><i class="bi bi-credit-card me-2"></i>Demo / Simulated Card Payment</h5>
        </div>
        <div class="sb-content">
            <div class="alert alert-info py-2 mb-3" style="max-width: 600px;">
                <i class="bi bi-shield-lock-fill me-2 text-primary"></i>
                <strong>Demo / Simulated Card Payment:</strong> This environment simulates merchant card gateway transactions. High-value transactions require mandatory Email OTP verification before any balance deduction.
            </div>

            <c:if test="${not empty error}">
                <div class="alert alert-danger py-2 mb-3 text-danger" style="max-width: 600px;">
                    <i class="bi bi-exclamation-triangle-fill me-2"></i><strong>Error:</strong> <c:out value="${error}"/>
                </div>
            </c:if>

            <div class="sb-card" style="max-width: 600px;">
                <div class="d-flex justify-content-between align-items-center mb-3">
                    <h6 class="mb-0">Payment Details</h6>
                    <span class="badge bg-warning text-dark">Demo / Simulated Mode</span>
                </div>
                <form id="paymentForm" method="post" action="<c:url value='/demo/payment'/>" novalidate>
                    <c:if test="${not empty _csrf}"><input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" /></c:if>
                    
                    <div class="mb-3">
                        <label class="form-label" for="accountId">Select Account <span class="text-danger">*</span></label>
                        <select name="accountId" id="accountId" class="form-select" required>
                            <option value="">-- Select Account --</option>
                            <c:forEach var="acc" items="${accounts}">
                                <option value="${acc.id}">${acc.accountNumber} — ${acc.accountType} (LKR <fmt:formatNumber value="${acc.balance}" maxFractionDigits="2"/>)<c:if test="${not empty acc.status && acc.status != 'ACTIVE'}"> [${acc.status}]</c:if></option>
                            </c:forEach>
                        </select>
                        <div class="invalid-feedback text-danger" id="accountError">Please select an account.</div>
                    </div>

                    <div class="mb-3">
                        <label class="form-label" for="cardNumber">Card Number <span class="text-danger">*</span></label>
                        <input type="text" class="form-control" name="cardNumber" id="cardNumber" 
                               placeholder="1234 5678 9012 3456" maxlength="19" autocomplete="off" required>
                        <div class="invalid-feedback text-danger" id="cardError">Card number must be 16 digits.</div>
                    </div>

                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label class="form-label" for="cvv">CVV (3 or 4 digits) <span class="text-danger">*</span></label>
                            <input type="password" class="form-control" name="cvv" id="cvv" 
                                   placeholder="•••" maxlength="4" autocomplete="off" required>
                            <div class="invalid-feedback text-danger" id="cvvError">CVV must be 3 or 4 digits.</div>
                        </div>
                        <div class="col-md-6 mb-3">
                            <label class="form-label" for="amount">Amount (LKR) <span class="text-danger">*</span></label>
                            <input type="number" step="0.01" min="1.00" class="form-control" name="amount" id="amount" 
                                   placeholder="0.00" required>
                            <div class="invalid-feedback text-danger" id="amountError">Amount must be at least LKR 1.00.</div>
                        </div>
                    </div>

                    <div class="mb-3">
                        <label class="form-label" for="merchantName">Merchant Name <span class="text-danger">*</span></label>
                        <input type="text" class="form-control" name="merchantName" id="merchantName" 
                               placeholder="e.g. Cargills Food City" minlength="2" maxlength="100" required>
                        <div class="invalid-feedback text-danger" id="merchantError">Merchant name must be at least 2 characters.</div>
                    </div>

                    <div class="d-flex align-items-center gap-2 mt-4">
                        <button type="submit" class="btn btn-gold px-4">
                            <i class="bi bi-shield-check me-2"></i>Pay Now (Demo)
                        </button>
                        <a href="<c:url value='/bankdash/overview'/>" class="btn btn-outline-secondary">Back to Dashboard</a>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script>
document.getElementById('paymentForm').addEventListener('submit', function(e) {
    let valid = true;
    const acc = document.getElementById('accountId');
    const card = document.getElementById('cardNumber');
    const cvv = document.getElementById('cvv');
    const merchant = document.getElementById('merchantName');
    const amount = document.getElementById('amount');

    if (!acc.value) {
        acc.classList.add('is-invalid');
        valid = false;
    } else {
        acc.classList.remove('is-invalid');
    }

    const cardDigits = card.value.replace(/\s+/g, '');
    if (!/^\d{16}$/.test(cardDigits)) {
        card.classList.add('is-invalid');
        valid = false;
    } else {
        card.classList.remove('is-invalid');
    }

    if (!/^\d{3,4}$/.test(cvv.value.trim())) {
        cvv.classList.add('is-invalid');
        valid = false;
    } else {
        cvv.classList.remove('is-invalid');
    }

    const amt = parseFloat(amount.value);
    if (isNaN(amt) || amt < 1.0) {
        amount.classList.add('is-invalid');
        valid = false;
    } else {
        amount.classList.remove('is-invalid');
    }

    if (merchant.value.trim().length < 2) {
        merchant.classList.add('is-invalid');
        valid = false;
    } else {
        merchant.classList.remove('is-invalid');
    }

    if (!valid) {
        e.preventDefault();
        return false;
    }

    if (!confirm('Confirm Demo / Simulated Card Payment of LKR ' + amt.toFixed(2) + ' to ' + merchant.value.trim() + '?')) {
        e.preventDefault();
        return false;
    }
});
</script>
</body>
</html>
