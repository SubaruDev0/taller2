<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Clínica Dental - Inicio</title>

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
           ESTILOS DE inicio.css
        ===================== */
        body {
            font-family: "Cascadia Code PL", Arial, sans-serif;
            background-color: var(--fondo-claro);
            color: var(--color-fuente);
            min-height: 100vh;
        }

        .banner {
            position: relative;
            display: flex;
            align-items: center;
            justify-content: center;
            height: 500px;
            overflow: hidden;
        }

        .banner img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            opacity: 0.7;
            position: absolute;
            top: 0;
            left: 0;
            z-index: 1;
        }

        .banner-text {
            position: relative;
            z-index: 2;
            width: 80%;
            max-width: 800px;
            margin: 0 auto;
            background: rgba(15, 164, 156, 0.7);
            border-radius: 16px;
            padding: 40px 30px;
            box-shadow: 0px 2px 12px rgba(15, 164, 156, 0.3);
            text-align: center;
            color: white;
        }

        .banner-text h1 {
            font-size: 40px;
            font-weight: 700;
            margin-bottom: 15px;
            text-shadow: 0 2px 8px rgba(0, 0, 0, 0.5);
        }

        .banner-text p {
            font-size: 20px;
            margin-bottom: 25px;
            text-shadow: 0 2px 8px rgba(0, 0, 0, 0.5);
        }

        .btn-banner {
            background-color: var(--color-secundario);
            color: var(--color-fuente);
            border: none;
            border-radius: 50px;
            padding: 12px 30px;
            font-size: 18px;
            font-weight: bold;
            cursor: pointer;
            transition: background-color 0.3s, transform 0.3s;
        }

        .btn-banner:hover {
            background-color: #e5b600;
            transform: scale(1.05);
        }

        #servicios {
            padding: 60px 20px;
            background-color: white;
        }

        .section-title {
            color: var(--azul-principal);
            text-align: center;
            font-size: 32px;
            margin-bottom: 40px;
        }

        .carousel-wrapper {
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 40px auto;
            padding: 0 20px;
            max-width: 1200px;
            position: relative;
        }

        .carousel {
            display: flex;
            overflow-x: auto;
            scroll-behavior: smooth;
            scroll-snap-type: x mandatory;
            gap: 30px;
            justify-content: flex-start;
            padding: 20px 0;
        }

        .carousel .servicio {
            scroll-snap-align: start;
        }

        .carousel .servicio:first-child {
            margin-left: 15px;
        }

        .carousel .servicio:last-child {
            margin-right: 15px;
        }

        .carousel-btn {
            background-color: rgba(15, 164, 156, 0.8);
            border: none;
            color: #fff;
            font-size: 32px;
            padding: 12px 18px;
            cursor: pointer;
            border-radius: 50%;
            transition: background-color 0.3s;
        }

        .carousel-btn:hover {
            background-color: var(--azul-principal);
        }

        .left-btn {
            margin-right: 10px;
        }

        .right-btn {
            margin-left: 10px;
        }

        .servicio {
            background-color: white;
            border-radius: 16px;
            padding: 20px;
            flex: 0 0 calc(33.33% - 20px);
            text-align: center;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
            transition: transform 0.3s ease, box-shadow 0.3s ease;
            display: flex;
            flex-direction: column;
            justify-content: flex-start;
            height: 350px;
            border-top: 4px solid var(--azul-principal);
        }

        .servicio img {
            width: 100%;
            height: 180px;
            object-fit: cover;
            border-radius: 12px;
            margin-bottom: 15px;
        }

        .servicio h3 {
            margin-bottom: 10px;
            color: var(--azul-principal);
            font-size: 20px;
        }

        .servicio p {
            font-size: 15px;
            color: var(--color-fuente);
        }

        .servicio:hover {
            transform: translateY(-10px);
            box-shadow: 0 10px 30px rgba(15, 164, 156, 0.2);
        }

        .ver-mas-container {
            text-align: center;
            margin-top: 30px;
        }

        .btn-ver-mas {
            background-color: transparent;
            color: var(--azul-principal);
            border: 2px solid var(--azul-principal);
            border-radius: 50px;
            padding: 10px 25px;
            font-size: 16px;
            font-weight: bold;
            cursor: pointer;
            transition: all 0.3s;
        }

        .btn-ver-mas:hover {
            background-color: var(--azul-principal);
            color: white;
        }

        #testimonios {
            padding: 60px 40px;
            text-align: center;
            background: var(--fondo-claro);
        }

        #testimonios h2 {
            margin-bottom: 40px;
            font-size: 32px;
            color: var(--azul-principal);
        }

        .testimonios-grid {
            display: flex;
            flex-wrap: wrap;
            gap: 30px;
            justify-content: center;
        }

        .testimonio {
            background: #fff;
            border-radius: 14px;
            padding: 24px 18px;
            width: 280px;
            box-shadow: 0 2px 12px rgba(0, 0, 0, 0.07);
            transition: transform 0.2s, box-shadow 0.2s;
            font-style: italic;
            border-left: 4px solid var(--color-secundario);
        }

        .testimonio:hover {
            transform: translateY(-5px);
            box-shadow: 0 6px 20px rgba(0, 0, 0, 0.13);
        }

        .testimonio p:last-child {
            font-style: normal;
            font-weight: bold;
            margin-top: 10px;
            color: var(--azul-principal);
        }

        #btn-top {
            position: fixed;
            bottom: 20px;
            right: 20px;
            background-color: var(--azul-principal);
            color: #fff;
            border: none;
            border-radius: 10px;
            padding: 15px 20px;
            font-size: 16px;
            cursor: pointer;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.2);
            transition: background-color 0.3s;
        }

        #btn-top:hover {
            background-color: var(--color-hover);
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

            .banner-text h1 {
                font-size: 2rem;
            }

            .banner-text p {
                font-size: 1rem;
            }

            .section-title {
                font-size: 2rem;
            }

            .carousel-btn {
                padding: 10px 15px;
                font-size: 1.2rem;
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
            <li><a href="${pageContext.request.contextPath}/inicio" class="active">Inicio</a></li>
            <li><a href="${pageContext.request.contextPath}/servicios">Servicios</a></li>
            <li><a href="${pageContext.request.contextPath}/equipo">Equipo</a></li>
            <li><a href="${pageContext.request.contextPath}/contacto">Contacto</a></li>
            <li><a href="${pageContext.request.contextPath}/login">Login</a></li>
        </ul>
    </nav>
</header>

<!-- =====================
     BANNER
===================== -->
<section class="banner">
    <img src="${pageContext.request.contextPath}/img/banner.png" alt="Banner principal">

    <div class="banner-text">
        <h1>Bienvenidos a nuestra Clínica Dental</h1>
        <p>Los mejores tratamientos para tu salud bucal</p>

        <button class="btn-banner"
                onclick="window.location.href='${pageContext.request.contextPath}/pedirTurno'">
            Solicitar Cita
        </button>
    </div>
</section>

<!-- =====================
     SERVICIOS
===================== -->
<section id="servicios">
    <h2 class="section-title">Nuestros Servicios</h2>

    <div class="carousel-wrapper">

        <button class="carousel-btn left-btn">&#10094;</button>

        <div class="carousel">

            <div class="servicio">
                <img src="${pageContext.request.contextPath}/img/images.jpg" alt="Odontología General">
                <h3>Odontología General</h3>
                <p>Atención integral para el cuidado de tu salud bucal.</p>
            </div>

            <div class="servicio">
                <img src="${pageContext.request.contextPath}/img/Ortodoncia.jpg" alt="Ortodoncia">
                <h3>Ortodoncia</h3>
                <p>Alinea tus dientes y mejora tu sonrisa.</p>
            </div>

            <div class="servicio">
                <img src="${pageContext.request.contextPath}/img/Implantes.jpg" alt="Implantes">
                <h3>Implantes Dentales</h3>
                <p>Solución permanente para reemplazar dientes perdidos.</p>
            </div>

            <div class="servicio">
                <img src="${pageContext.request.contextPath}/img/Endodoncia.png" alt="Endodoncia">
                <h3>Endodoncia</h3>
                <p>Tratamiento de conductos para salvar tus piezas dentales.</p>
            </div>

            <div class="servicio">
                <img src="${pageContext.request.contextPath}/img/Periodoncia.jpg" alt="Periodoncia">
                <h3>Periodoncia</h3>
                <p>Cuidado y tratamiento especializado de encías.</p>
            </div>

            <div class="servicio">
                <img src="${pageContext.request.contextPath}/img/Blanqueamiento.jpg" alt="Blanqueamiento">
                <h3>Blanqueamiento Dental</h3>
                <p>Recupera la estética y color natural de tu sonrisa.</p>
            </div>
        </div>

        <button class="carousel-btn right-btn">&#10095;</button>

    </div>

    <div class="ver-mas-container">
        <button class="btn-ver-mas"
                onclick="window.location.href='${pageContext.request.contextPath}/servicios'">
            Ver Todos los Servicios
        </button>
    </div>
</section>

<!-- =====================
    TESTIMONIOS
===================== -->
<section id="testimonios">
    <h2>Lo que dicen nuestros pacientes</h2>

    <div class="testimonios-grid">

        <div class="testimonio">
            <p>"Excelente atención y resultados. Muy recomendados."</p>
            <p>- Juan Pérez</p>
            <p>⭐⭐⭐⭐⭐</p>
            <p>Servicio: Ortodoncia</p>
        </div>

        <div class="testimonio">
            <p>"Profesionales y amables. Me hicieron sentir muy cómoda."</p>
            <p>- Rosa López</p>
            <p>⭐⭐⭐⭐</p>
            <p>Servicio: Blanqueamiento</p>
        </div>

        <div class="testimonio">
            <p>"El tratamiento de implantes fue impecable."</p>
            <p>- Luis Fernández</p>
            <p>⭐⭐⭐⭐⭐</p>
            <p>Servicio: Implantes Dentales</p>
        </div>

    </div>
</section>

<!-- =====================
     FOOTER
===================== -->
<footer>
    <p>&copy; 2025 Clínica Dental. Todos los derechos reservados.</p>
    <div class="redes-sociales">
        <a href="#">Facebook</a>
        <a href="#">Instagram</a>
    </div>
</footer>

<button id="btn-top" style="display:none;">Volver Arriba</button>

<!-- =====================
     JAVASCRIPT INLINE
===================== -->
<script>
document.addEventListener('DOMContentLoaded', () => {

    // 1. SELECCIÓN DE ELEMENTOS DEL DOM
    const carousel = document.querySelector('.carousel');
    const leftBtn = document.querySelector('.left-btn');
    const rightBtn = document.querySelector('.right-btn');
    const cards = carousel.querySelectorAll('.servicio');

    // Salir si los elementos no existen para evitar errores
    if (!carousel || !leftBtn || !rightBtn || cards.length === 0) {
        console.error("No se encontraron todos los elementos necesarios para el carrusel.");
        return;
    }

    // 2. CONFIGURACIÓN DE CONSTANTES
    const GAP = 30;
    const AUTO_SCROLL_INTERVAL = 3000;
    const scrollAmount = cards[0].offsetWidth + GAP;

    // 3. LÓGICA DE NAVEGACIÓN
    function handleLeftClick() {
        if (carousel.scrollLeft <= 0) {
            carousel.scrollTo({
                left: carousel.scrollWidth,
                behavior: 'smooth'
            });
        } else {
            carousel.scrollBy({
                left: -scrollAmount,
                behavior: 'smooth'
            });
        }
    }

    function handleRightClick() {
        const scrollTolerance = 1;
        if (carousel.scrollLeft + carousel.clientWidth + scrollTolerance >= carousel.scrollWidth) {
            carousel.scrollTo({
                left: 0,
                behavior: 'smooth'
            });
        } else {
            carousel.scrollBy({
                left: scrollAmount,
                behavior: 'smooth'
            });
        }
    }

    leftBtn.addEventListener('click', handleLeftClick);
    rightBtn.addEventListener('click', handleRightClick);

    // 4. AUTO-SCROLL INFINITO
    let autoScrollId;

    function startAutoScroll() {
        stopAutoScroll();
        autoScrollId = setInterval(() => {
            const scrollTolerance = 1;
            if (carousel.scrollLeft + carousel.clientWidth + scrollTolerance >= carousel.scrollWidth) {
                carousel.scrollTo({
                    left: 0,
                    behavior: 'smooth'
                });
            } else {
                carousel.scrollBy({
                    left: scrollAmount,
                    behavior: 'smooth'
                });
            }
        }, AUTO_SCROLL_INTERVAL);
    }

    function stopAutoScroll() {
        clearInterval(autoScrollId);
    }

    carousel.addEventListener('mouseenter', stopAutoScroll);
    carousel.addEventListener('mouseleave', startAutoScroll);

    startAutoScroll();

    // BOTÓN "VOLVER ARRIBA"
    const btnTop = document.getElementById("btn-top");
    if (btnTop) {
        window.addEventListener('scroll', () => {
            const isScrolled = window.scrollY > 200 || document.documentElement.scrollTop > 200;
            btnTop.style.display = isScrolled ? "block" : "none";
        });

        btnTop.addEventListener('click', () => {
            window.scrollTo({
                top: 0,
                behavior: 'smooth'
            });
        });
    } else {
        console.warn("El botón 'Volver Arriba' no fue encontrado.");
    }
});
</script>
</body>
</html>
