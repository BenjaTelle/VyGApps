/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controlador;

import Repository.AsistenciaDAO;
import Repository.ProyectoDAO;
import java.io.IOException;
import java.io.PrintWriter;
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
@WebServlet(name = "AsistenciaGlobal", urlPatterns = {"/AsistenciaGlobal"})
public class AsistenciaGlobal extends HttpServlet {

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
        
         try {
            // 1. Capturar los filtros enviados desde la vista (pueden ser null si es la primera vez que entra)
            String fechaFiltro = request.getParameter("fecha");
            String idProyectoFiltro = request.getParameter("id_proyecto");

            // 2. Instanciar repositorios
            AsistenciaDAO aDAO = new AsistenciaDAO();
            ProyectoDAO pDAO = new ProyectoDAO();

            // 3. Obtener la lista de proyectos activos para llenar el combo box (Select)
            request.setAttribute("ListaProyectos", pDAO.VerProyectosActivos());

            // 4. Obtener la lista de asistencias aplicando los filtros dinámicos
            request.setAttribute("ListaAsistenciaGlobal", aDAO.ListarAsistenciaGlobalFiltrada(fechaFiltro, idProyectoFiltro));
            
        } catch(SQLException e) {
            System.out.println("Error al cargar la asistencia global: " + e.getMessage());
            e.printStackTrace();
        }
        
        // 5. Redirigir a la vista
        request.getRequestDispatcher("AsistenciaGlobal.jsp").forward(request, response);
    
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
