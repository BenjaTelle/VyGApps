/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Repository;

import Conexion.ConectarBD;
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
        String sql = "Select * from proyectos ";
        List<proyectos> proyectos = new ArrayList<>();
       
        Connection con = ConectarBD.conectar();
        
        PreparedStatement ps = con.prepareStatement(sql);
        try {
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                 proyectos p = new proyectos();
                p.setNombre_proyecto(rs.getString("name_proyect"));
                p.setProyecto_id(Integer.parseInt(rs.getString("id_proyecto")));        
                proyectos.add(p);
            }

        } catch (SQLException e) {
           e.printStackTrace();
        }
        
       return proyectos;
    }
    
    public void AsignSup(int id_proyecto)
    {
         String sql =" ";
        
        
    }

    public void CrearProyecto(String NombreProyecto) throws SQLException {
      String sql=" INSERT INTO proyectos(name_proyect) VALUES (?)";
        
      Connection con = ConectarBD.conectar();
      PreparedStatement ps = con.prepareStatement(sql);
      ps.setString(1, NombreProyecto);
      
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
    
}
