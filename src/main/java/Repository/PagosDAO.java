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
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;
import java.util.Locale;

/**
 *
 * @author Benja
 */
public class PagosDAO {
    public List<PagoDTO> listarNominasPorTrabajador(int idTrabajador) throws SQLException {
        String sql = "SELECT  id_pago_nomina, periodo_inicio, periodo_fin, monto_pagado, estado FROM pago_nomina WHERE id_trabajador = ? ORDER BY periodo_fin DESC LIMIT 5";
        List<PagoDTO> listaP = new ArrayList<>();

        try (Connection con = ConectarBD.conectar();
             PreparedStatement ps = con.prepareStatement(sql)) {
             
            ps.setInt(1, idTrabajador);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    PagoDTO dto = new PagoDTO();
                    String inicioFormateado = formatoFechaLocal(rs.getString("periodo_inicio"));
                    String finFormateado = formatoFechaLocal(rs.getString("periodo_fin"));
                    
                    dto.setPeriodoInicio(inicioFormateado);
                    dto.setPeriodoFin(finFormateado);
                    dto.setMonto(rs.getDouble("monto_pagado"));
                    dto.setEstado(rs.getString("estado"));
                    dto.setIdPago(rs.getInt("id_pago_nomina"));
                    listaP.add(dto);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return listaP;
    }
    
    /**
     * Convierte una fecha en formato SQL a un formato legible localizado.
     * 
     * @param fechaSQL Fecha en formato yyyy-MM-dd.
     * @return Fecha formateada (ej. '01 Ene 2023') o 'N/D' si es nula.
     */
    private String formatoFechaLocal(String fechaSQL) {
        if (fechaSQL == null || fechaSQL.isEmpty()) return "N/D";
        try {
            LocalDate fecha = LocalDate.parse(fechaSQL);
            DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd MMM yyyy", new Locale("es", "ES"));
            return fecha.format(formatter);
        } catch (Exception e) {
            return fechaSQL; 
        }
    }
    
    public PagoDTO obtenerDetallePago(int idPago) throws SQLException {
        PagoDTO pago = null;
        
        String sql = "SELECT pn.id_pago_nomina, pn.periodo_inicio, pn.periodo_fin, "
                   + "pn.monto_pagado, pn.estado, pn.dias_trabajados, "
                   + "t.full_name AS nombre_trabajador, p.name_proyect AS nombre_proyecto "
                   + "FROM pago_nomina pn "
                   + "INNER JOIN trabajadores t ON pn.id_trabajador = t.id_trabajador "
                   + "INNER JOIN proyectos p ON t.id_proyect = p.id_proyecto "
                   + "WHERE pn.id_pago_nomina = ?";

        try (Connection con = ConectarBD.conectar();
             PreparedStatement ps = con.prepareStatement(sql)) {
             
            ps.setInt(1, idPago);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    pago = new PagoDTO();
                    pago.setIdPago(rs.getInt("id_pago_nomina"));
                    pago.setPeriodoInicio(rs.getString("periodo_inicio"));
                    pago.setPeriodoFin(rs.getString("periodo_fin"));
                    pago.setMonto(rs.getDouble("monto_pagado"));
                    pago.setEstado(rs.getString("estado"));
                    pago.setNombreTrabajador(rs.getString("nombre_trabajador"));
                    pago.setNombreProyecto(rs.getString("nombre_proyecto"));
                    pago.setDiasTrabajados(rs.getInt("dias_trabajados"));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return pago;
    }
}
