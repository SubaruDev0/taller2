package com.taller2.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet(urlPatterns = {"/inicio","/servicios","/equipo","/contacto","/login","/pedirTurno"})
public class PagesController extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String path = req.getServletPath().replaceFirst("/", ""); // e.g. inicio
        String view = "/WEB-INF/views/" + path + ".jsp";
        req.getRequestDispatcher(view).forward(req, resp);
    }
}
