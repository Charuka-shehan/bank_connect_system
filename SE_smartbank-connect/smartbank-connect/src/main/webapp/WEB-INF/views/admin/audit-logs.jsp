<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <title>Audit Logs | SmartBank Connect</title>
    <jsp:include page="../common/app-head.jsp"/>
</head>
<body>
<div class="sb-shell">
    <jsp:include page="../common/sidebar.jsp"/>
    <div class="sb-main">
        <div class="sb-topbar"><h5 class="mb-0">Audit Logs</h5></div>
        <div class="sb-content">
            <c:if test="${not empty success}"><div class="alert alert-success py-2 mb-3">${success}</div></c:if>
            <c:if test="${not empty error}"><div class="alert alert-danger py-2 mb-3">${error}</div></c:if>

            <div class="sb-card">
                <div class="d-flex justify-content-between align-items-center mb-2 flex-wrap gap-2">
                    <div>
                        <h6 class="mb-0"><i class="bi bi-journal-text text-primary me-2"></i>System Audit Trail</h6>
                        <p class="text-muted small mb-0">System-generated, immutable log of all sensitive actions across every module.</p>
                    </div>
                    <div class="d-flex gap-2">
                        <a href="<c:url value='/reports/audit/logs'/>" target="_blank" class="btn btn-sm btn-outline-primary">
                            <i class="bi bi-file-earmark-pdf me-1"></i>PDF
                        </a>
                        <a href="<c:url value='/reports/audit/logs/csv'/>" class="btn btn-sm btn-outline-success">
                            <i class="bi bi-file-earmark-spreadsheet me-1"></i>CSV
                        </a>
                        <span class="badge bg-secondary align-self-center px-2 py-2">${logs.size()} entries</span>
                    </div>
                </div>

                <!-- Search and Filter Bar -->
                <div class="row g-2 mb-3 mt-1">
                    <div class="col-md-5">
                        <div class="input-group input-group-sm">
                            <span class="input-group-text"><i class="bi bi-search"></i></span>
                            <input type="text" id="auditSearchInput" class="form-control" placeholder="Search actor, action, details..." onkeyup="filterAuditLogs()">
                        </div>
                    </div>
                    <div class="col-md-4">
                        <select id="actionFilterSelect" class="form-select form-select-sm" onchange="filterAuditLogs()">
                            <option value="">All Actions</option>
                            <option value="LOGIN">LOGIN</option>
                            <option value="ACCOUNT">ACCOUNT Actions</option>
                            <option value="TRANSFER">TRANSFER Actions</option>
                            <option value="LOAN">LOAN Actions</option>
                            <option value="APPROVAL">APPROVAL Actions</option>
                            <option value="CUSTOMER">CUSTOMER Actions</option>
                            <option value="STAFF">STAFF Actions</option>
                            <option value="BRANCH">BRANCH Actions</option>
                        </select>
                    </div>
                    <div class="col-md-3 text-end">
                        <button class="btn btn-sm btn-outline-secondary w-100" onclick="resetAuditFilters()"><i class="bi bi-arrow-counterclockwise me-1"></i>Reset</button>
                    </div>
                </div>

                <div class="table-responsive">
                    <table class="table table-sm align-middle" id="auditLogTable">
                        <thead><tr><th>Timestamp</th><th>Actor</th><th>Action</th><th>Entity</th><th>Details</th><th class="text-end">Action</th></tr></thead>
                        <tbody>
                        <c:forEach var="log" items="${logs}">
                            <tr class="audit-row" data-action="${log.action}">
                                <td style="white-space: nowrap;">${log.timestamp}</td>
                                <td>${log.actorEmail != null ? log.actorEmail : 'SYSTEM'}</td>
                                <td><span class="badge bg-secondary">${log.action}</span></td>
                                <td>${log.entityType} #${log.entityId}</td>
                                <td class="small">${log.details}</td>
                                <td class="text-end">
                                    <form action="<c:url value='/admin/audit-logs/${log.id}/request-delete'/>" method="post" class="d-inline"
                                          onsubmit="var r = prompt('Reason for audit log deletion:'); if (!r) return false; this.querySelector('input[name=reason]').value = r;">
                                        <c:if test="${not empty _csrf}"><input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" /></c:if>
                                        <input type="hidden" name="reason" value="">
                                        <button type="submit" class="btn btn-sm btn-outline-danger py-0" title="Request Deletion">
                                            <i class="bi bi-trash"></i>
                                        </button>
                                    </form>
                                </td>
                            </tr>
                        </c:forEach>
                        <c:if test="${empty logs}"><tr><td colspan="6" class="text-muted text-center py-3">No audit entries yet.</td></tr></c:if>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script>
function filterAuditLogs() {
    const search = document.getElementById('auditSearchInput').value.toLowerCase().trim();
    const actionFilter = document.getElementById('actionFilterSelect').value.toUpperCase();
    const rows = document.querySelectorAll('#auditLogTable tbody tr.audit-row');

    rows.forEach(row => {
        const text = row.innerText.toLowerCase();
        const action = (row.getAttribute('data-action') || '').toUpperCase();
        const matchesSearch = !search || text.includes(search);
        const matchesAction = !actionFilter || action.includes(actionFilter);

        row.style.display = (matchesSearch && matchesAction) ? '' : 'none';
    });
}

function resetAuditFilters() {
    document.getElementById('auditSearchInput').value = '';
    document.getElementById('actionFilterSelect').value = '';
    filterAuditLogs();
}
</script>
</body>
</html>
