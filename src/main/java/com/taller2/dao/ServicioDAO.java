package com.taller2.dao;

import com.taller2.model.Servicio;
import com.taller2.util.DatabaseConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ServicioDAO extends BaseDAO {

    public boolean crear(Servicio servicio) {
        String sql = "INSERT INTO servicios (nombre, descripcion, imagen, precio, duracion_minutos, activo) VALUES (?, ?, ?, ?, ?, ?)";

        try (Connection conn = DatabaseConnection.getInstance().getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, servicio.getNombre());
            stmt.setString(2, servicio.getDescripcion());
            stmt.setString(3, servicio.getImagen());
            stmt.setBigDecimal(4, servicio.getPrecio());
            stmt.setObject(5, servicio.getDuracionMinutos());
            stmt.setBoolean(6, servicio.isActivo());

            return stmt.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public List<Servicio> obtenerTodos() {
        List<Servicio> servicios = new ArrayList<>();
        String sql = "SELECT * FROM servicios ORDER BY id ASC";

        try (Connection conn = DatabaseConnection.getInstance().getConnection();
                Statement stmt = conn.createStatement();
                ResultSet rs = stmt.executeQuery(sql)) {

            while (rs.next()) {
                servicios.add(mapearServicio(rs));
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return servicios;
    }

    public List<Servicio> obtenerActivos() {
        List<Servicio> servicios = new ArrayList<>();
        String sql = "SELECT * FROM servicios WHERE activo = TRUE ORDER BY nombre ASC";

        try (Connection conn = DatabaseConnection.getInstance().getConnection();
                Statement stmt = conn.createStatement();
                ResultSet rs = stmt.executeQuery(sql)) {

            while (rs.next()) {
                servicios.add(mapearServicio(rs));
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return servicios;
    }

    public Servicio obtenerPorId(int id) {
        String sql = "SELECT * FROM servicios WHERE id = ?";

        try (Connection conn = DatabaseConnection.getInstance().getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, id);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                return mapearServicio(rs);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean actualizar(Servicio servicio) {
        String sql = "UPDATE servicios SET nombre=?, descripcion=?, imagen=?, precio=?, duracion_minutos=?, activo=? WHERE id=?";

        try (Connection conn = DatabaseConnection.getInstance().getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, servicio.getNombre());
            stmt.setString(2, servicio.getDescripcion());
            stmt.setString(3, servicio.getImagen());
            stmt.setBigDecimal(4, servicio.getPrecio());
            stmt.setObject(5, servicio.getDuracionMinutos());
            stmt.setBoolean(6, servicio.isActivo());
            stmt.setInt(7, servicio.getId());

            return stmt.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean eliminar(int id) {
        String sql = "DELETE FROM servicios WHERE id = ?";

        try (Connection conn = DatabaseConnection.getInstance().getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, id);
            return stmt.executeUpdate() > 0;

        } catch (SQLException e) {
            System.err.println("Error al eliminar servicio: " + e.getMessage());
            return false;
        }
    }

    private Servicio mapearServicio(ResultSet rs) throws SQLException {
        Servicio servicio = new Servicio();
        servicio.setId(rs.getInt("id"));
        servicio.setNombre(rs.getString("nombre"));
        servicio.setDescripcion(rs.getString("descripcion"));
        servicio.setImagen(rs.getString("imagen"));
        servicio.setPrecio(rs.getBigDecimal("precio"));
        servicio.setDuracionMinutos((Integer) rs.getObject("duracion_minutos"));
        servicio.setActivo(rs.getBoolean("activo"));
        servicio.setFechaCreacion(rs.getTimestamp("fecha_creacion"));
        return servicio;
    }
}
