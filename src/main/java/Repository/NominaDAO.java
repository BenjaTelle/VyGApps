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
            /* 
             * Convertimos el String a un objeto Date estricto de SQL.
             * Esto asume que tu JSP está enviando el formato "YYYY-MM-DD".
             */
            java.sql.Date sqlFechaInicio = java.sql.Date.valueOf(fechaInicio);
            java.sql.Date sqlFechaFin = java.sql.Date.valueOf(fechaFin);

            // Seteamos las fechas usando setDate() en lugar de setString()
            ps.setDate(1, sqlFechaInicio);
            ps.setDate(2, sqlFechaFin);
            ps.setDate(3, sqlFechaInicio);
            ps.setDate(4, sqlFechaFin);
            ps.setDate(5, sqlFechaInicio);
            ps.setDate(6, sqlFechaFin);
            ps.setInt(7, idAdmin);
            
            // Ejecutamos la inserción masiva
            int filasInsertadas = ps.executeUpdate();
            
            // Si insertó al menos 1 fila, es un éxito
            return filasInsertadas > 0;
            
        } catch (IllegalArgumentException e) {
            // Este error saltará si el JSP manda una fecha como "23/04/2026" en vez de "2026-04-23"
            System.out.println("Error de formato de fecha: Asegúrate de que el JSP envíe YYYY-MM-DD");
            e.printStackTrace();
            return false;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            if (ps != null) ps.close();
            if (con != null) con.close();
        }
    }
}