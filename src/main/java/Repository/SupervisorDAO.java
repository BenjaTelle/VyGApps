/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Repository;

import Conexion.ConectarBD;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;
import model.supervisores;

/**
 *
 * @author Benja
 */
public class SupervisorDAO {
//asignar supervisor a un proyecto
    public int AsignarSupervisor(int id_proyecto, int id_trabajador) throws SQLException {
        String sql = "Insert into  proyecto_supervisor(id_proyecto, id_trabajador)  values(?,?)";
        Connection con = ConectarBD.conectar();

        PreparedStatement ps = con.prepareStatement(sql);
        ps.setInt(1, id_proyecto);
        ps.setInt(2, id_trabajador);
        int filas = ps.executeUpdate();

        return filas;

    }



}
