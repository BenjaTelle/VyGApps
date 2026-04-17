/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controlador;

import Repository.MaquinasDAO;
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
@WebServlet(name = "GenerarPagoMaquinaria", urlPatterns = {"/GenerarPagoMaquinaria"})
public class GenerarPagoMaquinaria extends HttpServlet {

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
        response.sendRedirect("GenerarPagoMaquinaria.jsp");
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

        // 2. Capturar parámetros
        String fechaInicio = request.getParameter("fecha_inicio");
        String fechaFin = request.getParameter("fecha_fin");
        int idAdmin = user.getId_user();

        // 3. Ejecutar Lógica
        try {
            MaquinasDAO dao = new MaquinasDAO();
            boolean exito = dao.liquidarUsoMaquinaria(fechaInicio, fechaFin, idAdmin);
            
            if (exito) {
                // Redirigimos al dashboard maestro. Mismo truco de mandar el mensaje por URL.
                response.sendRedirect("AdminFinanzas?msg=maquinaria_generada");
            } else {
                request.setAttribute("error", "No se encontraron registros de maquinaria pendientes en esas fechas o el costo es cero.");
                request.getRequestDispatcher("GenerarPagoMaquinaria.jsp").forward(request, response);
            }
            
        } catch (SQLException e) {
            System.out.println("Error SQL en Liquidación: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "Ocurrió un error al procesar la liquidación en la base de datos.");
            request.getRequestDispatcher("GenerarPagoMaquinaria.jsp").forward(request, response);
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
