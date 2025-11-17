-- ========================================
-- Script de Creación de Base de Datos
-- Proyecto: Taller 2
-- Base de Datos: taller2_bd
-- ========================================

-- Este script está preparado para futuras tablas
-- Por ahora solo crea la base de datos

-- NOTA: Este script se debe ejecutar como superusuario de PostgreSQL
-- Comando: psql -U postgres -f create_database.sql

-- Crear la base de datos si no existe
-- (Ejecutar esta parte fuera de una transacción)

-- Verificar conexión
SELECT version();

-- Listar bases de datos existentes
SELECT datname FROM pg_database WHERE datname = 'taller2_bd';

-- Si necesitas eliminar la base de datos primero (cuidado en producción):
-- DROP DATABASE IF EXISTS taller2_bd;

-- Crear la base de datos
-- CREATE DATABASE taller2_bd;

-- Mensaje de confirmación
-- La base de datos taller2_bd está lista para ser utilizada

