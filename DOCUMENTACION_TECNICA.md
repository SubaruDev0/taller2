# Documentación Técnica

## Arquitectura Detallada

- **Patrón MVC**: Modelo (clases en `src/main/java/com/taller2/model`), Vista (JSPs en `src/main/webapp/WEB-INF/views`), Controlador (Servlets en `src/main/java/com/taller2/controller`).
- **Flujo de datos**: El cliente envía peticiones HTTP → Servlet procesa → DAO accede a la base → JSP renderiza.
- **Diagrama de flujo**: (añadir imagen `arquitectura.png` en `/img`)

## Base de Datos

- **Motor**: PostgreSQL 15.
- **Esquema**:
  - `usuario(id, nombre, email, password, rol)`
  - `servicio(id, nombre, descripcion, precio, imagen, activo)`
  - `cita(id, usuario_id, servicio_id, fecha, hora, estado, comentarios)`
- **Índices**: PK en cada tabla, FK en `cita` para `usuario_id` y `servicio_id`.

## Funcionalidades Avanzadas

### Upload de Imágenes (Drag & Drop)

- **Frontend**: HTML5 Drag & Drop API + `FileReader` para preview.
- **Backend**: `ImageUploadServlet` recibe `multipart/form-data`, valida tipo y tamaño, guarda en `/img`.
- **Código de ejemplo**:

```java
@MultipartConfig
@WebServlet("/upload/imagen")
public class ImageUploadServlet extends HttpServlet {
    // ... (código ya implementado)
}
```

### Pre‑selección de Servicio en Solicitud de Cita

- El botón **Agendar** en `servicios.jsp` envía `?servicioId=ID`.
- `PedirCitaServlet.doGet` captura el parámetro y lo pasa al JSP.
- En `pedirCita.jsp` se pre‑selecciona el `<select>` y se hace scroll al formulario.

## Componentes Clave

- **DAOs**: Encapsulan acceso a la base de datos, usando JDBC.
- **Models**: POJOs que representan entidades.
- **Controllers**: Servlets que gestionan la lógica de negocio.
- **Views**: JSPs que generan HTML dinámico.

## FAQ – Preguntas Frecuentes

1. **¿Cómo funciona el drag & drop de imágenes?**
   - El usuario arrastra un archivo sobre la zona designada, JavaScript captura el `File` y lo envía con `fetch` a `ImageUploadServlet` usando `FormData`.
2. **¿Qué base de datos se usa y por qué?**
   - PostgreSQL, por su robustez, soporte de tipos avanzados y licencia libre.
3. **¿Por qué JSP y no HTML puro?**
   - JSP permite combinar lógica Java con la vista, facilitando la inserción de datos dinámicos sin necesidad de un framework SPA.
4. **¿Qué hacen los DAOs?**
   - Abstraen la capa de persistencia, centralizando consultas y evitando código SQL repetido.
5. **¿Cómo funciona el patrón MVC aquí?**
   - Modelo = POJOs, Vista = JSP, Controlador = Servlets; la separación mejora mantenibilidad.
6. **¿Cómo se manejan las sesiones?**
   - `HttpSession` almacena `usuarioId` y `rol` después del login; los servlets verifican su existencia.
7. **¿Cómo se validan los datos?**
   - Validaciones tanto en cliente (HTML5 `required`, JavaScript) como en servidor (checks en `PedirCitaServlet`).

---
*Esta documentación se ha actualizado para reflejar los cambios recientes, incluyendo el drag & drop de imágenes y la pre‑selección de servicios al solicitar una cita.* - Sistema de Gestión Clínica Dental

## 1. Descripción del Proyecto

Este proyecto es una aplicación web Java (JEE) diseñada para la gestión integral de una clínica dental. Permite a los usuarios visualizar servicios, agendar citas y dejar comentarios. Para los administradores, ofrece un panel de control para gestionar usuarios, servicios, citas y comentarios.

## 2. Tecnologías Utilizadas

- **Lenguaje:** Java (JDK 8+)
- **Framework Web:** Java Server Pages (JSP), Servlets
- **Base de Datos:** PostgreSQL
- **Servidor de Aplicaciones:** GlassFish 4.1.1
- **Gestión de Dependencias:** Maven
- **Frontend:** HTML5, CSS3, JavaScript (Vanilla)
- **Conectividad:** JDBC (Driver PostgreSQL)

## 3. Arquitectura del Sistema

El sistema sigue el patrón de diseño **MVC (Modelo-Vista-Controlador)**:

### Flujo de Datos

```
Cliente (Navegador) 
    ↓ HTTP Request
Servlet (Controlador)
    ↓ Procesa lógica de negocio
DAO (Acceso a Datos)
    ↓ Consultas SQL
Base de Datos PostgreSQL
    ↑ Resultados
DAO → Servlet → JSP (Vista)
    ↓ HTML
Cliente (Navegador)
```

### 3.1. Modelo (com.taller2.model)

Representa los objetos de negocio y la estructura de datos. Los modelos son **POJOs (Plain Old Java Objects)** que encapsulan los datos de las entidades del negocio.

- `Usuario.java`: Representa a los usuarios del sistema (admin/cliente). Contiene atributos como id, nombre, email, password (hash), rol, fecha de creación.
- `Cita.java`: Representa las citas agendadas (anteriormente Turno). Incluye información del paciente, servicio solicitado, fecha, hora, estado (PENDIENTE/APROBADA/RECHAZADA) y comentarios adicionales.
- `Servicio.java`: Representa los servicios dentales ofrecidos. Incluye nombre, descripción, precio, imagen y estado (activo/inactivo).
- `Comentario.java`: Representa las opiniones de los pacientes. Contiene el texto del comentario, usuario que lo escribió, fecha y estado de aprobación.

### 3.2. Vista (src/main/webapp/WEB-INF/views)

Archivos JSP encargados de la presentación de datos.

- `inicio.jsp`: Página principal con carrusel y bienvenida.
- `servicios.jsp`: Catálogo de servicios dinámico.
- `pedirCita.jsp`: Formulario para agendar nuevas citas.
- `panel.jsp`: Dashboard administrativo para gestión integral.
- `login.jsp` / `registro.jsp`: Autenticación y registro de usuarios.
- `contacto.jsp` / `equipo.jsp`: Páginas informativas.

### 3.3. Controlador (com.taller2.controller)

Servlets que manejan las peticiones HTTP y la lógica de negocio. Estos componentes son el corazón del sistema, procesando las solicitudes del cliente y coordinando entre el modelo y la vista.

- `PagesController.java`: Maneja la navegación de páginas estáticas y carga datos públicos (inicio, servicios, equipo, contacto).
- `LoginServlet.java`: Gestiona la autenticación de usuarios, validando credenciales y creando sesiones.
- `RegistroServlet.java`: Procesa el registro de nuevos usuarios con validaciones de seguridad.
- `LogoutServlet.java`: Cierra la sesión del usuario actual.
- `PedirCitaServlet.java`: Procesa la solicitud de nuevas citas con validaciones completas (campos obligatorios, formato de fecha, etc.).
- `PanelGestionServlet.java`: Carga los datos para el panel de administración (usuarios, citas, servicios, comentarios).
- `PanelAccionServlet.java`: Procesa acciones administrativas (aprobar/rechazar citas, aprobar/eliminar comentarios, activar/desactivar servicios).
- `ImageUploadServlet.java`: Gestiona la subida de imágenes con soporte para Drag & Drop, validando formato y tamaño.

### 3.4. Acceso a Datos (com.taller2.dao)

**¿Qué es un DAO?** DAO (Data Access Object) es un patrón de diseño que proporciona una interfaz abstracta para acceder a la base de datos. Los DAOs encapsulan toda la lógica de acceso a datos, separando la lógica de negocio de la persistencia.

**Ventajas de usar DAOs:**
- **Separación de responsabilidades**: El código de negocio no necesita conocer detalles de SQL.
- **Reutilización**: Las operaciones CRUD se centralizan y pueden reutilizarse.
- **Mantenibilidad**: Los cambios en la base de datos solo afectan a los DAOs.
- **Testabilidad**: Es más fácil crear mocks para pruebas unitarias.

**DAOs implementados:**

- `BaseDAO.java`: Clase abstracta con métodos comunes para todos los DAOs (conexión, cierre de recursos).
- `UsuarioDAO.java`: CRUD de usuarios - crear, obtener por ID/email, listar todos, actualizar, eliminar.
- `CitaDAO.java`: CRUD de citas - crear, obtener por ID, listar por usuario, listar todas, cambiar estado, eliminar.
- `ServicioDAO.java`: CRUD de servicios - crear, obtener por ID, listar activos, listar todos, actualizar, cambiar estado.
- `ComentarioDAO.java`: CRUD de comentarios - crear, obtener por ID, listar aprobados, listar pendientes, aprobar, eliminar.

### 3.5. Utilidades (com.taller2.util)

- `DatabaseConnection.java`: Implementación del patrón **Singleton** para la conexión a la base de datos. Garantiza que solo exista una instancia de conexión, mejorando el rendimiento y evitando problemas de concurrencia.

- `RutValidator.java`: Utilidad para validar RUT (Rol Único Tributario) chileno usando el algoritmo estándar de módulo 11. Incluye las siguientes funcionalidades:
  - **validarRut(String rut)**: Valida formato y dígito verificador del RUT
  - **formatearRut(String rut)**: Normaliza el formato del RUT (elimina puntos, guiones, espacios)
  - **calcularDigitoVerificador(String rutSinDV)**: Calcula el dígito verificador usando módulo 11
  - **esRutTesteo(String rut)**: Identifica RUTs de prueba (11111111-1, 22222222-2, 33333333-3, 44444444-4)
  
  **Algoritmo de validación:** El sistema multiplica cada dígito del RUT por la serie [2,3,4,5,6,7] de forma cíclica, suma los resultados, calcula el módulo 11 y determina el dígito verificador (11→0, 10→K).

---

## 4. Funcionalidades Avanzadas

### 4.1. Validación de RUT Chileno

El sistema implementa validación robusta del RUT (Rol Único Tributario) chileno, un identificador único usado en Chile para personas y empresas.

#### Algoritmo de Validación

El RUT chileno usa el **algoritmo de módulo 11** para validar su dígito verificador:

1. **Formato esperado**: `12345678-9` (8 dígitos + guión + dígito verificador)
2. **Normalización**: Se eliminan puntos, guiones y espacios
3. **Cálculo del dígito verificador**:
   - Se multiplica cada dígito por la serie [2,3,4,5,6,7] de forma cíclica (de derecha a izquierda)
   - Se suman todos los productos
   - Se calcula el resto de dividir la suma por 11
   - Se resta el resto de 11
   - Casos especiales: si el resultado es 11 → 0, si es 10 → K

#### Ejemplo de Validación

```
RUT: 12.345.678-5

1. Normalizar: 12345678-5
2. Separar: número=12345678, dv=5
3. Multiplicar de derecha a izquierda:
   8×2 + 7×3 + 6×4 + 5×5 + 4×6 + 3×7 + 2×2 + 1×3 = 139
4. Calcular: 11 - (139 % 11) = 11 - 7 = 4
5. Comparar: 4 ≠ 5 → RUT inválido

RUT correcto sería: 12.345.678-4
```

#### RUTs de Prueba

El sistema reconoce los siguientes RUTs como válidos para propósitos de testing:
- `11111111-1`
- `22222222-2`
- `33333333-3`
- `44444444-4`

#### Implementación en el Código

```java
// En PedirCitaServlet.java
String rut = request.getParameter("rut");
if (!RutValidator.validarRut(rut)) {
    mensajeError = "El RUT ingresado no es válido. Verifique el formato (ej: 12345678-9).";
    request.setAttribute("mensajeError", mensajeError);
    doGet(request, response);
    return;
}
```

### 4.2. Upload de Imágenes con Drag & Drop

Una de las funcionalidades más destacadas del sistema es la capacidad de subir imágenes arrastrándolas directamente sobre un área designada en el panel de administración.

#### Tecnologías Utilizadas

**Frontend:**
- **HTML5 Drag & Drop API**: Eventos `dragover`, `dragleave`, `drop` para detectar archivos arrastrados.
- **File API**: Para leer el contenido del archivo en el navegador.
- **FileReader API**: Para generar una vista previa (preview) de la imagen antes de subirla.
- **Fetch API**: Para enviar el archivo al servidor de forma asíncrona sin recargar la página.
- **FormData**: Para construir una petición multipart/form-data compatible con el servidor.

**Backend:**
- **@MultipartConfig**: Anotación en el servlet para habilitar el procesamiento de archivos.
- **HttpServletRequest.getPart()**: Método para extraer el archivo de la petición.
- **Validaciones**: Tipo MIME (solo imágenes), tamaño máximo (5MB).
- **Almacenamiento**: Los archivos se guardan en la carpeta `/img` del proyecto con nombres únicos.

#### Flujo Completo del Proceso

1. **Usuario arrastra imagen**: El usuario arrastra un archivo sobre la zona designada en `panel.jsp`.

2. **Preview en el navegador**: 
   ```javascript
   // JavaScript lee el archivo y muestra preview
   const file = event.dataTransfer.files[0];
   const reader = new FileReader();
   reader.onload = (e) => {
       previewImg.src = e.target.result; // Muestra la imagen
   };
   reader.readAsDataURL(file);
   ```

3. **Envío al servidor**:
   ```javascript
   // Se crea FormData con el archivo y datos adicionales
   const formData = new FormData();
   formData.append('imagen', file);
   formData.append('nombre', nombreServicio);
   formData.append('descripcion', descripcion);
   formData.append('precio', precio);
   
   // Se envía con Fetch API
   fetch('/taller2/upload/imagen', {
       method: 'POST',
       body: formData
   });
   ```

4. **Procesamiento en el servidor** (`ImageUploadServlet.java`):
   ```java
   @MultipartConfig(
       maxFileSize = 5242880,      // 5MB
       maxRequestSize = 10485760   // 10MB
   )
   @WebServlet("/upload/imagen")
   public class ImageUploadServlet extends HttpServlet {
       
       protected void doPost(HttpServletRequest request, HttpServletResponse response) {
           Part filePart = request.getPart("imagen");
           
           // Validar tipo MIME
           String contentType = filePart.getContentType();
           if (!contentType.startsWith("image/")) {
               // Rechazar archivo
               return;
           }
           
           // Generar nombre único
           String fileName = System.currentTimeMillis() + "_" + 
                            getSubmittedFileName(filePart);
           
           // Guardar en /img
           String uploadPath = getServletContext().getRealPath("/img");
           filePart.write(uploadPath + File.separator + fileName);
           
           // Guardar referencia en base de datos
           ServicioDAO servicioDAO = new ServicioDAO();
           servicio.setImagen(fileName);
           servicioDAO.crear(servicio);
       }
   }
   ```

5. **Confirmación al usuario**: El navegador recibe respuesta del servidor y muestra mensaje de éxito/error.

#### Validaciones Implementadas

**Frontend:**
- Solo permite arrastrar archivos (no texto u otros elementos).
- Muestra feedback visual cuando el usuario arrastra sobre la zona.
- Valida que sea un archivo de imagen antes de enviarlo.

**Backend:**
- **Tipo de archivo**: Solo acepta MIME types que comienzan con `image/` (jpeg, png, gif, webp).
- **Tamaño máximo**: 5MB por archivo.
- **Nombre único**: Previene colisiones usando timestamp + nombre original.
- **Sanitización**: Limpia caracteres especiales del nombre del archivo.

#### Ventajas de esta Implementación

- **UX mejorada**: Más intuitivo que un botón tradicional de "Seleccionar archivo".
- **Preview instantáneo**: El usuario ve la imagen antes de subirla.
- **Sin recargas**: Todo el proceso es asíncrono (AJAX).
- **Seguridad**: Validaciones robustas en cliente y servidor.
- **Escalabilidad**: Fácil de extender para otros tipos de archivos.

### 4.2. Pre-selección de Servicio en Solicitud de Cita

Esta funcionalidad mejora la experiencia del usuario al permitir que, al hacer clic en "Agendar" desde una tarjeta de servicio específico, el formulario de solicitud de cita se abra con ese servicio ya pre-seleccionado.

#### Implementación Técnica

**1. Página de Servicios (`servicios.jsp`):**
```html
<!-- Cada tarjeta de servicio incluye el ID en la URL -->
<button class="btn-info" 
    onclick="window.location.href='${pageContext.request.contextPath}/pedirCita?servicioId=<%= s.getId() %>'">
    Agendar
</button>
```

**2. Servlet de Citas (`PedirCitaServlet.java`):**
```java
@Override
protected void doGet(HttpServletRequest request, HttpServletResponse response) {
    // Cargar servicios activos
    request.setAttribute("servicios", servicioDAO.obtenerActivos());
    
    // Capturar servicioId de la URL
    String servicioIdParam = request.getParameter("servicioId");
    if (servicioIdParam != null && !servicioIdParam.isEmpty()) {
        request.setAttribute("servicioIdPreseleccionado", servicioIdParam);
    }
    
    request.getRequestDispatcher("/WEB-INF/views/pedirCita.jsp").forward(request, response);
}
```

**3. Formulario de Citas (`pedirCita.jsp`):**
```javascript
// Campo oculto con el ID pre-seleccionado
<input type="hidden" id="preselectedServicioId" value="${servicioIdPreseleccionado}" />

<script>
document.addEventListener("DOMContentLoaded", function () {
    const preselectedId = document.getElementById('preselectedServicioId').value;
    if (preselectedId) {
        // Pre-seleccionar en el dropdown
        const servicioSelect = document.getElementById('servicio');
        servicioSelect.value = preselectedId;
        
        // Scroll suave al formulario
        document.getElementById('citas').scrollIntoView({ 
            behavior: 'smooth', 
            block: 'start' 
        });
    }
});
</script>
```

#### Beneficios

- **Menos clics**: El usuario no tiene que buscar el servicio en el dropdown.
- **Flujo intuitivo**: Conexión directa entre ver un servicio y agendarlo.
- **Scroll automático**: La página se desplaza automáticamente al formulario.

---

## 5. Base de Datos

### Esquema de la Base de Datos

El esquema de la base de datos (`taller2_bd`) consta de las siguientes tablas principales:

#### Tabla: `usuarios`
```sql
CREATE TABLE usuarios (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    rol VARCHAR(20) DEFAULT 'CLIENTE',
    fecha_registro TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```
**Almacena**: Credenciales y datos personales de todos los usuarios del sistema (clientes y administradores).

#### Tabla: `servicios`
```sql
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
```
**Almacena**: Catálogo de tratamientos dentales con nombre, descripción, precio, duración estimada, imagen y estado activo/inactivo.

#### Tabla: `citas`
```sql
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
```
**Almacena**: Registro de citas/solicitudes de turno con referencia a usuario y servicio, información del paciente (incluyendo RUT validado), fecha/hora deseada y estado del proceso.

**Estados posibles:**
- **PENDIENTE**: Cita solicitada, esperando revisión del administrador
- **APROBADA**: Cita aprobada por el administrador
- **RECHAZADA**: Cita rechazada por el administrador
- **CONFIRMADO**: Paciente confirmó su asistencia
- **CANCELADO**: Cita cancelada por alguna de las partes
- **COMPLETADO**: Cita realizada exitosamente

**Validación de RUT:** El sistema implementa validación de RUT chileno usando el algoritmo estándar de módulo 11. Los RUTs de prueba reconocidos son: `11111111-1`, `22222222-2`, `33333333-3`, `44444444-4`.

#### Tabla: `comentarios`
```sql
CREATE TABLE IF NOT EXISTS comentarios (
    id SERIAL PRIMARY KEY,
    usuario_id INTEGER REFERENCES usuarios(id),
    nombre VARCHAR(100) NOT NULL,
    comentario TEXT NOT NULL,
    calificacion INTEGER CHECK (calificacion BETWEEN 1 AND 5),
    aprobado BOOLEAN DEFAULT FALSE,
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```
**Almacena**: Opiniones/testimonios de usuarios con calificación de 1 a 5 estrellas, sujetas a aprobación por parte de los administradores.

### Relaciones e Índices

- **Foreign Keys**: 
  - `citas.usuario_id` → `usuarios.id` (ON DELETE CASCADE)
  - `citas.servicio_id` → `servicios.id` (ON DELETE SET NULL)
  - `comentarios.usuario_id` → `usuarios.id` (ON DELETE CASCADE)

- **Índices automáticos**: Se crean automáticamente en Primary Keys y Foreign Keys.

- **Constraint UNIQUE**: El campo `email` en `usuarios` tiene restricción de unicidad.

### Motor de Base de Datos

**PostgreSQL 15** fue elegido por las siguientes razones:
- **Robustez**: Manejo eficiente de transacciones ACID.
- **Tipos avanzados**: Soporte nativo para JSON, arrays, fechas/horas.
- **Licencia libre**: PostgreSQL es completamente open source.
- **Escalabilidad**: Preparado para crecer con el proyecto.
- **Comunidad activa**: Amplia documentación y soporte.

---

## 6. Despliegue

El proyecto incluye un script de automatización `desplegar.sh` que facilita el proceso de compilación y despliegue.

### Requisitos Previos

- **JDK 8 o superior**
- **Maven 3.6+**
- **GlassFish Server 4.1.1**
- **PostgreSQL 15**

### Pasos de Despliegue

#### Opción 1: Script Automático
```bash
./desplegar.sh
```

#### Opción 2: Pasos Manuales

1. **Compilar el proyecto**:
   ```bash
   mvn clean package
   ```

2. **Desplegar en GlassFish**:
   ```bash
   asadmin deploy --force target/taller2.war
   ```

3. **Acceder a la aplicación**:
   ```
   http://localhost:9000/taller2/
   ```

### Configuración de Base de Datos

Antes del primer despliegue, ejecutar:

```bash
psql -U postgres -d taller2_bd -f src/main/resources/database/schema.sql
```

---

## 7. Preguntas Frecuentes (FAQ)

### ¿Cómo funciona el drag & drop de imágenes?

El usuario arrastra un archivo sobre una zona designada en el panel de administración. JavaScript captura el evento `drop`, lee el archivo usando la `File API`, muestra un preview con `FileReader`, y envía el archivo al servidor usando `fetch` con `FormData`. El servidor (`ImageUploadServlet`) valida el tipo y tamaño, genera un nombre único y guarda el archivo en `/img`.

**Tecnologías clave**: HTML5 Drag & Drop API, FileReader, Fetch API, FormData, @MultipartConfig.

---

### ¿Qué base de datos se usa y por qué?

Se utiliza **PostgreSQL 15**. Fue elegido por:
- Su robustez y confiabilidad en entornos de producción.
- Soporte de tipos de datos avanzados (JSON, arrays, fechas).
- Licencia completamente libre (open source).
- Excelente rendimiento y escalabilidad.
- Amplia comunidad y documentación.

---

### ¿Por qué JSP en lugar de HTML puro?

**JSP (JavaServer Pages)** permite combinar lógica Java con HTML, facilitando:
- **Generación dinámica**: Insertar datos de la base directamente en las vistas.
- **Reutilización**: Usar scriplets y JSTL para evitar repetición de código.
- **Integración nativa**: Comunicación directa con servlets sin necesidad de APIs REST.
- **Simplicidad**: No requiere un framework frontend complejo (React, Angular) para proyectos medianos.

**Ejemplo**:
```jsp
<% List<Servicio> servicios = (List<Servicio>) request.getAttribute("servicios"); %>
<% for (Servicio s : servicios) { %>
    <div class="servicio-card">
        <h3><%= s.getNombre() %></h3>
        <p><%= s.getDescripcion() %></p>
    </div>
<% } %>
```

Sin JSP, necesitaríamos crear una API REST y consumirla con JavaScript, añadiendo complejidad innecesaria.

---

### ¿Qué hacen los DAOs?

**DAO (Data Access Object)** es un patrón de diseño que encapsula toda la lógica de acceso a datos. Los DAOs:

1. **Separan responsabilidades**: La lógica de negocio (servlets) no conoce detalles de SQL.
2. **Centralizan consultas**: Todas las operaciones CRUD están en un solo lugar.
3. **Facilitan el mantenimiento**: Los cambios en la base solo afectan a los DAOs.
4. **Mejoran testabilidad**: Es fácil crear mocks para pruebas unitarias.

**Ejemplo (`CitaDAO.java`)**:
```java
public class CitaDAO extends BaseDAO {
    
    public boolean crear(Cita cita) {
        String sql = "INSERT INTO citas (usuario_id, servicio_id, fecha_cita, ...) VALUES (?, ?, ?, ...)";
        // Lógica de inserción
    }
    
    public List<Cita> listarTodas() {
        String sql = "SELECT * FROM citas ORDER BY fecha_solicitud DESC";
        // Lógica de consulta
    }
}
```

---

### ¿Cómo funciona el patrón MVC en este proyecto?

El patrón **MVC (Modelo-Vista-Controlador)** divide la aplicación en tres capas:

1. **Modelo** (`com.taller2.model`): POJOs que representan entidades (Usuario, Cita, Servicio, Comentario). No contienen lógica de negocio, solo getters/setters.

2. **Vista** (JSP en `/WEB-INF/views`): Genera HTML dinámico. Recibe datos del controlador y los renderiza.

3. **Controlador** (`com.taller2.controller`): Servlets que procesan requests, invocan DAOs, preparan datos y redirigen a la vista apropiada.

**Flujo típico**:
```
Usuario hace clic → Servlet (Controlador) → DAO accede a BD → 
Servlet prepara datos → Envía a JSP (Vista) → JSP genera HTML → Usuario ve resultado
```

**Ventajas**:
- Separación de responsabilidades clara.
- Código más mantenible y testeable.
- Facilita el trabajo en equipo (diferentes personas pueden trabajar en cada capa).

---

### ¿Cómo se manejan las sesiones?

Se utiliza `HttpSession` de Jakarta Servlet:

1. **Login exitoso**: Se crea una sesión y se almacenan datos del usuario.
   ```java
   HttpSession session = request.getSession();
   session.setAttribute("usuarioId", usuario.getId());
   session.setAttribute("usuario", usuario.getNombre());
   session.setAttribute("rol", usuario.getRol());
   ```

2. **Verificación en páginas protegidas**:
   ```java
   HttpSession session = request.getSession(false);
   if (session == null || session.getAttribute("usuarioId") == null) {
       response.sendRedirect("/login");
       return;
   }
   ```

3. **Logout**: Se invalida la sesión.
   ```java
   session.invalidate();
   ```

**Ventajas**: 
- Simple y nativo de Java EE.
- El servidor gestiona automáticamente cookies (JSESSIONID).
- Los datos de sesión están en memoria del servidor (seguros).

---

### ¿Cómo se validan los datos?

El sistema implementa **validación en dos capas**:

#### Validación en Cliente (Frontend)
- **HTML5**: Atributos `required`, `type="email"`, `type="date"`, `min`, `max`.
- **JavaScript**: Validaciones personalizadas (ej: formato de RUT chileno).

```javascript
function checkRut(rutInput) {
    let valor = rutInput.value.replace(/[^0-9kK]/g, '');
    // Formatea automáticamente: 12.345.678-9
}
```

#### Validación en Servidor (Backend)
- **Verificación de campos obligatorios**: Null checks y trim().
- **Formato de datos**: Parsing de fechas, números, validación de email.
- **Lógica de negocio**: Verificar que el servicio existe, que la fecha no sea pasada, etc.

```java
if (nombre == null || nombre.trim().isEmpty()) {
    request.setAttribute("error", "El nombre es obligatorio");
    return;
}

try {
    cita.setFechaCita(Date.valueOf(fechaStr));
} catch (IllegalArgumentException e) {
    request.setAttribute("error", "Fecha inválida");
    return;
}
```

**¿Por qué validar en ambos lados?**
- **Cliente**: Mejora UX con feedback inmediato.
- **Servidor**: Seguridad (el cliente puede modificarse fácilmente).

---

### ¿Cómo se gestionan los permisos de usuario?

El sistema tiene dos roles: **CLIENTE** y **ADMIN**.

**Verificación en servlets**:
```java
String rol = (String) session.getAttribute("rol");
if (!"ADMIN".equals(rol)) {
    response.sendError(HttpServletResponse.SC_FORBIDDEN, "Acceso denegado");
    return;
}
```

**Ocultación de elementos en JSPs**:
```jsp
<% if ("ADMIN".equals(session.getAttribute("rol"))) { %>
    <a href="/panel">Panel de Gestión</a>
<% } %>
```

**Rutas protegidas**:
- `/panel*`: Solo administradores.
- `/pedirCita`: Solo usuarios autenticados (no invitados).
- `/inicio`, `/servicios`: Públicas para todos.

---

## 8. Notas de Desarrollo

### Cambios Recientes (Noviembre 2025)

- **Refactorización de terminología**: La tabla y todos los conceptos "Turno" han sido migrados a "Cita" en todo el sistema (código, base de datos, documentación) para mayor claridad y profesionalismo.

- **Implementación de validación de RUT chileno**: Se agregó la clase `RutValidator.java` con el algoritmo estándar de módulo 11 para validar RUTs chilenos. Incluye soporte para RUTs de prueba (11111111-1, 22222222-2, 33333333-3, 44444444-4).

- **Actualización de estados de citas**: La tabla `citas` ahora soporta 6 estados diferentes: PENDIENTE, APROBADA, RECHAZADA, CONFIRMADO, CANCELADO, COMPLETADO. Esto permite un seguimiento más detallado del ciclo de vida de cada cita.

- **Eliminación de dependencias CDN**: Se removieron todas las referencias a Cloudflare CDN (Font Awesome) para evitar dependencias externas y mejorar el rendimiento offline.

- **Cambio de nomenclatura UI**: Toda la interfaz ahora usa "Solicitar Cita" en lugar de "Pedir Cita" para un lenguaje más profesional.

- **Logs de depuración**: Se implementaron logs exhaustivos en `PedirCitaServlet` y `CitaDAO` para facilitar el diagnóstico de problemas de persistencia.

### Características Implementadas

- La gestión de servicios es totalmente dinámica, permitiendo agregar, editar y desactivar tratamientos desde el panel de administración.
- El sistema incluye validaciones robustas en cliente y servidor para garantizar la integridad de los datos.
- Todas las contraseñas se almacenan en formato hash para seguridad.
- El diseño responsive garantiza funcionamiento en dispositivos móviles, tablets y escritorio.
- Sistema de drag & drop para carga de imágenes en el panel administrativo.
- Pre-selección automática de servicios al navegar desde la página de servicios al formulario de citas.

### Base de Datos

- **Motor**: PostgreSQL 15
- **Nombre**: taller2_bd
- **Encoding**: UTF-8
- **Scripts disponibles**: 
  - `src/main/resources/database/create_database.sql` (creación completa con datos iniciales)
  - `src/main/resources/database/schema.sql` (solo esquema)

---

## 9. Estructura de Directorios

```
Taller2/
├── src/
│   ├── main/
│   │   ├── java/com/taller2/
│   │   │   ├── controller/              # Servlets (Controladores MVC)
│   │   │   │   ├── ComentarioServlet.java
│   │   │   │   ├── HealthServlet.java
│   │   │   │   ├── HomeController.java
│   │   │   │   ├── LoginServlet.java
│   │   │   │   ├── LogoutServlet.java
│   │   │   │   ├── PagesController.java
│   │   │   │   ├── PanelAccionServlet.java
│   │   │   │   ├── PanelGestionServlet.java
│   │   │   │   ├── PedirCitaServlet.java  # Gestión de solicitudes de citas
│   │   │   │   ├── RecuperarContrasenaServlet.java
│   │   │   │   └── RegistroServlet.java
│   │   │   ├── dao/                     # Acceso a datos (Data Access Objects)
│   │   │   │   ├── BaseDAO.java
│   │   │   │   ├── CitaDAO.java         # CRUD de citas
│   │   │   │   ├── ComentarioDAO.java
│   │   │   │   ├── TurnoDAO.java        # (Deprecated - migrado a CitaDAO)
│   │   │   │   └── UsuarioDAO.java
│   │   │   ├── model/                   # Entidades (POJOs)
│   │   │   │   ├── Cita.java            # Modelo de cita
│   │   │   │   ├── Comentario.java
│   │   │   │   ├── Turno.java           # (Deprecated - migrado a Cita)
│   │   │   │   └── Usuario.java
│   │   │   └── util/                    # Utilidades
│   │   │       ├── DatabaseConnection.java  # Singleton para conexión BD
│   │   │       └── RutValidator.java    # Validador de RUT chileno (Módulo 11)
│   │   ├── resources/
│   │   │   └── database/                # Scripts SQL
│   │   │       ├── create_database.sql  # Creación completa con datos iniciales
│   │   │       └── schema.sql           # Solo esquema de tablas
│   │   └── webapp/
│   │       ├── WEB-INF/
│   │       │   ├── views/               # JSPs (Vistas MVC)
│   │       │   │   ├── contacto.jsp
│   │       │   │   ├── equipo.jsp
│   │       │   │   ├── home.jsp
│   │       │   │   ├── inicio.jsp
│   │       │   │   ├── login.jsp
│   │       │   │   ├── panel.jsp        # Panel administrativo
│   │       │   │   ├── pedirCita.jsp    # Formulario de solicitud de citas
│   │       │   │   ├── recuperar.jsp
│   │       │   │   ├── registro.jsp
│   │       │   │   └── servicios.jsp    # Catálogo de servicios
│   │       │   ├── web.xml              # Descriptor de despliegue Jakarta EE
│   │       │   └── glassfish-web.xml    # Configuración específica GlassFish
│   │       ├── img/                     # Imágenes (servicios, logos)
│   │       │   ├── Blanqueamiento.jpg
│   │       │   ├── Endodoncia.png
│   │       │   ├── Implantes.jpg
│   │       │   ├── images.jpg
│   │       │   ├── Ortodoncia.jpg
│   │       │   └── Periodoncia.jpg
│   │       └── index.jsp                # Página de entrada
├── target/                              # Compilados (generado por Maven)
│   └── taller2.war                      # Archivo desplegable
├── pom.xml                              # Configuración Maven (dependencias, plugins)
├── desplegar.sh                         # Script bash de despliegue automático
├── ARQUITECTURA.md                      # Diagrama de arquitectura del sistema
├── DOCUMENTACION_TECNICA.md             # Este archivo
├── GUIA_RAPIDA.md                       # Guía de uso rápido para usuarios finales
└── SISTEMA_AUTH.md                      # Documentación del sistema de autenticación
```

### Archivos Clave

- **pom.xml**: Define dependencias (PostgreSQL JDBC, Jakarta EE, GlassFish)
- **web.xml**: Configuración de servlets, filtros, páginas de error
- **glassfish-web.xml**: Context root `/taller2`
- **DatabaseConnection.java**: Patrón Singleton, URL: `jdbc:postgresql://localhost:5432/taller2_bd`
- **RutValidator.java**: Validación de RUT con algoritmo módulo 11

---

## Apéndice: FAQ Técnico


### ¿Cómo funciona el patrón Singleton en DatabaseConnection?

```java
public class DatabaseConnection {
    private static DatabaseConnection instance;
    
    private DatabaseConnection() {} // Constructor privado
    
    public static synchronized DatabaseConnection getInstance() {
        if (instance == null) {
            instance = new DatabaseConnection();
        }
        return instance;
    }
}
```

Solo puede existir una instancia de la clase, garantizando un punto único de acceso a la conexión de BD.

### ¿Qué es un PreparedStatement y por qué es importante?

`PreparedStatement` es una interfaz JDBC que previene inyecciones SQL al separar la estructura de la consulta de los datos:

```java
// ❌ Vulnerable a SQL Injection
String sql = "SELECT * FROM usuarios WHERE email = '" + email + "'";

// ✅ Seguro con PreparedStatement
String sql = "SELECT * FROM usuarios WHERE email = ?";
PreparedStatement stmt = conn.prepareStatement(sql);
stmt.setString(1, email);
```

Los parámetros son escapados automáticamente, previniendo ataques.

### ¿Cómo extender el sistema para agregar una nueva entidad?

1. Crear POJO en `model/` (ej: `Pago.java`)
2. Crear tabla en PostgreSQL
3. Crear DAO en `dao/` extendiendo `BaseDAO`
4. Crear servlet en `controller/` para manejar operaciones CRUD
5. Crear JSP en `views/` para la interfaz
6. Registrar servlet en `web.xml` si es necesario

---

*Este documento es una guía viva que se actualiza con cada cambio significativo en el proyecto.*
