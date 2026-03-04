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
import model.material;

/**
 *
 * @author Benja
 */
public class MaterialDAO {
    
    public List<material> ListarMateriales()
    {
        String sql="SELECT * FROM materiales";
          List<material> ListaM = new ArrayList<>();
        try{
            
            Connection con = ConectarBD.conectar();
            PreparedStatement ps = con.prepareStatement(sql);
            
            ResultSet rs = ps.executeQuery();
            
            while(rs.next())
            {
                material m = new material();
                m.setId_material(rs.getInt("id_material"));
                m.setCosto_unitario(rs.getDouble("costo_unitario"));
                m.setNombre_material(rs.getString("nombre_material"));
                m.setUnidad_medida(rs.getString("unidad_medida"));
                
                ListaM.add(m);
                
            }
            
        }catch(SQLException e)
        {
            e.printStackTrace();
        }
        
        return ListaM;
    }
}
