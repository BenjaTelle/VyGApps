package Repository;

import Conexion.ConectarBD;
import DTO.HistorialUsoDTO;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author Benja
 */
public class UsoDAO {

    /**
     * Recupera todos los registros de uso de maquinaria de forma detallada.
     * 
     * @return Lista de historial de uso con costos calculados.
     */
    public List<HistorialUsoDTO> ListarRegistrosDetallados() {
        List<HistorialUsoDTO> lista = new ArrayList<>();
        
        // TODO: Refactorizar consulta para aislar el manejo de compensación de medianoche en una vista o función almacenada.
        String query = 
            "SELECT " +
            "   u.id_uso, u.fecha, u.hora_inicio, u.hora_fin, u.costo_por_hora, " +
            "   p.name_proyect AS proyecto, " +
            "   CONCAT(m.tipo_maquina, ' ', m.marca) AS maquina, " +
            "   t.full_name AS trabajador, " +
            "   u.combustible AS galones, " +
            "   ((CASE " +
            "       WHEN u.hora_fin < u.hora_inicio THEN (TIMESTAMPDIFF(MINUTE, u.hora_inicio, u.hora_fin) + 1440) / 60.0 " +
            "       ELSE TIMESTAMPDIFF(MINUTE, u.hora_inicio, u.hora_fin) / 60.0 " +
            "   END) * u.costo_por_hora) + u.costo_combustible_total AS costo_total " +
            "FROM uso_registro u " +
            "INNER JOIN proyectos p ON u.id_proyect = p.id_proyecto " +
            "INNER JOIN maquinas m ON u.id_maquinaria = m.id_maquina " +
            "INNER JOIN trabajadores t ON u.id_trabajador = t.id_trabajador " +
            "ORDER BY u.fecha DESC, u.id_uso DESC";

        try (Connection con = ConectarBD.conectar();
             PreparedStatement ps = con.prepareStatement(query);
             ResultSet rs = ps.executeQuery()) {
            
            while(rs.next()) {
                HistorialUsoDTO dto = new HistorialUsoDTO();
                dto.setIdUso(rs.getInt("id_uso"));
                dto.setFecha(rs.getDate("fecha"));
                dto.setHoraInicio(rs.getTime("hora_inicio"));
                dto.setHoraFin(rs.getTime("hora_fin"));
                
                dto.setCostoPorHora(rs.getDouble("costo_por_hora"));
                dto.setNombreProyecto(rs.getString("proyecto"));
                dto.setNombreMaquina(rs.getString("maquina"));
                dto.setNombreTrabajador(rs.getString("trabajador"));
                dto.setGalonesCombustible(rs.getDouble("galones"));
                dto.setCostoTotal(rs.getDouble("costo_total"));
                
                lista.add(dto);
            }
        } catch (SQLException e) { 
            System.out.println("Error al listar registros de uso: " + e.getMessage());
            e.printStackTrace(); 
        }
        return lista;
    }

    /**
     * Obtiene el detalle específico de un registro de uso de maquinaria.
     * 
     * @param idUso Identificador único del registro de uso.
     * @return DTO con la información desglosada del uso, o null si no se encuentra.
     */
    public HistorialUsoDTO obtenerDetalleUso(int idUso) {
        HistorialUsoDTO dto = null;
        
        // TODO: Refactorizar cálculos de tiempo y costo utilizando lógica centralizada de persistencia.
        String query = 
            "SELECT " +
            "   u.id_uso, u.fecha, u.hora_inicio, u.hora_fin, u.costo_por_hora, " +
            "   p.name_proyect AS proyecto, " +
            "   CONCAT(m.tipo_maquina, ' ', m.marca) AS maquina, " +
            "   t.full_name AS trabajador, " +
            "   u.combustible AS galones, " +
            "   (CASE " +
            "       WHEN u.hora_fin < u.hora_inicio THEN (TIMESTAMPDIFF(MINUTE, u.hora_inicio, u.hora_fin) + 1440) / 60.0 " +
            "       ELSE TIMESTAMPDIFF(MINUTE, u.hora_inicio, u.hora_fin) / 60.0 " +
            "   END) AS horas_trabajadas, " +
            "   ((CASE " +
            "       WHEN u.hora_fin < u.hora_inicio THEN (TIMESTAMPDIFF(MINUTE, u.hora_inicio, u.hora_fin) + 1440) / 60.0 " +
            "       ELSE TIMESTAMPDIFF(MINUTE, u.hora_inicio, u.hora_fin) / 60.0 " +
            "   END) * u.costo_por_hora) + u.costo_combustible_total AS costo_total, " +
            "   u.costo_combustible_total AS costo_combustible " +
            "FROM uso_registro u " +
            "INNER JOIN proyectos p ON u.id_proyect = p.id_proyecto " +
            "INNER JOIN maquinas m ON u.id_maquinaria = m.id_maquina " +
            "INNER JOIN trabajadores t ON u.id_trabajador = t.id_trabajador " +
            "WHERE u.id_uso = ?";

        try (Connection con = ConectarBD.conectar();
             PreparedStatement ps = con.prepareStatement(query)) {
            
            ps.setInt(1, idUso);
            try (ResultSet rs = ps.executeQuery()) {
                if(rs.next()) {
                    dto = new HistorialUsoDTO();
                    dto.setIdUso(rs.getInt("id_uso"));
                    dto.setFecha(rs.getDate("fecha"));
                    dto.setHoraInicio(rs.getTime("hora_inicio"));
                    dto.setHoraFin(rs.getTime("hora_fin"));
                    dto.setCostoPorHora(rs.getDouble("costo_por_hora"));
                    dto.setNombreProyecto(rs.getString("proyecto"));
                    dto.setNombreMaquina(rs.getString("maquina"));
                    dto.setNombreTrabajador(rs.getString("trabajador"));
                    dto.setGalonesCombustible(rs.getDouble("galones"));
                    dto.setHorasTrabajadas(rs.getDouble("horas_trabajadas"));
                    dto.setCostoTotal(rs.getDouble("costo_total"));
                }
            }
        } catch (SQLException e) { 
            System.out.println("Error al obtener detalle del uso: " + e.getMessage());
            e.printStackTrace(); 
        }
        return dto;
    }
}