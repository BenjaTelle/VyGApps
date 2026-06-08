/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controlador;

import Repository.AutorizacionDAO;
import java.io.IOException;
import java.io.PrintWriter;
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
@WebServlet(name = "AutorizarPagoSv", urlPatterns = {"/AutorizarPagoSv"})
public class AutorizarPagoSv extends HttpServlet {

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
        if (user == null) { response.sendRedirect("login.jsp"); return; }

        try {
            // 1. Capturamos todos los parámetros de la URL
            int idPago = Integer.parseInt(request.getParameter("id_pago"));
            int idProyecto = Integer.parseInt(request.getParameter("id_proyecto"));
            double monto = Double.parseDouble(request.getParameter("monto"));
            String tipo = request.getParameter("tipo"); // Determina si el pago corresponde a nómina o maquinaria
            int idUsuario = user.getId_user();

            AutorizacionDAO dao = new AutorizacionDAO();
            String resultado = "";

            // Delegar autorización al DAO correspondiente según el tipo de gasto
            if (tipo != null && tipo.equals("maquinaria")) {
                // Autoriza el pago de maquinaria descontando del presupuesto
                resultado = dao.autorizarPagoMaquinaria(idPago, idProyecto, monto, idUsuario);
            } else {
                // Autoriza el pago de nómina estándar descontando del presupuesto
                resultado = dao.autorizarPago(idPago, idProyecto, monto, idUsuario);
            }

            // Redirigir a bandeja principal con estado de la operación
            response.sendRedirect("BandejaAutorizacionSv?msg=" + resultado);
            
        } catch (Exception e) {
            System.out.println("Error al procesar la autorización: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect("BandejaAutorizacionSv?msg=error");
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
