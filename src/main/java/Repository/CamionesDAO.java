package Repository;

import Conexion.ConectarBD;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.sql.Types;
import model.camiones;

public class CamionesDAO {

    public void registrarCamion(camiones c) {
        String sql = "INSERT INTO registro_camiones(hora_salida, hora_llegada, origen, destino, cantidad_cargada, id_uso, costo_flete, id_material) VALUES (?,?,?,?,?,?,?,?)";
        
        try (Connection con = ConectarBD.conectar();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setTime(1, c.getHora_salida());
            ps.setTime(2, c.getHora_llegada());
            ps.setString(3, c.getOrigen());
            ps.setString(4, c.getDestino());
            ps.setDouble(5, c.getCantidad_cargada());
            ps.setInt(6, c.getId_uso());
            ps.setDouble(7, c.getCosto_flete());
            
            if (c.getId_material() == 0) {
                ps.setNull(8, Types.INTEGER);
            } else {
                ps.setInt(8, c.getId_material());
            }

            ps.executeUpdate();
             
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
