/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Repository;

import Conexion.ConectarBD;
import DTO.PagoDTO;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author Benja
 */
public class PagosDAO {
    
    // Método para listar los últimos pagos de un trabajador específico
    public List<PagoDTO> listarPagosPorTrabajador(int idTrabajador) throws SQLException {
      String sql = "SELECT p.quincena_fecha, pr.name_proyect, p.monto_presupuestado, p.estado " +
                     "FROM pago p " +
                     "LEFT JOIN proyectos pr ON p.id_proyecto = pr.id_proyecto " +
                     "WHERE p.id_trabajador = ? " +
                     "ORDER BY p.quincena_fecha DESC LIMIT 5"; // Mostramos los últimos 5

        //  Conexión
        Connection con = ConectarBD.conectar();

        //  Preparar la consulta
        PreparedStatement ps = con.prepareStatement(sql);

        //  Crear la Lista
        List<PagoDTO> listaP = new ArrayList<>();

        // 5. Try / Catch para asignar parámetro, el ResultSet y el Bucle
        try {
            ps.setInt(1, idTrabajador);

            // 6. ResultSet
            ResultSet rs = ps.executeQuery();

            // 7. Bucle de llenado
            while (rs.next()) {
                PagoDTO dto = new PagoDTO();
                
                dto.setFecha(rs.getString("quincena_fecha"));
                
                // Armar el "Concepto" dinámicamente con el nombre del proyecto
                String nombreProyecto = rs.getString("name_proyect");
                if (nombreProyecto != null) {
                    dto.setConcepto("Nómina - " + nombreProyecto);
                } else {
                    dto.setConcepto("Nómina General");
                }
                
                dto.setMonto(rs.getDouble("monto_presupuestado"));
                dto.setEstado(rs.getString("estado"));

                listaP.add(dto);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return listaP;
    
    }
}
