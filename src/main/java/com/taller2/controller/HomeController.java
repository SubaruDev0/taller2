package com.taller2.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 * Controlador para la página principal
 *
 * Este servlet maneja las peticiones a la página de inicio del proyecto.
 * Verifica la conexión a la base de datos y redirige a la vista principal.
 */
@WebServlet(name = "HomeController", urlPatterns = {"/", "/home"})
public class HomeController extends HttpServlet {

    /**
     * Maneja las peticiones GET
     *
     * @param request objeto HttpServletRequest
     * @param response objeto HttpServletResponse
     * @throws ServletException si hay error en el servlet
     * @throws IOException si hay error de I/O
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setAttribute("mensaje", "¡Hola Mundo desde GlassFish (Jakarta)!" );

        // Redirigir a la vista
        request.getRequestDispatcher("/WEB-INF/views/inicio.jsp").forward(request, response);
    }

    /**
     * Maneja las peticiones POST (por ahora redirige a GET)
     *
     * @param request objeto HttpServletRequest
     * @param response objeto HttpServletResponse
     * @throws ServletException si hay error en el servlet
     * @throws IOException si hay error de I/O
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
