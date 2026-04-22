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

        // Aquí metemos la consulta avanzada que suma las nóminas y la maquinaria
        String sql = "SELECT "
                + "p.id_proyecto, "
                + "p.name_proyect AS nombre_proyecto, "
                + "p.estado, "
                + "p.presupuesto_total, "
                + "(SELECT GROUP_CONCAT(t.full_name SEPARATOR ', ') "
                + " FROM proyecto_supervisor ps "
                + " JOIN trabajadores t ON ps.id_trabajador = t.id_trabajador "
                + " WHERE ps.id_proyecto = p.id_proyecto) AS supervisor, "
                + "(SELECT COUNT(id_trabajador) "
                + " FROM trabajadores "
                + " WHERE id_proyect = p.id_proyecto) AS cantidad_trabajadores, "
                + "( "
                + "    IFNULL(( "
                + "        SELECT SUM(pn.monto_pagado) "
                + "        FROM pago_nomina pn "
                + "        JOIN trabajadores tr ON pn.id_trabajador = tr.id_trabajador "
                + "        WHERE tr.id_proyect = p.id_proyecto AND pn.estado = 'Autorizado' "
                + "    ), 0) "
                + "    + "
                + "    IFNULL(( "
                + "        SELECT SUM(pm.total_pagado) "
                + "        FROM pago_maquinaria pm "
                + "        JOIN uso_registro ur ON pm.id_uso = ur.id_uso "
                + "        WHERE ur.id_proyect = p.id_proyecto "
                + "    ), 0) "
                + ") AS total_pagado "
                + "FROM proyectos p "
                + "ORDER BY cantidad_trabajadores DESC;";

        List<ProyectoReporteDTO> ListaPReporte = new ArrayList<>();

        try {

            Connection con = ConectarBD.conectar();

            PreparedStatement ps = con.prepareStatement(sql);

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {

                ProyectoReporteDTO PR = new ProyectoReporteDTO();

                // Fíjate que aquí los nombres coinciden con los "AS" de la consulta SQL
                PR.setNombreProyecto(rs.getString("nombre_proyecto"));

                PR.setSupervisor(rs.getString("supervisor"));

                PR.setEstado(rs.getString("estado"));

                PR.setCantidadTrabajadores(rs.getInt("cantidad_trabajadores"));

               
                PR.setTotalPagado(rs.getDouble("total_pagado"));

                ListaPReporte.add(PR);

            }

        } catch (SQLException e) {

            e.printStackTrace();

        }

        return ListaPReporte;

    }

}
