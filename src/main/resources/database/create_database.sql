-- ========================================
-- Script de Creación de Base de Datos
-- Proyecto: Taller 2 - Sistema de Gestión Clínica Dental
-- Base de Datos: taller2_bd
-- ========================================

-- NOTA: Este script se debe ejecutar como superusuario de PostgreSQL
-- Comando: sudo -u postgres psql -f create_database.sql

-- ========================================
-- PASO 1: Crear la base de datos
-- ========================================

-- Verificar versión de PostgreSQL
SELECT version();

-- Verificar si la base de datos ya existe
SELECT datname FROM pg_database WHERE datname = 'taller2_bd';

-- Crear la base de datos (ejecutar fuera de transacción)
-- Descomentar si necesitas crear la base de datos:
-- CREATE DATABASE taller2_bd
--     WITH 
--     OWNER = postgres
--     ENCODING = 'UTF8'
--     LC_COLLATE = 'es_CL.UTF-8'
--     LC_CTYPE = 'es_CL.UTF-8'
--     TABLESPACE = pg_default
--     CONNECTION LIMIT = -1;

-- ========================================
-- PASO 2: Conectarse a la base de datos
-- ========================================
-- Ejecutar: \c taller2_bd

-- ========================================
-- PASO 3: Crear las tablas
-- ========================================

-- Tabla de usuarios con roles
CREATE TABLE IF NOT EXISTS usuarios (
    id SERIAL PRIMARY KEY,
    usuario VARCHAR(50) UNIQUE NOT NULL,
    contrasena VARCHAR(255) NOT NULL,
    rol VARCHAR(20) NOT NULL CHECK (rol IN ('ADMIN', 'USUARIO')),
    nombre_completo VARCHAR(100),
    email VARCHAR(100),
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    activo BOOLEAN DEFAULT TRUE
);

-- Tabla de servicios dentales
CREATE TABLE IF NOT EXISTS servicios (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    descripcion TEXT,
    imagen VARCHAR(255),
    precio DECIMAL(10,2),
    duracion_minutos INTEGER,
    activo BOOLEAN DEFAULT TRUE,
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabla de citas (solicitudes de turno)
CREATE TABLE IF NOT EXISTS citas (
    id SERIAL PRIMARY KEY,
    usuario_id INTEGER REFERENCES usuarios(id),
    servicio_id INTEGER REFERENCES servicios(id),
    fecha_cita DATE NOT NULL,
    hora_cita TIME NOT NULL,
    nombre_paciente VARCHAR(100) NOT NULL,
    rut VARCHAR(12) NOT NULL, -- Formato: 12345678-9 (validado con algoritmo chileno)
    telefono VARCHAR(20),
    email VARCHAR(100),
    comentarios TEXT,
    estado VARCHAR(20) DEFAULT 'PENDIENTE' CHECK (estado IN ('PENDIENTE', 'APROBADA', 'RECHAZADA', 'CONFIRMADO', 'CANCELADO', 'COMPLETADO')),
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabla de comentarios/testimonios
CREATE TABLE IF NOT EXISTS comentarios (
    id SERIAL PRIMARY KEY,
    usuario_id INTEGER REFERENCES usuarios(id),
    nombre VARCHAR(100) NOT NULL,
    comentario TEXT NOT NULL,
    calificacion INTEGER CHECK (calificacion BETWEEN 1 AND 5),
    aprobado BOOLEAN DEFAULT FALSE,
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ========================================
-- PASO 4: Insertar datos iniciales
-- ========================================

-- Usuarios por defecto (contraseñas sin encriptar para desarrollo)
INSERT INTO usuarios (usuario, contrasena, rol, nombre_completo, email) VALUES
('Subaru', '123', 'ADMIN', 'Subaru Admin', 'subaru@clinica.cl'),
('Matias', '123', 'ADMIN', 'Matias Admin', 'matias@clinica.cl'),
('Antonio', '1234', 'ADMIN', 'Antonio Admin', 'antonio@clinica.cl'),
('Blas', '123', 'USUARIO', 'Blas Usuario', 'blas@correo.cl')
ON CONFLICT (usuario) DO NOTHING;

-- Servicios dentales por defecto
INSERT INTO servicios (nombre, descripcion, imagen, precio, duracion_minutos) VALUES
('Ortodoncia', 'Corrección de la posición de los dientes y huesos maxilares', 'Ortodoncia.jpg', 500000, 60),
('Implantes Dentales', 'Reemplazo de dientes perdidos con implantes de titanio', 'Implantes.jpg', 800000, 90),
('Endodoncia', 'Tratamiento de conductos para salvar tus piezas dentales', 'Endodoncia.png', 150000, 60),
('Periodoncia', 'Cuidado y tratamiento especializado de encías', 'Periodoncia.jpg', 120000, 45),
('Blanqueamiento Dental', 'Recupera la estética y color natural de tu sonrisa', 'Blanqueamiento.jpg', 80000, 60),
('Odontología General', 'Consultas y tratamientos dentales generales', 'images.jpg', 30000, 30)
ON CONFLICT DO NOTHING;

-- ========================================
-- VERIFICACIÓN FINAL
-- ========================================

-- Verificar tablas creadas
SELECT table_name FROM information_schema.tables 
WHERE table_schema = 'public' 
ORDER BY table_name;

-- Verificar usuarios insertados
SELECT COUNT(*) as total_usuarios FROM usuarios;

-- Verificar servicios insertados
SELECT COUNT(*) as total_servicios FROM servicios;

-- ========================================
-- NOTAS IMPORTANTES
-- ========================================

-- 1. VALIDACIÓN RUT: El sistema implementa validación de RUT chileno con algoritmo módulo 11
--    Los RUTs de prueba son: 11111111-1, 22222222-2, 33333333-3, 44444444-4
--
-- 2. ESTADOS DE CITAS:
--    - PENDIENTE: Cita solicitada, esperando aprobación
--    - APROBADA: Cita aprobada por administrador
--    - RECHAZADA: Cita rechazada por administrador
--    - CONFIRMADO: Paciente confirmó asistencia
--    - CANCELADO: Cita cancelada
--    - COMPLETADO: Cita realizada
--
-- 3. ROLES DE USUARIO:
--    - ADMIN: Acceso completo al panel de administración
--    - USUARIO: Acceso limitado, puede solicitar citas
--
-- 4. CONEXIÓN:
--    URL: jdbc:postgresql://localhost:5432/taller2_bd
--    Usuario: postgres
--    Contraseña: (configurar en DatabaseConnection.java)



