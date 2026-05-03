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
        
        DashboardAdminDTO dashboard = new DashboardAdminDTO();
        List<String> alertas = new ArrayList<>();
        DecimalFormat formatoMoneda = new DecimalFormat("C$ #,##0.00");
        
        // Valores por defecto
        dashboard.setTotalPagadoMes("C$ 0.00");
        dashboard.setTotalPendiente("C$ 0.00");
        dashboard.setPresupuestoGlobal("C$ 0.00");
        dashboard.setPlanillasPendientes(0);

        Connection con = ConectarBD.conectar();

        // ==========================================
        // CONSULTA 1: Total Pagado en el mes (NÓMINA + MAQUINARIA)
        // ==========================================
        String sql1 = "SELECT IFNULL(SUM(monto), 0) AS total_pagado FROM (" +
                      "  SELECT monto_pagado AS monto FROM pago_nomina WHERE estado = 'Autorizado' AND MONTH(fecha_generacion) = MONTH(CURRENT_DATE()) AND YEAR(fecha_generacion) = YEAR(CURRENT_DATE()) " +
                      "  UNION ALL " +
                      "  SELECT total_pagado AS monto FROM pago_maquinaria WHERE estado = 'Autorizado' AND MONTH(fecha_generacion) = MONTH(CURRENT_DATE()) AND YEAR(fecha_generacion) = YEAR(CURRENT_DATE())" +
                      ") AS pagos_mensuales";
        
        try (PreparedStatement ps1 = con.prepareStatement(sql1); ResultSet rs1 = ps1.executeQuery()) {
            if (rs1.next()) {
                dashboard.setTotalPagadoMes(formatoMoneda.format(rs1.getDouble("total_pagado")));
            }
        } catch (SQLException e) { e.printStackTrace(); }

        // ==========================================
        // CONSULTA 2: Total Pendiente y Cantidad (NÓMINA + MAQUINARIA)
        // ==========================================
        String sql2 = "SELECT IFNULL(SUM(monto), 0) AS total_pendiente, COUNT(*) AS cantidad_pendiente FROM (" +
                      "  SELECT monto_pagado AS monto FROM pago_nomina WHERE estado = 'Pendiente' " +
                      "  UNION ALL " +
                      "  SELECT total_pagado AS monto FROM pago_maquinaria WHERE estado = 'Pendiente'" +
                      ") AS pagos_pendientes";
        
        try (PreparedStatement ps2 = con.prepareStatement(sql2); ResultSet rs2 = ps2.executeQuery()) {
            if (rs2.next()) {
                dashboard.setTotalPendiente(formatoMoneda.format(rs2.getDouble("total_pendiente")));
                dashboard.setPlanillasPendientes(rs2.getInt("cantidad_pendiente"));
            }
        } catch (SQLException e) { e.printStackTrace(); }

        // ==========================================
        // CONSULTA 3: Presupuesto Global Disponible (Queda igual)
        // ==========================================
        String sql3 = "SELECT IFNULL(SUM(presupuesto_total), 0) AS presupuesto_global FROM proyectos WHERE estado = 'activo'";
        try (PreparedStatement ps3 = con.prepareStatement(sql3); ResultSet rs3 = ps3.executeQuery()) {
            if (rs3.next()) {
                dashboard.setPresupuestoGlobal(formatoMoneda.format(rs3.getDouble("presupuesto_global")));
            }
        } catch (SQLException e) { e.printStackTrace(); }

        // ==========================================
        // CONSULTA 4: Alertas de Atrasos (NÓMINA + MAQUINARIA)
        // ==========================================
        String sql4 = "SELECT DISTINCT proyecto, MAX(dias_retraso) AS max_retraso FROM (" +
                      "  SELECT pr.name_proyect AS proyecto, DATEDIFF(CURRENT_DATE(), pn.fecha_generacion) AS dias_retraso " +
                      "  FROM pago_nomina pn INNER JOIN trabajadores t ON pn.id_trabajador = t.id_trabajador INNER JOIN proyectos pr ON t.id_proyect = pr.id_proyecto WHERE pn.estado = 'Pendiente' " +
                      "  UNION ALL " +
                      "  SELECT pr.name_proyect AS proyecto, DATEDIFF(CURRENT_DATE(), pm.fecha_generacion) AS dias_retraso " +
                      "  FROM pago_maquinaria pm INNER JOIN uso_registro ur ON pm.id_uso = ur.id_uso INNER JOIN proyectos pr ON ur.id_proyect = pr.id_proyecto WHERE pm.estado = 'Pendiente'" +
                      ") AS alertas_pendientes " +
                      "WHERE dias_retraso >= 2 " +
                      "GROUP BY proyecto";
        
        try (PreparedStatement ps4 = con.prepareStatement(sql4); ResultSet rs4 = ps4.executeQuery()) {
            while (rs4.next()) {
                String proyecto = rs4.getString("proyecto");
                int dias = rs4.getInt("max_retraso");
                alertas.add("Pagos del proyecto <strong>'" + proyecto + "'</strong> llevan <strong>" + dias + " días</strong> esperando autorización.");
            }
            dashboard.setAlertas(alertas);
        } catch (SQLException e) { e.printStackTrace(); }

        return dashboard;
    }
}