package com.habittracker.service;

import com.habittracker.dao.HabitCompletionDAO;
import com.habittracker.dao.HabitDAO;
import com.habittracker.entity.Habit;
import com.habittracker.entity.HabitCompletion;

import java.time.LocalDate;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Service layer — sits between Servlets and DAOs.
 *
 * Responsibilities:
 *   - Input validation
 *   - Business rule enforcement (e.g. prevent duplicate completions)
 *   - Aggregation of data for the dashboard and history
 *   - Shields Servlets from direct Hibernate interactions
 *
 * AIP Concepts Demonstrated:
 *   - MVC service layer
 *   - Business logic separation from controllers
 */
public class HabitService {

    private final HabitDAO habitDAO = new HabitDAO();
    private final HabitCompletionDAO completionDAO = new HabitCompletionDAO();

    // ---------------------------------------------------------------
    // HABIT CRUD
    // ---------------------------------------------------------------

    /**
     * Validates and saves a new habit.
     *
     * @param name        required; trimmed
     * @param description optional
     * @param category    must be one of the allowed values
     * @param frequency   Daily or Weekly
     * @return saved Habit
     * @throws IllegalArgumentException on validation failure
     */
    public Habit addHabit(String name, String description, String category, String frequency) {
        validateHabitInputs(name, category, frequency);

        Habit habit = new Habit(
                name.trim(),
                (description != null && !description.trim().isEmpty()) ? description.trim() : null,
                category.trim(),
                frequency.trim()
        );
        return habitDAO.save(habit);
    }

    /**
     * Validates and updates an existing habit.
     *
     * @param id          the id of the habit to update
     * @param name        updated name
     * @param description updated description
     * @param category    updated category
     * @param frequency   updated frequency
     * @throws IllegalArgumentException if habit not found or inputs invalid
     */
    public void updateHabit(Long id, String name, String description, String category, String frequency) {
        Habit habit = habitDAO.findById(id);
        if (habit == null) {
            throw new IllegalArgumentException("Habit not found with id: " + id);
        }
        validateHabitInputs(name, category, frequency);

        habit.setName(name.trim());
        habit.setDescription((description != null && !description.trim().isEmpty()) ? description.trim() : null);
        habit.setCategory(category.trim());
        habit.setFrequency(frequency.trim());
        habitDAO.update(habit);
    }

    /**
     * Deletes a habit by id.
     *
     * @param id the id of the habit to delete
     * @throws IllegalArgumentException if habit not found
     */
    public void deleteHabit(Long id) {
        boolean deleted = habitDAO.deleteById(id);
        if (!deleted) {
            throw new IllegalArgumentException("Habit not found with id: " + id);
        }
    }

    /**
     * Retrieves all habits.
     *
     * @return list of all habits; empty list if none
     */
    public List<Habit> getAllHabits() {
        return habitDAO.findAll();
    }

    /**
     * Retrieves a single habit by id.
     *
     * @param id the habit id
     * @return Habit or null if not found
     */
    public Habit getHabitById(Long id) {
        return habitDAO.findById(id);
    }

    // ---------------------------------------------------------------
    // COMPLETION TRACKING
    // ---------------------------------------------------------------

    /**
     * Toggles the completion status of a habit for today.
     *
     * - If no record exists for today, creates one with completed = true.
     * - If a record exists and is completed, marks it incomplete.
     * - If a record exists and is incomplete, marks it complete.
     *
     * @param habitId the id of the habit
     * @param date    the date to toggle (typically today)
     * @throws IllegalArgumentException if habit not found
     */
    public void toggleCompletion(Long habitId, LocalDate date) {
        Habit habit = habitDAO.findById(habitId);
        if (habit == null) {
            throw new IllegalArgumentException("Habit not found with id: " + habitId);
        }

        HabitCompletion existing = completionDAO.findByHabitAndDate(habitId, date);

        if (existing == null) {
            // First time — create a completed record
            HabitCompletion newRecord = new HabitCompletion(habit, date, true);
            completionDAO.save(newRecord);
        } else {
            // Toggle
            existing.setCompleted(!existing.isCompleted());
            completionDAO.update(existing);
        }
    }

    // ---------------------------------------------------------------
    // DASHBOARD STATISTICS
    // ---------------------------------------------------------------

    /**
     * Builds the statistics map used by the dashboard JSP.
     *
     * Keys in the returned map:
     *   totalHabits       — long
     *   completedToday    — long
     *   remainingToday    — long
     *   completionPercent — int  (0-100)
     *   completedIds      — List<Long>  (habit IDs completed today)
     *
     * @param today the current date
     * @return stats map
     */
    public Map<String, Object> getDashboardStats(LocalDate today) {
        Map<String, Object> stats = new HashMap<>();

        long totalHabits = habitDAO.countAll();
        long completedToday = completionDAO.countCompletedByDate(today);
        long remaining = Math.max(0, totalHabits - completedToday);

        int percent = 0;
        if (totalHabits > 0) {
            percent = (int) Math.round((completedToday * 100.0) / totalHabits);
        }

        List<Long> completedIds = completionDAO.findCompletedHabitIdsByDate(today);

        stats.put("totalHabits", totalHabits);
        stats.put("completedToday", completedToday);
        stats.put("remainingToday", remaining);
        stats.put("completionPercent", percent);
        stats.put("completedIds", completedIds);

        return stats;
    }

    // ---------------------------------------------------------------
    // HISTORY
    // ---------------------------------------------------------------

    /**
     * Retrieves habit completion data for a specific date.
     *
     * Returns a map with:
     *   completions     — List<HabitCompletion> for that date
     *   allHabits       — List<Habit> (all habits, for cross-referencing uncompleted ones)
     *   completedCount  — long
     *   totalCount      — long
     *   percent         — int
     *
     * @param date the history date
     * @return history data map
     */
    public Map<String, Object> getHistoryForDate(LocalDate date) {
        Map<String, Object> data = new HashMap<>();

        List<HabitCompletion> completions = completionDAO.findByDate(date);
        List<Habit> allHabits = habitDAO.findAll();

        long total = allHabits.size();
        long completedCount = completions.stream().filter(HabitCompletion::isCompleted).count();

        int percent = 0;
        if (total > 0) {
            percent = (int) Math.round((completedCount * 100.0) / total);
        }

        data.put("completions", completions);
        data.put("allHabits", allHabits);
        data.put("completedCount", completedCount);
        data.put("totalCount", total);
        data.put("percent", percent);

        return data;
    }

    // ---------------------------------------------------------------
    // VALIDATION HELPERS
    // ---------------------------------------------------------------

    private static final List<String> VALID_CATEGORIES =
            List.of("Health", "Study", "Fitness", "Productivity", "Personal");

    private static final List<String> VALID_FREQUENCIES =
            List.of("Daily", "Weekly");

    private void validateHabitInputs(String name, String category, String frequency) {
        if (name == null || name.trim().isEmpty()) {
            throw new IllegalArgumentException("Habit name is required.");
        }
        if (name.trim().length() > 200) {
            throw new IllegalArgumentException("Habit name must be 200 characters or fewer.");
        }
        if (category == null || !VALID_CATEGORIES.contains(category.trim())) {
            throw new IllegalArgumentException("Invalid category. Choose: " + VALID_CATEGORIES);
        }
        if (frequency == null || !VALID_FREQUENCIES.contains(frequency.trim())) {
            throw new IllegalArgumentException("Invalid frequency. Choose: Daily or Weekly.");
        }
    }
}
