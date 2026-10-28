package com.habittracker.servlet;

import com.habittracker.service.HabitService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 * Controller for deleting a habit.
 *
 * POST /deleteHabit — deletes the habit and all its completions,
 *                     then redirects to dashboard.
 *
 * Uses POST (not GET) for the delete action so that browsers and crawlers
 * cannot accidentally trigger deletion via a link or prefetch.
 *
 * AIP Concepts:
 *   - doPost() for destructive operations
 *   - Cascading delete handled by Hibernate (CascadeType.ALL on Habit entity)
 *   - Post/Redirect/Get
 */
@WebServlet("/deleteHabit")
public class DeleteHabitServlet extends HttpServlet {

    private final HabitService habitService = new HabitService();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String idParam = request.getParameter("id");

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
            habitService.deleteHabit(id);
            response.sendRedirect(request.getContextPath() + "/dashboard?success=Habit+deleted+successfully");

        } catch (IllegalArgumentException e) {
            response.sendRedirect(request.getContextPath() + "/dashboard?error=Habit+not+found");
        } catch (Exception e) {
            response.sendRedirect(request.getContextPath() + "/dashboard?error=Delete+failed");
        }
    }
}

