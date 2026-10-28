package com.habittracker.servlet;

import com.habittracker.entity.Habit;
import com.habittracker.service.HabitService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 * Controller for loading the edit-habit form.
 *
 * GET /editHabit?id={habitId} — loads the habit from the database
 *                               and forwards to edit-habit.jsp pre-populated
 *                               with existing values.
 *
 * AIP Concepts:
 *   - Reading query parameters
 *   - Loading an entity by ID and forwarding to a pre-populated form
 *   - Graceful handling of invalid IDs
 */
@WebServlet("/editHabit")
public class EditHabitServlet extends HttpServlet {

    private final HabitService habitService = new HabitService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String idParam = request.getParameter("id");

        // Validate the id parameter
        if (idParam == null || idParam.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/dashboard?error=Missing+habit+id");
            return;
        }

        long id;
        try {
            id = Long.parseLong(idParam.trim());
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/dashboard?error=Invalid+habit+id");
            return;
        }

        Habit habit = habitService.getHabitById(id);
        if (habit == null) {
            response.sendRedirect(request.getContextPath() + "/dashboard?error=Habit+not+found");
            return;
        }

        // Pass the habit to the JSP for pre-population
        request.setAttribute("habit", habit);
        request.getRequestDispatcher("/WEB-INF/views/edit-habit.jsp")
               .forward(request, response);
    }
}
