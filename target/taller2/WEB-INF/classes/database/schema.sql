-- ========================================
-- Script de Esquema de Base de Datos
-- Proyecto: Taller 2
-- Base de Datos: taller2_bd
-- ========================================

-- Ejecutar con: psql -U postgres -d taller2_bd -f schema.sql

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

-- Tabla de servicios (para que los admin puedan gestionar)
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

-- Tabla de turnos/citas
CREATE TABLE IF NOT EXISTS turnos (
    id SERIAL PRIMARY KEY,
    usuario_id INTEGER REFERENCES usuarios(id),
    servicio_id INTEGER REFERENCES servicios(id),
    fecha_turno DATE NOT NULL,
    hora_turno TIME NOT NULL,
    nombre_paciente VARCHAR(100) NOT NULL,
    rut VARCHAR(20) NOT NULL,
    telefono VARCHAR(20),
    email VARCHAR(100),
    comentarios TEXT,
    estado VARCHAR(20) DEFAULT 'PENDIENTE' CHECK (estado IN ('PENDIENTE', 'CONFIRMADO', 'CANCELADO', 'COMPLETADO')),
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

-- Insertar usuarios por defecto
INSERT INTO usuarios (usuario, contrasena, rol, nombre_completo, email) VALUES
('Subaru', '123', 'ADMIN', 'Subaru Admin', 'subaru@clinica.cl'),
('Matias', '123', 'ADMIN', 'Matias Admin', 'matias@clinica.cl'),
('Antonio', '1234', 'ADMIN', 'Antonio Admin', 'antonio@clinica.cl'),
('Blas', '123', 'USUARIO', 'Blas Usuario', 'blas@correo.cl')
ON CONFLICT (usuario) DO NOTHING;

-- Insertar servicios por defecto
INSERT INTO servicios (nombre, descripcion, imagen, precio, duracion_minutos) VALUES
('Ortodoncia', 'Corrección de la posición de los dientes y huesos maxilares', 'Ortodoncia.jpg', 500000, 60),
('Implantes Dentales', 'Reemplazo de dientes perdidos con implantes de titanio', 'Implantes.jpg', 800000, 90),
('Endodoncia', 'Tratamiento de conductos para salvar tus piezas dentales', 'Endodoncia.png', 150000, 60),
('Periodoncia', 'Cuidado y tratamiento especializado de encías', 'Periodoncia.jpg', 120000, 45),
('Blanqueamiento Dental', 'Recupera la estética y color natural de tu sonrisa', 'Blanqueamiento.jpg', 80000, 60),
('Odontología General', 'Consultas y tratamientos dentales generales', 'images.jpg', 30000, 30)
ON CONFLICT DO NOTHING;
