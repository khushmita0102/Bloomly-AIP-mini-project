package com.habittracker.dao;

import com.habittracker.entity.Habit;
import com.habittracker.util.HibernateUtil;
import org.hibernate.Session;
import org.hibernate.Transaction;
import org.hibernate.query.Query;

import java.util.Collections;
import java.util.List;

/**
 * Data Access Object for the Habit entity.
 *
 * AIP Concepts Demonstrated:
 *   - Hibernate Session and Transaction
 *   - HQL (Hibernate Query Language) with named parameters
 *   - CRUD operations via Hibernate 6
 *   - Proper resource cleanup via try-with-resources
 *
 * Hibernate 6 API notes:
 *   - session.save()   replaced by session.persist()
 *   - session.update() replaced by session.merge()
 *   - session.delete() replaced by session.remove()
 */
public class HabitDAO {

    // ---------------------------------------------------------------
    // CREATE
    // ---------------------------------------------------------------

    /**
     * Persists a new Habit to the database.
     *
     * @param habit the Habit to save
     * @return the saved Habit with its generated id
     */
    public Habit save(Habit habit) {
        Transaction tx = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            tx = session.beginTransaction();
            session.persist(habit);        // Hibernate 6: persist() replaces save()
            tx.commit();
            return habit;
        } catch (Exception e) {
            if (tx != null) tx.rollback();
            throw new RuntimeException("Error saving habit: " + e.getMessage(), e);
        }
    }

    // ---------------------------------------------------------------
    // READ
    // ---------------------------------------------------------------

    /**
     * Finds a single Habit by its primary key.
     *
     * @param id the habit's id
     * @return the Habit, or null if not found
     */
    public Habit findById(Long id) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            return session.get(Habit.class, id);
        } catch (Exception e) {
            throw new RuntimeException("Error finding habit by id " + id + ": " + e.getMessage(), e);
        }
    }

    /**
     * Returns all habits ordered by creation date descending.
     *
     * Uses HQL with named parameters — no string concatenation.
     *
     * @return list of all habits; empty list if none exist
     */
    public List<Habit> findAll() {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            Query<Habit> query = session.createQuery(
                    "FROM Habit h ORDER BY h.createdAt DESC", Habit.class);
            List<Habit> habits = query.list();
            return habits != null ? habits : Collections.emptyList();
        } catch (Exception e) {
            throw new RuntimeException("Error fetching all habits: " + e.getMessage(), e);
        }
    }

    /**
     * Returns the total number of habits in the database.
     *
     * @return count of all habits
     */
    public long countAll() {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            Query<Long> query = session.createQuery(
                    "SELECT COUNT(h) FROM Habit h", Long.class);
            Long count = query.uniqueResult();
            return count != null ? count : 0L;
        } catch (Exception e) {
            throw new RuntimeException("Error counting habits: " + e.getMessage(), e);
        }
    }

    // ---------------------------------------------------------------
    // UPDATE
    // ---------------------------------------------------------------

    /**
     * Updates an existing Habit's mutable fields.
     *
     * @param habit the Habit with updated values (must have a valid id)
     * @return the merged (managed) Habit instance
     */
    public Habit update(Habit habit) {
        Transaction tx = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            tx = session.beginTransaction();
            Habit merged = session.merge(habit);   // Hibernate 6: merge() replaces update()
            tx.commit();
            return merged;
        } catch (Exception e) {
            if (tx != null) tx.rollback();
            throw new RuntimeException("Error updating habit: " + e.getMessage(), e);
        }
    }

    // ---------------------------------------------------------------
    // DELETE
    // ---------------------------------------------------------------

    /**
     * Deletes a Habit and all its associated completions from the database.
     *
     * @param id the id of the habit to delete
     * @return true if deleted, false if not found
     */
    public boolean deleteById(Long id) {
        Transaction tx = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            tx = session.beginTransaction();
            Habit habit = session.get(Habit.class, id);
            if (habit == null) {
                tx.rollback();
                return false;
            }
            session.remove(habit);         // Hibernate 6: remove() replaces delete()
            tx.commit();
            return true;
        } catch (Exception e) {
            if (tx != null) tx.rollback();
            throw new RuntimeException("Error deleting habit id " + id + ": " + e.getMessage(), e);
        }
    }
}
