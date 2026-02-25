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
import model.trabajadores;

/**
 *
 * @author Benja
 */
public class TrabajadoresDAO {

    public void registrarTrabajador(trabajadores t) {
        String sql = "INSERT into trabajadores(cedula,full_name,edad,puesto,salario_quincenal,origen,id_supervisor,id_proyect) VALUES(?,?,?,?,?,?,?,?)";
        Connection con = ConectarBD.conectar();
        try {
            PreparedStatement ps = con.prepareStatement(sql);
            if (t != null) {
                ps.setString(1, t.getCedula());
                ps.setString(2, t.getFull_name());
                ps.setInt(3, t.getEdad());
                ps.setString(4, t.getPuesto());
                ps.setDouble(5, t.getSalario_quincenal());
                ps.setString(6, t.getOrigen());
                ps.setInt(7, t.getId_supervisor());
                ps.setInt(8, t.getId_proyect());

            }
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
    //todos los trabajadores 
    public List<trabajadores> ListarTrabajadores() throws SQLException {
        String sql = "Select * from trabajadores";
        Connection con = ConectarBD.conectar();
        PreparedStatement ps = con.prepareStatement(sql);
        List<trabajadores> ListaT = new ArrayList<>();
        try {

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {

                trabajadores t = new trabajadores();
                t.setId_trabajador(rs.getInt("id_trabajador"));
                t.setCedula(rs.getString("cedula"));
                t.setFull_name(rs.getString("full_name"));
                t.setEdad(rs.getInt("edad"));
                t.setPuesto(rs.getString("puesto"));
                t.setSalario_quincenal(rs.getDouble("salario_quincenal"));
                t.setOrigen(rs.getString("origen"));
                t.setId_supervisor(rs.getInt("id_supervisor"));
                t.setId_proyect(rs.getInt("id_proyect"));

                ListaT.add(t);
            }
            
            

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return ListaT;
    }

    
    //trabajadores que no  tiene puesto supervisor
        public List<trabajadores> ListarTrabajadoresSinSuperv() throws SQLException {
        String sql = "SELECT * FROM trabajadores where not puesto = 'Supervisor de obra'";
        Connection con = ConectarBD.conectar();
        PreparedStatement ps = con.prepareStatement(sql);
        List<trabajadores> ListaT = new ArrayList<>();
        try {

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {

                trabajadores t = new trabajadores();
                t.setId_trabajador(rs.getInt("id_trabajador"));
                t.setCedula(rs.getString("cedula"));
                t.setFull_name(rs.getString("full_name"));
                t.setEdad(rs.getInt("edad"));
                t.setPuesto(rs.getString("puesto"));
                t.setSalario_quincenal(rs.getDouble("salario_quincenal"));
                t.setOrigen(rs.getString("origen"));
                t.setId_supervisor(rs.getInt("id_supervisor"));
                t.setId_proyect(rs.getInt("id_proyect"));

                ListaT.add(t);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return ListaT;
    }
        
        
    //trabajadores que no  tiene puesto supervisor
        public List<trabajadores> ListarTrabajadoresSuperv() throws SQLException {
        String sql = "SELECT * FROM trabajadores where puesto = 'Supervisor de obra' ";
        Connection con = ConectarBD.conectar();
        PreparedStatement ps = con.prepareStatement(sql);
        List<trabajadores> ListaT = new ArrayList<>();
        try {

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {

                trabajadores t = new trabajadores();
                t.setId_trabajador(rs.getInt("id_trabajador"));
                t.setCedula(rs.getString("cedula"));
                t.setFull_name(rs.getString("full_name"));
                t.setEdad(rs.getInt("edad"));
                t.setPuesto(rs.getString("puesto"));
                t.setSalario_quincenal(rs.getDouble("salario_quincenal"));
                t.setOrigen(rs.getString("origen"));
                t.setId_supervisor(rs.getInt("id_supervisor"));
                t.setId_proyect(rs.getInt("id_proyect"));

                ListaT.add(t);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return ListaT;
    }
    
    
    public boolean AsignarProyecto(int  id_proyect, int id_trabajador) throws SQLException
        {
            String sql= "UPDATE trabajadores set id_proyect=?  WHERE  id_trabajador=?";

            Connection con = ConectarBD.conectar();

            PreparedStatement ps = con.prepareStatement(sql);
            
            ps.setInt(1, id_proyect);
            ps.setInt(2, id_trabajador);

             int filasActualizadas = ps.executeUpdate();
            return filasActualizadas > 0;
            
            
           
        
        
    }

    public void ActualizarTrabajador(trabajadores t) throws SQLException {
        String sql = "UPDATE trabajadores SET  cedula=?, full_name= ?, edad =?, puesto=?, salario_quincenal=?, origen=?, id_supervisor=?, id_proyect=? WHERE id_trabajador=?";
        Connection con = ConectarBD.conectar();
        PreparedStatement ps = con.prepareStatement(sql);
        ps.setString(1, t.getCedula());
        ps.setString(2, t.getFull_name());
        ps.setInt(3, t.getEdad());
        ps.setString(4, t.getPuesto());
        ps.setDouble(5, t.getSalario_quincenal());
        ps.setString(6, t.getOrigen());
        ps.setInt(7, t.getId_supervisor());
        ps.setInt(8, t.getId_proyect());
        ps.setInt(9, t.getId_trabajador());
        
        ps.executeLargeUpdate();
        
    }

    public void EliminarTrabajador(int id) throws SQLException {
       String sql="DELETE FROM trabajadores WHERE id_trabajador=?";
       Connection con = ConectarBD.conectar();
       
       PreparedStatement ps = con.prepareStatement(sql);
       ps.setInt(1, id);
       ps.executeUpdate();
       
    }
}
