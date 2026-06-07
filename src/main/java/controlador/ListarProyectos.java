/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controlador;

import DTO.FichaTecnicaDTO;
import Repository.ProyectoDAO;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 *
 * @author Benja
 */
@WebServlet(name = "ListarProyectos", urlPatterns = {"/ListarProyectos"})
public class ListarProyectos extends HttpServlet {

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
        response.setContentType("text/html;charset=UTF-8");
    
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
            ProyectoDAO pDAO = new ProyectoDAO();
            request.setAttribute("ListaP", pDAO.VerProyectosActivos());
        } catch(SQLException e) {
            System.out.println("Error al obtener listado de proyectos: " + e.getMessage());
            e.printStackTrace();
        }
        
        String idProyectoSTR = request.getParameter("id_proyecto");
        
        // Vista Detalle: Si el usuario solicitó la ficha técnica de un proyecto
        if(idProyectoSTR != null) {
            int idProyecto = Integer.parseInt(idProyectoSTR);
            FichaTecnicaDTO ficha = new FichaTecnicaDTO();
            
            try {
                request.setAttribute("ficha", ficha.traerFicha(idProyecto));
            } catch (SQLException ex) {
                System.out.println("Error al generar la ficha técnica: " + ex.getMessage());
                ex.printStackTrace();
            }
            
            request.getRequestDispatcher("FichaTecnicaProyecto.jsp").forward(request, response);
            return; // Freno de mano para no cargar la lista general
        }
       
        // Vista General: Si no hay ID, cargar la lista de proyectos
        request.getRequestDispatcher("ListarProyectos.jsp").forward(request, response);
         
        
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
