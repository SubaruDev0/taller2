package com.taller2.dao;

import com.taller2.model.Cita;
import com.taller2.util.DatabaseConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CitaDAO extends BaseDAO {

    public boolean crear(Cita cita) {
        String sql = "INSERT INTO citas (usuario_id, servicio_id, fecha_cita, hora_cita, nombre_paciente, rut, telefono, email, comentarios, estado) "
                +
                "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = DatabaseConnection.getInstance().getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setObject(1, cita.getUsuarioId());
            stmt.setObject(2, cita.getServicioId());
            stmt.setDate(3, cita.getFechaCita());
            stmt.setTime(4, cita.getHoraCita());
            stmt.setString(5, cita.getNombrePaciente());
            stmt.setString(6, cita.getRut());
            stmt.setString(7, cita.getTelefono());
            stmt.setString(8, cita.getEmail());
            stmt.setString(9, cita.getComentarios());
            stmt.setString(10, cita.getEstado() != null ? cita.getEstado() : "PENDIENTE");

            return stmt.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return false;
    }

    public List<Cita> obtenerTodos() {
        List<Cita> citas = new ArrayList<>();
        String sql = "SELECT c.*, s.nombre as nombre_servicio, u.usuario as nombre_usuario " +
                "FROM citas c " +
                "LEFT JOIN servicios s ON c.servicio_id = s.id " +
                "LEFT JOIN usuarios u ON c.usuario_id = u.id " +
                "ORDER BY c.fecha_cita DESC, c.hora_cita DESC";

        try (Connection conn = DatabaseConnection.getInstance().getConnection();
                Statement stmt = conn.createStatement();
                ResultSet rs = stmt.executeQuery(sql)) {

            while (rs.next()) {
                citas.add(mapearCita(rs));
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return citas;
    }

    public Cita obtenerPorId(int id) {
        String sql = "SELECT c.*, s.nombre as nombre_servicio, u.usuario as nombre_usuario " +
                "FROM citas c " +
                "LEFT JOIN servicios s ON c.servicio_id = s.id " +
                "LEFT JOIN usuarios u ON c.usuario_id = u.id " +
                "WHERE c.id = ?";

        try (Connection conn = DatabaseConnection.getInstance().getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, id);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                return mapearCita(rs);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return null;
    }

    public boolean actualizarEstado(int id, String estado) {
        String sql = "UPDATE citas SET estado = ? WHERE id = ?";

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
        String sql = "DELETE FROM citas WHERE id = ?";

        try (Connection conn = DatabaseConnection.getInstance().getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, id);
            return stmt.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return false;
    }

    private Cita mapearCita(ResultSet rs) throws SQLException {
        Cita cita = new Cita();
        cita.setId(rs.getInt("id"));
        cita.setUsuarioId((Integer) rs.getObject("usuario_id"));
        cita.setServicioId((Integer) rs.getObject("servicio_id"));
        cita.setFechaCita(rs.getDate("fecha_cita"));
        cita.setHoraCita(rs.getTime("hora_cita"));
        cita.setNombrePaciente(rs.getString("nombre_paciente"));
        cita.setRut(rs.getString("rut"));
        cita.setTelefono(rs.getString("telefono"));
        cita.setEmail(rs.getString("email"));
        cita.setComentarios(rs.getString("comentarios"));
        cita.setEstado(rs.getString("estado"));
        cita.setFechaCreacion(rs.getTimestamp("fecha_creacion"));
        cita.setNombreServicio(rs.getString("nombre_servicio"));
        cita.setNombreUsuario(rs.getString("nombre_usuario"));
        return cita;
    }
}
