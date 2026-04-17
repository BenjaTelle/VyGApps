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
        // 1. Definir la consulta SQL para pago_nomina
        String sql = "SELECT  id_pago_nomina, periodo_inicio, periodo_fin, monto_pagado, estado FROM pago_nomina WHERE id_trabajador = ? ORDER BY periodo_fin DESC LIMIT 5";

        // 2. Conexión
        Connection con = ConectarBD.conectar();

        // 3. Preparar la consulta
        PreparedStatement ps = con.prepareStatement(sql);
        ps.setInt(1, idTrabajador);

        // 4. Crear la Lista
        List<PagoDTO> listaP = new ArrayList<>();

        // 5. Try / Catch para el ResultSet y el Bucle
        try {
            // 6. ResultSet
            ResultSet rs = ps.executeQuery();

            // 7. Bucle de llenado
            while (rs.next()) {
                PagoDTO dto = new PagoDTO();
                String inicioFormateado = formatearFechaElegante(rs.getString("periodo_inicio"));
                String finFormateado = formatearFechaElegante(rs.getString("periodo_fin"));
                
                dto.setPeriodoInicio(inicioFormateado);
                dto.setPeriodoFin(finFormateado);
                dto.setMonto(rs.getDouble("monto_pagado"));
                dto.setEstado(rs.getString("estado"));
                dto.setIdPago(rs.getInt("id_pago_nomina"));
                listaP.add(dto);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return listaP;
    }
    
     
     // Método privado para darle formato elegante a las fechas
    private String formatearFechaElegante(String fechaSQL) {
        if (fechaSQL == null || fechaSQL.isEmpty()) return "N/D";
        try {
            // Convierte el String de MySQL a un objeto de fecha Java
            LocalDate fecha = LocalDate.parse(fechaSQL);
            
            // Define el formato: "dd MMM yyyy" -> "01 abr 2026"
            // ejemplo "01 de abril de 2026", usa "dd 'de' MMMM 'de' yyyy"
            DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd MMM yyyy", new Locale("es", "ES"));
            
            return fecha.format(formatter);
        } catch (Exception e) {
            return fechaSQL; // Si algo falla, devuelve la fecha original para no romper nada
        }
    }
}
