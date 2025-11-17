package com.taller2.controller;

import com.taller2.dao.UsuarioDAO;
import com.taller2.dao.TurnoDAO;
import com.taller2.dao.ComentarioDAO;
import com.taller2.model.Usuario;
import com.taller2.model.Turno;
import com.taller2.model.Comentario;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

@WebServlet("/panel")
public class PanelGestionServlet extends HttpServlet {
    
    private UsuarioDAO usuarioDAO;
    private TurnoDAO turnoDAO;
    private ComentarioDAO comentarioDAO;
    
    @Override
    public void init() {
        usuarioDAO = new UsuarioDAO();
        turnoDAO = new TurnoDAO();
        comentarioDAO = new ComentarioDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        
        // Verificar que el usuario esté autenticado
        if (session == null || session.getAttribute("usuarioId") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        // Verificar que sea ADMIN
        String rol = (String) session.getAttribute("rol");
        if (!"ADMIN".equals(rol)) {
            response.sendRedirect(request.getContextPath() + "/inicio");
            return;
        }
        
        // Obtener lista de usuarios
        List<Usuario> usuarios = usuarioDAO.obtenerTodos();
        request.setAttribute("usuarios", usuarios);
        
        // Obtener lista de turnos
        List<Turno> turnos = turnoDAO.obtenerTodos();
        request.setAttribute("turnos", turnos);
        
        // Obtener lista de comentarios
        List<Comentario> comentarios = comentarioDAO.obtenerTodos();
        request.setAttribute("comentarios", comentarios);
        
        request.getRequestDispatcher("/WEB-INF/views/panel.jsp").forward(request, response);
    }
}
