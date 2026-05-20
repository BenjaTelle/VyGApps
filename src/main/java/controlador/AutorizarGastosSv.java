/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controlador;

import Repository.GastosDAO;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import model.GastosProyecto;
import model.Usuarios;

/**
 *
 * @author Benja
 */
@WebServlet(name = "AutorizarGastosSv", urlPatterns = {"/AutorizarGastosSv"})
public class AutorizarGastosSv extends HttpServlet {

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
     HttpSession sessionActual = request.getSession(false);
        Usuarios user = (sessionActual != null) ? (Usuarios) sessionActual.getAttribute("usuarioLogeado") : null;
        
        // Verificación doble de seguridad en Backend
        if (user == null || !user.getRol().equalsIgnoreCase("Administrador")) {
            response.sendRedirect("login.jsp");
            return;
        }

        GastosDAO dao = new GastosDAO();

        
        // Seteamos el atributo que lee el JSP en su bucle scriptlet
        request.setAttribute("GastosPendientes", dao.obtenerGastosPendientes());
        request.getRequestDispatcher("AutorizarGastos.jsp").forward(request, response);
        
        
            
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
        
        request.setCharacterEncoding("UTF-8");
        HttpSession sessionActual = request.getSession(false);
        Usuarios user = (sessionActual != null) ? (Usuarios) sessionActual.getAttribute("usuarioLogeado") : null;
        
        if (user == null || !user.getRol().equalsIgnoreCase("Administrador")) {
            response.sendRedirect("login.jsp");
            return;
        }

        try {
            int idGasto = Integer.parseInt(request.getParameter("id_gasto"));
            String accion = request.getParameter("accion"); // Captura el valor del botón pulsado
            String observaciones = request.getParameter("observaciones");
            
            // Evaluamos cuál botón del grupo de acciones fue accionado
            String nuevoEstado = "Pendiente";
            if ("Aprobar".equalsIgnoreCase(accion)) {
                nuevoEstado = "Aprobado";
            } else if ("Rechazar".equalsIgnoreCase(accion)) {
                nuevoEstado = "Rechazado";
            }
            
            GastosDAO dao = new GastosDAO();
            dao.resolverGasto(idGasto, nuevoEstado, user.getId_user(), observaciones);
            
            // Añadimos una variable de sesión flash por si quieres pintar un alert de éxito
            request.getSession().setAttribute("mensajeFinanzas", "El gasto #" + idGasto + " fue " + nuevoEstado.toLowerCase() + " correctamente.");
            
            // Volvemos a cargar el flujo maestro de finanzas
            response.sendRedirect("AdminFinanzas");
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("AdminFinanzas");
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
