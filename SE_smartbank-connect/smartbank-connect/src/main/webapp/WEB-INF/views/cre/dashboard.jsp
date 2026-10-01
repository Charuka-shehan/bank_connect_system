<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Customer Relations" scope="request"/>
<jsp:include page="../common/app-frame-start.jsp"/>

<form class="sb-card mb-4 row g-2" method="get">
    <div class="col-md-9"><input class="form-control" name="q" value="${query}" placeholder="Search customers"></div>
    <div class="col-md-3"><button class="btn btn-primary w-100">Search</button></div>
</form>

<div class="row g-4">
    <div class="col-lg-6">
        <div class="sb-card mb-4">
            <h6 class="mb-3">New enquiry / ticket</h6>
            <form method="post" action="<c:url value='/cre/tickets'/>">
                <c:if test="${not empty _csrf}"><input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" /></c:if>
                <select name="customerId" class="form-select mb-2" required>
                    <option value="">Select customer</option>
                    <c:forEach var="cust" items="${customers}">
                        <option value="${cust.id}">${cust.fullName} (${cust.email})</option>
                    </c:forEach>
                </select>
                <input class="form-control mb-2" name="subject" placeholder="Subject" required>
                <textarea class="form-control mb-2" name="message" placeholder="Details" required></textarea>
                <button class="btn btn-primary btn-sm">Create ticket</button>
            </form>
        </div>
        <div class="sb-card mb-4">
            <h6 class="mb-3">Support tickets</h6>
            <c:forEach var="t" items="${tickets}">
                <div class="border-bottom py-2">
                    <strong><c:out value="${t.ticketNumber}"/></strong> — <c:out value="${t.subject}"/>
                    <span class="badge bg-secondary"><c:out value="${t.status}"/></span>
                    <div class="small text-muted"><c:out value="${t.customer.fullName}"/></div>
                    <form class="d-flex gap-2 mt-1" method="post" action="<c:url value='/cre/tickets/${t.id}/status'/>">
                        <c:if test="${not empty _csrf}"><input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" /></c:if>
                        <select name="status" class="form-select form-select-sm">
                            <option>OPEN</option><option>IN_PROGRESS</option><option>RESOLVED</option>
                        </select>
                        <input class="form-control form-control-sm" name="resolution" placeholder="Resolution">
                        <button class="btn btn-sm btn-outline-primary">Update</button>
                    </form>
                </div>
            </c:forEach>
        </div>
    </div>
    <div class="col-lg-6">
        <div class="sb-card mb-4">
            <h6 class="mb-3">Statement request</h6>
            <form method="post" action="<c:url value='/cre/statements'/>">
                <c:if test="${not empty _csrf}"><input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" /></c:if>
                <select name="customerId" class="form-select mb-2" required>
                    <option value="">Customer</option>
                    <c:forEach var="cust" items="${customers}">
                        <option value="${cust.id}">${cust.fullName}</option>
                    </c:forEach>
                </select>
                <input class="form-control mb-2" name="accountId" placeholder="Account ID" required>
                <div class="row g-2 mb-2">
                    <div class="col"><input type="date" class="form-control" name="periodFrom" required></div>
                    <div class="col"><input type="date" class="form-control" name="periodTo" required></div>
                </div>
                <button class="btn btn-sm btn-primary">Log request</button>
            </form>
            <table class="table mt-3">
                <c:forEach var="s" items="${statements}">
                    <tr>
                        <td><c:out value="${s.account.accountNumber}"/></td>
                        <td><c:out value="${s.status}"/></td>
                        <td>
                            <c:if test="${s.status == 'PENDING'}">
                                <form method="post" action="<c:url value='/cre/statements/${s.id}/complete'/>">
                                    <c:if test="${not empty _csrf}"><input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" /></c:if>
                                    <button class="btn btn-sm btn-success">Complete</button>
                                </form>
                            </c:if>
                        </td>
                    </tr>
                </c:forEach>
            </table>
        </div>
        <div class="sb-card">
            <h6 class="mb-3">Communication log</h6>
            <form method="post" action="<c:url value='/cre/communications'/>" class="mb-3">
                <c:if test="${not empty _csrf}"><input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" /></c:if>
                <select name="customerId" class="form-select mb-2" required>
                    <option value="">Customer</option>
                    <c:forEach var="cust" items="${customers}">
                        <option value="${cust.id}">${cust.fullName}</option>
                    </c:forEach>
                </select>
                <select name="channel" class="form-select mb-2">
                    <option>PHONE</option><option>EMAIL</option><option>IN_BRANCH</option>
                </select>
                <input class="form-control mb-2" name="summary" placeholder="Summary" required>
                <button class="btn btn-sm btn-outline-primary">Log communication</button>
            </form>
            <ul class="list-unstyled small">
                <c:forEach var="log" items="${communications}">
                    <li class="border-bottom py-2"><c:out value="${log.createdAt}"/> — <c:out value="${log.customer.fullName}"/> via <c:out value="${log.channel}"/>: <c:out value="${log.summary}"/></li>
                </c:forEach>
            </ul>
        </div>
    </div>
</div>

<jsp:include page="../common/app-frame-end.jsp"/>
