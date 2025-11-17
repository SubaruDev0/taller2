package com.taller2.dao;

import com.taller2.util.DatabaseConnection;

import java.sql.Connection;
import java.sql.SQLException;

/**
 * Clase base para todos los DAOs (Data Access Objects)
 *
 * Proporciona acceso a la conexión de base de datos mediante el Singleton
 * y métodos comunes para todas las clases DAO.
 */
public abstract class BaseDAO {

    /**
     * Obtiene una conexión a la base de datos
     *
     * @return objeto Connection
     * @throws SQLException si hay error al obtener la conexión
     */
    protected Connection getConnection() throws SQLException {
        return DatabaseConnection.getInstance().getConnection();
    }

    /**
     * Cierra los recursos de base de datos de forma segura
     *
     * @param autoCloseable recursos que implementan AutoCloseable (Connection, Statement, ResultSet)
     */
    protected void closeResources(AutoCloseable... autoCloseable) {
        for (AutoCloseable resource : autoCloseable) {
            if (resource != null) {
                try {
                    resource.close();
                } catch (Exception e) {
                    System.err.println("✗ Error al cerrar recurso: " + e.getMessage());
                }
            }
        }
    }
}

