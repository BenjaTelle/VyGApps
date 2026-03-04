/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Repository;

import Conexion.ConectarBD;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import model.uso_registros;

/**
 *
 * @author Benja
 */
public class RegistroUsoDAO {

    public void CrearRegistroUso(uso_registros uso) throws SQLException {
        String sql = "INSERT into uso_registro(fecha, hora_inicio, hora_fin, combustible, id_maquinaria , id_proyect,id_trabajador, costo_combustible_total) VALUES(?,?,?,?,?,?,?,?)";

        Connection con = ConectarBD.conectar();
        PreparedStatement ps = con.prepareStatement(sql);

        ps.setDate(1, uso.getFecha());
        ps.setTime(2, uso.getHora_inicio());
        ps.setTime(3, uso.getHora_fin());
        ps.setDouble(4, uso.getCombustible());
        ps.setInt(5, uso.getId_maquina());
        ps.setInt(6, uso.getId_proyect());
        ps.setInt(7, uso.getId_trabajador());
        ps.setDouble(8, uso.getCostoT_combustible());

        ps.executeUpdate();

    }

}
