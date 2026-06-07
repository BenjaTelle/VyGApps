/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controlador;

import Repository.ProyectoDAO;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.SQLException;
import java.sql.Time;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import model.proyectos;

/**
 *
 * @author Benja
 */
@WebServlet(name = "ConfigurarProyectoSv", urlPatterns = {"/ConfigurarProyectoSv"})
public class ConfigurarProyectoSv extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
     
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
       
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
         try {
            // 1. Obtener parámetros del modal
            int idProyecto = Integer.parseInt(request.getParameter("id_proyecto"));
            String horaEntradaStr = request.getParameter("hora_entrada_oficial");
            String horaSalidaStr = request.getParameter("hora_salida_oficial");
            double tarifaExtra = Double.parseDouble(request.getParameter("tarifa_hora_extra"));
            
            // 2. Convertir horas a SQL Time
            Time horaEntrada = Time.valueOf(horaEntradaStr + ":00");
            Time horaSalida = Time.valueOf(horaSalidaStr + ":00");
            
            ProyectoDAO pDAO = new ProyectoDAO();
            
            // 3. Buscar el proyecto original para no perder su nombre, estado o presupuesto
            proyectos proyectoActual = pDAO.BuscarPorID(idProyecto);
            
            if(proyectoActual.getProyecto_id() > 0) {
                // 4. Modificar únicamente las reglas operativas
                proyectoActual.setHora_entrada_oficial(horaEntrada);
                proyectoActual.setHora_salida_oficial(horaSalida);
                proyectoActual.setTarifa_hora_extra(tarifaExtra);
                
                // 5. Actualizar en Base de Datos
                pDAO.EditarProyecto(proyectoActual);
            }
            
        } catch (SQLException | NumberFormatException e) {
            System.out.println("Error al configurar el proyecto: " + e.getMessage());
            e.printStackTrace();
        }
        
        // 6. Recargar la lista de proyectos limpiamente
        response.sendRedirect("ListarProyectos");
        
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
