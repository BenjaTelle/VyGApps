/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controlador;

import Repository.CodigosDAO;
import Repository.ProyectoDAO;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.SQLException;
import java.util.List;
import java.util.Random;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import model.Usuarios;
import model.proyectos;

/**
 *
 * @author Benja
 */
@WebServlet(name = "GenerarCodigoSv", urlPatterns = {"/GenerarCodigoSv"})
public class GenerarCodigoSv extends HttpServlet {

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
   // A. Seguridad: Solo Supervisores
        HttpSession session = request.getSession(false);
        Usuarios user = (session != null) ? (Usuarios) session.getAttribute("usuarioLogeado") : null;
        
        if (user == null || !user.getRol().equalsIgnoreCase("Supervisor")) {
            response.sendRedirect("login.jsp");
            return;
        }

        // B. Cargar la lista de proyectos para el <select> del formulario
        try {
            ProyectoDAO pdao = new ProyectoDAO();
            List<proyectos> listaProyectos = pdao.ListarProyectos();
            request.setAttribute("ListaProyectos", listaProyectos);
        } catch (SQLException e) {
            e.printStackTrace();
        }

        // C. Evitar Caché y mandar a la vista
        response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
        response.setHeader("Pragma", "no-cache");
        response.setDateHeader("Expires", 0);
        
        request.getRequestDispatcher("GenerarCodigo.jsp").forward(request, response);
        
        
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
              
        // A. Seguridad
        HttpSession session = request.getSession(false);
        Usuarios user = (session != null) ? (Usuarios) session.getAttribute("usuarioLogeado") : null;
        
        if (user == null || !user.getRol().equalsIgnoreCase("Supervisor")) {
            response.sendRedirect("login.jsp");
            return;
        }

        int idSupervisor = user.getId_trabajador();
        
        // B. Recibir parámetros del formulario
        int idProyecto = Integer.parseInt(request.getParameter("id_proyecto"));
        int minutosValidez = Integer.parseInt(request.getParameter("tiempo_validez"));
        CodigosDAO codigosDAO = new CodigosDAO();
        // C. Generar el código aleatorio (Formato: VYG-XXXXXX)
        String codigoGenerado = codigosDAO.generarCadenaAleatoria();

        // D. Guardar en la Base de Datos usando el DAO
        try {
            
            // Este método guardará el código y le sumará los minutos de validez a la hora actual
            boolean exito = codigosDAO.crearCodigoAsistencia(codigoGenerado, idSupervisor, idProyecto, minutosValidez);
            
            if (exito) {
                // Enviamos el código recién generado a la vista para que el supervisor lo vea en grande
                request.setAttribute("CodigoExito", codigoGenerado);
                request.setAttribute("Minutos", minutosValidez);
            } else {
                request.setAttribute("ErrorGeneracion", "Hubo un problema al generar el código en la base de datos.");
            }
            
       ProyectoDAO pDAO = new ProyectoDAO();
                        request.setAttribute("ListaProyectos", pDAO.ListarProyectos());
            
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("ErrorGeneracion", "Error de conexión: " + e.getMessage());
        }

        // E. Volver a la misma página mostrando el resultado
        request.getRequestDispatcher("GenerarCodigo.jsp").forward(request, response);
        
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
