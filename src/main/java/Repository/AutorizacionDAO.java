/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
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

    // 1. Listar las planillas pendientes
    public List<PlanillaPendienteDTO> listarPendientes() throws SQLException {
        // NOTA: Si quieres filtrar por supervisor, agrega un WHERE que cruce con proyecto_supervisor
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
        
        try {
            ResultSet rs = ps.executeQuery();
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
        } catch (SQLException e) { e.printStackTrace(); }
        return lista;
    }

    // 2. Autorizar pago y descontar presupuesto (Usa Transacciones)
    public String autorizarPago(int idPago, int idProyecto, double monto, int idAdminSupervisor) {
        Connection con = ConectarBD.conectar();
        try {
            // Iniciar transacción manualmente
            con.setAutoCommit(false);

            // A) Verificar si hay fondos suficientes
            String checkSql = "SELECT presupuesto_total FROM proyectos WHERE id_proyecto = ?";
            PreparedStatement psCheck = con.prepareStatement(checkSql);
            psCheck.setInt(1, idProyecto);
            ResultSet rsCheck = psCheck.executeQuery();
            
            if (rsCheck.next()) {
                double presupuestoActual = rsCheck.getDouble("presupuesto_total");
                if (presupuestoActual < monto) {
                    con.rollback(); // Cancelar todo
                    return "sin_fondos";
                }
            }

            // B) Descontar el dinero del proyecto
            String descSql = "UPDATE proyectos SET presupuesto_total = presupuesto_total - ? WHERE id_proyecto = ?";
            PreparedStatement psDesc = con.prepareStatement(descSql);
            psDesc.setDouble(1, monto);
            psDesc.setInt(2, idProyecto);
            psDesc.executeUpdate();

            // C) Cambiar estado a Autorizado
            String authSql = "UPDATE pago_nomina SET estado = 'Autorizado', id_user_autoriza = ? WHERE id_pago_nomina = ?";
            PreparedStatement psAuth = con.prepareStatement(authSql);
            psAuth.setInt(1, idAdminSupervisor);
            psAuth.setInt(2, idPago);
            psAuth.executeUpdate();

            // Confirmar transacción (Guardar todo)
            con.commit();
            return "exito";

        } catch (SQLException e) {
            try { if (con != null) con.rollback(); } catch (SQLException ex) {}
            e.printStackTrace();
            return "error";
        }
    }
}