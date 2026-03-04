/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Repository;

import Conexion.ConectarBD;
import DTO.ProyectoReporteDTO;
import DTO.ReporteProyectoResumenDTO;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author Benja
 */
public class ProyectoReporteDAO {

// funcion proyectos activos 
    private int ProyectosAct() throws SQLException {

        String sql = "SELECT COUNT(id_proyecto) as ProyectosActivos FROM proyectos where estado='activo' ";
        Connection con = ConectarBD.conectar();
        PreparedStatement ps = con.prepareStatement(sql);
        int proyectosAct = 0;
        ResultSet rs = ps.executeQuery();
        if (rs.next()) {
            proyectosAct = rs.getInt("ProyectosActivos");

        }

        return proyectosAct;

    }

    //numero total de proyectos
    private int TotalProy() throws SQLException {

        String sql = "SELECT COUNT(id_proyecto) as TotalProyectos FROM proyectos";
        Connection con = ConectarBD.conectar();
        PreparedStatement ps = con.prepareStatement(sql);
        int TotalProyectos = 0;
        ResultSet rs = ps.executeQuery();
        if (rs.next()) {
            TotalProyectos = rs.getInt("TotalProyectos");

        }

        return TotalProyectos;

    }

    public ReporteProyectoResumenDTO resumenProyecto() throws SQLException {

        ReporteProyectoResumenDTO resumenPDTO = new ReporteProyectoResumenDTO();

        resumenPDTO.setProyectosActivos(ProyectosAct()); //seteamos los proyectos activos 
        resumenPDTO.setTotalProyectos(TotalProy()); //seteamos totalproyectos

        return resumenPDTO;

    }

        public List<ProyectoReporteDTO> listaReporteProyectos() throws SQLException {

            String sql = "SELECT p.name_proyect, MAX(CASE WHEN t.puesto = 'Supervisor de obra' THEN t.full_name END) AS full_name, COUNT(t.id_trabajador) AS total_trabajadores, p.estado FROM proyectos AS p "
                    + "LEFT JOIN trabajadores AS t ON p.id_proyecto = t.id_proyect GROUP BY p.id_proyecto, p.name_proyect, p.estado "
                    + "ORDER BY total_trabajadores DESC;";
            List<ProyectoReporteDTO> ListaPReporte = new ArrayList<>();
            try {
                Connection con = ConectarBD.conectar();
                PreparedStatement ps = con.prepareStatement(sql);

                ResultSet rs = ps.executeQuery();

                while (rs.next()) {
                    ProyectoReporteDTO PR = new ProyectoReporteDTO();

                    PR.setNombreProyecto(rs.getString("name_proyect"));
                    PR.setSupervisor(rs.getString("full_name"));
                    PR.setEstado(rs.getString("estado"));
                    PR.setCantidadTrabajadores(rs.getInt("total_trabajadores"));
                    ListaPReporte.add(PR);

                }

            } catch (SQLException e) {
                e.printStackTrace();
            }
            return ListaPReporte;
        }

}
