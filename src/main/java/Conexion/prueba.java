/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Conexion;

import Repository.ProyectoDAO;
import Repository.TrabajadoresDAO;
import java.sql.SQLException;
import java.util.List;
import model.proyectos;
import model.trabajadores;

/**
 *
 * @author Benja
 */
public class prueba {
    public static void main(String args[]) throws SQLException
    {
     TrabajadoresDAO tDAO = new TrabajadoresDAO();
        
        List<trabajadores> lista = tDAO.ListarTrabajadores();
        
        for(trabajadores list:  lista)
        {
            System.out.println("nombre trabajador"+ list.getFull_name());
        }
        
        
    }
}
