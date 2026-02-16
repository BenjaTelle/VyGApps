/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controlador;

import Repository.ProyectoDAO;
import Repository.SupervisorDAO;
import Repository.TrabajadoresDAO;
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
@WebServlet(name = "AsignSup", urlPatterns = {"/AsignSup"})
public class AsignSup extends HttpServlet {

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
            TrabajadoresDAO tDAO = new TrabajadoresDAO();
            ProyectoDAO pDAO = new ProyectoDAO();
            request.setAttribute("ListaT", tDAO.ListarTrabajadoresSinSuperv());
            request.setAttribute("ListaP", pDAO.ListarProyectos());
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        request.getRequestDispatcher("AsignSup.jsp")
                .forward(request, response);
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
        
        int id_trabajador = Integer.parseInt(request.getParameter("id_trabajador"));
        int id_proyecto = Integer.parseInt(request.getParameter("id_proyecto"));
        
        SupervisorDAO supDAO = new SupervisorDAO();
        
        try {
            int filas = supDAO.AsignarSupervisor(id_proyecto, id_trabajador);
            
            if (filas > 0) {
                System.out.println("inserto los datos ");
            } else {
                
                System.out.println("no inserto  datos ");
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        response.sendRedirect("AdminPage.jsp");
        
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
