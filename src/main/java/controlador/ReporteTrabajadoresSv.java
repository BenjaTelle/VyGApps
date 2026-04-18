/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controlador;

import DTO.ReporteTrabajadorDTO;
import Repository.ProyectoDAO;
import Repository.ReporteTrabajadoresDAO;
import Repository.TrabajadoresDAO;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
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
@WebServlet(name = "ReporteTrabajadoresSv", urlPatterns = {"/ReporteTrabajadoresSv"})
public class ReporteTrabajadoresSv extends HttpServlet {

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
          // 1. Verificación de Seguridad
 
        HttpSession sessionActual = request.getSession(false);
        Usuarios user = (sessionActual != null) ? (Usuarios) sessionActual.getAttribute("usuarioLogeado") : null;
        
        if (user == null || !user.getRol().equalsIgnoreCase("Administrador")) {
            response.sendRedirect("login.jsp");
            return;
        }

        // 2. Recibir los parámetros del filtro
        String idProyectoStr = request.getParameter("id_proyecto");
        String estado = request.getParameter("estado");

        // 3. Procesar parámetros (Si es la primera vez que entran, vienen nulos)
        int idProyecto = 0;
        if (idProyectoStr != null && !idProyectoStr.isEmpty()) {
            try {
                idProyecto = Integer.parseInt(idProyectoStr);
            } catch (NumberFormatException e) {
                idProyecto = 0; // Si alguien altera la URL, por defecto buscamos todos
            }
        }

        if (estado == null || estado.isEmpty()) {
            estado = "Todos";
        }

        // 4. Instanciar el DAO y las listas
        ReporteTrabajadoresDAO dao = new ReporteTrabajadoresDAO();
        List<proyectos> listaProyectos = new ArrayList<>();
        List<ReporteTrabajadorDTO> listaTrabajadores = new ArrayList<>();

        try {
            // 5. Consumir los métodos del DAO que armamos a tu estilo
            listaProyectos = dao.obtenerProyectosActivos();
            listaTrabajadores = dao.reporteDinamicoTrabajadores(idProyecto, estado);
            
        } catch (SQLException e) {
            System.out.println("Error de Base de Datos en el Servlet: " + e.getMessage());
            e.printStackTrace();
        }

        // 6. Enviar los atributos a la vista (Mayúsculas exactas para el JSP)
        request.setAttribute("ListaProyectos", listaProyectos);
        request.setAttribute("ListaTrabajadores", listaTrabajadores);

        // 7. Cabeceras anti-caché para evitar el error "304 Not Modified" y la pantalla en blanco
        response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
        response.setHeader("Pragma", "no-cache");
        response.setDateHeader("Expires", 0);

        // 8. Despachar a la vista
        request.getRequestDispatcher("ReporteTrabajadores.jsp").forward(request, response);
    
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
