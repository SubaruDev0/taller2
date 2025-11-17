# 📘 DOCUMENTACIÓN TÉCNICA - Sistema de Gestión Clínica Dental

**Proyecto:** Taller2 - Sistema Web de Clínica Dental  
**Tecnologías:** Java 11, Jakarta EE 9, PostgreSQL, GlassFish 6.2.5  
**Fecha:** Noviembre 2025  
**Nivel:** Intermedio - Explicaciones completas y claras

---

## 📚 TABLA DE CONTENIDOS

1. [Descripción General del Proyecto](#descripción-general)
2. [Arquitectura del Sistema](#arquitectura)
3. [Patrón Singleton - Gestión de Conexiones](#patrón-singleton)
4. [Patrón DAO - Acceso a Datos](#patrón-dao)
5. [Servlets - Controladores HTTP](#servlets)
6. [Sistema de Autenticación](#autenticación)
7. [Gestión de Turnos y Comentarios](#turnos-comentarios)
8. [Panel de Administración](#panel-admin)
9. [Control de Acceso y Seguridad](#control-acceso)
10. [Frontend: Carruseles con JavaScript](#carruseles)
11. [Flujo de Datos Completo](#flujo-datos)
12. [Despliegue y Troubleshooting](#despliegue)

---

## 📋 DESCRIPCIÓN GENERAL DEL PROYECTO {#descripción-general}

### ¿Qué es este sistema?

Sistema web completo para la gestión de una clínica dental que permite:
- **Usuarios invitados:** Visualización de información pública
- **Usuarios registrados:** Solicitud de turnos y envío de comentarios
- **Administradores:** Gestión completa de usuarios, turnos y comentarios

### Tecnologías Principales

| Tecnología | Versión | Propósito |
|-----------|---------|-----------|
| **Java** | 11 | Lenguaje de programación backend |
| **Jakarta EE** | 9 | Framework para aplicaciones empresariales |
| **PostgreSQL** | 13+ | Base de datos relacional |
| **GlassFish** | 6.2.5 | Servidor de aplicaciones |
| **Maven** | 3.8.7 | Gestión de dependencias y construcción |
| **JSP** | 2.3 | Vistas dinámicas del lado del servidor |
| **JavaScript (ES5)** | Vanilla | Interactividad del lado del cliente |

### Stack Completo Explicado

**Backend (Servidor):**
- Java maneja toda la lógica de negocio
- Los Servlets procesan las peticiones HTTP
- Los DAO acceden a la base de datos
- El patrón Singleton gestiona las conexiones

**Frontend (Cliente):**
- JSP genera HTML dinámico
- JavaScript proporciona interactividad (carruseles, validaciones)
- CSS para estilos visuales

**Persistencia (Almacenamiento):**
- PostgreSQL almacena usuarios, turnos y comentarios
- Conexión mediante JDBC

---

## 🏗️ ARQUITECTURA DEL SISTEMA {#arquitectura}

### Patrón MVC (Model-View-Controller)

El proyecto sigue una arquitectura MVC modificada:

```
┌─────────────────────────────────────────────────┐
│                   CLIENTE                        │
│              (Navegador Web)                     │
└────────────────┬────────────────────────────────┘
                 │ HTTP Request
                 ▼
┌─────────────────────────────────────────────────┐
│              CONTROLADORES                       │
│         (Servlets - *.java)                      │
│  LoginServlet, RegistroServlet, etc.            │
└────────────────┬────────────────────────────────┘
                 │
        ┌────────┴────────┐
        │                 │
        ▼                 ▼
┌───────────────┐  ┌──────────────┐
│    MODELO     │  │    VISTA     │
│  (Entities)   │  │    (JSP)     │
│  Usuario.java │  │  login.jsp   │
│  Turno.java   │  │  panel.jsp   │
└───────┬───────┘  └──────────────┘
        │
        ▼
┌───────────────────┐
│       DAO         │
│  (Data Access)    │
│  UsuarioDAO.java  │
└────────┬──────────┘
         │
         ▼
┌────────────────────┐
│   BASE DE DATOS    │
│    PostgreSQL      │
└────────────────────┘
```

### Estructura de Directorios

```
src/main/java/com/taller2/
├── controller/          # Servlets que manejan peticiones HTTP
├── dao/                 # Clases de acceso a datos
├── model/               # Entidades (Usuario, Turno, Comentario)
└── util/                # Utilidades (DatabaseConnection)

src/main/webapp/
├── WEB-INF/
│   ├── views/          # JSPs protegidos (requieren autenticación)
│   ├── web.xml         # Configuración de la aplicación
│   └── glassfish-web.xml
└── index.jsp           # Página de entrada pública
```

### Principios de Diseño Aplicados

1. **Separación de Responsabilidades:** Cada clase tiene un propósito único
2. **DRY (Don't Repeat Yourself):** BaseDAO elimina código duplicado
3. **Singleton:** Una única instancia de conexión a BD
4. **DAO Pattern:** Abstracción del acceso a datos
5. **MVC:** Separación clara entre lógica, datos y presentación

---

## 🔌 PATRÓN SINGLETON - GESTIÓN DE CONEXIONES {#patrón-singleton}

### ¿Por qué necesitamos Singleton?

**Problema:** Si cada vez que alguien accede a la BD creamos una nueva conexión, podríamos tener cientos de conexiones abiertas simultáneamente, agotando los recursos del servidor.

**Solución:** El patrón Singleton garantiza que **solo existe una instancia** de la conexión a la base de datos en toda la aplicación.

### Implementación en DatabaseConnection.java

```java
public class DatabaseConnection {
    // Variable estática que contiene la única instancia
    private static DatabaseConnection instance;
    private Connection connection;
    
    // Constructor privado (nadie puede hacer "new DatabaseConnection()")
    private DatabaseConnection() {
        try {
            Class.forName("org.postgresql.Driver");
            this.connection = DriverManager.getConnection(
                "jdbc:postgresql://localhost:5432/taller2_bd",
                "postgres",
                "admin"
            );
        } catch (Exception e) {
            throw new RuntimeException("Error al conectar con la BD", e);
        }
    }
    
    // Método público para obtener la única instancia
    public static synchronized DatabaseConnection getInstance() {
        if (instance == null) {
            instance = new DatabaseConnection();
        }
        return instance;
    }
    
    public Connection getConnection() {
        return this.connection;
    }
}
```

### Flujo de Singleton

```
Primera llamada:
getInstance() → instance == null → Se crea la instancia → Se retorna

Segunda llamada:
getInstance() → instance != null → Se retorna la instancia existente

Tercera llamada:
getInstance() → instance != null → Se retorna la misma instancia
```

### Ventajas del Singleton

✅ **Control de recursos:** Solo una conexión activa  
✅ **Performance:** No se crean conexiones innecesarias  
✅ **Thread-safe:** `synchronized` evita problemas de concurrencia  
✅ **Punto único de acceso:** Todos usan la misma conexión

### Cuándo usar Singleton

- ✅ Conexiones a bases de datos
- ✅ Configuraciones globales
- ✅ Logger systems
- ✅ Cache managers
- ❌ Objetos con estado mutable frecuente
- ❌ Entidades de negocio (Usuario, Turno, etc.)

---

## 💾 PATRÓN DAO - ACCESO A DATOS {#patrón-dao}

### ¿Qué es DAO?

**DAO (Data Access Object)** es un patrón que separa la lógica de acceso a datos de la lógica de negocio. Proporciona una interfaz abstracta para interactuar con la base de datos.

### Jerarquía DAO en el Proyecto

```
BaseDAO<T> (Clase abstracta genérica)
    ├── UsuarioDAO (Operaciones sobre usuarios)
    ├── TurnoDAO (Operaciones sobre turnos)
    └── ComentarioDAO (Operaciones sobre comentarios)
```

### BaseDAO.java - La Clase Base

```java
public abstract class BaseDAO<T> {
    protected Connection connection;
    
    public BaseDAO() {
        this.connection = DatabaseConnection.getInstance().getConnection();
    }
    
    // Métodos abstractos que cada DAO debe implementar
    public abstract List<T> obtenerTodos();
    public abstract T obtenerPorId(int id);
    public abstract void insertar(T entidad);
    public abstract void actualizar(T entidad);
    public abstract void eliminar(int id);
}
```

**Ventajas de BaseDAO:**
- Evita duplicar el código de conexión en cada DAO
- Define un contrato común para todas las entidades
- Facilita el mantenimiento (cambios en un solo lugar)

### UsuarioDAO.java - Ejemplo Completo

```java
public class UsuarioDAO extends BaseDAO<Usuario> {
    
    @Override
    public List<Usuario> obtenerTodos() {
        List<Usuario> usuarios = new ArrayList<>();
        String sql = "SELECT * FROM usuarios";
        
        try (PreparedStatement ps = connection.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                usuarios.add(mapearUsuario(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return usuarios;
    }
    
    @Override
    public Usuario obtenerPorId(int id) {
        String sql = "SELECT * FROM usuarios WHERE id = ?";
        
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                return mapearUsuario(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    // Método personalizado (no está en BaseDAO)
    public Usuario obtenerPorEmail(String email) {
        String sql = "SELECT * FROM usuarios WHERE email = ?";
        
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, email);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                return mapearUsuario(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    @Override
    public void insertar(Usuario usuario) {
        String sql = "INSERT INTO usuarios (nombre, email, password, rol) VALUES (?, ?, ?, ?)";
        
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, usuario.getNombre());
            ps.setString(2, usuario.getEmail());
            ps.setString(3, usuario.getPassword());
            ps.setString(4, usuario.getRol());
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
    
    // Convierte ResultSet a objeto Usuario
    private Usuario mapearUsuario(ResultSet rs) throws SQLException {
        Usuario usuario = new Usuario();
        usuario.setId(rs.getInt("id"));
        usuario.setNombre(rs.getString("nombre"));
        usuario.setEmail(rs.getString("email"));
        usuario.setPassword(rs.getString("password"));
        usuario.setRol(rs.getString("rol"));
        return usuario;
    }
}
```

### Flujo de Uso de DAO

```
Servlet (LoginServlet)
    ↓
Crea instancia: UsuarioDAO dao = new UsuarioDAO()
    ↓
Llama método: Usuario usuario = dao.obtenerPorEmail("juan@email.com")
    ↓
DAO ejecuta SQL: SELECT * FROM usuarios WHERE email = ?
    ↓
BD retorna ResultSet
    ↓
DAO mapea a objeto Usuario
    ↓
Servlet recibe objeto Usuario y continúa la lógica
```

### Ventajas del Patrón DAO

✅ **Separación clara:** La lógica de negocio no conoce SQL  
✅ **Mantenibilidad:** Cambios en BD solo afectan los DAO  
✅ **Testeable:** Puedes mockear los DAO en pruebas  
✅ **Reutilizable:** Los mismos DAO en diferentes Servlets

---

## 🌐 SERVLETS - CONTROLADORES HTTP {#servlets}

### ¿Qué son los Servlets?

Los **Servlets** son clases Java que manejan peticiones HTTP (GET, POST, PUT, DELETE) y generan respuestas dinámicas. Actúan como el punto de entrada de la aplicación web.

### Ciclo de Vida de un Servlet

```
Cliente hace request
    ↓
Contenedor web (GlassFish) recibe la petición
    ↓
¿Primera vez? → init() se ejecuta una vez
    ↓
Por cada request → service() decide si llamar doGet() o doPost()
    ↓
Servlet procesa y genera response
    ↓
Contenedor destruye servlet → destroy()
```

### LoginServlet.java - Análisis Completo

```java
@WebServlet("/login")
public class LoginServlet extends HttpServlet {
    
    private UsuarioDAO usuarioDAO;
    
    @Override
    public void init() {
        // Se ejecuta UNA sola vez al iniciar el servlet
        this.usuarioDAO = new UsuarioDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Muestra el formulario de login
        request.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // 1. Obtener parámetros del formulario
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        
        // 2. Buscar usuario en la BD
        Usuario usuario = usuarioDAO.obtenerPorEmail(email);
        
        // 3. Validar credenciales
        if (usuario != null && usuario.getPassword().equals(password)) {
            // Login exitoso
            HttpSession session = request.getSession();
            session.setAttribute("usuario", usuario);
            session.setAttribute("rol", usuario.getRol());
            
            // Redireccionar según rol
            if ("ADMIN".equals(usuario.getRol())) {
                response.sendRedirect(request.getContextPath() + "/panel");
            } else {
                response.sendRedirect(request.getContextPath() + "/home");
            }
        } else {
            // Login fallido
            request.setAttribute("error", "Credenciales inválidas");
            request.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(request, response);
        }
    }
}
```

### Diferencia entre GET y POST

| Método | Cuándo usar | Características |
|--------|-------------|-----------------|
| **GET** | Mostrar formularios, páginas de consulta | Parámetros visibles en URL, cacheable, idempotente |
| **POST** | Enviar formularios, modificar datos | Parámetros en el cuerpo, no cacheable, puede modificar estado |

### Forward vs Redirect

**Forward (`request.getRequestDispatcher().forward()`):**
- El servidor procesa la petición internamente
- La URL no cambia en el navegador
- Mantiene los atributos del request
- Uso: Mostrar vistas con datos procesados

**Redirect (`response.sendRedirect()`):**
- El navegador hace una nueva petición
- La URL cambia en el navegador
- No mantiene los atributos del request
- Uso: Después de POST (evita reenvío de formularios)

### Mapeo de Servlets

```java
// Opción 1: Anotación (recomendado)
@WebServlet("/login")
public class LoginServlet extends HttpServlet { }

// Opción 2: web.xml (legacy)
<servlet>
    <servlet-name>LoginServlet</servlet-name>
    <servlet-class>com.taller2.controller.LoginServlet</servlet-class>
</servlet>
<servlet-mapping>
    <servlet-name>LoginServlet</servlet-name>
    <url-pattern>/login</url-pattern>
</servlet-mapping>
```

### Gestión de Sesiones

```java
// Crear/obtener sesión
HttpSession session = request.getSession();

// Almacenar datos en sesión
session.setAttribute("usuario", usuarioObjeto);
session.setAttribute("rol", "ADMIN");

// Recuperar datos de sesión
Usuario usuario = (Usuario) session.getAttribute("usuario");
String rol = (String) session.getAttribute("rol");

// Verificar si existe atributo
if (session.getAttribute("usuario") != null) {
    // Usuario autenticado
}

// Invalidar sesión (logout)
session.invalidate();
```

---

## 🔐 SISTEMA DE AUTENTICACIÓN {#autenticación}

### Flujo Completo de Autenticación

```
1. REGISTRO
Usuario completa formulario registro.jsp
    ↓
POST /registro → RegistroServlet.doPost()
    ↓
Validaciones (email único, password coincide)
    ↓
UsuarioDAO.insertar(nuevoUsuario)
    ↓
Redirect a /login con mensaje de éxito

2. LOGIN
Usuario completa formulario login.jsp
    ↓
POST /login → LoginServlet.doPost()
    ↓
UsuarioDAO.obtenerPorEmail(email)
    ↓
Validar password
    ↓
Crear sesión y guardar usuario
    ↓
Redirect según rol (admin→panel, user→home)

3. LOGOUT
Usuario clic en "Cerrar Sesión"
    ↓
GET /logout → LogoutServlet.doGet()
    ↓
session.invalidate()
    ↓
Redirect a /index.jsp

4. RECUPERAR CONTRASEÑA
Usuario solicita recuperación
    ↓
POST /recuperar-contrasena → RecuperarContrasenaServlet
    ↓
Valida email existe
    ↓
Genera token temporal
    ↓
Envía email con enlace (simulado en este proyecto)
    ↓
Usuario accede al enlace y restablece password
```

### RegistroServlet.java - Puntos Clave

```java
@WebServlet("/registro")
public class RegistroServlet extends HttpServlet {
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String nombre = request.getParameter("nombre");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");
        
        // Validación 1: Contraseñas coinciden
        if (!password.equals(confirmPassword)) {
            request.setAttribute("error", "Las contraseñas no coinciden");
            request.getRequestDispatcher("/WEB-INF/views/registro.jsp").forward(request, response);
            return;
        }
        
        // Validación 2: Email no existe
        UsuarioDAO dao = new UsuarioDAO();
        if (dao.obtenerPorEmail(email) != null) {
            request.setAttribute("error", "El email ya está registrado");
            request.getRequestDispatcher("/WEB-INF/views/registro.jsp").forward(request, response);
            return;
        }
        
        // Crear usuario con rol USER por defecto
        Usuario nuevoUsuario = new Usuario();
        nuevoUsuario.setNombre(nombre);
        nuevoUsuario.setEmail(email);
        nuevoUsuario.setPassword(password); // En producción: hash con BCrypt
        nuevoUsuario.setRol("USER");
        
        dao.insertar(nuevoUsuario);
        
        response.sendRedirect(request.getContextPath() + "/login?registro=exitoso");
    }
}
```

### Seguridad de Contraseñas

**⚠️ Estado actual (desarrollo):**
```java
usuario.setPassword(password); // Plain text - INSEGURO
```

**✅ Producción (recomendado):**
```java
import org.mindrot.jbcrypt.BCrypt;

// Al registrar
String hashedPassword = BCrypt.hashpw(password, BCrypt.gensalt());
usuario.setPassword(hashedPassword);

// Al validar login
if (BCrypt.checkpw(passwordIngresado, usuario.getPassword())) {
    // Login exitoso
}
```

### Control de Acceso por Rol

```java
// En cada servlet protegido
HttpSession session = request.getSession(false);
if (session == null || session.getAttribute("usuario") == null) {
    response.sendRedirect(request.getContextPath() + "/login");
    return;
}

String rol = (String) session.getAttribute("rol");
if (!"ADMIN".equals(rol)) {
    response.sendError(HttpServletResponse.SC_FORBIDDEN, "Acceso denegado");
    return;
}
```

### Protección de Recursos

**En web.xml:**
```xml
<security-constraint>
    <web-resource-collection>
        <web-resource-name>Admin Pages</web-resource-name>
        <url-pattern>/panel/*</url-pattern>
    </web-resource-collection>
    <auth-constraint>
        <role-name>ADMIN</role-name>
    </auth-constraint>
</security-constraint>
```

---

## 📅 GESTIÓN DE TURNOS Y COMENTARIOS {#turnos-comentarios}

### Sistema de Turnos

**Funcionalidades:**
- Usuarios autenticados pueden solicitar turnos
- Especifican fecha, hora y servicio deseado
- Los turnos se almacenan con estado "PENDIENTE"
- Administradores aprueban o rechazan turnos

### PedirTurnoServlet.java

```java
@WebServlet("/pedir-turno")
public class PedirTurnoServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Verificar autenticación
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("usuario") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        // Verificar que NO sea invitado
        String rol = (String) session.getAttribute("rol");
        if ("INVITADO".equals(rol)) {
            request.setAttribute("error", "Los invitados no pueden solicitar turnos");
            request.getRequestDispatcher("/WEB-INF/views/home.jsp").forward(request, response);
            return;
        }
        
        request.getRequestDispatcher("/WEB-INF/views/pedirTurno.jsp").forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        Usuario usuario = (Usuario) session.getAttribute("usuario");
        
        String fecha = request.getParameter("fecha");
        String hora = request.getParameter("hora");
        String servicio = request.getParameter("servicio");
        
        // Crear turno
        Turno turno = new Turno();
        turno.setUsuarioId(usuario.getId());
        turno.setFecha(LocalDate.parse(fecha));
        turno.setHora(LocalTime.parse(hora));
        turno.setServicio(servicio);
        turno.setEstado("PENDIENTE");
        
        TurnoDAO turnoDAO = new TurnoDAO();
        turnoDAO.insertar(turno);
        
        response.sendRedirect(request.getContextPath() + "/home?turno=solicitado");
    }
}
```

### Sistema de Comentarios

**Funcionalidades:**
- Usuarios autenticados dejan comentarios
- Los comentarios se muestran públicamente (si están aprobados)
- Administradores moderan los comentarios

### ComentarioServlet.java

```java
@WebServlet("/comentario")
public class ComentarioServlet extends HttpServlet {
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("usuario") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        // Verificar que NO sea invitado
        String rol = (String) session.getAttribute("rol");
        if ("INVITADO".equals(rol)) {
            response.sendRedirect(request.getContextPath() + "/home?error=invitado");
            return;
        }
        
        Usuario usuario = (Usuario) session.getAttribute("usuario");
        String contenido = request.getParameter("contenido");
        
        Comentario comentario = new Comentario();
        comentario.setUsuarioId(usuario.getId());
        comentario.setContenido(contenido);
        comentario.setAprobado(false); // Requiere aprobación
        comentario.setFecha(LocalDateTime.now());
        
        ComentarioDAO comentarioDAO = new ComentarioDAO();
        comentarioDAO.insertar(comentario);
        
        response.sendRedirect(request.getContextPath() + "/home?comentario=enviado");
    }
}
```

### TurnoDAO.java - Métodos Principales

```java
public class TurnoDAO extends BaseDAO<Turno> {
    
    // Obtener turnos de un usuario específico
    public List<Turno> obtenerPorUsuario(int usuarioId) {
        List<Turno> turnos = new ArrayList<>();
        String sql = "SELECT * FROM turnos WHERE usuario_id = ? ORDER BY fecha DESC, hora DESC";
        
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, usuarioId);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                turnos.add(mapearTurno(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return turnos;
    }
    
    // Cambiar estado de un turno (APROBADO/RECHAZADO)
    public void cambiarEstado(int turnoId, String nuevoEstado) {
        String sql = "UPDATE turnos SET estado = ? WHERE id = ?";
        
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, nuevoEstado);
            ps.setInt(2, turnoId);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
    
    private Turno mapearTurno(ResultSet rs) throws SQLException {
        Turno turno = new Turno();
        turno.setId(rs.getInt("id"));
        turno.setUsuarioId(rs.getInt("usuario_id"));
        turno.setFecha(rs.getDate("fecha").toLocalDate());
        turno.setHora(rs.getTime("hora").toLocalTime());
        turno.setServicio(rs.getString("servicio"));
        turno.setEstado(rs.getString("estado"));
        return turno;
    }
}
```

---

## 🛡️ PANEL DE ADMINISTRACIÓN {#panel-admin}

### Funcionalidades del Panel

El panel de administración (`panel.jsp`) permite:
1. **Gestión de Usuarios:** Ver, editar rol, eliminar
2. **Gestión de Turnos:** Aprobar, rechazar, eliminar
3. **Gestión de Comentarios:** Aprobar, rechazar, eliminar
4. **Estadísticas:** Dashboard con métricas clave

### PanelGestionServlet.java

```java
@WebServlet("/panel/gestion")
public class PanelGestionServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Verificar que sea admin
        HttpSession session = request.getSession(false);
        if (session == null || !"ADMIN".equals(session.getAttribute("rol"))) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }
        
        // Cargar datos para el panel
        UsuarioDAO usuarioDAO = new UsuarioDAO();
        TurnoDAO turnoDAO = new TurnoDAO();
        ComentarioDAO comentarioDAO = new ComentarioDAO();
        
        request.setAttribute("usuarios", usuarioDAO.obtenerTodos());
        request.setAttribute("turnos", turnoDAO.obtenerTodos());
        request.setAttribute("comentarios", comentarioDAO.obtenerTodos());
        
        request.getRequestDispatcher("/WEB-INF/views/panel.jsp").forward(request, response);
    }
}
```

### PanelAccionServlet.java - Acciones CRUD

```java
@WebServlet("/panel/accion")
public class PanelAccionServlet extends HttpServlet {
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String accion = request.getParameter("accion");
        String tipo = request.getParameter("tipo"); // usuario, turno, comentario
        int id = Integer.parseInt(request.getParameter("id"));
        
        switch (tipo) {
            case "usuario":
                gestionarUsuario(accion, id, request);
                break;
            case "turno":
                gestionarTurno(accion, id);
                break;
            case "comentario":
                gestionarComentario(accion, id);
                break;
        }
        
        response.sendRedirect(request.getContextPath() + "/panel/gestion");
    }
    
    private void gestionarTurno(String accion, int turnoId) {
        TurnoDAO turnoDAO = new TurnoDAO();
        
        switch (accion) {
            case "aprobar":
                turnoDAO.cambiarEstado(turnoId, "APROBADO");
                break;
            case "rechazar":
                turnoDAO.cambiarEstado(turnoId, "RECHAZADO");
                break;
            case "eliminar":
                turnoDAO.eliminar(turnoId);
                break;
        }
    }
    
    private void gestionarComentario(String accion, int comentarioId) {
        ComentarioDAO comentarioDAO = new ComentarioDAO();
        
        switch (accion) {
            case "aprobar":
                comentarioDAO.aprobar(comentarioId);
                break;
            case "rechazar":
                comentarioDAO.rechazar(comentarioId);
                break;
            case "eliminar":
                comentarioDAO.eliminar(comentarioId);
                break;
        }
    }
    
    private void gestionarUsuario(String accion, int usuarioId, HttpServletRequest request) {
        UsuarioDAO usuarioDAO = new UsuarioDAO();
        
        if ("cambiarRol".equals(accion)) {
            String nuevoRol = request.getParameter("nuevoRol");
            Usuario usuario = usuarioDAO.obtenerPorId(usuarioId);
            usuario.setRol(nuevoRol);
            usuarioDAO.actualizar(usuario);
        } else if ("eliminar".equals(accion)) {
            usuarioDAO.eliminar(usuarioId);
        }
    }
}
```

### Interfaz del Panel (panel.jsp)

```jsp
<%-- Sección de gestión de turnos --%>
<div class="gestion-turnos">
    <h2>Gestión de Turnos</h2>
    <table>
        <thead>
            <tr>
                <th>Usuario</th>
                <th>Fecha</th>
                <th>Hora</th>
                <th>Servicio</th>
                <th>Estado</th>
                <th>Acciones</th>
            </tr>
        </thead>
        <tbody>
            <c:forEach var="turno" items="${turnos}">
                <tr>
                    <td>${turno.usuarioNombre}</td>
                    <td>${turno.fecha}</td>
                    <td>${turno.hora}</td>
                    <td>${turno.servicio}</td>
                    <td>
                        <span class="badge badge-${turno.estado}">${turno.estado}</span>
                    </td>
                    <td>
                        <c:if test="${turno.estado == 'PENDIENTE'}">
                            <form method="post" action="${pageContext.request.contextPath}/panel/accion" style="display:inline;">
                                <input type="hidden" name="tipo" value="turno">
                                <input type="hidden" name="id" value="${turno.id}">
                                <button type="submit" name="accion" value="aprobar" class="btn-success">Aprobar</button>
                                <button type="submit" name="accion" value="rechazar" class="btn-danger">Rechazar</button>
                            </form>
                        </c:if>
                        <form method="post" action="${pageContext.request.contextPath}/panel/accion" style="display:inline;">
                            <input type="hidden" name="tipo" value="turno">
                            <input type="hidden" name="id" value="${turno.id}">
                            <button type="submit" name="accion" value="eliminar" class="btn-delete">Eliminar</button>
                        </form>
                    </td>
                </tr>
            </c:forEach>
        </tbody>
    </table>
</div>
```

---

## 🚫 CONTROL DE ACCESO Y SEGURIDAD {#control-acceso}

### Roles en el Sistema

| Rol | Permisos |
|-----|----------|
| **INVITADO** | Solo visualización de contenido público, NO puede pedir turnos ni comentar |
| **USER** | Visualización + pedir turnos + comentar |
| **ADMIN** | Acceso total al panel de administración |

### Implementación de Control de Acceso

**Verificación en cada Servlet:**

```java
// 1. Verificar autenticación
HttpSession session = request.getSession(false);
if (session == null || session.getAttribute("usuario") == null) {
    response.sendRedirect(request.getContextPath() + "/login");
    return;
}

// 2. Verificar rol específico
String rol = (String) session.getAttribute("rol");
if ("INVITADO".equals(rol)) {
    request.setAttribute("error", "Los invitados no tienen permisos para esta acción");
    request.getRequestDispatcher("/WEB-INF/views/error.jsp").forward(request, response);
    return;
}

// 3. Verificar admin
if (!"ADMIN".equals(rol)) {
    response.sendError(HttpServletResponse.SC_FORBIDDEN, "Acceso denegado");
    return;
}
```

### Filter para Autenticación Global

**Alternativa recomendada:** Crear un `AuthFilter` para centralizar la autenticación:

```java
@WebFilter("/*")
public class AuthFilter implements Filter {
    
    private static final List<String> PUBLIC_URLS = Arrays.asList(
        "/index.jsp", "/login", "/registro", "/recuperar-contrasena"
    );
    
    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        
        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;
        
        String path = req.getRequestURI().substring(req.getContextPath().length());
        
        // Permitir URLs públicas
        if (PUBLIC_URLS.stream().anyMatch(path::startsWith)) {
            chain.doFilter(request, response);
            return;
        }
        
        // Verificar autenticación para otras URLs
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("usuario") == null) {
            res.sendRedirect(req.getContextPath() + "/login");
            return;
        }
        
        // Verificar acceso a panel de admin
        if (path.startsWith("/panel")) {
            String rol = (String) session.getAttribute("rol");
            if (!"ADMIN".equals(rol)) {
                res.sendError(HttpServletResponse.SC_FORBIDDEN);
                return;
            }
        }
        
        chain.doFilter(request, response);
    }
}
```

### Mensajes de Error Personalizados

```jsp
<%-- En las JSPs --%>
<c:if test="${not empty error}">
    <div class="alert alert-danger">
        ${error}
    </div>
</c:if>

<c:if test="${param.error == 'invitado'}">
    <div class="alert alert-warning">
        Los usuarios invitados no pueden realizar esta acción. Por favor, regístrate.
    </div>
</c:if>
```

---

## 🎠 FRONTEND: CARRUSELES CON JAVASCRIPT {#carruseles}

### Carrusel de inicio.jsp

**Características:**
- Auto-scroll cada 3 segundos
- Pausa al pasar el mouse (hover)
- Navegación infinita (loop)
- Botones prev/next
- Imágenes responsive

### Implementación Completa

```jsp
<style>
.carousel-container {
    position: relative;
    width: 100%;
    max-width: 1200px;
    margin: 0 auto;
    overflow: hidden;
}

.carousel-wrapper {
    display: flex;
    transition: transform 0.5s ease-in-out;
    overflow-x: auto;
    scroll-behavior: smooth;
    scroll-snap-type: x mandatory;
}

.carousel-item {
    min-width: 100%;
    scroll-snap-align: start;
}

.carousel-item img {
    width: 100%;
    height: 400px;
    object-fit: cover;
}

.carousel-btn {
    position: absolute;
    top: 50%;
    transform: translateY(-50%);
    background: rgba(0, 0, 0, 0.6);
    color: white;
    border: none;
    border-radius: 50%;
    width: 50px;
    height: 50px;
    font-size: 24px;
    cursor: pointer;
    z-index: 10;
    transition: background 0.3s;
}

.carousel-btn:hover {
    background: rgba(0, 0, 0, 0.8);
}

.btn-prev { left: 20px; }
.btn-next { right: 20px; }
</style>

<div class="carousel-container">
    <button class="carousel-btn btn-prev" onclick="scrollCarousel('prev')">‹</button>
    <button class="carousel-btn btn-next" onclick="scrollCarousel('next')">›</button>
    
    <div class="carousel-wrapper" id="carouselWrapper">
        <div class="carousel-item">
            <img src="${pageContext.request.contextPath}/img/slide1.jpg" alt="Slide 1">
        </div>
        <div class="carousel-item">
            <img src="${pageContext.request.contextPath}/img/slide2.jpg" alt="Slide 2">
        </div>
        <div class="carousel-item">
            <img src="${pageContext.request.contextPath}/img/slide3.jpg" alt="Slide 3">
        </div>
    </div>
</div>

<script>
    var carousel = document.getElementById('carouselWrapper');
    var autoScrollInterval;
    var isScrolling = false;
    
    // Auto-scroll cada 3 segundos
    function startAutoScroll() {
        autoScrollInterval = setInterval(function() {
            if (!isScrolling) {
                scrollCarousel('next');
            }
        }, 3000);
    }
    
    function stopAutoScroll() {
        clearInterval(autoScrollInterval);
    }
    
    function scrollCarousel(direction) {
        var itemWidth = carousel.querySelector('.carousel-item').offsetWidth;
        var currentScroll = carousel.scrollLeft;
        var maxScroll = carousel.scrollWidth - carousel.offsetWidth;
        
        isScrolling = true;
        
        if (direction === 'next') {
            if (currentScroll >= maxScroll - 10) {
                // Llegamos al final, volver al inicio
                carousel.scrollTo({ left: 0, behavior: 'smooth' });
            } else {
                carousel.scrollBy({ left: itemWidth, behavior: 'smooth' });
            }
        } else {
            if (currentScroll <= 10) {
                // Estamos al inicio, ir al final
                carousel.scrollTo({ left: maxScroll, behavior: 'smooth' });
            } else {
                carousel.scrollBy({ left: -itemWidth, behavior: 'smooth' });
            }
        }
        
        setTimeout(function() {
            isScrolling = false;
        }, 500);
    }
    
    // Pausar auto-scroll al pasar el mouse
    carousel.addEventListener('mouseenter', stopAutoScroll);
    carousel.addEventListener('mouseleave', startAutoScroll);
    
    // Iniciar auto-scroll al cargar la página
    startAutoScroll();
</script>
```

### Carrusel de contacto.jsp - Sucursales Hardcodeadas

**Características:**
- Datos hardcodeados (NO desde BD)
- 5 sucursales: Santiago, Valparaíso, Viña del Mar, Punta Arenas, Copiapó
- Misma lógica de navegación que inicio.jsp

```jsp
<script>
    var sucursalesData = [
        {
            nombre: 'Santiago Centro',
            direccion: 'Av. Libertador Bernardo O\'Higgins 1234',
            telefono: '+56 2 2345 6789',
            horario: 'Lun-Vie: 9:00-20:00, Sáb: 10:00-14:00',
            imagen: '${pageContext.request.contextPath}/img/sucursal-santiago.jpg'
        },
        {
            nombre: 'Valparaíso',
            direccion: 'Calle Esmeralda 456',
            telefono: '+56 32 234 5678',
            horario: 'Lun-Vie: 9:00-19:00, Sáb: 10:00-13:00',
            imagen: '${pageContext.request.contextPath}/img/sucursal-valparaiso.jpg'
        },
        {
            nombre: 'Viña del Mar',
            direccion: 'Av. Libertad 789',
            telefono: '+56 32 345 6789',
            horario: 'Lun-Vie: 9:00-20:00',
            imagen: '${pageContext.request.contextPath}/img/sucursal-vina.jpg'
        },
        {
            nombre: 'Punta Arenas',
            direccion: 'Av. Colón 321',
            telefono: '+56 61 234 5678',
            horario: 'Lun-Vie: 10:00-18:00',
            imagen: '${pageContext.request.contextPath}/img/sucursal-puntaarenas.jpg'
        },
        {
            nombre: 'Copiapó',
            direccion: 'Calle Los Carrera 654',
            telefono: '+56 52 234 5678',
            horario: 'Lun-Vie: 9:00-19:00',
            imagen: '${pageContext.request.contextPath}/img/sucursal-copiapo.jpg'
        }
    ];
    
    function renderCarruselSedes() {
        var wrapper = document.getElementById('carouselSedesWrapper');
        wrapper.innerHTML = '';
        
        sucursalesData.forEach(function(sucursal) {
            var card = document.createElement('div');
            card.className = 'carousel-item sede-card';
            card.innerHTML = 
                '<img src="' + sucursal.imagen + '" alt="' + sucursal.nombre + '">' +
                '<div class="sede-info">' +
                    '<h3>' + sucursal.nombre + '</h3>' +
                    '<p><i class="fas fa-map-marker-alt"></i> ' + sucursal.direccion + '</p>' +
                    '<p><i class="fas fa-phone"></i> ' + sucursal.telefono + '</p>' +
                    '<p><i class="fas fa-clock"></i> ' + sucursal.horario + '</p>' +
                '</div>';
            wrapper.appendChild(card);
        });
    }
    
    function inicializarNavegacionCarrusel() {
        var carousel = document.getElementById('carouselSedesWrapper');
        var btnPrev = document.querySelector('.btn-prev');
        var btnNext = document.querySelector('.btn-next');
        
        btnNext.addEventListener('click', function() {
            scrollCarouselSedes('next');
        });
        
        btnPrev.addEventListener('click', function() {
            scrollCarouselSedes('prev');
        });
        
        // Auto-scroll
        carousel.addEventListener('mouseenter', stopAutoScroll);
        carousel.addEventListener('mouseleave', startAutoScroll);
        startAutoScroll();
    }
    
    // Ejecutar al cargar la página
    document.addEventListener('DOMContentLoaded', function() {
        renderCarruselSedes();
        inicializarNavegacionCarrusel();
    });
</script>
```

### Ventajas de JavaScript Inline en JSP

✅ **Compatible con JSP:** Puede usar `${pageContext.request.contextPath}`  
✅ **No requiere archivos externos:** Todo en un solo archivo  
✅ **ES5 compatible:** Funciona en navegadores antiguos  
✅ **Sin módulos:** No necesita bundlers (Webpack, Vite)

### Desventajas

❌ **Mantenibilidad:** Código duplicado en múltiples JSPs  
❌ **Cache:** No se puede cachear como archivo .js externo  
❌ **Testing:** Difícil hacer unit tests

**Solución recomendada para producción:** Migrar a archivos `.js` externos con sistema de build.

---

## 🔄 FLUJO DE DATOS COMPLETO {#flujo-datos}

### Flujo: Usuario solicita un turno

```
1. Usuario autenticado navega a /pedir-turno
   ↓
2. PedirTurnoServlet.doGet()
   - Verifica sesión activa
   - Verifica que NO sea invitado
   - Forward a pedirTurno.jsp
   ↓
3. Usuario completa formulario y envía (POST)
   ↓
4. PedirTurnoServlet.doPost()
   - Captura parámetros del request
   - Recupera usuario de la sesión
   - Crea objeto Turno
   - Llama a TurnoDAO.insertar(turno)
   ↓
5. TurnoDAO.insertar()
   - Obtiene conexión singleton
   - Ejecuta INSERT INTO turnos...
   - PostgreSQL almacena el registro
   ↓
6. Redirect a /home?turno=solicitado
   ↓
7. HomeController muestra mensaje de éxito
```

### Flujo: Admin aprueba un turno

```
1. Admin accede a /panel/gestion
   ↓
2. PanelGestionServlet.doGet()
   - Verifica rol ADMIN
   - TurnoDAO.obtenerTodos()
   - Carga todos los turnos pendientes
   - Forward a panel.jsp
   ↓
3. Admin ve tabla con turnos pendientes
   - Clic en botón "Aprobar"
   ↓
4. Formulario POST a /panel/accion
   - Parámetros: accion=aprobar, tipo=turno, id=123
   ↓
5. PanelAccionServlet.doPost()
   - Identifica acción y tipo
   - Llama a gestionarTurno("aprobar", 123)
   ↓
6. TurnoDAO.cambiarEstado(123, "APROBADO")
   - UPDATE turnos SET estado = 'APROBADO' WHERE id = 123
   ↓
7. Redirect a /panel/gestion
   - El turno ahora aparece como APROBADO
```

### Flujo: Invitado intenta comentar

```
1. Usuario con rol INVITADO en sesión
   ↓
2. Navega a sección de comentarios en home.jsp
   ↓
3. Intenta enviar comentario (POST /comentario)
   ↓
4. ComentarioServlet.doPost()
   - Verifica sesión: OK (existe)
   - Verifica rol: INVITADO
   - Detección: ❌ Invitado no tiene permisos
   ↓
5. Redirect a /home?error=invitado
   ↓
6. home.jsp muestra mensaje:
   "Los usuarios invitados no pueden comentar. Por favor, regístrate."
```

### Diagrama de Secuencia: Login Completo

```
Cliente         LoginServlet      UsuarioDAO      PostgreSQL       Session
  |                  |                |               |              |
  |--POST /login---->|                |               |              |
  |                  |                |               |              |
  |           obtenerPorEmail(email)  |               |              |
  |                  |--------------->|               |              |
  |                  |                |--SELECT ...-->|              |
  |                  |                |<--ResultSet---|              |
  |                  |<--Usuario obj--|               |              |
  |                  |                |               |              |
  |            Validar password       |               |              |
  |                  |                |               |              |
  |            request.getSession()   |               |              |
  |                  |------------------------------------>|          |
  |                  |                |               |   session.setAttribute("usuario")
  |                  |                |               |   session.setAttribute("rol")
  |                  |                |               |              |
  |<--Redirect /home-|                |               |              |
  |                  |                |               |              |
```

---

## 🚀 DESPLIEGUE Y TROUBLESHOOTING {#despliegue}

### Compilación del Proyecto

```bash
# Limpiar compilaciones anteriores y compilar
mvn clean package

# Resultado esperado:
# BUILD SUCCESS
# target/taller2.war generado
```

### Despliegue en GlassFish

```bash
# Opción 1: Consola asadmin
asadmin deploy --force target/taller2.war

# Opción 2: Script automatizado
bash desplegar.sh

# Opción 3: Admin Console
# Navega a http://localhost:4848
# Applications → Deploy → Selecciona taller2.war
```

### Verificar Despliegue

```bash
# Comprobar aplicación desplegada
asadmin list-applications

# Ver logs en tiempo real
tail -f /path/to/glassfish6/glassfish/domains/domain1/logs/server.log

# Acceder a la aplicación
# http://localhost:9000/taller2
```

### Problemas Comunes y Soluciones

#### 1. Error: "Connection refused" a PostgreSQL

**Síntoma:**
```
org.postgresql.util.PSQLException: Connection refused
```

**Causas:**
- PostgreSQL no está corriendo
- Puerto incorrecto (debe ser 5432)
- Credenciales incorrectas

**Solución:**
```bash
# Verificar estado de PostgreSQL
sudo systemctl status postgresql

# Iniciar PostgreSQL
sudo systemctl start postgresql

# Conectar manualmente para verificar
psql -U postgres -d taller2_bd
```

#### 2. Error: "ClassNotFoundException: org.postgresql.Driver"

**Síntoma:**
```
java.lang.ClassNotFoundException: org.postgresql.Driver
```

**Causa:** Driver JDBC no incluido en el WAR

**Solución:**
```xml
<!-- Verificar en pom.xml -->
<dependency>
    <groupId>org.postgresql</groupId>
    <artifactId>postgresql</artifactId>
    <version>42.6.0</version>
</dependency>
```

```bash
# Recompilar
mvn clean package
```

#### 3. Error 404: Página no encontrada

**Síntoma:** Al acceder a `http://localhost:9000/taller2/login` → 404

**Causas:**
- Servlet no mapeado correctamente
- Context path incorrecto
- Aplicación no desplegada

**Solución:**
```java
// Verificar anotación del servlet
@WebServlet("/login") // Debe tener la barra inicial

// Verificar URL completa
// http://localhost:9000/taller2/login
//                      ↑        ↑
//                context-path  servlet-mapping
```

#### 4. Error 500: NullPointerException en sesión

**Síntoma:**
```
java.lang.NullPointerException: session.getAttribute("usuario")
```

**Causa:** Usuario no autenticado intenta acceder a página protegida

**Solución:**
```java
// Siempre verificar sesión antes de usar
HttpSession session = request.getSession(false);
if (session == null || session.getAttribute("usuario") == null) {
    response.sendRedirect(request.getContextPath() + "/login");
    return;
}
```

#### 5. Cambios en JSP no se reflejan

**Síntoma:** Modificas `login.jsp` pero no ves los cambios

**Causa:** Cache del servidor o navegador

**Solución:**
```bash
# Redesplegar forzando
asadmin undeploy taller2
asadmin deploy target/taller2.war

# O usar --force
asadmin deploy --force target/taller2.war

# Limpiar cache del navegador
Ctrl + Shift + R (hard reload)
```

#### 6. Puerto 9000 ya en uso

**Síntoma:**
```
Address already in use: bind
```

**Solución:**
```bash
# Encontrar proceso usando el puerto
lsof -i :9000

# Matar el proceso
kill -9 <PID>

# O cambiar puerto en GlassFish
asadmin set configs.config.server-config.http-service.http-listener.http-listener-1.port=8080
```

### Comandos Útiles de Maven

```bash
# Compilar sin ejecutar tests
mvn clean package -DskipTests

# Ver árbol de dependencias
mvn dependency:tree

# Limpiar target/
mvn clean

# Compilar y ejecutar tests
mvn test

# Ver información del proyecto
mvn help:effective-pom
```

### Comandos Útiles de GlassFish

```bash
# Iniciar/detener servidor
asadmin start-domain
asadmin stop-domain

# Reiniciar servidor
asadmin restart-domain

# Ver aplicaciones desplegadas
asadmin list-applications

# Desplegar aplicación
asadmin deploy --force target/taller2.war

# Desplegar aplicación
asadmin undeploy taller2

# Ver estado del servidor
asadmin version

# Cambiar configuración
asadmin set <property>=<value>
```

### Health Check del Sistema

```bash
# 1. Verificar PostgreSQL
psql -U postgres -c "SELECT version();"

# 2. Verificar GlassFish
asadmin list-applications

# 3. Verificar Java
java -version

# 4. Verificar Maven
mvn -version

# 5. Probar endpoint de salud
curl http://localhost:9000/taller2/health
```

### Logs y Debugging

**Ubicación de logs:**
```
GlassFish: /path/to/glassfish6/glassfish/domains/domain1/logs/server.log
Aplicación: System.out.println() → server.log
PostgreSQL: /var/log/postgresql/postgresql-13-main.log
```

**Nivel de logs en GlassFish:**
```bash
# Cambiar a modo DEBUG
asadmin set-log-levels com.taller2=FINE

# Volver a INFO
asadmin set-log-levels com.taller2=INFO
```

---

## 📊 MEJORES PRÁCTICAS Y RECOMENDACIONES

### Seguridad

1. **Nunca almacenar contraseñas en texto plano**
   - Usar BCrypt o Argon2
   
2. **Validar inputs del usuario**
   - Prevenir SQL Injection
   - Usar PreparedStatement siempre

3. **Implementar HTTPS en producción**
   - Certificado SSL/TLS

4. **Session timeout configurado**
   ```xml
   <session-config>
       <session-timeout>30</session-timeout> <!-- 30 minutos -->
   </session-config>
   ```

### Performance

1. **Connection Pooling**
   - Usar HikariCP en lugar de conexión directa
   
2. **Cache de consultas frecuentes**
   - Implementar cache con Caffeine o Redis

3. **Lazy loading de datos**
   - No cargar todos los turnos si son miles

### Escalabilidad

1. **Separar frontend y backend**
   - API REST con JSON
   - Frontend en React/Vue

2. **Microservicios**
   - Servicio de usuarios
   - Servicio de turnos
   - Servicio de comentarios

3. **Containerización**
   ```dockerfile
   FROM eclipse-temurin:11-jre
   COPY target/taller2.war /app/
   CMD ["java", "-jar", "/app/taller2.war"]
   ```

---

## 📝 CONCLUSIÓN

Este documento proporciona una guía completa del sistema de gestión de clínica dental. Cubre desde la arquitectura básica hasta detalles de implementación, patrones de diseño aplicados, y solución de problemas comunes.

**Próximos pasos recomendados:**
1. Implementar tests unitarios con JUnit
2. Migrar contraseñas a BCrypt
3. Crear API REST para consumo externo
4. Implementar logging profesional (SLF4J + Logback)
5. Dockerizar la aplicación completa

**Recursos adicionales:**
- Documentación de Jakarta EE: https://jakarta.ee/
- PostgreSQL Documentation: https://www.postgresql.org/docs/
- GlassFish Server: https://glassfish.org/documentation
- Maven Guide: https://maven.apache.org/guides/

```
┌─────────────────────────────────────────────┐
│  USUARIO (tú, navegando desde Chrome)       │
└─────────────────┬───────────────────────────┘
                  │ "Quiero pedir una cita"
┌─────────────────▼───────────────────────────┐
│  NAVEGADOR envía petición HTTP              │
└─────────────────┬───────────────────────────┘
                  │
┌─────────────────▼───────────────────────────┐
│  GLASSFISH (el servidor que escucha)        │
│  "Ah, quieres pedir cita, déjame ver..."    │
└─────────────────┬───────────────────────────┘
                  │
┌─────────────────▼───────────────────────────┐
│  SERVLET (PedirTurnoServlet.java)           │
│  "Ok, voy a verificar si estás logueado"    │
└─────────────────┬───────────────────────────┘
                  │
┌─────────────────▼───────────────────────────┐
│  DAO (TurnoDAO.java)                        │
│  "Voy a guardar esta cita en la BD"         │
└─────────────────┬───────────────────────────┘
                  │
┌─────────────────▼───────────────────────────┐
│  POSTGRESQL (Base de Datos)                 │
│  "Guardado. ID de turno: 123"               │
└─────────────────┬───────────────────────────┘
                  │
┌─────────────────▼───────────────────────────┐
│  RESPUESTA AL USUARIO                       │
│  "¡Turno solicitado exitosamente! ✓"        │
└─────────────────────────────────────────────┘
```

**TL;DR (Too Long; Didn't Read):**
Es un sitio web que conecta:
- **Frontend (JSP)** = Lo que ves (HTML, CSS, JavaScript)
- **Backend (Servlets)** = La lógica (Java)
- **Base de Datos (PostgreSQL)** = Donde se guarda todo

---

## 🏗️ ARQUITECTURA GENERAL {#arquitectura-general}

---

## 🏗️ ARQUITECTURA GENERAL {#arquitectura-general}

### Estructura del Proyecto

```
Taller2/
├── src/main/java/com/taller2/
│   ├── controller/          # Servlets (Controladores)
│   │   ├── LoginServlet.java
│   │   ├── RegistroServlet.java
│   │   ├── RecuperarContrasenaServlet.java
│   │   ├── PedirTurnoServlet.java
│   │   ├── ComentarioServlet.java
│   │   ├── PanelGestionServlet.java
│   │   └── PanelAccionServlet.java
│   │
│   ├── dao/                 # Data Access Objects
│   │   ├── BaseDAO.java
│   │   ├── UsuarioDAO.java
│   │   ├── TurnoDAO.java
│   │   └── ComentarioDAO.java
│   │
│   ├── model/               # Modelos (POJOs)
│   │   ├── Usuario.java
│   │   ├── Turno.java
│   │   └── Comentario.java
│   │
│   └── util/                # Utilidades
│       └── DatabaseConnection.java (Singleton)
│
└── src/main/webapp/
    ├── WEB-INF/
    │   ├── views/           # JSP Views
    │   │   ├── login.jsp
    │   │   ├── registro.jsp
    │   │   ├── recuperar.jsp
    │   │   ├── inicio.jsp
    │   │   ├── contacto.jsp
    │   │   ├── pedirTurno.jsp
    │   │   └── panel.jsp
    │   └── web.xml          # Configuración Web
    └── img/                 # Recursos estáticos
```

### Arquitectura Multicapa

```
┌─────────────────────────────────────────────┐
│         CAPA DE PRESENTACIÓN (JSP)          │
│  - login.jsp, inicio.jsp, panel.jsp         │
│  - HTML + CSS inline + JavaScript           │
└─────────────────┬───────────────────────────┘
                  │ HTTP Request/Response
┌─────────────────▼───────────────────────────┐
│       CAPA DE CONTROLADORES (Servlets)      │
│  - LoginServlet, PanelGestionServlet        │
│  - Validan datos, gestionan sesiones        │
└─────────────────┬───────────────────────────┘
                  │ Invoca métodos
┌─────────────────▼───────────────────────────┐
│         CAPA DE ACCESO A DATOS (DAO)        │
│  - UsuarioDAO, TurnoDAO, ComentarioDAO      │
│  - Ejecutan SQL, mapean ResultSet           │
└─────────────────┬───────────────────────────┘
                  │ Obtiene Connection
┌─────────────────▼───────────────────────────┐
│      CAPA DE UTILIDADES (Singleton)         │
│  - DatabaseConnection (Pool de conexiones)  │
└─────────────────┬───────────────────────────┘
                  │ JDBC Driver
┌─────────────────▼───────────────────────────┐
│         BASE DE DATOS (PostgreSQL)          │
│  - Tablas: usuarios, turnos, comentarios   │
└─────────────────────────────────────────────┘
```

---

## 🔐 PATRÓN DE DISEÑO SINGLETON - CONEXIÓN A BASE DE DATOS {#patrón-singleton}

### ¿Qué es el Patrón Singleton?

El **Singleton** es un patrón de diseño creacional que garantiza que una clase tenga **una única instancia** y proporciona un punto de acceso global a ella.

### ¿Por qué usamos Singleton para la conexión a la BD?

1. **Evitar múltiples conexiones innecesarias**: Crear una conexión a la base de datos es costoso en recursos
2. **Pool de conexiones centralizado**: Una única instancia gestiona todas las conexiones
3. **Acceso global**: Todos los DAOs pueden acceder a la misma instancia
4. **Thread-safe**: Garantiza seguridad en aplicaciones con múltiples hilos

### Implementación: `DatabaseConnection.java`

```java
package com.taller2.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DatabaseConnection {
    
    // 1. INSTANCIA ÚNICA (privada y estática)
    private static DatabaseConnection instance;
    
    // 2. CONFIGURACIÓN DE LA BASE DE DATOS
    private static final String URL = "jdbc:postgresql://localhost:5432/taller2_bd";
    private static final String USER = "postgres";
    private static final String PASSWORD = "postgres";
    
    // 3. CONSTRUCTOR PRIVADO (nadie puede hacer 'new DatabaseConnection()')
    private DatabaseConnection() {
        try {
            // Cargar el driver de PostgreSQL
            Class.forName("org.postgresql.Driver");
        } catch (ClassNotFoundException e) {
            throw new RuntimeException("Error al cargar el driver de PostgreSQL", e);
        }
    }
    
    // 4. MÉTODO PÚBLICO PARA OBTENER LA INSTANCIA ÚNICA
    public static DatabaseConnection getInstance() {
        if (instance == null) {
            // Double-check locking para thread-safety
            synchronized (DatabaseConnection.class) {
                if (instance == null) {
                    instance = new DatabaseConnection();
                }
            }
        }
        return instance;
    }
    
    // 5. MÉTODO PARA OBTENER UNA CONEXIÓN A LA BD
    public Connection getConnection() throws SQLException {
        return DriverManager.getConnection(URL, USER, PASSWORD);
    }
}
```

### Flujo de Uso del Singleton

```
1. Primera llamada desde UsuarioDAO:
   DatabaseConnection.getInstance().getConnection()
   ↓
   - instance == null → Se crea la instancia
   - Constructor privado carga el driver
   - Retorna nueva conexión

2. Segunda llamada desde TurnoDAO:
   DatabaseConnection.getInstance().getConnection()
   ↓
   - instance != null → Reutiliza la misma instancia
   - Retorna nueva conexión (pero misma instancia)

3. N llamadas posteriores:
   - Siempre usan la MISMA instancia de DatabaseConnection
   - Cada getConnection() crea una nueva Connection (del pool)
```

### Ventajas en Nuestro Proyecto

- ✅ **Una sola carga del driver PostgreSQL** (en el constructor)
- ✅ **Configuración centralizada** (URL, USER, PASSWORD en un solo lugar)
- ✅ **Fácil de cambiar** (si cambiamos de BD, solo modificamos esta clase)
- ✅ **Thread-safe** (múltiples servlets pueden usarla simultáneamente)

---

## 📦 PATRÓN DAO (DATA ACCESS OBJECT) {#patrón-dao}

### ¿Qué es un DAO?

**DAO** es un patrón de diseño que **encapsula toda la lógica de acceso a datos**, separando la lógica de negocio de la persistencia.

### Estructura de un DAO

```
┌─────────────────────────────────────┐
│          <<interface>>              │
│            BaseDAO                  │
│  + crear(T): boolean                │
│  + obtenerTodos(): List<T>          │
│  + actualizar(T): boolean           │
│  + eliminar(int): boolean           │
└────────────────┬────────────────────┘
                 │
      ┌──────────┴──────────┐
      │                     │
┌─────▼──────┐      ┌──────▼──────┐
│ UsuarioDAO │      │  TurnoDAO   │
└────────────┘      └─────────────┘
```

### Ejemplo Completo: `UsuarioDAO.java`

```java
package com.taller2.dao;

import com.taller2.model.Usuario;
import com.taller2.util.DatabaseConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class UsuarioDAO {
    
    // ========================================
    // 1. MÉTODO: AUTENTICAR USUARIO
    // ========================================
    public Usuario autenticar(String usuario, String contrasena) {
        String sql = "SELECT * FROM usuarios WHERE usuario = ? AND contrasena = ?";
        
        // Try-with-resources: cierra automáticamente Connection, PreparedStatement, ResultSet
        try (Connection conn = DatabaseConnection.getInstance().getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            // Establecer parámetros (previene SQL Injection)
            stmt.setString(1, usuario);
            stmt.setString(2, contrasena);
            
            // Ejecutar consulta
            ResultSet rs = stmt.executeQuery();
            
            // Si hay resultado, mapear a objeto Usuario
            if (rs.next()) {
                return mapearUsuario(rs);
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return null; // Usuario no encontrado o error
    }
    
    // ========================================
    // 2. MÉTODO: OBTENER TODOS LOS USUARIOS
    // ========================================
    public List<Usuario> obtenerTodos() {
        List<Usuario> usuarios = new ArrayList<>();
        String sql = "SELECT * FROM usuarios ORDER BY id";
        
        try (Connection conn = DatabaseConnection.getInstance().getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                usuarios.add(mapearUsuario(rs));
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return usuarios;
    }
    
    // ========================================
    // 3. MÉTODO: CREAR NUEVO USUARIO
    // ========================================
    public boolean crear(Usuario usuario) {
        String sql = "INSERT INTO usuarios (usuario, contrasena, rol, nombre_completo, email) " +
                     "VALUES (?, ?, ?, ?, ?)";
        
        try (Connection conn = DatabaseConnection.getInstance().getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, usuario.getUsuario());
            stmt.setString(2, usuario.getContrasena());
            stmt.setString(3, usuario.getRol());
            stmt.setString(4, usuario.getNombreCompleto());
            stmt.setString(5, usuario.getEmail());
            
            // executeUpdate() retorna número de filas afectadas
            return stmt.executeUpdate() > 0;
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return false;
    }
    
    // ========================================
    // 4. MÉTODO: BUSCAR POR NOMBRE DE USUARIO
    // ========================================
    public Usuario buscarPorNombreUsuario(String nombreUsuario) {
        String sql = "SELECT * FROM usuarios WHERE usuario = ?";
        
        try (Connection conn = DatabaseConnection.getInstance().getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, nombreUsuario);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return mapearUsuario(rs);
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return null;
    }
    
    // ========================================
    // 5. MÉTODO: CAMBIAR CONTRASEÑA
    // ========================================
    public boolean cambiarContrasena(int usuarioId, String nuevaContrasena) {
        String sql = "UPDATE usuarios SET contrasena = ? WHERE id = ?";
        
        try (Connection conn = DatabaseConnection.getInstance().getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, nuevaContrasena);
            stmt.setInt(2, usuarioId);
            
            return stmt.executeUpdate() > 0;
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return false;
    }
    
    // ========================================
    // 6. MÉTODO PRIVADO: MAPEAR ResultSet → Usuario
    // ========================================
    private Usuario mapearUsuario(ResultSet rs) throws SQLException {
        Usuario usuario = new Usuario();
        usuario.setId(rs.getInt("id"));
        usuario.setUsuario(rs.getString("usuario"));
        usuario.setContrasena(rs.getString("contrasena"));
        usuario.setRol(rs.getString("rol"));
        usuario.setNombreCompleto(rs.getString("nombre_completo"));
        usuario.setEmail(rs.getString("email"));
        usuario.setFechaCreacion(rs.getTimestamp("fecha_creacion"));
        usuario.setActivo(rs.getBoolean("activo"));
        return usuario;
    }
}
```

### ¿Por qué usar DAOs?

| Ventaja | Explicación |
|---------|-------------|
| **Separación de Responsabilidades** | Los Servlets no tienen SQL, los DAOs no tienen lógica de negocio |
| **Reutilización** | `usuarioDAO.obtenerTodos()` se usa en múltiples servlets |
| **Mantenibilidad** | Si cambia la BD, solo modificamos los DAOs |
| **Testeable** | Podemos hacer tests unitarios de los DAOs por separado |
| **Prevención de SQL Injection** | Uso de PreparedStatement con parámetros |

---

## 🌐 SERVLETS Y CONTROL DE FLUJO {#servlets}

### ¿Qué es un Servlet?

Un **Servlet** es una clase Java que **maneja peticiones HTTP** y genera respuestas dinámicas. Funciona como **controlador** en el patrón MVC.

### Ciclo de Vida de un Servlet

```
1. INICIO DEL SERVIDOR (GlassFish)
   ↓
   init() → Se ejecuta UNA VEZ al cargar el servlet
   ↓
2. PETICIÓN HTTP (Usuario navega a /login)
   ↓
   service() → Decide si llamar a doGet() o doPost()
   ↓
   doGet() o doPost() → Procesa la petición
   ↓
3. RESPUESTA HTTP (Redirige a /inicio o muestra error)
   ↓
4. FIN DEL SERVIDOR
   ↓
   destroy() → Se ejecuta UNA VEZ al apagar el servidor
```

### Ejemplo Completo: `LoginServlet.java`

```java
package com.taller2.controller;

import com.taller2.dao.UsuarioDAO;
import com.taller2.model.Usuario;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

// ========================================
// ANOTACIÓN: Define la URL del servlet
// ========================================
@WebServlet("/login")
public class LoginServlet extends HttpServlet {
    
    // DAO para acceso a datos de usuarios
    private UsuarioDAO usuarioDAO;
    
    // ========================================
    // 1. INIT: Se ejecuta AL INICIAR el servlet
    // ========================================
    @Override
    public void init() {
        usuarioDAO = new UsuarioDAO();
    }
    
    // ========================================
    // 2. doGET: Muestra el formulario de login
    // ========================================
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // Forward a la vista JSP
        request.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(request, response);
    }
    
    // ========================================
    // 3. doPOST: Procesa el formulario enviado
    // ========================================
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Obtener parámetros del formulario
        String usuario = request.getParameter("usuario");
        String contrasena = request.getParameter("contrasena");
        String tipoLogin = request.getParameter("tipoLogin");
        
        // Obtener sesión actual (o crear una nueva)
        HttpSession session = request.getSession();
        
        // ========================================
        // CASO 1: Login como INVITADO
        // ========================================
        if ("invitado".equals(tipoLogin)) {
            session.setAttribute("tipoUsuario", "INVITADO");
            session.setAttribute("nombreUsuario", "Invitado");
            response.sendRedirect(request.getContextPath() + "/inicio");
            return;
        }
        
        // ========================================
        // CASO 2: Login con CREDENCIALES
        // ========================================
        if (usuario != null && contrasena != null) {
            // Llamar al DAO para autenticar
            Usuario user = usuarioDAO.autenticar(usuario, contrasena);
            
            if (user != null) {
                // ✅ AUTENTICACIÓN EXITOSA
                session.setAttribute("usuarioId", user.getId());
                session.setAttribute("usuario", user.getUsuario());
                session.setAttribute("nombreUsuario", user.getNombreCompleto());
                session.setAttribute("rol", user.getRol());
                session.setAttribute("tipoUsuario", user.getRol());
                
                // Redirigir a inicio
                response.sendRedirect(request.getContextPath() + "/inicio");
            } else {
                // ❌ CREDENCIALES INVÁLIDAS
                request.setAttribute("error", "Usuario o contraseña incorrectos");
                request.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(request, response);
            }
        } else {
            // Parámetros faltantes
            response.sendRedirect(request.getContextPath() + "/login");
        }
    }
}
```

### Métodos HTTP y Servlets

| Método HTTP | Método Servlet | Uso Típico |
|-------------|----------------|------------|
| **GET** | `doGet()` | Mostrar formularios, listar datos |
| **POST** | `doPost()` | Enviar formularios, crear/actualizar datos |
| **PUT** | `doPut()` | Actualizar recursos (REST API) |
| **DELETE** | `doDelete()` | Eliminar recursos (REST API) |

### Flujo Completo de una Petición

```
1. Usuario escribe en el navegador:
   http://localhost:9000/taller2/login
   
2. GlassFish recibe la petición GET
   ↓
3. Busca el servlet con @WebServlet("/login")
   ↓
4. Llama a LoginServlet.doGet()
   ↓
5. doGet() hace forward a login.jsp
   ↓
6. login.jsp se renderiza y se envía al navegador
   ↓
7. Usuario completa el formulario y hace clic en "Acceder"
   ↓
8. Navegador envía POST a /login con datos del formulario
   ↓
9. GlassFish llama a LoginServlet.doPost()
   ↓
10. doPost() valida credenciales con UsuarioDAO
    ↓
11. Si es válido: redirect a /inicio
    Si es inválido: forward a login.jsp con mensaje de error
```

---

## 🔑 SISTEMA DE AUTENTICACIÓN {#sistema-autenticación}

### Componentes del Sistema

```
┌─────────────────────────────────────────────┐
│         SISTEMA DE AUTENTICACIÓN            │
├─────────────────────────────────────────────┤
│ 1. LoginServlet          → Inicio de sesión │
│ 2. RegistroServlet       → Crear cuenta     │
│ 3. RecuperarContrasena   → Cambiar password │
│ 4. LogoutServlet         → Cerrar sesión    │
│ 5. Filtros de sesión     → Proteger rutas   │
└─────────────────────────────────────────────┘
```

### Tipos de Usuario

| Rol | Permisos | Restricciones |
|-----|----------|---------------|
| **INVITADO** | Ver páginas públicas | ❌ No puede pedir turnos ni comentar |
| **USUARIO** | Pedir turnos, comentar | ❌ No puede acceder al panel |
| **ADMIN** | Gestionar turnos, comentarios, usuarios | ✅ Acceso total |

### Flujo de Registro de Usuario

```java
// RegistroServlet.java - doPost()
@Override
protected void doPost(HttpServletRequest request, HttpServletResponse response) 
        throws ServletException, IOException {
    
    // 1. OBTENER DATOS DEL FORMULARIO
    String nombreCompleto = request.getParameter("nombreCompleto");
    String usuario = request.getParameter("usuario");
    String email = request.getParameter("email");
    String contrasena = request.getParameter("contrasena");
    String confirmarContrasena = request.getParameter("confirmarContrasena");
    
    // 2. VALIDAR QUE LAS CONTRASEÑAS COINCIDAN
    if (!contrasena.equals(confirmarContrasena)) {
        request.setAttribute("error", "Las contraseñas no coinciden");
        request.getRequestDispatcher("/WEB-INF/views/registro.jsp")
               .forward(request, response);
        return;
    }
    
    // 3. VERIFICAR SI EL USUARIO YA EXISTE
    Usuario usuarioExistente = usuarioDAO.buscarPorNombreUsuario(usuario);
    if (usuarioExistente != null) {
        request.setAttribute("error", "El nombre de usuario ya está en uso");
        request.getRequestDispatcher("/WEB-INF/views/registro.jsp")
               .forward(request, response);
        return;
    }
    
    // 4. CREAR NUEVO USUARIO CON ROL USUARIO
    Usuario nuevoUsuario = new Usuario();
    nuevoUsuario.setNombreCompleto(nombreCompleto);
    nuevoUsuario.setUsuario(usuario);
    nuevoUsuario.setEmail(email);
    nuevoUsuario.setContrasena(contrasena);
    nuevoUsuario.setRol("USUARIO");
    nuevoUsuario.setActivo(true);
    
    // 5. GUARDAR EN LA BASE DE DATOS
    boolean registrado = usuarioDAO.crear(nuevoUsuario);
    
    // 6. REDIRIGIR SEGÚN RESULTADO
    if (registrado) {
        request.setAttribute("exito", "¡Registro exitoso! Ya puedes iniciar sesión");
        request.getRequestDispatcher("/WEB-INF/views/login.jsp")
               .forward(request, response);
    } else {
        request.setAttribute("error", "Error al registrar el usuario");
        request.getRequestDispatcher("/WEB-INF/views/registro.jsp")
               .forward(request, response);
    }
}
```

### Manejo de Sesiones

```java
// CREAR O OBTENER SESIÓN
HttpSession session = request.getSession(); // Crea si no existe

// GUARDAR DATOS EN LA SESIÓN
session.setAttribute("usuarioId", user.getId());
session.setAttribute("rol", user.getRol());

// LEER DATOS DE LA SESIÓN
Integer usuarioId = (Integer) session.getAttribute("usuarioId");
String rol = (String) session.getAttribute("rol");

// VERIFICAR SI EL USUARIO ESTÁ LOGUEADO
if (session.getAttribute("usuarioId") == null) {
    response.sendRedirect(request.getContextPath() + "/login");
    return;
}

// CERRAR SESIÓN
session.invalidate(); // Destruye la sesión completa
```

### Protección de Rutas en JSP

```jsp
<!-- Bloquear acceso a invitados en pedirTurno.jsp -->
<% 
String tipoUsuario = (String) session.getAttribute("tipoUsuario");
if ("INVITADO".equals(tipoUsuario)) {
%>
    <div class="mensaje-bloqueado">
        <i class="fas fa-lock"></i>
        <h2>Acceso Restringido</h2>
        <p>Para pedir un turno debes iniciar sesión</p>
        <a href="${pageContext.request.contextPath}/login">Iniciar Sesión</a>
    </div>
<%
    return; // Detener renderizado del formulario
}
%>

<!-- Bloquear acceso al panel para no-admins -->
<% 
String rol = (String) session.getAttribute("rol");
if (!"ADMIN".equals(rol)) {
    response.sendRedirect(request.getContextPath() + "/inicio");
    return;
}
%>
```

---

## 📅 SISTEMA DE TURNOS Y COMENTARIOS {#turnos-comentarios}

### Modelo de Datos

#### Tabla `turnos`

```sql
CREATE TABLE turnos (
    id SERIAL PRIMARY KEY,
    usuario_id INTEGER REFERENCES usuarios(id),
    servicio_id INTEGER,
    fecha_turno DATE NOT NULL,
    hora_turno TIME NOT NULL,
    nombre_paciente VARCHAR(100) NOT NULL,
    rut VARCHAR(12) NOT NULL,
    telefono VARCHAR(15) NOT NULL,
    email VARCHAR(100) NOT NULL,
    comentarios TEXT,
    estado VARCHAR(20) DEFAULT 'PENDIENTE' 
           CHECK (estado IN ('PENDIENTE', 'CONFIRMADO', 'CANCELADO', 'COMPLETADO')),
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

#### Tabla `comentarios`

```sql
CREATE TABLE comentarios (
    id SERIAL PRIMARY KEY,
    usuario_id INTEGER REFERENCES usuarios(id),
    nombre VARCHAR(100) NOT NULL,
    comentario TEXT NOT NULL,
    calificacion INTEGER CHECK (calificacion BETWEEN 1 AND 5),
    aprobado BOOLEAN DEFAULT FALSE,
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

### Flujo: Crear Turno

```
USUARIO → Formulario pedirTurno.jsp
         ↓
         POST /pedirTurno
         ↓
    PedirTurnoServlet.doPost()
         ↓
    1. Validar sesión (no invitado)
    2. Obtener datos del formulario
    3. Crear objeto Turno
    4. turnoDAO.crear(turno)
         ↓
    TurnoDAO.crear()
         ↓
    INSERT INTO turnos (...) VALUES (...)
         ↓
    BD PostgreSQL
         ↓
    Redirect a /pedirTurno con mensaje de éxito
```

### Código: `PedirTurnoServlet.java`

```java
@WebServlet("/pedirTurno")
public class PedirTurnoServlet extends HttpServlet {
    
    private TurnoDAO turnoDAO;
    
    @Override
    public void init() {
        turnoDAO = new TurnoDAO();
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        
        // 1. VALIDAR QUE NO SEA INVITADO
        String tipoUsuario = (String) session.getAttribute("tipoUsuario");
        if ("INVITADO".equals(tipoUsuario)) {
            session.setAttribute("mensajeError", "Los invitados no pueden pedir turnos");
            response.sendRedirect(request.getContextPath() + "/pedirTurno");
            return;
        }
        
        // 2. OBTENER DATOS DEL FORMULARIO
        Integer usuarioId = (Integer) session.getAttribute("usuarioId");
        String nombrePaciente = request.getParameter("nombre");
        String rut = request.getParameter("rut");
        String telefono = request.getParameter("telefono");
        String email = request.getParameter("email");
        String servicioIdStr = request.getParameter("servicio");
        String fechaStr = request.getParameter("fecha");
        String horaStr = request.getParameter("horario");
        String comentarios = request.getParameter("mensaje");
        
        // 3. CREAR OBJETO TURNO
        Turno turno = new Turno();
        turno.setUsuarioId(usuarioId);
        turno.setServicioId(Integer.parseInt(servicioIdStr));
        turno.setFechaTurno(Date.valueOf(fechaStr));
        turno.setHoraTurno(Time.valueOf(horaStr + ":00"));
        turno.setNombrePaciente(nombrePaciente);
        turno.setRut(rut);
        turno.setTelefono(telefono);
        turno.setEmail(email);
        turno.setComentarios(comentarios);
        turno.setEstado("PENDIENTE");
        
        // 4. GUARDAR EN BD
        boolean creado = turnoDAO.crear(turno);
        
        // 5. MENSAJE DE RETROALIMENTACIÓN
        if (creado) {
            session.setAttribute("mensajeExito", "¡Turno solicitado exitosamente!");
        } else {
            session.setAttribute("mensajeError", "Error al solicitar el turno");
        }
        
        response.sendRedirect(request.getContextPath() + "/pedirTurno");
    }
}
```

### Flujo: Aprobar Comentario

```
ADMIN → Panel /panel
        ↓
    Ve comentario pendiente
        ↓
    Clic en "Aprobar"
        ↓
    POST /panel/accion
        tipo=comentario, id=1, accion=aprobar
        ↓
    PanelAccionServlet.doPost()
        ↓
    comentarioDAO.aprobar(id)
        ↓
    UPDATE comentarios SET aprobado = TRUE WHERE id = ?
        ↓
    BD PostgreSQL
        ↓
    Redirect a /panel
        ↓
    Comentario aparece en inicio.jsp y contacto.jsp
```

---

## 🎛️ PANEL DE ADMINISTRACIÓN {#panel-admin}

### Funcionalidades

1. **Gestión de Usuarios**: Ver lista de usuarios registrados
2. **Gestión de Turnos**: Aprobar, rechazar, eliminar turnos
3. **Gestión de Comentarios**: Aprobar, eliminar comentarios

### Código: `PanelGestionServlet.java`

```java
@WebServlet("/panel")
public class PanelGestionServlet extends HttpServlet {
    
    private UsuarioDAO usuarioDAO;
    private TurnoDAO turnoDAO;
    private ComentarioDAO comentarioDAO;
    
    @Override
    public void init() {
        usuarioDAO = new UsuarioDAO();
        turnoDAO = new TurnoDAO();
        comentarioDAO = new ComentarioDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        
        // 1. VALIDAR QUE ESTÉ LOGUEADO
        if (session == null || session.getAttribute("usuarioId") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        // 2. VALIDAR QUE SEA ADMIN
        String rol = (String) session.getAttribute("rol");
        if (!"ADMIN".equals(rol)) {
            response.sendRedirect(request.getContextPath() + "/inicio");
            return;
        }
        
        // 3. CARGAR DATOS DESDE LA BD
        List<Usuario> usuarios = usuarioDAO.obtenerTodos();
        List<Turno> turnos = turnoDAO.obtenerTodos();
        List<Comentario> comentarios = comentarioDAO.obtenerTodos();
        
        // 4. PASAR DATOS A LA VISTA
        request.setAttribute("usuarios", usuarios);
        request.setAttribute("turnos", turnos);
        request.setAttribute("comentarios", comentarios);
        
        // 5. MOSTRAR LA VISTA
        request.getRequestDispatcher("/WEB-INF/views/panel.jsp")
               .forward(request, response);
    }
}
```

### Código: `PanelAccionServlet.java`

```java
@WebServlet("/panel/accion")
public class PanelAccionServlet extends HttpServlet {
    
    private TurnoDAO turnoDAO;
    private ComentarioDAO comentarioDAO;
    
    @Override
    public void init() {
        turnoDAO = new TurnoDAO();
        comentarioDAO = new ComentarioDAO();
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // 1. OBTENER PARÁMETROS
        String tipo = request.getParameter("tipo");       // "turno" o "comentario"
        String idStr = request.getParameter("id");        // ID del registro
        String accion = request.getParameter("accion");   // "aprobar", "rechazar", "eliminar"
        
        int id = Integer.parseInt(idStr);
        boolean exito = false;
        
        // 2. EJECUTAR ACCIÓN SEGÚN TIPO
        if ("turno".equals(tipo)) {
            if ("aprobar".equals(accion)) {
                exito = turnoDAO.actualizarEstado(id, "CONFIRMADO");
            } else if ("rechazar".equals(accion)) {
                exito = turnoDAO.actualizarEstado(id, "CANCELADO");
            } else if ("eliminar".equals(accion)) {
                exito = turnoDAO.eliminar(id);
            }
        } else if ("comentario".equals(tipo)) {
            if ("aprobar".equals(accion)) {
                exito = comentarioDAO.aprobar(id);
            } else if ("eliminar".equals(accion)) {
                exito = comentarioDAO.eliminar(id);
            }
        }
        
        // 3. REDIRIGIR AL PANEL
        response.sendRedirect(request.getContextPath() + "/panel");
    }
}
```

### Interfaz del Panel (panel.jsp)

```jsp
<!-- Tabla de Turnos -->
<table>
    <thead>
        <tr>
            <th>ID</th>
            <th>Paciente</th>
            <th>Fecha</th>
            <th>Estado</th>
            <th>Acciones</th>
        </tr>
    </thead>
    <tbody>
        <% 
        List<Turno> turnos = (List<Turno>) request.getAttribute("turnos");
        if (turnos != null && !turnos.isEmpty()) {
            for (Turno t : turnos) {
        %>
        <tr>
            <td><%= t.getId() %></td>
            <td><%= t.getNombrePaciente() %></td>
            <td><%= t.getFechaTurno() %></td>
            <td><span class="badge badge-<%= t.getEstado().toLowerCase() %>">
                <%= t.getEstado() %>
            </span></td>
            <td>
                <% if ("PENDIENTE".equals(t.getEstado())) { %>
                    <!-- Formulario para APROBAR -->
                    <form method="POST" action="${pageContext.request.contextPath}/panel/accion" style="display:inline;">
                        <input type="hidden" name="tipo" value="turno">
                        <input type="hidden" name="id" value="<%= t.getId() %>">
                        <input type="hidden" name="accion" value="aprobar">
                        <button type="submit" class="btn-aprobar">✓ Aprobar</button>
                    </form>
                    
                    <!-- Formulario para RECHAZAR -->
                    <form method="POST" action="${pageContext.request.contextPath}/panel/accion" style="display:inline;">
                        <input type="hidden" name="tipo" value="turno">
                        <input type="hidden" name="id" value="<%= t.getId() %>">
                        <input type="hidden" name="accion" value="rechazar">
                        <button type="submit" class="btn-rechazar">✗ Rechazar</button>
                    </form>
                <% } %>
                
                <!-- Formulario para ELIMINAR -->
                <form method="POST" action="${pageContext.request.contextPath}/panel/accion" style="display:inline;">
                    <input type="hidden" name="tipo" value="turno">
                    <input type="hidden" name="id" value="<%= t.getId() %>">
                    <input type="hidden" name="accion" value="eliminar">
                    <button type="submit" class="btn-eliminar">🗑 Eliminar</button>
                </form>
            </td>
        </tr>
        <% 
            }
        }
        %>
    </tbody>
</table>
```

---

## 🔄 FLUJO DE DATOS COMPLETO {#flujo-datos}

### Caso de Uso: Usuario Solicita Turno

```
┌─────────────────────────────────────────────────────────────────┐
│                     FLUJO COMPLETO                              │
└─────────────────────────────────────────────────────────────────┘

1. INICIO
   Usuario abre navegador → http://localhost:9000/taller2/inicio

2. NAVEGACIÓN
   Usuario ve botón "Pedir Turno" → Clic
   ↓
   GET /pedirTurno
   ↓
   PagesController.doGet()
   ↓
   Forward a pedirTurno.jsp
   ↓
   JSP verifica sesión:
   - Si es INVITADO → Muestra "Acceso Restringido"
   - Si es USUARIO/ADMIN → Muestra formulario

3. COMPLETAR FORMULARIO
   Usuario llena:
   - Nombre: "Juan Pérez"
   - RUT: "12345678-9"
   - Teléfono: "56912345678"
   - Email: "juan@test.cl"
   - Servicio: "Ortodoncia"
   - Fecha: "2025-11-20"
   - Horario: "10:00"
   - Mensaje: "Primera consulta"
   ↓
   Clic en "Solicitar Turno"

4. ENVÍO DE DATOS
   POST /pedirTurno
   Body: nombre=Juan+Pérez&rut=12345678-9&...
   ↓
   PedirTurnoServlet.doPost()

5. VALIDACIÓN EN SERVLET
   - Verificar que no sea invitado ✅
   - Obtener usuarioId de la sesión ✅
   - Parsear fecha y hora ✅
   - Crear objeto Turno ✅

6. PERSISTENCIA EN BD
   turnoDAO.crear(turno)
   ↓
   TurnoDAO.crear()
   ↓
   DatabaseConnection.getInstance().getConnection()
   ↓
   PreparedStatement con SQL:
   INSERT INTO turnos 
   (usuario_id, servicio_id, fecha_turno, hora_turno, 
    nombre_paciente, rut, telefono, email, comentarios, estado)
   VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, 'PENDIENTE')
   ↓
   PostgreSQL ejecuta INSERT
   ↓
   Retorna true si éxito

7. RETROALIMENTACIÓN
   session.setAttribute("mensajeExito", "¡Turno solicitado!")
   ↓
   response.sendRedirect("/pedirTurno")
   ↓
   pedirTurno.jsp muestra mensaje verde:
   "✓ ¡Turno solicitado exitosamente!"

8. GESTIÓN POR ADMIN
   Admin abre → http://localhost:9000/taller2/panel
   ↓
   GET /panel
   ↓
   PanelGestionServlet.doGet()
   ↓
   turnoDAO.obtenerTodos()
   ↓
   SELECT * FROM turnos ORDER BY fecha_turno, hora_turno
   ↓
   PostgreSQL retorna lista de turnos
   ↓
   panel.jsp renderiza tabla con turno de Juan Pérez
   ↓
   Admin ve botones: [✓ Aprobar] [✗ Rechazar] [🗑 Eliminar]

9. APROBACIÓN
   Admin hace clic en "Aprobar"
   ↓
   POST /panel/accion
   Body: tipo=turno&id=1&accion=aprobar
   ↓
   PanelAccionServlet.doPost()
   ↓
   turnoDAO.actualizarEstado(1, "CONFIRMADO")
   ↓
   UPDATE turnos SET estado = 'CONFIRMADO' WHERE id = 1
   ↓
   PostgreSQL ejecuta UPDATE
   ↓
   Redirect a /panel
   ↓
   Badge cambia de naranja (PENDIENTE) a verde (CONFIRMADO)

10. FIN
    Turno aprobado y visible para el usuario
```

### Diagrama de Secuencia

```
Usuario          PedirTurno     TurnoDAO      DatabaseConn    PostgreSQL
  │                 │              │               │              │
  ├─POST /pedirTurno→│              │               │              │
  │                 ├─crear(turno)→│               │              │
  │                 │              ├─getConnection()→              │
  │                 │              │               ├─return conn →│
  │                 │              ├─prepareStatement()→           │
  │                 │              ├─setString()...─→              │
  │                 │              ├─executeUpdate()→              │
  │                 │              │               │              ├─INSERT
  │                 │              │               │              ├─return 1
  │                 │              ├─return true──←│              │
  │                 ├─return true←─│               │              │
  │                 ├─setAttribute("mensajeExito")  │              │
  │                 ├─sendRedirect("/pedirTurno")  │              │
  ├─HTTP 302────────┤              │               │              │
  ├─GET /pedirTurno→│              │               │              │
  ├─Muestra mensaje verde          │               │              │
```

---

## 📊 RESUMEN DE TECNOLOGÍAS Y PATRONES

### Stack Tecnológico

| Capa | Tecnología | Versión |
|------|------------|---------|
| **Frontend** | JSP + CSS + JavaScript | Jakarta EE 9 |
| **Backend** | Java (Servlets) | Java 11 |
| **Base de Datos** | PostgreSQL | 13+ |
| **Servidor de Aplicaciones** | GlassFish | 6.2.5 |
| **Build Tool** | Maven | 3.8.7 |
| **JDBC Driver** | PostgreSQL JDBC Driver | 42.6.0 |

### Patrones de Diseño Utilizados

1. **Singleton**: `DatabaseConnection.java`
   - Una única instancia de conexión a BD
   - Thread-safe con double-check locking

2. **DAO (Data Access Object)**: `UsuarioDAO`, `TurnoDAO`, `ComentarioDAO`
   - Encapsula toda la lógica de acceso a datos
   - Separa SQL de la lógica de negocio

3. **MVC (Model-View-Controller)**:
   - **Model**: `Usuario.java`, `Turno.java`, `Comentario.java`
   - **View**: JSP files (`login.jsp`, `panel.jsp`, etc.)
   - **Controller**: Servlets (`LoginServlet`, `PanelGestionServlet`, etc.)

4. **Front Controller**: `PagesController.java`
   - Maneja rutas estáticas (`/inicio`, `/servicios`, etc.)
   - Centraliza la lógica de navegación

5. **Session Management**: HttpSession
   - Mantiene el estado del usuario
   - Almacena datos entre peticiones

### Convenciones y Buenas Prácticas

#### Nomenclatura

```java
// Clases: PascalCase
public class UsuarioDAO { }

// Métodos: camelCase
public Usuario autenticar(String usuario, String contrasena) { }

// Constantes: UPPER_SNAKE_CASE
private static final String DB_URL = "jdbc:postgresql://...";

// Variables: camelCase
String nombreUsuario = "Subaru";
```

#### Manejo de Recursos

```java
// ✅ CORRECTO: Try-with-resources (cierra automáticamente)
try (Connection conn = DatabaseConnection.getInstance().getConnection();
     PreparedStatement stmt = conn.prepareStatement(sql)) {
    // código
} catch (SQLException e) {
    e.printStackTrace();
}

// ❌ INCORRECTO: Cierre manual (puede olvidarse)
Connection conn = null;
PreparedStatement stmt = null;
try {
    conn = DatabaseConnection.getInstance().getConnection();
    stmt = conn.prepareStatement(sql);
    // código
} finally {
    if (stmt != null) stmt.close();
    if (conn != null) conn.close();
}
```

#### Prevención de SQL Injection

```java
// ✅ CORRECTO: PreparedStatement con parámetros
String sql = "SELECT * FROM usuarios WHERE usuario = ? AND contrasena = ?";
PreparedStatement stmt = conn.prepareStatement(sql);
stmt.setString(1, usuario);
stmt.setString(2, contrasena);

// ❌ INCORRECTO: Concatenación de strings
String sql = "SELECT * FROM usuarios WHERE usuario = '" + usuario + 
             "' AND contrasena = '" + contrasena + "'";
// Vulnerable a: usuario' OR '1'='1
```

---

## 🚀 GUÍA DE DESPLIEGUE

### Requisitos del Sistema

- **Java JDK**: 11 o superior
- **PostgreSQL**: 13 o superior
- **GlassFish**: 6.2.5
- **Maven**: 3.8.7 o superior

### Pasos de Instalación

#### 1. Configurar Base de Datos

```sql
-- Conectarse a PostgreSQL
psql -U postgres

-- Crear base de datos
CREATE DATABASE taller2_bd;

-- Conectarse a la BD
\c taller2_bd

-- Ejecutar script de creación de tablas
\i /path/to/create_database.sql
```

#### 2. Compilar Proyecto

```bash
cd /path/to/Taller2

# Establecer JAVA_HOME
export JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64

# Compilar con Maven
mvn clean package
```

#### 3. Desplegar en GlassFish

```bash
# Iniciar GlassFish
asadmin start-domain

# Desplegar aplicación
asadmin deploy --force true /path/to/Taller2/target/taller2.war

# Verificar despliegue
asadmin list-applications
```

#### 4. Acceder a la Aplicación

```
URL: http://localhost:9000/taller2/inicio

Usuarios de prueba:
- Admin: Subaru / admin123
- Usuario: Blas / user123
- Invitado: Clic en "Acceder como invitado"
```

---

## 🐛 SOLUCIÓN DE PROBLEMAS COMUNES

### Error: "Cannot find PostgreSQL Driver"

```bash
# Verificar que el driver esté en pom.xml
<dependency>
    <groupId>org.postgresql</groupId>
    <artifactId>postgresql</artifactId>
    <version>42.6.0</version>
</dependency>

# Recompilar
mvn clean package
```

### Error: "Port 9000 already in use"

```bash
# Detener GlassFish
asadmin stop-domain

# Cambiar puerto en domain.xml o matar proceso
sudo lsof -i :9000
sudo kill -9 <PID>

# Reiniciar
asadmin start-domain
```

### Error: "Connection refused to PostgreSQL"

```bash
# Verificar que PostgreSQL esté corriendo
sudo systemctl status postgresql

# Iniciar si está detenido
sudo systemctl start postgresql

# Verificar puerto (por defecto 5432)
sudo netstat -plunt | grep postgres
```

### Error: "Class file has wrong version 65.0"

```bash
# Significa que se compiló con Java 21 pero GlassFish usa Java 11

# Solución: Compilar con Java 11
export JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64
mvn clean package

# Verificar versión compilada
javap -v target/classes/com/taller2/controller/LoginServlet.class | grep "major version"
# Debe mostrar: major version: 55 (Java 11)
```

---

## 📚 GLOSARIO DE TÉRMINOS

| Término | Definición |
|---------|------------|
| **Servlet** | Clase Java que maneja peticiones HTTP y genera respuestas dinámicas |
| **JSP** | JavaServer Pages - Tecnología para crear páginas web dinámicas con Java |
| **DAO** | Data Access Object - Patrón que encapsula acceso a datos |
| **Singleton** | Patrón que garantiza una única instancia de una clase |
| **POJO** | Plain Old Java Object - Objeto Java simple sin herencia especial |
| **PreparedStatement** | Sentencia SQL precompilada con parámetros (previene SQL Injection) |
| **HttpSession** | Objeto que mantiene datos del usuario entre peticiones |
| **Forward** | Transferir petición a otro recurso en el servidor (misma URL) |
| **Redirect** | Indicar al navegador que vaya a otra URL (cambia URL) |
| **JDBC** | Java Database Connectivity - API para conectarse a bases de datos |
| **Try-with-resources** | Sintaxis Java que cierra recursos automáticamente |
| **MVC** | Model-View-Controller - Patrón arquitectónico de separación de capas |

---

## 🎓 CONCEPTOS CLAVE EXPLICADOS

### ¿Por qué separar en capas?

```
SIN CAPAS (todo en un servlet):
❌ Difícil de mantener
❌ Código duplicado
❌ SQL mezclado con HTML
❌ Difícil de testear

CON CAPAS (MVC + DAO):
✅ Fácil de mantener (cada capa tiene una responsabilidad)
✅ Reutilización (un DAO se usa en múltiples servlets)
✅ SQL separado en DAOs
✅ Fácil de testear (mock de DAOs)
```

### ¿Por qué usar PreparedStatement?

```java
// EJEMPLO DE SQL INJECTION

// Usuario malicioso escribe en el formulario:
// Usuario: admin' OR '1'='1
// Contraseña: cualquier cosa

// Con concatenación (VULNERABLE):
String sql = "SELECT * FROM usuarios WHERE usuario = '" + usuario + 
             "' AND contrasena = '" + contrasena + "'";
// Resultado: SELECT * FROM usuarios WHERE usuario = 'admin' OR '1'='1' AND contrasena = 'cualquier cosa'
// ¡'1'='1' siempre es verdadero! → Login sin contraseña ❌

// Con PreparedStatement (SEGURO):
String sql = "SELECT * FROM usuarios WHERE usuario = ? AND contrasena = ?";
PreparedStatement stmt = conn.prepareStatement(sql);
stmt.setString(1, "admin' OR '1'='1"); // Se escapa automáticamente
stmt.setString(2, "cualquier cosa");
// Resultado: Busca literalmente el usuario "admin' OR '1'='1" → No existe ✅
```

### Forward vs Redirect

```java
// FORWARD (misma petición, misma URL)
request.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(request, response);
// URL en navegador: http://localhost:9000/taller2/login
// Se ejecuta en el servidor, el navegador no sabe
// Los atributos del request se mantienen

// REDIRECT (nueva petición, nueva URL)
response.sendRedirect(request.getContextPath() + "/inicio");
// URL en navegador: http://localhost:9000/taller2/inicio
// El navegador hace una nueva petición GET
// Los atributos del request se pierden (usar session)
```

### Session vs Request Attributes

```java
// REQUEST ATTRIBUTE (solo para la petición actual)
request.setAttribute("error", "Usuario no encontrado");
// Disponible en: mismo request, forward a JSP
// Se pierde en: redirect

// SESSION ATTRIBUTE (persiste entre peticiones)
session.setAttribute("usuarioId", user.getId());
// Disponible en: todas las peticiones mientras la sesión esté activa
// Se mantiene en: redirect, forward, nuevas peticiones
// Se pierde en: session.invalidate() o timeout
```

---

## 📝 CONCLUSIÓN

Este sistema demuestra la implementación de:

1. **Patrón Singleton** para gestión eficiente de conexiones a BD
2. **Patrón DAO** para separación de lógica de acceso a datos
3. **Arquitectura MVC** con Servlets (Controller), JSP (View) y POJOs (Model)
4. **Sistema de autenticación robusto** con roles y protección de rutas
5. **Gestión de turnos y comentarios** con workflow de aprobación
6. **Panel administrativo** para gestión centralizada

### Ventajas de esta Arquitectura

- ✅ **Escalable**: Fácil agregar nuevas funcionalidades
- ✅ **Mantenible**: Código organizado por responsabilidades
- ✅ **Seguro**: Prevención de SQL Injection, validación de sesiones
- ✅ **Reutilizable**: DAOs y utilidades se comparten entre componentes
- ✅ **Profesional**: Sigue estándares de la industria (Jakarta EE)

---

**Autor:** Equipo de Desarrollo Taller2  
**Fecha de Creación:** Noviembre 2025  
**Última Actualización:** 17 de noviembre de 2025  
**Versión:** 1.0
