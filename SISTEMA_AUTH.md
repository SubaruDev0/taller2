# 🔐 Sistema de Autenticación - Clínica Dental

## 📋 Usuarios del Sistema

### 👨‍💼 Administradores (ADMIN)
Los administradores tienen acceso completo al sistema, incluyendo el Panel de Gestión.

| Usuario | Contraseña | Nombre Completo | Permisos |
|---------|------------|-----------------|----------|
| `Subaru` | `123` | Subaru Admin | ✅ Panel de Gestión, ✅ Pedir Turnos, ✅ Ver todo |
| `Matias` | `123` | Matias Admin | ✅ Panel de Gestión, ✅ Pedir Turnos, ✅ Ver todo |
| `Antonio` | `1234` | Antonio Admin | ✅ Panel de Gestión, ✅ Pedir Turnos, ✅ Ver todo |

### 👤 Usuarios Normales (USUARIO)
Los usuarios normales pueden pedir turnos pero no tienen acceso al panel administrativo.

| Usuario | Contraseña | Nombre Completo | Permisos |
|---------|------------|-----------------|----------|
| `Blas` | `123` | Blas Usuario | ❌ Panel de Gestión, ✅ Pedir Turnos, ✅ Ver todo |

### 🌐 Modo Invitado
- Permite navegar por toda la web
- **NO** permite pedir turnos
- Muestra mensaje: "Debes iniciar sesión para pedir turno"

## 🎯 Funcionalidades por Tipo de Usuario

### Administradores:
1. **Panel de Gestión** (`/panel`)
   - Ver lista completa de usuarios
   - Gestionar servicios dentales (en desarrollo)
   - Ver turnos programados (en desarrollo)
   - Moderar comentarios (en desarrollo)

2. **Header personalizado**
   - Muestra opción "Panel de Gestión"
   - Muestra "Cerrar Sesión (usuario)"

3. **Acceso completo**
   - Todas las páginas
   - Formulario de pedir turno

### Usuarios Normales:
1. **Sin Panel de Gestión**
   - No ven la opción en el header
   - Si intentan acceder a `/panel`, son redirigidos a `/inicio`

2. **Header personalizado**
   - Muestra "Cerrar Sesión (usuario)"
   - NO muestra "Panel de Gestión"

3. **Puede pedir turnos**
   - Acceso al formulario completo
   - Guardar citas (funcionalidad futura)

### Invitados:
1. **Navegación libre**
   - Pueden ver: Inicio, Servicios, Equipo, Contacto

2. **Restricción de turnos**
   - Al intentar acceder a `/pedirTurno` ven mensaje:
   - "Para solicitar un turno debes iniciar sesión con una cuenta registrada"
   - Botón para ir a Login

3. **Header básico**
   - Solo muestra "Login"

## 🔑 Flujo de Autenticación

```
┌─────────────────┐
│   /login        │
│  (Página Login) │
└────────┬────────┘
         │
         ├─────────────────────────────────────────┐
         │                                         │
         v                                         v
┌────────────────────┐                   ┌──────────────────┐
│ Acceso con         │                   │ Acceso como      │
│ Credenciales       │                   │ Invitado         │
└─────────┬──────────┘                   └────────┬─────────┘
          │                                       │
          │ Valida en BD                          │
          ├──────────┬──────────┐                 │
          v          v          v                 v
      ┌─────┐   ┌──────┐   ┌──────┐      ┌────────────┐
      │ADMIN│   │USUARIO│  │ERROR │      │session:    │
      └──┬──┘   └───┬──┘   └──┬───┘      │INVITADO    │
         │          │          │          └─────┬──────┘
         │          │          │                │
         v          v          v                v
    ┌────────────────────────────┐      ┌──────────────┐
    │ session: usuarioId, rol,   │      │ Puede navegar│
    │ usuario, nombreUsuario     │      │ NO puede     │
    │                            │      │ pedir turnos │
    │ → Acceso al Panel          │      └──────────────┘
    │ → Puede pedir turnos       │
    └────────────────────────────┘
```

## 🛠️ Estructura de Base de Datos

### Tabla: `usuarios`
```sql
CREATE TABLE usuarios (
    id SERIAL PRIMARY KEY,
    usuario VARCHAR(50) UNIQUE NOT NULL,
    contrasena VARCHAR(255) NOT NULL,
    rol VARCHAR(20) CHECK (rol IN ('ADMIN', 'USUARIO')),
    nombre_completo VARCHAR(100),
    email VARCHAR(100),
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    activo BOOLEAN DEFAULT TRUE
);
```

## 📡 Endpoints del Sistema

| Endpoint | Método | Descripción | Requiere Auth |
|----------|--------|-------------|---------------|
| `/login` | GET | Muestra página de login | ❌ No |
| `/login` | POST | Procesa autenticación | ❌ No |
| `/logout` | GET/POST | Cierra sesión | ✅ Sí |
| `/panel` | GET | Panel de gestión | ✅ Sí (ADMIN) |
| `/pedirTurno` | GET | Formulario de turno | ✅ Sí (USUARIO/ADMIN) |
| `/inicio`, `/servicios`, `/equipo`, `/contacto` | GET | Páginas públicas | ❌ No |

## 🧪 Probar el Sistema

### 1. Iniciar como Administrador:
```
Usuario: Subaru
Contraseña: 123
```
✅ Debería ver "Panel de Gestión" en el header
✅ Puede acceder a http://localhost:9000/taller2/panel

### 2. Iniciar como Usuario Normal:
```
Usuario: Blas
Contraseña: 123
```
❌ NO debe ver "Panel de Gestión" en el header
✅ Puede acceder a http://localhost:9000/taller2/pedirTurno

### 3. Acceder como Invitado:
- Click en "Acceder como invitado"
✅ Puede navegar por todas las páginas
❌ Al ir a `/pedirTurno` ve mensaje "Debes iniciar sesión"

## 🔒 Seguridad

### Validaciones Implementadas:
1. **Verificación de sesión** en `PanelGestionServlet`
   - Redirige a `/login` si no está autenticado
   - Redirige a `/inicio` si no es ADMIN

2. **Verificación en JSP** (`pedirTurno.jsp`)
   - Muestra formulario solo si `usuarioId` existe en sesión
   - Bloquea invitados con mensaje

3. **Headers condicionales**
   - "Panel de Gestión" solo si `rol == ADMIN`
   - "Cerrar Sesión (usuario)" solo si `usuarioId` existe

### ⚠️ Mejoras de Seguridad Futuras:
- [ ] Encriptar contraseñas con BCrypt
- [ ] Implementar HTTPS
- [ ] Tokens CSRF para formularios
- [ ] Rate limiting en login
- [ ] Logs de acceso

## 📝 Notas Importantes

1. **Las contraseñas NO están encriptadas** (solo para desarrollo)
2. La tabla `servicios` se crea con datos de ejemplo
3. Las tablas `turnos` y `comentarios` están vacías, listas para desarrollo futuro
4. El Panel de Gestión muestra solo la tabla de usuarios por ahora

## 🚀 Próximos Pasos

- [ ] Implementar CRUD completo de servicios en el panel
- [ ] Sistema de gestión de turnos/citas
- [ ] Moderación de comentarios
- [ ] Envío de emails de confirmación
- [ ] Dashboard con estadísticas
- [ ] Exportar datos a PDF/Excel
