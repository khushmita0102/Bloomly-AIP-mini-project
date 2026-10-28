package com.habittracker.servlet;

import com.habittracker.service.HabitService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 * Controller for adding a new habit.
 *
 * GET  /addHabit — displays the "Add Habit" form
 * POST /addHabit — validates input, saves to DB, redirects to dashboard
 *
 * AIP Concepts:
 *   - Separate doGet() and doPost()
 *   - Server-side input validation
 *   - Post/Redirect/Get pattern (prevents duplicate form submissions)
 *   - Passing error messages back to the form via request attributes
 */
@WebServlet("/addHabit")
public class AddHabitServlet extends HttpServlet {

    private final HabitService habitService = new HabitService();

    /**
     * Displays the add-habit form.
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.getRequestDispatcher("/WEB-INF/views/add-habit.jsp")
               .forward(request, response);
    }

    /**
     * Processes the submitted form.
     * On success  → redirect to /dashboard
     * On failure  → forward back to the form with an error message
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String name        = request.getParameter("name");
        String description = request.getParameter("description");
        String category    = request.getParameter("category");
        String frequency   = request.getParameter("frequency");

        try {
            habitService.addHabit(name, description, category, frequency);

            // Post/Redirect/Get — redirect after successful modification
            response.sendRedirect(request.getContextPath() + "/dashboard?success=Habit+added+successfully");

        } catch (IllegalArgumentException e) {
            // Validation failed — send the user back to the form with feedback
            request.setAttribute("errorMessage", e.getMessage());
            request.setAttribute("name",        name);
            request.setAttribute("description", description);
            request.setAttribute("category",    category);
            request.setAttribute("frequency",   frequency);
            request.getRequestDispatcher("/WEB-INF/views/add-habit.jsp")
                   .forward(request, response);

        } catch (Exception e) {
            request.setAttribute("errorMessage", "An unexpected error occurred. Please try again.");
            request.getRequestDispatcher("/WEB-INF/views/add-habit.jsp")
                   .forward(request, response);
        }
    }
}
