package com.taller2.controller;

import com.taller2.dao.CitaDAO;
import com.taller2.dao.ComentarioDAO;
import com.taller2.dao.ServicioDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/panel/accion")
public class PanelAccionServlet extends HttpServlet {

    private CitaDAO citaDAO;
    private ComentarioDAO comentarioDAO;
    private ServicioDAO servicioDAO;

    @Override
    public void init() {
        citaDAO = new CitaDAO();
        comentarioDAO = new ComentarioDAO();
        servicioDAO = new ServicioDAO();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        // Verificar que sea ADMIN
        if (session == null || !"ADMIN".equals(session.getAttribute("rol"))) {
            response.sendRedirect(request.getContextPath() + "/inicio");
            return;
        }

        String tipo = request.getParameter("tipo"); // "cita", "comentario", "servicio"
        String accion = request.getParameter("accion"); // "aprobar", "rechazar", "eliminar"
        String idStr = request.getParameter("id");

        if (tipo == null || accion == null || idStr == null) {
            response.sendRedirect(request.getContextPath() + "/panel");
            return;
        }

        try {
            int id = Integer.parseInt(idStr);
            boolean exito = false;

            if ("cita".equals(tipo)) {
                if ("aprobar".equals(accion)) {
                    exito = citaDAO.actualizarEstado(id, "CONFIRMADO");
                } else if ("rechazar".equals(accion)) {
                    exito = citaDAO.actualizarEstado(id, "CANCELADO");
                } else if ("eliminar".equals(accion)) {
                    exito = citaDAO.eliminar(id);
                }
            } else if ("comentario".equals(tipo)) {
                if ("aprobar".equals(accion)) {
                    exito = comentarioDAO.aprobar(id);
                } else if ("eliminar".equals(accion)) {
                    exito = comentarioDAO.eliminar(id);
                }
            } else if ("servicio".equals(tipo)) {
                if ("eliminar".equals(accion)) {
                    exito = servicioDAO.eliminar(id);
                }
            }

            if (exito) {
                session.setAttribute("mensajeExito", "Acción realizada exitosamente");
            } else {
                session.setAttribute("mensajeError", "Error al realizar la acción");
            }

        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("mensajeError", "Error: " + e.getMessage());
        }

        response.sendRedirect(request.getContextPath() + "/panel");
    }
}
