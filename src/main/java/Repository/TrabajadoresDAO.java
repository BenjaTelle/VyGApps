/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Repository;

import Conexion.ConectarBD;
import DTO.ReporteTrabajadorDTO;
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
        String sql = "SELECT * FROM trabajadores \n"
                + "WHERE puesto IN ('Supervisor de obra', 'Ingeniero residente', 'Arquitecto') \n"
                + "AND estado = 'Activo'";
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

    public List<trabajadores> ListarTecnicoOperadorativo() throws SQLException {
        String sql = "SELECT * FROM trabajadores where puesto = 'Tecnico operativo' ";
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

    public boolean AsignarProyecto(int id_proyect, int id_trabajador) throws SQLException {
        String sql = "UPDATE trabajadores set id_proyect=?  WHERE  id_trabajador=?";

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
        String sql = "DELETE FROM trabajadores WHERE id_trabajador=?";
        Connection con = ConectarBD.conectar();

        PreparedStatement ps = con.prepareStatement(sql);
        ps.setInt(1, id);
        ps.executeUpdate();

    }

    public List<ReporteTrabajadorDTO> reporteDinamicoTrabajadores(int idProyecto, String estadoFiltro) {
        List<ReporteTrabajadorDTO> lista = new ArrayList<>();

        // Iniciamos la consulta base (1=1 es un truco para poder concatenar los AND fácilmente)
        StringBuilder sql = new StringBuilder(
                "SELECT t.id_trabajador, t.full_name, p.name_proyect, t.salario_quincenal, t.estado "
                + "FROM trabajadores t "
                + "INNER JOIN proyectos p ON t.id_proyect = p.id_proyecto "
                + "WHERE 1=1 "
        );

        // Agregamos filtros a la consulta solo si es necesario
        if (idProyecto > 0) {
            sql.append("AND t.id_proyect = ? ");
        }
        if (!estadoFiltro.equalsIgnoreCase("Todos")) {
            sql.append("AND t.estado = ? ");
        }

        sql.append("ORDER BY t.estado ASC, p.name_proyect ASC, t.full_name ASC");

        try (Connection con = ConectarBD.conectar(); PreparedStatement ps = con.prepareStatement(sql.toString())) {

            // Asignar los parámetros dinámicamente
            int paramIndex = 1;

            if (idProyecto > 0) {
                ps.setInt(paramIndex++, idProyecto);
            }
            if (!estadoFiltro.equalsIgnoreCase("Todos")) {
                ps.setString(paramIndex++, estadoFiltro);
            }

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                ReporteTrabajadorDTO dto = new ReporteTrabajadorDTO();
                dto.setIdTrabajador(rs.getInt("id_trabajador"));
                dto.setNombreCompleto(rs.getString("full_name"));
                dto.setNombreProyecto(rs.getString("name_proyect"));
                dto.setSalarioBase(rs.getDouble("salario_quincenal"));
                dto.setEstado(rs.getString("estado"));

                lista.add(dto);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return lista;
    }
}
