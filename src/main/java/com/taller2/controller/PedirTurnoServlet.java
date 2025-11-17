package com.taller2.controller;

import com.taller2.dao.TurnoDAO;
import com.taller2.model.Turno;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.Date;
import java.sql.Time;

@WebServlet("/pedirTurno")
public class PedirTurnoServlet extends HttpServlet {
    
    private TurnoDAO turnoDAO;
    
    @Override
    public void init() {
        turnoDAO = new TurnoDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // Simplemente mostrar la página
        request.getRequestDispatcher("/WEB-INF/views/pedirTurno.jsp").forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        
        // Verificar que esté logueado
        if (session == null || session.getAttribute("usuarioId") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        try {
            Turno turno = new Turno();
            turno.setUsuarioId((Integer) session.getAttribute("usuarioId"));
            turno.setNombrePaciente(request.getParameter("nombre"));
            turno.setRut(request.getParameter("rut"));
            turno.setTelefono(request.getParameter("telefono"));
            turno.setEmail(request.getParameter("email"));
            
            // Servicio ID (simplificado - guardaremos el nombre en comentarios)
            turno.setServicioId(null);
            
            // Fecha y hora
            String fechaStr = request.getParameter("fecha");
            turno.setFechaTurno(Date.valueOf(fechaStr));
            
            String horario = request.getParameter("horario");
            // Convertir horario a Time (simplificado)
            Time hora = horario.equals("mañana") ? Time.valueOf("10:00:00") :
                        horario.equals("tarde") ? Time.valueOf("16:00:00") :
                        Time.valueOf("10:00:00");
            turno.setHoraTurno(hora);
            
            turno.setComentarios(request.getParameter("mensaje"));
            turno.setEstado("PENDIENTE");
            
            boolean creado = turnoDAO.crear(turno);
            
            if (creado) {
                request.setAttribute("exito", "¡Turno solicitado exitosamente! Nos contactaremos pronto.");
            } else {
                request.setAttribute("error", "Error al guardar el turno. Intente nuevamente.");
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error al procesar el turno: " + e.getMessage());
        }
        
        request.getRequestDispatcher("/WEB-INF/views/pedirTurno.jsp").forward(request, response);
    }
}
