/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */

package Repository;

/**
 *
 * @author Benja
 */

import Conexion.ConectarBD;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.GastosProyecto;

public class GastosDAO {

    public void registrarGasto(GastosProyecto g) {
        String sql = "INSERT into gastos_proyectos(id_proyecto, concepto, descripcion, monto, fecha_gasto, nro_comprobante, categoria, id_user_registra) VALUES(?,?,?,?,?,?,?,?)";
        Connection con = ConectarBD.conectar();
        
        try {
            PreparedStatement ps = con.prepareStatement(sql);
            if (g != null) {
                ps.setInt(1, g.getIdProyecto());
                ps.setString(2, g.getConcepto());
                ps.setString(3, g.getDescripcion());
                ps.setDouble(4, g.getMonto());
                ps.setDate(5, g.getFechaGasto());
                ps.setString(6, g.getNroComprobante());
                ps.setString(7, g.getCategoria());
                ps.setInt(8, g.getIdUserRegistra());
            }
            
           ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        
        
    }
    
    /**
     * Obtiene la lista completa de gastos en estado 'Pendiente'
     * Ordenados por el registro más reciente para facilitar la auditoría.
     */
    public List<GastosProyecto> obtenerGastosPendientes() {
        List<GastosProyecto> lista = new ArrayList<>();
        String sql = "SELECT id_gasto, id_proyecto, concepto, descripcion, monto, fecha_gasto, nro_comprobante, categoria, id_user_registra, fecha_registro, estado FROM gastos_proyectos WHERE estado = 'Pendiente' ORDER BY fecha_registro DESC";
        Connection con = ConectarBD.conectar();
        
        try {
            PreparedStatement ps = con.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                GastosProyecto g = new GastosProyecto();
                g.setIdGasto(rs.getInt("id_gasto"));
                g.setIdProyecto(rs.getInt("id_proyecto"));
                g.setConcepto(rs.getString("concepto"));
                g.setDescripcion(rs.getString("descripcion"));
                g.setMonto(rs.getDouble("monto"));
                g.setFechaGasto(rs.getDate("fecha_gasto"));
                g.setNroComprobante(rs.getString("nro_comprobante"));
                g.setCategoria(rs.getString("categoria"));
                g.setIdUserRegistra(rs.getInt("id_user_registra"));
                g.setFechaRegistro(rs.getTimestamp("fecha_registro"));
                g.setEstado(rs.getString("estado"));
                
                lista.add(g);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return lista;
    }

    /**
     * Actualiza el estado de un gasto específico (Aprobado o Rechazado).
     * Si el gasto es 'Aprobado', automáticamente descuenta el monto del presupuesto_total de la obra.
     * Utiliza transacciones para asegurar la integridad de los datos y evitar saldos parciales inconsistentes.
     * 
     * @param idGasto Identificador único del gasto a resolver.
     * @param nuevoEstado Estado al que pasará el gasto ("Aprobado" o "Rechazado").
     * @param idUserAutoriza Identificador del administrador que autoriza el movimiento.
     * @param observaciones Notas adicionales sobre la resolución.
     */
    public void resolverGasto(int idGasto, String nuevoEstado, int idUserAutoriza, String observaciones) {
        Connection con = ConectarBD.conectar();
        PreparedStatement psGasto = null;
        PreparedStatement psProyecto = null;
        PreparedStatement psBuscarGasto = null;
        ResultSet rs = null;

        try {
            // Desactivamos el autocommit para manejar la transacción manualmente
            con.setAutoCommit(false);

            // Iniciar transacción
            if ("Aprobado".equalsIgnoreCase(nuevoEstado)) {
                String sqlBuscar = "SELECT id_proyecto, monto FROM gastos_proyectos WHERE id_gasto = ?";
                psBuscarGasto = con.prepareStatement(sqlBuscar);
                psBuscarGasto.setInt(1, idGasto);
                rs = psBuscarGasto.executeQuery();

                if (rs.next()) {
                    int idProyecto = rs.getInt("id_proyecto");
                    double montoGasto = rs.getDouble("monto");

                    // Descontar monto del presupuesto del proyecto
                    String sqlUpdateProyecto = "UPDATE proyectos SET presupuesto_total = presupuesto_total - ? WHERE id_proyecto = ?";
                    psProyecto = con.prepareStatement(sqlUpdateProyecto);
                    psProyecto.setDouble(1, montoGasto);
                    psProyecto.setInt(2, idProyecto);
                    psProyecto.executeUpdate();
                }
            }

            // Actualizar estado del gasto y registrar datos de auditoría
            String sqlUpdateGasto = "UPDATE gastos_proyectos SET estado = ?, id_user_autoriza = ?, fecha_autorizacion = CURRENT_TIMESTAMP, observaciones = ? WHERE id_gasto = ?";
            psGasto = con.prepareStatement(sqlUpdateGasto);
            psGasto.setString(1, nuevoEstado);
            psGasto.setInt(2, idUserAutoriza);
            psGasto.setString(3, observaciones);
            psGasto.setInt(4, idGasto);
            psGasto.executeUpdate();

            // Confirmar transacción
            con.commit();
            
        } catch (SQLException e) {
            // Revertir transacción en caso de error
            try {
                if (con != null) {
                    con.rollback();
                }
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
            e.printStackTrace();
        } finally {
            // Liberar recursos
            try {
                if (rs != null) rs.close();
                if (psBuscarGasto != null) psBuscarGasto.close();
                if (psProyecto != null) psProyecto.close();
                if (psGasto != null) psGasto.close();
                if (con != null) {
                    con.setAutoCommit(true); // Devolvemos el estado original a la conexión
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
}