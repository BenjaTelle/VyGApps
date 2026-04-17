/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Repository;

import Conexion.ConectarBD;
import DTO.DashboardAdminDTO;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.DecimalFormat;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author Benja
 */
public class DashboardDAO {

    public DashboardAdminDTO obtenerDatosDashboardAdmin() throws SQLException {
        
        // 1. Declaración de objetos (Como lo haces antes de los trys)
        DashboardAdminDTO dashboard = new DashboardAdminDTO();
        List<String> alertas = new ArrayList<>();
        DecimalFormat formatoMoneda = new DecimalFormat("C$ #,##0.00");
        
        // Valores por defecto
        dashboard.setTotalPagadoMes("C$ 0.00");
        dashboard.setTotalPendiente("C$ 0.00");
        dashboard.setPresupuestoGlobal("C$ 0.00");
        dashboard.setPlanillasPendientes(0);

        // Abres tu conexión (Una sola vez para todas las consultas de este método)
        Connection con = ConectarBD.conectar();

        // ==========================================
        // CONSULTA 1: Total Pagado en el mes
        // ==========================================
        String sql1 = "SELECT IFNULL(SUM(monto_pagado), 0) AS total_pagado FROM pago_nomina WHERE estado = 'Autorizado' AND MONTH(fecha_generacion) = MONTH(CURRENT_DATE()) AND YEAR(fecha_generacion) = YEAR(CURRENT_DATE())";
        PreparedStatement ps1 = con.prepareStatement(sql1);
        try {
            ResultSet rs1 = ps1.executeQuery();
            if (rs1.next()) {
                dashboard.setTotalPagadoMes(formatoMoneda.format(rs1.getDouble("total_pagado")));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        // ==========================================
        // CONSULTA 2: Total Pendiente y Cantidad
        // ==========================================
        String sql2 = "SELECT IFNULL(SUM(monto_pagado), 0) AS total_pendiente, COUNT(id_pago_nomina) AS cantidad_pendiente FROM pago_nomina WHERE estado = 'Pendiente'";
        PreparedStatement ps2 = con.prepareStatement(sql2);
        try {
            ResultSet rs2 = ps2.executeQuery();
            if (rs2.next()) {
                dashboard.setTotalPendiente(formatoMoneda.format(rs2.getDouble("total_pendiente")));
                dashboard.setPlanillasPendientes(rs2.getInt("cantidad_pendiente"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        // ==========================================
        // CONSULTA 3: Presupuesto Global Disponible
        // ==========================================
        String sql3 = "SELECT IFNULL(SUM(presupuesto_total), 0) AS presupuesto_global FROM proyectos WHERE estado = 'activo'";
        PreparedStatement ps3 = con.prepareStatement(sql3);
        try {
            ResultSet rs3 = ps3.executeQuery();
            if (rs3.next()) {
                dashboard.setPresupuestoGlobal(formatoMoneda.format(rs3.getDouble("presupuesto_global")));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        // ==========================================
        // CONSULTA 4: Alertas de Supervisores Atrasados
        // ==========================================
        String sql4 = "SELECT DISTINCT pr.name_proyect, DATEDIFF(CURRENT_DATE(), pn.fecha_generacion) as dias_retraso FROM pago_nomina pn INNER JOIN trabajadores t ON pn.id_trabajador = t.id_trabajador INNER JOIN proyectos pr ON t.id_proyect = pr.id_proyecto WHERE pn.estado = 'Pendiente' AND DATEDIFF(CURRENT_DATE(), pn.fecha_generacion) >= 2";
        PreparedStatement ps4 = con.prepareStatement(sql4);
        try {
            ResultSet rs4 = ps4.executeQuery();
            while (rs4.next()) {
                String proyecto = rs4.getString("name_proyect");
                int dias = rs4.getInt("dias_retraso");
                
                alertas.add("Planillas del proyecto <strong>'" + proyecto + "'</strong> llevan <strong>" + dias + " días</strong> esperando autorización.");
            }
            dashboard.setAlertas(alertas);
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return dashboard;
    }
}