package com.habittracker.servlet;

import com.habittracker.service.HabitService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.time.format.DateTimeParseException;
import java.util.Map;

/**
 * Controller for the habit history page.
 *
 * GET /history              — shows today's history by default
 * GET /history?date=YYYY-MM-DD — shows history for the specified date
 *
 * AIP Concepts:
 *   - doGet() with optional query parameters
 *   - Date parsing and validation
 *   - Forwarding data to JSP view
 */
@WebServlet("/history")
public class HistoryServlet extends HttpServlet {

    private final HabitService habitService = new HabitService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Default to today; override if a date parameter is provided
        LocalDate selectedDate = LocalDate.now();
        String dateParam = request.getParameter("date");

        if (dateParam != null && !dateParam.trim().isEmpty()) {
            try {
                selectedDate = LocalDate.parse(dateParam.trim());
            } catch (DateTimeParseException e) {
                // Invalid date format — fall back to today silently
                selectedDate = LocalDate.now();
            }
        }

        // Fetch history data for the selected date
        Map<String, Object> historyData = habitService.getHistoryForDate(selectedDate);

        // Format the date for display
        String formattedDate = selectedDate.format(DateTimeFormatter.ofPattern("EEEE, MMMM d, yyyy"));

        request.setAttribute("historyData", historyData);
        request.setAttribute("selectedDate", selectedDate.toString());      // ISO for input[type=date]
        request.setAttribute("formattedDate", formattedDate);
        request.setAttribute("today", LocalDate.now().toString());          // for max attribute on date picker

        request.getRequestDispatcher("/WEB-INF/views/history.jsp")
               .forward(request, response);
    }
}

