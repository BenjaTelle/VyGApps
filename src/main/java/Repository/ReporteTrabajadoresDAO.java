/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Repository;

import Conexion.ConectarBD;
import DTO.ReporteAsistenciaDTO;
import DTO.ReporteTrabajadorDTO;
import DTO.ResumenAsistenciaDTO;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.proyectos;

/**
 *
 * @author Benja
 */
  
   
public class ReporteTrabajadoresDAO {
    /**
     * Obtiene la lista de proyectos activos disponibles en el sistema.
     * 
     * @return Lista de proyectos con estado activo.
     * @throws SQLException Si ocurre un error de acceso a datos.
     */
    public List<proyectos> obtenerProyectosActivos() throws SQLException {
        String sql = "SELECT id_proyecto, name_proyect  FROM proyectos WHERE estado = 'Activo'";
        Connection con = ConectarBD.conectar();
        PreparedStatement ps = con.prepareStatement(sql);
        List<proyectos> lista = new ArrayList<>();
        
        try {
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                proyectos p = new proyectos();
                p.setProyecto_id(rs.getInt("id_proyecto"));
                p.setNombre_proyecto(rs.getString("name_proyect"));
                
                lista.add(p);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return lista;
    }

    /**
     * Genera un reporte detallado de trabajadores filtrado por proyecto y estado.
     * 
     * @param idProyecto ID del proyecto para filtrar (0 para incluir todos).
     * @param estadoFiltro Estado del trabajador para filtrar ("Todos" para omitir este filtro).
     * @return Lista de ReporteTrabajadorDTO con los datos solicitados.
     * @throws SQLException Si ocurre un error durante la ejecución de la consulta.
     */
    public List<ReporteTrabajadorDTO> reporteDinamicoTrabajadores(int idProyecto, String estadoFiltro) throws SQLException {
        StringBuilder sqlBuilder = new StringBuilder(
            "SELECT t.id_trabajador, t.full_name, p.name_proyect, t.salario_quincenal, t.estado " +
            "FROM trabajadores t " +
            "INNER JOIN proyectos p ON t.id_proyect = p.id_proyecto " +
            "WHERE 1=1 "
        );

        if (idProyecto > 0) {
            sqlBuilder.append("AND t.id_proyect = ? ");
        }
        if (!estadoFiltro.equalsIgnoreCase("Todos")) {
            sqlBuilder.append("AND t.estado = ? ");
        }
        sqlBuilder.append("ORDER BY t.estado ASC, p.name_proyect ASC, t.full_name ASC");

        String sql = sqlBuilder.toString();
        Connection con = ConectarBD.conectar();
        PreparedStatement ps = con.prepareStatement(sql);
        List<ReporteTrabajadorDTO> lista = new ArrayList<>();
        
        try {
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

    
    
      public List<ReporteAsistenciaDTO> filtrarAsistencia(String fechaInicio, String fechaFin, int idProyecto, String estadoFiltro) throws SQLException {
        List<ReporteAsistenciaDTO> lista = new ArrayList<>();
        Connection con = ConectarBD.conectar();
        
        // TODO: Refactorizar generación de consulta para utilizar Criteria API o un ORM en lugar de concatenación manual.
        StringBuilder sql = new StringBuilder();
        sql.append("SELECT a.fecha, t.full_name, p.name_proyect, a.hora_entrada, a.hora_salida ");
        sql.append("FROM asistencia a ");
        sql.append("JOIN trabajadores t ON a.id_trabajador = t.id_trabajador ");
        sql.append("JOIN proyectos p ON t.id_proyect = p.id_proyecto ");
        sql.append("WHERE a.fecha BETWEEN ? AND ? ");
        
        if (idProyecto > 0) {
            sql.append("AND t.id_proyect = ? ");
        }
        
        sql.append("ORDER BY a.fecha DESC, t.full_name ASC");

        try {
            PreparedStatement ps = con.prepareStatement(sql.toString());
            ps.setString(1, fechaInicio);
            ps.setString(2, fechaFin);
            
            if (idProyecto > 0) {
                ps.setInt(3, idProyecto);
            }

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                ReporteAsistenciaDTO dto = new ReporteAsistenciaDTO();
                dto.setFecha(rs.getString("fecha"));
                dto.setNombreTrabajador(rs.getString("full_name"));
                dto.setNombreProyecto(rs.getString("name_proyect"));
                
                String horaEntrada = rs.getString("hora_entrada");
                dto.setHoraEntrada(horaEntrada);
                dto.setHoraSalida(rs.getString("hora_salida"));
                
                // Lógica simple para Estado
                String estadoCalculado = "Ausente";
                if (horaEntrada != null) {
                    // Si entra después de las 08:15:00, es tardanza. Ajusta esto a la política de tu empresa.
                    if (horaEntrada.compareTo("08:15:00") > 0) {
                        estadoCalculado = "Tardanza";
                    } else {
                        estadoCalculado = "Presente";
                    }
                }
                dto.setEstado(estadoCalculado);

                // Aplicar el filtro de estado en memoria (si el usuario no eligió "Todos")
                if (estadoFiltro == null || estadoFiltro.equals("Todos") || estadoFiltro.equalsIgnoreCase(estadoCalculado)) {
                    lista.add(dto);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            if (con != null) con.close();
        }
        return lista;
    }
    
    

}
