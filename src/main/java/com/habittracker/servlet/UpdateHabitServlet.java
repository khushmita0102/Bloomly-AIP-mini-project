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
 * Controller for processing the edit-habit form submission.
 *
 * POST /updateHabit — validates input, updates the habit in the DB,
 *                     then redirects to the dashboard.
 *
 * AIP Concepts:
 *   - doPost() for data modification
 *   - Post/Redirect/Get after update
 *   - Server-side validation with error feedback
 */
@WebServlet("/updateHabit")
public class UpdateHabitServlet extends HttpServlet {

    private final HabitService habitService = new HabitService();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String idParam     = request.getParameter("id");
        String name        = request.getParameter("name");
        String description = request.getParameter("description");
        String category    = request.getParameter("category");
        String frequency   = request.getParameter("frequency");

        // Parse habit id
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

        try {
            habitService.updateHabit(id, name, description, category, frequency);
            response.sendRedirect(request.getContextPath() + "/dashboard?success=Habit+updated+successfully");

        } catch (IllegalArgumentException e) {
            // Validation error — reload edit form with the error message
            request.setAttribute("errorMessage", e.getMessage());

            // Rebuild a stub habit so the form is pre-populated with the submitted values
            Habit stub = new Habit();
            stub.setId(id);
            stub.setName(name);
            stub.setDescription(description);
            stub.setCategory(category);
            stub.setFrequency(frequency);
            request.setAttribute("habit", stub);

            request.getRequestDispatcher("/WEB-INF/views/edit-habit.jsp")
                   .forward(request, response);

        } catch (Exception e) {
            response.sendRedirect(request.getContextPath() + "/dashboard?error=Update+failed");
        }
    }
}

