<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Habit History &#8212; Bloomly</title>
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
            <a href="${pageContext.request.contextPath}/history" class="nav-link active">
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
            <h1>Habit History &#128197;</h1>
            <p class="page-subtitle">Review your completion record for any date.</p>
        </div>

        <%-- Date filter --%>
        <div class="history-filter">
            <label for="historyDate">View history for:</label>
            <form action="${pageContext.request.contextPath}/history" method="get"
                  style="display:flex; gap:10px; align-items:center; flex-wrap:wrap;">
                <input type="date" id="historyDate" name="date"
                       value="${selectedDate}" max="${today}">
                <button type="submit" class="btn btn-primary btn-sm">View</button>
            </form>
            <span style="font-size:0.84rem; color:#718096;">
                Showing: <strong><c:out value="${formattedDate}"/></strong>
            </span>
        </div>

        <%-- Summary stats --%>
        <div class="stats-grid" style="margin-bottom:18px;">
            <div class="stat-card">
                <div class="stat-icon blue">&#128203;</div>
                <div class="stat-body">
                    <div class="stat-value"><c:out value="${historyData.totalCount}"/></div>
                    <div class="stat-label">Total Habits</div>
                </div>
            </div>
            <div class="stat-card">
                <div class="stat-icon green">&#10003;</div>
                <div class="stat-body">
                    <div class="stat-value"><c:out value="${historyData.completedCount}"/></div>
                    <div class="stat-label">Completed</div>
                </div>
            </div>
            <div class="stat-card">
                <div class="stat-icon orange">&#9201;</div>
                <div class="stat-body">
                    <div class="stat-value"><c:out value="${historyData.percent}"/>%</div>
                    <div class="stat-label">Completion Rate</div>
                </div>
            </div>
        </div>

        <%-- Progress bar --%>
        <div class="progress-section" style="margin-bottom:22px;">
            <div class="progress-header">
                <span class="progress-title">Completion Progress</span>
                <span class="progress-pct"><c:out value="${historyData.percent}"/>%</span>
            </div>
            <div class="progress-bar-track">
                <div class="progress-bar-fill"
                     style="width: ${historyData.percent}%;"></div>
            </div>
        </div>

        <%-- Habits table --%>
        <div class="section-title-row">
            <span class="section-title">
                Habit Status on <c:out value="${formattedDate}"/>
            </span>
        </div>

        <c:choose>
            <c:when test="${empty historyData.allHabits}">
                <div class="empty-state">
                    <div class="empty-icon">&#128197;</div>
                    <h3>No habits found.</h3>
                    <p>You haven&#8217;t added any habits yet.</p>
                    <a href="${pageContext.request.contextPath}/addHabit"
                       class="btn btn-primary">&#43; Add a Habit</a>
                </div>
            </c:when>
            <c:otherwise>
                <div class="history-table-wrap">
                    <table class="history-table">
                        <thead>
                            <tr>
                                <th>#</th>
                                <th>Habit Name</th>
                                <th>Category</th>
                                <th>Frequency</th>
                                <th>Status</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:set var="rowNum" value="0"/>
                            <c:forEach var="habit" items="${historyData.allHabits}">
                                <c:set var="rowNum" value="${rowNum + 1}"/>

                                <c:set var="habitDone" value="false" scope="page"/>
                                <c:forEach var="comp" items="${historyData.completions}">
                                    <c:if test="${comp.habit.id == habit.id and comp.completed}">
                                        <c:set var="habitDone" value="true" scope="page"/>
                                    </c:if>
                                </c:forEach>

                                <%-- Category badge class --%>
                                <c:choose>
                                    <c:when test="${habit.category eq 'Health'}">
                                        <c:set var="hCatClass" value="badge badge-cat-health" scope="page"/>
                                    </c:when>
                                    <c:when test="${habit.category eq 'Fitness'}">
                                        <c:set var="hCatClass" value="badge badge-cat-fitness" scope="page"/>
                                    </c:when>
                                    <c:when test="${habit.category eq 'Study'}">
                                        <c:set var="hCatClass" value="badge badge-cat-study" scope="page"/>
                                    </c:when>
                                    <c:when test="${habit.category eq 'Productivity'}">
                                        <c:set var="hCatClass" value="badge badge-cat-productivity" scope="page"/>
                                    </c:when>
                                    <c:when test="${habit.category eq 'Personal'}">
                                        <c:set var="hCatClass" value="badge badge-cat-personal" scope="page"/>
                                    </c:when>
                                    <c:otherwise>
                                        <c:set var="hCatClass" value="badge badge-category" scope="page"/>
                                    </c:otherwise>
                                </c:choose>

                                <c:set var="hFreqClass" value="${habit.frequency eq 'Daily' ? 'badge badge-freq-daily' : 'badge badge-freq-weekly'}" scope="page"/>

                                <tr>
                                    <td style="color:#A0AEC0; font-size:0.8rem;">
                                        <c:out value="${rowNum}"/>
                                    </td>
                                    <td><strong><c:out value="${habit.name}"/></strong></td>
                                    <td>
                                        <span class="${hCatClass}">
                                            <c:out value="${habit.category}"/>
                                        </span>
                                    </td>
                                    <td>
                                        <span class="${hFreqClass}">
                                            <c:out value="${habit.frequency}"/>
                                        </span>
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${habitDone}">
                                                <span class="badge badge-completed">&#10003; Completed</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge badge-pending">&#8212; Not Done</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </c:otherwise>
        </c:choose>

    </main>

    <%-- Habit Buddy --%>
    <aside class="buddy-panel">
        <div class="buddy-card">
            <div class="buddy-image-wrap">
                <img src="${pageContext.request.contextPath}/assets/images/habit-buddy.png"
                     alt="Habit Buddy mascot"/>
            </div>
            <div class="buddy-name">Habit Buddy &#127804;</div>
            <div class="buddy-messages">
                <div class="buddy-msg">&#128197; Every day counts&#8212;<br>even the small ones!</div>
                <div class="buddy-msg">&#127775; Look how far<br>you&#8217;ve come!</div>
                <div class="buddy-msg">&#9989; Progress, not<br>perfection!</div>
                <div class="buddy-msg">&#127807; Your past efforts<br>are blooming!</div>
            </div>
            <div class="buddy-tip">&#10024; Your cheerleader</div>
        </div>
    </aside>

</div>
</body>
