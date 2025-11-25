package com.taller2.controller;

import com.taller2.dao.ServicioDAO;
import com.taller2.model.Servicio;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.math.BigDecimal;

import jakarta.servlet.annotation.MultipartConfig;

@WebServlet("/admin/servicio")
@MultipartConfig
public class AdminServicioServlet extends HttpServlet {

    private ServicioDAO servicioDAO;

    @Override
    public void init() {
        servicioDAO = new ServicioDAO();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || !"ADMIN".equals(session.getAttribute("rol"))) {
            response.sendRedirect(request.getContextPath() + "/inicio");
            return;
        }

        String accion = request.getParameter("accion"); // "crear", "editar"

        try {
            Servicio servicio = new Servicio();
            String idStr = request.getParameter("id");
            if (idStr != null && !idStr.isEmpty()) {
                servicio.setId(Integer.parseInt(idStr));
            }

            servicio.setNombre(request.getParameter("nombre"));
            servicio.setDescripcion(request.getParameter("descripcion"));
            servicio.setImagen(request.getParameter("imagen")); // Por ahora URL o nombre de archivo

            String precioStr = request.getParameter("precio");
            if (precioStr != null && !precioStr.isEmpty()) {
                servicio.setPrecio(new BigDecimal(precioStr));
            }

            String duracionStr = request.getParameter("duracion");
            if (duracionStr != null && !duracionStr.isEmpty()) {
                servicio.setDuracionMinutos(Integer.parseInt(duracionStr));
            }

            // Si es crear, activo por defecto true, si es editar, depende del checkbox
            // Pero el checkbox solo envía si está marcado.
            // Si es editar, deberíamos leer el estado anterior si no viene el parámetro?
            // Asumiremos que el formulario siempre envía el estado correcto.
            // En HTML checkbox: si no está marcado, no se envía.
            // Así que si es null, es false.
            servicio.setActivo(request.getParameter("activo") != null);

            boolean exito = false;
            if ("crear".equals(accion)) {
                // Al crear, forzamos activo si no se especifica (aunque el DAO lo maneja)
                if (request.getParameter("activo") == null)
                    servicio.setActivo(true);
                exito = servicioDAO.crear(servicio);
            } else if ("editar".equals(accion)) {
                exito = servicioDAO.actualizar(servicio);
            }

            if (exito) {
                session.setAttribute("mensajeExito", "Servicio guardado exitosamente");
            } else {
                session.setAttribute("mensajeError", "Error al guardar el servicio");
            }

        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("mensajeError", "Error: " + e.getMessage());
        }

        response.sendRedirect(request.getContextPath() + "/panel");
    }
}
