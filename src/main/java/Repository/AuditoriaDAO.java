package Repository;

import Conexion.ConectarBD;
import DTO.AuditoriaPagoDTO;
import DTO.MonitorPendientesDTO;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class AuditoriaDAO {

    public List<MonitorPendientesDTO> listarMonitorPendientes() throws SQLException {
        String sql = "SELECT pr.name_proyect, " +
                     "(SELECT t.full_name FROM trabajadores t WHERE t.id_proyect = pr.id_proyecto AND t.puesto = 'Supervisor de obra' LIMIT 1) AS supervisor, " +
                     "MIN(pu.fecha_generacion) AS fecha_generacion, SUM(pu.monto) AS monto_total, " +
                     "DATEDIFF(CURRENT_DATE(), MIN(pu.fecha_generacion)) AS dias_retraso " +
                     "FROM proyectos pr " +
                     "INNER JOIN ( " +
                     "  SELECT tr.id_proyect AS id_proyecto, pn.fecha_generacion, pn.monto_pagado AS monto " +
                     "  FROM pago_nomina pn INNER JOIN trabajadores tr ON pn.id_trabajador = tr.id_trabajador WHERE pn.estado = 'Pendiente' " +
                     "  UNION ALL " +
                     "  SELECT ur.id_proyect AS id_proyecto, pm.fecha_generacion, pm.total_pagado AS monto " +
                     "  FROM pago_maquinaria pm INNER JOIN uso_registro ur ON pm.id_uso = ur.id_uso WHERE pm.estado = 'Pendiente' " +
                     ") pu ON pr.id_proyecto = pu.id_proyecto " +
                     "GROUP BY pr.id_proyecto, pr.name_proyect " +
                     "ORDER BY dias_retraso DESC";

        List<MonitorPendientesDTO> lista = new ArrayList<>();
        
        try (Connection con = ConectarBD.conectar();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                MonitorPendientesDTO m = new MonitorPendientesDTO();
                m.setNombreProyecto(rs.getString("name_proyect"));
                
                String superv = rs.getString("supervisor");
                m.setNombreSupervisor(superv != null ? superv : "Sin asignar");
                
                m.setFechaGeneracion(rs.getString("fecha_generacion"));
                m.setMontoTotal(rs.getDouble("monto_total"));
                m.setDiasRetraso(rs.getInt("dias_retraso"));
                lista.add(m);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            throw e;
        }
        return lista;
    }

    public List<AuditoriaPagoDTO> buscarHistorialGlobal(String criterio) {
        List<AuditoriaPagoDTO> lista = new ArrayList<>();
        String filtro = "%" + criterio + "%";
        
        String sql = 
            "SELECT CONCAT('NOM-', pn.id_pago_nomina) AS recibo, 'Nómina' AS tipo, t.full_name AS concepto, pr.name_proyect AS proyecto, " +
            "ugen.user_name AS generado, uaut.user_name AS autorizado, CAST(pn.fecha_generacion AS CHAR) AS fecha, pn.monto_pagado AS monto " +
            "FROM pago_nomina pn " +
            "INNER JOIN trabajadores t ON pn.id_trabajador = t.id_trabajador " +
            "INNER JOIN proyectos pr ON t.id_proyect = pr.id_proyecto " +
            "INNER JOIN usuarios ugen ON pn.id_user_genera = ugen.id_user " +
            "INNER JOIN usuarios uaut ON pn.id_user_autoriza = uaut.id_user " +
            "WHERE pn.estado = 'Autorizado' AND (t.full_name LIKE ? OR pr.name_proyect LIKE ?) " +
            
            "UNION ALL " +
            
            "SELECT CONCAT('MAQ-', pm.id_pago_maq) AS recibo, 'Maquinaria' AS tipo, CONCAT(m.tipo_maquina, ' ', m.marca) AS concepto, pr.name_proyect AS proyecto, " +
            "ugen.user_name AS generado, uaut.user_name AS autorizado, CAST(pm.fecha_generacion AS CHAR) AS fecha, pm.total_pagado AS monto " +
            "FROM pago_maquinaria pm " +
            "INNER JOIN uso_registro ur ON pm.id_uso = ur.id_uso " +
            "INNER JOIN maquinas m ON ur.id_maquinaria = m.id_maquina " +
            "INNER JOIN proyectos pr ON ur.id_proyect = pr.id_proyecto " +
            "INNER JOIN usuarios ugen ON pm.id_user_genera = ugen.id_user " +
            "INNER JOIN usuarios uaut ON pm.id_user_autoriza = uaut.id_user " +
            "WHERE pm.estado = 'Autorizado' AND (m.tipo_maquina LIKE ? OR m.marca LIKE ? OR pr.name_proyect LIKE ?) " +
            
            "UNION ALL " +
            
            "SELECT CONCAT('GST-', gp.id_gasto) AS recibo, 'Gasto Vario' AS tipo, gp.concepto AS concepto, pr.name_proyect AS proyecto, " +
            "ugen.user_name AS generado, uaut.user_name AS autorizado, CAST(gp.fecha_autorizacion AS CHAR) AS fecha, gp.monto AS monto " +
            "FROM gastos_proyectos gp " +
            "INNER JOIN proyectos pr ON gp.id_proyecto = pr.id_proyecto " +
            "INNER JOIN usuarios ugen ON gp.id_user_registra = ugen.id_user " +
            "INNER JOIN usuarios uaut ON gp.id_user_autoriza = uaut.id_user " +
            "WHERE gp.estado = 'Aprobado' AND (gp.concepto LIKE ? OR pr.name_proyect LIKE ?) " +
            
            "ORDER BY fecha DESC";

        try (Connection con = ConectarBD.conectar();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ps.setString(1, filtro);
            ps.setString(2, filtro);
            ps.setString(3, filtro);
            ps.setString(4, filtro);
            ps.setString(5, filtro);
            ps.setString(6, filtro);
            ps.setString(7, filtro);
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    AuditoriaPagoDTO d = new AuditoriaPagoDTO();
                    d.setCodigoRecibo(rs.getString("recibo"));
                    d.setTipoPago(rs.getString("tipo"));
                    d.setConcepto(rs.getString("concepto"));
                    d.setNombreProyecto(rs.getString("proyecto"));
                    d.setGeneradoPor(rs.getString("generado"));
                    d.setAutorizadoPor(rs.getString("autorizado"));
                    d.setFechaPago(rs.getString("fecha"));
                    d.setMontoPagado(rs.getDouble("monto"));
                    lista.add(d);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return lista;
    }

    public List<AuditoriaPagoDTO> historialSupervisor(int idSupervisor, String mesFiltro) throws SQLException {
        List<AuditoriaPagoDTO> lista = new ArrayList<>();
        String filtroFecha = (mesFiltro != null && !mesFiltro.trim().isEmpty()) ? mesFiltro + "%" : "%";

        String sql = 
            "SELECT CONCAT('NOM-', pn.id_pago_nomina) AS recibo, 'Nómina' AS tipo, t.full_name AS concepto, CAST(pn.fecha_generacion AS CHAR) AS fecha, pn.monto_pagado AS monto " +
            "FROM pago_nomina pn " +
            "INNER JOIN trabajadores t ON pn.id_trabajador = t.id_trabajador " +
            "WHERE pn.estado = 'Autorizado' AND pn.id_user_autoriza = ? AND CAST(pn.fecha_generacion AS CHAR) LIKE ? " +
            
            "UNION ALL " +
            
            "SELECT CONCAT('MAQ-', pm.id_pago_maq) AS recibo, 'Maquinaria' AS tipo, CONCAT(m.tipo_maquina, ' ', m.marca) AS concepto, CAST(pm.fecha_generacion AS CHAR) AS fecha, pm.total_pagado AS monto " +
            "FROM pago_maquinaria pm " +
            "INNER JOIN uso_registro ur ON pm.id_uso = ur.id_uso " +
            "INNER JOIN maquinas m ON ur.id_maquinaria = m.id_maquina " +
            "WHERE pm.estado = 'Autorizado' AND pm.id_user_autoriza = ? AND CAST(pm.fecha_generacion AS CHAR) LIKE ? " +
            
            "UNION ALL " +
            
            "SELECT CONCAT('GST-', gp.id_gasto) AS recibo, 'Gasto Vario' AS tipo, gp.concepto AS concepto, CAST(gp.fecha_autorizacion AS CHAR) AS fecha, gp.monto AS monto " +
            "FROM gastos_proyectos gp " +
            "WHERE gp.estado = 'Aprobado' AND gp.id_user_registra = ? AND CAST(gp.fecha_autorizacion AS CHAR) LIKE ? " +
            
            "ORDER BY fecha DESC";

        try (Connection con = ConectarBD.conectar();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ps.setInt(1, idSupervisor);
            ps.setString(2, filtroFecha);
            ps.setInt(3, idSupervisor);
            ps.setString(4, filtroFecha);
            ps.setInt(5, idSupervisor);
            ps.setString(6, filtroFecha);
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    AuditoriaPagoDTO dto = new AuditoriaPagoDTO();
                    dto.setCodigoRecibo(rs.getString("recibo"));
                    dto.setTipoPago(rs.getString("tipo"));
                    dto.setConcepto(rs.getString("concepto"));
                    dto.setFechaPago(rs.getString("fecha"));
                    dto.setMontoPagado(rs.getDouble("monto"));
                    lista.add(dto);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            throw e;
        }
        return lista;
    }
}