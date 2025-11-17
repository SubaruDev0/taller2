package com.taller2.dao;

import com.taller2.model.Turno;
import com.taller2.util.DatabaseConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class TurnoDAO extends BaseDAO {

    public boolean crear(Turno turno) {
        String sql = "INSERT INTO turnos (usuario_id, servicio_id, fecha_turno, hora_turno, nombre_paciente, rut, telefono, email, comentarios, estado) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        
        try (Connection conn = DatabaseConnection.getInstance().getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setObject(1, turno.getUsuarioId());
            stmt.setObject(2, turno.getServicioId());
            stmt.setDate(3, turno.getFechaTurno());
            stmt.setTime(4, turno.getHoraTurno());
            stmt.setString(5, turno.getNombrePaciente());
            stmt.setString(6, turno.getRut());
            stmt.setString(7, turno.getTelefono());
            stmt.setString(8, turno.getEmail());
            stmt.setString(9, turno.getComentarios());
            stmt.setString(10, turno.getEstado() != null ? turno.getEstado() : "PENDIENTE");
            
            return stmt.executeUpdate() > 0;
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return false;
    }

    public List<Turno> obtenerTodos() {
        List<Turno> turnos = new ArrayList<>();
        String sql = "SELECT t.*, s.nombre as nombre_servicio, u.usuario as nombre_usuario " +
                     "FROM turnos t " +
                     "LEFT JOIN servicios s ON t.servicio_id = s.id " +
                     "LEFT JOIN usuarios u ON t.usuario_id = u.id " +
                     "ORDER BY t.fecha_turno DESC, t.hora_turno DESC";
        
        try (Connection conn = DatabaseConnection.getInstance().getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                turnos.add(mapearTurno(rs));
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return turnos;
    }

    public Turno obtenerPorId(int id) {
        String sql = "SELECT t.*, s.nombre as nombre_servicio, u.usuario as nombre_usuario " +
                     "FROM turnos t " +
                     "LEFT JOIN servicios s ON t.servicio_id = s.id " +
                     "LEFT JOIN usuarios u ON t.usuario_id = u.id " +
                     "WHERE t.id = ?";
        
        try (Connection conn = DatabaseConnection.getInstance().getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, id);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return mapearTurno(rs);
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return null;
    }

    public boolean actualizarEstado(int id, String estado) {
        String sql = "UPDATE turnos SET estado = ? WHERE id = ?";
        
        try (Connection conn = DatabaseConnection.getInstance().getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, estado);
            stmt.setInt(2, id);
            
            return stmt.executeUpdate() > 0;
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return false;
    }

    public boolean eliminar(int id) {
        String sql = "DELETE FROM turnos WHERE id = ?";
        
        try (Connection conn = DatabaseConnection.getInstance().getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, id);
            return stmt.executeUpdate() > 0;
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return false;
    }

    private Turno mapearTurno(ResultSet rs) throws SQLException {
        Turno turno = new Turno();
        turno.setId(rs.getInt("id"));
        turno.setUsuarioId((Integer) rs.getObject("usuario_id"));
        turno.setServicioId((Integer) rs.getObject("servicio_id"));
        turno.setFechaTurno(rs.getDate("fecha_turno"));
        turno.setHoraTurno(rs.getTime("hora_turno"));
        turno.setNombrePaciente(rs.getString("nombre_paciente"));
        turno.setRut(rs.getString("rut"));
        turno.setTelefono(rs.getString("telefono"));
        turno.setEmail(rs.getString("email"));
        turno.setComentarios(rs.getString("comentarios"));
        turno.setEstado(rs.getString("estado"));
        turno.setFechaCreacion(rs.getTimestamp("fecha_creacion"));
        turno.setNombreServicio(rs.getString("nombre_servicio"));
        turno.setNombreUsuario(rs.getString("nombre_usuario"));
        return turno;
    }
}
