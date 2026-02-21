package Repository;

import Conexion.ConectarBD;
import DTO.UsuarioDetalle;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */

/**
 *
 * @author Benja
 */
public class UsuarioDetalleDAO {

    public List<UsuarioDetalle> ListarUsuDetalle() throws SQLException {
        String sql = "SELECT u.user_name, t.full_name, u.rol FROM usuarios as u  INNER JOIN trabajadores as t on t.id_trabajador = u.id_trabajador";
        
        Connection con = ConectarBD.conectar();
        PreparedStatement ps = con.prepareStatement(sql);
        
        ResultSet rs = ps.executeQuery();
    List<UsuarioDetalle> ListaUD = new ArrayList<>();
        while(rs.next())
        {
            UsuarioDetalle ud = new UsuarioDetalle();
            ud.setUsern_name(rs.getString("user_name"));
            ud.setTrabajadorAsign(rs.getString("full_name"));
            ud.setRol(rs.getString("rol"));
            
            ListaUD.add(ud);
            
        }
        
        
        
      return ListaUD;
    }
    
    
    
    
}
