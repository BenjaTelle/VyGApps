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
        
        /* EXPLICACIÓN DE LA SÚPER CONSULTA:
           1. Calcula las horas restando hora_fin - hora_inicio.
           2. Multiplica esas horas por el costo de la máquina.
           3. Le suma el costo del combustible.
           4. Solo agarra registros en el rango de fechas.
           5. El NOT EXISTS evita que se vuelva a generar pago a un registro de uso que ya está en la tabla de pagos.
        */
        String sql = "INSERT INTO pago_maquinaria (fecha_generacion, monto_horas, monto_combustible, total_pagado, estado, id_uso, id_user_genera) " +
                     "SELECT " +
                     "   CURRENT_DATE(), " +
                     "   (TIMESTAMPDIFF(MINUTE, u.hora_inicio, u.hora_fin) / 60.0) * m.costo_por_hora AS monto_horas, " +
                     "   u.costo_combustible_total AS monto_combustible, " +
                     "   ((TIMESTAMPDIFF(MINUTE, u.hora_inicio, u.hora_fin) / 60.0) * m.costo_por_hora) + u.costo_combustible_total AS total_pagado, " +
                     "   'Pendiente', " +
                     "   u.id_uso, " +
                     "   ? " +  // (1) ID del Admin
                     "FROM uso_registro u " +
                     "INNER JOIN maquinas m ON u.id_maquinaria = m.id_maquina " +
                     "WHERE u.fecha >= ? AND u.fecha <= ? " + // (2) y (3) Fechas
                     "AND NOT EXISTS (" +
                     "   SELECT 1 FROM pago_maquinaria pm WHERE pm.id_uso = u.id_uso" +
                     ")";

        Connection con = ConectarBD.conectar();
        PreparedStatement ps = con.prepareStatement(sql);
        
        try {
            ps.setInt(1, idAdmin);
            ps.setString(2, fechaInicio);
            ps.setString(3, fechaFin);
            
            // Ejecutamos la inserción
            int filasInsertadas = ps.executeUpdate();
            
            // Si insertó al menos 1 fila, la liquidación tuvo éxito
            return filasInsertadas > 0;
            
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } 
        // Opcional: finally { con.close(); }
    }
}
