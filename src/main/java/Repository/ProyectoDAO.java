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
import java.util.Set;
import model.proyectos;

/**
 *
 * @author Benja
 */
public class ProyectoDAO {
    
    public List<proyectos> ListarProyectos() throws SQLException {
        String sql = "Select * from proyectos where proyectos.estado = 'activo'  ";
        List<proyectos> proyectos = new ArrayList<>();
       
        Connection con = ConectarBD.conectar();
        
        PreparedStatement ps = con.prepareStatement(sql);
        try {
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                 proyectos p = new proyectos();
                p.setNombre_proyecto(rs.getString("name_proyect"));
                p.setProyecto_id(Integer.parseInt(rs.getString("id_proyecto")));      
                p.setEstado(rs.getString("estado"));
                p.setPresupuesto_total(rs.getDouble("presupuesto_total"));
                proyectos.add(p);
            }

        } catch (SQLException e) {
           e.printStackTrace();
        }
        
       return proyectos;
    }
    
    

    public void CrearProyecto(proyectos p) throws SQLException {
      String sql="INSERT INTO proyectos(name_proyect, estado, presupuesto_total) VALUES(?,?,?) ";
        
      Connection con = ConectarBD.conectar();
      PreparedStatement ps = con.prepareStatement(sql);
      ps.setString(1, p.getNombre_proyecto());
      ps.setString(2, p.getEstado());
      ps.setDouble(3, p.getPresupuesto_total());
      
      ps.executeUpdate();
      
      
    }
    
    public int BuscarPorNombre(String nombre) throws SQLException{
        String sql = " SELECT p.id_proyecto from proyectos as p where p.name_proyect =?";
        
        Connection con = ConectarBD.conectar();
        PreparedStatement ps = con.prepareStatement(sql);
        
        ps.setString(1, nombre);
        
        ResultSet rs = ps.executeQuery();
      if(rs.next())
      {
            int id_t = rs.getInt("id_proyecto");
        return id_t;
      }
        
        
        return 0;
    }

    public proyectos BuscarPorID(int id) throws SQLException {
        String sql = " SELECT * FROM proyectos WHERE id_proyecto=?";
        
        Connection con = ConectarBD.conectar();
        PreparedStatement ps = con.prepareStatement(sql);
        
        ps.setInt(1,id );
        proyectos p = new proyectos();
        ResultSet rs = ps.executeQuery();
      if(rs.next())
      {
           
          p.setEstado(rs.getString("estado"));
          p.setNombre_proyecto(rs.getString("name_proyect"));
          p.setPresupuesto_total(rs.getDouble("presupuesto_total"));
          p.setProyecto_id(rs.getInt("id_proyecto"));
          
      }
        
        return p;
       
    }
    
    
    public List<ListarProyectosDTO> VerProyectosActivos() throws SQLException
    {
        String sql= "SELECT p.id_proyecto, p.name_proyect, t.full_name, p.presupuesto_total, p.estado FROM proyectos as p LEFT JOIN proyecto_supervisor as ps ON p.id_proyecto = ps.id_proyecto LEFT JOIN trabajadores as t ON ps.id_trabajador = t.id_trabajador;";
        Connection con = ConectarBD.conectar();
        PreparedStatement ps = con.prepareStatement(sql);
        List<ListarProyectosDTO> Lista = new ArrayList<>();
        try{
            
            ResultSet rs =  ps.executeQuery();
            while(rs.next())
            {
                
                ListarProyectosDTO LP = new ListarProyectosDTO();
                LP.setId(rs.getInt("id_proyecto"));
                LP.setNombre_supervisor(rs.getString("full_name"));
                LP.setNombre_proyecto(rs.getString("name_proyect"));
                LP.setNombre_supervisor(rs.getString("full_name"));
                LP.setPresupuesto_total(rs.getDouble("presupuesto_total"));
                
                Lista.add(LP);
                
                
            }
            
        }catch(SQLException e)
        {
            e.printStackTrace();
        }
        return Lista;
        
    }
    // Método para inyectar capital a un proyecto
    public boolean inyectarPresupuesto(int idProyecto, double montoAdicional) throws SQLException {
        // Hacemos que SQL sume el monto directamente, es más seguro y rápido
        String sql = "UPDATE proyectos SET presupuesto_total = presupuesto_total + ? WHERE id_proyecto = ?";
        
        Connection con = ConectarBD.conectar();
        PreparedStatement ps = con.prepareStatement(sql);
        
        try {
            ps.setDouble(1, montoAdicional);
            ps.setInt(2, idProyecto);
            
            int filasActualizadas = ps.executeUpdate();
            return filasActualizadas > 0;
            
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
       
    }
}
