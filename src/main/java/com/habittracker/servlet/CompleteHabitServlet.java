package com.habittracker.servlet;

import com.habittracker.service.HabitService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.time.LocalDate;

/**
 * Controller for toggling a habit's completion status for today.
 *
 * POST /completeHabit — toggles completed / incomplete for the current date,
 *                       then redirects back to the dashboard.
 *
 * Business rules enforced by the service:
 *   - Only one completion record per habit per date.
 *   - Clicking again toggles back to incomplete (undo support).
 *
 * AIP Concepts:
 *   - doPost() for data modification
 *   - Service layer enforcing business rules
 *   - Post/Redirect/Get
 */
@WebServlet("/completeHabit")
public class CompleteHabitServlet extends HttpServlet {

    private final HabitService habitService = new HabitService();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String idParam = request.getParameter("habitId");

        if (idParam == null || idParam.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/dashboard?error=Missing+habit+id");
            return;
        }

        long habitId;
        try {
            habitId = Long.parseLong(idParam.trim());
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/dashboard?error=Invalid+habit+id");
            return;
        }

        try {
            habitService.toggleCompletion(habitId, LocalDate.now());
            response.sendRedirect(request.getContextPath() + "/dashboard");

        } catch (IllegalArgumentException e) {
            response.sendRedirect(request.getContextPath() + "/dashboard?error=Habit+not+found");
        } catch (Exception e) {
            response.sendRedirect(request.getContextPath() + "/dashboard?error=Could+not+update+completion");
        }
    }
}
