/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controlador;

import Repository.JustificacionDAO;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Date;
import java.sql.SQLException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 *
 * @author Benja
 */
@WebServlet(name = "ProcesarJustificacionSv", urlPatterns = {"/ProcesarJustificacionSv"})
public class ProcesarJustificacionSv extends HttpServlet {

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
        processRequest(request, response);
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
        request.setCharacterEncoding("UTF-8"); // Asegurar que los acentos lleguen bien
        
        try {
            // 1. Recibir los datos del formulario
            String idIncidencia = request.getParameter("id_incidencia"); // Trae "id_fecha"
            String motivo = request.getParameter("motivo");
            String observaciones = request.getParameter("observaciones");
            String estadoResolucion = request.getParameter("estado_resolucion");
            
            System.out.println(">> Intentando procesar justificación: " + idIncidencia);

            // 2. Separar el ID del trabajador y la Fecha
            if (idIncidencia != null && idIncidencia.contains("_")) {
                String[] partes = idIncidencia.split("_");
                int idTrabajador = Integer.parseInt(partes[0]);
                Date fechaIncidencia = Date.valueOf(partes[1]);
                
                String tipoIncidencia = "Salida Temprana"; 
                
                // 3. Mandar a guardar a la Base de Datos
                JustificacionDAO jDAO = new JustificacionDAO();
               // En tu Servlet, la llamada queda así:
boolean guardado = jDAO.registrarJustificacion(idTrabajador, fechaIncidencia, tipoIncidencia, motivo, observaciones, estadoResolucion);
                
                if (guardado) {
                    System.out.println(">> Justificación guardada con éxito en BD.");
                } else {
                    System.out.println(">> ERROR: No se afectaron filas en la BD.");
                }
            } else {
                System.out.println(">> ERROR: El id_incidencia llegó vacío o con formato incorrecto.");
            }
            
        } catch (SQLException e) {
            System.out.println(">> ERROR SQL AL GUARDAR JUSTIFICACIÓN: " + e.getMessage());
            e.printStackTrace();
        } catch (Exception e) {
            System.out.println(">> ERROR GENERAL AL GUARDAR JUSTIFICACIÓN: " + e.getMessage());
            e.printStackTrace();
        }
        
        // 4. Redirigir de vuelta a la bandeja
        response.sendRedirect("GestionJustificaciones");
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
