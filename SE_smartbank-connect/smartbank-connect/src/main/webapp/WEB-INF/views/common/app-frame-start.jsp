<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <title>${empty pageTitle ? 'SmartBank Connect' : pageTitle} | SmartBank Connect</title>
    <jsp:include page="/WEB-INF/views/common/app-head.jsp"/>
</head>
<body>
<div class="sb-shell">
    <jsp:include page="/WEB-INF/views/common/sidebar.jsp"/>
    <div class="sb-main">
        <div class="sb-topbar">
            <h5 class="mb-0">${empty pageTitle ? 'SmartBank Connect' : pageTitle}</h5>
            <div class="d-flex align-items-center gap-3">
                <a href="<c:url value='/notifications'/>" class="position-relative text-decoration-none text-secondary">
                    <i class="bi bi-bell fs-5"></i>
                    <c:if test="${unreadCount > 0}">
                        <span class="position-absolute top-0 start-100 translate-middle badge rounded-pill bg-danger">${unreadCount}</span>
                    </c:if>
                </a>
                <div class="dropdown">
                    <c:set var="displayUser" value="${not empty user ? user : userDto}"/>
                    <a class="d-flex align-items-center text-decoration-none dropdown-toggle" href="#" data-bs-toggle="dropdown">
                        <span class="small fw-semibold"><c:out value="${displayUser.fullName}"/></span>
                    </a>
                    <ul class="dropdown-menu dropdown-menu-end">
                        <li><span class="dropdown-item-text small text-muted"><c:out value="${displayUser.role}"/></span></li>
                        <li><a class="dropdown-item" href="<c:url value='/customer/profile'/>">Profile</a></li>
                        <li>
                            <form action="<c:url value='/logout'/>" method="post">
                                <c:if test="${not empty _csrf}"><input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" /></c:if>
                                <button class="dropdown-item" type="submit">Log out</button>
                            </form>
                        </li>
                    </ul>
                </div>
            </div>
        </div>
        <div class="sb-content">
            <c:if test="${not empty success}"><div class="alert alert-success alert-dismissible fade show">${success}<button type="button" class="btn-close" data-bs-dismiss="alert"></button></div></c:if>
            <c:if test="${not empty error}"><div class="alert alert-danger alert-dismissible fade show">${error}<button type="button" class="btn-close" data-bs-dismiss="alert"></button></div></c:if>
