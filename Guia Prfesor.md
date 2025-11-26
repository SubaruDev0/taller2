# Guía Rápida de Despliegue - Clínica Dental

## Requisitos Previos

- Java JDK 8 o superior
- Maven
- GlassFish Server 4.1.1 (configurado en el PATH o en el script de despliegue)
- PostgreSQL (Base de datos `taller2_bd` creada)

## Despliegue en un paso

Hemos preparado un script para facilitar la compilación y el despliegue.

1. **Dar permisos de ejecución al script:**

    ```bash
    chmod +x desplegar.sh
    ```

2. **Ejecutar el script:**

    ```bash
    ./desplegar.sh
    ```

Este script realizará lo siguiente:

- Limpiará el proyecto (`mvn clean`).
- Compilará y empaquetará el proyecto (`mvn package`).
- Desplegará el archivo WAR en GlassFish (`asadmin deploy --force ...`).

## Acceso a la Aplicación

Una vez desplegado correctamente, puede acceder a la aplicación en:

**[http://localhost:9000/taller2/](http://localhost:9000/taller2/)**

## Credenciales de Prueba

- **Administrador:**
  - Usuario: `subaru`
  - Contraseña: `123`

- **Usuario de prueba:**
  - Usuario: `blas`
  - Contraseña: `123`
