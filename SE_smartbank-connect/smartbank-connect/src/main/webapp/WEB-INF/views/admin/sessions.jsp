<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Active Sessions" scope="request"/>
<jsp:include page="../common/app-frame-start.jsp"/>

<c:if test="${not empty success}"><div class="alert alert-success alert-dismissible fade show py-2 mb-3" role="alert"><c:out value="${success}"/><button type="button" class="btn-close" data-bs-dismiss="alert"></button></div></c:if>
<c:if test="${not empty error}"><div class="alert alert-danger alert-dismissible fade show py-2 mb-3" role="alert"><c:out value="${error}"/><button type="button" class="btn-close" data-bs-dismiss="alert"></button></div></c:if>

<p class="text-muted">Configured idle timeout: ${timeoutMinutes} minutes. Concurrent sessions are limited to 1 per user.</p>

<div class="sb-card mb-4">
    <h6 class="mb-3"><i class="bi bi-shield-lock text-primary me-2"></i>Active Sessions</h6>
    <div class="table-responsive">
        <table class="table align-middle">
            <thead>
                <tr>
                    <th>User / Principal</th>
                    <th>Session ID</th>
                    <th>Last Active</th>
                    <th class="text-end">Action</th>
                </tr>
            </thead>
            <tbody>
            <c:forEach var="s" items="${sessions}">
                <tr>
                    <td class="fw-medium"><c:out value="${s.principal}"/></td>
                    <td class="font-monospace small"><c:out value="${s.sessionId}"/></td>
                    <td class="small text-muted"><c:out value="${s.lastRequest}"/></td>
                    <td class="text-end">
                        <form method="post" action="<c:url value='/admin/sessions/expire'/>" class="d-inline"
                              onsubmit="return confirm('Expire this session immediately?');">
                            <c:if test="${not empty _csrf}"><input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" /></c:if>
                            <input type="hidden" name="sessionId" value="${s.sessionId}">
                            <button type="submit" class="btn btn-sm btn-outline-danger"><i class="bi bi-box-arrow-right me-1"></i>Expire</button>
                        </form>
                    </td>
                </tr>
            </c:forEach>
            <c:if test="${empty sessions}">
                <tr><td colspan="4" class="text-muted text-center py-3">No active sessions tracked in session registry.</td></tr>
            </c:if>
            </tbody>
        </table>
    </div>
</div>

<div class="sb-card">
    <h6 class="mb-3"><i class="bi bi-person-check text-secondary me-2"></i>Registered Principals</h6>
    <c:forEach var="p" items="${principals}">
        <div class="border-bottom py-2">
            <strong><c:out value="${p}"/></strong>
        </div>
    </c:forEach>
    <c:if test="${empty principals}"><p class="text-muted mb-0">No active principals.</p></c:if>
</div>

<jsp:include page="../common/app-frame-end.jsp"/>
