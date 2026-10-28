-- =============================================================
-- Daily Habit Tracker — Database Setup Script
-- Run this script in MySQL Workbench or MySQL CLI before
-- deploying the application.
--
-- NOTE: Hibernate with hbm2ddl.auto=update will also create
-- and alter tables automatically. This script is provided
-- for reference and manual verification.
-- =============================================================

-- 1. Create the database
CREATE DATABASE IF NOT EXISTS habit_tracker_db
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;

-- 2. Select the database
USE habit_tracker_db;

-- 3. Create the habits table
CREATE TABLE IF NOT EXISTS habits (
    id          BIGINT       NOT NULL AUTO_INCREMENT,
    name        VARCHAR(200) NOT NULL,
    description VARCHAR(500),
    category    VARCHAR(50)  NOT NULL,
    frequency   VARCHAR(20)  NOT NULL,
    created_at  DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 4. Create the habit_completions table
CREATE TABLE IF NOT EXISTS habit_completions (
    id              BIGINT  NOT NULL AUTO_INCREMENT,
    habit_id        BIGINT  NOT NULL,
    completion_date DATE    NOT NULL,
    completed       TINYINT(1) NOT NULL DEFAULT 0,
    PRIMARY KEY (id),
    CONSTRAINT fk_habit
        FOREIGN KEY (habit_id) REFERENCES habits(id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    CONSTRAINT uq_habit_date
        UNIQUE (habit_id, completion_date)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- =============================================================
-- Optional: Insert sample habits for initial testing
-- Remove or comment out these lines after testing.
-- =============================================================
-- INSERT INTO habits (name, description, category, frequency) VALUES
--     ('Drink 2 litres of water', 'Stay hydrated throughout the day', 'Health', 'Daily'),
--     ('Read for 30 minutes',     'Read any book or article',          'Study',  'Daily'),
--     ('Exercise for 20 minutes', 'Any physical activity counts',      'Fitness','Daily'),
--     ('Study for 2 hours',       'Focused study session',             'Study',  'Daily'),
--     ('Sleep before 11 PM',      'Maintain a healthy sleep schedule', 'Health', 'Daily');

-- =============================================================
-- Verify tables were created
-- =============================================================
SHOW TABLES;
DESCRIBE habits;
DESCRIBE habit_completions;
