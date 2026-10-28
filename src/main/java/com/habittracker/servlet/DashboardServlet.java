package com.habittracker.servlet;

import com.habittracker.entity.Habit;
import com.habittracker.service.HabitService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.time.DayOfWeek;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.time.format.TextStyle;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

/**
 * Controller for the main dashboard page.
 *
 * URL mapping : /dashboard  (also the application root via index.jsp redirect)
 *
 * AIP Concepts:
 *   - doGet() for read-only page display
 *   - Forwarding to a JSP view
 *   - Setting request attributes for EL access in JSP
 */
@WebServlet("/dashboard")
public class DashboardServlet extends HttpServlet {

    private final HabitService habitService = new HabitService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        LocalDate today = LocalDate.now();

        // Retrieve all habits from the database
        List<Habit> habits = habitService.getAllHabits();

        // Build dashboard statistics (totalHabits, completedToday, remainingToday,
        // completionPercent, completedIds)
        Map<String, Object> stats = habitService.getDashboardStats(today);

        // Format today's date for display
        String formattedDate = today.format(DateTimeFormatter.ofPattern("EEEE, MMMM d, yyyy"));

        // ----------------------------------------------------------------
        // Weekly activity — last 7 days including today
        // Each entry: { date, label (Mon/Tue…), isToday, hasActivity }
        // Uses existing HabitCompletionDAO via HabitService to check completions.
        // ----------------------------------------------------------------
        List<Map<String, Object>> weekDays = new ArrayList<>();
        for (int i = 6; i >= 0; i--) {
            LocalDate day = today.minusDays(i);
            Map<String, Object> entry = new LinkedHashMap<>();

            // Short day label e.g. "Mon"
            String label = day.getDayOfWeek()
                              .getDisplayName(TextStyle.SHORT, Locale.ENGLISH);
            entry.put("label",  label);
            entry.put("isToday", day.equals(today));

            // Re-use the existing service: if any habit was completed that day
            // completedCount > 0 means there was activity
            Map<String, Object> dayHistory = habitService.getHistoryForDate(day);
            long completedOnDay = (long) dayHistory.get("completedCount");
            entry.put("hasActivity", completedOnDay > 0);

            weekDays.add(entry);
        }

        // Set request attributes accessed via EL in JSP
        request.setAttribute("habits",        habits);
        request.setAttribute("stats",         stats);
        request.setAttribute("today",         today.toString());
        request.setAttribute("formattedDate", formattedDate);
        request.setAttribute("weekDays",      weekDays);

        // Forward to the JSP view (MVC pattern)
        request.getRequestDispatcher("/WEB-INF/views/dashboard.jsp")
               .forward(request, response);
    }
}
