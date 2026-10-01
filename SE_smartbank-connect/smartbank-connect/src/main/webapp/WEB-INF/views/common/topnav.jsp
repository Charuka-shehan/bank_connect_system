<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<nav class="navbar navbar-expand-lg sb-navbar">
  <div class="container">
    <a class="navbar-brand" href="<c:url value='/'/>">SmartBank <span>Connect</span></a>
    <button class="navbar-toggler bg-light" type="button" data-bs-toggle="collapse" data-bs-target="#sbNav">
      <span class="navbar-toggler-icon"></span>
    </button>
    <div class="collapse navbar-collapse" id="sbNav">
      <ul class="navbar-nav ms-auto align-items-lg-center">
        <li class="nav-item"><a class="nav-link" href="<c:url value='/'/>">Home</a></li>
        <li class="nav-item"><a class="nav-link" href="<c:url value='/#workflow'/>">How It Works</a></li>
        <li class="nav-item"><a class="nav-link" href="<c:url value='/#roles'/>">Roles</a></li>
        <li class="nav-item"><a class="nav-link" href="<c:url value='/#services'/>">Services</a></li>
        <li class="nav-item"><a class="nav-link" href="<c:url value='/#about'/>">About</a></li>
        <li class="nav-item"><a class="nav-link" href="<c:url value='/#faq'/>">FAQ</a></li>
        <li class="nav-item ms-lg-2"><a class="nav-link" href="<c:url value='/login'/>">Log In</a></li>
        <li class="nav-item ms-lg-2"><a class="btn btn-gold btn-sm px-3" href="<c:url value='/register'/>">Open an Account</a></li>
      </ul>
    </div>
  </div>
</nav>
