/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Repository;

import Conexion.ConectarBD;
import Conexion.ConectarBD;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.Set;

import model.Usuarios;
import model.proyectos;

/**
 *
 * @author Benja
 */
public class UsuarioDAO {

    public Usuarios login(String user_name, String pass) throws SQLException {
        //establecemos el objeto en null

        Usuarios usu = null;

        //hacemos la consulta 
        String sql = "Select * from usuarios where user_name=? and pass=?";

        Connection con = ConectarBD.conectar();

        PreparedStatement ps = con.prepareStatement(sql);
        //prepara los parametros 
        ps.setString(1, user_name);
        ps.setString(2, pass);
        
        //Ejecutar select
        ResultSet rs = ps.executeQuery();
        //vemos  si hay resultados 
        if (rs.next()) {
            usu = new Usuarios();
            usu.setUser_name(rs.getString("user_name"));
            usu.setPass(rs.getString("pass"));
            usu.setRol(rs.getString("rol"));
            usu.setId_user(Integer.parseInt(rs.getString("id_user")));
            usu.setId_trabajador(rs.getInt("id_trabajador"));
            
            System.out.println("usuario encontrado:  " + usu.getUser_name() + "" + usu.getPass());

        }

        return usu;

    }

    public List<Usuarios> traerSupervisor() throws SQLException {
        Usuarios usu = null;
        String sql = "Select * from usuarios where rol='Supervisor' ";
        List<Usuarios> LS = new ArrayList<>();
        //conectamos a bd 
        Connection con = ConectarBD.conectar();

        PreparedStatement ps = con.prepareStatement(sql);

        try {
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {

                usu = new Usuarios();
               

                usu.setUser_name(rs.getString("user_name"));
                usu.setPass(rs.getString("pass"));
                usu.setRol(rs.getString("rol"));
                usu.setId_user(Integer.parseInt(rs.getString("id_user")));
                
                

            }

          

            return LS; //retornamos la lista con los supervisores
            
        } catch (SQLException e) {

            return null; //retornamos un null si no hay supervisores
        }

    }
    
    public void registrarUsuario(Usuarios usu) throws SQLException{
    String sql = "INSERT INTO usuarios(user_name, pass, rol, id_trabajador) VALUES (?, ?, ?, ?)";

    Connection con = ConectarBD.conectar();

    try (PreparedStatement ps = con.prepareStatement(sql)) {

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
        Usuarios usu = null;
        String sql = "Select * from usuarios ";
        List<Usuarios> LS = new ArrayList<>();
        //conectamos a bd 
        Connection con = ConectarBD.conectar();

        PreparedStatement ps = con.prepareStatement(sql);

        try {
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {

                usu = new Usuarios();
               

                usu.setUser_name(rs.getString("user_name"));
                usu.setPass(rs.getString("pass"));
                usu.setRol(rs.getString("rol"));
                usu.setId_user(Integer.parseInt(rs.getString("id_user")));

                  LS.add(usu);
            }

         

            return LS; //retornamos la lista con los supervisores
            
        } catch (SQLException e) {

            return null; //retornamos un null si no hay supervisores
        }

    }

    public int modificarUsuario(Usuarios usu) throws SQLException {
            String sql="UPDATE usuarios SET user_name =?, pass=?, rol=?, id_trabajador=? WHERE id_user=?";
            
             Connection con = ConectarBD.conectar();

        PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, usu.getUser_name());
            ps.setString(2, usu.getPass());
            ps.setString(3, usu.getRol());
            ps.setInt(4, usu.getId_trabajador());
            ps.setInt(5, usu.getId_user());
            
            int filas=ps.executeUpdate();
            
            if(filas>0)
            {
                return filas;
            }
            else
            {
                return 0;
            }
            
    }

    public int EliminarUsuario(int idUsu) throws SQLException {
        String sql = "DELETE FROM usuarios WHERE id_user=?";
        Connection con = ConectarBD.conectar();
        
        PreparedStatement ps = con.prepareStatement(sql);
        ps.setInt(1, idUsu);
        
        int filas =ps.executeUpdate();
        
        return filas;
    }

}
