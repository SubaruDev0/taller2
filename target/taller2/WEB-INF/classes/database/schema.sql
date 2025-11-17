-- ========================================
-- Script de Esquema de Base de Datos
-- Proyecto: Taller 2
-- Base de Datos: taller2_bd
-- ========================================

-- Este archivo está preparado para agregar tablas en el futuro
-- Ejecutar con: psql -U postgres -d taller2_bd -f schema.sql

-- Ejemplo de tabla (comentado, para uso futuro):
/*
CREATE TABLE IF NOT EXISTS usuarios (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
*/

-- Por ahora, la base de datos está vacía y lista para desarrollo
# Archivos compilados
target/
*.class
*.war
*.ear
*.jar

# Logs
*.log

# IDE - IntelliJ IDEA
.idea/
*.iml
*.iws
out/

# IDE - Eclipse
.classpath
.project
.settings/

# Maven
.mvn/
mvnw
mvnw.cmd

# Sistema operativo
.DS_Store
Thumbs.db

# Configuración local
*.local

# Backup files
*.bak
*~

