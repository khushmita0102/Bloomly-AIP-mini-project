# Bloomly- Habit Tracker 

A fully functional Daily Habit Tracker web application built using **Java Servlets**, **Hibernate ORM**, **JSP**, **JSTL**, **MySQL**, and **Maven**, deployed on **Apache Tomcat 11**.

---

## Features

- Add, edit, and delete daily habits
- Mark habits as complete or incomplete for today
- Dashboard with statistics: total, completed, remaining, and progress percentage
- Habit history viewer — select any date and see completion status for each habit
- Clean, responsive sidebar layout

---

## Technology Stack

| Layer       | Technology                        |
|-------------|-----------------------------------|
| Frontend    | HTML5, CSS3 (Flexbox), JSP, JSTL  |
| Backend     | Java 17, Jakarta Servlets 6.0     |
| ORM         | Hibernate 6.4 (with JDBC)         |
| Database    | MySQL 8                           |
| Server      | Apache Tomcat 11                  |
| Build Tool  | Maven 3                           |
| IDE         | Apache NetBeans                   |

---

## Prerequisites

Before running the application, ensure the following are installed and configured:

1. **Java 17** (JDK)
2. **Apache Maven 3.x**
3. **Apache Tomcat 11.x**
4. **MySQL Server 8.x**
## Project Structure

```
DailyHabitTracker/
├── pom.xml                          Maven build descriptor
├── database_setup.sql               Database creation script
├── README.md
└── src/main/
    ├── java/com/habittracker/
    │   ├── entity/
    │   │   ├── Habit.java           Hibernate entity — habits table
    │   │   └── HabitCompletion.java Hibernate entity — habit_completions table
    │   ├── dao/
    │   │   ├── HabitDAO.java        CRUD for Habit
    │   │   └── HabitCompletionDAO.java  CRUD for HabitCompletion
    │   ├── service/
    │   │   └── HabitService.java    Business logic, validation, statistics
    │   ├── util/
    │   │   ├── HibernateUtil.java   SessionFactory singleton
    │   │   └── AppContextListener.java  Manages Hibernate lifecycle
    │   └── servlet/
    │       ├── DashboardServlet.java
    │       ├── AddHabitServlet.java
    │       ├── EditHabitServlet.java
    │       ├── UpdateHabitServlet.java
    │       ├── DeleteHabitServlet.java
    │       ├── CompleteHabitServlet.java
    │       ├── HistoryServlet.java
    │       └── AboutServlet.java
    ├── resources/
    │   └── hibernate.cfg.xml        Hibernate + DB configuration
    └── webapp/
        ├── index.jsp                Redirects to /dashboard
        ├── assets/css/style.css     Main stylesheet
        └── WEB-INF/
            ├── web.xml
            └── views/
                ├── dashboard.jsp
                ├── add-habit.jsp
                ├── edit-habit.jsp
                ├── history.jsp
                ├── about.jsp
                └── error.jsp
```

---

## URL Mappings

| URL               | Servlet              | Method | Purpose                          |
|-------------------|----------------------|--------|----------------------------------|
| `/`               | index.jsp            | GET    | Redirects to /dashboard          |
| `/dashboard`      | DashboardServlet     | GET    | Main dashboard                   |
| `/addHabit`       | AddHabitServlet      | GET    | Show add habit form              |
| `/addHabit`       | AddHabitServlet      | POST   | Save new habit                   |
| `/editHabit?id=N` | EditHabitServlet     | GET    | Show edit habit form             |
| `/updateHabit`    | UpdateHabitServlet   | POST   | Save habit updates               |
| `/deleteHabit`    | DeleteHabitServlet   | POST   | Delete a habit                   |
| `/completeHabit`  | CompleteHabitServlet | POST   | Toggle today's completion status |
| `/history`        | HistoryServlet       | GET    | View completion history by date  |
| `/about`          | AboutServlet         | GET    | About project page               |

---

## AIP Concepts Demonstrated

### HTML & CSS
- HTML5 semantic structure
- CSS3 Flexbox layout
- Responsive design with media queries
- Form input validation attributes

### Java Servlets
- `doGet()` for page display
- `doPost()` for data modifications
- Post/Redirect/Get pattern
- `@WebServlet` annotation mapping
- Request parameters, attributes, forwarding, and redirecting
- Jakarta Servlet 6.0 API (`jakarta.servlet.*`)

### JSP & JSTL
- Expression Language (`${variable}`)
- `<c:forEach>`, `<c:if>`, `<c:choose>`, `<c:when>`, `<c:otherwise>`
- `fn:escapeXml()` for XSS prevention
- No Java scriptlets (clean JSP)

### Hibernate ORM
- `@Entity`, `@Table`, `@Id`, `@GeneratedValue`, `@Column`
- `@ManyToOne`, `@OneToMany`, `@JoinColumn`
- `CascadeType.ALL` for automatic deletion of related records
- `SessionFactory` and `Session`
- HQL queries with named parameters (`:param`)
- Transaction management (`beginTransaction`, `commit`, `rollback`)
- `hbm2ddl.auto=update` for schema management

### JDBC
- Used internally by Hibernate via MySQL Connector/J
- MySQL 8 dialect configured in `hibernate.cfg.xml`

### Database Design
- Two-table design: `habits` and `habit_completions`
- Foreign key constraint with `ON DELETE CASCADE`
- Unique constraint `(habit_id, completion_date)` to prevent duplicates
- Boolean completion status per habit per date

---

