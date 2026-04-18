/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package DTO;

import Conexion.ConectarBD;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

/**
 *
 * @author Benja
 */
public class ProyectosTrabajadorDTO {
    
    
    private  String nombre;
    private String puesto;
    private String nombre_proyecto;
    private String estado;

    public ProyectosTrabajadorDTO() {
    }

    public String getNombre() {
        return nombre;
    }

    public void setNombre(String nombre) {
        this.nombre = nombre;
    }

    public String getPuesto() {
        return puesto;
    }

    public void setPuesto(String puesto) {
        this.puesto = puesto;
    }

    public String getNombre_proyecto() {
        return nombre_proyecto;
    }

    public void setNombre_proyecto(String nombre_proyecto) {
        this.nombre_proyecto = nombre_proyecto;
    }

    public String getEstado() {
        return estado;
    }

    public void setEstado(String estado) {
        this.estado = estado;
    }
    
    
    
    public ProyectosTrabajadorDTO TraerProyecto(int id) throws SQLException
    {
        
        String sql = "SELECT t.full_name as nombre, t.puesto, p.name_proyect as nombre_proyecto, p.estado FROM usuarios as u INNER JOIN trabajadores as t on t.id_trabajador = u.id_trabajador INNER JOIN proyectos as p on p.id_proyecto = t.id_proyect where u.id_user=?";
        
        Connection con = ConectarBD.conectar();
        PreparedStatement ps = con.prepareStatement(sql);
        
        ps.setInt(1, id);
        ProyectosTrabajadorDTO PT = new ProyectosTrabajadorDTO();
        ResultSet rs = ps.executeQuery();
        while(rs.next())
        {
            PT.setNombre(rs.getString("nombre"));
            PT.setEstado(rs.getString("estado"));
            PT.setNombre_proyecto(rs.getString("nombre_proyecto"));
            PT.setPuesto(rs.getString("puesto"));
            
            
        }
        return PT;
        
    }
    
    
    
}
