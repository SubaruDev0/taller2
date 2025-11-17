package com.taller2.controller;

import com.taller2.dao.UsuarioDAO;
import com.taller2.model.Usuario;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet("/recuperar")
public class RecuperarContrasenaServlet extends HttpServlet {
    
    private UsuarioDAO usuarioDAO;
    
    @Override
    public void init() {
        usuarioDAO = new UsuarioDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        request.getRequestDispatcher("/WEB-INF/views/recuperar.jsp").forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String usuario = request.getParameter("usuario");
        String contrasenaActual = request.getParameter("contrasenaActual");
        String nuevaContrasena = request.getParameter("nuevaContrasena");
        String confirmarContrasena = request.getParameter("confirmarContrasena");
        
        // Validar que las contraseñas nuevas coincidan
        if (!nuevaContrasena.equals(confirmarContrasena)) {
            request.setAttribute("error", "Las contraseñas nuevas no coinciden");
            request.getRequestDispatcher("/WEB-INF/views/recuperar.jsp").forward(request, response);
            return;
        }
        
        // Autenticar con contraseña actual
        Usuario user = usuarioDAO.autenticar(usuario, contrasenaActual);
        
        if (user == null) {
            request.setAttribute("error", "Usuario o contraseña actual incorrectos");
            request.getRequestDispatcher("/WEB-INF/views/recuperar.jsp").forward(request, response);
            return;
        }
        
        // Cambiar contraseña
        boolean cambiado = usuarioDAO.cambiarContrasena(user.getId(), nuevaContrasena);
        
        if (cambiado) {
            request.setAttribute("exito", "¡Contraseña cambiada exitosamente! Ya puedes iniciar sesión");
            request.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(request, response);
        } else {
            request.setAttribute("error", "Error al cambiar la contraseña. Inténtalo nuevamente");
            request.getRequestDispatcher("/WEB-INF/views/recuperar.jsp").forward(request, response);
        }
    }
}
