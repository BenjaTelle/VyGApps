/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
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
        // Buscamos las planillas pendientes, agrupamos por proyecto, sumamos la plata y sacamos el retraso
        String sql = "SELECT " +
                     "   pr.name_proyect, " +
                     "   (SELECT t.full_name FROM trabajadores t WHERE t.id_proyect = pr.id_proyecto AND t.puesto = 'Supervisor de obra' LIMIT 1) as supervisor, " +
                     "   MIN(pn.fecha_generacion) as fecha_generacion, " +
                     "   SUM(pn.monto_pagado) as monto_total, " +
                     "   DATEDIFF(CURRENT_DATE(), MIN(pn.fecha_generacion)) as dias_retraso " +
                     "FROM pago_nomina pn " +
                     "INNER JOIN trabajadores tr ON pn.id_trabajador = tr.id_trabajador " +
                     "INNER JOIN proyectos pr ON tr.id_proyect = pr.id_proyecto " +
                     "WHERE pn.estado = 'Pendiente' " +
                     "GROUP BY pr.id_proyecto, pr.name_proyect " +
                     "ORDER BY dias_retraso DESC";

        Connection con = ConectarBD.conectar();
        PreparedStatement ps = con.prepareStatement(sql);
        List<MonitorPendientesDTO> lista = new ArrayList<>();
        
        try {
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                MonitorPendientesDTO m = new MonitorPendientesDTO();
                m.setNombreProyecto(rs.getString("name_proyect"));
                
                // Si por alguna razón no hay supervisor asignado, evitamos nulos
                String superv = rs.getString("supervisor");
                m.setNombreSupervisor(superv != null ? superv : "Sin asignar");
                
                m.setFechaGeneracion(rs.getString("fecha_generacion"));
                m.setMontoTotal(rs.getDouble("monto_total"));
                m.setDiasRetraso(rs.getInt("dias_retraso"));
                
                lista.add(m);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return lista;
    }
    // Agrega este método a tu AuditoriaDAO
public List<AuditoriaPagoDTO> buscarHistorialGlobal(String criterio) throws SQLException {
    List<AuditoriaPagoDTO> lista = new ArrayList<>();
    String filtro = "%" + criterio + "%";
    
    // Consulta combinada: Nómina + Maquinaria
    String sql = 
        // --- PARTE 1: NÓMINA ---
        "SELECT CONCAT('NOM-', pn.id_pago_nomina) AS recibo, 'Nómina' AS tipo, " +
        "t.full_name AS concepto, pr.name_proyect AS proyecto, " +
        "ugen.user_name AS generado, uaut.user_name AS autorizado, " +
        "pn.fecha_generacion AS fecha, pn.monto_pagado AS monto " +
        "FROM pago_nomina pn " +
        "INNER JOIN trabajadores t ON pn.id_trabajador = t.id_trabajador " +
        "INNER JOIN proyectos pr ON t.id_proyect = pr.id_proyecto " +
        "INNER JOIN usuarios ugen ON pn.id_user_genera = ugen.id_user " +
        "INNER JOIN usuarios uaut ON pn.id_user_autoriza = uaut.id_user " +
        "WHERE pn.estado = 'Autorizado' AND (t.full_name LIKE ? OR pr.name_proyect LIKE ?) " +
        
        "UNION ALL " +
        
        // --- PARTE 2: MAQUINARIA ---
        "SELECT CONCAT('MAQ-', pm.id_pago_maq) AS recibo, 'Maquinaria' AS tipo, " +
        "CONCAT(m.tipo_maquina, ' ', m.marca) AS concepto, pr.name_proyect AS proyecto, " +
        "ugen.user_name AS generado, uaut.user_name AS autorizado, " +
        "pm.fecha_generacion AS fecha, pm.total_pagado AS monto " +
        "FROM pago_maquinaria pm " +
        "INNER JOIN uso_registro ur ON pm.id_uso = ur.id_uso " +
        "INNER JOIN maquinas m ON ur.id_maquinaria = m.id_maquina " +
        "INNER JOIN proyectos pr ON ur.id_proyect = pr.id_proyecto " +
        "INNER JOIN usuarios ugen ON pm.id_user_genera = ugen.id_user " +
        "INNER JOIN usuarios uaut ON pm.id_user_autoriza = uaut.id_user " +
        "WHERE pm.estado = 'Autorizado' AND (m.tipo_maquina LIKE ? OR pr.name_proyect LIKE ?) " +
        
        "ORDER BY fecha DESC";

    Connection con = ConectarBD.conectar();
    PreparedStatement ps = con.prepareStatement(sql);
    
    try {
        // Pasamos el filtro a los 4 signos de interrogación (2 para nómina, 2 para maquinaria)
        ps.setString(1, filtro);
        ps.setString(2, filtro);
        ps.setString(3, filtro);
        ps.setString(4, filtro);
        
        ResultSet rs = ps.executeQuery();
        while (rs.next()) {
            AuditoriaPagoDTO dto = new AuditoriaPagoDTO();
            dto.setCodigoRecibo(rs.getString("recibo"));
            dto.setTipoPago(rs.getString("tipo"));
            dto.setConcepto(rs.getString("concepto"));
            dto.setNombreProyecto(rs.getString("proyecto"));
            dto.setGeneradoPor(rs.getString("generado"));
            dto.setAutorizadoPor(rs.getString("autorizado"));
            dto.setFechaPago(rs.getString("fecha"));
            dto.setMontoPagado(rs.getDouble("monto"));
            lista.add(dto);
        }
    } catch (SQLException e) {
        e.printStackTrace();
    }
    return lista;
}
    // Trae el historial exclusivo de un supervisor, con opción de filtrar por mes
    public List<AuditoriaPagoDTO> historialSupervisor(int idSupervisor, String mesFiltro) throws SQLException {
        List<AuditoriaPagoDTO> lista = new ArrayList<>();
        
        // El input de HTML 'month' manda el dato como "YYYY-MM" (ej. "2026-04").
        // Si viene vacío, usamos "%" para traer todos los meses.
        String filtroFecha = (mesFiltro != null && !mesFiltro.trim().isEmpty()) ? mesFiltro + "%" : "%";

        String sql = 
            // NÓMINA
            "SELECT CONCAT('NOM-', pn.id_pago_nomina) AS recibo, 'Nómina' AS tipo, " +
            "t.full_name AS concepto, pn.fecha_generacion AS fecha, pn.monto_pagado AS monto " +
            "FROM pago_nomina pn " +
            "INNER JOIN trabajadores t ON pn.id_trabajador = t.id_trabajador " +
            "WHERE pn.estado = 'Autorizado' AND pn.id_user_autoriza = ? AND pn.fecha_generacion LIKE ? " +
            
            "UNION ALL " +
            
            // MAQUINARIA
            "SELECT CONCAT('MAQ-', pm.id_pago_maq) AS recibo, 'Maquinaria' AS tipo, " +
            "CONCAT(m.tipo_maquina, ' ', m.marca) AS concepto, pm.fecha_generacion AS fecha, pm.total_pagado AS monto " +
            "FROM pago_maquinaria pm " +
            "INNER JOIN uso_registro ur ON pm.id_uso = ur.id_uso " +
            "INNER JOIN maquinas m ON ur.id_maquinaria = m.id_maquina " +
            "WHERE pm.estado = 'Autorizado' AND pm.id_user_autoriza = ? AND pm.fecha_generacion LIKE ? " +
            
            "ORDER BY fecha DESC";

        Connection con = ConectarBD.conectar();
        PreparedStatement ps = con.prepareStatement(sql);
        
        try {
            ps.setInt(1, idSupervisor);
            ps.setString(2, filtroFecha);
            ps.setInt(3, idSupervisor);
            ps.setString(4, filtroFecha);
            
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                AuditoriaPagoDTO dto = new AuditoriaPagoDTO();
                dto.setCodigoRecibo(rs.getString("recibo"));
                dto.setTipoPago(rs.getString("tipo"));
                dto.setConcepto(rs.getString("concepto"));
                dto.setFechaPago(rs.getString("fecha"));
                dto.setMontoPagado(rs.getDouble("monto"));
                // Solo llenamos los campos que la vista del supervisor necesita
                lista.add(dto);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return lista;
    }
    
}