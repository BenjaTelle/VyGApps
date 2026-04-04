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

        // Consulta cruzada con cálculo matemático incluido
        String query
                = "SELECT "
                + "   u.id_uso, u.fecha, u.hora_inicio, u.hora_fin, "
                + "   p.name_proyect AS proyecto, "
                + "   CONCAT(m.tipo_maquina, ' ', m.marca) AS maquina, "
                + "   t.full_name AS trabajador, "
                + "   u.combustible AS galones, "
                + "   ((TIMESTAMPDIFF(MINUTE, u.hora_inicio, u.hora_fin) / 60.0) * m.costo_por_hora) + u.costo_combustible_total AS costo_total "
                + "FROM uso_registro u "
                + "INNER JOIN proyectos p ON u.id_proyect = p.id_proyecto "
                + "INNER JOIN maquinas m ON u.id_maquinaria = m.id_maquina "
                + "INNER JOIN trabajadores t ON u.id_trabajador = t.id_trabajador "
                + "ORDER BY u.fecha DESC, u.id_uso DESC";

        try {
            Connection con = ConectarBD.conectar();
            PreparedStatement ps = con.prepareStatement(query);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                HistorialUsoDTO dto = new HistorialUsoDTO();
                dto.setIdUso(rs.getInt("id_uso"));
                dto.setFecha(rs.getDate("fecha"));
                dto.setHoraInicio(rs.getTime("hora_inicio"));
                dto.setHoraFin(rs.getTime("hora_fin"));
                dto.setNombreProyecto(rs.getString("proyecto"));
                dto.setNombreMaquina(rs.getString("maquina"));
                dto.setNombreTrabajador(rs.getString("trabajador"));
                dto.setGalonesCombustible(rs.getDouble("galones"));
                dto.setCostoTotal(rs.getDouble("costo_total"));

                lista.add(dto);
            }
        } catch (SQLException e) {
            e.printStackTrace(); // Aquí idealmente va un log, pero te lo dejo así por rapidez
        }
        return lista;
    }

}
