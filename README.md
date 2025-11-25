# 🦷 Sistema de Gestión Clínica Dental

[![Build Status](https://img.shields.io/badge/build-passing-brightgreen)]()
[![Java](https://img.shields.io/badge/Java-11-orange)]()
[![PostgreSQL](https://img.shields.io/badge/PostgreSQL-15-blue)]()
[![License](https://img.shields.io/badge/license-MIT-green)]()

## 📋 Descripción

Sistema web completo para la gestión integral de una clínica dental. Permite a los pacientes visualizar servicios, agendar citas y dejar comentarios. Los administradores cuentan con un panel de control para gestionar usuarios, servicios, citas y comentarios.

## ✨ Características Principales

### Para Pacientes
- ✅ Visualización de servicios dentales con imágenes y precios
- ✅ Solicitud de citas online con pre-selección de servicios
- ✅ Sistema de comentarios y testimonios
- ✅ Registro y autenticación de usuarios
- ✅ Interfaz responsive (móvil, tablet, escritorio)

### Para Administradores
- ✅ Panel de control completo
- ✅ Gestión dinámica de servicios (CRUD completo)
- ✅ **Upload de imágenes con Drag & Drop**
- ✅ Aprobación/rechazo de citas
- ✅ Moderación de comentarios
- ✅ Gestión de usuarios

## 🚀 Tecnologías Utilizadas

### Backend
- **Java 11** - Lenguaje de programación
- **Jakarta EE** - Servlets, JSP
- **Maven** - Gestión de dependencias
- **JDBC** - Conectividad con base de datos
- **PostgreSQL 15** - Base de datos relacional

### Frontend
- **HTML5** - Estructura
- **CSS3** - Estilos y diseño responsive
- **JavaScript (Vanilla)** - Interactividad
- **Drag & Drop API** - Upload de imágenes intuitivo
- **Fetch API** - Comunicación asíncrona

### Servidor
- **GlassFish 4.1.1** - Servidor de aplicaciones Java EE

## 📁 Estructura del Proyecto

```
Taller2/
├── src/main/java/com/taller2/
│   ├── controller/     # Servlets (Controladores MVC)
│   ├── dao/            # Acceso a datos (DAOs)
│   ├── model/          # Entidades (POJOs)
│   └── util/           # Utilidades (Conexión BD)
├── src/main/webapp/
│   ├── WEB-INF/views/  # Vistas JSP
│   └── img/            # Imágenes
├── DOCUMENTACION_TECNICA.md  # Documentación completa
├── GUIA_RAPIDA.md            # Guía de despliegue
└── pom.xml                   # Configuración Maven
```

## 🛠️ Instalación y Despliegue

### Requisitos Previos
- JDK 11 o superior
- Maven 3.6+
- GlassFish Server 4.1.1
- PostgreSQL 15

### Pasos de Instalación

1. **Clonar el repositorio**
   ```bash
   git clone https://github.com/SubaruDev0/taller2.git
   cd taller2
   ```

2. **Configurar la base de datos**
   ```bash
   psql -U postgres -d taller2_bd -f src/main/resources/database/schema.sql
   ```

3. **Compilar el proyecto**
   ```bash
   mvn clean package
   ```

4. **Desplegar en GlassFish**
   ```bash
   asadmin deploy --force target/taller2.war
   ```

5. **Acceder a la aplicación**
   ```
   http://localhost:9000/taller2/
   ```

### Script de Despliegue Automatizado
```bash
./desplegar.sh
```

## 📚 Documentación

- **[Documentación Técnica Completa](DOCUMENTACION_TECNICA.md)** - Arquitectura, componentes, FAQ
- **[Guía Rápida](GUIA_RAPIDA.md)** - Despliegue simplificado
- **[Guía de Usuario](GUIA_USUARIO.md)** - Manual de uso

## 🎯 Funcionalidades Destacadas

### 1. Upload de Imágenes con Drag & Drop

Sistema intuitivo de carga de imágenes implementado con:
- **HTML5 Drag & Drop API** para arrastrar archivos
- **FileReader API** para preview instantáneo
- **Fetch API** para envío asíncrono
- **Validaciones robustas** (tipo, tamaño, formato)

```javascript
// Preview instantáneo antes de subir
reader.onload = (e) => {
    previewImg.src = e.target.result;
};
```

### 2. Pre-selección de Servicios

Al hacer clic en "Agendar" desde una tarjeta de servicio, el formulario se abre con ese servicio ya seleccionado:

```java
// Servlet captura el parámetro
String servicioId = request.getParameter("servicioId");
request.setAttribute("servicioIdPreseleccionado", servicioId);
```

### 3. Arquitectura MVC

Separación clara de responsabilidades:
- **Modelo**: POJOs representando entidades
- **Vista**: JSPs con HTML dinámico
- **Controlador**: Servlets procesando lógica

## 🔐 Seguridad

- ✅ Contraseñas almacenadas con hash
- ✅ Validaciones en cliente y servidor
- ✅ Sesiones gestionadas con HttpSession
- ✅ Control de acceso basado en roles (ADMIN/CLIENTE)
- ✅ Protección contra inyección SQL (PreparedStatements)

## 👥 Roles de Usuario

### CLIENTE
- Ver servicios públicos
- Solicitar citas
- Dejar comentarios

### ADMIN
- Todas las funciones de CLIENTE
- Gestionar servicios (crear, editar, desactivar)
- Aprobar/rechazar citas
- Moderar comentarios
- Ver panel de administración

## 📊 Base de Datos

### Tablas Principales
- `usuarios` - Credenciales y datos personales
- `servicios` - Catálogo de tratamientos dentales
- `citas` - Registro de citas solicitadas
- `comentarios` - Testimonios de pacientes

### Relaciones
- `citas.usuario_id` → `usuarios.id`
- `citas.servicio_id` → `servicios.id`
- `comentarios.usuario_id` → `usuarios.id`

## 🧪 Testing

### Verificación Manual

1. **Test de Citas**:
   - Ir a `/servicios`
   - Clic en "Agendar" de un servicio
   - Verificar pre-selección
   - Completar y enviar formulario

2. **Test de Upload**:
   - Login como admin
   - Ir a `/panel`
   - Arrastrar imagen al formulario
   - Verificar preview
   - Guardar servicio

3. **Test de Roles**:
   - Login como cliente
   - Verificar que no puede acceder a `/panel`
   - Login como admin
   - Verificar acceso completo

## 🚀 Próximas Mejoras

- [ ] Notificaciones por email
- [ ] Calendario interactivo
- [ ] Sistema de pagos online
- [ ] API REST para app móvil
- [ ] Reportes y estadísticas
- [ ] Chat en vivo

## 📝 FAQ

### ¿Cómo funciona el Drag & Drop?
Utiliza la HTML5 Drag & Drop API combinada con FileReader para preview y Fetch API para envío asíncrono al servidor. Ver [Documentación Técnica](DOCUMENTACION_TECNICA.md#41-upload-de-imágenes-con-drag--drop) para detalles.

### ¿Por qué JSP y no React/Angular?
JSP permite integración nativa con Java EE sin necesidad de APIs REST intermedias, simplificando el desarrollo para proyectos medianos. Ver [FAQ Completo](DOCUMENTACION_TECNICA.md#7-preguntas-frecuentes-faq).

### ¿Qué son los DAOs?
Data Access Objects - patrón que encapsula la lógica de acceso a datos, separándola de la lógica de negocio. Ver [Documentación de DAOs](DOCUMENTACION_TECNICA.md#34-acceso-a-datos-comtaller2dao).

## 👨‍💻 Autores

**Equipo de Desarrollo Taller2**
- GitHub: [@SubaruDev0](https://github.com/SubaruDev0)

## 📄 Licencia

Este proyecto está bajo la Licencia MIT - ver el archivo LICENSE para más detalles.

## 🙏 Agradecimientos

- Comunidad de Java EE
- PostgreSQL Team
- GlassFish Server
- Stack Overflow Community

---

**Versión**: 2.0  
**Última actualización**: Noviembre 2025  
**Estado**: ✅ Producción

---

### 💡 Tip para Presentación

Este proyecto demuestra:
1. **Arquitectura sólida**: Patrón MVC bien implementado
2. **UX moderna**: Drag & Drop, pre-selección intuitiva
3. **Código limpio**: Separación de responsabilidades, DAOs
4. **Seguridad**: Validaciones dobles, control de acceso
5. **Documentación completa**: Código auto-explicativo y docs detalladas

¡Perfecto para demostrar competencias en desarrollo web Java EE! 🚀
