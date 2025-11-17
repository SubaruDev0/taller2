package com.taller2.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

/**
 * Clase Singleton para manejar la conexión a la base de datos PostgreSQL
 *
 * Esta clase implementa el patrón Singleton para asegurar que solo exista
 * una única instancia de conexión a la base de datos durante toda la ejecución.
 */
public class DatabaseConnection {

    private static DatabaseConnection instance;
    private Connection connection;

    // Configuración de la base de datos
    private static final String URL = "jdbc:postgresql://localhost:5432/taller2_bd";
    private static final String USER = "postgres";
    private static final String PASSWORD = "postgres";

    /**
     * Constructor privado para implementar el patrón Singleton
     */
    private DatabaseConnection() {
        try {
            // Cargar el driver de PostgreSQL
            Class.forName("org.postgresql.Driver");
            // Establecer la conexión
            this.connection = DriverManager.getConnection(URL, USER, PASSWORD);
            System.out.println("✓ Conexión a PostgreSQL establecida exitosamente");
        } catch (ClassNotFoundException e) {
            System.err.println("✗ Driver de PostgreSQL no encontrado: " + e.getMessage());
            e.printStackTrace();
        } catch (SQLException e) {
            System.err.println("✗ Error al conectar con la base de datos: " + e.getMessage());
            e.printStackTrace();
        }
    }

    /**
     * Método para obtener la única instancia de DatabaseConnection
     *
     * @return instancia única de DatabaseConnection
     */
    public static synchronized DatabaseConnection getInstance() {
        if (instance == null) {
            instance = new DatabaseConnection();
        }
        return instance;
    }

    /**
     * Obtiene la conexión a la base de datos
     *
     * @return objeto Connection
     * @throws SQLException si hay error al obtener la conexión
     */
    public Connection getConnection() throws SQLException {
        // Verificar si la conexión está cerrada o es nula
        if (connection == null || connection.isClosed()) {
            try {
                connection = DriverManager.getConnection(URL, USER, PASSWORD);
                System.out.println("✓ Reconexión a PostgreSQL establecida");
            } catch (SQLException e) {
                System.err.println("✗ Error al reconectar con la base de datos: " + e.getMessage());
                throw e;
            }
        }
        return connection;
    }

    /**
     * Cierra la conexión a la base de datos
     */
    public void closeConnection() {
        try {
            if (connection != null && !connection.isClosed()) {
                connection.close();
                System.out.println("✓ Conexión a PostgreSQL cerrada");
            }
        } catch (SQLException e) {
            System.err.println("✗ Error al cerrar la conexión: " + e.getMessage());
            e.printStackTrace();
        }
    }
}
