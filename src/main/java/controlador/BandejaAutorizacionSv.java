/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controlador;

import DTO.PlanillaPendienteDTO;
import Repository.AutorizacionDAO;
import java.io.IOException;
import java.io.PrintWriter;
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
@WebServlet(name = "BandejaAutorizacionSv", urlPatterns = {"/BandejaAutorizacionSv"})
public class BandejaAutorizacionSv extends HttpServlet {

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
      // 1. Seguridad en el Backend
        HttpSession session = request.getSession(false);
        Usuarios user = (session != null) ? (Usuarios) session.getAttribute("usuarioLogeado") : null;
        
        if (user == null || (!user.getRol().equalsIgnoreCase("Supervisor") && !user.getRol().equalsIgnoreCase("Administrador"))) { 
            response.sendRedirect("login.jsp"); 
            return; 
        }

        try {
            AutorizacionDAO dao = new AutorizacionDAO();
            
            // 2. Traer lista de nóminas (Humanos)
            List<PlanillaPendienteDTO> listaNominas = dao.listarPendientes();
            request.setAttribute("ListaPlanillas", listaNominas);
            
            // 3. Traer lista de maquinarias y fletes (¡NUEVO!)
            List<PlanillaPendienteDTO> listaMaquinarias = dao.listarMaquinariaPendiente();
            request.setAttribute("ListaMaquinarias", listaMaquinarias);
            
            // 4. Enviar todo al JSP
            request.getRequestDispatcher("BandejaAutorizacion.jsp").forward(request, response);
            
        } catch (Exception e) {
            System.out.println("Error al cargar la bandeja de autorizaciones: " + e.getMessage());
            e.printStackTrace();
            // Si hay error, podrías redirigir con un mensaje
            response.sendRedirect("BandejaAutorizacion.jsp?msg=error");
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
