/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controlador;

import DTO.PagoDTO;
import Repository.PagosDAO;
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
import javax.servlet.http.HttpSession;
import model.Usuarios;

/**
 *
 * @author Benja
 */
@WebServlet(name = "GenerarReciboPDF", urlPatterns = {"/GenerarReciboPDF"})
public class GenerarReciboPDF extends HttpServlet {

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
        // 1. Validar la sesión (Seguridad)
        HttpSession session = request.getSession(false);
        Usuarios user = (session != null) ? (Usuarios) session.getAttribute("usuarioLogeado") : null;

        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        // 2. Capturar el ID del pago que viene en la URL
        String idPagoParam = request.getParameter("id_pago");
        
        if (idPagoParam != null && !idPagoParam.isEmpty()) {
            try {
                int idPago = Integer.parseInt(idPagoParam);
                
                // 3. Instanciar el DAO y buscar el pago en la BD
                PagosDAO pagoDAO = new PagosDAO(); 
                PagoDTO detallePago = pagoDAO.obtenerDetallePago(idPago);
                
                if (detallePago != null) {
                    // 4. Enviar los datos al JSP
                    request.setAttribute("DetallePago", detallePago);
                    request.getRequestDispatcher("ReciboPago.jsp").forward(request, response);
                } else {
                    // Si por alguna razón el ID no existe en la BD
                    response.getWriter().print("Error: No se encontró el registro de pago.");
                }
                
            } catch (NumberFormatException e) {
                response.getWriter().print("Error: El ID del pago no es válido.");
            } catch (SQLException e) {
                e.printStackTrace();
                response.getWriter().print("Error de base de datos al generar el recibo.");
            } 
        } else {
            response.getWriter().print("Error: Falta el parámetro ID del pago.");
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
