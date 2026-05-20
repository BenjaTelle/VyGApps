/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controlador;

import Repository.GastosDAO;
import Repository.ProyectoDAO;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Date;
import java.sql.SQLException;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import model.GastosProyecto;
import model.proyectos;

/**
 *
 * @author Benja
 */
@WebServlet(name = "RegistrarGastoSv", urlPatterns = {"/RegistrarGastoSv"})
public class RegistrarGastoSv extends HttpServlet {

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
        

       
        try {
           ProyectoDAO proyDao = new ProyectoDAO();
            request.setAttribute("ListaProyectos", proyDao.ListarProyectos());
           
        } catch (SQLException ex) {
            ex.printStackTrace();
        }

        request.getRequestDispatcher("RegistrarGasto.jsp").forward(request, response);
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

        try {
            int idProyecto = Integer.parseInt(request.getParameter("id_proyecto"));
            int idUserRegistra = Integer.parseInt(request.getParameter("id_user_registra"));
            String concepto = request.getParameter("concepto");
            String descripcion = request.getParameter("descripcion");
            double monto = Double.parseDouble(request.getParameter("monto"));
            Date fechaGasto = Date.valueOf(request.getParameter("fecha_gasto"));
            String nroComprobante = request.getParameter("nro_comprobante");
            String categoria = request.getParameter("categoria");

            GastosProyecto nuevoGasto = new GastosProyecto(idProyecto, concepto, descripcion, monto, fechaGasto, nroComprobante, categoria, idUserRegistra);

            // Instanciamos el DAO y registramos el gasto
            GastosDAO gastosDAO = new GastosDAO();
            gastosDAO.registrarGasto(nuevoGasto);

// Como el DAO ahora es void, asumimos que si no saltó al catch, se ejecutó bien
            request.getSession().setAttribute("mensajeGasto", "Gasto registrado correctamente y en espera de autorización.");
            response.sendRedirect("SupervisorPage");

        } catch (Exception e) {
            System.out.println("Error en doPost RegistrarGastoSv: " + e.getMessage());
            request.setAttribute("error", "Error en los datos enviados.");
            doGet(request, response);
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
