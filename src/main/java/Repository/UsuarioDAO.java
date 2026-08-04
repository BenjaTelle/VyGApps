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

import model.Usuarios;

/**
 *
 * @author Benja
 */
public class UsuarioDAO {

    public Usuarios login(String user_name, String pass) throws SQLException {
        Usuarios usu = null;
        String sql = "Select * from usuarios where user_name=? and pass=?";

        try (Connection con = ConectarBD.conectar();
             PreparedStatement ps = con.prepareStatement(sql)) {
             
            ps.setString(1, user_name);
            ps.setString(2, pass);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    usu = new Usuarios();
                    usu.setUser_name(rs.getString("user_name"));
                    usu.setPass(rs.getString("pass"));
                    usu.setRol(rs.getString("rol"));
                    usu.setId_user(Integer.parseInt(rs.getString("id_user")));
                    usu.setId_trabajador(rs.getObject("id_trabajador") != null ? rs.getInt("id_trabajador") : null);
                    System.out.println("usuario encontrado:  " + usu.getUser_name() + "" + usu.getPass());
                }
            }
        }
        return usu;
    }

    public List<Usuarios> traerSupervisor() throws SQLException {
        String sql = "Select * from usuarios where rol='Supervisor' ";
        List<Usuarios> LS = new ArrayList<>();

        try (Connection con = ConectarBD.conectar();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
             
            while (rs.next()) {
                Usuarios usu = new Usuarios();
                usu.setUser_name(rs.getString("user_name"));
                usu.setPass(rs.getString("pass"));
                usu.setRol(rs.getString("rol"));
                usu.setId_user(Integer.parseInt(rs.getString("id_user")));
                LS.add(usu); 
            }
            return LS; 
        } catch (SQLException e) {
            return null; 
        }
    }

    public void registrarUsuario(Usuarios usu) throws SQLException {
        String sql = "INSERT INTO usuarios(user_name, pass, rol, id_trabajador) VALUES (?, ?, ?, ?)";
        try (Connection con = ConectarBD.conectar();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, usu.getUser_name());
            ps.setString(2, usu.getPass());
            ps.setString(3, usu.getRol());

            Integer idTrab = usu.getId_trabajador();
            if (idTrab != null) {
                ps.setInt(4, idTrab);
            } else {
                ps.setNull(4, java.sql.Types.INTEGER);
            }
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
            throw e;
        }
    }

    public List<Usuarios> ListarUsuarios() throws SQLException {
        String sql = "Select * from usuarios ";
        List<Usuarios> LS = new ArrayList<>();

        try (Connection con = ConectarBD.conectar();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
             
            while (rs.next()) {
                Usuarios usu = new Usuarios();
                usu.setUser_name(rs.getString("user_name"));
                usu.setPass(rs.getString("pass"));
                usu.setRol(rs.getString("rol"));
                usu.setId_user(Integer.parseInt(rs.getString("id_user")));
                LS.add(usu);
            }
            return LS; 
        } catch (SQLException e) {
            return null; 
        }
    }

    public int modificarUsuario(Usuarios usu) throws SQLException {
        String sql = "UPDATE usuarios SET user_name =?, pass=?, rol=?, id_trabajador=? WHERE id_user=?";

        try (Connection con = ConectarBD.conectar();
             PreparedStatement ps = con.prepareStatement(sql)) {
             
            ps.setString(1, usu.getUser_name());
            ps.setString(2, usu.getPass());
            ps.setString(3, usu.getRol());
            ps.setInt(4, usu.getId_trabajador());
            ps.setInt(5, usu.getId_user());

            return ps.executeUpdate();
        }
    }

    public int EliminarUsuario(int idUsu) throws SQLException {
        String sql = "DELETE FROM usuarios WHERE id_user=?";
        try (Connection con = ConectarBD.conectar();
             PreparedStatement ps = con.prepareStatement(sql)) {
             
            ps.setInt(1, idUsu);
            return ps.executeUpdate();
        }
    }
}
