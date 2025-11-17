<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    // Verificar si el usuario es invitado
    String tipoUsuario = (String) session.getAttribute("tipoUsuario");
    boolean esInvitado = "INVITADO".equals(tipoUsuario);
    boolean estaLogueado = session.getAttribute("usuarioId") != null;
    
    // Mensajes de éxito/error
    String mensajeExito = (String) request.getAttribute("exito");
    String mensajeError = (String) request.getAttribute("error");
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Pedir Turno - Clínica Dental</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
:root{--azul-principal:#0fa49c;--azul-claro:#087872;--color-secundario:#ffca1c;--fondo-claro:#f0f9f8;--fondo-tarjeta:#ffffff;--color-fuente:#333333;--color-hover:#0d8c85}*{margin:0;padding:0;box-sizing:border-box;font-family:"Segoe UI",sans-serif}body{background:var(--fondo-claro);min-height:100vh;display:flex;flex-direction:column}header{display:flex;justify-content:space-between;align-items:center;padding:15px 40px;background:var(--azul-principal);color:#fff;height:120px;box-shadow:0 2px 10px rgba(0,0,0,0.1)}.logo img{width:300px;height:auto}nav ul{display:flex;list-style:none;gap:25px}nav a{color:#fff;text-decoration:none;font-weight:500;font-size:16px;padding:8px 12px;border-radius:5px;transition:background-color 0.3s}nav a:hover,nav a.active{background-color:var(--color-hover)}footer{background:var(--azul-principal);color:white;text-align:center;padding:25px 20px;margin-top:auto}footer .redes-sociales{margin-top:12px;display:flex;justify-content:center;gap:18px}footer .redes-sociales a{text-decoration:none;color:#f5f7fa;font-weight:bold;transition:color 0.3s}footer .redes-sociales a:hover{color:var(--color-secundario)}.container{flex:1;max-width:1200px;margin:0 auto;padding:20px}.page-header{text-align:center;margin-bottom:40px;padding:30px 20px;background:linear-gradient(135deg,var(--azul-principal) 0%,var(--azul-claro) 100%);border-radius:16px;color:white}.page-header h1{font-size:2.5rem;margin-bottom:15px}.page-header p{font-size:1.1rem;max-width:600px;margin:0 auto;line-height:1.6}.form-section{background:var(--fondo-tarjeta);border-radius:16px;padding:40px;margin-bottom:40px;box-shadow:0 6px 20px rgba(0,0,0,0.1)}.formulario{max-width:800px;margin:0 auto}.turno-form{display:grid;grid-template-columns:1fr 1fr;gap:25px}.form-group{display:flex;flex-direction:column}.form-group.full-width{grid-column:1/-1}.form-group label{margin-bottom:8px;font-weight:600;color:var(--azul-principal);font-size:1rem}.form-group input,.form-group select,.form-group textarea{padding:12px 15px;border:2px solid #e0e0e0;border-radius:8px;font-size:1rem;transition:all 0.3s ease;background-color:#fafafa}.form-group input:focus,.form-group select:focus,.form-group textarea:focus{outline:none;border-color:var(--azul-principal);background-color:white;box-shadow:0 0 0 3px rgba(15,164,156,0.1)}.form-group textarea{resize:vertical;min-height:100px;font-family:inherit}.help-text{margin-top:5px;font-size:0.85rem;color:#666;font-style:italic}.checkbox-label{display:flex;align-items:flex-start;cursor:pointer;font-size:0.95rem;line-height:1.4}.checkbox-label input[type="checkbox"]{display:none}.checkmark{width:20px;height:20px;border:2px solid #ddd;border-radius:4px;margin-right:10px;margin-top:2px;position:relative;transition:all 0.3s ease;flex-shrink:0}.checkbox-label input[type="checkbox"]:checked+.checkmark{background-color:var(--azul-principal);border-color:var(--azul-principal)}.checkbox-label input[type="checkbox"]:checked+.checkmark::after{content:"✓";position:absolute;color:white;font-size:14px;top:50%;left:50%;transform:translate(-50%,-50%)}.checkbox-label .link{color:var(--azul-principal);text-decoration:none;font-weight:600}.checkbox-label .link:hover{text-decoration:underline}.btn-submit{grid-column:1/-1;background-color:var(--color-secundario);color:var(--color-fuente);border:none;border-radius:50px;padding:15px 30px;font-size:1.1rem;font-weight:bold;cursor:pointer;transition:all 0.3s ease;margin-top:10px}.btn-submit:hover{background-color:#e5b600;transform:translateY(-2px);box-shadow:0 4px 12px rgba(0,0,0,0.15)}.info-section{margin-top:40px}.info-grid{display:grid;grid-template-columns:repeat(auto-fit,minmax(300px,1fr));gap:25px}.info-card{background:var(--fondo-tarjeta);border-radius:12px;padding:25px;box-shadow:0 4px 15px rgba(0,0,0,0.08);border-left:4px solid var(--azul-principal);transition:transform 0.3s ease}.info-card:hover{transform:translateY(-5px)}.info-card h3{color:var(--azul-principal);margin-bottom:15px;font-size:1.3rem}.info-card p{margin-bottom:8px;color:var(--color-fuente);line-height:1.5}.info-card strong{color:var(--azul-claro)}@media(max-width:768px){header{flex-direction:column;height:auto;padding:15px;gap:15px}.logo img{width:200px}nav ul{flex-wrap:wrap;justify-content:center;gap:10px}.container{padding:15px}.page-header{padding:20px 15px;margin-bottom:30px}.page-header h1{font-size:2rem}.page-header p{font-size:1rem}.form-section{padding:25px 20px;margin-bottom:30px}.turno-form{grid-template-columns:1fr;gap:20px}.form-group.full-width{grid-column:1}.btn-submit{grid-column:1}.info-grid{grid-template-columns:1fr;gap:20px}.info-card{padding:20px}}
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
            <% if (session.getAttribute("rol") != null && "ADMIN".equals(session.getAttribute("rol"))) { %>
                <li><a href="${pageContext.request.contextPath}/panel">Panel de Gestión</a></li>
            <% } %>
            <% if (session.getAttribute("usuarioId") != null) { %>
                <li><a href="${pageContext.request.contextPath}/logout">Cerrar Sesión (<%= session.getAttribute("usuario") %>)</a></li>
            <% } else { %>
                <li><a href="${pageContext.request.contextPath}/login">Login</a></li>
            <% } %>
        </ul>
    </nav>
</header>
<main class="container">
    <div class="page-header">
        <h1>Solicitar Turno</h1>
        <p>Complete el formulario para agendar su cita. Nos contactaremos para confirmar.</p>
    </div>
    
    <% if (mensajeExito != null) { %>
        <div style="background:#d4edda;color:#155724;padding:15px;border-radius:10px;margin-bottom:20px;text-align:center;font-weight:bold;">
            ✓ <%= mensajeExito %>
        </div>
    <% } %>
    <% if (mensajeError != null) { %>
        <div style="background:#f8d7da;color:#721c24;padding:15px;border-radius:10px;margin-bottom:20px;text-align:center;font-weight:bold;">
            ✗ <%= mensajeError %>
        </div>
    <% } %>
    
    <% if (esInvitado || !estaLogueado) { %>
        <section class="form-section" style="text-align:center;padding:60px 40px;">
            <div style="max-width:600px;margin:0 auto;">
                <i class="fas fa-lock" style="font-size:4rem;color:var(--azul-principal);margin-bottom:20px;"></i>
                <h2 style="color:var(--azul-principal);margin-bottom:15px;font-size:2rem;">Acceso Restringido</h2>
                <p style="font-size:1.1rem;color:#666;margin-bottom:30px;line-height:1.6;">
                    Para solicitar un turno debes iniciar sesión con una cuenta registrada.
                    <% if (esInvitado) { %>
                        <br><br>Estás navegando como <strong>invitado</strong>. Por favor, inicia sesión para continuar.
                    <% } %>
                </p>
                <a href="${pageContext.request.contextPath}/login" 
                   style="display:inline-block;background-color:var(--color-secundario);color:var(--color-fuente);padding:15px 40px;border-radius:50px;text-decoration:none;font-weight:bold;font-size:1.1rem;transition:all 0.3s ease;">
                    Iniciar Sesión
                </a>
            </div>
        </section>
    <% } else { %>
    <section id="turnos" class="form-section">
        <div class="formulario">
            <form class="turno-form" id="formTurno" method="POST" action="${pageContext.request.contextPath}/pedirTurno">
                <div class="form-group">
                    <label for="nombre">Nombre Completo *</label>
                    <input type="text" id="nombre" name="nombre" placeholder="Ingrese su nombre completo" required>
                </div>
                <div class="form-group">
                    <label for="rut">RUT *</label>
                    <input type="text" id="rut" name="rut" placeholder="Ej: 12.345.678-9" required>
                    <small class="help-text">Formato: 12.345.678-9</small>
                </div>
                <div class="form-group">
                    <label for="telefono">Teléfono *</label>
                    <input type="tel" id="telefono" name="telefono" placeholder="+56 9 1234 5678" required>
                </div>
                <div class="form-group">
                    <label for="email">Email *</label>
                    <input type="email" id="email" name="email" placeholder="su.email@ejemplo.com" required>
                </div>
                <div class="form-group">
                    <label for="servicio">Servicio Solicitado *</label>
                    <input type="hidden" name="servicio" id="servicioHidden">
                    <select id="servicio" required onchange="document.getElementById('servicioHidden').value=this.value">>
                        <option value="" disabled selected>Seleccione un servicio</option>
                        <option value="odontologia-general">Odontología general</option>
                        <option value="ortodoncia">Ortodoncia</option>
                        <option value="implantes">Implantes dentales</option>
                        <option value="endodoncia">Endodoncia (tratamiento de conducto)</option>
                        <option value="periodoncia">Periodoncia (encías)</option>
                        <option value="rehabilitacion">Rehabilitación oral</option>
                        <option value="estetica">Estética dental (blanqueamiento, carillas)</option>
                        <option value="protesis">Prótesis dentales</option>
                        <option value="cirugia">Cirugía oral y maxilofacial</option>
                        <option value="odontopediatria">Odontopediatría (niños)</option>
                        <option value="urgencias">Urgencias dentales</option>
                        <option value="limpieza">Limpieza dental</option>
                        <option value="radiografias">Radiografías y diagnóstico</option>
                    </select>
                </div>
                <div class="form-group">
                    <label for="fecha">Fecha Preferida *</label>
                    <input type="date" id="fecha" name="fecha" required min="">
                </div>
                <div class="form-group">
                    <label for="horario">Horario Preferido *</label>
                    <select id="horario" name="horario" required>
                        <option value="" disabled selected>Seleccione un horario</option>
                        <option value="mañana">Mañana (9:00 - 12:00)</option>
                        <option value="tarde">Tarde (15:00 - 19:00)</option>
                        <option value="sabado">Sábado (9:00 - 13:00)</option>
                    </select>
                </div>
                <div class="form-group full-width">
                    <label for="mensaje">Mensaje Adicional</label>
                    <textarea id="mensaje" name="mensaje" placeholder="Describa brevemente el motivo de su consulta o alguna información relevante..." rows="4"></textarea>
                </div>
                <div class="form-group full-width">
                    <label class="checkbox-label">
                        <input type="checkbox" id="terminos" required>
                        <span class="checkmark"></span>
                        Acepto los&nbsp;
                        <a href="#" class="link">términos y condiciones</a>&nbsp;y la&nbsp;
                        <a href="#" class="link">política de privacidad</a> *
                    </label>
                </div>
                <button type="submit" class="btn-submit">Solicitar Turno</button>
            </form>
        </div>
    </section>
    <% } %>
    <section class="info-section">
        <div class="info-grid">
            <div class="info-card">
                <h3>📞 Contacto Rápido</h3>
                <p>Si prefiere, puede contactarnos directamente:</p>
                <p><strong>Teléfono:</strong> +56 9 1234 5678</p>
                <p><strong>Email:</strong> turnos@clinicadental.cl</p>
            </div>
            <div class="info-card">
                <h3>🕒 Horarios de Atención</h3>
                <p><strong>Lunes a Viernes:</strong> 9:00 - 20:00 hrs</p>
                <p><strong>Sábados:</strong> 9:00 - 14:00 hrs</p>
                <p><strong>Domingos:</strong> Cerrado</p>
            </div>
            <div class="info-card">
                <h3>🚑 Urgencias Dentales</h3>
                <p>Para emergencias fuera de horario:</p>
                <p><strong>Urgencias:</strong> +56 9 8765 4321</p>
                <p>Atendemos emergencias las 24 horas</p>
            </div>
        </div>
    </section>
</main>
<footer>
    <p>&copy; 2025 Clínica Dental. Todos los derechos reservados.</p>
    <div class="redes-sociales">
        <a href="#">Facebook</a>
        <a href="#">Instagram</a>
    </div>
</footer>
<script>
class RutFormatter{constructor(t){this.input=document.getElementById(t),this.input&&this.input.addEventListener("input",(()=>this.format()))}format(){let t=this.input.value.replace(/\D/g,"");if(t.length>1){let e=t.slice(0,-1),i=t.slice(-1);e=e.replace(/\B(?=(\d{3})+(?!\d))/g,"."),this.input.value=`${e}-${i}`}else this.input.value=t}}new RutFormatter("rut"),document.addEventListener("DOMContentLoaded",(function(){const t=document.getElementById("fecha"),e=(new Date).toISOString().split("T")[0];t.min=e}));
</script>
</body>
</html>
