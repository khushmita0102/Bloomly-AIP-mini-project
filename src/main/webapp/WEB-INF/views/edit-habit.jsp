<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit Habit &#8212; Bloomly</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/assets/images/bloomly-logo.png">
</head>
<body>
<div class="app-container">

    <aside class="sidebar">
        <div class="sidebar-header">
            <div class="logo-container">
                <img
                    class="logo-img"
                    src="${pageContext.request.contextPath}/assets/images/bloomly-logo.png"
                    alt="Bloomly logo"
                    width="130"
                    height="130"
                />
                <p class="logo-tagline"><i>Your little space to grow </i></p>
            </div>
        </div>
        <nav class="sidebar-nav">
            <div class="nav-label">Main</div>
            <a href="${pageContext.request.contextPath}/dashboard" class="nav-link">
                <span class="nav-icon">&#9632;</span> Dashboard
            </a>
            <a href="${pageContext.request.contextPath}/addHabit" class="nav-link">
                <span class="nav-icon">&#43;</span> Add Habit
            </a>
            <div class="nav-label">Reports</div>
            <a href="${pageContext.request.contextPath}/history" class="nav-link">
                <span class="nav-icon">&#128197;</span> Habit History
            </a>
            <div class="nav-label">Info</div>
            <a href="${pageContext.request.contextPath}/about" class="nav-link">
                <span class="nav-icon">&#128218;</span> About Project
            </a>
        </nav>
    </aside>

    <main class="main-content">
        <div class="page-header">
            <h1>Edit Habit &#9998;</h1>
            <p class="page-subtitle">Update the details for this habit.</p>
        </div>

        <c:if test="${not empty errorMessage}">
            <div class="alert alert-error">
                <span>&#9888;</span>
                <c:out value="${errorMessage}"/>
            </div>
        </c:if>

        <div class="form-card">
            <form action="${pageContext.request.contextPath}/updateHabit"
                  method="post" novalidate>

                <input type="hidden" name="id" value="${habit.id}">

                <div class="form-group">
                    <label class="form-label" for="name">
                        Habit Name <span class="required">*</span>
                    </label>
                    <input type="text" id="name" name="name"
                           class="form-control" maxlength="200"
                           value="${fn:escapeXml(habit.name)}" required>
                </div>

                <div class="form-group">
                    <label class="form-label" for="description">Description</label>
                    <textarea id="description" name="description"
                              class="form-control" maxlength="500"
                              rows="3">${fn:escapeXml(habit.description)}</textarea>
                    <div class="form-hint">Optional.</div>
                </div>

                <div class="form-group">
                    <label class="form-label" for="category">
                        Category <span class="required">*</span>
                    </label>
                    <select id="category" name="category" class="form-control" required>
                        <option value="Health"       ${habit.category == 'Health'       ? 'selected' : ''}>&#129380; Health</option>
                        <option value="Study"        ${habit.category == 'Study'        ? 'selected' : ''}>&#128218; Study</option>
                        <option value="Fitness"      ${habit.category == 'Fitness'      ? 'selected' : ''}>&#128170; Fitness</option>
                        <option value="Productivity" ${habit.category == 'Productivity' ? 'selected' : ''}>&#9889; Productivity</option>
                        <option value="Personal"     ${habit.category == 'Personal'     ? 'selected' : ''}>&#127775; Personal</option>
                    </select>
                </div>

                <div class="form-group">
                    <label class="form-label" for="frequency">
                        Frequency <span class="required">*</span>
                    </label>
                    <select id="frequency" name="frequency" class="form-control" required>
                        <option value="Daily"  ${habit.frequency == 'Daily'  ? 'selected' : ''}>&#128197; Daily</option>
                        <option value="Weekly" ${habit.frequency == 'Weekly' ? 'selected' : ''}>&#128336; Weekly</option>
                    </select>
                </div>

                <div class="form-actions">
                    <button type="submit" class="btn btn-primary">&#128190; Save Changes</button>
                    <a href="${pageContext.request.contextPath}/dashboard"
                       class="btn btn-outline">Cancel</a>
                </div>
            </form>
        </div>
    </main>

    <aside class="buddy-panel">
        <div class="buddy-card">
            <div class="buddy-image-wrap">
                <img src="${pageContext.request.contextPath}/assets/images/habit-buddy.png"
                     alt="Habit Buddy mascot"/>
            </div>
            <div class="buddy-name">Habit Buddy &#127804;</div>
            <div class="buddy-messages">
                <div class="buddy-msg">&#9997; Tweaking your habit<br>is growth too!</div>
                <div class="buddy-msg">&#127807; Small updates,<br>big results!</div>
                <div class="buddy-msg">&#10024; Make it yours &#8212;<br>you know best!</div>
                <div class="buddy-msg">&#127919; Keep refining,<br>keep shining!</div>
            </div>
            <div class="buddy-tip">&#10024; Your cheerleader</div>
        </div>
    </aside>

</div>
</body>
</html>
