package Repository;

import Conexion.ConectarBD;
import DTO.PlanillaPendienteDTO;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class AutorizacionDAO {

    // =========================================================================
    // --- SECCIÓN 1: PERSONAL (NÓMINA) ---
    // =========================================================================

    public List<PlanillaPendienteDTO> listarPendientes() throws SQLException {
        String sql = "SELECT pn.id_pago_nomina, pr.id_proyecto, t.full_name, pr.name_proyect, " +
                     "CONCAT(pn.periodo_inicio, ' al ', pn.periodo_fin) AS periodo, " +
                     "pn.dias_trabajados, pn.monto_pagado " +
                     "FROM pago_nomina pn " +
                     "INNER JOIN trabajadores t ON pn.id_trabajador = t.id_trabajador " +
                     "INNER JOIN proyectos pr ON t.id_proyect = pr.id_proyecto " +
                     "WHERE pn.estado = 'Pendiente'";

        Connection con = ConectarBD.conectar();
        PreparedStatement ps = con.prepareStatement(sql);
        List<PlanillaPendienteDTO> lista = new ArrayList<>();
        
        try (ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                PlanillaPendienteDTO p = new PlanillaPendienteDTO();
                p.setIdPago(rs.getInt("id_pago_nomina"));
                p.setIdProyecto(rs.getInt("id_proyecto"));
                p.setNombreTrabajador(rs.getString("full_name"));
                p.setNombreProyecto(rs.getString("name_proyect"));
                p.setPeriodo(rs.getString("periodo"));
                p.setDiasTrabajados(rs.getInt("dias_trabajados"));
                p.setMontoPagado(rs.getDouble("monto_pagado"));
                lista.add(p);
            }
        } finally { 
            con.close(); // Cierre seguro de conexión
        }
        return lista;
    }

    public String autorizarPago(int idPago, int idProyecto, double monto, int idAdminSupervisor) {
        Connection con = ConectarBD.conectar();
        try {
            con.setAutoCommit(false); // Inicia transacción
            
            if (!hayFondos(con, idProyecto, monto)) { 
                con.rollback(); 
                return "sin_fondos"; 
            }
            
            descontarPresupuesto(con, idProyecto, monto);
            
            String authSql = "UPDATE pago_nomina SET estado = 'Autorizado', id_user_autoriza = ? WHERE id_pago_nomina = ?";
            PreparedStatement psAuth = con.prepareStatement(authSql);
            psAuth.setInt(1, idAdminSupervisor);
            psAuth.setInt(2, idPago);
            psAuth.executeUpdate();
            
            con.commit(); // Confirma transacción
            return "exito";
            
        } catch (SQLException e) {
            try { if (con != null) con.rollback(); } catch (SQLException ex) {}
            e.printStackTrace(); 
            return "error";
        } finally { 
            try { if (con != null) con.close(); } catch (Exception e) {} 
        }
    }

    // =========================================================================
    // --- SECCIÓN 2: MAQUINARIA Y FLETES ---
    // =========================================================================

    public List<PlanillaPendienteDTO> listarMaquinariaPendiente() throws SQLException {
        String sql = "SELECT pm.id_pago_maq, pr.id_proyecto, pr.name_proyect, " +
                     "CONCAT(m.tipo_maquina, ' (', m.marca, ')') AS maquina_info, " +
                     "CAST(pm.fecha_generacion AS CHAR) AS periodo, pm.total_pagado " +
                     "FROM pago_maquinaria pm " +
                     "INNER JOIN uso_registro u ON pm.id_uso = u.id_uso " +
                     "INNER JOIN maquinas m ON u.id_maquinaria = m.id_maquina " +
                     "INNER JOIN proyectos pr ON u.id_proyect = pr.id_proyecto " +
                     "WHERE pm.estado = 'Pendiente'";

        Connection con = ConectarBD.conectar();
        PreparedStatement ps = con.prepareStatement(sql);
        List<PlanillaPendienteDTO> lista = new ArrayList<>();
        
        try (ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                PlanillaPendienteDTO p = new PlanillaPendienteDTO();
                p.setIdPago(rs.getInt("id_pago_maq"));
                p.setIdProyecto(rs.getInt("id_proyecto"));
                p.setNombreProyecto(rs.getString("name_proyect"));
                p.setNombreTrabajador(rs.getString("maquina_info")); // Reutilizamos campo para el nombre de la máquina
                p.setPeriodo(rs.getString("periodo"));
                p.setMontoPagado(rs.getDouble("total_pagado"));
                lista.add(p);
            }
        } finally { 
            con.close(); 
        }
        return lista;
    }

    public String autorizarPagoMaquinaria(int idPago, int idProyecto, double monto, int idAdminSupervisor) {
        Connection con = ConectarBD.conectar();
        try {
            con.setAutoCommit(false);
            
            if (!hayFondos(con, idProyecto, monto)) { 
                con.rollback(); 
                return "sin_fondos"; 
            }
            
            descontarPresupuesto(con, idProyecto, monto);
            
            String authSql = "UPDATE pago_maquinaria SET estado = 'Autorizado', id_user_autoriza = ? WHERE id_pago_maq = ?";
            PreparedStatement psAuth = con.prepareStatement(authSql);
            psAuth.setInt(1, idAdminSupervisor);
            psAuth.setInt(2, idPago);
            psAuth.executeUpdate();
            
            con.commit();
            return "exito";
            
        } catch (SQLException e) {
            try { if (con != null) con.rollback(); } catch (SQLException ex) {}
            e.printStackTrace(); 
            return "error";
        } finally { 
            try { if (con != null) con.close(); } catch (Exception e) {} 
        }
    }

    // =========================================================================
    // --- SECCIÓN 3: MÉTODOS DE APOYO (REUTILIZABLES) ---
    // =========================================================================

    private boolean hayFondos(Connection con, int idProyecto, double monto) throws SQLException {
        String sql = "SELECT presupuesto_total FROM proyectos WHERE id_proyecto = ?";
        PreparedStatement ps = con.prepareStatement(sql);
        ps.setInt(1, idProyecto);
        ResultSet rs = ps.executeQuery();
        if (rs.next()) {
            return rs.getDouble("presupuesto_total") >= monto;
        }
        return false;
    }

    private void descontarPresupuesto(Connection con, int idProyecto, double monto) throws SQLException {
        String sql = "UPDATE proyectos SET presupuesto_total = presupuesto_total - ? WHERE id_proyecto = ?";
        PreparedStatement ps = con.prepareStatement(sql);
        ps.setDouble(1, monto);
        ps.setInt(2, idProyecto);
        ps.executeUpdate();
    }
}