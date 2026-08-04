/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controlador;

import DTO.PagoDTO;
import DTO.UsuarioDetalle;
import Repository.*;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.SQLException;
import java.sql.Time;
import java.util.ArrayList;
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
import model.trabajadores;

/**
 *
 * @author Benja
 */
@WebServlet(name = "Home", urlPatterns = {"/Home"})
public class Home extends HttpServlet {

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

       // 1. Obtener la sesión
        HttpSession sessionActual = request.getSession(false);
        Usuarios user = (sessionActual != null) ? (Usuarios) sessionActual.getAttribute("usuarioLogeado") : null;
        
        // 2. Seguridad en el Servlet (Evita el NullPointerException si la sesión caducó)
        if (user == null || !user.getRol().equalsIgnoreCase("Trabajador")) {
            response.sendRedirect("login.jsp");
            return;
        }

        int idT = (user.getId_trabajador() != null) ? user.getId_trabajador() : 0;

        try {
            // 3. Buscar Detalles del Usuario (Lo que ya tenías)
            UsuarioDetalleDAO udDAO = new UsuarioDetalleDAO();
            request.setAttribute("usuarioLogueadoDetalle", udDAO.BuscarUsuDetalle(idT));

            // 4. Buscar Últimos Pagos (NUEVO)
            PagosDAO pagosDAO = new PagosDAO();
            List<PagoDTO> listaPagos = pagosDAO.listarNominasPorTrabajador(idT);
            
            // 5. Enviar la lista a la vista
            request.setAttribute("ListaPagos", listaPagos);

        } catch (SQLException e) {
            System.out.println("Error SQL en el Home (Servlet): " + e.getMessage());
            e.printStackTrace();
            // Si la BD falla, enviamos una lista vacía para que no se caiga la página
            request.setAttribute("ListaPagos", new ArrayList<PagoDTO>());
        }

        // 6. Cabeceras Anti-Caché (Para evitar la tabla vacía o el error 304)
        response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate"); // HTTP 1.1
        response.setHeader("Pragma", "no-cache"); // HTTP 1.0
        response.setDateHeader("Expires", 0); // Proxies

        // 7. Despachar a la vista
        request.getRequestDispatcher("Home.jsp").forward(request, response);
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
