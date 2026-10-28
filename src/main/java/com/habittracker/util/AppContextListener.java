package com.habittracker.util;

import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;
import jakarta.servlet.annotation.WebListener;

/**
 * ServletContextListener that manages the Hibernate SessionFactory lifecycle.
 *
 * - On application startup  : initialises HibernateUtil (builds SessionFactory)
 * - On application shutdown : closes the SessionFactory gracefully
 *
 * AIP Concept Demonstrated:
 *   - ServletContextListener for application-level lifecycle management
 *   - Proper resource cleanup to avoid connection pool leaks
 */
@WebListener
public class AppContextListener implements ServletContextListener {

    /**
     * Called when the web application is deployed / Tomcat starts.
     * Eagerly initialises the Hibernate SessionFactory so the first
     * request does not pay the initialisation cost.
     */
    @Override
    public void contextInitialized(ServletContextEvent sce) {
        System.out.println("[AppContextListener] Application starting — initialising Hibernate...");
        try {
            // Triggers the static initialiser block in HibernateUtil
            HibernateUtil.getSessionFactory();
            System.out.println("[AppContextListener] Hibernate initialised successfully.");
        } catch (Exception e) {
            System.err.println("[AppContextListener] FATAL: Hibernate initialisation failed: " + e.getMessage());
            // Let Tomcat know startup failed
            throw new RuntimeException("Hibernate initialisation failed", e);
        }
    }

    /**
     * Called when Tomcat shuts down or undeploys the application.
     * Closes the SessionFactory to release database connections.
     */
    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        System.out.println("[AppContextListener] Application stopping — closing Hibernate SessionFactory...");
        HibernateUtil.shutdown();
    }
}
