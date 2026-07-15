/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controlador;

import DTO.CicloPlanillaDTO;
import Repository.NominaDAO;
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
        HttpSession sessionActual = request.getSession(false);
        Usuarios user = (sessionActual != null) ? (Usuarios) sessionActual.getAttribute("usuarioLogeado") : null;
        
        if (user == null || !user.getRol().equalsIgnoreCase("Administrador")) {
            response.sendRedirect("login.jsp");
            return;
        }

        NominaDAO dao = new NominaDAO();
        
        // 1. Cargar estado de los ciclos (Tarjetas)
        List<CicloPlanillaDTO> ciclos = dao.obtenerEstadoCiclos();
        for (CicloPlanillaDTO ciclo : ciclos) {
            if (ciclo.getTipoNomina().equals("Administrativa")) {
                request.setAttribute("cicloAdmin", ciclo);
            } else if (ciclo.getTipoNomina().equals("Operativa")) {
                request.setAttribute("cicloOperativo", ciclo);
            }
        }

        // 2. Cargar el Historial de Pagos
        List<DTO.PagoNominaDTO> historialAdmin = dao.obtenerHistorialPagos("Administrativa");
        List<DTO.PagoNominaDTO> historialOperativo = dao.obtenerHistorialPagos("Operativa");
        
        request.setAttribute("historialAdmin", historialAdmin);
        request.setAttribute("historialOperativo", historialOperativo);

        request.getRequestDispatcher("GenerarPlanilla.jsp").forward(request, response);
    
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
    HttpSession sessionActual = request.getSession(false);
        Usuarios user = (sessionActual != null) ? (Usuarios) sessionActual.getAttribute("usuarioLogeado") : null;
        
        if (user == null || !user.getRol().equalsIgnoreCase("Administrador")) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        int idAdmin = user.getId_user();

        String tipoNomina = request.getParameter("tipo_nomina");
        String ultimaEjecucionStr = request.getParameter("ultima_ejecucion");
        String fechaProximoPagoStr = request.getParameter("proximo_pago");    
        String diasCicloStr = request.getParameter("dias_ciclo");             

        try {
            if (tipoNomina != null && fechaProximoPagoStr != null && ultimaEjecucionStr != null && diasCicloStr != null) {
                
                int diasCiclo = Integer.parseInt(diasCicloStr);
                NominaDAO dao = new NominaDAO();
                
                boolean exito = dao.generarPlanillaAutomatizada(tipoNomina, diasCiclo, ultimaEjecucionStr, fechaProximoPagoStr, idAdmin);
                if (exito) {
                    sessionActual.setAttribute("mensajePlanilla", "exito");
                } else {
                    sessionActual.setAttribute("mensajePlanilla", "duplicado_o_error");
                }
            }
        } catch (Exception e) {
            System.out.println(">> ERROR en Servlet GenerarPlanilla: " + e.getMessage());
            e.printStackTrace();
            sessionActual.setAttribute("mensajePlanilla", "duplicado_o_error");
        }
        
        response.sendRedirect("GenerarPlanilla");
    
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
