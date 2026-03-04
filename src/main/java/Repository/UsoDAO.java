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
import java.util.ArrayList;
import java.util.List;
import model.uso_registros;

/**
 *
 * @author Benja
 */
public class UsoDAO {

    public List<uso_registros> ListarRegistros() {
        String query = "Select * from uso_registro";
        List<uso_registros> ListaRegistros = new ArrayList<>();
        try {
            Connection con = ConectarBD.conectar();
            PreparedStatement  ps= con.prepareStatement(query);
            ResultSet rs = ps.executeQuery();
            while(rs.next())
            {
                uso_registros ur = new uso_registros();
                
                ur.setCombustible(rs.getDouble("costo_combustible_total"));
                ur.setFecha(rs.getDate("fecha"));
                ur.setCombustible(rs.getDouble("combustible"));
                ur.setHora_inicio(rs.getTime("hora_inicio"));
                 ur.setHora_fin(rs.getTime("hora_fin"));
                 ur.setId_maquina(rs.getInt("id_maquinaria"));
                 ur.setId_proyect(rs.getInt("id_proyect"));
                 ur.setId_trabajador(rs.getInt("id_trabajador"));
                 ur.setId_uso(rs.getInt("id_uso"));
                 
                 ListaRegistros.add(ur);
            }
            
                
        } catch (SQLException e) {

        }
return ListaRegistros;
    }
}
