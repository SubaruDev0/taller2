# 🚀 GUÍA RÁPIDA - Sistema de Gestión Clínica Dental

## 📋 Tabla de Contenidos
1. [Clonar y Configurar en Otro PC](#clonar-proyecto)
2. [Requisitos del Sistema](#requisitos)
3. [Instalación de Dependencias](#instalación)
4. [Configuración de Base de Datos](#base-datos)
5. [Compilar y Desplegar](#desplegar)
6. [Comandos Útiles](#comandos)
7. [Solución de Problemas](#problemas)

---

## 🖥️ CLONAR Y CONFIGURAR EN OTRO PC {#clonar-proyecto}

### 1. Clonar el Repositorio

```bash
# Clonar desde GitHub
git clone https://github.com/SubaruDev0/taller2.git
cd taller2

# O si ya tienes el repositorio
cd /ruta/donde/clonaste/taller2
```

### 2. Verificar Estructura

Asegúrate de tener esta estructura:

```
taller2/
├── src/
│   ├── main/
│   │   ├── java/com/taller2/
│   │   ├── resources/database/
│   │   └── webapp/
│   │       ├── img/              # Imágenes (26+ archivos)
│   │       ├── WEB-INF/views/    # JSP con CSS/JS inline
│   │       ├── index.jsp
│   │       └── WEB-INF/web.xml
├── pom.xml
├── desplegar.sh
├── GUIA_RAPIDA.md
├── DOCUMENTACION_TECNICA.md
└── .gitignore
```

### 3. Configurar Variables de Entorno

```bash
# Agregar al ~/.bashrc o ~/.zshrc

# Java (ajustar según tu instalación)
export JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64
export PATH=$JAVA_HOME/bin:$PATH

# Maven
export MAVEN_HOME=/usr/share/maven
export PATH=$MAVEN_HOME/bin:$PATH

# GlassFish
export GLASSFISH_HOME=/opt/glassfish6
export PATH=$GLASSFISH_HOME/bin:$PATH

# Aplicar cambios
source ~/.bashrc
```

### 4. Verificar Instalaciones

```bash
java -version      # Debe mostrar: openjdk 11.x.x o superior
mvn -version       # Debe mostrar: Apache Maven 3.8.x o superior
psql --version     # Debe mostrar: psql (PostgreSQL) 13.x o superior
asadmin version    # Debe mostrar: GlassFish 6.2.5
```

---

## 📦 REQUISITOS DEL SISTEMA {#requisitos}

| Componente | Versión Mínima | Versión Recomendada |
|------------|----------------|---------------------|
| **Java JDK** | 11 | 11 o 17 |
| **Maven** | 3.6.0 | 3.8.7+ |
| **PostgreSQL** | 13 | 13+ o 14+ |
| **GlassFish** | 6.2.5 | 6.2.5 |
| **SO** | Linux/Windows/Mac | Ubuntu 20.04+ / Windows 10+ |
| **RAM** | 4 GB | 8 GB+ |
| **Disco** | 2 GB libres | 5 GB+ |

---

## 🔧 INSTALACIÓN DE DEPENDENCIAS {#instalación}

### En Ubuntu/Debian

```bash
# Actualizar repositorios
sudo apt update

# Instalar Java 11
sudo apt install openjdk-11-jdk -y

# Instalar Maven
sudo apt install maven -y

# Instalar PostgreSQL
sudo apt install postgresql postgresql-contrib -y

# Iniciar PostgreSQL
sudo systemctl start postgresql
sudo systemctl enable postgresql

# Descargar GlassFish 6.2.5
cd /tmp
wget https://download.eclipse.org/ee4j/glassfish/glassfish-6.2.5.zip
sudo unzip glassfish-6.2.5.zip -d /opt/
sudo mv /opt/glassfish6 /opt/glassfish6

# Dar permisos
sudo chmod -R 755 /opt/glassfish6
```

### En Windows

1. **Java JDK 11:**
   - Descargar desde: https://adoptium.net/
   - Instalar y agregar a PATH
   - Verificar: `java -version`

2. **Maven:**
   - Descargar desde: https://maven.apache.org/download.cgi
   - Extraer y agregar bin/ a PATH
   - Verificar: `mvn -version`

3. **PostgreSQL:**
   - Descargar desde: https://www.postgresql.org/download/windows/
   - Instalar con contraseña para usuario `postgres`

4. **GlassFish:**
   - Descargar: https://glassfish.org/download
   - Extraer en `C:\glassfish6`
   - Agregar `C:\glassfish6\bin` a PATH

### En macOS

```bash
# Instalar Homebrew si no lo tienes
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Instalar Java 11
brew install openjdk@11

# Instalar Maven
brew install maven

# Instalar PostgreSQL
brew install postgresql@14
brew services start postgresql@14

# Descargar GlassFish
cd ~/Downloads
curl -O https://download.eclipse.org/ee4j/glassfish/glassfish-6.2.5.zip
unzip glassfish-6.2.5.zip
sudo mv glassfish6 /opt/
```

---

## 🗄️ CONFIGURACIÓN DE BASE DE DATOS {#base-datos}

### 1. Conectarse a PostgreSQL

```bash
# En Linux/Mac
sudo -u postgres psql

# En Windows (desde cmd como administrador)
psql -U postgres
```

### 2. Crear Base de Datos

```sql
-- Crear la base de datos
CREATE DATABASE taller2_bd;

-- Conectarse a la base de datos
\c taller2_bd

-- Crear las tablas (ejecutar el script completo)
-- El archivo está en: src/main/resources/database/schema.sql
```

### 3. Ejecutar Script SQL desde Terminal

```bash
# Desde la raíz del proyecto
cd taller2

# Ejecutar script
psql -U postgres -d taller2_bd -f src/main/resources/database/schema.sql

# O ejecutar create_database.sql
psql -U postgres -d taller2_bd -f src/main/resources/database/create_database.sql
```

### 4. Verificar Tablas Creadas

```sql
-- Dentro de psql
\c taller2_bd
\dt

-- Debe mostrar:
-- usuarios
-- turnos
-- comentarios
```

### 5. Crear Usuario Admin de Prueba

```sql
INSERT INTO usuarios (usuario, contrasena, rol, nombre_completo, email, activo) 
VALUES ('admin', 'admin123', 'ADMIN', 'Administrador', 'admin@clinica.cl', true);

INSERT INTO usuarios (usuario, contrasena, rol, nombre_completo, email, activo) 
VALUES ('user', 'user123', 'USUARIO', 'Usuario Prueba', 'user@test.cl', true);
```

### 6. Configurar Conexión en el Código

Si usas credenciales diferentes, edita:

```java
// src/main/java/com/taller2/util/DatabaseConnection.java

private static final String URL = "jdbc:postgresql://localhost:5432/taller2_bd";
private static final String USER = "postgres";     // Cambiar si es necesario
private static final String PASSWORD = "postgres"; // Cambiar a tu contraseña
```

---

## 🚀 COMPILAR Y DESPLEGAR {#desplegar}

### 1. Iniciar GlassFish

```bash
# Iniciar dominio
asadmin start-domain

# Verificar que esté corriendo
asadmin list-domains

# Configurar puerto 9000 (si no está configurado)
asadmin set configs.config.server-config.network-config.network-listeners.network-listener.http-listener-1.port=9000
asadmin restart-domain
```

### 2. Compilar el Proyecto

```bash
# Desde la raíz del proyecto
cd taller2

# Limpiar y compilar
mvn clean package

# Resultado esperado:
# [INFO] BUILD SUCCESS
# [INFO] ------------------------------------------------------------------------
# Archivo generado: target/taller2.war
```

### 3. Desplegar en GlassFish

```bash
# Opción 1: Comando manual
asadmin deploy --force target/taller2.war

# Opción 2: Script automatizado (Linux/Mac)
chmod +x desplegar.sh
./desplegar.sh

# Verificar despliegue
asadmin list-applications
# Debe mostrar: taller2
```

### 4. Acceder a la Aplicación

Abrir navegador en:

```
🌐 Página principal:
http://localhost:9000/taller2/

📄 Páginas disponibles:
http://localhost:9000/taller2/inicio
http://localhost:9000/taller2/servicios
http://localhost:9000/taller2/equipo
http://localhost:9000/taller2/contacto
http://localhost:9000/taller2/login
http://localhost:9000/taller2/pedirTurno

🔍 Health Check:
http://localhost:9000/taller2/health
```

### 5. Probar Login

**Usuario Admin:**
- Usuario: `admin`
- Contraseña: `admin123`
- Acceso: Panel de administración

**Usuario Normal:**
- Usuario: `user`
- Contraseña: `user123`
- Acceso: Pedir turnos y comentar

**Invitado:**
- Clic en "Acceder como invitado"
- Solo visualización

---

## 🛠️ COMANDOS ÚTILES {#comandos}

### Maven

```bash
# Compilar sin tests
mvn clean package -DskipTests

# Limpiar target/
mvn clean

# Ver dependencias
mvn dependency:tree

# Ejecutar tests
mvn test
```

### GlassFish

```bash
# Iniciar/Detener/Reiniciar
asadmin start-domain
asadmin stop-domain
asadmin restart-domain

# Ver aplicaciones desplegadas
asadmin list-applications

# Desplegar con force (sobrescribe)
asadmin deploy --force target/taller2.war

# Desplegar aplicación
asadmin undeploy taller2

# Ver logs en tiempo real
tail -f $GLASSFISH_HOME/glassfish/domains/domain1/logs/server.log

# Cambiar puerto HTTP
asadmin set configs.config.server-config.network-config.network-listeners.network-listener.http-listener-1.port=9000
```

### PostgreSQL

```bash
# Conectar a base de datos
psql -U postgres -d taller2_bd

# Listar bases de datos
\l

# Listar tablas
\dt

# Ver contenido de tabla
SELECT * FROM usuarios;

# Salir
\q

# Backup de la base de datos
pg_dump -U postgres taller2_bd > backup_taller2.sql

# Restaurar backup
psql -U postgres -d taller2_bd < backup_taller2.sql
```

### Git

```bash
# Ver estado
git status

# Agregar cambios
git add .

# Commit
git commit -m "Descripción del cambio"

# Push
git push origin main

# Pull (actualizar desde remoto)
git pull origin main

# Ver historial
git log --oneline

# Crear rama
git checkout -b feature/nueva-funcionalidad
```

---

## 🔧 SOLUCIÓN DE PROBLEMAS {#problemas}

### 1. Error: "Connection refused" a PostgreSQL

**Síntomas:**
```
org.postgresql.util.PSQLException: Connection refused
```

**Soluciones:**

```bash
# Verificar que PostgreSQL esté corriendo
sudo systemctl status postgresql

# Iniciar PostgreSQL
sudo systemctl start postgresql

# Verificar puerto (debe ser 5432)
sudo netstat -plunt | grep postgres

# Verificar que la BD existe
psql -U postgres -c "\l" | grep taller2_bd
```

### 2. Error: "BUILD FAILURE" en Maven

**Síntomas:**
```
[ERROR] Failed to execute goal
```

**Soluciones:**

```bash
# Limpiar cache de Maven
mvn clean

# Actualizar dependencias
mvn dependency:purge-local-repository

# Verificar Java version
java -version  # Debe ser 11+

# Verificar JAVA_HOME
echo $JAVA_HOME

# Recompilar
mvn clean package -U
```

### 3. Error 404: Página no encontrada

**Soluciones:**

```bash
# Verificar que la app esté desplegada
asadmin list-applications

# Si no aparece, redesplegar
asadmin deploy --force target/taller2.war

# Verificar URL completa
# http://localhost:9000/taller2/inicio
#                      ↑        ↑
#               context-path  servlet-mapping

# Ver logs del servidor
tail -f $GLASSFISH_HOME/glassfish/domains/domain1/logs/server.log
```

### 4. Error 500: Internal Server Error

**Soluciones:**

```bash
# Ver logs detallados
tail -n 100 $GLASSFISH_HOME/glassfish/domains/domain1/logs/server.log

# Verificar conexión a BD
psql -U postgres -d taller2_bd -c "SELECT 1;"

# Verificar credenciales en DatabaseConnection.java
# USER y PASSWORD deben coincidir con PostgreSQL

# Limpiar y redesplegar
mvn clean package
asadmin undeploy taller2
asadmin deploy target/taller2.war
```

### 5. Puerto 9000 ya en uso

**Soluciones:**

```bash
# Encontrar proceso usando puerto 9000
lsof -i :9000

# Matar proceso
kill -9 <PID>

# O cambiar GlassFish a otro puerto
asadmin set configs.config.server-config.network-config.network-listeners.network-listener.http-listener-1.port=8080
asadmin restart-domain
```

### 6. "Class file has wrong version"

**Síntomas:**
```
Unsupported class file major version 65
```

**Solución:**

```bash
# Verificar que compile a Java 11
# En pom.xml debe tener:
# <maven.compiler.release>11</maven.compiler.release>

# Limpiar y recompilar
mvn clean package

# Verificar versión compilada
javap -v target/classes/com/taller2/controller/LoginServlet.class | grep "major version"
# Debe mostrar: major version: 55 (Java 11)
```

### 7. Cambios en JSP no se reflejan

**Soluciones:**

```bash
# Redesplegar forzando
asadmin deploy --force target/taller2.war

# O desplegar y volver a desplegar
asadmin undeploy taller2
mvn clean package
asadmin deploy target/taller2.war

# Limpiar cache del navegador
# Chrome/Firefox: Ctrl + Shift + R (hard reload)
```

---

## 📊 VERIFICACIÓN COMPLETA DEL SISTEMA

### Health Check Rápido

```bash
# 1. Java
java -version

# 2. Maven
mvn -version

# 3. PostgreSQL
psql -U postgres -c "SELECT version();"

# 4. GlassFish
asadmin list-domains

# 5. Base de datos
psql -U postgres -d taller2_bd -c "\dt"

# 6. Aplicación desplegada
asadmin list-applications

# 7. Endpoint de salud
curl -s http://localhost:9000/taller2/health

# Respuesta esperada: "OK - Servlet operativo"
```

### Script de Verificación Completo

```bash
#!/bin/bash
echo "🔍 Verificando Sistema..."

echo -n "✓ Java: "
java -version 2>&1 | head -n 1

echo -n "✓ Maven: "
mvn -version 2>&1 | head -n 1

echo -n "✓ PostgreSQL: "
psql -U postgres -c "SELECT version();" 2>&1 | head -n 1

echo -n "✓ GlassFish: "
asadmin version 2>&1 | grep "GlassFish"

echo -n "✓ Base de datos 'taller2_bd': "
psql -U postgres -l | grep taller2_bd

echo -n "✓ Aplicación desplegada: "
asadmin list-applications 2>&1 | grep taller2

echo -n "✓ Health endpoint: "
curl -s http://localhost:9000/taller2/health

echo ""
echo "✅ Verificación completa!"
```

---

## 🎯 RESUMEN DE COMANDOS ESENCIALES

### Setup Inicial (Solo primera vez)

```bash
# 1. Clonar repositorio
git clone https://github.com/SubaruDev0/taller2.git
cd taller2

# 2. Crear base de datos
psql -U postgres -c "CREATE DATABASE taller2_bd;"
psql -U postgres -d taller2_bd -f src/main/resources/database/schema.sql

# 3. Iniciar GlassFish
asadmin start-domain

# 4. Configurar puerto
asadmin set configs.config.server-config.network-config.network-listeners.network-listener.http-listener-1.port=9000
asadmin restart-domain

# 5. Compilar y desplegar
mvn clean package
asadmin deploy target/taller2.war
```

### Flujo de Trabajo Diario

```bash
# 1. Iniciar servicios
sudo systemctl start postgresql  # Si no está corriendo
asadmin start-domain             # Si no está corriendo

# 2. Hacer cambios en el código
# ... editar archivos ...

# 3. Recompilar y redesplegar
mvn clean package
asadmin deploy --force target/taller2.war

# 4. Ver logs
tail -f $GLASSFISH_HOME/glassfish/domains/domain1/logs/server.log

# 5. Commit y push (al finalizar)
git add .
git commit -m "Descripción de cambios"
git push origin main
```

---

## 📞 CONTACTO Y RECURSOS

**Repositorio:** https://github.com/SubaruDev0/taller2

**Documentación Técnica Completa:** Ver `DOCUMENTACION_TECNICA.md`

**Arquitectura del Sistema:** Ver `ARQUITECTURA.md`

**Sistema de Autenticación:** Ver `SISTEMA_AUTH.md`

---

## ✅ CHECKLIST DE CONFIGURACIÓN

- [ ] Java 11+ instalado y configurado
- [ ] Maven 3.8+ instalado
- [ ] PostgreSQL 13+ instalado y corriendo
- [ ] GlassFish 6.2.5 descargado y configurado
- [ ] Base de datos `taller2_bd` creada
- [ ] Tablas creadas con schema.sql
- [ ] Usuario admin creado en BD
- [ ] Variables de entorno configuradas
- [ ] Proyecto clonado desde GitHub
- [ ] Compilación exitosa (mvn clean package)
- [ ] Aplicación desplegada en GlassFish
- [ ] Puerto 9000 configurado
- [ ] Acceso a http://localhost:9000/taller2/ funcionando
- [ ] Health endpoint respondiendo OK
- [ ] Login con usuario admin funciona

---

**¡Todo listo para desarrollar! 🚀**

## 🎨 CSS y JavaScript INLINE

**IMPORTANTE**: Todos los archivos JSP ahora tienen CSS y JavaScript inline (embebido).
No hay archivos externos .css o .js que cargar.

### Ventajas del CSS/JS Inline:
- ✅ Menos peticiones HTTP
- ✅ Carga más rápida
- ✅ Sin problemas de rutas relativas
- ✅ Todo autocontenido en cada JSP

## 📱 Páginas Disponibles

Todas estas rutas deberían mostrar estilos completos:

- **Inicio**: http://localhost:9000/taller2/
- **Servicios**: http://localhost:9000/taller2/servicios
- **Equipo**: http://localhost:9000/taller2/equipo
- **Contacto**: http://localhost:9000/taller2/contacto
- **Login**: http://localhost:9000/taller2/login
- **Pedir Turno**: http://localhost:9000/taller2/pedirTurno
- **Health Check**: http://localhost:9000/taller2/health

## Frontend: CSS y JS disponibles
Estructura de assets (ubicados en `src/main/webapp/`):
```
css/
  header-footer.css      # Estilos comunes de header y footer (✅ Creado)
  inicio.css             # Estilos página inicio (✅ Creado)
  servicios.css          # Grid y cards de servicios (✅ Creado)
  equipo.css             # Layout equipo y miembros (✅ Creado)
  contacto.css           # Mapa y tarjetas de contacto (✅ Creado)
  login.css              # Pantalla y formulario de login (✅ Creado)
  pedirTurno.css         # Formulario para solicitar turno (✅ Creado)
js/
  carrusel.js            # Lógica de carrusel de servicios (✅ Creado)
  contacto.js            # Inicialización de sección contacto (✅ Creado)
  login.js               # Comportamiento del formulario login (✅ Creado)
  restricciones.js       # Validaciones y formateo RUT (✅ Creado)
img/                     # Coloca aquí tus imágenes (logo, banner, etc.)
```

**IMPORTANTE**: Si los estilos no se cargan:
1. Verifica que los archivos existan: `ls -la src/main/webapp/css/`
2. Recompila: `mvn clean package`
3. Redesplega: `asadmin deploy --force target/taller2.war`
4. Refresca el navegador con Ctrl+Shift+R (refresh forzado)

### Cómo incluir CSS en un JSP
```jsp
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/inicio.css" />
```

### Cómo incluir JS al final del `<body>`
```jsp
<script src="${pageContext.request.contextPath}/js/carrusel.js"></script>
```

### Buenas prácticas
- Mantén componentes reutilizables en `header-footer.css`.
- Usa nombres coherentes (ej: `turnos.css`, `turnos.js` si agregas módulo de turnos avanzado).
- Evita lógica compleja inline: crea archivos en `js/`.
- Optimiza imágenes (formatos: `.webp` o `.avif` preferentes) dentro de `img/`.

### Agregar un nuevo asset
1. Crear archivo en carpeta correspondiente (`css/` o `js/`).
2. Referenciarlo en el JSP usando `${pageContext.request.contextPath}`.
3. Recompilar y desplegar (los archivos estáticos se empaquetan automáticamente en el WAR).

## Script opcional
Si prefieres automatizar:
```
./desplegar.sh
```
(Compila con Java 11 y despliega el WAR en GlassFish)

---
© 2025 Taller 2
