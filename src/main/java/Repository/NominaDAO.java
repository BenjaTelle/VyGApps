/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Repository;

import Conexion.ConectarBD;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

/**
 *
 * @author Benja
 */
public class NominaDAO {

    public boolean generarPlanillaMasiva(String fechaInicio, String fechaFin, int idAdmin) throws SQLException {
        
        // Esta super consulta calcula los días asistidos y el pago proporcional en un solo movimiento
        String sql = "INSERT INTO pago_nomina (fecha_generacion, periodo_inicio, periodo_fin, dias_trabajados, monto_pagado, estado, id_trabajador, id_user_genera) " +
                     "SELECT " +
                     "   CURRENT_DATE(), " +
                     "   ?, " +  // periodo_inicio (1)
                     "   ?, " +  // periodo_fin (2)
                     "   IFNULL((SELECT COUNT(DISTINCT a.fecha) FROM asistencia a WHERE a.id_trabajador = t.id_trabajador AND a.fecha >= ? AND a.fecha <= ?), 0) AS dias, " + // (3, 4)
                     "   (t.salario_quincenal / 15.0) * IFNULL((SELECT COUNT(DISTINCT a.fecha) FROM asistencia a WHERE a.id_trabajador = t.id_trabajador AND a.fecha >= ? AND a.fecha <= ?), 0) AS pago, " + // (5, 6)
                     "   'Pendiente', " +
                     "   t.id_trabajador, " +
                     "   ? " +   // id_user_genera (7)
                     "FROM trabajadores t " +
                     "WHERE t.id_proyect IS NOT NULL"; // Solo generamos pago a quienes tengan un proyecto asignado

        Connection con = ConectarBD.conectar();
        PreparedStatement ps = con.prepareStatement(sql);
        
        try {
            // Seteamos las fechas en todos los lugares de la consulta
            ps.setString(1, fechaInicio);
            ps.setString(2, fechaFin);
            ps.setString(3, fechaInicio);
            ps.setString(4, fechaFin);
            ps.setString(5, fechaInicio);
            ps.setString(6, fechaFin);
            ps.setInt(7, idAdmin);
            
            // Ejecutamos la inserción masiva
            int filasInsertadas = ps.executeUpdate();
            
            // Si insertó al menos 1 fila, es un éxito
            return filasInsertadas > 0;
            
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            if (ps != null) ps.close();
            if (con != null) con.close();
        }
    }
}