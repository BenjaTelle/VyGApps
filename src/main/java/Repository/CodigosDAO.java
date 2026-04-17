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
import java.util.Random;

/**
 *
 * @author Benja
 */
public class CodigosDAO {
    
    // Método para insertar el código generado por el supervisor
    public boolean crearCodigoAsistencia(String codigo, int idSupervisor, int idProyecto, int minutosValidez) throws SQLException {
        // 1. Definir la consulta SQL
        // Usamos DATE_ADD de MySQL para sumar los minutos a la hora actual del servidor automáticamente
        String sql = "INSERT INTO codigos_asistencia (codigo, id_supervisor, id_proyecto, fecha_expiracion, estado) " +
                     "VALUES (?, ?, ?, DATE_ADD(NOW(), INTERVAL ? MINUTE), 'Activo')";
        
        // 2. Conexión
        Connection con = ConectarBD.conectar();
        
        // 3. Preparar la consulta
        PreparedStatement ps = con.prepareStatement(sql);
        
        // 4. Variable de retorno
        boolean exito = false;
        
        // 5. Try / Catch
        try {
            // Asignar los parámetros
            ps.setString(1, codigo);
            ps.setInt(2, idSupervisor);
            ps.setInt(3, idProyecto);
            ps.setInt(4, minutosValidez);
            
            // 6. Ejecutar actualización (executeUpdate para INSERT/UPDATE/DELETE)
            int filasAfectadas = ps.executeUpdate();
            
            // 7. Verificación
            if (filasAfectadas > 0) {
                exito = true;
            }
            
        } catch (SQLException e) {
            System.out.println("Error al insertar el código de asistencia en la BD: " + e.getMessage());
            e.printStackTrace();
        } 
        
        return exito;
    }
    
     public String generarCadenaAleatoria() {
        String caracteres = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
        StringBuilder codigo = new StringBuilder();
        Random rnd = new Random();
        
        // Generamos 6 caracteres aleatorios
        for (int i = 0; i < 6; i++) {
            codigo.append(caracteres.charAt(rnd.nextInt(caracteres.length())));
        }
        
        return "VYG-" + codigo.toString(); // Resultado ej: VYG-7B9X2A
    }
     
     
   
}
