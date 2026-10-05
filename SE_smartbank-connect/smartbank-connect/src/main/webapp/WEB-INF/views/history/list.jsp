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
            <c:if test="${not empty error}">
                <div id="serverDateAlert" class="alert alert-danger alert-dismissible fade show d-flex align-items-center mb-3" role="alert">
                    <i class="bi bi-exclamation-triangle-fill flex-shrink-0 me-2 fs-5"></i>
                    <div><c:out value="${error}"/></div>
                    <button type="button" class="btn-close ms-auto" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
            </c:if>

            <div id="clientDateAlert" class="alert alert-danger alert-dismissible fade show d-flex align-items-center mb-3 d-none" role="alert">
                <i class="bi bi-exclamation-triangle-fill flex-shrink-0 me-2 fs-5"></i>
                <div id="clientDateAlertMsg">The “To” date must not be earlier than the “From” date.</div>
                <button type="button" class="btn-close ms-auto" type="button" onclick="hideClientError()" aria-label="Close"></button>
            </div>

            <div class="sb-card mb-4">
                <form id="historyFilterForm" action="<c:url value='/history'/>" method="get" class="row g-2 align-items-end" novalidate>
                    <div class="col-md-4">
                        <label for="accountSelect" class="form-label small">Select Account</label>
                        <select id="accountSelect" name="accountId" class="form-select" onchange="onAccountChange(this)">
                            <c:forEach var="a" items="${accounts}">
                                <option value="${a.id}" ${a.id == selectedAccountId ? 'selected' : ''}>${a.accountNumber} — ${a.accountType} (Rs. <fmt:formatNumber value="${a.balance}" maxFractionDigits="2"/>)</option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="col-md-3">
                        <label for="startDateInput" class="form-label small">From</label>
                        <input type="date" id="startDateInput" name="startDate" value="<c:out value='${startDate}'/>" class="form-control">
                    </div>
                    <div class="col-md-3">
                        <label for="endDateInput" class="form-label small">To</label>
                        <input type="date" id="endDateInput" name="endDate" value="<c:out value='${endDate}'/>" class="form-control <c:if test='${not empty error}'>is-invalid</c:if>">
                        <div id="endDateFeedback" class="invalid-feedback">
                            The “To” date must not be earlier than the “From” date.
                        </div>
                    </div>
                    <div class="col-md-2 d-flex gap-1">
                        <button type="submit" class="btn btn-gold flex-grow-1" id="filterBtn">Filter</button>
                        <c:if test="${not empty startDate || not empty endDate}">
                            <a href="<c:url value='/history?accountId=${selectedAccountId}'/>" class="btn btn-outline-secondary" title="Reset date filter">
                                <i class="bi bi-x-lg"></i>
                            </a>
                        </c:if>
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
<script>
(function() {
    var startDateInput = document.getElementById('startDateInput');
    var endDateInput = document.getElementById('endDateInput');
    var filterForm = document.getElementById('historyFilterForm');
    var clientAlert = document.getElementById('clientDateAlert');
    var clientAlertMsg = document.getElementById('clientDateAlertMsg');
    var endDateFeedback = document.getElementById('endDateFeedback');

    window.hideClientError = function() {
        if (clientAlert) clientAlert.classList.add('d-none');
        if (endDateInput) endDateInput.classList.remove('is-invalid');
    };

    function showDateError(message) {
        if (clientAlertMsg) clientAlertMsg.textContent = message;
        if (clientAlert) clientAlert.classList.remove('d-none');
        if (endDateFeedback) endDateFeedback.textContent = message;
        if (endDateInput) {
            endDateInput.classList.add('is-invalid');
            endDateInput.focus();
        }
    }

    function syncDateConstraints() {
        if (!startDateInput || !endDateInput) return;

        var fromVal = startDateInput.value ? startDateInput.value.trim() : '';
        var toVal = endDateInput.value ? endDateInput.value.trim() : '';

        // If a From date is selected, set min on To date so earlier dates cannot be picked
        if (fromVal) {
            endDateInput.min = fromVal;
        } else {
            endDateInput.removeAttribute('min');
        }

        // If user already had or entered a To date earlier than From date, prevent it
        if (fromVal && toVal && toVal < fromVal) {
            endDateInput.value = '';
            showDateError('The “To” date cannot be earlier than the “From” date. Please select ' + fromVal + ' or a later date.');
            return false;
        } else {
            hideClientError();
            return true;
        }
    }

    // Initialize on page load
    if (startDateInput && endDateInput) {
        if (startDateInput.value) {
            endDateInput.min = startDateInput.value.trim();
        }

        // Validate immediately if both values already present
        if (startDateInput.value && endDateInput.value && endDateInput.value.trim() < startDateInput.value.trim()) {
            endDateInput.value = '';
            showDateError('The “To” date must not be earlier than the “From” date.');
        }

        // Handle From date selection
        startDateInput.addEventListener('change', function() {
            syncDateConstraints();
        });
        startDateInput.addEventListener('input', function() {
            syncDateConstraints();
        });

        // Handle To date selection
        endDateInput.addEventListener('change', function() {
            var fromVal = startDateInput.value ? startDateInput.value.trim() : '';
            var toVal = endDateInput.value ? endDateInput.value.trim() : '';

            if (fromVal && toVal && toVal < fromVal) {
                endDateInput.value = '';
                showDateError('The “To” date cannot be earlier than the “From” date. Please select ' + fromVal + ' or a later date.');
            } else {
                hideClientError();
            }
        });
        endDateInput.addEventListener('input', function() {
            var fromVal = startDateInput.value ? startDateInput.value.trim() : '';
            var toVal = endDateInput.value ? endDateInput.value.trim() : '';

            if (fromVal && toVal && toVal < fromVal) {
                endDateInput.value = '';
                showDateError('The “To” date cannot be earlier than the “From” date. Please select ' + fromVal + ' or a later date.');
            } else {
                hideClientError();
            }
        });
    }

    // Prevent form submission if dates violate validation rule
    if (filterForm) {
        filterForm.addEventListener('submit', function(e) {
            if (startDateInput && endDateInput) {
                var fromVal = startDateInput.value ? startDateInput.value.trim() : '';
                var toVal = endDateInput.value ? endDateInput.value.trim() : '';

                if (fromVal && toVal && toVal < fromVal) {
                    e.preventDefault();
                    e.stopPropagation();
                    showDateError('The “To” date must not be earlier than the “From” date.');
                    return false;
                }
            }
        });
    }

    window.onAccountChange = function(selectEl) {
        if (startDateInput && endDateInput) {
            var fromVal = startDateInput.value ? startDateInput.value.trim() : '';
            var toVal = endDateInput.value ? endDateInput.value.trim() : '';
            if (fromVal && toVal && toVal < fromVal) {
                endDateInput.value = '';
            }
        }
        selectEl.form.submit();
    };
})();
</script>
</body>
</html>
