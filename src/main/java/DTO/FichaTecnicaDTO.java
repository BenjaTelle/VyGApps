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
public class FichaTecnicaDTO {

    private int idP;
    private String nombre_proyecto;
    private String estado;
    private String nombre_supervisor;
    private int total_trabajadores;
    private double presupuesto;

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

    public String getNombre_supervisor() {
        return nombre_supervisor;
    }

    public void setNombre_supervisor(String nombre_supervisor) {
        this.nombre_supervisor = nombre_supervisor;
    }

    public int getTotal_trabajadores() {
        return total_trabajadores;
    }

    public void setTotal_trabajadores(int total_trabajadores) {
        this.total_trabajadores = total_trabajadores;
    }

    public double getPresupuesto() {
        return presupuesto;
    }

    public void setPresupuesto(double presupuesto) {
        this.presupuesto = presupuesto;
    }

    public int getIdP() {
        return idP;
    }

    public void setIdP(int idP) {
        this.idP = idP;
    }

    public FichaTecnicaDTO() {
    }

    public FichaTecnicaDTO traerFicha(int id) throws SQLException {
        String sql = "SELECT p.id_proyecto, \n"
                + "p.name_proyect, \n"
                + "p.estado, \n"
                + "p.presupuesto_total,\n"
                + " -- Identificamos quién es el supervisor de esta obra \n"
                + "MAX(CASE WHEN t.puesto = 'Supervisor de obra' THEN t.full_name ELSE NULL END) AS nombre_supervisor, \n"
                + "-- Contamos cuántos trabajadores están asignados (incluyendo al supervisor) \n"
                + "COUNT(t.id_trabajador) AS total_trabajadores \n"
                + "FROM proyectos p LEFT JOIN trabajadores t ON p.id_proyecto = t.id_proyect WHERE p.id_proyecto = ?\n"
                + "GROUP BY \n"
                + "p.id_proyecto, \n"
                + "p.name_proyect, \n"
                + "p.estado, \n"
                + "p.presupuesto_total;";
        
        
        Connection con = ConectarBD.conectar();
        PreparedStatement ps = con.prepareStatement(sql);
        
        ps.setInt(1,  id);
        FichaTecnicaDTO ficha = new FichaTecnicaDTO();
        try{
            ResultSet  rs = ps.executeQuery();
            while(rs.next())
            {
                
                ficha.setNombre_proyecto(rs.getString("name_proyect"));
                ficha.setEstado( rs.getString("estado"));
                ficha.setNombre_supervisor(rs.getString("nombre_supervisor"));
                ficha.setPresupuesto(rs.getDouble("presupuesto_total"));
                ficha.setTotal_trabajadores(rs.getInt("total_trabajadores"));
                ficha.setIdP(id);
            }
            
            
        }catch(SQLException e)
        {
            e.printStackTrace();
            
        }
        
        
        return ficha;
    }


}
