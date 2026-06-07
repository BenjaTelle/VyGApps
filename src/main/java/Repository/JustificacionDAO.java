package Repository;

import Conexion.ConectarBD;
import DTO.IncidenciaDTO;
import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class JustificacionDAO {

public List<IncidenciaDTO> obtenerIncidenciasPendientes() throws SQLException {
        // Usamos DATE(a.fecha) y DATE(j.fecha_incidencia) para asegurar que la hora no interfiera
        String sql = "SELECT a.id_trabajador, t.full_name, a.fecha, a.hora_salida \n" +
"FROM asistencia a \n" +
"INNER JOIN trabajadores t ON a.id_trabajador = t.id_trabajador \n" +
"WHERE a.marca_anomala = 1   \n" +
"ORDER BY a.fecha DESC;";

        List<IncidenciaDTO> lista = new ArrayList<>();
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            con = ConectarBD.conectar();
            ps = con.prepareStatement(sql);
            rs = ps.executeQuery();

            while (rs.next()) {
                IncidenciaDTO inc = new IncidenciaDTO();
                inc.setIdTrabajador(rs.getInt("id_trabajador"));
                inc.setNombreTrabajador(rs.getString("full_name"));
                inc.setFecha(rs.getDate("fecha"));
                inc.setTipoIncidencia("Salida Temprana");
                inc.setDetalle("Hora de salida: " + rs.getTime("hora_salida"));
                lista.add(inc);
            }
        } finally {
            if (rs != null) try { rs.close(); } catch (SQLException e) {}
            if (ps != null) try { ps.close(); } catch (SQLException e) {}
            if (con != null) try { con.close(); } catch (SQLException e) {}
        }
        return lista;
    }
    public boolean registrarJustificacion(int idTrabajador, Date fechaIncidencia, String tipo, String motivo, String observaciones, String estado) throws SQLException {
        // Query corregido con los nombres exactos de tus columnas
        String sql = "INSERT INTO justificaciones (id_trabajador, fecha_incidencia, tipo_motivo, descripcion, estado) VALUES (?, ?, ?, ?, ?)";
        Connection con = null;
        PreparedStatement ps = null;

        try {
            con = ConectarBD.conectar();
            ps = con.prepareStatement(sql);
            ps.setInt(1, idTrabajador);
            ps.setDate(2, fechaIncidencia);
            // Combinamos tipo + motivo en tipo_motivo como acordamos
            ps.setString(3, tipo + " - " + motivo); 
            ps.setString(4, observaciones);
            ps.setString(5, estado);

            return ps.executeUpdate() > 0;
        } finally {
            if (ps != null) try { ps.close(); } catch (SQLException e) {}
            if (con != null) try { con.close(); } catch (SQLException e) {}
        }
    }
}