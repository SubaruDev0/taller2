<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ page import="java.util.List" %>
        <%@ page import="com.taller2.model.Usuario" %>
            <%@ page import="com.taller2.model.Cita" %>
                <%@ page import="com.taller2.model.Comentario" %>
                    <%@ page import="com.taller2.model.Servicio" %>
                        <!DOCTYPE html>
                        <html lang="es">

                        <head>
                            <meta charset="UTF-8">
                            <meta name="viewport" content="width=device-width, initial-scale=1.0">
                            <title>Panel de Gestión - Clínica Dental</title>
                            <style>
                                :root {
                                    --azul-principal: #0fa49c;
                                    --azul-claro: #087872;
                                    --color-secundario: #ffca1c;
                                    --fondo-claro: #f0f9f8;
                                    --fondo-tarjeta: #ffffff;
                                    --color-fuente: #333333;
                                    --color-hover: #0d8c85
                                }

                                * {
                                    margin: 0;
                                    padding: 0;
                                    box-sizing: border-box;
                                    font-family: "Segoe UI", sans-serif
                                }

                                body {
                                    background-color: var(--fondo-claro);
                                    color: var(--color-fuente)
                                }

                                header {
                                    display: flex;
                                    justify-content: space-between;
                                    align-items: center;
                                    padding: 15px 40px;
                                    background: var(--azul-principal);
                                    color: #fff;
                                    height: 120px;
                                    box-shadow: 0 2px 10px rgba(0, 0, 0, .1)
                                }

                                .logo img {
                                    width: 300px;
                                    height: auto
                                }

                                nav ul {
                                    display: flex;
                                    list-style: none;
                                    gap: 25px
                                }

                                nav ul li a {
                                    color: #fff;
                                    text-decoration: none;
                                    font-size: 1.1rem;
                                    font-weight: 600;
                                    transition: color .3s
                                }

                                nav ul li a:hover {
                                    color: var(--color-secundario)
                                }

                                .container {
                                    max-width: 1400px;
                                    margin: 40px auto;
                                    padding: 0 20px
                                }

                                .panel-header {
                                    text-align: center;
                                    margin-bottom: 40px
                                }

                                .panel-header h1 {
                                    font-size: 2.5rem;
                                    color: var(--azul-principal);
                                    margin-bottom: 10px
                                }

                                .panel-header p {
                                    font-size: 1.1rem;
                                    color: #666
                                }

                                .panel-grid {
                                    display: grid;
                                    grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
                                    gap: 30px;
                                    margin-bottom: 50px
                                }

                                .panel-card {
                                    background: var(--fondo-tarjeta);
                                    border-radius: 15px;
                                    padding: 30px;
                                    box-shadow: 0 4px 15px rgba(0, 0, 0, .1);
                                    transition: transform .3s, box-shadow .3s;
                                    cursor: pointer
                                }

                                .panel-card:hover {
                                    transform: translateY(-5px);
                                    box-shadow: 0 8px 25px rgba(0, 0, 0, .15)
                                }

                                .panel-card i {
                                    font-size: 3rem;
                                    color: var(--azul-principal);
                                    margin-bottom: 20px
                                }

                                .panel-card h3 {
                                    font-size: 1.5rem;
                                    color: var(--azul-principal);
                                    margin-bottom: 10px
                                }

                                .panel-card p {
                                    color: #666;
                                    line-height: 1.6
                                }

                                .tabla-section {
                                    background: var(--fondo-tarjeta);
                                    border-radius: 15px;
                                    padding: 30px;
                                    box-shadow: 0 4px 15px rgba(0, 0, 0, .1);
                                    margin-bottom: 30px
                                }

                                .tabla-section h2 {
                                    font-size: 2rem;
                                    color: var(--azul-principal);
                                    margin-bottom: 20px;
                                    padding-bottom: 15px;
                                    border-bottom: 2px solid var(--azul-principal)
                                }

                                table {
                                    width: 100%;
                                    border-collapse: collapse;
                                    margin-top: 20px
                                }

                                thead {
                                    background: var(--azul-principal);
                                    color: #fff
                                }

                                thead th {
                                    padding: 15px;
                                    text-align: left;
                                    font-weight: 600
                                }

                                tbody tr {
                                    border-bottom: 1px solid #e0e0e0;
                                    transition: background .3s
                                }

                                tbody tr:hover {
                                    background: var(--fondo-claro)
                                }

                                tbody td {
                                    padding: 12px 15px
                                }

                                .badge {
                                    display: inline-block;
                                    padding: 5px 12px;
                                    border-radius: 20px;
                                    font-size: .85rem;
                                    font-weight: 600
                                }

                                .badge-admin {
                                    background: #ff9800;
                                    color: #fff
                                }

                                .badge-usuario {
                                    background: #4caf50;
                                    color: #fff
                                }

                                .badge-activo {
                                    background: #4caf50;
                                    color: #fff
                                }

                                .badge-inactivo {
                                    background: #f44336;
                                    color: #fff
                                }

                                .badge-pendiente {
                                    background: #ff9800;
                                    color: #fff
                                }

                                .badge-confirmado {
                                    background: #4caf50;
                                    color: #fff
                                }

                                .badge-cancelado {
                                    background: #f44336;
                                    color: #fff
                                }

                                .badge-completado {
                                    background: #2196f3;
                                    color: #fff
                                }

                                .btn-accion {
                                    padding: 6px 12px;
                                    border: none;
                                    border-radius: 5px;
                                    cursor: pointer;
                                    font-size: .85rem;
                                    font-weight: 600;
                                    margin: 2px;
                                    transition: opacity .3s
                                }

                                .btn-aprobar {
                                    background: #4caf50;
                                    color: #fff
                                }

                                .btn-rechazar {
                                    background: #ff9800;
                                    color: #fff
                                }

                                .btn-eliminar {
                                    background: #f44336;
                                    color: #fff
                                }

                                .btn-accion:hover {
                                    opacity: .8
                                }

                                .acciones {
                                    display: flex;
                                    gap: 5px;
                                    flex-wrap: wrap
                                }

                                footer {
                                    background: var(--azul-principal);
                                    color: #fff;
                                    padding: 30px 40px;
                                    margin-top: 60px;
                                    text-align: center
                                }

                                footer p {
                                    margin: 0;
                                    font-size: 1rem
                                }

                                @media(max-width:768px) {
                                    header {
                                        flex-direction: column;
                                        height: auto;
                                        padding: 15px
                                    }

                                    nav ul {
                                        flex-wrap: wrap;
                                        gap: 15px;
                                        justify-content: center
                                    }

                                    .panel-grid {
                                        grid-template-columns: 1fr
                                    }

                                    .tabla-section {
                                        overflow-x: auto
                                    }

                                    table {
                                        font-size: .9rem
                                    }

                                    tbody td {
                                        padding: 8px 10px
                                    }
                                }
                            </style>
                        </head>

                        <body>
                            <header>
                                <div class="logo">
                                    <img src="${pageContext.request.contextPath}/img/logo.png"
                                        alt="Clínica Dental Logo">
                                </div>
                                <nav>
                                    <ul>
                                        <li><a href="${pageContext.request.contextPath}/inicio">Inicio</a></li>
                                        <li><a href="${pageContext.request.contextPath}/servicios">Servicios</a></li>
                                        <li><a href="${pageContext.request.contextPath}/equipo">Equipo</a></li>
                                        <li><a href="${pageContext.request.contextPath}/contacto">Contacto</a></li>
                                        <li><a href="${pageContext.request.contextPath}/panel" class="active">Panel de
                                                Gestión</a></li>
                                        <li><a href="${pageContext.request.contextPath}/logout">Cerrar Sesión (<%=
                                                    session.getAttribute("usuario") %>)</a></li>
                                    </ul>
                                </nav>
                            </header>

                            <div class="container">
                                <div class="panel-header">
                                    <h1><i class="fas fa-cogs"></i> Panel de Gestión</h1>
                                    <p>Bienvenido, <strong>
                                            <%= session.getAttribute("nombreUsuario") %>
                                        </strong> - Administrador</p>
                                </div>

                                <div class="panel-grid">
                                    <div class="panel-card" onclick="scrollToSection('usuarios')">
                                        <i class="fas fa-users"></i>
                                        <h3>Gestión de Usuarios</h3>
                                        <p>Administra los usuarios del sistema, roles y permisos</p>
                                    </div>

                                    <div class="panel-card" onclick="scrollToSection('servicios')">
                                        <i class="fas fa-tooth"></i>
                                        <h3>Gestión de Servicios</h3>
                                        <p>Edita, agrega o elimina servicios dentales</p>
                                    </div>

                                    <div class="panel-card" onclick="scrollToSection('citas')">
                                        <i class="fas fa-calendar-alt"></i>
                                        <h3>Gestión de Citas</h3>
                                        <p>Visualiza y gestiona las citas programadas</p>
                                    </div>

                                    <div class="panel-card" onclick="scrollToSection('comentarios')">
                                        <i class="fas fa-comments"></i>
                                        <h3>Gestión de Comentarios</h3>
                                        <p>Modera y aprueba comentarios de pacientes</p>
                                    </div>
                                </div>

                                <!-- Tabla de Usuarios -->
                                <div class="tabla-section" id="usuarios">
                                    <h2><i class="fas fa-users"></i> Usuarios del Sistema</h2>
                                    <table>
                                        <thead>
                                            <tr>
                                                <th>ID</th>
                                                <th>Usuario</th>
                                                <th>Nombre Completo</th>
                                                <th>Email</th>
                                                <th>Rol</th>
                                                <th>Estado</th>
                                                <th>Fecha Creación</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <% List<Usuario> usuarios = (List<Usuario>)
                                                    request.getAttribute("usuarios");
                                                    if (usuarios != null && !usuarios.isEmpty()) {
                                                    for (Usuario u : usuarios) {
                                                    %>
                                                    <tr>
                                                        <td>
                                                            <%= u.getId() %>
                                                        </td>
                                                        <td><strong>
                                                                <%= u.getUsuario() %>
                                                            </strong></td>
                                                        <td>
                                                            <%= u.getNombreCompleto() !=null ? u.getNombreCompleto()
                                                                : "-" %>
                                                        </td>
                                                        <td>
                                                            <%= u.getEmail() !=null ? u.getEmail() : "-" %>
                                                        </td>
                                                        <td><span class="badge <%= u.esAdmin() ? " badge-admin"
                                                                : "badge-usuario" %>"><%= u.getRol() %></span></td>
                                                        <td><span class="badge <%= u.isActivo() ? " badge-activo"
                                                                : "badge-inactivo" %>"><%= u.isActivo() ? "ACTIVO"
                                                                    : "INACTIVO" %></span></td>
                                                        <td>
                                                            <%= u.getFechaCreacion() !=null ?
                                                                u.getFechaCreacion().toString().substring(0, 16) : "-"
                                                                %>
                                                        </td>
                                                    </tr>
                                                    <% } } else { %>
                                                        <tr>
                                                            <td colspan="7"
                                                                style="text-align:center;padding:30px;color:#999;">No
                                                                hay usuarios registrados</td>
                                                        </tr>
                                                        <% } %>
                                        </tbody>
                                    </table>
                                </div>

                                <!-- Sección de Servicios -->
                                <div class="tabla-section" id="servicios">
                                    <h2><i class="fas fa-tooth"></i> Servicios Dentales</h2>

                                    <!-- Formulario para agregar/editar servicio -->
                                    <div
                                        style="background:#f9f9f9; padding:20px; border-radius:10px; margin-bottom:20px;">
                                        <h3>Agregar / Editar Servicio</h3>
                                        <form action="${pageContext.request.contextPath}/admin/servicio" method="POST">
                                            <input type="hidden" name="accion" value="crear" id="formServicioAccion">
                                            <input type="hidden" name="id" id="servicioId">

                                            <div
                                                style="display:grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap:15px;">
                                                <div>
                                                    <label
                                                        style="display:block;margin-bottom:5px;font-weight:600;">Nombre:</label>
                                                    <input type="text" name="nombre" id="servicioNombre" required
                                                        style="width:100%; padding:8px; border:1px solid #ddd; border-radius:4px;">
                                                </div>
                                                <div>
                                                    <label
                                                        style="display:block;margin-bottom:5px;font-weight:600;">Precio:</label>
                                                    <input type="number" name="precio" id="servicioPrecio"
                                                        style="width:100%; padding:8px; border:1px solid #ddd; border-radius:4px;">
                                                </div>
                                                <div style="grid-column: 1/-1;">
                                                    <label
                                                        style="display:block;margin-bottom:5px;font-weight:600;">Imagen:</label>
                                                    <input type="hidden" name="imagen" id="servicioImagen">
                                                    <div id="dropZone"
                                                        style="border:2px dashed #0fa49c; border-radius:8px; padding:30px; text-align:center; background:#f0f9f8; cursor:pointer; transition:all 0.3s;">
                                                        <i class="fas fa-cloud-upload-alt"
                                                            style="font-size:3rem; color:#0fa49c; margin-bottom:10px;"></i>
                                                        <p style="margin:10px 0; font-weight:600; color:#0fa49c;">
                                                            Arrastra una imagen aquí o haz clic para seleccionar</p>
                                                        <p style="font-size:0.85rem; color:#666;">Formatos: JPG, PNG,
                                                            GIF, WEBP (máx. 10MB)</p>
                                                        <input type="file" id="fileInput" accept="image/*"
                                                            style="display:none;">
                                                        <div id="imagePreview" style="margin-top:15px; display:none;">
                                                            <img id="previewImg" src="" alt="Preview"
                                                                style="max-width:200px; max-height:200px; border-radius:8px; box-shadow:0 2px 8px rgba(0,0,0,0.1);">
                                                            <p id="fileName"
                                                                style="margin-top:10px; font-weight:600; color:#333;">
                                                            </p>
                                                        </div>
                                                    </div>
                                                </div>
                                                <div>
                                                    <label
                                                        style="display:block;margin-bottom:5px;font-weight:600;">Duración
                                                        (min):</label>
                                                    <input type="number" name="duracion" id="servicioDuracion"
                                                        style="width:100%; padding:8px; border:1px solid #ddd; border-radius:4px;">
                                                </div>
                                                <div style="grid-column: 1/-1;">
                                                    <label
                                                        style="display:block;margin-bottom:5px;font-weight:600;">Descripción:</label>
                                                    <textarea name="descripcion" id="servicioDescripcion" rows="2"
                                                        style="width:100%; padding:8px; border:1px solid #ddd; border-radius:4px;"></textarea>
                                                </div>
                                                <div>
                                                    <label style="cursor:pointer;"><input type="checkbox" name="activo"
                                                            id="servicioActivo" checked> Activo</label>
                                                </div>
                                            </div>
                                            <div style="margin-top:15px;">
                                                <button type="submit" class="btn-accion btn-aprobar"
                                                    style="padding:10px 20px; font-size:1rem;">Guardar</button>
                                                <button type="button" class="btn-accion btn-rechazar"
                                                    style="padding:10px 20px; font-size:1rem;"
                                                    onclick="limpiarFormServicio()">Limpiar</button>
                                            </div>
                                        </form>
                                    </div>

                                    <table>
                                        <thead>
                                            <tr>
                                                <th>ID</th>
                                                <th>Nombre</th>
                                                <th>Precio</th>
                                                <th>Estado</th>
                                                <th>Acciones</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <% List<Servicio> servicios = (List<Servicio>)
                                                    request.getAttribute("servicios");
                                                    if (servicios != null && !servicios.isEmpty()) {
                                                    for (Servicio s : servicios) {
                                                    %>
                                                    <tr>
                                                        <td>
                                                            <%= s.getId() %>
                                                        </td>
                                                        <td><strong>
                                                                <%= s.getNombre() %>
                                                            </strong></td>
                                                        <td>$<%= s.getPrecio() !=null ? String.format("%,.0f",
                                                                s.getPrecio()) : "0" %>
                                                        </td>
                                                        <td><span class="badge <%= s.isActivo() ? " badge-activo"
                                                                : "badge-inactivo" %>"><%= s.isActivo() ? "ACTIVO"
                                                                    : "INACTIVO" %></span></td>
                                                        <td class="acciones">
                                                            <button type="button" class="btn-accion btn-aprobar"
                                                                onclick="editarServicio('<%= s.getId() %>', '<%= s.getNombre() %>', '<%= s.getPrecio() %>', '<%= s.getImagen() %>', '<%= s.getDuracionMinutos() %>', '<%= s.getDescripcion() %>', <%= s.isActivo() %>)">✏
                                                                Editar</button>

                                                            <form method="POST"
                                                                action="${pageContext.request.contextPath}/panel/accion"
                                                                style="display:inline;">
                                                                <input type="hidden" name="tipo" value="servicio">
                                                                <input type="hidden" name="id" value="<%= s.getId() %>">
                                                                <input type="hidden" name="accion" value="eliminar">
                                                                <button type="submit" class="btn-accion btn-eliminar"
                                                                    onclick="return confirm('¿Eliminar este servicio?')">🗑
                                                                    Eliminar</button>
                                                            </form>
                                                        </td>
                                                    </tr>
                                                    <% } } else { %>
                                                        <tr>
                                                            <td colspan="5"
                                                                style="text-align:center;padding:30px;color:#999;">No
                                                                hay servicios registrados</td>
                                                        </tr>
                                                        <% } %>
                                        </tbody>
                                    </table>
                                </div>

                                <!-- Sección de Citas -->
                                <div class="tabla-section" id="citas">
                                    <h2><i class="fas fa-calendar-alt"></i> Citas Programadas</h2>
                                    <table>
                                        <thead>
                                            <tr>
                                                <th>ID</th>
                                                <th>Paciente</th>
                                                <th>RUT</th>
                                                <th>Fecha</th>
                                                <th>Hora</th>
                                                <th>Teléfono</th>
                                                <th>Email</th>
                                                <th>Estado</th>
                                                <th>Acciones</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <% List<Cita> citas = (List<Cita>) request.getAttribute("citas");
                                                    if (citas != null && !citas.isEmpty()) {
                                                    for (Cita t : citas) {
                                                    %>
                                                    <tr>
                                                        <td>
                                                            <%= t.getId() %>
                                                        </td>
                                                        <td><strong>
                                                                <%= t.getNombrePaciente() %>
                                                            </strong></td>
                                                        <td>
                                                            <%= t.getRut() %>
                                                        </td>
                                                        <td>
                                                            <%= t.getFechaCita() %>
                                                        </td>
                                                        <td>
                                                            <%= t.getHoraCita() !=null ?
                                                                t.getHoraCita().toString().substring(0, 5) : "-" %>
                                                        </td>
                                                        <td>
                                                            <%= t.getTelefono() %>
                                                        </td>
                                                        <td>
                                                            <%= t.getEmail() %>
                                                        </td>
                                                        <td>
                                                            <span
                                                                class="badge badge-<%= t.getEstado().toLowerCase() %>">
                                                                <%= t.getEstado() %>
                                                            </span>
                                                        </td>
                                                        <td class="acciones">
                                                            <% if ("PENDIENTE".equals(t.getEstado())) { %>
                                                                <form method="POST"
                                                                    action="${pageContext.request.contextPath}/panel/accion"
                                                                    style="display:inline;">
                                                                    <input type="hidden" name="tipo" value="cita">
                                                                    <input type="hidden" name="id"
                                                                        value="<%= t.getId() %>">
                                                                    <input type="hidden" name="accion" value="aprobar">
                                                                    <button type="submit"
                                                                        class="btn-accion btn-aprobar">✓
                                                                        Aprobar</button>
                                                                </form>
                                                                <form method="POST"
                                                                    action="${pageContext.request.contextPath}/panel/accion"
                                                                    style="display:inline;">
                                                                    <input type="hidden" name="tipo" value="cita">
                                                                    <input type="hidden" name="id"
                                                                        value="<%= t.getId() %>">
                                                                    <input type="hidden" name="accion" value="rechazar">
                                                                    <button type="submit"
                                                                        class="btn-accion btn-rechazar">✗
                                                                        Rechazar</button>
                                                                </form>
                                                                <% } %>
                                                                    <form method="POST"
                                                                        action="${pageContext.request.contextPath}/panel/accion"
                                                                        style="display:inline;">
                                                                        <input type="hidden" name="tipo" value="cita">
                                                                        <input type="hidden" name="id"
                                                                            value="<%= t.getId() %>">
                                                                        <input type="hidden" name="accion"
                                                                            value="eliminar">
                                                                        <button type="submit"
                                                                            class="btn-accion btn-eliminar"
                                                                            onclick="return confirm('¿Eliminar esta cita?')">🗑
                                                                            Eliminar</button>
                                                                    </form>
                                                        </td>
                                                    </tr>
                                                    <% } } else { %>
                                                        <tr>
                                                            <td colspan="9"
                                                                style="text-align:center;padding:30px;color:#999;">No
                                                                hay citas registradas</td>
                                                        </tr>
                                                        <% } %>
                                        </tbody>
                                    </table>
                                </div>

                                <!-- Sección de Comentarios -->
                                <div class="tabla-section" id="comentarios">
                                    <h2><i class="fas fa-comments"></i> Comentarios de Pacientes</h2>
                                    <table>
                                        <thead>
                                            <tr>
                                                <th>ID</th>
                                                <th>Nombre</th>
                                                <th>Comentario</th>
                                                <th>Calificación</th>
                                                <th>Fecha</th>
                                                <th>Estado</th>
                                                <th>Acciones</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <% List<Comentario> comentarios = (List<Comentario>)
                                                    request.getAttribute("comentarios");
                                                    if (comentarios != null && !comentarios.isEmpty()) {
                                                    for (Comentario c : comentarios) {
                                                    %>
                                                    <tr>
                                                        <td>
                                                            <%= c.getId() %>
                                                        </td>
                                                        <td><strong>
                                                                <%= c.getNombre() %>
                                                            </strong></td>
                                                        <td style="max-width:300px;">
                                                            <%= c.getComentario() %>
                                                        </td>
                                                        <td>
                                                            <% if (c.getCalificacion() !=null) { for (int i=0; i <
                                                                c.getCalificacion(); i++) { %>⭐<% } } else { %>-<% } %>
                                                        </td>
                                                        <td>
                                                            <%= c.getFechaCreacion() !=null ?
                                                                c.getFechaCreacion().toString().substring(0, 16) : "-"
                                                                %>
                                                        </td>
                                                        <td>
                                                            <span class="badge <%= c.isAprobado() ? " badge-activo"
                                                                : "badge-pendiente" %>">
                                                                <%= c.isAprobado() ? "APROBADO" : "PENDIENTE" %>
                                                            </span>
                                                        </td>
                                                        <td class="acciones">
                                                            <% if (!c.isAprobado()) { %>
                                                                <form method="POST"
                                                                    action="${pageContext.request.contextPath}/panel/accion"
                                                                    style="display:inline;">
                                                                    <input type="hidden" name="tipo" value="comentario">
                                                                    <input type="hidden" name="id"
                                                                        value="<%= c.getId() %>">
                                                                    <input type="hidden" name="accion" value="aprobar">
                                                                    <button type="submit"
                                                                        class="btn-accion btn-aprobar">✓
                                                                        Aprobar</button>
                                                                </form>
                                                                <% } %>
                                                                    <form method="POST"
                                                                        action="${pageContext.request.contextPath}/panel/accion"
                                                                        style="display:inline;">
                                                                        <input type="hidden" name="tipo"
                                                                            value="comentario">
                                                                        <input type="hidden" name="id"
                                                                            value="<%= c.getId() %>">
                                                                        <input type="hidden" name="accion"
                                                                            value="eliminar">
                                                                        <button type="submit"
                                                                            class="btn-accion btn-eliminar"
                                                                            onclick="return confirm('¿Eliminar este comentario?')">🗑
                                                                            Eliminar</button>
                                                                    </form>
                                                        </td>
                                                    </tr>
                                                    <% } } else { %>
                                                        <tr>
                                                            <td colspan="7"
                                                                style="text-align:center;padding:30px;color:#999;">No
                                                                hay comentarios registrados</td>
                                                        </tr>
                                                        <% } %>
                                        </tbody>
                                    </table>
                                </div>
                            </div>

                            <footer>
                                <p>&copy; 2024 Clínica Dental. Todos los derechos reservados.</p>
                            </footer>

                            <script>
                                function scrollToSection(e) { document.getElementById(e).scrollIntoView({ behavior: "smooth", block: "start" }) }

                                function editarServicio(id, nombre, precio, imagen, duracion, descripcion, activo) {
                                    document.getElementById('formServicioAccion').value = 'editar';
                                    document.getElementById('servicioId').value = id;
                                    document.getElementById('servicioNombre').value = nombre;
                                    document.getElementById('servicioPrecio').value = precio;
                                    document.getElementById('servicioImagen').value = imagen;
                                    document.getElementById('servicioDuracion').value = duracion;
                                    document.getElementById('servicioDescripcion').value = descripcion;
                                    document.getElementById('servicioActivo').checked = activo;

                                    // Scroll to form
                                    document.getElementById('servicios').scrollIntoView({ behavior: 'smooth' });
                                }

                                function limpiarFormServicio() {
                                    document.getElementById('formServicioAccion').value = 'crear';
                                    document.getElementById('servicioId').value = '';
                                    document.getElementById('servicioNombre').value = '';
                                    document.getElementById('servicioPrecio').value = '';
                                    document.getElementById('servicioImagen').value = '';
                                    document.getElementById('servicioDuracion').value = '';
                                    document.getElementById('servicioDescripcion').value = '';
                                    document.getElementById('servicioActivo').checked = true;

                                    // Limpiar preview de imagen
                                    document.getElementById('imagePreview').style.display = 'none';
                                    document.getElementById('previewImg').src = '';
                                    document.getElementById('fileName').textContent = '';
                                }

                                // Drag and Drop functionality
                                const dropZone = document.getElementById('dropZone');
                                const fileInput = document.getElementById('fileInput');
                                const imagePreview = document.getElementById('imagePreview');
                                const previewImg = document.getElementById('previewImg');
                                const fileName = document.getElementById('fileName');
                                const servicioImagen = document.getElementById('servicioImagen');

                                // Click to select file
                                dropZone.addEventListener('click', () => fileInput.click());

                                // File input change
                                fileInput.addEventListener('change', (e) => {
                                    if (e.target.files.length > 0) {
                                        handleFile(e.target.files[0]);
                                    }
                                });

                                // Drag over
                                dropZone.addEventListener('dragover', (e) => {
                                    e.preventDefault();
                                    dropZone.style.borderColor = '#087872';
                                    dropZone.style.background = '#e0f5f4';
                                });

                                // Drag leave
                                dropZone.addEventListener('dragleave', (e) => {
                                    e.preventDefault();
                                    dropZone.style.borderColor = '#0fa49c';
                                    dropZone.style.background = '#f0f9f8';
                                });

                                // Drop
                                dropZone.addEventListener('drop', (e) => {
                                    e.preventDefault();
                                    dropZone.style.borderColor = '#0fa49c';
                                    dropZone.style.background = '#f0f9f8';

                                    if (e.dataTransfer.files.length > 0) {
                                        handleFile(e.dataTransfer.files[0]);
                                    }
                                });

                                function handleFile(file) {
                                    // Validate file type
                                    if (!file.type.match('image.*')) {
                                        alert('Por favor selecciona una imagen válida');
                                        return;
                                    }

                                    // Validate file size (10MB)
                                    if (file.size > 10 * 1024 * 1024) {
                                        alert('La imagen no debe superar los 10MB');
                                        return;
                                    }

                                    // Show preview
                                    const reader = new FileReader();
                                    reader.onload = (e) => {
                                        previewImg.src = e.target.result;
                                        imagePreview.style.display = 'block';
                                    };
                                    reader.readAsDataURL(file);

                                    // Upload file
                                    uploadImage(file);
                                }

                                function uploadImage(file) {
                                    const formData = new FormData();
                                    formData.append('file', file);

                                    fileName.textContent = 'Subiendo...';

                                    fetch('${pageContext.request.contextPath}/upload/imagen', {
                                        method: 'POST',
                                        body: formData
                                    })
                                        .then(response => response.json())
                                        .then(data => {
                                            if (data.success) {
                                                servicioImagen.value = data.fileName;
                                                fileName.textContent = '✓ ' + data.fileName;
                                                fileName.style.color = '#4caf50';
                                            } else {
                                                alert('Error: ' + data.message);
                                                fileName.textContent = '✗ Error al subir';
                                                fileName.style.color = '#f44336';
                                            }
                                        })
                                        .catch(error => {
                                            console.error('Error:', error);
                                            alert('Error al subir la imagen');
                                            fileName.textContent = '✗ Error al subir';
                                            fileName.style.color = '#f44336';
                                        });
                                }
                            </script>
                        </body>

                        </html>