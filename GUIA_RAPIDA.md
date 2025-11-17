# Guía Rápida - Taller 2

## Requisitos
- Java (JDK 21 instalado, compila a bytecode 11)
- Maven
- GlassFish 6.2.5
- PostgreSQL (db: taller2_bd)

## Compilar
```
mvn clean package
```

## Desplegar WAR
```
asadmin deploy --force target/taller2.war
```

## Ver aplicaciones
```
asadmin list-applications
```

## Reiniciar servidor
```
asadmin restart-domain domain1
```

## Cambiar puerto (ya está en 9000)
```
asadmin set configs.config.server-config.network-config.network-listeners.network-listener.http-listener-1.port=9000
asadmin restart-domain domain1
```

## Probar funcionamiento
- Home: http://localhost:9000/taller2/
- Inicio: http://localhost:9000/taller2/inicio
- Servicios: http://localhost:9000/taller2/servicios
- Equipo: http://localhost:9000/taller2/equipo
- Contacto: http://localhost:9000/taller2/contacto
- Login: http://localhost:9000/taller2/login
- Pedir Turno: http://localhost:9000/taller2/pedirTurno
- Servlet salud: http://localhost:9000/taller2/health

## Logs
```
tail -f /opt/glassfish6/glassfish/domains/domain1/logs/server.log
```

## Redistribuir tras cambios
```
mvn clean package
asadmin deploy --force target/taller2.war
```

## Limpiar despliegue
```
asadmin undeploy taller2
```

## Problemas frecuentes
| Error | Acción |
|-------|--------|
| 404 | Ver mappings y list-applications |
| 500 HttpServlet | Conflicto javax/jakarta -> usar jakarta.servlet-api 5.0.0 |
| Unsupported class file 65 | Asegurar release=11 y recompilar |
| No aparece en list-applications | WAR no desplegado, repetir deploy |

## Health rápido
```
curl -s http://localhost:9000/taller2/health
```
Debe devolver: `OK - Servlet operativo`

## ✅ Estructura Final del Proyecto

```
src/main/webapp/
├── img/                   # ✅ Imágenes (26+ archivos) - Accesibles públicamente
│   ├── logo.png
│   ├── banner.png
│   ├── images.jpg
│   ├── Ortodoncia.jpg
│   ├── Implantes.jpg
│   ├── Endodoncia.png
│   └── ... (más imágenes)
├── WEB-INF/
│   ├── views/            # JSP con CSS y JS INLINE
│   │   ├── inicio.jsp        (18K - CSS + JS inline)
│   │   ├── servicios.jsp     (12K - CSS inline)
│   │   ├── equipo.jsp        (9.7K - CSS inline)
│   │   ├── contacto.jsp      (13K - CSS + JS inline)
│   │   ├── login.jsp         (9.2K - CSS + JS inline)
│   │   └── pedirTurno.jsp    (12K - CSS + JS inline)
│   └── web.xml
└── index.jsp             # Redirige a /inicio

❌ ELIMINADO: css/  (todo el CSS está inline en los JSP)
❌ ELIMINADO: js/   (todo el JS está inline en los JSP)
```

## 🎨 CSS y JavaScript INLINE

**IMPORTANTE**: Todos los archivos JSP ahora tienen CSS y JavaScript inline (embebido).
No hay archivos externos .css o .js que cargar.

### Ventajas del CSS/JS Inline:
- ✅ Menos peticiones HTTP
- ✅ Carga más rápida
- ✅ Sin problemas de rutas relativas
- ✅ Todo autocontenido en cada JSP

## 📱 Páginas Disponibles

Todas estas rutas deberían mostrar estilos completos:

- **Inicio**: http://localhost:9000/taller2/
- **Servicios**: http://localhost:9000/taller2/servicios
- **Equipo**: http://localhost:9000/taller2/equipo
- **Contacto**: http://localhost:9000/taller2/contacto
- **Login**: http://localhost:9000/taller2/login
- **Pedir Turno**: http://localhost:9000/taller2/pedirTurno
- **Health Check**: http://localhost:9000/taller2/health

## Frontend: CSS y JS disponibles
Estructura de assets (ubicados en `src/main/webapp/`):
```
css/
  header-footer.css      # Estilos comunes de header y footer (✅ Creado)
  inicio.css             # Estilos página inicio (✅ Creado)
  servicios.css          # Grid y cards de servicios (✅ Creado)
  equipo.css             # Layout equipo y miembros (✅ Creado)
  contacto.css           # Mapa y tarjetas de contacto (✅ Creado)
  login.css              # Pantalla y formulario de login (✅ Creado)
  pedirTurno.css         # Formulario para solicitar turno (✅ Creado)
js/
  carrusel.js            # Lógica de carrusel de servicios (✅ Creado)
  contacto.js            # Inicialización de sección contacto (✅ Creado)
  login.js               # Comportamiento del formulario login (✅ Creado)
  restricciones.js       # Validaciones y formateo RUT (✅ Creado)
img/                     # Coloca aquí tus imágenes (logo, banner, etc.)
```

**IMPORTANTE**: Si los estilos no se cargan:
1. Verifica que los archivos existan: `ls -la src/main/webapp/css/`
2. Recompila: `mvn clean package`
3. Redesplega: `asadmin deploy --force target/taller2.war`
4. Refresca el navegador con Ctrl+Shift+R (refresh forzado)

### Cómo incluir CSS en un JSP
```jsp
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/inicio.css" />
```

### Cómo incluir JS al final del `<body>`
```jsp
<script src="${pageContext.request.contextPath}/js/carrusel.js"></script>
```

### Buenas prácticas
- Mantén componentes reutilizables en `header-footer.css`.
- Usa nombres coherentes (ej: `turnos.css`, `turnos.js` si agregas módulo de turnos avanzado).
- Evita lógica compleja inline: crea archivos en `js/`.
- Optimiza imágenes (formatos: `.webp` o `.avif` preferentes) dentro de `img/`.

### Agregar un nuevo asset
1. Crear archivo en carpeta correspondiente (`css/` o `js/`).
2. Referenciarlo en el JSP usando `${pageContext.request.contextPath}`.
3. Recompilar y desplegar (los archivos estáticos se empaquetan automáticamente en el WAR).

## Script opcional
Si prefieres automatizar:
```
./desplegar.sh
```
(Compila con Java 11 y despliega el WAR en GlassFish)

---
© 2025 Taller 2
