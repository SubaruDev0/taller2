<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.taller2.model.Comentario" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Información de Contacto | Clínica Dental</title>
    <style>
        :root {
            --azul-principal: #0fa49c;
            --azul-claro: #087872;
            --color-secundario: #ffca1c;
            --fondo-claro: #f0f9f8;
            --fondo-tarjeta: #ffffff;
            --color-fuente: #333333;
            --color-hover: #0d8c85;
            --fondo-gris: #f4f7fb;
            --color-texto: #222;
            --borde-radius: 12px;
            --sombra-suave: 0 4px 15px rgba(0,0,0,0.1);
            --sombra-fuerte: 0 8px 25px rgba(0,0,0,0.15);
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: "Segoe UI", Arial, sans-serif;
        }

        body {
            background: var(--fondo-gris);
            min-height: 100vh;
            display: flex;
            flex-direction: column;
            line-height: 1.6;
        }

        a {
            text-decoration: none;
            color: var(--azul-principal);
            transition: color 0.3s ease;
        }

        /* Header Styles */
        header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 15px 40px;
            background: var(--azul-principal);
            color: #fff;
            height: 120px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }

        .logo img {
            width: 300px;
            height: auto;
            object-fit: contain;
        }

        nav ul {
            display: flex;
            list-style: none;
            gap: 25px;
        }

        nav a {
            color: #fff;
            text-decoration: none;
            font-weight: 500;
            font-size: 16px;
            padding: 8px 12px;
            border-radius: 5px;
            transition: background-color 0.3s;
        }

        nav a:hover,
        nav a.active {
            background-color: var(--color-hover);
        }

        /* Main Container */
        .main-container {
            flex: 1;
            display: grid;
            grid-template-columns: 2fr 1fr;
            grid-template-areas: 
                "mapa-titulo info-cards"
                "mapa-ubicacion info-cards";
            gap: 0 30px;
            background: var(--fondo-tarjeta);
            margin: 40px auto;
            padding: 30px;
            border-radius: var(--borde-radius);
            box-shadow: var(--sombra-suave);
            max-width: 1200px;
            width: 90%;
        }

        .mapa-titulo {
            grid-area: mapa-titulo;
            color: var(--azul-principal);
            font-size: 1.8em;
            padding-bottom: 10px;
            border-bottom: 3px solid var(--color-secundario);
            margin-bottom: 25px;
        }

        /* Mapa Section */
        #mapa-ubicacion {
            grid-area: mapa-ubicacion;
            height: 100%;
            background: #e0e0e0;
            border-radius: var(--borde-radius);
            overflow: hidden;
            box-shadow: var(--sombra-suave);
            position: relative;
            display: flex;
            flex-direction: column;
        }

        #mapa-interactivo-div {
            width: 100%;
            flex-grow: 1;
            min-height: 400px;
        }

        #mapa-interactivo-div iframe {
            width: 100%;
            height: 100%;
            border: none;
        }

        .mapa-placeholder {
            position: absolute;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            color: #666;
            text-align: center;
            padding: 20px;
            background: white;
            border-radius: var(--borde-radius);
            box-shadow: var(--sombra-suave);
        }

        /* Info Cards */
        .info-cards {
            grid-area: info-cards;
            display: flex;
            flex-direction: column;
            gap: 30px;
        }

        .tarjeta {
            padding: 30px;
            border-radius: var(--borde-radius);
            background: var(--fondo-tarjeta);
            box-shadow: var(--sombra-suave);
            transition: transform 0.3s ease, box-shadow 0.3s ease;
        }

        .tarjeta:hover {
            transform: translateY(-5px);
            box-shadow: var(--sombra-fuerte);
        }

        .tarjeta h3 {
            margin-bottom: 15px;
            color: var(--azul-principal);
            font-size: 1.5em;
            border-bottom: 3px solid var(--color-secundario);
            padding-bottom: 10px;
            display: flex;
            align-items: center;
        }

        .tarjeta h3 i {
            margin-right: 10px;
            color: var(--color-secundario);
        }

        /* Horario Styles */
        .horario-info .time-slot {
            font-size: 1.8em;
            font-weight: bold;
            color: var(--color-secundario);
            margin-top: 5px;
        }

        .contacto-info {
            border-left: 5px solid var(--azul-principal);
        }

        .var-item {
            margin-bottom: 20px;
            padding: 10px 0;
        }

        .var-item span {
            font-size: 0.9em;
            color: #666;
            font-weight: 500;
            display: block;
            margin-bottom: 5px;
        }

        .var-value {
            font-size: 1.1em;
            font-weight: bold;
            color: var(--color-texto);
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .var-value a {
            color: var(--azul-principal);
            transition: color 0.3s;
        }

        .var-value a:hover {
            color: var(--color-hover);
        }

        .var-value i {
            font-size: 1.3em;
            color: var(--color-secundario);
        }

        /* Redes Sociales */
        .redes-var {
            display: flex;
            flex-direction: column;
        }

        .redes-titulo {
            font-size: 0.9em;
            color: #666;
            font-weight: 500;
            margin-bottom: 8px;
        }

        .redes-var .var-value {
            display: flex;
            gap: 15px;
            justify-content: flex-start;
        }

        .redes-var .var-value a {
            font-size: 1.6em;
            color: var(--azul-principal);
            transition: color 0.3s, transform 0.3s;
        }

        .redes-var .var-value a:hover {
            color: var(--color-secundario);
            transform: scale(1.15);
        }

        /* Carrusel Sedes */
        .carrusel-sedes-wrapper {
            padding: 15px;
            background-color: var(--fondo-tarjeta);
            border-top: 1px solid #ddd;
            box-shadow: 0 -2px 5px rgba(0,0,0,0.05);
            flex-shrink: 0;
        }

        .carrusel-sedes-wrapper h3 {
            font-size: 1.1em;
            color: var(--azul-principal);
            margin-bottom: 10px;
        }

        .carrusel-sedes-wrapper h3 i {
            margin-right: 8px;
            color: var(--color-secundario);
        }

        .carrusel-sedes {
            display: flex;
            overflow-x: auto;
            padding-bottom: 10px;
            gap: 15px;
            -webkit-overflow-scrolling: touch;
            scrollbar-width: thin;
        }

        .carrusel-sedes::-webkit-scrollbar {
            height: 8px;
        }

        .carrusel-sedes::-webkit-scrollbar-thumb {
            background: rgba(0,0,0,0.15);
            border-radius: 10px;
        }

        .sede-card {
            flex-shrink: 0;
            width: 250px;
            background-color: var(--fondo-tarjeta);
            border-radius: 8px;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
            transition: box-shadow 0.3s, transform 0.3s;
            cursor: default;
            border: 1px solid #ddd;
            overflow: hidden;
        }

        .sede-card:hover {
            box-shadow: 0 5px 15px rgba(0,0,0,0.2);
            transform: translateY(-3px);
        }

        .sede-card-img-container {
            width: 100%;
            height: 120px;
            overflow: hidden;
            background: #f0f0f0;
        }

        .sede-card-img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            transition: transform 0.3s ease;
        }

        .sede-card:hover .sede-card-img {
            transform: scale(1.05);
        }

        .sede-card h4 {
            margin: 10px 15px 5px 15px;
            color: var(--azul-principal);
            font-size: 1.1em;
        }

        .sede-card p {
            font-size: 0.85em;
            color: #555;
            margin: 0 15px 5px 15px;
            padding-bottom: 5px;
        }

        .sede-card p i {
            color: var(--color-secundario);
            margin-right: 5px;
        }

        /* Carousel Navigation Buttons */
        .carousel-btn {
            position: absolute;
            top: 50%;
            transform: translateY(-50%);
            background: var(--azul-principal);
            color: white;
            border: none;
            width: 40px;
            height: 40px;
            border-radius: 50%;
            cursor: pointer;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.2rem;
            transition: all 0.3s ease;
            z-index: 10;
            box-shadow: 0 2px 8px rgba(0,0,0,0.2);
        }

        .carousel-btn:hover {
            background: var(--color-hover);
            transform: translateY(-50%) scale(1.1);
        }

        .carousel-btn-left {
            left: -15px;
        }

        .carousel-btn-right {
            right: -15px;
        }

        #carousel-items {
            display: flex;
            gap: 15px;
        }

        /* Comentarios Section */
        .seccion-comentarios {
            margin: 60px auto 40px;
            max-width: 1200px;
            width: 90%;
        }

        .contenedor-comentarios {
            background: var(--fondo-tarjeta);
            border-radius: var(--borde-radius);
            padding: 40px;
            box-shadow: var(--sombra-suave);
        }

        .titulo-comentarios {
            color: var(--azul-principal);
            margin-bottom: 30px;
            font-size: 2rem;
            text-align: center;
        }

        .titulo-comentarios i {
            margin-right: 10px;
        }

        /* Alert Messages */
        .alert {
            padding: 15px;
            border-radius: 10px;
            margin-bottom: 20px;
            text-align: center;
            font-weight: bold;
        }

        .alert-success {
            background: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }

        .alert-error {
            background: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }

        /* Form Styles */
        .form-comentario {
            max-width: 600px;
            margin: 0 auto 40px auto;
        }

        .form-group {
            margin-bottom: 20px;
        }

        .form-label {
            display: block;
            margin-bottom: 8px;
            font-weight: 600;
            color: #333;
        }

        .form-input,
        .form-select,
        .form-textarea {
            width: 100%;
            padding: 12px;
            border: 2px solid #e0e0e0;
            border-radius: 8px;
            font-size: 1rem;
            transition: border-color 0.3s ease;
        }

        .form-input:focus,
        .form-select:focus,
        .form-textarea:focus {
            outline: none;
            border-color: var(--azul-principal);
        }

        .form-textarea {
            resize: vertical;
            min-height: 120px;
        }

        .btn-submit {
            width: 100%;
            padding: 15px;
            background-color: var(--color-secundario);
            color: #000;
            border: none;
            border-radius: 50px;
            font-size: 1.1rem;
            font-weight: bold;
            cursor: pointer;
            transition: background 0.3s, transform 0.3s;
        }

        .btn-submit:hover {
            background-color: #e6b800;
            transform: translateY(-2px);
        }

        /* Comentarios List */
        .lista-comentarios {
            border-top: 2px solid #e0e0e0;
            padding-top: 40px;
            margin-top: 20px;
        }

        .subtitulo-comentarios {
            color: var(--azul-principal);
            margin-bottom: 25px;
            font-size: 1.6rem;
            text-align: center;
        }

        .grid-comentarios {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
            gap: 20px;
        }

        .tarjeta-comentario {
            background: #f8f9fa;
            border-left: 4px solid var(--azul-principal);
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 2px 8px rgba(0,0,0,.05);
            transition: transform 0.3s ease;
        }

        .tarjeta-comentario:hover {
            transform: translateY(-3px);
        }

        .header-comentario {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 12px;
        }

        .nombre-usuario {
            color: var(--azul-principal);
            font-size: 1.1rem;
            font-weight: bold;
        }

        .estrellas {
            color: #ffca1c;
            font-size: 1.2rem;
        }

        .texto-comentario {
            color: #555;
            line-height: 1.6;
            margin: 0;
        }

        .fecha-comentario {
            color: #999;
            font-size: 0.85rem;
            margin-top: 10px;
            text-align: right;
        }

        /* Acceso Restringido */
        .acceso-restringido {
            text-align: center;
            padding: 40px 20px;
            max-width: 600px;
            margin: 0 auto;
        }

        .icono-bloqueo {
            font-size: 4rem;
            color: var(--azul-principal);
            margin-bottom: 20px;
            display: block;
        }

        .btn-login {
            display: inline-block;
            background-color: var(--color-secundario);
            color: #000;
            padding: 15px 40px;
            border-radius: 50px;
            text-decoration: none;
            font-weight: bold;
            font-size: 1.1rem;
            transition: all 0.3s ease;
            margin-top: 10px;
        }

        .btn-login:hover {
            background-color: #e6b800;
            transform: translateY(-2px);
        }

        /* Footer */
        footer {
            background: var(--azul-principal);
            color: white;
            text-align: center;
            padding: 25px 20px;
            margin-top: auto;
        }

        .redes-sociales {
            margin-top: 12px;
            display: flex;
            justify-content: center;
            gap: 18px;
        }

        .redes-sociales a {
            text-decoration: none;
            color: #f5f7fa;
            font-weight: bold;
            transition: color 0.3s;
        }

        .redes-sociales a:hover {
            color: var(--color-secundario);
        }

        /* Responsive Design */
        @media (max-width: 768px) {
            header {
                flex-direction: column;
                height: auto;
                padding: 15px;
                gap: 15px;
            }

            .logo img {
                width: 200px;
            }

            nav ul {
                flex-wrap: wrap;
                justify-content: center;
                gap: 10px;
            }

            .main-container {
                grid-template-columns: 1fr;
                grid-template-areas: 
                    "mapa-titulo"
                    "mapa-ubicacion"
                    "info-cards";
                padding: 20px;
                margin: 20px auto;
                width: 95%;
            }

            .mapa-titulo {
                font-size: 1.4em;
            }

            #mapa-ubicacion {
                min-height: 300px;
            }

            .info-cards {
                gap: 20px;
            }

            .tarjeta {
                padding: 20px;
            }

            .tarjeta h3 {
                font-size: 1.3em;
            }

            .carrusel-sedes-wrapper h3 {
                font-size: 1em;
            }

            .sede-card {
                width: 220px;
            }

            .contenedor-comentarios {
                padding: 20px;
            }

            .titulo-comentarios {
                font-size: 1.6rem;
            }

            .grid-comentarios {
                grid-template-columns: 1fr;
            }
        }

        @media (max-width: 480px) {
            .main-container {
                padding: 15px;
                margin: 15px auto;
            }

            .contenedor-comentarios {
                padding: 15px;
            }

            .titulo-comentarios {
                font-size: 1.4rem;
            }

            .btn-login {
                padding: 12px 30px;
                font-size: 1rem;
            }
        }
    </style>
</head>
<body>
    <header>
        <div class="logo">
            <img src="${pageContext.request.contextPath}/img/logo.png" alt="Clínica Dental Logo" onerror="this.src='${pageContext.request.contextPath}/img/logo-clinica.jpg'">
        </div>
        <nav>
            <ul>
                <li><a href="${pageContext.request.contextPath}/inicio">Inicio</a></li>
                <li><a href="${pageContext.request.contextPath}/servicios">Servicios</a></li>
                <li><a href="${pageContext.request.contextPath}/equipo">Equipo</a></li>
                <li><a href="${pageContext.request.contextPath}/contacto" class="active">Contacto</a></li>
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

    <main class="main-container">
        <h2 class="mapa-titulo">Sede Principal: Concepción</h2>
        
        <section id="mapa-ubicacion" class="section">
            <div id="mapa-interactivo-div">
                <iframe width="100%" height="100%" frameborder="0" style="border:0" 
                        referrerpolicy="no-referrer-when-downgrade" 
                        src="https://maps.google.com/maps?q=Arturo%20Prat%20450,%20Concepci%C3%B3n&t=&z=15&ie=UTF8&iwloc=&output=embed" 
                        allowfullscreen loading="lazy"
                        title="Ubicación de la Clínica Dental en Concepción">
                </iframe>
            </div>
            <div class="carrusel-sedes-wrapper">
                <h3><i class="fas fa-city"></i> Nuestras Otras Sucursales</h3>
                <div style="position: relative;">
                    <button id="btn-prev" class="carousel-btn carousel-btn-left" aria-label="Anterior">
                        <i class="fas fa-chevron-left"></i>
                    </button>
                    <div id="carrusel-sedes" class="carrusel-sedes">
                        <div id="carousel-items"></div>
                    </div>
                    <button id="btn-next" class="carousel-btn carousel-btn-right" aria-label="Siguiente">
                        <i class="fas fa-chevron-right"></i>
                    </button>
                </div>
            </div>
        </section>

        <section class="info-cards">
            <article class="tarjeta horario-info">
                <h3><i class="fas fa-clock"></i> Horario de Atención</h3>
                <p>Lunes – Viernes:</p>
                <p class="time-slot">09:00 — 17:30</p>
                <p style="margin-top:15px;">Sábados no festivos:</p>
                <p class="time-slot" style="font-size:1.4em;">09:00 — 14:00</p>
                <p style="margin-top:15px;font-size:0.9em;color:#888;">
                    Atención solo con cita previa. Domingos y festivos cerrado.
                </p>
            </article>

            <article class="tarjeta contacto-info">
                <h3><i class="fas fa-id-badge"></i> Contacto Central</h3>
                <div class="var-item">
                    <span>Teléfono Central</span>
                    <a href="tel:+56912345678" class="var-value">
                        +56 9 1234 5678 <i class="fas fa-phone-alt"></i>
                    </a>
                </div>
                <div class="var-item">
                    <span>Correo Electrónico</span>
                    <a href="mailto:contacto@centrodental.cl" class="var-value">
                        contacto@centrodental.cl <i class="fas fa-envelope"></i>
                    </a>
                </div>
                <div class="var-item redes-var">
                    <span class="redes-titulo">Aprende más de nosotros en:</span>
                    <span class="var-value">
                        <a href="#" aria-label="Facebook"><i class="fab fa-facebook-f"></i></a>
                        <a href="#" aria-label="Instagram"><i class="fab fa-instagram"></i></a>
                    </span>
                </div>
            </article>
        </section>
    </main>

    <!-- Sección de Comentarios -->
    <section class="seccion-comentarios">
        <div class="contenedor-comentarios">
            <h3 class="titulo-comentarios">
                <i class="fas fa-comments"></i> Déjanos tu Comentario
            </h3>
            
            <%
                String exitoComentario = (String) session.getAttribute("mensajeExito");
                String errorComentario = (String) session.getAttribute("mensajeError");
                
                if (exitoComentario != null) {
            %>
                <div class="alert alert-success">
                    ✓ <%= exitoComentario %>
                </div>
            <%
                    session.removeAttribute("mensajeExito");
                }
                
                if (errorComentario != null) {
            %>
                <div class="alert alert-error">
                    ✗ <%= errorComentario %>
                </div>
            <%
                    session.removeAttribute("mensajeError");
                }
            %>
            
            <% 
                String tipoUsuario = (String) session.getAttribute("tipoUsuario");
                boolean esInvitado = "INVITADO".equals(tipoUsuario);
                boolean estaLogueado = session.getAttribute("usuarioId") != null;
            %>
            
            <% if (esInvitado || !estaLogueado) { %>
                <!-- MENSAJE DE ACCESO RESTRINGIDO PARA INVITADOS -->
                <div class="acceso-restringido">
                    <i class="fas fa-lock icono-bloqueo"></i>
                    <h2 style="color:var(--azul-principal);margin-bottom:15px;font-size:2rem;">
                        Acceso Restringido
                    </h2>
                    <p style="font-size:1.1rem;color:#666;margin-bottom:20px;line-height:1.6;">
                        Para dejar un comentario debes iniciar sesión con una cuenta registrada.
                        <% if (esInvitado) { %>
                            <br><br>Estás navegando como <strong>invitado</strong>. Por favor, inicia sesión para continuar.
                        <% } %>
                    </p>
                    <a href="${pageContext.request.contextPath}/login" class="btn-login">
                        Iniciar Sesión
                    </a>
                </div>
            <% } else { %>
                <!-- FORMULARIO DE COMENTARIOS -->
                <form method="POST" action="${pageContext.request.contextPath}/comentario" class="form-comentario">
                    <div class="form-group">
                        <label class="form-label">Nombre *</label>
                        <input type="text" name="nombre" required class="form-input"
                               placeholder="Ingresa tu nombre completo">
                    </div>
                    
                    <div class="form-group">
                        <label class="form-label">Calificación *</label>
                        <select name="calificacion" required class="form-select">
                            <option value="">Seleccione una calificación...</option>
                            <option value="5">⭐⭐⭐⭐⭐ Excelente</option>
                            <option value="4">⭐⭐⭐⭐ Muy Bueno</option>
                            <option value="3">⭐⭐⭐ Bueno</option>
                            <option value="2">⭐⭐ Regular</option>
                            <option value="1">⭐ Malo</option>
                        </select>
                    </div>
                    
                    <div class="form-group">
                        <label class="form-label">Comentario *</label>
                        <textarea name="comentario" required rows="5" class="form-textarea"
                                  placeholder="Cuéntanos tu experiencia, sugerencias o comentarios..."></textarea>
                    </div>
                    
                    <button type="submit" class="btn-submit">
                        <i class="fas fa-paper-plane"></i> Enviar Comentario
                    </button>
                </form>
            <% } %>
            
            <!-- Comentarios Aprobados -->
            <% 
                List<Comentario> comentariosAprobados = (List<Comentario>) request.getAttribute("comentariosAprobados");
                if (comentariosAprobados != null && !comentariosAprobados.isEmpty()) { 
            %>
                <div class="lista-comentarios">
                    <h4 class="subtitulo-comentarios">
                        <i class="fas fa-star"></i> Opiniones de Nuestros Pacientes
                    </h4>
                    <div class="grid-comentarios">
                        <% for (Comentario c : comentariosAprobados) { %>
                            <div class="tarjeta-comentario">
                                <div class="header-comentario">
                                    <strong class="nombre-usuario"><%= c.getNombre() %></strong>
                                    <span class="estrellas">
                                        <% for(int i = 0; i < c.getCalificacion(); i++) { %>⭐<% } %>
                                    </span>
                                </div>
                                <p class="texto-comentario"><%= c.getComentario() %></p>
                                <p class="fecha-comentario">
                                    <%= c.getFechaCreacion() != null ? 
                                        new java.text.SimpleDateFormat("dd/MM/yyyy").format(c.getFechaCreacion()) : "" %>
                                </p>
                            </div>
                        <% } %>
                    </div>
                </div>
            <% } else { %>
                <div style="text-align:center;padding:20px;color:#666;">
                    <p>No hay comentarios aprobados para mostrar.</p>
                </div>
            <% } %>
        </div>
    </section>

    <footer>
        <p>© 2025 Clínica Dental. Todos los derechos reservados.</p>
        <div class="redes-sociales">
            <a href="#"><i class="fab fa-facebook-f"></i> Facebook</a>
            <a href="#"><i class="fab fa-instagram"></i> Instagram</a>
        </div>
    </footer>

    <script>
        // Obtener el contexto de la aplicación
        var contextPath = '${pageContext.request.contextPath}';
        
        // DATOS HARDCODEADOS DE SUCURSALES (SIN TEMUCO)
        var sucursalesData = [
            {
                id: "santiago",
                name: "Santiago",
                address: "Avenida Libertador Bernardo O'Higgins 100, Santiago",
                phone: "+56 2 9876 5432",
                image: contextPath + "/img/sede-santiago.jpg"
            },
            {
                id: "valparaiso",
                name: "Valparaíso",
                address: "Condell 1500, Valparaíso",
                phone: "+56 32 543 2109",
                image: contextPath + "/img/sede-valparaiso.jpg"
            },
            {
                id: "vinadelmar",
                name: "Viña del Mar",
                address: "Calle Valparaíso 500, Viña del Mar",
                phone: "+56 32 109 8765",
                image: contextPath + "/img/sede-vina.jpg"
            },
            {
                id: "puntaarenas",
                name: "Punta Arenas",
                address: "Avenida Colón 900, Punta Arenas",
                phone: "+56 61 678 9012",
                image: contextPath + "/img/sede-puntaarenas.jpeg"
            },
            {
                id: "copiapo",
                name: "Copiapó",
                address: "Calle O'Higgins 700, Copiapó",
                phone: "+56 52 345 6789",
                image: contextPath + "/img/sede-copiapo.jpg"
            }
        ];

        // Configuración del carrusel
        var AUTO_SCROLL_INTERVAL = 3000;
        var scrollAmount = 280;

        // Función para renderizar las tarjetas del carrusel
        function renderCarruselSedes() {
            var carouselItemsContainer = document.getElementById("carousel-items");
            
            if (!carouselItemsContainer) {
                console.error("No se encontró el contenedor carousel-items");
                return;
            }

            if (!sucursalesData || sucursalesData.length === 0) {
                console.warn("No hay sucursales para mostrar");
                carouselItemsContainer.innerHTML = '<p style="padding:20px;color:#666;">No hay sucursales disponibles</p>';
                return;
            }

            var html = '';

            for (var i = 0; i < sucursalesData.length; i++) {
                var sede = sucursalesData[i];
                
                // Extraer nombre corto y dirección corta
                var nombreCorto = sede.name;
                if (sede.name.indexOf("—") !== -1) {
                    nombreCorto = sede.name.split("—")[0].trim();
                }
                
                var direccionCorta = sede.address;
                if (sede.address.indexOf(",") !== -1) {
                    direccionCorta = sede.address.split(",")[0].trim();
                }
                
                var imageSrc = sede.image;
                var fallbackImage = contextPath + "/img/sede-card.jpg";
                
                html += '<div class="sede-card" role="article" aria-label="Sede ' + nombreCorto + '">';
                html += '  <div class="sede-card-img-container">';
                html += '    <img src="' + imageSrc + '" ';
                html += '         alt="Fachada de la Sede ' + nombreCorto + '" ';
                html += '         class="sede-card-img"';
                html += '         onerror="this.src=\'' + fallbackImage + '\'">';
                html += '  </div>';
                html += '  <h4>' + nombreCorto + '</h4>';
                html += '  <p><i class="fas fa-phone-alt"></i> ' + sede.phone + '</p>';
                html += '  <p style="padding-bottom: 15px;">';
                html += '    <i class="fas fa-map-marker-alt"></i> ' + direccionCorta;
                html += '  </p>';
                html += '</div>';
            }

            carouselItemsContainer.innerHTML = html;
        }

        // Función para inicializar navegación del carrusel (LÓGICA DE INICIO.JSP)
        function inicializarNavegacionCarrusel() {
            var btnPrev = document.getElementById("btn-prev");
            var btnNext = document.getElementById("btn-next");
            var carruselContainer = document.getElementById("carrusel-sedes");

            if (!btnPrev || !btnNext || !carruselContainer) {
                console.error("No se encontraron los botones o contenedor del carrusel");
                return;
            }

            // Evento para botón anterior (con vuelta al final)
            btnPrev.addEventListener("click", function() {
                var scrollTolerance = 1;
                if (carruselContainer.scrollLeft <= scrollTolerance) {
                    carruselContainer.scrollTo({
                        left: carruselContainer.scrollWidth,
                        behavior: 'smooth'
                    });
                } else {
                    carruselContainer.scrollBy({
                        left: -scrollAmount,
                        behavior: 'smooth'
                    });
                }
            });

            // Evento para botón siguiente (con vuelta al inicio)
            btnNext.addEventListener("click", function() {
                var scrollTolerance = 1;
                if (carruselContainer.scrollLeft + carruselContainer.clientWidth + scrollTolerance >= carruselContainer.scrollWidth) {
                    carruselContainer.scrollTo({
                        left: 0,
                        behavior: 'smooth'
                    });
                } else {
                    carruselContainer.scrollBy({
                        left: scrollAmount,
                        behavior: 'smooth'
                    });
                }
            });

            // AUTO-SCROLL INFINITO (como en inicio.jsp)
            var autoScrollId;

            function startAutoScroll() {
                stopAutoScroll();
                autoScrollId = setInterval(function() {
                    var scrollTolerance = 1;
                    if (carruselContainer.scrollLeft + carruselContainer.clientWidth + scrollTolerance >= carruselContainer.scrollWidth) {
                        carruselContainer.scrollTo({
                            left: 0,
                            behavior: 'smooth'
                        });
                    } else {
                        carruselContainer.scrollBy({
                            left: scrollAmount,
                            behavior: 'smooth'
                        });
                    }
                }, AUTO_SCROLL_INTERVAL);
            }

            function stopAutoScroll() {
                clearInterval(autoScrollId);
            }

            // Pausar auto-scroll al pasar el mouse
            carruselContainer.addEventListener('mouseenter', stopAutoScroll);
            carruselContainer.addEventListener('mouseleave', startAutoScroll);

            // Iniciar auto-scroll
            startAutoScroll();
        }

        // Función para inicializar el mapa
        function inicializarMapa() {
            var mapaContainer = document.getElementById("mapa-interactivo-div");
            if (!mapaContainer) {
                console.warn("No se encontró el contenedor del mapa");
                return;
            }

            var iframe = mapaContainer.querySelector("iframe");
            if (iframe) {
                iframe.addEventListener("load", function() {
                    console.log("Mapa de Google cargado correctamente");
                });

                iframe.addEventListener("error", function() {
                    console.error("Error al cargar el mapa de Google");
                    mostrarPlaceholderMapa();
                });
            }
        }

        function mostrarPlaceholderMapa() {
            var mapaContainer = document.getElementById("mapa-interactivo-div");
            if (mapaContainer) {
                mapaContainer.innerHTML = '<div class="mapa-placeholder">' +
                    '<i class="fas fa-map-marked-alt" style="font-size: 3em; color: #666; margin-bottom: 15px;"></i>' +
                    '<h3>Mapa no disponible</h3>' +
                    '<p>No se pudo cargar el mapa interactivo.</p>' +
                    '<p><strong>Dirección:</strong> Arturo Prat 450, Concepción</p>' +
                    '</div>';
            }
        }

        // Inicialización cuando el DOM esté listo
        document.addEventListener("DOMContentLoaded", function() {
            console.log("Inicializando página de contacto...");
            renderCarruselSedes();
            inicializarNavegacionCarrusel();
            inicializarMapa();
            console.log("Página de contacto inicializada correctamente");
        });

        // Manejo de errores globales
        window.addEventListener("error", function(e) {
            console.error("Error en la página de contacto:", e.error);
        });
    </script>
</body>
</html>