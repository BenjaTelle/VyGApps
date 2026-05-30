/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Repository;

import Conexion.ConectarBD;
import DTO.ResumenGastoDTO;
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
public class ResumenDiarioDAO {

    public List<ResumenGastoDTO> obtenerResumenDiario(String fecha, int idProyecto, String categoria) throws SQLException {
        
        List<ResumenGastoDTO> listaGastos = new ArrayList<>();
        ResumenGastoDTO gasto = null;

        String condFecha = (fecha != null && !fecha.isEmpty()) ? " = '" + fecha + "'" : " = CURDATE()";
        StringBuilder sql = new StringBuilder();
        boolean requiereUnion = false;

        // 1. Consulta de Nómina
        if (categoria.equals("Todos") || categoria.equals("Nomina")) {
            sql.append("SELECT pn.id_pago_nomina AS id_ref, 'Nomina' AS categoria, pr.name_proyect AS nombre_proyecto, ")
               .append("CONCAT('Pago planilla: ', t.full_name) AS concepto, pn.fecha_generacion AS fecha, pn.monto_pagado AS monto ")
               .append("FROM pago_nomina pn ")
               .append("INNER JOIN trabajadores t ON pn.id_trabajador = t.id_trabajador ")
               .append("INNER JOIN proyectos pr ON t.id_proyect = pr.id_proyecto ")
               .append("WHERE pn.fecha_generacion ").append(condFecha);
               
            if (idProyecto > 0) {
                sql.append(" AND t.id_proyect = ").append(idProyecto);
            }
            requiereUnion = true;
        }

        // 2. Consulta de Maquinaria
        if (categoria.equals("Todos") || categoria.equals("Maquinaria")) {
            if (requiereUnion) sql.append(" UNION ALL ");
            
            sql.append("SELECT pm.id_pago_maq AS id_ref, 'Maquinaria' AS categoria, pr.name_proyect AS nombre_proyecto, ")
               .append("CONCAT('Operación: ', mq.marca) AS concepto, pm.fecha_generacion AS fecha, pm.total_pagado AS monto ")
               .append("FROM pago_maquinaria pm ")
               .append("INNER JOIN uso_registro ur ON pm.id_uso = ur.id_uso ")
               .append("INNER JOIN maquinas mq ON ur.id_maquinaria = mq.id_maquina ")
               .append("INNER JOIN proyectos pr ON ur.id_proyect = pr.id_proyecto ")
               .append("WHERE pm.fecha_generacion ").append(condFecha);
               
            if (idProyecto > 0) {
                sql.append(" AND ur.id_proyect = ").append(idProyecto);
            }
            requiereUnion = true;
        }

        // 3. Consulta de Fletes
        if (categoria.equals("Todos") || categoria.equals("Flete")) {
            if (requiereUnion) sql.append(" UNION ALL ");
            
            sql.append("SELECT rc.id_ruta AS id_ref, 'Flete' AS categoria, pr.name_proyect AS nombre_proyecto, ")
               .append("CONCAT('Acarreo: ', mat.nombre_material) AS concepto, ur.fecha AS fecha, rc.costo_flete AS monto ")
               .append("FROM registro_camiones rc ")
               .append("INNER JOIN uso_registro ur ON rc.id_uso = ur.id_uso ")
               .append("INNER JOIN materiales mat ON rc.id_material = mat.id_material ")
               .append("INNER JOIN proyectos pr ON ur.id_proyect = pr.id_proyecto ")
               .append("WHERE ur.fecha ").append(condFecha);
               
            if (idProyecto > 0) {
                sql.append(" AND ur.id_proyect = ").append(idProyecto);
            }
            requiereUnion = true;
        }

        // 4. Consulta de Gastos Varios
        if (categoria.equals("Todos") || categoria.equals("Otros")) {
            if (requiereUnion) sql.append(" UNION ALL ");
            
            sql.append("SELECT gp.id_gasto AS id_ref, gp.categoria AS categoria, pr.name_proyect AS nombre_proyecto, ")
               .append("gp.concepto AS concepto, gp.fecha_gasto AS fecha, gp.monto AS monto ")
               .append("FROM gastos_proyectos gp ")
               .append("INNER JOIN proyectos pr ON gp.id_proyecto = pr.id_proyecto ")
               .append("WHERE gp.fecha_gasto ").append(condFecha);
               
            if (idProyecto > 0) {
                sql.append(" AND gp.id_proyecto = ").append(idProyecto);
            }
        }

        Connection con = ConectarBD.conectar();
        PreparedStatement ps = con.prepareStatement(sql.toString());

        try {
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                gasto = new ResumenGastoDTO();
                gasto.setIdReferencia(rs.getString("id_ref"));
                gasto.setCategoria(rs.getString("categoria"));
                gasto.setNombreProyecto(rs.getString("nombre_proyecto"));
                gasto.setConcepto(rs.getString("concepto"));
                gasto.setFechaOperacion(rs.getString("fecha"));
                gasto.setMonto(rs.getDouble("monto"));
                
                listaGastos.add(gasto);
            }

            return listaGastos;

        } catch (SQLException e) {
            e.printStackTrace();
            return null;
        }
    }
}