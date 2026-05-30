/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controlador;

import DTO.ResumenGastoDTO;
import Repository.ProyectoDAO;
import Repository.ResumenDiarioDAO;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.SQLException;
import java.time.LocalDate;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import model.Usuarios;
import model.proyectos;

/**
 *
 * @author Benja
 */
@WebServlet(name = "ResumenDiarioSv", urlPatterns = {"/ResumenDiarioSv"})
public class ResumenDiarioSv extends HttpServlet {

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
    HttpSession session = request.getSession(false);
        Usuarios user = (session != null) ? (Usuarios) session.getAttribute("usuarioLogeado") : null;
        
        if (user == null || !user.getRol().equalsIgnoreCase("Administrador")) {
            response.sendRedirect("login.jsp");
            return;
        }

        String fechaFiltro = request.getParameter("fechaFiltro");
        String tipoFiltro = request.getParameter("tipoFiltro");
        String idProyectoStr = request.getParameter("idProyecto");

        /* Lógica para asignar la fecha actual automáticamente */
        if (fechaFiltro == null || fechaFiltro.trim().isEmpty()) {
            fechaFiltro = LocalDate.now().toString(); 
        }

        if (tipoFiltro == null || tipoFiltro.trim().isEmpty()) {
            tipoFiltro = "Todos";
        }

        int idProyecto = 0;
        if (idProyectoStr != null && !idProyectoStr.trim().isEmpty()) {
            try {
                idProyecto = Integer.parseInt(idProyectoStr);
            } catch (NumberFormatException e) {
                idProyecto = 0;
            }
        }

        try {
            ResumenDiarioDAO resumenDAO = new ResumenDiarioDAO();
            ProyectoDAO proyectoDAO = new ProyectoDAO();

            List<ResumenGastoDTO> listaGastos = resumenDAO.obtenerResumenDiario(fechaFiltro, idProyecto, tipoFiltro);
            List<proyectos> listaProyectos = proyectoDAO.ListarProyectos();

            request.setAttribute("ListaGastos", listaGastos);
            request.setAttribute("ListaProyectos", listaProyectos);
            
            /* Retornamos los filtros a la vista para mantener el estado */
            request.setAttribute("fechaFiltro", fechaFiltro); 
            request.setAttribute("tipoFiltro", tipoFiltro);
            request.setAttribute("idProyecto", idProyecto);

        } catch (Exception e) {
            System.out.println("Error en ResumenDiarioSv: " + e.getMessage());
        }

        request.getRequestDispatcher("ResumenDiario.jsp").forward(request, response);
    
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
