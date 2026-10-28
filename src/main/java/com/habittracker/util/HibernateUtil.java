package com.habittracker.util;

import org.hibernate.SessionFactory;
import org.hibernate.boot.registry.StandardServiceRegistryBuilder;
import org.hibernate.cfg.Configuration;
import org.hibernate.service.ServiceRegistry;

/**
 * Utility class that creates and manages the Hibernate SessionFactory.
 *
 * AIP Concept Demonstrated:
 *   - Hibernate SessionFactory initialisation
 *   - Reading hibernate.cfg.xml from the classpath
 *   - Singleton pattern for the SessionFactory (expensive to create)
 *
 * Hibernate 6 changes from Hibernate 5:
 *   - Dialect class moved to org.hibernate.dialect.MySQLDialect (auto-detected)
 *   - session.save()   → session.persist()
 *   - session.update() → session.merge()
 *   - session.delete() → session.remove()
 */
public class HibernateUtil {

    /**
     * Singleton SessionFactory — created once per application lifetime.
     */
    private static SessionFactory sessionFactory;

    static {
        try {
            Configuration configuration = new Configuration();
            // Loads hibernate.cfg.xml from the root of the classpath
            configuration.configure("hibernate.cfg.xml");
            configuration.addAnnotatedClass(com.habittracker.entity.Habit.class);
            configuration.addAnnotatedClass(com.habittracker.entity.HabitCompletion.class);

            ServiceRegistry serviceRegistry = new StandardServiceRegistryBuilder()
                    .applySettings(configuration.getProperties())
                    .build();

            sessionFactory = configuration.buildSessionFactory(serviceRegistry);

            System.out.println("[HibernateUtil] SessionFactory created successfully.");

        } catch (Exception ex) {
            System.err.println("[HibernateUtil] SessionFactory creation FAILED: " + ex.getMessage());
            throw new ExceptionInInitializerError(ex);
        }
    }

    /**
     * Returns the application-wide SessionFactory.
     */
    public static SessionFactory getSessionFactory() {
        return sessionFactory;
    }

    /**
     * Closes the SessionFactory on application shutdown.
     * Called by AppContextListener.contextDestroyed().
     */
    public static void shutdown() {
        if (sessionFactory != null && !sessionFactory.isClosed()) {
            sessionFactory.close();
            System.out.println("[HibernateUtil] SessionFactory closed.");
        }
    }
}
