package Repository;

import Conexion.ConectarBD;
import DTO.DeduccionDTO;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Types;
import java.util.ArrayList;
import java.util.List;

public class DeduccionDAO {

    public DeduccionDAO() {
        asegurarTablaDeducciones();
    }

    public void asegurarTablaDeducciones() {
        String sql = "CREATE TABLE IF NOT EXISTS `deducciones` ("
                + "  `id_deduccion` INT(11) NOT NULL AUTO_INCREMENT,"
                + "  `id_trabajador` INT(11) NOT NULL,"
                + "  `concepto` VARCHAR(255) DEFAULT NULL,"
                + "  `monto` DECIMAL(10,2) NOT NULL,"
                + "  `estado` VARCHAR(20) NOT NULL DEFAULT 'Pendiente',"
                + "  `fecha_registro` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP(),"
                + "  `id_user_registra` INT(11) DEFAULT NULL,"
                + "  PRIMARY KEY (`id_deduccion`),"
                + "  KEY `fk_deduccion_trabajador` (`id_trabajador`),"
                + "  CONSTRAINT `fk_deduccion_trabajador` FOREIGN KEY (`id_trabajador`) REFERENCES `trabajadores` (`id_trabajador`) ON DELETE CASCADE ON UPDATE CASCADE"
                + ") ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;";

        try (Connection con = ConectarBD.conectar();
             Statement st = con.createStatement()) {
            st.executeUpdate(sql);
        } catch (SQLException e) {
            System.err.println(">> Error al verificar/crear la tabla deducciones: " + e.getMessage());
        }
    }

    public boolean registrarDeduccion(int idTrabajador, String concepto, double monto, Integer idUserRegistra) {
        String sql = "INSERT INTO deducciones (id_trabajador, concepto, monto, estado, id_user_registra) VALUES (?, ?, ?, 'Pendiente', ?)";

        try (Connection con = ConectarBD.conectar();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, idTrabajador);
            if (concepto != null && !concepto.trim().isEmpty()) {
                ps.setString(2, concepto.trim());
            } else {
                ps.setNull(2, Types.VARCHAR);
            }
            ps.setDouble(3, monto);
            if (idUserRegistra != null && idUserRegistra > 0) {
                ps.setInt(4, idUserRegistra);
            } else {
                ps.setNull(4, Types.INTEGER);
            }

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public List<DeduccionDTO> listarDeducciones() {
        List<DeduccionDTO> lista = new ArrayList<>();
        String sql = "SELECT d.id_deduccion, d.id_trabajador, t.full_name AS nombre_trabajador, d.concepto, d.monto, d.estado, d.fecha_registro, d.id_user_registra "
                + "FROM deducciones d "
                + "INNER JOIN trabajadores t ON d.id_trabajador = t.id_trabajador "
                + "ORDER BY d.id_deduccion DESC";

        try (Connection con = ConectarBD.conectar();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                DeduccionDTO dto = new DeduccionDTO();
                dto.setIdDeduccion(rs.getInt("id_deduccion"));
                dto.setIdTrabajador(rs.getInt("id_trabajador"));
                dto.setNombreTrabajador(rs.getString("nombre_trabajador"));
                dto.setConcepto(rs.getString("concepto"));
                dto.setMonto(rs.getDouble("monto"));
                dto.setEstado(rs.getString("estado"));
                dto.setFechaRegistro(rs.getTimestamp("fecha_registro"));
                dto.setIdUserRegistra(rs.getObject("id_user_registra") != null ? rs.getInt("id_user_registra") : null);
                lista.add(dto);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return lista;
    }

    public boolean eliminarDeduccion(int idDeduccion) {
        String sql = "DELETE FROM deducciones WHERE id_deduccion = ? AND estado = 'Pendiente'";
        try (Connection con = ConectarBD.conectar();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, idDeduccion);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
}
