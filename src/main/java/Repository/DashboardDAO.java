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

public class DashboardDAO {

    public DashboardAdminDTO obtenerDatosDashboardAdmin() throws SQLException {
        DashboardAdminDTO dashboard = new DashboardAdminDTO();
        List<String> alertas = new ArrayList<>();
        DecimalFormat formatoMoneda = new DecimalFormat("C$ #,##0.00");
        
        dashboard.setTotalPagadoMes("C$ 0.00");
        dashboard.setTotalPendiente("C$ 0.00");
        dashboard.setPresupuestoGlobal("C$ 0.00");
        dashboard.setPlanillasPendientes(0);

        Connection con = ConectarBD.conectar();
        PreparedStatement ps = null;
        ResultSet rs = null;

        String sqlPagado = "SELECT IFNULL(SUM(monto), 0) AS total_pagado FROM (" +
                           "  SELECT monto_pagado AS monto FROM pago_nomina WHERE estado = 'Autorizado' AND MONTH(fecha_generacion) = MONTH(CURRENT_DATE()) AND YEAR(fecha_generacion) = YEAR(CURRENT_DATE()) " +
                           "  UNION ALL " +
                           "  SELECT total_pagado AS monto FROM pago_maquinaria WHERE estado = 'Autorizado' AND MONTH(fecha_generacion) = MONTH(CURRENT_DATE()) AND YEAR(fecha_generacion) = YEAR(CURRENT_DATE()) " +
                           "  UNION ALL " +
                           "  SELECT monto AS monto FROM gastos_proyectos WHERE estado = 'Aprobado' AND MONTH(fecha_autorizacion) = MONTH(CURRENT_DATE()) AND YEAR(fecha_autorizacion) = YEAR(CURRENT_DATE())" +
                           ") AS pagos_mensuales";
        try {
            ps = con.prepareStatement(sqlPagado);
            rs = ps.executeQuery();
            if (rs.next()) dashboard.setTotalPagadoMes(formatoMoneda.format(rs.getDouble("total_pagado")));
        } catch (SQLException e) { e.printStackTrace(); }

        String sqlPendiente = "SELECT IFNULL(SUM(monto), 0) AS total_pendiente FROM (" +
                              "  SELECT monto_pagado AS monto FROM pago_nomina WHERE estado = 'Pendiente' " +
                              "  UNION ALL " +
                              "  SELECT total_pagado AS monto FROM pago_maquinaria WHERE estado = 'Pendiente' " +
                              "  UNION ALL " +
                              "  SELECT monto AS monto FROM gastos_proyectos WHERE estado = 'Pendiente'" +
                              ") AS pagos_pendientes";
        try {
            ps = con.prepareStatement(sqlPendiente);
            rs = ps.executeQuery();
            if (rs.next()) dashboard.setTotalPendiente(formatoMoneda.format(rs.getDouble("total_pendiente")));
        } catch (SQLException e) { e.printStackTrace(); }

        String sqlCount = "SELECT COUNT(*) AS cantidad FROM (" +
                          "  SELECT id_pago_nomina FROM pago_nomina WHERE estado = 'Pendiente' " +
                          "  UNION ALL " +
                          "  SELECT id_pago_maq FROM pago_maquinaria WHERE estado = 'Pendiente'" +
                          ") AS conteo_planillas";
        try {
            ps = con.prepareStatement(sqlCount);
            rs = ps.executeQuery();
            if (rs.next()) dashboard.setPlanillasPendientes(rs.getInt("cantidad"));
        } catch (SQLException e) { e.printStackTrace(); }

        String sqlPresupuesto = "SELECT IFNULL(SUM(presupuesto_total), 0) AS global FROM proyectos WHERE estado = 'activo'";
        try {
            ps = con.prepareStatement(sqlPresupuesto);
            rs = ps.executeQuery();
            if (rs.next()) dashboard.setPresupuestoGlobal(formatoMoneda.format(rs.getDouble("global")));
        } catch (SQLException e) { e.printStackTrace(); }

        String sqlAlertasSup = "SELECT proyecto, MAX(dias_retraso) AS max_retraso FROM (" +
                               "  SELECT pr.name_proyect AS proyecto, DATEDIFF(CURRENT_DATE(), pn.fecha_generacion) AS dias_retraso " +
                               "  FROM pago_nomina pn INNER JOIN trabajadores t ON pn.id_trabajador = t.id_trabajador INNER JOIN proyectos pr ON t.id_proyect = pr.id_proyecto WHERE pn.estado = 'Pendiente' " +
                               "  UNION ALL " +
                               "  SELECT pr.name_proyect AS proyecto, DATEDIFF(CURRENT_DATE(), pm.fecha_generacion) AS dias_retraso " +
                               "  FROM pago_maquinaria pm INNER JOIN uso_registro ur ON pm.id_uso = ur.id_uso INNER JOIN proyectos pr ON ur.id_proyect = pr.id_proyecto WHERE pm.estado = 'Pendiente' " +
                               ") AS retrasos WHERE dias_retraso >= 2 GROUP BY proyecto";
        try {
            ps = con.prepareStatement(sqlAlertasSup);
            rs = ps.executeQuery();
            while (rs.next()) {
                alertas.add("Los supervisores del proyecto <strong>'" + rs.getString("proyecto") + "'</strong> llevan <strong>" + rs.getInt("max_retraso") + " días</strong> sin autorizar planillas.");
            }
        } catch (SQLException e) { e.printStackTrace(); }

        String sqlAlertasAdmin = "SELECT COUNT(*) AS total_gastos FROM gastos_proyectos WHERE estado = 'Pendiente'";
        try {
            ps = con.prepareStatement(sqlAlertasAdmin);
            rs = ps.executeQuery();
            if (rs.next()) {
                int totalGastos = rs.getInt("total_gastos");
                if (totalGastos > 0) alertas.add("Tienes <strong>" + totalGastos + " gastos pendientes</strong> de auditar en tu bandeja.");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            try {
                if (rs != null) rs.close();
                if (ps != null) ps.close();
                if (con != null) con.close();
            } catch (SQLException ex) { ex.printStackTrace(); }
        }

        dashboard.setAlertas(alertas);
        return dashboard;
    }
}