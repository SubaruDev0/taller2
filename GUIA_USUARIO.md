# Guía de Usuario - Clínica Dental

## Registro e Inicio de Sesión

- Acceda a `/login`.
- Complete los campos **Usuario** y **Contraseña**.
- Si no tiene cuenta, registre una en `/registro`.

## Navegación Principal

- **Inicio**: muestra el carrusel de servicios.
- **Servicios**: lista todos los servicios con imágenes.
- **Equipo**: información del personal.
- **Contacto**: formulario de contacto.
- **Panel** (solo admin): gestión de servicios y citas.

## Solicitar una Cita

1. Vaya a **Servicios**.
2. Haga clic en **Agendar** del servicio deseado.
3. En la página de solicitud, el servicio se pre‑selecciona automáticamente.
4. Complete los datos personales, seleccione fecha y horario.
5. Envíe el formulario.
6. Aparecerá un mensaje de éxito y la cita quedará visible en el **Panel** de administración.

## Gestión de Servicios (Panel de Administración)

- **Agregar Servicio**: use el formulario con drag‑and‑drop para subir una imagen.
- **Editar**: modifique los campos y cambie la imagen si lo desea.
- **Eliminar**: botón rojo elimina el registro.

## Gestión de Citas (Panel de Administración)

- Visualice la lista de citas pendientes.
- Cambie el estado (PENDIENTE, CONFIRMADA, CANCELADA).
- Elimine citas si es necesario.

## Preguntas Frecuentes

- **¿Cómo subir imágenes?** Use el área de arrastre o el selector de archivos; la imagen se guarda en `/img`.
- **¿Qué pasa si olvido mi contraseña?** Actualmente no hay recuperación; contacte al administrador.
- **¿Puedo cancelar una cita?** No, solo el administrador puede cambiar su estado.
- **¿Qué tecnologías usa la aplicación?** Java 11, JSP, Servlets, PostgreSQL, HTML5, CSS, JavaScript (Fetch API).

---
*Esta guía está pensada para usuarios finales y administradores del sistema.*
