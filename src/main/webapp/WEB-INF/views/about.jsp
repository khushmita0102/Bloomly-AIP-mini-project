<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>About &#8212; Bloomly</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/assets/images/bloomly-logo.png">
</head>
<body>
<div class="app-container">

    <%-- Sidebar --%>
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
            <a href="${pageContext.request.contextPath}/about" class="nav-link active">
                <span class="nav-icon">&#128218;</span> About Project
            </a>
        </nav>
    </aside>

    <%-- Main Content --%>
    <main class="main-content">
        <div class="page-header">
            <h1>About Project</h1>
            <p class="page-subtitle">AIP Mini Project &#8212; Bloomly</p>
        </div>

        <%-- Project Overview --%>
        <div class="about-card">
            <h2>&#128218; Project Overview</h2>
            <p>
                The <strong>Bloomly</strong> is a web application developed as a mini
                project for the <strong>Advanced Internet Programming (AIP)</strong> subject.
                It allows users to create daily habits, track completion, and review their
                progress history — all persisted in a MySQL database.
            </p>
            <p>
                The project demonstrates the practical implementation of AIP syllabus concepts
                through a real, working application following the MVC architecture.
            </p>
        </div>

        <%-- MVC Architecture --%>
        <div class="about-card">
            <h2>&#127959; MVC Architecture</h2>
            <p>The application is structured following the Model-View-Controller (MVC) pattern:</p>
            <ul>
                <li>
                    <strong>Model</strong> — Java entity classes (<code>Habit</code>,
                    <code>HabitCompletion</code>) mapped to MySQL tables via Hibernate annotations.
                    DAO and Service classes manage data access and business logic.
                </li>
                <li>
                    <strong>View</strong> — JSP pages with JSTL core tags and Expression Language (EL)
                    render dynamic HTML. A shared CSS stylesheet provides the UI.
                </li>
                <li>
                    <strong>Controller</strong> — Java Servlets handle HTTP requests, validate input,
                    call the service layer, and forward/redirect to JSP views.
                </li>
            </ul>
        </div>

        <%-- AIP Concepts --%>
        <div class="about-card">
            <h2>&#128204; AIP Concepts Demonstrated</h2>
            <ul>
                <li><strong>HTML5 Forms</strong> — Input fields, dropdowns, textareas, buttons.</li>
                <li><strong>CSS3 Layout</strong> — Flexbox sidebar + main layout, responsive design.</li>
                <li><strong>Java Servlets</strong> — Separate Servlet for each operation; doGet/doPost.</li>
                <li><strong>JSP + EL</strong> — Dynamic rendering using Expression Language without scriptlets.</li>
                <li><strong>JSTL Core Tags</strong> — &lt;c:forEach&gt;, &lt;c:if&gt;, &lt;c:choose&gt;.</li>
                <li><strong>Hibernate ORM</strong> — Entity mapping, SessionFactory, Session, Transactions, HQL.</li>
                <li><strong>JDBC</strong> — Hibernate uses JDBC internally for MySQL connectivity.</li>
                <li><strong>CRUD Operations</strong> — Create, Read, Update, Delete via Hibernate.</li>
                <li><strong>Post/Redirect/Get</strong> — Prevents duplicate form submissions on back/refresh.</li>
                <li><strong>Server-side Validation</strong> — All inputs validated in the Service layer.</li>
                <li><strong>Unique Constraints</strong> — One completion record per habit per date.</li>
                <li><strong>Entity Relationships</strong> — @ManyToOne / @OneToMany between Habit and HabitCompletion.</li>
            </ul>
        </div>

        <%-- Technology Stack --%>
        <div class="about-card">
            <h2>&#9881; Technology Stack</h2>
            <div class="tech-grid">
                <div class="tech-item">&#9749; Java 17</div>
                <div class="tech-item">&#127760; Jakarta Servlets 6.0</div>
                <div class="tech-item">&#128196; JSP 3.1 + JSTL 3.0</div>
                <div class="tech-item">&#128025; Hibernate ORM 6.4</div>
                <div class="tech-item">&#128200; MySQL 8</div>
                <div class="tech-item">&#128736; Apache Tomcat 11</div>
                <div class="tech-item">&#128218; Maven</div>
                <div class="tech-item">&#127775; CSS3 Flexbox</div>
            </div>
        </div>

        <%-- Project Structure --%>
        <div class="about-card">
            <h2>&#128193; Project Structure</h2>
            <pre style="font-size:0.78rem; background:#F8FAFC; padding:16px; border-radius:8px;
                        border:1px solid #E2E8F0; overflow-x:auto; color:#1E293B; line-height:1.7;">
DailyHabitTracker/
├── pom.xml
└── src/main/
    ├── java/com/habittracker/
    │   ├── entity/   Habit.java, HabitCompletion.java
    │   ├── dao/      HabitDAO.java, HabitCompletionDAO.java
    │   ├── service/  HabitService.java
    │   ├── util/     HibernateUtil.java, AppContextListener.java
    │   └── servlet/  DashboardServlet, AddHabitServlet, EditHabitServlet,
    │                 UpdateHabitServlet, DeleteHabitServlet,
    │                 CompleteHabitServlet, HistoryServlet, AboutServlet
    ├── resources/
    │   └── hibernate.cfg.xml
    └── webapp/
        ├── index.jsp
        ├── assets/css/style.css
        └── WEB-INF/
            ├── web.xml
            └── views/  dashboard.jsp, add-habit.jsp, edit-habit.jsp,
                        history.jsp, about.jsp, error.jsp
            </pre>
        </div>

    </main>
</div>
</body>
</html>
