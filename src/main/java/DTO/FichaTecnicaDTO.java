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
        // Usamos subconsultas limpias apoyándonos en la tabla intermedia proyecto_supervisor
        String sql = "SELECT "
                + "p.id_proyecto, "
                + "p.name_proyect, "
                + "p.estado, "
                + "p.presupuesto_total, "
                + "-- Subconsulta para traer TODOS los supervisores concatenados por coma \n"
                + "(SELECT GROUP_CONCAT(t_sup.full_name SEPARATOR ', ') "
                + " FROM proyecto_supervisor ps "
                + " JOIN trabajadores t_sup ON ps.id_trabajador = t_sup.id_trabajador "
                + " WHERE ps.id_proyecto = p.id_proyecto) AS nombre_supervisor, "
                + "-- Subconsulta para contar a todos los trabajadores del proyecto \n"
                + "(SELECT COUNT(id_trabajador) "
                + " FROM trabajadores "
                + " WHERE id_proyect = p.id_proyecto) AS total_trabajadores "
                + "FROM proyectos p "
                + "WHERE p.id_proyecto = ?;";
        
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
                
                // Si no hay supervisor, la BD devuelve NULL, lo manejamos con una validación rápida
                String supervisores = rs.getString("nombre_supervisor");
                ficha.setNombre_supervisor(supervisores != null ? supervisores : "Sin asignar");
                
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
