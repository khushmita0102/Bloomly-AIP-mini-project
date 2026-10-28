package com.habittracker.dao;

import com.habittracker.entity.Habit;
import com.habittracker.entity.HabitCompletion;
import com.habittracker.util.HibernateUtil;
import org.hibernate.Session;
import org.hibernate.Transaction;
import org.hibernate.query.Query;

import java.time.LocalDate;
import java.util.Collections;
import java.util.List;

/**
 * Data Access Object for the HabitCompletion entity.
 *
 * AIP Concepts Demonstrated:
 *   - HQL with named parameters (:paramName)
 *   - Preventing duplicate records via unique constraint + existence check
 *   - Date-based querying through Hibernate
 *   - Proper transaction management
 */
public class HabitCompletionDAO {

    // ---------------------------------------------------------------
    // UPSERT — insert or toggle completion for today
    // ---------------------------------------------------------------

    /**
     * Finds the HabitCompletion record for the given habit and date,
     * or returns null if no record exists yet.
     *
     * @param habitId        the id of the habit
     * @param completionDate the date to look up
     * @return HabitCompletion or null
     */
    public HabitCompletion findByHabitAndDate(Long habitId, LocalDate completionDate) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            Query<HabitCompletion> query = session.createQuery(
                    "FROM HabitCompletion hc WHERE hc.habit.id = :habitId AND hc.completionDate = :date",
                    HabitCompletion.class);
            query.setParameter("habitId", habitId);
            query.setParameter("date", completionDate);
            return query.uniqueResult();  // null if not found
        } catch (Exception e) {
            throw new RuntimeException("Error finding completion: " + e.getMessage(), e);
        }
    }

    /**
     * Inserts a new HabitCompletion record.
     *
     * @param completion the new record to insert
     */
    public void save(HabitCompletion completion) {
        Transaction tx = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            tx = session.beginTransaction();
            session.persist(completion);   // Hibernate 6: persist() replaces save()
            tx.commit();
        } catch (Exception e) {
            if (tx != null) tx.rollback();
            throw new RuntimeException("Error saving completion: " + e.getMessage(), e);
        }
    }

    /**
     * Updates an existing HabitCompletion (e.g., toggling completed flag).
     *
     * @param completion the record to update (must have a valid id)
     */
    public void update(HabitCompletion completion) {
        Transaction tx = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            tx = session.beginTransaction();
            session.merge(completion);     // Hibernate 6: merge() replaces update()
            tx.commit();
        } catch (Exception e) {
            if (tx != null) tx.rollback();
            throw new RuntimeException("Error updating completion: " + e.getMessage(), e);
        }
    }

    // ---------------------------------------------------------------
    // QUERIES
    // ---------------------------------------------------------------

    /**
     * Returns all HabitCompletion records for a specific date.
     * Used by the history page to show what was done on a given day.
     *
     * @param date the date to filter by
     * @return list of completions on that date
     */
    public List<HabitCompletion> findByDate(LocalDate date) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            Query<HabitCompletion> query = session.createQuery(
                    "FROM HabitCompletion hc WHERE hc.completionDate = :date ORDER BY hc.habit.name",
                    HabitCompletion.class);
            query.setParameter("date", date);
            List<HabitCompletion> result = query.list();
            return result != null ? result : Collections.emptyList();
        } catch (Exception e) {
            throw new RuntimeException("Error fetching completions by date: " + e.getMessage(), e);
        }
    }

    /**
     * Returns all HabitCompletion records for a specific habit.
     *
     * @param habitId the id of the habit
     * @return list of all completion records for that habit
     */
    public List<HabitCompletion> findByHabit(Long habitId) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            Query<HabitCompletion> query = session.createQuery(
                    "FROM HabitCompletion hc WHERE hc.habit.id = :habitId ORDER BY hc.completionDate DESC",
                    HabitCompletion.class);
            query.setParameter("habitId", habitId);
            List<HabitCompletion> result = query.list();
            return result != null ? result : Collections.emptyList();
        } catch (Exception e) {
            throw new RuntimeException("Error fetching completions by habit: " + e.getMessage(), e);
        }
    }

    /**
     * Counts the number of habits marked as completed on a specific date.
     *
     * @param date the date to count
     * @return number of completed habits
     */
    public long countCompletedByDate(LocalDate date) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            Query<Long> query = session.createQuery(
                    "SELECT COUNT(hc) FROM HabitCompletion hc WHERE hc.completionDate = :date AND hc.completed = true",
                    Long.class);
            query.setParameter("date", date);
            Long count = query.uniqueResult();
            return count != null ? count : 0L;
        } catch (Exception e) {
            throw new RuntimeException("Error counting completions: " + e.getMessage(), e);
        }
    }

    /**
     * Returns IDs of all habits that are completed on a given date.
     * Useful for quickly determining which habits have been done today.
     *
     * @param date the target date
     * @return list of habit IDs that are completed
     */
    public List<Long> findCompletedHabitIdsByDate(LocalDate date) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            Query<Long> query = session.createQuery(
                    "SELECT hc.habit.id FROM HabitCompletion hc WHERE hc.completionDate = :date AND hc.completed = true",
                    Long.class);
            query.setParameter("date", date);
            List<Long> result = query.list();
            return result != null ? result : Collections.emptyList();
        } catch (Exception e) {
            throw new RuntimeException("Error fetching completed habit IDs: " + e.getMessage(), e);
        }
    }
}
