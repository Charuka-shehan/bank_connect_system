<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Branches" scope="request"/>
<jsp:include page="../common/app-frame-start.jsp"/>

<div class="sb-card mb-4" style="max-width:520px;">
    <h6 class="mb-3">Add branch</h6>
    <form method="post" action="<c:url value='/branches'/>">
        <c:if test="${not empty _csrf}"><input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" /></c:if>
        <input class="form-control mb-2" name="code" placeholder="Code (e.g. JFN-BR)" required>
        <input class="form-control mb-2" name="name" placeholder="Name" required>
        <input class="form-control mb-2" name="address" placeholder="Address" required>
        <button class="btn btn-primary">Create</button>
    </form>
</div>

<div class="sb-card">
    <div class="table-responsive">
        <table class="table align-middle">
            <thead><tr><th style="width: 15%;">Code</th><th style="width: 35%;">Name</th><th style="width: 35%;">Address</th><th class="text-end" style="width: 15%;">Action</th></tr></thead>
            <tbody>
            <c:forEach var="b" items="${branches}">
                <tr>
                    <td class="fw-semibold"><span class="badge bg-secondary"><c:out value="${b.code}"/></span></td>
                    <td>
                        <input form="branchForm_${b.id}" class="form-control form-control-sm" name="name" value="<c:out value='${b.name}'/>" required>
                    </td>
                    <td>
                        <input form="branchForm_${b.id}" class="form-control form-control-sm" name="address" value="<c:out value='${b.address}'/>" required>
                    </td>
                    <td class="text-end">
                        <form id="branchForm_${b.id}" method="post" action="<c:url value='/branches/${b.id}'/>" class="d-inline">
                            <c:if test="${not empty _csrf}"><input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" /></c:if>
                            <button type="submit" class="btn btn-sm btn-outline-primary"><i class="bi bi-check-lg me-1"></i>Save</button>
                        </form>
                        <form method="post" action="<c:url value='/branches/${b.id}/delete'/>" class="d-inline"
                              onsubmit="return confirm('Are you sure you want to delete branch ${b.code} - ${b.name}?');">
                            <c:if test="${not empty _csrf}"><input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" /></c:if>
                            <button type="submit" class="btn btn-sm btn-outline-danger"><i class="bi bi-trash"></i></button>
                        </form>
                    </td>
                </tr>
            </c:forEach>
            <c:if test="${empty branches}">
                <tr><td colspan="4" class="text-muted text-center py-3">No branches found.</td></tr>
            </c:if>
            </tbody>
        </table>
    </div>
</div>

<jsp:include page="../common/app-frame-end.jsp"/>
