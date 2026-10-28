<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Add Habit &#8212; Bloomly</title>
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
            <a href="${pageContext.request.contextPath}/addHabit" class="nav-link active">
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
            <h1>Add New Habit &#43;</h1>
            <p class="page-subtitle">Define a habit you want to build consistently.</p>
        </div>

        <c:if test="${not empty errorMessage}">
            <div class="alert alert-error">
                <span>&#9888;</span>
                <c:out value="${errorMessage}"/>
            </div>
        </c:if>

        <div class="form-card">
            <form action="${pageContext.request.contextPath}/addHabit"
                  method="post" novalidate>

                <div class="form-group">
                    <label class="form-label" for="name">
                        Habit Name <span class="required">*</span>
                    </label>
                    <input type="text" id="name" name="name"
                           class="form-control" maxlength="200"
                           placeholder="e.g. Drink 2 litres of water"
                           value="${fn:escapeXml(name)}" required>
                    <div class="form-hint">Max 200 characters.</div>
                </div>

                <div class="form-group">
                    <label class="form-label" for="description">Description</label>
                    <textarea id="description" name="description"
                              class="form-control" maxlength="500"
                              placeholder="Optional &#8212; add a short note about this habit"
                              rows="3">${fn:escapeXml(description)}</textarea>
                    <div class="form-hint">Max 500 characters. Optional.</div>
                </div>

                <div class="form-group">
                    <label class="form-label" for="category">
                        Category <span class="required">*</span>
                    </label>
                    <select id="category" name="category" class="form-control" required>
                        <option value="" disabled ${empty category ? 'selected' : ''}>Select a category</option>
                        <option value="Health"       ${category == 'Health'       ? 'selected' : ''}>&#129380; Health</option>
                        <option value="Study"        ${category == 'Study'        ? 'selected' : ''}>&#128218; Study</option>
                        <option value="Fitness"      ${category == 'Fitness'      ? 'selected' : ''}>&#128170; Fitness</option>
                        <option value="Productivity" ${category == 'Productivity' ? 'selected' : ''}>&#9889; Productivity</option>
                        <option value="Personal"     ${category == 'Personal'     ? 'selected' : ''}>&#127775; Personal</option>
                    </select>
                </div>

                <div class="form-group">
                    <label class="form-label" for="frequency">
                        Frequency <span class="required">*</span>
                    </label>
                    <select id="frequency" name="frequency" class="form-control" required>
                        <option value="" disabled ${empty frequency ? 'selected' : ''}>Select frequency</option>
                        <option value="Daily"  ${frequency == 'Daily'  ? 'selected' : ''}>&#128197; Daily</option>
                        <option value="Weekly" ${frequency == 'Weekly' ? 'selected' : ''}>&#128336; Weekly</option>
                    </select>
                </div>

                <div class="form-actions">
                    <button type="submit" class="btn btn-primary">&#43; Save Habit</button>
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
                <div class="buddy-msg">&#127807; A new habit starts<br>with a single step!</div>
                <div class="buddy-msg">&#9997; Write it down,<br>make it real!</div>
                <div class="buddy-msg">&#127775; Small habits,<br>big impact!</div>
                <div class="buddy-msg">&#127919; Name it, claim it,<br>build it!</div>
            </div>
            <div class="buddy-tip">&#10024; You&#8217;re doing great</div>
        </div>
    </aside>

</div>
</body>
</html>
