/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controlador;

import Repository.ProyectoDAO;
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
import model.proyectos;

/**
 *
 * @author Benja
 */
@WebServlet(name = "VerDetalleProyecto", urlPatterns = {"/VerDetalleProyecto"})
public class VerDetalleProyecto extends HttpServlet {

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
        ProyectoDAO pDAO = new ProyectoDAO();

        try {

            // 1. SIEMPRE cargamos la lista de proyectos para que el <select> no quede vacío
            // (Asegúrate de que el nombre "ListaProyectos" coincida con tu JSP)
            request.setAttribute("ListaProyectos", pDAO.ListarProyectos());

            // 2. Capturamos el ID de la URL como texto primero para ver si existe
            String idParam = request.getParameter("id_proyecto");

            // 3. Solo buscamos el detalle SI el supervisor presionó el botón y mandó un ID
            if (idParam != null && !idParam.isEmpty()) {

                int idSeleccionado = Integer.parseInt(idParam);

                proyectos p = pDAO.BuscarPorID(idSeleccionado);

                // Guardamos el proyecto específico para que el JSP dibuje la tarjeta inferior
                request.setAttribute("proyectoSeleccionado", p);

            }

            // 4. AHORA SÍ, al final de todo, despachamos el viaje hacia el JSP
            request.getRequestDispatcher("VerDetalleProyecto.jsp").forward(request, response);

        } catch (SQLException ex) {

            ex.printStackTrace();

            // Podrías redirigir a una página de error si falla la BD
        } catch (NumberFormatException ex) {

            // Por si alguien manipula la URL y pone letras en vez de números
            ex.printStackTrace();

            request.getRequestDispatcher("VerDetalleProyecto.jsp").forward(request, response);

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
