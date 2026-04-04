/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Repository;

import Conexion.ConectarBD;
import DTO.HistorialUsoDTO;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.uso_registros;

/**
 *
 * @author Benja
 */
public class UsoDAO {
public List<HistorialUsoDTO> ListarRegistrosDetallados() {
        List<HistorialUsoDTO> lista = new ArrayList<>();
        
        // Modificamos la query para jalar u.costo_por_hora y hacer el cálculo con ese campo
        String query = 
            "SELECT " +
            "   u.id_uso, u.fecha, u.hora_inicio, u.hora_fin, u.costo_por_hora, " +
            "   p.name_proyect AS proyecto, " +
            "   CONCAT(m.tipo_maquina, ' ', m.marca) AS maquina, " +
            "   t.full_name AS trabajador, " +
            "   u.combustible AS galones, " +
            "   ((TIMESTAMPDIFF(MINUTE, u.hora_inicio, u.hora_fin) / 60.0) * u.costo_por_hora) + u.costo_combustible_total AS costo_total " +
            "FROM uso_registro u " +
            "INNER JOIN proyectos p ON u.id_proyect = p.id_proyecto " +
            "INNER JOIN maquinas m ON u.id_maquinaria = m.id_maquina " +
            "INNER JOIN trabajadores t ON u.id_trabajador = t.id_trabajador " +
            "ORDER BY u.fecha DESC, u.id_uso DESC";

        try {
            Connection con = ConectarBD.conectar();
            PreparedStatement ps = con.prepareStatement(query);
            ResultSet rs = ps.executeQuery();
            
            while(rs.next()) {
                HistorialUsoDTO dto = new HistorialUsoDTO();
                dto.setIdUso(rs.getInt("id_uso"));
                dto.setFecha(rs.getDate("fecha"));
                dto.setHoraInicio(rs.getTime("hora_inicio"));
                dto.setHoraFin(rs.getTime("hora_fin"));
                
                // Mapeamos el nuevo campo
                dto.setCostoPorHora(rs.getDouble("costo_por_hora"));
                
                dto.setNombreProyecto(rs.getString("proyecto"));
                dto.setNombreMaquina(rs.getString("maquina"));
                dto.setNombreTrabajador(rs.getString("trabajador"));
                dto.setGalonesCombustible(rs.getDouble("galones"));
                dto.setCostoTotal(rs.getDouble("costo_total"));
                
                lista.add(dto);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return lista;
    }

public HistorialUsoDTO obtenerDetalleUso(int idUso) {
        HistorialUsoDTO dto = null;
        String query = 
            "SELECT " +
            "   u.id_uso, u.fecha, u.hora_inicio, u.hora_fin, u.costo_por_hora, " +
            "   p.name_proyect AS proyecto, " +
            "   CONCAT(m.tipo_maquina, ' ', m.marca) AS maquina, " +
            "   t.full_name AS trabajador, " +
            "   u.combustible AS galones, " +
            "   (TIMESTAMPDIFF(MINUTE, u.hora_inicio, u.hora_fin) / 60.0) AS horas_trabajadas, " + // NUEVO CALCULO
            "   ((TIMESTAMPDIFF(MINUTE, u.hora_inicio, u.hora_fin) / 60.0) * u.costo_por_hora) + u.costo_combustible_total AS costo_total, " +
            "   u.costo_combustible_total AS costo_combustible " + // Jalamos el costo puro del diesel
            "FROM uso_registro u " +
            "INNER JOIN proyectos p ON u.id_proyect = p.id_proyecto " +
            "INNER JOIN maquinas m ON u.id_maquinaria = m.id_maquina " +
            "INNER JOIN trabajadores t ON u.id_trabajador = t.id_trabajador " +
            "WHERE u.id_uso = ?";

        try {
            Connection con = ConectarBD.conectar();
            PreparedStatement ps = con.prepareStatement(query);
            ps.setInt(1, idUso);
            ResultSet rs = ps.executeQuery();
            
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
                // Usaremos getCombustible() prestado del DTO original o lo pasamos como extra.
                // Para no alterar más tu DTO, haremos la resta matemática en el JSP.
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return dto;
    }
}
