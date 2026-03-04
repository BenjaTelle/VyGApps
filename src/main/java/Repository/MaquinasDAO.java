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
import model.maquinas;

/**
 *
 * @author Benja
 */
public class MaquinasDAO {
    
    
    
    public List<maquinas> listarMaquinas() throws SQLException
    {
        String sql= "SELECT * FROM maquinas";
        Connection con = ConectarBD.conectar();
        PreparedStatement ps = con.prepareStatement(sql);
         List<maquinas> listaMaquinas = new ArrayList<>();
        try{
            
            ResultSet rs = ps.executeQuery();
            
            while(rs.next())
            {
                maquinas m = new maquinas();
                m.setMarca(rs.getString("marca"));
                m.setFuncion(rs.getString("funcion"));
                m.setId_maquina(rs.getInt("id_maquina"));
                m.setTipo_maquina(rs.getString("tipo_maquina"));
                m.setCosto_por_hora(rs.getDouble("costo_por_hora"));
                listaMaquinas.add(m);
                
            }
        
         
        }catch(SQLException e)
        {
            e.printStackTrace();
        }
        
        
        
        return listaMaquinas;
    }
}
