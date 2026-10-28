package com.habittracker.entity;

import jakarta.persistence.*;
import java.time.LocalDate;

/**
 * Hibernate entity mapped to the 'habit_completions' table.
 * Stores one record per habit per date indicating completion status.
 *
 * Demonstrates: @ManyToOne, @JoinColumn, unique constraint on composite columns.
 */
@Entity
@Table(
    name = "habit_completions",
    uniqueConstraints = {
        @UniqueConstraint(
            name = "uq_habit_date",
            columnNames = {"habit_id", "completion_date"}
        )
    }
)
public class HabitCompletion {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id")
    private Long id;

    /**
     * Many completions can belong to one habit.
     * Uses a foreign key 'habit_id' in this table.
     */
    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "habit_id", nullable = false)
    private Habit habit;

    @Column(name = "completion_date", nullable = false)
    private LocalDate completionDate;

    /**
     * true  = habit was completed on this date
     * false = habit was marked but not completed (or toggled back)
     */
    @Column(name = "completed", nullable = false)
    private boolean completed;

    // ---------------------------------------------------------------
    // Constructors
    // ---------------------------------------------------------------

    public HabitCompletion() {
    }

    public HabitCompletion(Habit habit, LocalDate completionDate, boolean completed) {
        this.habit = habit;
        this.completionDate = completionDate;
        this.completed = completed;
    }

    // ---------------------------------------------------------------
    // Getters and Setters
    // ---------------------------------------------------------------

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public Habit getHabit() {
        return habit;
    }

    public void setHabit(Habit habit) {
        this.habit = habit;
    }

    public LocalDate getCompletionDate() {
        return completionDate;
    }

    public void setCompletionDate(LocalDate completionDate) {
        this.completionDate = completionDate;
    }

    public boolean isCompleted() {
        return completed;
    }

    public void setCompleted(boolean completed) {
        this.completed = completed;
    }

    @Override
    public String toString() {
        return "HabitCompletion{id=" + id
                + ", habitId=" + (habit != null ? habit.getId() : null)
                + ", date=" + completionDate
                + ", completed=" + completed + "}";
    }
}

