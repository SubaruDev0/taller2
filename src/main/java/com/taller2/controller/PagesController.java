package com.taller2.controller;

import com.taller2.dao.ComentarioDAO;
import com.taller2.model.Comentario;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;
import java.util.stream.Collectors;

@WebServlet(urlPatterns = { "/inicio", "/servicios", "/equipo", "/contacto" })
public class PagesController extends HttpServlet {
    private ComentarioDAO comentarioDAO = new ComentarioDAO();
    private com.taller2.dao.ServicioDAO servicioDAO = new com.taller2.dao.ServicioDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String path = req.getServletPath().replaceFirst("/", ""); // e.g. inicio

        // Si es contacto o inicio, cargar comentarios aprobados
        if ("contacto".equals(path) || "inicio".equals(path)) {
            try {
                List<Comentario> todosComentarios = comentarioDAO.obtenerTodos();
                List<Comentario> comentariosAprobados = todosComentarios.stream()
                        .filter(Comentario::isAprobado)
                        .collect(Collectors.toList());
                req.setAttribute("comentariosAprobados", comentariosAprobados);
            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        // Si es servicios o inicio, cargar servicios activos
        if ("servicios".equals(path) || "inicio".equals(path)) {
            try {
                req.setAttribute("servicios", servicioDAO.obtenerActivos());
            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        String view = "/WEB-INF/views/" + path + ".jsp";
        req.getRequestDispatcher(view).forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // Redirigir POST a GET (por si acaso)
        doGet(req, resp);
    }
}
