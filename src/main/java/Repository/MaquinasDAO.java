/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Repository;

import Conexion.ConectarBD;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.maquinas;

/**
 *
 * @author Benja
 */
public class MaquinasDAO {
    
    
    
    public List<maquinas> listarMaquinas() throws SQLException
    {
        String sql= "SELECT * FROM maquinas";
        Connection con = ConectarBD.conectar();
        PreparedStatement ps = con.prepareStatement(sql);
         List<maquinas> listaMaquinas = new ArrayList<>();
        try{
            
            ResultSet rs = ps.executeQuery();
            
            while(rs.next())
            {
                maquinas m = new maquinas();
                m.setMarca(rs.getString("marca"));
                m.setFuncion(rs.getString("funcion"));
                m.setId_maquina(rs.getInt("id_maquina"));
                m.setTipo_maquina(rs.getString("tipo_maquina"));
                m.setCosto_por_hora(rs.getDouble("costo_por_hora"));
                listaMaquinas.add(m);
                
            }
        
         
        }catch(SQLException e)
        {
            e.printStackTrace();
        }
        
        
        
        return listaMaquinas;
    }
    
   public boolean liquidarUsoMaquinaria(String fechaInicio, String fechaFin, int idAdmin) throws SQLException {
    
    /**
     * Calcula y registra los pagos de maquinaria en un periodo especificado.
     * 
     * Notas de implementación:
     * - Ajusta el cálculo de horas para turnos que cruzan la medianoche añadiendo 1440 minutos.
     * - Utiliza el costo histórico guardado en 'uso_registro' para mantener la integridad financiera.
     * - Calcula el pago total sumando el costo por horas y el costo de combustible.
     *
     * @param fechaInicio Fecha de inicio del periodo.
     * @param fechaFin Fecha de fin del periodo.
     * @param idAdmin Identificador del administrador que genera la liquidación.
     * @return true si se insertaron registros, false en caso contrario.
     * @throws SQLException Si ocurre un error de base de datos.
     */
     String sql = "INSERT INTO pago_maquinaria (fecha_generacion, monto_horas, monto_combustible, total_pagado, estado, id_uso, id_user_genera) " +
                  "SELECT " +
                  "   CURRENT_DATE(), " +
                  // Calcula el costo de horas trabajadas manejando cruces de medianoche
                  "   (CASE WHEN u.hora_fin < u.hora_inicio " +
                  "         THEN (TIMESTAMPDIFF(MINUTE, u.hora_inicio, u.hora_fin) + 1440) " +
                  "         ELSE TIMESTAMPDIFF(MINUTE, u.hora_inicio, u.hora_fin) " +
                  "    END / 60.0) * u.costo_por_hora AS monto_horas, " +
                  "   u.costo_combustible_total AS monto_combustible, " +
                  // Calcula el monto total a pagar (Horas + Combustible + Flete)
                  "   ((CASE WHEN u.hora_fin < u.hora_inicio " +
                  "          THEN (TIMESTAMPDIFF(MINUTE, u.hora_inicio, u.hora_fin) + 1440) " +
                  "          ELSE TIMESTAMPDIFF(MINUTE, u.hora_inicio, u.hora_fin) " +
                  "     END / 60.0) * u.costo_por_hora) + u.costo_combustible_total + COALESCE((SELECT SUM(rc.costo_flete) FROM registro_camiones rc WHERE rc.id_uso = u.id_uso), 0.00) AS total_pagado, " +
                  "   'Pendiente', " +
                  "   u.id_uso, " +
                  "   ? " + 
                  "FROM uso_registro u " +
                  "INNER JOIN maquinas m ON u.id_maquinaria = m.id_maquina " +
                  "WHERE u.fecha >= ? AND u.fecha <= ? " + 
                  "AND NOT EXISTS (" +
                  "   SELECT 1 FROM pago_maquinaria pm WHERE pm.id_uso = u.id_uso" +
                  ")";

    // Try-with-resources para el manejo automático de conexiones
    try (Connection con = ConectarBD.conectar();
         PreparedStatement ps = con.prepareStatement(sql)) {
        
        ps.setInt(1, idAdmin);
        ps.setString(2, fechaInicio);
        ps.setString(3, fechaFin);
        
        int filasInsertadas = ps.executeUpdate();
        return filasInsertadas > 0;
        
    } catch (SQLException e) {
        System.out.println("Error al liquidar maquinaria: " + e.getMessage());
        e.printStackTrace();
        return false;
    } 
}
}
