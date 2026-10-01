<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="System Settings" scope="request"/>
<jsp:include page="../common/app-frame-start.jsp"/>

<div class="sb-card" style="max-width:640px;">
    <p class="small text-muted">OTP, session and lockout values are stored in application metadata and applied on the next OTP cycle. SMTP host is read from configuration.</p>
    <form method="post" action="<c:url value='/admin/settings'/>" class="row g-3">
        <c:if test="${not empty _csrf}"><input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" /></c:if>
        <div class="col-md-4"><label class="form-label">OTP expiry (min)</label><input class="form-control" name="otpExpiryMinutes" value="${settings['otp.expiryMinutes']}"></div>
        <div class="col-md-4"><label class="form-label">OTP max attempts</label><input class="form-control" name="otpMaxAttempts" value="${settings['otp.maxAttempts']}"></div>
        <div class="col-md-4"><label class="form-label">OTP max resend</label><input class="form-control" name="otpMaxResend" value="${settings['otp.maxResend']}"></div>
        <div class="col-md-6"><label class="form-label">Session timeout (min)</label><input class="form-control" name="sessionTimeoutMinutes" value="${settings['session.timeoutMinutes']}"></div>
        <div class="col-md-6"><label class="form-label">Lock after failed logins</label><input class="form-control" name="maxFailedLogins" value="${settings['security.maxFailedLogins']}"></div>
        <div class="col-12"><label class="form-label">Mail from name</label><input class="form-control" name="mailFromName" value="${settings['mail.fromName']}"></div>
        <div class="col-12 small text-muted">SMTP: <c:out value="${mailHost}"/> · <c:out value="${mailUser}"/></div>
        <div class="col-12"><button class="btn btn-primary">Save settings</button></div>
    </form>
</div>

<jsp:include page="../common/app-frame-end.jsp"/>
