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
        String sql = "SELECT u.user_name, t.full_name, u.rol FROM usuarios as u LEFT JOIN trabajadores as t on t.id_trabajador = u.id_trabajador";
        
        List<UsuarioDetalle> ListaUD = new ArrayList<>();
        try (Connection con = ConectarBD.conectar();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                UsuarioDetalle ud = new UsuarioDetalle();
                ud.setUsern_name(rs.getString("user_name"));
                String fullName = rs.getString("full_name");
                ud.setTrabajadorAsign(fullName != null ? fullName : "Sin trabajador");
                ud.setRol(rs.getString("rol"));
                ListaUD.add(ud);
            }
        }
        return ListaUD;
    }

    public UsuarioDetalle BuscarUsuDetalle(int idT) throws SQLException {
        String sql = "SELECT u.user_name, t.full_name, u.rol FROM usuarios as u LEFT JOIN trabajadores as t on t.id_trabajador = u.id_trabajador WHERE u.id_trabajador=? OR (? = 0 AND u.id_trabajador IS NULL)";
        UsuarioDetalle ud = new UsuarioDetalle();
        try (Connection con = ConectarBD.conectar();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, idT);
            ps.setInt(2, idT);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    ud.setRol(rs.getString("rol"));
                    String fullName = rs.getString("full_name");
                    ud.setTrabajadorAsign(fullName != null ? fullName : "Sin trabajador");
                    ud.setUsern_name(rs.getString("user_name"));
                }
            }
        }
        if (ud.getTrabajadorAsign() == null) {
            ud.setTrabajadorAsign("Usuario General");
        }
        return ud;
    }
}
