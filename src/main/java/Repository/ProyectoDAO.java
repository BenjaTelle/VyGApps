/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Repository;

import Conexion.ConectarBD;
import DTO.ListarProyectosDTO;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.proyectos;

/**
 *
 * @author Benja
 */
public class ProyectoDAO {
    
    public List<proyectos> ListarProyectos() throws SQLException {
        String sql = "SELECT * FROM proyectos WHERE estado = 'activo'";
        List<proyectos> proyectos = new ArrayList<>();
       
        try (Connection con = ConectarBD.conectar();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                proyectos p = new proyectos();
                p.setNombre_proyecto(rs.getString("name_proyect"));
                p.setProyecto_id(rs.getInt("id_proyecto"));      
                p.setEstado(rs.getString("estado"));
                p.setPresupuesto_total(rs.getDouble("presupuesto_total"));
                p.setHora_entrada_oficial(rs.getTime("hora_entrada_oficial"));
                p.setHora_salida_oficial(rs.getTime("hora_salida_oficial"));
                p.setTarifa_hora_extra(rs.getDouble("tarifa_hora_extra"));
                proyectos.add(p);
            }
        } catch (SQLException e) {
           e.printStackTrace();
        }
        return proyectos;
    }

    public void CrearProyecto(proyectos p) throws SQLException {
        String sql="INSERT INTO proyectos(name_proyect, estado, presupuesto_total, hora_entrada_oficial, hora_salida_oficial, tarifa_hora_extra) VALUES(?,?,?,?,?,?)";
        
        try (Connection con = ConectarBD.conectar();
             PreparedStatement ps = con.prepareStatement(sql)) {
             
            ps.setString(1, p.getNombre_proyecto());
            ps.setString(2, p.getEstado());
            ps.setDouble(3, p.getPresupuesto_total());
            ps.setTime(4, p.getHora_entrada_oficial());
            ps.setTime(5, p.getHora_salida_oficial());
            ps.setDouble(6, p.getTarifa_hora_extra());
            ps.executeUpdate();
        }
    }
    
    public void EditarProyecto(proyectos p) throws SQLException {
        String sql = "UPDATE proyectos SET name_proyect=?, estado=?, presupuesto_total=?, hora_entrada_oficial=?, hora_salida_oficial=?, tarifa_hora_extra=? WHERE id_proyecto=?";
        
        try (Connection con = ConectarBD.conectar();
             PreparedStatement ps = con.prepareStatement(sql)) {
             
            ps.setString(1, p.getNombre_proyecto());
            ps.setString(2, p.getEstado());
            ps.setDouble(3, p.getPresupuesto_total());
            ps.setTime(4, p.getHora_entrada_oficial());
            ps.setTime(5, p.getHora_salida_oficial());
            ps.setDouble(6, p.getTarifa_hora_extra());
            ps.setInt(7, p.getProyecto_id());
            ps.executeUpdate();
        }
    }
    
    public int BuscarPorNombre(String nombre) throws SQLException{
        String sql = "SELECT id_proyecto FROM proyectos WHERE name_proyect = ?";
        
        try (Connection con = ConectarBD.conectar();
             PreparedStatement ps = con.prepareStatement(sql)) {
             
            ps.setString(1, nombre);
            try (ResultSet rs = ps.executeQuery()) {
                if(rs.next()) {
                    return rs.getInt("id_proyecto");
                }
            }
        }
        return 0;
    }

    public proyectos BuscarPorID(int id) throws SQLException {
        String sql = "SELECT * FROM proyectos WHERE id_proyecto=?";
        proyectos p = new proyectos();
        
        try (Connection con = ConectarBD.conectar();
             PreparedStatement ps = con.prepareStatement(sql)) {
             
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if(rs.next()) {
                    p.setProyecto_id(rs.getInt("id_proyecto"));
                    p.setNombre_proyecto(rs.getString("name_proyect"));
                    p.setEstado(rs.getString("estado"));
                    p.setPresupuesto_total(rs.getDouble("presupuesto_total"));
                    p.setHora_entrada_oficial(rs.getTime("hora_entrada_oficial"));
                    p.setHora_salida_oficial(rs.getTime("hora_salida_oficial"));
                    p.setTarifa_hora_extra(rs.getDouble("tarifa_hora_extra"));
                }
            }
        }
        return p;
    }
    
    public List<ListarProyectosDTO> VerProyectosActivos() throws SQLException {
        String sql= "SELECT p.id_proyecto, p.name_proyect, t.full_name, p.presupuesto_total, p.estado " +
                    "FROM proyectos as p " +
                    "LEFT JOIN proyecto_supervisor as ps ON p.id_proyecto = ps.id_proyecto " +
                    "LEFT JOIN trabajadores as t ON ps.id_trabajador = t.id_trabajador";
                    
        List<ListarProyectosDTO> Lista = new ArrayList<>();
        
        try (Connection con = ConectarBD.conectar();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            while(rs.next()) {
                ListarProyectosDTO LP = new ListarProyectosDTO();
                LP.setId(rs.getInt("id_proyecto"));
                LP.setNombre_proyecto(rs.getString("name_proyect"));
                LP.setNombre_supervisor(rs.getString("full_name"));
                LP.setPresupuesto_total(rs.getDouble("presupuesto_total"));
                Lista.add(LP);
            }
        } catch(SQLException e) {
            e.printStackTrace();
        }
        return Lista;
    }
    
    public boolean inyectarPresupuesto(int idProyecto, double montoAdicional) throws SQLException {
        String sql = "UPDATE proyectos SET presupuesto_total = presupuesto_total + ? WHERE id_proyecto = ?";
        
        try (Connection con = ConectarBD.conectar();
             PreparedStatement ps = con.prepareStatement(sql)) {
             
            ps.setDouble(1, montoAdicional);
            ps.setInt(2, idProyecto);
            return ps.executeUpdate() > 0;
            
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
}