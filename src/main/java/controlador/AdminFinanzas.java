/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controlador;

import DTO.DashboardAdminDTO;
import Repository.DashboardDAO;
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
@WebServlet(name = "AdminFinanzas", urlPatterns = {"/AdminFinanzas"})
public class AdminFinanzas extends HttpServlet {

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
      // ========================================================
        // 1. BARRERA DE SEGURIDAD (Backend)
        // ========================================================
        // Nunca confíes solo en el JSP. Si alguien escribe la URL del Servlet 
        // directamente, lo rebotamos aquí.
        HttpSession session = request.getSession(false);
        Usuarios user = (session != null) ? (Usuarios) session.getAttribute("usuarioLogeado") : null;
        
        if (user == null || !user.getRol().equalsIgnoreCase("Administrador")) {
            // Si no tiene permisos, lo mandamos a volar al login
            response.sendRedirect("login.jsp");
            return;
        }

        // ========================================================
        // 2. CONEXIÓN AL DAO Y EXTRACCIÓN DE DATOS
        // ========================================================
        try {
            DashboardDAO dao = new DashboardDAO();
            
            // Llamamos al método que armamos anteriormente
            DashboardAdminDTO datosDashboard = dao.obtenerDatosDashboardAdmin();
            
            // ========================================================
            // 3. EMPAQUETAR Y ENVIAR A LA VISTA (JSP)
            // ========================================================
            // Metemos el DTO en el "request" con el nombre que espera el JSP
            request.setAttribute("DashboardData", datosDashboard);
            
            // Hacemos el reenvío interno (Forward) al JSP para que se dibuje
            request.getRequestDispatcher("AdminFinanzas.jsp").forward(request, response);
            
        } catch (SQLException e) {
            // Si la base de datos explota, lo registramos en la consola
            System.out.println("Error SQL en AdminFinanzasServlet: " + e.getMessage());
            e.printStackTrace();
            
            // Podrías enviar un mensaje de error genérico al JSP si quieres
            request.setAttribute("error", "Error de conexión con la base de datos al cargar métricas.");
            request.getRequestDispatcher("AdminFinanzas.jsp").forward(request, response);
        }    }

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
