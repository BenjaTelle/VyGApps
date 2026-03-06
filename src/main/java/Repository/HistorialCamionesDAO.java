/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Repository;

import Conexion.ConectarBD;
import DTO.HistorialCamionesDTO;
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
public class HistorialCamionesDAO {
    
    
    public List<HistorialCamionesDTO> ListarHistorialC() throws SQLException
    {
        String sql = "SELECT rc.id_ruta , rc.cantidad_cargada, rc.origen, rc.destino, rc.hora_salida, rc.hora_llegada, rc.costo_flete, ur.fecha,p.name_proyect as nombre_proyecto, mq.tipo_maquina, mq.marca, m.nombre_material \n" +
"FROM registro_camiones as rc \n" +
"INNER JOIN uso_registro as ur on ur.id_uso = rc.id_uso \n" +
"INNER  JOIN materiales as m on m.id_material = rc.id_material INNER JOIN proyectos as p on p.id_proyecto = ur.id_proyect \n" +
"INNER JOIN maquinas as mq on mq.id_maquina = ur.id_maquinaria; ";
        
        Connection con = ConectarBD.conectar();
        PreparedStatement ps = con.prepareStatement(sql);
        List<HistorialCamionesDTO> ListaHC = new ArrayList<>();
        try{
            
            ResultSet rs = ps.executeQuery();
            while(rs.next())
            {
                HistorialCamionesDTO hc = new HistorialCamionesDTO();
               hc.setId_ruta(rs.getInt("id_ruta"));
               hc.setCantidad_cargada(rs.getDouble("cantidad_cargada"));
              hc.setOrigen(rs.getString("origen"));
              hc.setDestino(rs.getString("destino"));
              hc.setHora_salida(rs.getTime("hora_salida"));
              hc.setHora_entrada(rs.getTime("hora_llegada"));
              hc.setCosto_flete(rs.getDouble("costo_flete"));
              hc.setFecha(rs.getDate("fecha"));
              hc.setNombre_proyecto(rs.getString("nombre_proyecto"));
              hc.setTipo_maquina(rs.getString("tipo_maquina"));
              hc.setMarca(rs.getString("marca"));
              hc.setNombre_material(rs.getString("nombre_material"));
              
              ListaHC.add(hc);
              
              
              
            }
            
        }catch(SQLException e)
        {
            e.printStackTrace();
        }
        
        return ListaHC;
        
    }
    
      public HistorialCamionesDTO BuscarCamionID(int id) throws SQLException
    {
        String sql = "SELECT rc.id_ruta , rc.cantidad_cargada, rc.origen, rc.destino, rc.hora_salida, rc.hora_llegada, rc.costo_flete, ur.fecha,p.name_proyect as nombre_proyecto, mq.tipo_maquina, mq.marca, m.nombre_material \n" +
"FROM registro_camiones as rc \n" +
"INNER JOIN uso_registro as ur on ur.id_uso = rc.id_uso \n" +
"INNER  JOIN materiales as m on m.id_material = rc.id_material INNER JOIN proyectos as p on p.id_proyecto = ur.id_proyect \n" +
"INNER JOIN maquinas as mq on mq.id_maquina = ur.id_maquinaria where id_ruta=?";
        
        Connection con = ConectarBD.conectar();
        PreparedStatement ps = con.prepareStatement(sql);
        
        ps.setInt(1, id);
        
      HistorialCamionesDTO hc = new HistorialCamionesDTO();
        try{
            
            ResultSet rs = ps.executeQuery();
            
            while(rs.next())
            {
                
               hc.setId_ruta(rs.getInt("id_ruta"));
               hc.setCantidad_cargada(rs.getDouble("cantidad_cargada"));
              hc.setOrigen(rs.getString("origen"));
              hc.setDestino(rs.getString("destino"));
              hc.setHora_salida(rs.getTime("hora_salida"));
              hc.setHora_entrada(rs.getTime("hora_llegada"));
              hc.setCosto_flete(rs.getDouble("costo_flete"));
              hc.setFecha(rs.getDate("fecha"));
              hc.setNombre_proyecto(rs.getString("nombre_proyecto"));
              hc.setTipo_maquina(rs.getString("tipo_maquina"));
              hc.setMarca(rs.getString("marca"));
              hc.setNombre_material(rs.getString("nombre_material"));
              
           
              
              
              
            }
            
        }catch(SQLException e)
        {
            e.printStackTrace();
        }
        
        return hc;
        
    }
    
    
    
    
}
