<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Clínica Dental | Registro</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Cascadia+Code+PL:wght@400;700&display=swap" rel="stylesheet">
    <style>
:root{--azul-principal:#0fa49c;--color-secundario:#ffca1c;--fondo-claro:#087872;--fondo-tarjeta:#ffffff;--color-fuente:#000000}body{margin:0;font-family:'Cascadia Code PL',monospace;background-color:var(--fondo-claro);display:flex;justify-content:center;align-items:center;min-height:100vh;overflow:hidden;color:var(--color-fuente)}.oculto{display:none!important}.contenedor-logo.ocultar-final{display:none!important}.pantalla-inicial.ocultar-fondo-blanco{background-color:transparent!important;z-index:1}.pantalla-inicial{position:fixed;top:0;left:0;width:100%;height:100%;display:flex;justify-content:center;align-items:center;background-color:var(--fondo-claro);z-index:100}.expansor-azul{width:100%;height:100%;background-color:var(--azul-principal);position:absolute;transform:scaleX(0);transform-origin:center center;animation:expandir-horizontalmente 0.8s cubic-bezier(0.65,0.05,0.36,1) forwards;z-index:99}.contenedor-logo{opacity:0;position:absolute;z-index:101;perspective:1000px}.logo-clinica{width:1200px;height:auto;display:block}.contenedor-logo.mostrar-logo{animation:rotar-logo 0.7s ease-out forwards}.contenedor-logo.desvanecer{animation:rotar-y-desvanecer 0.6s ease-in forwards}.contenedor-login{display:flex;justify-content:center;align-items:center;width:100%;height:100vh;max-width:550px;transform:scaleX(0);transform-origin:center center;opacity:0;z-index:50;background-color:var(--fondo-tarjeta);box-shadow:0 0 30px rgba(0,0,0,0.2)}.contenedor-login.visible{opacity:1;animation:aparecer-horizontal 0.8s cubic-bezier(0.65,0.05,0.36,1) forwards}.tarjeta-login{padding:60px;max-width:490px;width:100%;text-align:center;min-width:100%;box-sizing:border-box;background-color:transparent;box-shadow:none}.encabezado-login{margin-bottom:40px}h2{font-size:2.0rem;color:var(--azul-principal);margin:0}.grupo-entrada{position:relative;text-align:left;margin-bottom:40px}.grupo-entrada input{width:100%;padding:12px 0 5px 0;margin-bottom:5px;font-size:1.2rem;color:var(--azul-principal);border:none;border-bottom:2px solid #ccc;outline:none;background:transparent;box-sizing:border-box;transition:border-color 0.3s}.grupo-entrada input:focus{border-color:var(--azul-principal);box-shadow:none}.grupo-entrada label{position:absolute;top:12px;left:0;padding:0;font-size:1.2rem;color:#999;pointer-events:none;transition:0.5s;display:flex;align-items:center}.grupo-entrada label i{margin-right:12px;color:#999;font-size:1.4rem;transition:0.5s}.grupo-entrada input:focus+label,.grupo-entrada input:valid+label{top:-25px;left:0;color:var(--azul-principal);font-size:0.9rem}.grupo-entrada input:focus+label i,.grupo-entrada input:valid+label i{color:var(--azul-principal)}.boton-acceso{width:100%;padding:18px;background-color:var(--color-secundario);color:var(--color-fuente);border:none;border-radius:10px;font-size:1.4rem;cursor:pointer;transition:background-color 0.3s;font-weight:bold;margin-bottom:20px}.boton-acceso:hover{background-color:#e5b600}.mensaje-error{color:#cc0000;font-size:0.9rem;font-weight:bold;margin-bottom:20px;padding:10px;border:1px solid #ffcccc;background-color:#ffebeb;border-radius:5px;text-align:center}@keyframes expandir-horizontalmente{to{transform:scaleX(1)}}@keyframes rotar-logo{0%{transform:rotateY(-90deg);opacity:0}50%{transform:rotateY(0deg);opacity:1}100%{transform:rotateY(0deg);opacity:1}}@keyframes rotar-y-desvanecer{0%{transform:rotateY(0deg);opacity:1}100%{transform:rotateY(90deg);opacity:0}}@keyframes aparecer-horizontal{0%{transform:scaleX(0)}100%{transform:scaleX(1)}}@media(max-width:480px){.contenedor-login{max-width:100%;box-shadow:none}.tarjeta-login{padding:40px 30px}h2{font-size:1.7rem;margin-bottom:30px}.grupo-entrada{margin-bottom:30px}.boton-acceso{padding:15px;font-size:1.2rem}}
    </style>
</head>
<body>
<div class="pantalla-inicial">
    <div class="expansor-azul"></div>
    <div class="contenedor-logo">
        <img src="${pageContext.request.contextPath}/img/logo.png" alt="Logo Clínica Dental" class="logo-clinica">
    </div>
</div>
<div class="contenedor-login oculto">
    <div class="tarjeta-login">
        <div class="encabezado-login">
            <h2>Crear Cuenta</h2>
        </div>
        <form class="formulario-login" method="POST" action="${pageContext.request.contextPath}/registro">
            <div class="grupo-entrada">
                <input type="text" id="nombreCompleto" name="nombreCompleto" required>
                <label for="nombreCompleto"><i class="fas fa-id-card"></i> Nombre Completo</label>
            </div>
            <div class="grupo-entrada">
                <input type="text" id="usuario" name="usuario" required>
                <label for="usuario"><i class="fas fa-user"></i> Usuario</label>
            </div>
            <div class="grupo-entrada">
                <input type="email" id="email" name="email" required>
                <label for="email"><i class="fas fa-envelope"></i> Email</label>
            </div>
            <div class="grupo-entrada">
                <input type="password" id="contrasena" name="contrasena" required>
                <label for="contrasena"><i class="fas fa-lock"></i> Contraseña</label>
            </div>
            <div class="grupo-entrada">
                <input type="password" id="confirmarContrasena" name="confirmarContrasena" required>
                <label for="confirmarContrasena"><i class="fas fa-lock"></i> Confirmar Contraseña</label>
            </div>
            <div id="mensajeError" class="mensaje-error <%= request.getAttribute("error") == null ? "oculto" : "" %>">
                <% if (request.getAttribute("error") != null) { %><%= request.getAttribute("error") %><% } %>
            </div>
            <button type="submit" class="boton-acceso">Registrarse</button>
            <div style="margin-top:25px;text-align:center;font-size:1rem;">
                <span style="color:#666;">¿Ya tienes cuenta?</span>
                <a href="${pageContext.request.contextPath}/login" style="color:var(--azul-principal);font-weight:bold;text-decoration:none;margin-left:5px;">Inicia sesión aquí</a>
            </div>
        </form>
    </div>
</div>
<script>
document.addEventListener('DOMContentLoaded',()=>{const e=document.querySelector('.contenedor-logo'),o=document.querySelector('.pantalla-inicial'),t=document.querySelector('.contenedor-login'),n=c=>new Promise(e=>setTimeout(e,c));(async()=>{try{await n(800),e.classList.add('mostrar-logo'),await n(1500),e.classList.remove('mostrar-logo'),e.classList.add('desvanecer'),await n(600),e.classList.add('ocultar-final'),o.classList.add('ocultar-fondo-blanco'),t.classList.remove('oculto'),t.classList.add('visible')}catch(e){console.error('Error durante la secuencia de animación:',e)}})()});
</script>
</body>
</html>
