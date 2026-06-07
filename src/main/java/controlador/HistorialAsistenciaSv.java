/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controlador;

import DTO.AsistenciaDTO;
import Repository.AsistenciaDAO;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.SQLException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import model.Usuarios;

/**
 *
 * @author Benja
 */
@WebServlet(name = "HistorialAsistenciaSv", urlPatterns = {"/HistorialAsistenciaSv"})
public class HistorialAsistenciaSv extends HttpServlet {

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
        // 1. Validar sesión estrictamente para el rol de Trabajador
        HttpSession sessionActual = request.getSession(false);
        Usuarios user = (sessionActual != null) ? (Usuarios) sessionActual.getAttribute("usuarioLogeado") : null;
        
        if (user == null || !user.getRol().equalsIgnoreCase("Trabajador")) {
            response.sendRedirect("login.jsp");
            return;
        }

        // 2. Extraer el historial de la Base de Datos usando el DTO actualizado
        AsistenciaDAO asistenciaDAO = new AsistenciaDAO();
        try {
            int idTrabajador = user.getId_trabajador();
            
            // Llamamos al método que ahora devuelve List<AsistenciaDTO> con horas extras y anomalías
            List<AsistenciaDTO> listaHistorial = asistenciaDAO.ListarAsistenciaTrabajador(idTrabajador);
            
            // 3. Enviar los datos al JSP
            request.setAttribute("ListaAsistencia", listaHistorial);
            
        } catch (SQLException ex) {
            System.out.println("Error al cargar historial de asistencia del trabajador: " + ex.getMessage());
            ex.printStackTrace();
            request.setAttribute("error", "No se pudo cargar el historial debido a un error en el servidor.");
        }

        // 4. Redirigir a la vista
        request.getRequestDispatcher("HistorialAsistencia.jsp").forward(request, response);
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
        
        response.sendRedirect("Home.jsp");
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
