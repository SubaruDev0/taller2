package com.taller2.controller;

import com.taller2.dao.CitaDAO;
import com.taller2.model.Cita;
import com.taller2.util.RutValidator;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.Date;
import java.sql.Time;

@WebServlet("/pedirCita")
public class PedirCitaServlet extends HttpServlet {

    private CitaDAO citaDAO;
    private com.taller2.dao.ServicioDAO servicioDAO;

    @Override
    public void init() {
        citaDAO = new CitaDAO();
        servicioDAO = new com.taller2.dao.ServicioDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Cargar servicios activos para el dropdown
        request.setAttribute("servicios", servicioDAO.obtenerActivos());

        // Si viene un servicioId en la URL, pasarlo al JSP para pre-selección
        String servicioIdParam = request.getParameter("servicioId");
        if (servicioIdParam != null && !servicioIdParam.isEmpty()) {
            request.setAttribute("servicioIdPreseleccionado", servicioIdParam);
        }

        request.getRequestDispatcher("/WEB-INF/views/pedirCita.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        // Verificar que esté logueado
        if (session == null || session.getAttribute("usuarioId") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        try {
            // Validar campos requeridos
            String nombre = request.getParameter("nombre");
            String rut = request.getParameter("rut");
            String telefono = request.getParameter("telefono");
            String email = request.getParameter("email");
            String servicioIdStr = request.getParameter("servicio");
            String fechaStr = request.getParameter("fecha");
            String horario = request.getParameter("horario");

            // Validaciones
            if (nombre == null || nombre.trim().isEmpty()) {
                request.setAttribute("error", "El nombre es obligatorio");
                request.setAttribute("servicios", servicioDAO.obtenerActivos());
                request.getRequestDispatcher("/WEB-INF/views/pedirCita.jsp").forward(request, response);
                return;
            }

            if (rut == null || rut.trim().isEmpty()) {
                request.setAttribute("error", "El RUT es obligatorio");
                request.setAttribute("servicios", servicioDAO.obtenerActivos());
                request.getRequestDispatcher("/WEB-INF/views/pedirCita.jsp").forward(request, response);
                return;
            }

            // Validar formato y dígito verificador del RUT
            if (!RutValidator.validarRut(rut)) {
                request.setAttribute("error", "El RUT ingresado no es válido. Verifique el formato y dígito verificador.");
                request.setAttribute("servicios", servicioDAO.obtenerActivos());
                request.getRequestDispatcher("/WEB-INF/views/pedirCita.jsp").forward(request, response);
                return;
            }

            if (servicioIdStr == null || servicioIdStr.trim().isEmpty()) {
                request.setAttribute("error", "Debe seleccionar un servicio");
                request.setAttribute("servicios", servicioDAO.obtenerActivos());
                request.getRequestDispatcher("/WEB-INF/views/pedirCita.jsp").forward(request, response);
                return;
            }

            if (fechaStr == null || fechaStr.trim().isEmpty()) {
                request.setAttribute("error", "La fecha es obligatoria");
                request.setAttribute("servicios", servicioDAO.obtenerActivos());
                request.getRequestDispatcher("/WEB-INF/views/pedirCita.jsp").forward(request, response);
                return;
            }

            Cita cita = new Cita();
            cita.setUsuarioId((Integer) session.getAttribute("usuarioId"));
            cita.setNombrePaciente(nombre.trim());
            cita.setRut(RutValidator.formatearRut(rut.trim())); // Formatear RUT antes de guardar
            cita.setTelefono(telefono != null ? telefono.trim() : "");
            cita.setEmail(email != null ? email.trim() : "");

            // Servicio ID
            try {
                cita.setServicioId(Integer.parseInt(servicioIdStr));
            } catch (NumberFormatException e) {
                request.setAttribute("error", "Servicio inválido");
                request.setAttribute("servicios", servicioDAO.obtenerActivos());
                request.getRequestDispatcher("/WEB-INF/views/pedirCita.jsp").forward(request, response);
                return;
            }

            // Fecha y hora
            try {
                cita.setFechaCita(Date.valueOf(fechaStr));
            } catch (IllegalArgumentException e) {
                request.setAttribute("error", "Fecha inválida");
                request.setAttribute("servicios", servicioDAO.obtenerActivos());
                request.getRequestDispatcher("/WEB-INF/views/pedirCita.jsp").forward(request, response);
                return;
            }

            String horarioValue = horario != null ? horario : "mañana";
            Time hora = horarioValue.equals("mañana") ? Time.valueOf("10:00:00")
                    : horarioValue.equals("tarde") ? Time.valueOf("16:00:00") : Time.valueOf("10:00:00");
            cita.setHoraCita(hora);

            cita.setComentarios(request.getParameter("mensaje"));
            cita.setEstado("PENDIENTE");

            System.out.println("=== DEBUG: Intentando crear cita ===");
            System.out.println("Usuario ID: " + cita.getUsuarioId());
            System.out.println("Servicio ID: " + cita.getServicioId());
            System.out.println("Fecha: " + cita.getFechaCita());
            System.out.println("Hora: " + cita.getHoraCita());
            System.out.println("Nombre: " + cita.getNombrePaciente());
            System.out.println("RUT: " + cita.getRut());
            System.out.println("Estado: " + cita.getEstado());

            boolean creado = citaDAO.crear(cita);

            System.out.println("Resultado creación: " + creado);

            if (creado) {
                request.setAttribute("exito", "¡Cita solicitada exitosamente! Nos contactaremos pronto.");
            } else {
                request.setAttribute("error", "Error al guardar la cita. Intente nuevamente.");
            }

        } catch (Exception e) {
            System.err.println("=== ERROR AL PROCESAR CITA ===");
            e.printStackTrace();
            request.setAttribute("error", "Error al procesar la cita: " + e.getMessage());
        }

        // Recargar servicios si hay error o éxito para mostrar el form de nuevo
        request.setAttribute("servicios", servicioDAO.obtenerActivos());
        request.getRequestDispatcher("/WEB-INF/views/pedirCita.jsp").forward(request, response);
    }
}
