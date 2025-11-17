package com.taller2.dao;

import com.taller2.model.Comentario;
import com.taller2.util.DatabaseConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ComentarioDAO extends BaseDAO {

    public boolean crear(Comentario comentario) {
        String sql = "INSERT INTO comentarios (usuario_id, nombre, comentario, calificacion, aprobado) VALUES (?, ?, ?, ?, ?)";
        
        try (Connection conn = DatabaseConnection.getInstance().getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setObject(1, comentario.getUsuarioId());
            stmt.setString(2, comentario.getNombre());
            stmt.setString(3, comentario.getComentario());
            stmt.setObject(4, comentario.getCalificacion());
            stmt.setBoolean(5, false); // Por defecto no aprobado
            
            return stmt.executeUpdate() > 0;
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return false;
    }

    public List<Comentario> obtenerTodos() {
        List<Comentario> comentarios = new ArrayList<>();
        String sql = "SELECT c.*, u.usuario as nombre_usuario " +
                     "FROM comentarios c " +
                     "LEFT JOIN usuarios u ON c.usuario_id = u.id " +
                     "ORDER BY c.fecha_creacion DESC";
        
        try (Connection conn = DatabaseConnection.getInstance().getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                comentarios.add(mapearComentario(rs));
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return comentarios;
    }

    public List<Comentario> obtenerAprobados() {
        List<Comentario> comentarios = new ArrayList<>();
        String sql = "SELECT c.*, u.usuario as nombre_usuario " +
                     "FROM comentarios c " +
                     "LEFT JOIN usuarios u ON c.usuario_id = u.id " +
                     "WHERE c.aprobado = TRUE " +
                     "ORDER BY c.fecha_creacion DESC";
        
        try (Connection conn = DatabaseConnection.getInstance().getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                comentarios.add(mapearComentario(rs));
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return comentarios;
    }

    public boolean aprobar(int id) {
        String sql = "UPDATE comentarios SET aprobado = TRUE WHERE id = ?";
        
        try (Connection conn = DatabaseConnection.getInstance().getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, id);
            return stmt.executeUpdate() > 0;
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return false;
    }

    public boolean eliminar(int id) {
        String sql = "DELETE FROM comentarios WHERE id = ?";
        
        try (Connection conn = DatabaseConnection.getInstance().getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, id);
            return stmt.executeUpdate() > 0;
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return false;
    }

    private Comentario mapearComentario(ResultSet rs) throws SQLException {
        Comentario comentario = new Comentario();
        comentario.setId(rs.getInt("id"));
        comentario.setUsuarioId((Integer) rs.getObject("usuario_id"));
        comentario.setNombre(rs.getString("nombre"));
        comentario.setComentario(rs.getString("comentario"));
        comentario.setCalificacion((Integer) rs.getObject("calificacion"));
        comentario.setAprobado(rs.getBoolean("aprobado"));
        comentario.setFechaCreacion(rs.getTimestamp("fecha_creacion"));
        comentario.setNombreUsuario(rs.getString("nombre_usuario"));
        return comentario;
    }
}
