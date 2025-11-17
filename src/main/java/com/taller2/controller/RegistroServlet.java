package com.taller2.controller;

import com.taller2.dao.UsuarioDAO;
import com.taller2.model.Usuario;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet("/registro")
public class RegistroServlet extends HttpServlet {
    
    private UsuarioDAO usuarioDAO;
    
    @Override
    public void init() {
        usuarioDAO = new UsuarioDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        request.getRequestDispatcher("/WEB-INF/views/registro.jsp").forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String nombreCompleto = request.getParameter("nombreCompleto");
        String usuario = request.getParameter("usuario");
        String email = request.getParameter("email");
        String contrasena = request.getParameter("contrasena");
        String confirmarContrasena = request.getParameter("confirmarContrasena");
        
        // Validaciones
        if (!contrasena.equals(confirmarContrasena)) {
            request.setAttribute("error", "Las contraseñas no coinciden");
            request.getRequestDispatcher("/WEB-INF/views/registro.jsp").forward(request, response);
            return;
        }
        
        // Verificar si el usuario ya existe
        Usuario usuarioExistente = usuarioDAO.buscarPorNombreUsuario(usuario);
        if (usuarioExistente != null) {
            request.setAttribute("error", "El nombre de usuario ya está en uso");
            request.getRequestDispatcher("/WEB-INF/views/registro.jsp").forward(request, response);
            return;
        }
        
        // Crear nuevo usuario con rol USUARIO
        Usuario nuevoUsuario = new Usuario();
        nuevoUsuario.setNombreCompleto(nombreCompleto);
        nuevoUsuario.setUsuario(usuario);
        nuevoUsuario.setEmail(email);
        nuevoUsuario.setContrasena(contrasena);
        nuevoUsuario.setRol("USUARIO");
        nuevoUsuario.setActivo(true);
        
        boolean registrado = usuarioDAO.crear(nuevoUsuario);
        
        if (registrado) {
            request.setAttribute("exito", "¡Registro exitoso! Ya puedes iniciar sesión");
            request.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(request, response);
        } else {
            request.setAttribute("error", "Error al registrar el usuario. Inténtalo nuevamente");
            request.getRequestDispatcher("/WEB-INF/views/registro.jsp").forward(request, response);
        }
    }
}
