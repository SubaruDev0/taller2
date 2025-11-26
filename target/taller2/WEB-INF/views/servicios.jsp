<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <!DOCTYPE html>
    <html lang="es">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Clínica Dental - Servicios</title>

        <style>
            /* =====================
           ESTILOS DE header-footer.css
        ===================== */
            :root {
                --azul-principal: #0fa49c;
                --azul-claro: #087872;
                --color-secundario: #ffca1c;
                --fondo-claro: #f0f9f8;
                --fondo-tarjeta: #ffffff;
                --color-fuente: #333333;
                --color-hover: #0d8c85;
            }

            * {
                margin: 0;
                padding: 0;
                box-sizing: border-box;
                font-family: "Segoe UI", sans-serif;
            }

            header {
                display: flex;
                justify-content: space-between;
                align-items: center;
                padding: 15px 40px;
                background: var(--azul-principal);
                color: #fff;
                height: 120px;
                box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            }

            .logo img {
                width: 300px;
                height: auto;
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

            footer {
                background: var(--azul-principal);
                color: white;
                text-align: center;
                padding: 25px 20px;
                margin-top: auto;
            }

            footer .redes-sociales {
                margin-top: 12px;
                display: flex;
                justify-content: center;
                gap: 18px;
            }

            footer .redes-sociales a {
                text-decoration: none;
                color: #f5f7fa;
                font-weight: bold;
                transition: color 0.3s;
            }

            footer .redes-sociales a:hover {
                color: var(--color-secundario);
            }

            /* =====================
           ESTILOS DE servicios.css
        ===================== */
            body {
                background: var(--fondo-claro);
                min-height: 100vh;
                display: flex;
                flex-direction: column;
            }

            .page-header {
                text-align: center;
                padding: 40px 20px;
                background: linear-gradient(135deg, var(--azul-principal) 0%, var(--azul-claro) 100%);
                color: white;
            }

            .page-header h1 {
                font-size: 2.5rem;
                margin-bottom: 15px;
            }

            .page-header p {
                font-size: 1.2rem;
                max-width: 600px;
                margin: 0 auto;
            }

            main {
                flex: 1;
                padding: 40px 20px;
                max-width: 1200px;
                margin: 0 auto;
                width: 100%;
            }

            .servicios-grid {
                display: grid;
                grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
                gap: 30px;
                margin: 40px 0;
            }

            .servicio-card {
                background: #fff;
                border-radius: 14px;
                box-shadow: 0 4px 15px rgba(0, 0, 0, 0.08);
                padding: 25px 20px;
                text-align: center;
                transition: transform 0.3s, box-shadow 0.3s;
                display: flex;
                flex-direction: column;
                align-items: center;
                border-top: 4px solid var(--azul-principal);
            }

            .servicio-card:hover {
                transform: translateY(-10px);
                box-shadow: 0 10px 25px rgba(15, 164, 156, 0.15);
            }

            .servicio-card img {
                width: 100%;
                height: 200px;
                object-fit: cover;
                border-radius: 10px;
                margin-bottom: 15px;
                border: 2px solid var(--azul-claro);
            }

            .servicio-card h3 {
                margin-bottom: 12px;
                color: var(--azul-principal);
                font-size: 1.4rem;
            }

            .servicio-card p {
                margin-bottom: 20px;
                color: var(--color-fuente);
                line-height: 1.5;
                flex-grow: 1;
            }

            .btn-info {
                background-color: var(--azul-principal);
                color: white;
                border: none;
                border-radius: 5px;
                padding: 10px 20px;
                font-size: 1rem;
                cursor: pointer;
                transition: background-color 0.3s;
                width: 100%;
            }

            .btn-info:hover {
                background-color: var(--color-hover);
            }

            .btn-contacto {
                position: fixed;
                bottom: 30px;
                right: 30px;
                background-color: var(--color-secundario);
                color: var(--color-fuente);
                border: none;
                border-radius: 50px;
                padding: 15px 25px;
                font-size: 16px;
                font-weight: bold;
                cursor: pointer;
                box-shadow: 0 4px 12px rgba(0, 0, 0, 0.2);
                transition: background-color 0.3s, transform 0.3s;
                z-index: 100;
            }

            .btn-contacto:hover {
                background-color: #e5b600;
                transform: scale(1.05);
            }

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

                .page-header {
                    padding: 30px 15px;
                }

                .page-header h1 {
                    font-size: 2rem;
                }

                .page-header p {
                    font-size: 1rem;
                }

                main {
                    padding: 20px 15px;
                }

                .servicios-grid {
                    grid-template-columns: 1fr;
                    gap: 20px;
                }

                .btn-contacto {
                    bottom: 20px;
                    right: 20px;
                    padding: 12px 20px;
                    font-size: 14px;
                }
            }
        </style>
    </head>

    <body>

        <!-- =====================
     ENCABEZADO
===================== -->
        <header>
            <div class="logo">
                <img src="${pageContext.request.contextPath}/img/logo.png" alt="Clínica Dental Logo">
            </div>

            <nav>
                <ul>
                    <li><a href="${pageContext.request.contextPath}/inicio">Inicio</a></li>
                    <li><a href="${pageContext.request.contextPath}/servicios" class="active">Servicios</a></li>
                    <li><a href="${pageContext.request.contextPath}/equipo">Equipo</a></li>
                    <li><a href="${pageContext.request.contextPath}/contacto">Contacto</a></li>
                    <% if (session.getAttribute("rol") !=null && "ADMIN" .equals(session.getAttribute("rol"))) { %>
                        <li><a href="${pageContext.request.contextPath}/panel">Panel de Gestión</a></li>
                        <% } %>
                            <% if (session.getAttribute("usuarioId") !=null) { %>
                                <li><a href="${pageContext.request.contextPath}/logout">Cerrar Sesión (<%=
                                            session.getAttribute("usuario") %>)</a></li>
                                <% } else { %>
                                    <li><a href="${pageContext.request.contextPath}/login">Login</a></li>
                                    <% } %>
                </ul>
            </nav>
        </header>

        <!-- =====================
     CONTENIDO PRINCIPAL
===================== -->
        <main>
            <div class="page-header">
                <h1>Nuestros Servicios</h1>
                <p>Ofrecemos una amplia gama de tratamientos dentales para cuidar tu salud bucal</p>
            </div>

            <section id="servicios" class="servicios-grid">
                <% java.util.List<com.taller2.model.Servicio> servicios = (java.util.List<com.taller2.model.Servicio>)
                        request.getAttribute("servicios");
                        if (servicios != null && !servicios.isEmpty()) {
                        for (com.taller2.model.Servicio s : servicios) {
                        %>
                        <div class="servicio-card">
                            <img src="${pageContext.request.contextPath}/img/<%= (s.getImagen() != null && !s.getImagen().isEmpty()) ? s.getImagen() : "default.jpg" %>" 
                                alt="<%= s.getNombre() %>"
                                onerror="this.src='${pageContext.request.contextPath}/img/default.jpg'" />
                                <h3>
                                    <%= s.getNombre() %>
                                </h3>
                                <p>
                                    <%= s.getDescripcion() %>
                                </p>
                                <% if (s.getPrecio() !=null) { %>
                                    <p style="font-weight:bold;color:var(--azul-principal);margin-bottom:10px;">$<%=
                                            String.format("%,.0f", s.getPrecio()) %>
                                    </p>
                                    <% } %>
                                        <button class="btn-info"
                                            onclick="window.location.href='${pageContext.request.contextPath}/pedirCita?servicioId=<%= s.getId() %>'">Agendar</button>
                        </div>
                        <% } } else { %>
                            <div style="grid-column: 1/-1; text-align: center;">
                                <p>No hay servicios disponibles en este momento.</p>
                            </div>
                            <% } %>
            </section>
        </main>

        <!-- =====================
     PIE DE PÁGINA
===================== -->
        <footer>
            <p>&copy; 2025 Clínica Dental. Todos los derechos reservados.</p>
            <div class="redes-sociales">
                <a href="#">Facebook</a>
                <a href="#">Instagram</a>
            </div>
        </footer>

        <!-- =====================
     BOTÓN FLOTANTE
===================== -->
        <button class="btn-contacto" onclick="window.location.href='${pageContext.request.contextPath}/pedirCita'">Solicitar Cita</button>

    </body>

    </html>