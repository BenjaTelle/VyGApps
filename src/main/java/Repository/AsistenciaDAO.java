/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Repository;

import Conexion.ConectarBD;
import DTO.AsistenciaDTO;
import DTO.ResumenAsistenciaDTO;
import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Time;
import java.util.ArrayList;
import java.util.List;
import model.asistencia;

/**
 *
 * @author Benja
 */
public class AsistenciaDAO {
    
    
    public int MarcarEntrada(int id, Time entrada, Date fecha) throws SQLException
    {
        String sql = "INSERT INTO asistencia(hora_entrada, id_trabajador, fecha) VALUES(?,?,?)";
        Connection con = ConectarBD.conectar();
        PreparedStatement ps = con.prepareStatement(sql);
        ps.setTime(1, entrada);
        ps.setInt(2, id);
        ps.setDate(3, fecha);
        
       int filasAfectadas = ps.executeUpdate();
        return filasAfectadas;
        
    }
    
    
    public int MarcarSalida(int id, Time salida) throws SQLException
    {
        String sql = "UPDATE asistencia SET hora_salida=? where id_trabajador=?";
        Connection con = ConectarBD.conectar();
        PreparedStatement ps = con.prepareStatement(sql);
        ps.setTime(1, salida);
        ps.setInt(2, id);
     
        
       int filasAfectadas = ps.executeUpdate();
        return filasAfectadas;
        
    }
    
    public List<asistencia> ListarAsistencia(int id) throws SQLException
    {
        String sql = "SELECT * FROM asistencia where id_trabajador=?";
        Connection con = ConectarBD.conectar();
        PreparedStatement ps = con.prepareStatement(sql);
        ps.setInt(1, id);
        List<asistencia> ListaAsistencia = new ArrayList<>();
        ResultSet rs = ps.executeQuery();
        while(rs.next())
        {
            
         asistencia a =   new asistencia();
           a.setFecha(rs.getDate("fecha"));
           a.setHora_entrada(rs.getTime("hora_entrada"));
           a.setHora_salida(rs.getTime("hora_salida"));
            a.setId_trabajador(rs.getInt("id_trabajador"));
            
            ListaAsistencia.add(a);
        }
        
        return ListaAsistencia;
        
    }
    
    
    public List<AsistenciaDTO> ListarAsistenciaGlobal() throws SQLException
    {
        
        String sql = "SELECT t.id_trabajador, t.full_name, a.fecha, a.hora_entrada, a.hora_salida, case when a.hora_entrada > '08:00:00' then 'Llegada Tardía' end as estado_turno "
                + "FROM asistencia as a "
                + "INNER JOIN trabajadores as t on t.id_trabajador = a.id_trabajador;";
        
        
        Connection con = ConectarBD.conectar();
        PreparedStatement ps = con.prepareStatement(sql);
        List<AsistenciaDTO> AsistenciaGlobal = new ArrayList<>();
        try{
            ResultSet rs = ps.executeQuery();
            while (rs.next( )){
                AsistenciaDTO a = new AsistenciaDTO();
                a.setNombreTrabajador(rs.getString("full_name"));
                a.setFecha(rs.getDate("fecha"));
                a.setHoraEntrada(rs.getTime("hora_entrada"));
                a.setHoraSalida(rs.getTime("hora_salida"));
                a.setEstado_turno(rs.getString("estado_turno"));
                a.setIdTrabajador(rs.getInt("id_trabajador"));
                AsistenciaGlobal.add(a);
                
            }
        }catch(SQLException e){
        e.printStackTrace();
        
        
        }   
        return AsistenciaGlobal;
    }
    
    
     public List<AsistenciaDTO> ListarAsistenciaTrabajdor(int id) throws SQLException
    {
        
        String sql = "SELECT  t.full_name, a.fecha, a.hora_entrada, a.hora_salida, case when a.hora_entrada > '08:00:00' then 'Llegada Tardía' end as estado_turno "
                + "FROM asistencia as a "
                + "INNER JOIN trabajadores as t on t.id_trabajador = a.id_trabajador where t.id_trabajador = ?";
        
        
        Connection con = ConectarBD.conectar();
        PreparedStatement ps = con.prepareStatement(sql);
       ps.setInt(1, id);
       
    List<AsistenciaDTO> lista = new ArrayList<>();
        try{
            ResultSet rs = ps.executeQuery();
            while (rs.next( )){
               AsistenciaDTO a = new AsistenciaDTO();
                a.setNombreTrabajador(rs.getString("full_name"));
                a.setFecha(rs.getDate("fecha"));
                a.setHoraEntrada(rs.getTime("hora_entrada"));
                a.setHoraSalida(rs.getTime("hora_salida"));
                a.setEstado_turno(rs.getString("estado_turno"));
                a.setIdTrabajador(id);
lista.add(a);
                
            }
        }catch(SQLException e){
        e.printStackTrace();
        
        
        }
        return lista;
    }
    
  public ResumenAsistenciaDTO obtenerResumenTrabajador(int idTrabajador) throws SQLException {
        
        // La Súper Consulta Maestra Blindada
        String sql = "SELECT " +
                     "t.full_name, t.cedula, t.puesto, p.name_proyect, " +
                     "COUNT(a.id_asistencia) AS total_dias, " +
                     "SUM(CASE WHEN a.hora_entrada > '08:00:00' THEN 1 ELSE 0 END) AS total_tardias, " +
                     "IFNULL(ROUND(AVG( " +
                     "    CASE " +
                     "        WHEN a.hora_salida IS NULL THEN 0 " + // Protege contra nulos
                     "        WHEN a.hora_salida < a.hora_entrada THEN (TIMESTAMPDIFF(MINUTE, a.hora_entrada, a.hora_salida) + 1440) / 60.0 " + // Arregla los turnos de madrugada
                     "        ELSE TIMESTAMPDIFF(MINUTE, a.hora_entrada, a.hora_salida) / 60.0 " + // Turnos normales
                     "    END " +
                     "), 1), 0) AS promedio_horas " +
                     "FROM trabajadores t " +
                     "LEFT JOIN proyectos p ON t.id_proyect = p.id_proyecto " +
                     "LEFT JOIN asistencia a ON t.id_trabajador = a.id_trabajador " +
                     "WHERE t.id_trabajador = ? " +
                     "GROUP BY t.id_trabajador, t.full_name, t.cedula, t.puesto, p.name_proyect";

        ResumenAsistenciaDTO resumen = null;
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            con = ConectarBD.conectar();
            ps = con.prepareStatement(sql);
            ps.setInt(1, idTrabajador);
            
            rs = ps.executeQuery();
            
            if (rs.next()) {
                resumen = new ResumenAsistenciaDTO();
                
                // 1. Llenamos los datos personales
                resumen.setNombreCompleto(rs.getString("full_name"));
                resumen.setCedula(rs.getString("cedula"));
                resumen.setPuesto(rs.getString("puesto"));
                
                // Si no tiene proyecto asignado, evitamos que salga null
                String proyecto = rs.getString("name_proyect");
                resumen.setNombreProyecto(proyecto != null ? proyecto : "Sin proyecto asignado");
                
                // 2. Llenamos las métricas (KPIs)
                int dias = rs.getInt("total_dias");
                int tardias = rs.getInt("total_tardias");
                double promHoras = rs.getDouble("promedio_horas");
                
                resumen.setTotalDiasTrabajados(dias);
                resumen.setTotalLlegadasTardias(tardias);
                resumen.setHorasPromedioPorDia(promHoras + " hrs");
                
                // 3. Calculamos la puntualidad en Java
                double puntualidad = 0.0; // Cambiado a 0% por defecto si no hay asistencias
                
                if (dias > 0) {
                    // Formula: ((dias - tardias) / dias) * 100
                    puntualidad = ((double)(dias - tardias) / dias) * 100.0;
                    // Redondeamos a 1 decimal para la vista
                    puntualidad = Math.round(puntualidad * 10.0) / 10.0; 
                }
                resumen.setPorcentajePuntualidad(puntualidad);
            }
        } catch (Exception e) {
            System.out.println("Error al obtener el resumen de asistencia: " + e.getMessage());
            e.printStackTrace();
        } finally {
            // Buenas prácticas: cerrar recursos para evitar fugas de memoria en el servidor
            if (rs != null) try { rs.close(); } catch (SQLException e) {}
            if (ps != null) try { ps.close(); } catch (SQLException e) {}
            if (con != null) try { con.close(); } catch (SQLException e) {}
        }

        return resumen;
    }
  
      // Método para validar que el código sea correcto, vigente Y del proyecto del trabajador
    public boolean validarCodigoObra(String codigo, int idTrabajador) throws SQLException {
        // 1. Definir la consulta SQL con INNER JOIN
        // Cruzamos las tablas para asegurar que el id_proyecto del código 
        // coincida con el id_proyect asignado al trabajador
        String sql = "SELECT c.id_codigo FROM codigos_asistencia c " +
                     "INNER JOIN trabajadores t ON c.id_proyecto = t.id_proyect " +
                     "WHERE c.codigo = ? AND t.id_trabajador = ? " +
                     "AND c.estado = 'Activo' AND c.fecha_expiracion > NOW()";
        
        // 2. Conexión
        Connection con = ConectarBD.conectar();
        
        // 3. Preparar la consulta
        PreparedStatement ps = con.prepareStatement(sql);
        
        // 4. Variable de retorno
        boolean esValido = false;
        
        // 5. Try / Catch
        try {
            // Asignamos los dos parámetros de seguridad
            ps.setString(1, codigo);
            ps.setInt(2, idTrabajador);
            
            // 6. ResultSet
            ResultSet rs = ps.executeQuery();
            
            // 7. Verificación
            if (rs.next()) {
                esValido = true; // Si hay resultado, el código es de SU proyecto y es válido
            }
            
        } catch (SQLException e) {
            System.out.println("Error al validar código y proyecto: " + e.getMessage());
            e.printStackTrace();
        }
        
        return esValido;
    }
    
    
}
