package com.taller2.controller;

import com.taller2.dao.UsuarioDAO;
import com.taller2.model.Usuario;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {
    
    private UsuarioDAO usuarioDAO;
    
    @Override
    public void init() {
        usuarioDAO = new UsuarioDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // Mostrar página de login
        request.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String usuario = request.getParameter("usuario");
        String contrasena = request.getParameter("contrasena");
        String tipoLogin = request.getParameter("tipoLogin"); // "credenciales" o "invitado"
        
        HttpSession session = request.getSession();
        
        // Login como invitado
        if ("invitado".equals(tipoLogin)) {
            session.setAttribute("tipoUsuario", "INVITADO");
            session.setAttribute("nombreUsuario", "Invitado");
            response.sendRedirect(request.getContextPath() + "/inicio");
            return;
        }
        
        // Login con credenciales
        if (usuario != null && contrasena != null) {
            Usuario user = usuarioDAO.autenticar(usuario, contrasena);
            
            if (user != null) {
                // Autenticación exitosa
                session.setAttribute("usuarioId", user.getId());
                session.setAttribute("usuario", user.getUsuario());
                session.setAttribute("nombreUsuario", user.getNombreCompleto());
                session.setAttribute("rol", user.getRol());
                session.setAttribute("tipoUsuario", user.getRol()); // ADMIN o USUARIO
                
                response.sendRedirect(request.getContextPath() + "/inicio");
            } else {
                // Credenciales inválidas
                request.setAttribute("error", "Usuario o contraseña incorrectos");
                request.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(request, response);
            }
        } else {
            response.sendRedirect(request.getContextPath() + "/login");
        }
    }
}
