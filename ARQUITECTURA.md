# Arquitectura y Patrones - Taller 2

## Objetivo
Este documento resume las decisiones técnicas clave del proyecto y los patrones aplicados.

## Stack
- Java 11 (bytecode 55) compilado sobre JDK 21 usando release=11
- Jakarta Servlet API 5.0.0 (GlassFish 6.x)
- PostgreSQL (Base de datos: `taller2_bd`)
- Maven (packaging WAR)
- Servidor: GlassFish 6.2.5 (puerto HTTP configurado: 9000)

## Módulos Principales
```
src/main/java/com/taller2/
├── controller/      -> Servlets (capa presentación)
│   ├── HomeController.java
│   └── HealthServlet.java
├── util/            -> Utilidades (Singleton de conexión futura)
└── dao/             -> Preparado para futuros DAOs
```

## Patrón MVC (simplificado)
- Modelo: (Aún no implementado, carpeta `model/` lista para entidades futuras)
- Vista: JSP en `WEB-INF/views/home.jsp`
- Controlador: Servlets (`HomeController`, `HealthServlet`)

## Patrón Singleton (Conexión BD)
`DatabaseConnection` (cuando se reactive):
- Asegura una única instancia de conexión JDBC.
- Re-conecta automáticamente si la conexión fue cerrada.
- Ejemplo de uso:
```java
Connection conn = DatabaseConnection.getInstance().getConnection();
```

## Flujo de Petición
1. Usuario accede `http://localhost:9000/taller2/`
2. GlassFish resuelve contexto `/taller2`
3. Servlet `HomeController` atiende `/` y `/home`
4. Forward interno a `WEB-INF/views/home.jsp`
5. JSP renderiza datos

## Convenciones
- Servlets anotados con `@WebServlet`
- JSPs dentro de `WEB-INF` (no accesibles directos por URL)
- Nada de lógica de negocio en JSP
- Código preparado para añadir capas: `model`, `dao`

## Despliegue
- WAR generado: `target/taller2.war`
- Despliegue con:
```
asadmin deploy --force target/taller2.war
```

## Errores Solucionados
| Problema | Causa | Solución |
|----------|-------|----------|
| 404 root | Falta welcome / mappings | Añadir servlet mapping + index.jsp |
| 500 HttpServlet | Mezcla javax/jakarta | Unificar jakarta.servlet-api 5.0.0 |
| Unsupported class file 65 | Bytecode Java 21 | usar release=11 en compiler |
| No despliega dependencia EE | API completa innecesaria | Usar solo servlet-api |

## Próximos Pasos (Sugeridos)
1. Añadir entidad `Usuario` y tabla en BD.
2. Crear `UsuarioDAO` con CRUD básico.
3. Integrar conexión JDBC en `HomeController` (volver a activar DatabaseConnection).
4. Añadir tests (JUnit + Maven Surefire).
5. Implementar filtro (`jakarta.servlet.Filter`) para logging.

## Extensiones Futuras
- Seguridad (Auth y roles) usando filtros.
- Internacionalización (i18n) para mensajes.
- Paginación y DAO genérico.

## Health Check
`GET /taller2/health` -> Respuesta plano: `OK - Servlet operativo`

## Formato de Código
- Java 11
- Indentación 4 espacios
- Mensajes de log simples (System.out/err) para esta etapa inicial.

## Decisiones Clave
- Minimizar dependencias para evitar conflictos de javax vs jakarta.
- Mantener WAR pequeño y simple para entorno educativo.

---
© 2025 Taller 2

