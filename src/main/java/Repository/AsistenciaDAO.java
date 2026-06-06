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
    
    public int MarcarEntrada(int id, Time entrada, Date fecha) throws SQLException {
        String sql = "INSERT INTO asistencia(hora_entrada, id_trabajador, fecha) VALUES(?,?,?)";
        try (Connection con = ConectarBD.conectar();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setTime(1, entrada);
            ps.setInt(2, id);
            ps.setDate(3, fecha);
            return ps.executeUpdate();
        }
    }
    
    public Time obtenerHoraSalidaOficial(int idTrabajador) throws SQLException {
        String sql = "SELECT p.hora_salida_oficial FROM proyectos p " +
                     "INNER JOIN trabajadores t ON p.id_proyecto = t.id_proyect " +
                     "WHERE t.id_trabajador = ?";
        try (Connection con = ConectarBD.conectar();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, idTrabajador);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getTime("hora_salida_oficial");
                }
            }
        }
        return null; 
    }

    public int MarcarSalida(int id, Time salida, int horasExtras, int marcaAnomala, Date fecha) throws SQLException {
        String sql = "UPDATE asistencia SET hora_salida=?, horas_extras=?, marca_anomala=? WHERE id_trabajador=? AND fecha=?";
        try (Connection con = ConectarBD.conectar();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setTime(1, salida);
            ps.setInt(2, horasExtras);
            ps.setInt(3, marcaAnomala);
            ps.setInt(4, id);
            ps.setDate(5, fecha);
            return ps.executeUpdate();
        }
    }
   
    public List<AsistenciaDTO> ListarAsistenciaTrabajador(int id) throws SQLException {
        String sql = "SELECT t.full_name, a.fecha, a.hora_entrada, a.hora_salida, a.horas_extras, a.marca_anomala, "
                   + "CASE WHEN a.hora_entrada > ADDTIME(p.hora_entrada_oficial, '00:15:00') THEN 'Llegada Tardía' ELSE 'A Tiempo' END as estado_turno "
                   + "FROM asistencia as a "
                   + "INNER JOIN trabajadores as t ON t.id_trabajador = a.id_trabajador "
                   + "INNER JOIN proyectos as p ON t.id_proyect = p.id_proyecto "
                   + "WHERE t.id_trabajador = ? ORDER BY a.fecha DESC";
                   
        List<AsistenciaDTO> lista = new ArrayList<>();
        try (Connection con = ConectarBD.conectar();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    AsistenciaDTO a = new AsistenciaDTO();
                    a.setNombreTrabajador(rs.getString("full_name"));
                    a.setFecha(rs.getDate("fecha"));
                    a.setHoraEntrada(rs.getTime("hora_entrada"));
                    a.setHoraSalida(rs.getTime("hora_salida"));
                    a.setEstado_turno(rs.getString("estado_turno"));
                    a.setHorasExtras(rs.getInt("horas_extras")); 
                    a.setMarcaAnomala(rs.getInt("marca_anomala")); 
                    a.setIdTrabajador(id);
                    lista.add(a);
                }
            }
        } catch(SQLException e) {
            e.printStackTrace();
        }
        return lista;
    }
    
    public List<AsistenciaDTO> ListarAsistenciaGlobal() throws SQLException {
        String sql = "SELECT t.id_trabajador, t.full_name, a.fecha, a.hora_entrada, a.hora_salida, "
                   + "CASE WHEN a.hora_entrada > ADDTIME(p.hora_entrada_oficial, '00:15:00') THEN 'Llegada Tardía' ELSE 'A Tiempo' END as estado_turno "
                   + "FROM asistencia as a "
                   + "INNER JOIN trabajadores as t on t.id_trabajador = a.id_trabajador "
                   + "INNER JOIN proyectos as p on t.id_proyect = p.id_proyecto";
                   
        List<AsistenciaDTO> AsistenciaGlobal = new ArrayList<>();
        try (Connection con = ConectarBD.conectar();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()){
                AsistenciaDTO a = new AsistenciaDTO();
                a.setNombreTrabajador(rs.getString("full_name"));
                a.setFecha(rs.getDate("fecha"));
                a.setHoraEntrada(rs.getTime("hora_entrada"));
                a.setHoraSalida(rs.getTime("hora_salida"));
                a.setEstado_turno(rs.getString("estado_turno"));
                a.setIdTrabajador(rs.getInt("id_trabajador"));
                AsistenciaGlobal.add(a);
            }
        } catch(SQLException e) {
            e.printStackTrace();
        }
        return AsistenciaGlobal;
    }
    
    public ResumenAsistenciaDTO obtenerResumenTrabajador(int idTrabajador) throws SQLException {
        String sql = "SELECT " +
                     "t.full_name, t.cedula, t.puesto, p.name_proyect, " +
                     "COUNT(a.id_asistencia) AS total_dias, " +
                     "SUM(CASE WHEN a.hora_entrada > ADDTIME(p.hora_entrada_oficial, '00:15:00') THEN 1 ELSE 0 END) AS total_tardias, " +
                     "IFNULL(ROUND(AVG( " +
                     "    CASE " +
                     "        WHEN a.hora_salida IS NULL THEN 0 " + 
                     "        WHEN a.hora_salida < a.hora_entrada THEN (TIMESTAMPDIFF(MINUTE, a.hora_entrada, a.hora_salida) + 1440) / 60.0 " + 
                     "        ELSE TIMESTAMPDIFF(MINUTE, a.hora_entrada, a.hora_salida) / 60.0 " + 
                     "    END " +
                     "), 1), 0) AS promedio_horas " +
                     "FROM trabajadores t " +
                     "LEFT JOIN proyectos p ON t.id_proyect = p.id_proyecto " +
                     "LEFT JOIN asistencia a ON t.id_trabajador = a.id_trabajador " +
                     "WHERE t.id_trabajador = ? " +
                     "GROUP BY t.id_trabajador, t.full_name, t.cedula, t.puesto, p.name_proyect";

        ResumenAsistenciaDTO resumen = null;
        try (Connection con = ConectarBD.conectar();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, idTrabajador);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    resumen = new ResumenAsistenciaDTO();
                    resumen.setNombreCompleto(rs.getString("full_name"));
                    resumen.setCedula(rs.getString("cedula"));
                    resumen.setPuesto(rs.getString("puesto"));
                    String proyecto = rs.getString("name_proyect");
                    resumen.setNombreProyecto(proyecto != null ? proyecto : "Sin proyecto asignado");
                    int dias = rs.getInt("total_dias");
                    int tardias = rs.getInt("total_tardias");
                    double promHoras = rs.getDouble("promedio_horas");
                    resumen.setTotalDiasTrabajados(dias);
                    resumen.setTotalLlegadasTardias(tardias);
                    resumen.setHorasPromedioPorDia(promHoras + " hrs");
                    double puntualidad = 0.0;
                    if (dias > 0) {
                        puntualidad = ((double)(dias - tardias) / dias) * 100.0;
                        puntualidad = Math.round(puntualidad * 10.0) / 10.0; 
                    }
                    resumen.setPorcentajePuntualidad(puntualidad);
                }
            }
        } catch (Exception e) {
            System.out.println("Error al obtener el resumen de asistencia: " + e.getMessage());
            e.printStackTrace();
        }
        return resumen;
    }
  
    public boolean validarCodigoObra(String codigo, int idTrabajador) throws SQLException {
        String sql = "SELECT c.id_codigo FROM codigos_asistencia c " +
                     "INNER JOIN trabajadores t ON c.id_proyecto = t.id_proyect " +
                     "WHERE c.codigo = ? AND t.id_trabajador = ? " +
                     "AND c.estado = 'Activo' AND c.fecha_expiracion > NOW()";
        
        try (Connection con = ConectarBD.conectar();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, codigo);
            ps.setInt(2, idTrabajador);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        } catch (SQLException e) {
            System.out.println("Error al validar código y proyecto: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    public List<AsistenciaDTO> ListarAsistenciaGlobalFiltrada(String fecha, String idProyecto) throws SQLException {
        StringBuilder sql = new StringBuilder(
            "SELECT t.id_trabajador, t.full_name, a.fecha, a.hora_entrada, a.hora_salida, a.horas_extras, a.marca_anomala, " +
            "CASE WHEN a.hora_entrada > ADDTIME(p.hora_entrada_oficial, '00:15:00') THEN 'Llegada Tardía' ELSE 'A Tiempo' END as estado_turno " +
            "FROM asistencia as a " +
            "INNER JOIN trabajadores as t ON t.id_trabajador = a.id_trabajador " +
            "INNER JOIN proyectos as p ON t.id_proyect = p.id_proyecto WHERE 1=1 "
        );

        boolean filtrarFecha = (fecha != null && !fecha.trim().isEmpty());
        boolean filtrarProyecto = (idProyecto != null && !idProyecto.trim().isEmpty());

        if (filtrarFecha) {
            sql.append(" AND a.fecha = ? ");
        }
        if (filtrarProyecto) {
            sql.append(" AND p.id_proyecto = ? ");
        }
        sql.append(" ORDER BY a.fecha DESC");

        List<AsistenciaDTO> listaFiltrada = new ArrayList<>();
        try (Connection con = ConectarBD.conectar();
             PreparedStatement ps = con.prepareStatement(sql.toString())) {
             
            int paramIndex = 1;
            if (filtrarFecha) {
                ps.setDate(paramIndex++, java.sql.Date.valueOf(fecha));
            }
            if (filtrarProyecto) {
                ps.setInt(paramIndex++, Integer.parseInt(idProyecto));
            }

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()){
                    AsistenciaDTO a = new AsistenciaDTO();
                    a.setNombreTrabajador(rs.getString("full_name"));
                    a.setFecha(rs.getDate("fecha"));
                    a.setHoraEntrada(rs.getTime("hora_entrada"));
                    a.setHoraSalida(rs.getTime("hora_salida"));
                    a.setEstado_turno(rs.getString("estado_turno"));
                    a.setHorasExtras(rs.getInt("horas_extras")); 
                    a.setMarcaAnomala(rs.getInt("marca_anomala"));
                    a.setIdTrabajador(rs.getInt("id_trabajador"));
                    listaFiltrada.add(a);
                }
            }
        }
        return listaFiltrada;
    }
}