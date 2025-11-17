<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Información de Contacto | Clínica Dental</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <style>
:root{--azul-principal:#0fa49c;--azul-claro:#087872;--color-secundario:#ffca1c;--fondo-claro:#f0f9f8;--fondo-tarjeta:#ffffff;--color-fuente:#333333;--color-hover:#0d8c85;--fondo-gris:#f4f7fb;--color-texto:#222}*{margin:0;padding:0;box-sizing:border-box;font-family:"Segoe UI",sans-serif}body{background:var(--fondo-gris);min-height:100vh;display:flex;flex-direction:column}a{text-decoration:none;color:var(--azul-principal)}header{display:flex;justify-content:space-between;align-items:center;padding:15px 40px;background:var(--azul-principal);color:#fff;height:120px;box-shadow:0 2px 10px rgba(0,0,0,0.1)}.logo img{width:300px;height:auto}nav ul{display:flex;list-style:none;gap:25px}nav a{color:#fff;text-decoration:none;font-weight:500;font-size:16px;padding:8px 12px;border-radius:5px;transition:background-color 0.3s}nav a:hover,nav a.active{background-color:var(--color-hover)}footer{background:var(--azul-principal);color:white;text-align:center;padding:25px 20px;margin-top:auto}footer .redes-sociales{margin-top:12px;display:flex;justify-content:center;gap:18px}footer .redes-sociales a{text-decoration:none;color:#f5f7fa;font-weight:bold;transition:color 0.3s}footer .redes-sociales a:hover{color:var(--color-secundario)}.container{flex:1;display:grid;grid-template-rows:auto 1fr;grid-template-columns:2fr 1fr;grid-template-areas:"mapa-titulo info-cards" "mapa-ubicacion info-cards";gap:0 30px;background:var(--fondo-tarjeta);margin:40px auto;padding:30px;border-radius:16px;box-shadow:0 6px 15px rgba(0,0,0,0.1);max-width:1200px;width:90%}.mapa-titulo{grid-area:mapa-titulo;color:var(--azul-principal);font-size:1.8em;padding-bottom:10px;border-bottom:3px solid var(--color-secundario);margin-bottom:25px}#mapa-ubicacion{grid-area:mapa-ubicacion;height:100%;background:#e0e0e0;border-radius:12px;overflow:hidden;box-shadow:0 4px 10px rgba(0,0,0,0.1);position:relative;padding:0;display:flex;flex-direction:column}#mapa-ubicacion h2{display:none}#mapa-interactivo-div{width:100%;flex-grow:1}.mapa-placeholder{position:absolute;top:50%;left:50%;transform:translate(-50%,-50%);color:#666;text-align:center;padding:20px}.info-cards{grid-area:info-cards;display:flex;flex-direction:column;gap:30px}.carrusel-sedes-wrapper{padding:15px;background-color:var(--fondo-tarjeta);border-top:1px solid #ddd;box-shadow:0 -2px 5px rgba(0,0,0,0.05);flex-shrink:0}.carrusel-sedes-wrapper h3{font-size:1.1em;color:var(--azul-principal);margin-bottom:10px}.carrusel-sedes-wrapper h3 i{margin-right:8px;color:var(--color-secundario)}.carrusel-sedes{display:flex;overflow-x:scroll;padding-bottom:10px;gap:15px;-webkit-overflow-scrolling:touch;scrollbar-width:thin}.carrusel-sedes::-webkit-scrollbar{height:8px}.carrusel-sedes::-webkit-scrollbar-thumb{background:rgba(0,0,0,0.15);border-radius:10px}.sede-card{flex-shrink:0;width:250px;background-color:var(--fondo-tarjeta);border-radius:8px;box-shadow:0 2px 5px rgba(0,0,0,0.1);transition:box-shadow 0.3s,transform 0.3s;cursor:default;border:1px solid #ddd;overflow:hidden;padding:0}.sede-card:hover{box-shadow:0 5px 15px rgba(0,0,0,0.2);transform:translateY(-3px)}.sede-card-img-container{width:100%;height:120px;overflow:hidden}.sede-card-img{width:100%;height:100%;object-fit:cover;transition:transform 0.3s ease}.sede-card:hover .sede-card-img{transform:scale(1.05)}.sede-card h4{margin:10px 15px 5px 15px;color:var(--azul-principal);font-size:1.1em}.sede-card p{font-size:0.85em;color:#555;margin:0 15px 5px 15px;padding-bottom:5px}.sede-card p i{color:var(--color-secundario);margin-right:5px}.tarjeta{padding:30px;border-radius:12px;background:var(--fondo-tarjeta);box-shadow:0 4px 10px rgba(0,0,0,0.15);transition:transform 0.3s ease,box-shadow 0.3s ease}.tarjeta:hover{transform:translateY(-5px);box-shadow:0 8px 20px rgba(0,0,0,0.2)}.tarjeta h3{margin-bottom:15px;color:var(--azul-principal);font-size:1.5em;border-bottom:3px solid var(--color-secundario);padding-bottom:10px;display:flex;align-items:center}.tarjeta h3 i{margin-right:10px;color:var(--color-secundario)}.horario-info .time-slot{font-size:1.8em;font-weight:bold;color:var(--color-secundario);margin-top:5px}.contacto-info{border-left:5px solid var(--azul-principal)}.var-item{margin-bottom:20px}.var-item span{font-size:0.9em;color:#666;font-weight:500;display:block;margin-bottom:5px}.var-value{font-size:1.1em;font-weight:bold;color:var(--color-texto);display:flex;justify-content:space-between;align-items:center}.var-value a{color:var(--azul-principal);transition:color 0.3s}.var-value a:hover{color:var(--color-hover)}.var-value i{font-size:1.3em;color:var(--color-secundario)}.redes-var{display:flex;flex-direction:column}.redes-titulo{font-size:0.9em;color:#666;font-weight:500;margin-bottom:8px}.redes-var .var-value{display:flex;gap:15px;justify-content:flex-start}.redes-var .var-value a{font-size:1.6em;color:var(--azul-principal);transition:color 0.3s,transform 0.3s}.redes-var .var-value a:hover{color:var(--color-secundario);transform:scale(1.15)}@media(max-width:768px){header{flex-direction:column;height:auto;padding:15px;gap:15px}.logo img{width:200px}nav ul{flex-wrap:wrap;justify-content:center;gap:10px}.container{grid-template-columns:1fr;grid-template-areas:"mapa-titulo" "mapa-ubicacion" "info-cards";padding:20px;margin:20px auto;width:95%}.mapa-titulo{font-size:1.4em}#mapa-ubicacion{min-height:300px}.info-cards{gap:20px}.tarjeta{padding:20px}.tarjeta h3{font-size:1.3em}.carrusel-sedes-wrapper h3{font-size:1em}.sede-card{width:220px}}
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
            <li><a href="${pageContext.request.contextPath}/contacto" class="active">Contacto</a></li>
            <li><a href="${pageContext.request.contextPath}/login">Login</a></li>
        </ul>
    </nav>
</header>
<main class="container">
    <h2 class="mapa-titulo">Sede Principal: Concepción</h2>
    <section id="mapa-ubicacion" class="section">
        <div id="mapa-interactivo-div">
            <iframe width="100%" height="100%" frameborder="0" style="border:0" referrerpolicy="no-referrer-when-downgrade" src="https://maps.google.com/maps?q=Arturo%20Prat%20450,%20Concepci%C3%B3n&t=&z=15&ie=UTF8&iwloc=&output=embed" allowfullscreen loading="lazy"></iframe>
        </div>
        <div class="carrusel-sedes-wrapper">
            <h3><i class="fas fa-city"></i> Nuestras Otras Sucursales</h3>
            <div id="carrusel-sedes" class="carrusel-sedes"></div>
        </div>
    </section>
    <section class="info-cards">
        <article class="tarjeta horario-info">
            <h3><i class="fas fa-clock"></i> Horario de Atención</h3>
            <p>Lunes – Viernes:</p>
            <p class="time-slot">09:00 — 17:30</p>
            <p style="margin-top:15px;">Sábados no festivos:</p>
            <p class="time-slot" style="font-size:1.4em;">09:00 — 14:00</p>
            <p style="margin-top:15px;font-size:0.9em;color:#888;">Atención solo con cita previa. Domingos y festivos cerrado.</p>
        </article>
        <article class="tarjeta contacto-info">
            <h3><i class="fas fa-id-badge"></i> Contacto Central</h3>
            <div class="var-item">
                <span>Teléfono Central</span>
                <a href="tel:+56912345678" class="var-value">+56 9 1234 5678 <i class="fas fa-phone-alt"></i></a>
            </div>
            <div class="var-item">
                <span>Correo Electrónico</span>
                <a href="mailto:contacto@centrodental.cl" class="var-value">contacto@centrodental.cl <i class="fas fa-envelope"></i></a>
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
<footer>
    <p>© 2025 Clínica Dental. Todos los derechos reservados.</p>
    <div class="redes-sociales">
        <a href="#"><i class="fab fa-facebook-f"></i> Facebook</a>
        <a href="#"><i class="fab fa-instagram"></i> Instagram</a>
    </div>
</footer>
<script>
const contextPath='${pageContext.request.contextPath}';
const branchesData=[{id:"concepcion",name:"Sede Principal — Concepción",address:"Arturo Prat 450, Concepción",phone:"+56412345678",email:"concepcion@ejemplo.cl",image:contextPath+"/img/sede-concepcion.jpg"},{id:"santiago",name:"Santiago",address:"Avenida Libertador Bernardo O'Higgins 100, Santiago",phone:"+56298765432",email:"santiago@ejemplo.cl",image:contextPath+"/img/sede-santiago.jpg"},{id:"valparaiso",name:"Valparaíso",address:"Condell 1500, Valparaíso",phone:"+56325432109",email:null,image:contextPath+"/img/sede-valparaiso.jpg"},{id:"vinadelmar",name:"Viña del Mar",address:"Calle Valparaíso 500, Viña del Mar",phone:"+56321098765",email:"vina@ejemplo.cl",image:contextPath+"/img/sede-vina.jpg"},{id:"puntaarenas",name:"Punta Arenas",address:"Avenida Colón 900, Punta Arenas",phone:"+56616789012",email:"puntaarenas@ejemplo.cl",image:contextPath+"/img/sede-puntaarenas.jpeg"},{id:"copiapo",name:"Copiapó",address:"Calle O'Higgins 700, Copiapó",phone:"+56523456789",email:"atacama@ejemplo.cl",image:contextPath+"/img/sede-copiapo.jpg"}];function renderCarruselSedes(){const e=document.getElementById("carrusel-sedes");if(!e)return void console.error("No se encontró el contenedor del carrusel de sedes");const a=branchesData.filter((e=>"concepcion"!==e.id));let o="";a.forEach((e=>{const a=e.name.includes("—")?e.name.split("—")[0].trim():e.name,d=e.address.split(",")[0].trim();o+=`\n            <div class="sede-card" role="article" aria-label="Sede ${a}">\n                <div class="sede-card-img-container">\n                    <img src="${e.image}" \n                         alt="Fachada de la Sede ${a}" \n                         class="sede-card-img"\n                         onerror="this.src='${contextPath}/img/sede-default.jpg'">\n                </div>\n                <h4>${a}</h4>\n                <p><i class="fas fa-phone-alt"></i> ${e.phone}</p>\n                <p style="padding-bottom: 15px;">\n                    <i class="fas fa-map-marker-alt"></i> ${d}\n                </p>\n            </div>\n        `})),e.innerHTML=o}function inicializarMapa(){const e=document.getElementById("mapa-interactivo-div");if(!e)return void console.warn("No se encontró el contenedor del mapa");const a=e.querySelector("iframe");a&&(a.addEventListener("load",(function(){console.log("Mapa de Google cargado correctamente")})),a.addEventListener("error",(function(){console.error("Error al cargar el mapa de Google"),mostrarPlaceholderMapa()})))}function mostrarPlaceholderMapa(){const e=document.getElementById("mapa-interactivo-div");e&&(e.innerHTML='\n            <div class="mapa-placeholder">\n                <i class="fas fa-map-marked-alt" style="font-size: 3em; color: #666; margin-bottom: 15px;"></i>\n                <h3>Mapa no disponible</h3>\n                <p>No se pudo cargar el mapa interactivo.</p>\n                <p><strong>Dirección:</strong> Arturo Prat 450, Concepción</p>\n            </div>\n        ')}function agregarBotonFlotante(){if(!document.querySelector(".btn-pedir-turno")){const e=document.createElement("button");e.className="btn-pedir-turno",e.textContent="Pedir Turno",e.onclick=function(){window.location.href=contextPath+"/pedirTurno"},document.body.appendChild(e)}}document.addEventListener("DOMContentLoaded",(function(){console.log("Inicializando página de contacto..."),renderCarruselSedes(),inicializarMapa(),agregarBotonFlotante(),console.log("Página de contacto inicializada correctamente")})),window.addEventListener("error",(function(e){console.error("Error en la página de contacto:",e.error)}));
</script>
</body>
</html>
