/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controlador;

import DTO.ReporteAsistenciaDTO;
import Repository.AsistenciaDAO;
import Repository.ProyectoDAO;
import Repository.ReporteTrabajadoresDAO;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;
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
@WebServlet(name = "ReporteAsistenciaSv", urlPatterns = {"/ReporteAsistenciaSv"})
public class ReporteAsistenciaSv extends HttpServlet {

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
      
        String fechaInicio = request.getParameter("fechaInicio");
        String fechaFin = request.getParameter("fechaFin");
        String idProyectoStr = request.getParameter("id_proyecto");
        String estado = request.getParameter("estado");
        
        try {
            ProyectoDAO pDao = new ProyectoDAO();
            List<proyectos> listaProyectos = pDao.ListarProyectos();
             request.setAttribute("ListaProyectos", listaProyectos);

            if (fechaInicio != null && fechaFin != null) {
                int idProyecto = (idProyectoStr != null) ? Integer.parseInt(idProyectoStr) : 0;
                
                ReporteTrabajadoresDAO asisDao = new ReporteTrabajadoresDAO();
                List<ReporteAsistenciaDTO> lista = asisDao.filtrarAsistencia(fechaInicio, fechaFin, idProyecto, estado);
                
                request.setAttribute("ListaAsistencia", lista);
            }
            
            request.getRequestDispatcher("ReporteAsistencia.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            
            
            response.sendRedirect("AdminPage.jsp"); // O tu página de error
        }
        
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
