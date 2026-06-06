package Repository;

import Conexion.ConectarBD;
import DTO.CicloPlanillaDTO;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

public class NominaDAO {

    public List<CicloPlanillaDTO> obtenerEstadoCiclos() {
        List<CicloPlanillaDTO> listaCiclos = new ArrayList<>();
        String sql = "SELECT tipo_nomina, dias_ciclo, ultima_ejecucion FROM control_planillas";

        try (Connection con = ConectarBD.conectar();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            LocalDate fechaActual = LocalDate.now();

            while (rs.next()) {
                CicloPlanillaDTO ciclo = new CicloPlanillaDTO();
                ciclo.setTipoNomina(rs.getString("tipo_nomina"));
                ciclo.setDiasCiclo(rs.getInt("dias_ciclo"));
                
                LocalDate ultima = rs.getDate("ultima_ejecucion").toLocalDate();
                LocalDate proximo = ultima.plusDays(ciclo.getDiasCiclo());
                
                ciclo.setUltimaEjecucion(ultima);
                ciclo.setProximoPago(proximo);
                
                ciclo.setHabilitado(!fechaActual.isBefore(proximo));

                listaCiclos.add(ciclo);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return listaCiclos;
    }

    public boolean generarPlanillaAutomatizada(String tipoNomina, int diasCiclo, String fechaInicio, String fechaFin, int idAdmin) throws SQLException {
        
        // 1. SÚPER CONSULTA AJUSTADA A TU ESQUEMA REAL
        String sqlInsert = "INSERT INTO pago_nomina (fecha_generacion, periodo_inicio, periodo_fin, dias_trabajados, monto_pagado, estado, id_trabajador, id_user_genera, monto_horas_extras, dias_justificados) " +
                     "SELECT " +
                     "   CURDATE(), " +
                     "   ?, " +  
                     "   ?, " +  
                     "   COUNT(DISTINCT a.fecha) AS dias, " + 
                     "   ( " +
                     "       ((t.salario_quincenal / ?) * COUNT(DISTINCT a.fecha)) " + // Pago Proporcional
                     "       + SUM(IFNULL(a.horas_extras, 0) * IFNULL(p.tarifa_hora_extra, 0)) " + // + Horas Extras
                     "       - ( " + 
                     "           ((t.salario_quincenal / ?) * " + // - Descuentos
                     "           SUM(CASE " +
                     "               WHEN a.marca_anomala = 1 THEN " +
                     "                   CASE WHEN j.estado = 'Aprobada' THEN 0 ELSE 1 END " +
                     "               ELSE 0 " +
                     "           END)) " +
                     "       ) " +
                     "   ) AS pago_total, " +
                     "   'Pendiente', " +
                     "   t.id_trabajador, " +
                     "   ?, " +   
                     "   SUM(IFNULL(a.horas_extras, 0) * IFNULL(p.tarifa_hora_extra, 0)) AS total_extras, " + // Guarda extras en su propia columna
                     "   SUM(CASE WHEN a.marca_anomala = 1 AND j.estado = 'Aprobada' THEN 1 ELSE 0 END) AS justificados " + // Guarda cuántos días se perdonaron
                     "FROM trabajadores t " +
                     "LEFT JOIN asistencia a ON t.id_trabajador = a.id_trabajador AND a.fecha > ? AND a.fecha <= ? " + 
                     "LEFT JOIN proyectos p ON t.id_proyect = p.id_proyecto " + // <-- EL JOIN CORREGIDO
                     "LEFT JOIN justificaciones j ON a.id_trabajador = j.id_trabajador AND DATE(a.fecha) = DATE(j.fecha_incidencia) " +
                     "WHERE t.id_proyect IS NOT NULL AND t.tipo_nomina = ? " + 
                     "GROUP BY t.id_trabajador, t.salario_quincenal, p.tarifa_hora_extra " +
                     "HAVING dias > 0";

        String sqlUpdateCiclo = "UPDATE control_planillas SET ultima_ejecucion = ? WHERE tipo_nomina = ?";

        Connection con = null;
        PreparedStatement psInsert = null;
        PreparedStatement psUpdate = null;
        
        try {
            con = ConectarBD.conectar();
            con.setAutoCommit(false); 

            java.sql.Date sqlFechaInicio = java.sql.Date.valueOf(fechaInicio);
            java.sql.Date sqlFechaFin = java.sql.Date.valueOf(fechaFin);

            psInsert = con.prepareStatement(sqlInsert);
            psInsert.setDate(1, sqlFechaInicio);
            psInsert.setDate(2, sqlFechaFin);
            psInsert.setDouble(3, (double) diasCiclo); 
            psInsert.setDouble(4, (double) diasCiclo); 
            psInsert.setInt(5, idAdmin);
            psInsert.setDate(6, sqlFechaInicio);
            psInsert.setDate(7, sqlFechaFin);
            psInsert.setString(8, tipoNomina);
            
            int filasInsertadas = psInsert.executeUpdate();

            psUpdate = con.prepareStatement(sqlUpdateCiclo);
            psUpdate.setDate(1, sqlFechaFin); 
            psUpdate.setString(2, tipoNomina);
            psUpdate.executeUpdate();

            con.commit();
            
            return filasInsertadas > 0;
            
        } catch (SQLException e) {
            System.out.println(">> ERROR SQL AL GENERAR PLANILLA: " + e.getMessage());
            if (con != null) con.rollback(); 
            return false;
        } finally {
            if (psInsert != null) psInsert.close();
            if (psUpdate != null) psUpdate.close();
            if (con != null) {
                con.setAutoCommit(true); 
                con.close();
            }
        }
    }
    
    public boolean actualizarConfiguracionCiclo(String tipoNomina, int diasCiclo, String nuevaUltimaEjecucion) {
        String sql = "UPDATE control_planillas SET dias_ciclo = ?, ultima_ejecucion = ? WHERE tipo_nomina = ?";
        
        try (Connection con = ConectarBD.conectar();
             PreparedStatement ps = con.prepareStatement(sql)) {
             
            ps.setInt(1, diasCiclo);
            ps.setDate(2, java.sql.Date.valueOf(nuevaUltimaEjecucion));
            ps.setString(3, tipoNomina);
            
            return ps.executeUpdate() > 0;
            
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    public List<DTO.PagoNominaDTO> obtenerHistorialPagos(String tipoNomina) {
        List<DTO.PagoNominaDTO> lista = new ArrayList<>();
        String sql = "SELECT t.full_name, p.fecha_generacion, p.periodo_inicio, p.periodo_fin, " +
                     "p.dias_trabajados, p.monto_horas_extras, p.dias_justificados, p.monto_pagado " +
                     "FROM pago_nomina p " +
                     "INNER JOIN trabajadores t ON p.id_trabajador = t.id_trabajador " +
                     "WHERE t.tipo_nomina = ? " +
                     "ORDER BY p.fecha_generacion DESC, t.full_name ASC";

        try (Connection con = ConectarBD.conectar();
             PreparedStatement ps = con.prepareStatement(sql)) {
             
            ps.setString(1, tipoNomina);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    DTO.PagoNominaDTO pago = new DTO.PagoNominaDTO();
                    pago.setNombreTrabajador(rs.getString("full_name"));
                    pago.setFechaGeneracion(rs.getString("fecha_generacion"));
                    pago.setPeriodoInicio(rs.getString("periodo_inicio"));
                    pago.setPeriodoFin(rs.getString("periodo_fin"));
                    pago.setDiasTrabajados(rs.getInt("dias_trabajados"));
                    pago.setMontoHorasExtras(rs.getDouble("monto_horas_extras"));
                    pago.setDiasJustificados(rs.getInt("dias_justificados"));
                    pago.setMontoPagado(rs.getDouble("monto_pagado"));
                    lista.add(pago);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return lista;
    }
}