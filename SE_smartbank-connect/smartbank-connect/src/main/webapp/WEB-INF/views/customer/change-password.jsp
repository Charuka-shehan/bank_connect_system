<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <title>Change Password | SmartBank Connect</title>
    <jsp:include page="../common/app-head.jsp"/>
</head>
<body>
<div class="sb-shell">
    <jsp:include page="../common/sidebar.jsp"/>
    <div class="sb-main">
        <div class="sb-topbar"><h5 class="mb-0"><i class="bi bi-key me-2"></i>Change Password</h5></div>
        <div class="sb-content">
            <c:if test="${not empty success}">
                <div class="alert alert-success alert-dismissible fade show" role="alert">
                    <i class="bi bi-check-circle me-2"></i><c:out value="${success}"/>
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            </c:if>
            <c:if test="${not empty error}">
                <div class="alert alert-danger alert-dismissible fade show text-danger" role="alert">
                    <i class="bi bi-exclamation-triangle me-2"></i><c:out value="${error}"/>
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            </c:if>

            <div class="sb-card" style="max-width: 560px;">
                <form id="changePwForm" method="post" action="<c:url value='/customer/change-password'/>" class="row g-3" novalidate>
                    <c:if test="${not empty _csrf}"><input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" /></c:if>
                    
                    <div class="col-12">
                        <label class="form-label" for="currentPassword">Current Password <span class="text-danger">*</span></label>
                        <input type="password" class="form-control" name="currentPassword" id="currentPassword" required>
                        <div class="invalid-feedback text-danger" id="currentPwError">Current password is required.</div>
                    </div>

                    <div class="col-12">
                        <label class="form-label" for="newPassword">New Password <span class="text-danger">*</span></label>
                        <input type="password" class="form-control" name="newPassword" id="newPassword" minlength="8" required>
                        <div class="invalid-feedback text-danger" id="newPwError">Password must meet all security requirements below.</div>
                        <div class="mt-2 small" id="pwRules">
                            <div id="ruleLength" class="text-muted"><i class="bi bi-circle me-1"></i> At least 8 characters</div>
                            <div id="ruleUpper" class="text-muted"><i class="bi bi-circle me-1"></i> At least one uppercase letter (A-Z)</div>
                            <div id="ruleLower" class="text-muted"><i class="bi bi-circle me-1"></i> At least one lowercase letter (a-z)</div>
                            <div id="ruleDigit" class="text-muted"><i class="bi bi-circle me-1"></i> At least one digit (0-9)</div>
                            <div id="ruleSpecial" class="text-muted"><i class="bi bi-circle me-1"></i> At least one special character (@$!%*?&#)</div>
                        </div>
                    </div>

                    <div class="col-12">
                        <label class="form-label" for="confirmPassword">Confirm New Password <span class="text-danger">*</span></label>
                        <input type="password" class="form-control" name="confirmPassword" id="confirmPassword" minlength="8" required>
                        <div class="invalid-feedback text-danger" id="matchError">New passwords do not match.</div>
                        <div id="matchSuccess" class="text-success small mt-1" style="display:none;"><i class="bi bi-check-circle me-1"></i> Passwords match!</div>
                    </div>

                    <div class="col-12">
                        <button type="submit" class="btn btn-gold py-2"><i class="bi bi-shield-lock me-1"></i> Update Password</button>
                        <a href="<c:url value='/customer/profile'/>" class="btn btn-outline-secondary ms-2">Back to Profile</a>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script>
const pw = document.getElementById('newPassword');
const cpw = document.getElementById('confirmPassword');
const curPw = document.getElementById('currentPassword');
const ruleLength = document.getElementById('ruleLength');
const ruleUpper = document.getElementById('ruleUpper');
const ruleLower = document.getElementById('ruleLower');
const ruleDigit = document.getElementById('ruleDigit');
const ruleSpecial = document.getElementById('ruleSpecial');
const matchError = document.getElementById('matchError');
const matchSuccess = document.getElementById('matchSuccess');

function updateRule(el, valid) {
    if (valid) {
        el.className = 'text-success';
        el.innerHTML = '<i class="bi bi-check-circle-fill me-1"></i>' + el.textContent.trim();
    } else {
        el.className = 'text-danger';
        el.innerHTML = '<i class="bi bi-x-circle-fill me-1"></i>' + el.textContent.trim();
    }
}

pw.addEventListener('input', function() {
    const val = pw.value;
    updateRule(ruleLength, val.length >= 8);
    updateRule(ruleUpper, /[A-Z]/.test(val));
    updateRule(ruleLower, /[a-z]/.test(val));
    updateRule(ruleDigit, /[0-9]/.test(val));
    updateRule(ruleSpecial, /[@$!%*?&#]/.test(val));
    checkMatch();
});

function checkMatch() {
    if (!cpw.value) {
        matchSuccess.style.display = 'none';
        cpw.classList.remove('is-invalid');
        return;
    }
    if (pw.value === cpw.value) {
        matchSuccess.style.display = 'block';
        cpw.classList.remove('is-invalid');
    } else {
        matchSuccess.style.display = 'none';
        cpw.classList.add('is-invalid');
    }
}

cpw.addEventListener('input', checkMatch);

document.getElementById('changePwForm').addEventListener('submit', function(e) {
    let valid = true;

    if (!curPw.value) {
        curPw.classList.add('is-invalid');
        valid = false;
    } else {
        curPw.classList.remove('is-invalid');
    }

    const val = pw.value;
    const isPwValid = val.length >= 8 && /[A-Z]/.test(val) && /[a-z]/.test(val) && /[0-9]/.test(val) && /[@$!%*?&#]/.test(val);
    
    if (!isPwValid) {
        pw.classList.add('is-invalid');
        valid = false;
    } else {
        pw.classList.remove('is-invalid');
    }

    if (val !== cpw.value || !cpw.value) {
        cpw.classList.add('is-invalid');
        valid = false;
    } else {
        cpw.classList.remove('is-invalid');
    }

    if (!valid) {
        e.preventDefault();
        return false;
    }

    if (!confirm('Are you sure you want to change your password?')) {
        e.preventDefault();
        return false;
    }
});
</script>
</body>
</html>
