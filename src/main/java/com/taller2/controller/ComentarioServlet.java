package com.taller2.controller;

import com.taller2.dao.ComentarioDAO;
import com.taller2.model.Comentario;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/comentario")
public class ComentarioServlet extends HttpServlet {
    
    private ComentarioDAO comentarioDAO;
    
    @Override
    public void init() {
        comentarioDAO = new ComentarioDAO();
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        
        try {
            Comentario comentario = new Comentario();
            
            // Si está logueado, guardar el usuario_id
            if (session != null && session.getAttribute("usuarioId") != null) {
                comentario.setUsuarioId((Integer) session.getAttribute("usuarioId"));
            }
            
            comentario.setNombre(request.getParameter("nombre"));
            comentario.setComentario(request.getParameter("comentario"));
            
            String calificacionStr = request.getParameter("calificacion");
            if (calificacionStr != null && !calificacionStr.isEmpty()) {
                comentario.setCalificacion(Integer.parseInt(calificacionStr));
            }
            
            boolean creado = comentarioDAO.crear(comentario);
            
            if (creado) {
                session.setAttribute("mensajeExito", "¡Gracias por tu comentario! Será revisado por nuestro equipo.");
            } else {
                session.setAttribute("mensajeError", "Error al guardar el comentario. Intente nuevamente.");
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("mensajeError", "Error: " + e.getMessage());
        }
        
        response.sendRedirect(request.getContextPath() + "/contacto");
    }
}
