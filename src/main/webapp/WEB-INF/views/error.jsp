<%@ page contentType="text/html;charset=UTF-8" language="java" isErrorPage="true" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Error &#8212; Bloomly</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/assets/images/bloomly-logo.png">
</head>
<body>
<div class="app-container">
    <aside class="sidebar">
        <div class="sidebar-header">
            <div class="sidebar-logo">
                <img class="logo-img"
                     src="${pageContext.request.contextPath}/assets/images/bloomly-logo.png"
                     alt="Bloomly logo"
                     width="130"
                     height="130"
                     />
                <p class="logo-tagline"><i>Your little space to grow </i></p>
            </div>
        </div>
        <nav class="sidebar-nav">
            <a href="${pageContext.request.contextPath}/dashboard" class="nav-link">
                <span class="nav-icon">&#9632;</span> Dashboard
            </a>
        </nav>
    </aside>

    <main class="main-content">
        <div class="error-page-content">
            <div class="error-code">
                <c:choose>
                    <c:when test="${pageContext.errorData.statusCode == 404}">404</c:when>
                    <c:otherwise>500</c:otherwise>
                </c:choose>
            </div>
            <h2>
                <c:choose>
                    <c:when test="${pageContext.errorData.statusCode == 404}">Page Not Found</c:when>
                    <c:otherwise>Something Went Wrong</c:otherwise>
                </c:choose>
            </h2>
            <p>
                <c:choose>
                    <c:when test="${pageContext.errorData.statusCode == 404}">
                        The page you're looking for doesn't exist.
                    </c:when>
                    <c:otherwise>
                        An error occurred. Please try again or return to the dashboard.
                    </c:otherwise>
                </c:choose>
            </p>
            <a href="${pageContext.request.contextPath}/dashboard" class="btn btn-primary">
                &#8592; Back to Dashboard
            </a>
        </div>
    </main>
</div>
</body>
</html>
