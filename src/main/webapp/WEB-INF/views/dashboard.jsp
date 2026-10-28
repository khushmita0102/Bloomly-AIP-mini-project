<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard &#8212; Bloomly</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/assets/images/bloomly-logo.png">
</head>
<body>
<div class="app-container">

    <%-- ==================== SIDEBAR ==================== --%>
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
            <a href="${pageContext.request.contextPath}/dashboard" class="nav-link active">
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

    <%-- ==================== MAIN CONTENT ==================== --%>
    <main class="main-content">

        <%-- ---- Page Header ---- --%>
        <div class="page-header">
            <div class="header-row">
                <div>
                    <h1>Your Daily Habits &#127807;</h1>
                    <p class="page-subtitle">Stay consistent. Small steps, big results.</p>
                </div>
                <span class="page-date">&#128197; <c:out value="${formattedDate}"/></span>
            </div>
        </div>

        <%-- ---- Alerts ---- --%>
        <c:if test="${not empty param.success}">
            <div class="alert alert-success">
                <span>&#10003;</span>
                <c:out value="${param.success}"/>
            </div>
        </c:if>
        <c:if test="${not empty param.error}">
            <div class="alert alert-error">
                <span>&#9888;</span>
                <c:out value="${param.error}"/>
            </div>
        </c:if>

        <%-- ---- Stat Cards ---- --%>
        <div class="stats-grid">
            <div class="stat-card">
                <div class="stat-icon blue">&#128203;</div>
                <div class="stat-body">
                    <div class="stat-value"><c:out value="${stats.totalHabits}"/></div>
                    <div class="stat-label">Total Habits</div>
                </div>
            </div>
            <div class="stat-card">
                <div class="stat-icon green">&#10003;</div>
                <div class="stat-body">
                    <div class="stat-value"><c:out value="${stats.completedToday}"/></div>
                    <div class="stat-label">Completed Today</div>
                </div>
            </div>
            <div class="stat-card">
                <div class="stat-icon orange">&#9201;</div>
                <div class="stat-body">
                    <div class="stat-value"><c:out value="${stats.remainingToday}"/></div>
                    <div class="stat-label">Remaining</div>
                </div>
            </div>
        </div>

        <%-- ---- Progress Section ---- --%>
        <div class="progress-section">
            <div class="progress-header">
                <span class="progress-title">Today&#8217;s Progress</span>
                <span class="progress-pct"><c:out value="${stats.completionPercent}"/>%</span>
            </div>

            <%-- Motivational message based on actual completion percentage --%>
            <c:choose>
                <c:when test="${stats.completionPercent == 0}">
                    <p class="progress-motivation">&#127919; Every journey starts with one small step.</p>
                </c:when>
                <c:when test="${stats.completionPercent <= 25}">
                    <p class="progress-motivation">&#128640; You&#8217;re getting started! Keep going.</p>
                </c:when>
                <c:when test="${stats.completionPercent <= 50}">
                    <p class="progress-motivation">&#128293; You&#8217;re making progress!</p>
                </c:when>
                <c:when test="${stats.completionPercent <= 75}">
                    <p class="progress-motivation">&#11088; You&#8217;re doing great. Keep it up!</p>
                </c:when>
                <c:when test="${stats.completionPercent < 100}">
                    <p class="progress-motivation">&#127941; Almost there! You&#8217;ve got this.</p>
                </c:when>
                <c:otherwise>
                    <p class="progress-motivation">&#127881; Amazing! You completed all your habits!</p>
                </c:otherwise>
            </c:choose>

            <div class="progress-bar-track">
                <div class="progress-bar-fill"
                     style="width: ${stats.completionPercent}%;"></div>
            </div>
        </div>

        <%-- ---- Weekly Activity Strip ---- --%>
        <c:if test="${not empty weekDays}">
            <div class="weekly-activity">
                <div class="weekly-activity-title">&#128336; Last 7 Days</div>
                <div class="weekly-days">
                    <c:forEach var="wd" items="${weekDays}">
                        <%-- Build dot CSS class --%>
                        <c:choose>
                            <c:when test="${wd.hasActivity and wd.isToday}">
                                <c:set var="dotClass" value="week-day-dot active today" scope="page"/>
                            </c:when>
                            <c:when test="${wd.hasActivity}">
                                <c:set var="dotClass" value="week-day-dot active" scope="page"/>
                            </c:when>
                            <c:when test="${wd.isToday}">
                                <c:set var="dotClass" value="week-day-dot today" scope="page"/>
                            </c:when>
                            <c:otherwise>
                                <c:set var="dotClass" value="week-day-dot" scope="page"/>
                            </c:otherwise>
                        </c:choose>
                        <c:set var="lblClass" value="${wd.isToday ? 'week-day-label today-label' : 'week-day-label'}" scope="page"/>

                        <div class="week-day">
                            <div class="${dotClass}">
                                <c:if test="${wd.hasActivity}">&#10003;</c:if>
                            </div>
                            <div class="${lblClass}"><c:out value="${wd.label}"/></div>
                        </div>
                    </c:forEach>
                </div>
            </div>
        </c:if>

        <%-- ---- Habit List Header ---- --%>
        <div class="section-title-row">
            <span class="section-title">All Habits</span>
            <a href="${pageContext.request.contextPath}/addHabit"
               class="btn btn-primary btn-sm">&#43; Add Habit</a>
        </div>

        <%-- ---- Habit List ---- --%>
        <c:choose>
            <c:when test="${empty habits}">
                <div class="empty-state">
                    <div class="empty-icon">&#127807;</div>
                    <h3>Your journey starts here.</h3>
                    <p>You haven&#8217;t added any habits yet.<br>
                       Start small &#8212; even one habit a day makes a difference!</p>
                    <a href="${pageContext.request.contextPath}/addHabit"
                       class="btn btn-primary">&#43; Create Your First Habit</a>
                </div>
            </c:when>
            <c:otherwise>
                <div class="habits-list">
                    <c:forEach var="habit" items="${habits}">

                        <%-- Check completion status for today --%>
                        <c:set var="isDone" value="false" scope="page"/>
                        <c:forEach var="cid" items="${stats.completedIds}">
                            <c:if test="${cid eq habit.id}">
                                <c:set var="isDone" value="true" scope="page"/>
                            </c:if>
                        </c:forEach>

                        <%-- Pre-compute card and indicator CSS classes --%>
                        <c:choose>
                            <c:when test="${isDone}">
                                <c:set var="cardClass"      value="habit-card completed" scope="page"/>
                                <c:set var="indicatorClass" value="habit-status-indicator done" scope="page"/>
                            </c:when>
                            <c:otherwise>
                                <c:set var="cardClass"      value="habit-card" scope="page"/>
                                <c:set var="indicatorClass" value="habit-status-indicator" scope="page"/>
                            </c:otherwise>
                        </c:choose>

                        <%-- Category-specific badge class --%>
                        <c:choose>
                            <c:when test="${habit.category eq 'Health'}">
                                <c:set var="catBadgeClass" value="badge badge-cat-health" scope="page"/>
                            </c:when>
                            <c:when test="${habit.category eq 'Fitness'}">
                                <c:set var="catBadgeClass" value="badge badge-cat-fitness" scope="page"/>
                            </c:when>
                            <c:when test="${habit.category eq 'Study'}">
                                <c:set var="catBadgeClass" value="badge badge-cat-study" scope="page"/>
                            </c:when>
                            <c:when test="${habit.category eq 'Productivity'}">
                                <c:set var="catBadgeClass" value="badge badge-cat-productivity" scope="page"/>
                            </c:when>
                            <c:when test="${habit.category eq 'Personal'}">
                                <c:set var="catBadgeClass" value="badge badge-cat-personal" scope="page"/>
                            </c:when>
                            <c:otherwise>
                                <c:set var="catBadgeClass" value="badge badge-category" scope="page"/>
                            </c:otherwise>
                        </c:choose>

                        <%-- Frequency badge class --%>
                        <c:choose>
                            <c:when test="${habit.frequency eq 'Daily'}">
                                <c:set var="freqBadgeClass" value="badge badge-freq-daily" scope="page"/>
                            </c:when>
                            <c:otherwise>
                                <c:set var="freqBadgeClass" value="badge badge-freq-weekly" scope="page"/>
                            </c:otherwise>
                        </c:choose>

                        <div class="${cardClass}">

                            <div class="${indicatorClass}">
                                <c:if test="${isDone}">&#10003;</c:if>
                            </div>

                            <div class="habit-body">
                                <div class="habit-name">
                                    <c:out value="${habit.name}"/>
                                </div>
                                <c:if test="${not empty habit.description}">
                                    <div class="habit-desc">
                                        <c:out value="${habit.description}"/>
                                    </div>
                                </c:if>
                                <div class="habit-meta">
                                    <span class="${catBadgeClass}">
                                        <c:out value="${habit.category}"/>
                                    </span>
                                    <span class="${freqBadgeClass}">
                                        <c:out value="${habit.frequency}"/>
                                    </span>
                                    <c:choose>
                                        <c:when test="${isDone}">
                                            <span class="badge badge-completed">&#10003; Completed</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge badge-pending">Pending</span>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>

                            <div class="habit-actions">

                                <%-- Toggle Done / Undo --%>
                                <form action="${pageContext.request.contextPath}/completeHabit"
                                      method="post" style="display:inline;">
                                    <input type="hidden" name="habitId" value="${habit.id}">
                                    <c:choose>
                                        <c:when test="${isDone}">
                                            <button type="submit" class="btn btn-outline btn-sm"
                                                    title="Mark as Incomplete">
                                                &#8635; Undo
                                            </button>
                                        </c:when>
                                        <c:otherwise>
                                            <button type="submit" class="btn btn-success btn-sm"
                                                    title="Mark as Complete">
                                                &#10003; Done
                                            </button>
                                        </c:otherwise>
                                    </c:choose>
                                </form>

                                <%-- Edit --%>
                                <a href="${pageContext.request.contextPath}/editHabit?id=${habit.id}"
                                   class="btn btn-outline btn-sm">&#9998; Edit</a>

                                <%-- Delete --%>
                                <form action="${pageContext.request.contextPath}/deleteHabit"
                                      method="post" style="display:inline;"
                                      class="delete-form">
                                    <input type="hidden" name="id" value="${habit.id}">
                                    <input type="hidden" name="habitName"
                                           value="<c:out value='${habit.name}'/>">
                                    <button type="submit" class="btn btn-danger btn-sm"
                                            title="Delete habit">
                                        &#128465; Delete
                                    </button>
                                </form>

                            </div>
                        </div>
                    </c:forEach>
                </div>
            </c:otherwise>
        </c:choose>

    </main>

    <%-- ==================== HABIT BUDDY ==================== --%>
    <aside class="buddy-panel">
        <div class="buddy-card">
            <div class="buddy-image-wrap">
                <img src="${pageContext.request.contextPath}/assets/images/habit-buddy.png"
                     alt="Habit Buddy mascot"/>
            </div>
            <div class="buddy-name">Habit Buddy &#127804;</div>
            <div class="buddy-messages">
                <div class="buddy-msg">&#127804; Little steps,<br>big changes!</div>
                <div class="buddy-msg">&#127775; Every small habit<br>helps you bloom.</div>
                <div class="buddy-msg">&#9989; One habit at a time&#8212;<br>you&#8217;ve got this!</div>
                <div class="buddy-msg">&#127807; Keep growing,<br>keep glowing!</div>
            </div>
            <div class="buddy-tip">&#10024; Your cheerleader</div>
        </div>
    </aside>

</div>

<%-- Delete confirmation — reads name from hidden input --%>
<script>
    document.querySelectorAll('.delete-form').forEach(function(form) {
        form.addEventListener('submit', function(e) {
            var name = form.querySelector('[name="habitName"]').value;
            if (!confirm('Delete habit "' + name + '"? This cannot be undone.')) {
                e.preventDefault();
            }
        });
    });
</script>

</body>
</html>
