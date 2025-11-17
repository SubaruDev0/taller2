<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.taller2.model.Usuario" %>
<%@ page import="com.taller2.model.Turno" %>
<%@ page import="com.taller2.model.Comentario" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Panel de Gestión - Clínica Dental</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
:root{--azul-principal:#0fa49c;--azul-claro:#087872;--color-secundario:#ffca1c;--fondo-claro:#f0f9f8;--fondo-tarjeta:#ffffff;--color-fuente:#333333;--color-hover:#0d8c85}*{margin:0;padding:0;box-sizing:border-box;font-family:"Segoe UI",sans-serif}body{background-color:var(--fondo-claro);color:var(--color-fuente)}header{display:flex;justify-content:space-between;align-items:center;padding:15px 40px;background:var(--azul-principal);color:#fff;height:120px;box-shadow:0 2px 10px rgba(0,0,0,.1)}.logo img{width:300px;height:auto}nav ul{display:flex;list-style:none;gap:25px}nav ul li a{color:#fff;text-decoration:none;font-size:1.1rem;font-weight:600;transition:color .3s}nav ul li a:hover{color:var(--color-secundario)}.container{max-width:1400px;margin:40px auto;padding:0 20px}.panel-header{text-align:center;margin-bottom:40px}.panel-header h1{font-size:2.5rem;color:var(--azul-principal);margin-bottom:10px}.panel-header p{font-size:1.1rem;color:#666}.panel-grid{display:grid;grid-template-columns:repeat(auto-fit,minmax(300px,1fr));gap:30px;margin-bottom:50px}.panel-card{background:var(--fondo-tarjeta);border-radius:15px;padding:30px;box-shadow:0 4px 15px rgba(0,0,0,.1);transition:transform .3s,box-shadow .3s;cursor:pointer}.panel-card:hover{transform:translateY(-5px);box-shadow:0 8px 25px rgba(0,0,0,.15)}.panel-card i{font-size:3rem;color:var(--azul-principal);margin-bottom:20px}.panel-card h3{font-size:1.5rem;color:var(--azul-principal);margin-bottom:10px}.panel-card p{color:#666;line-height:1.6}.tabla-section{background:var(--fondo-tarjeta);border-radius:15px;padding:30px;box-shadow:0 4px 15px rgba(0,0,0,.1);margin-bottom:30px}.tabla-section h2{font-size:2rem;color:var(--azul-principal);margin-bottom:20px;padding-bottom:15px;border-bottom:2px solid var(--azul-principal)}table{width:100%;border-collapse:collapse;margin-top:20px}thead{background:var(--azul-principal);color:#fff}thead th{padding:15px;text-align:left;font-weight:600}tbody tr{border-bottom:1px solid #e0e0e0;transition:background .3s}tbody tr:hover{background:var(--fondo-claro)}tbody td{padding:12px 15px}.badge{display:inline-block;padding:5px 12px;border-radius:20px;font-size:.85rem;font-weight:600}.badge-admin{background:#ff9800;color:#fff}.badge-usuario{background:#4caf50;color:#fff}.badge-activo{background:#4caf50;color:#fff}.badge-inactivo{background:#f44336;color:#fff}.badge-pendiente{background:#ff9800;color:#fff}.badge-confirmado{background:#4caf50;color:#fff}.badge-cancelado{background:#f44336;color:#fff}.badge-completado{background:#2196f3;color:#fff}.btn-accion{padding:6px 12px;border:none;border-radius:5px;cursor:pointer;font-size:.85rem;font-weight:600;margin:2px;transition:opacity .3s}.btn-aprobar{background:#4caf50;color:#fff}.btn-rechazar{background:#ff9800;color:#fff}.btn-eliminar{background:#f44336;color:#fff}.btn-accion:hover{opacity:.8}.acciones{display:flex;gap:5px;flex-wrap:wrap}footer{background:var(--azul-principal);color:#fff;padding:30px 40px;margin-top:60px;text-align:center}footer p{margin:0;font-size:1rem}@media(max-width:768px){header{flex-direction:column;height:auto;padding:15px}nav ul{flex-wrap:wrap;gap:15px;justify-content:center}.panel-grid{grid-template-columns:1fr}.tabla-section{overflow-x:auto}table{font-size:.9rem}tbody td{padding:8px 10px}}
    </style>
</head>
<body>
<header>
    <div class="logo">
        <img src="${pageContext.request.contextPath}/img/logo.png" alt="Clínica Dental Logo">
    </div>
    <nav>
        <ul>
            <li><a href="${pageContext.request.contextPath}/inicio">Inicio</a></li>
            <li><a href="${pageContext.request.contextPath}/servicios">Servicios</a></li>
            <li><a href="${pageContext.request.contextPath}/equipo">Equipo</a></li>
            <li><a href="${pageContext.request.contextPath}/contacto">Contacto</a></li>
            <li><a href="${pageContext.request.contextPath}/panel" class="active">Panel de Gestión</a></li>
            <li><a href="${pageContext.request.contextPath}/logout">Cerrar Sesión (<%= session.getAttribute("usuario") %>)</a></li>
        </ul>
    </nav>
</header>

<div class="container">
    <div class="panel-header">
        <h1><i class="fas fa-cogs"></i> Panel de Gestión</h1>
        <p>Bienvenido, <strong><%= session.getAttribute("nombreUsuario") %></strong> - Administrador</p>
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

        <div class="panel-card" onclick="scrollToSection('turnos')">
            <i class="fas fa-calendar-alt"></i>
            <h3>Gestión de Turnos</h3>
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
                <% 
                List<Usuario> usuarios = (List<Usuario>) request.getAttribute("usuarios");
                if (usuarios != null && !usuarios.isEmpty()) {
                    for (Usuario u : usuarios) {
                %>
                <tr>
                    <td><%= u.getId() %></td>
                    <td><strong><%= u.getUsuario() %></strong></td>
                    <td><%= u.getNombreCompleto() != null ? u.getNombreCompleto() : "-" %></td>
                    <td><%= u.getEmail() != null ? u.getEmail() : "-" %></td>
                    <td><span class="badge <%= u.esAdmin() ? "badge-admin" : "badge-usuario" %>"><%= u.getRol() %></span></td>
                    <td><span class="badge <%= u.isActivo() ? "badge-activo" : "badge-inactivo" %>"><%= u.isActivo() ? "ACTIVO" : "INACTIVO" %></span></td>
                    <td><%= u.getFechaCreacion() != null ? u.getFechaCreacion().toString().substring(0, 16) : "-" %></td>
                </tr>
                <%
                    }
                } else {
                %>
                <tr>
                    <td colspan="7" style="text-align:center;padding:30px;color:#999;">No hay usuarios registrados</td>
                </tr>
                <% } %>
            </tbody>
        </table>
    </div>

    <!-- Sección de Servicios (Placeholder) -->
    <div class="tabla-section" id="servicios">
        <h2><i class="fas fa-tooth"></i> Servicios Dentales</h2>
        <p style="color:#666;padding:20px;text-align:center;">
            <i class="fas fa-info-circle"></i> Funcionalidad de gestión de servicios en desarrollo
        </p>
    </div>

    <!-- Sección de Turnos -->
    <div class="tabla-section" id="turnos">
        <h2><i class="fas fa-calendar-alt"></i> Turnos Programados</h2>
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
                <% 
                List<Turno> turnos = (List<Turno>) request.getAttribute("turnos");
                if (turnos != null && !turnos.isEmpty()) {
                    for (Turno t : turnos) {
                %>
                <tr>
                    <td><%= t.getId() %></td>
                    <td><strong><%= t.getNombrePaciente() %></strong></td>
                    <td><%= t.getRut() %></td>
                    <td><%= t.getFechaTurno() %></td>
                    <td><%= t.getHoraTurno() != null ? t.getHoraTurno().toString().substring(0, 5) : "-" %></td>
                    <td><%= t.getTelefono() %></td>
                    <td><%= t.getEmail() %></td>
                    <td>
                        <span class="badge badge-<%= t.getEstado().toLowerCase() %>"><%= t.getEstado() %></span>
                    </td>
                    <td class="acciones">
                        <% if ("PENDIENTE".equals(t.getEstado())) { %>
                            <form method="POST" action="${pageContext.request.contextPath}/panel/accion" style="display:inline;">
                                <input type="hidden" name="tipo" value="turno">
                                <input type="hidden" name="id" value="<%= t.getId() %>">
                                <input type="hidden" name="accion" value="aprobar">
                                <button type="submit" class="btn-accion btn-aprobar">✓ Aprobar</button>
                            </form>
                            <form method="POST" action="${pageContext.request.contextPath}/panel/accion" style="display:inline;">
                                <input type="hidden" name="tipo" value="turno">
                                <input type="hidden" name="id" value="<%= t.getId() %>">
                                <input type="hidden" name="accion" value="rechazar">
                                <button type="submit" class="btn-accion btn-rechazar">✗ Rechazar</button>
                            </form>
                        <% } %>
                        <form method="POST" action="${pageContext.request.contextPath}/panel/accion" style="display:inline;">
                            <input type="hidden" name="tipo" value="turno">
                            <input type="hidden" name="id" value="<%= t.getId() %>">
                            <input type="hidden" name="accion" value="eliminar">
                            <button type="submit" class="btn-accion btn-eliminar" onclick="return confirm('¿Eliminar este turno?')">🗑 Eliminar</button>
                        </form>
                    </td>
                </tr>
                <%
                    }
                } else {
                %>
                <tr>
                    <td colspan="9" style="text-align:center;padding:30px;color:#999;">No hay turnos registrados</td>
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
                <% 
                List<Comentario> comentarios = (List<Comentario>) request.getAttribute("comentarios");
                if (comentarios != null && !comentarios.isEmpty()) {
                    for (Comentario c : comentarios) {
                %>
                <tr>
                    <td><%= c.getId() %></td>
                    <td><strong><%= c.getNombre() %></strong></td>
                    <td style="max-width:300px;"><%= c.getComentario() %></td>
                    <td>
                        <% if (c.getCalificacion() != null) { 
                            for (int i = 0; i < c.getCalificacion(); i++) { %>⭐<% }
                        } else { %>-<% } %>
                    </td>
                    <td><%= c.getFechaCreacion() != null ? c.getFechaCreacion().toString().substring(0, 16) : "-" %></td>
                    <td>
                        <span class="badge <%= c.isAprobado() ? "badge-activo" : "badge-pendiente" %>">
                            <%= c.isAprobado() ? "APROBADO" : "PENDIENTE" %>
                        </span>
                    </td>
                    <td class="acciones">
                        <% if (!c.isAprobado()) { %>
                            <form method="POST" action="${pageContext.request.contextPath}/panel/accion" style="display:inline;">
                                <input type="hidden" name="tipo" value="comentario">
                                <input type="hidden" name="id" value="<%= c.getId() %>">
                                <input type="hidden" name="accion" value="aprobar">
                                <button type="submit" class="btn-accion btn-aprobar">✓ Aprobar</button>
                            </form>
                        <% } %>
                        <form method="POST" action="${pageContext.request.contextPath}/panel/accion" style="display:inline;">
                            <input type="hidden" name="tipo" value="comentario">
                            <input type="hidden" name="id" value="<%= c.getId() %>">
                            <input type="hidden" name="accion" value="eliminar">
                            <button type="submit" class="btn-accion btn-eliminar" onclick="return confirm('¿Eliminar este comentario?')">🗑 Eliminar</button>
                        </form>
                    </td>
                </tr>
                <%
                    }
                } else {
                %>
                <tr>
                    <td colspan="7" style="text-align:center;padding:30px;color:#999;">No hay comentarios registrados</td>
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
function scrollToSection(e){document.getElementById(e).scrollIntoView({behavior:"smooth",block:"start"})}
</script>
</body>
</html>
