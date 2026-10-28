package com.habittracker.entity;

import jakarta.persistence.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

/**
 * Hibernate entity mapped to the 'habits' table.
 * Demonstrates: @Entity, @Table, @Id, @GeneratedValue, @Column, @OneToMany
 */
@Entity
@Table(name = "habits")
public class Habit {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id")
    private Long id;

    @Column(name = "name", nullable = false, length = 200)
    private String name;

    @Column(name = "description", length = 500)
    private String description;

    /**
     * Category values: Health, Study, Fitness, Productivity, Personal
     */
    @Column(name = "category", nullable = false, length = 50)
    private String category;

    /**
     * Frequency values: Daily, Weekly
     */
    @Column(name = "frequency", nullable = false, length = 20)
    private String frequency;

    @Column(name = "created_at", nullable = false)
    private LocalDateTime createdAt;

    /**
     * Bidirectional one-to-many relationship with HabitCompletion.
     * cascade = ALL ensures that when a Habit is deleted, its completions are also removed.
     */
    @OneToMany(mappedBy = "habit", cascade = CascadeType.ALL, orphanRemoval = true, fetch = FetchType.LAZY)
    private List<HabitCompletion> completions = new ArrayList<>();

    // ---------------------------------------------------------------
    // Constructors
    // ---------------------------------------------------------------

    public Habit() {
    }

    public Habit(String name, String description, String category, String frequency) {
        this.name = name;
        this.description = description;
        this.category = category;
        this.frequency = frequency;
        this.createdAt = LocalDateTime.now();
    }

    // ---------------------------------------------------------------
    // Lifecycle callback — set createdAt automatically before insert
    // ---------------------------------------------------------------

    @PrePersist
    public void prePersist() {
        if (this.createdAt == null) {
            this.createdAt = LocalDateTime.now();
        }
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

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getCategory() {
        return category;
    }

    public void setCategory(String category) {
        this.category = category;
    }

    public String getFrequency() {
        return frequency;
    }

    public void setFrequency(String frequency) {
        this.frequency = frequency;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    public List<HabitCompletion> getCompletions() {
        return completions;
    }

    public void setCompletions(List<HabitCompletion> completions) {
        this.completions = completions;
    }

    @Override
    public String toString() {
        return "Habit{id=" + id + ", name='" + name + "', category='" + category + "', frequency='" + frequency + "'}";
    }
}
