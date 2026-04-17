/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controlador;

import Repository.NominaDAO;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.SQLException;
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
@WebServlet(name = "GenerarPlanilla", urlPatterns = {"/GenerarPlanilla"})
public class GenerarPlanilla extends HttpServlet {

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
        response.sendRedirect("GenerarPlanilla.jsp");
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
        
        // 1. Verificación de Seguridad
        HttpSession session = request.getSession(false);
        Usuarios user = (session != null) ? (Usuarios) session.getAttribute("usuarioLogeado") : null;
        
        if (user == null || !user.getRol().equalsIgnoreCase("Administrador")) {
            response.sendRedirect("login.jsp");
            return;
        }

        // 2. Capturar los datos del formulario (GenerarPlanilla.jsp)
        String fechaInicio = request.getParameter("fecha_inicio");
        String fechaFin = request.getParameter("fecha_fin");
        
        // Obtenemos el ID del administrador que está logueado para que quede en la auditoría
        int idAdmin = user.getId_user(); 

        // 3. Ejecutar la lógica de Base de Datos
        try {
            NominaDAO dao = new NominaDAO();
            boolean exito = dao.generarPlanillaMasiva(fechaInicio, fechaFin, idAdmin);
            
            if (exito) {
                // Si todo salió bien, lo mandamos de vuelta al Dashboard principal
                // Le pasamos un parámetro en la URL para poder mostrarle un mensaje de éxito si queremos
                response.sendRedirect("AdminFinanzas?msg=nomina_generada");
            } else {
                // Si no se insertó nada (ej. no hay trabajadores o no hay asistencias)
                request.setAttribute("error", "No se encontraron trabajadores con asistencias en este periodo.");
                request.getRequestDispatcher("GenerarPlanilla.jsp").forward(request, response);
            }
            
        } catch (SQLException e) {
            System.out.println("Error al generar la planilla: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "Error interno de la base de datos.");
            request.getRequestDispatcher("GenerarPlanilla.jsp").forward(request, response);
        }
    
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
