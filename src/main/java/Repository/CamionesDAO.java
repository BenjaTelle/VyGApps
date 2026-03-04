/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Repository;

import Conexion.ConectarBD;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import model.camiones;

/**
 *
 * @author Benja
 */
public class CamionesDAO {

    public void registrarCamion(camiones c) {

        String sql = "INSERT INTO registro_camiones(hora_salida, hora_llegada,origen,destino,cantidad_cargada,id_uso, costo_flete, id_material) VALUES (?,?,?,?,?,?,?,?) ";
        try {

            Connection con = ConectarBD.conectar();
            PreparedStatement ps = con.prepareStatement(sql);

            ps.setTime(1, c.getHora_salida());
            ps.setTime(2, c.getHora_llegada());
            ps.setString(3, c.getOrigen());
            ps.setString(4, c.getDestino());
             ps.setDouble(5, c.getCantidad_cargada());
             ps.setInt(6, c.getId_uso());
             ps.setDouble(7, c.getCosto_flete());
              ps.setInt(8, c.getId_material());

              ps.execute();
             
        } catch (SQLException e) {
            e.printStackTrace();
        }

    }

}
