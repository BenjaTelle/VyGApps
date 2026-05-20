/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controlador;

import Repository.ProyectoDAO;
import Repository.TrabajadoresDAO;
import Repository.UsuarioDAO;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.SQLException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import model.proyectos;
import model.trabajadores;

/**
 *
 * @author Benja
 */
@WebServlet(name = "RegistrarUsu", urlPatterns = {"/RegistrarUsu"})
public class RegistrarUsu extends HttpServlet {

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
        
        processRequest(request, response);
        try {
            TrabajadoresDAO trabajadorDAO = new TrabajadoresDAO();
            ProyectoDAO proyectoDAO = new ProyectoDAO();
            List<proyectos> lista = proyectoDAO.ListarProyectos();
            
            if (lista != null) {
                request.setAttribute("ListaSuperv", trabajadorDAO.ListarTrabajadoresSuperv());
                request.setAttribute("ListarProy", proyectoDAO.ListarProyectos());
            }
            else{
                System.out.println("lista proyectos vacio");
            }
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Error al cargar datos");
        }

        request.getRequestDispatcher("RegisTrabajador.jsp").forward(request, response);

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

          // 1. Capturar los parámetros originales
        String cedula = request.getParameter("cedula");
        String full_name = request.getParameter("full_name");
        int edad = Integer.parseInt(request.getParameter("edad"));
        String puesto = request.getParameter("puesto");
        double salario_quincenal = Double.parseDouble(request.getParameter("salario_quincenal"));
        String origen = request.getParameter("origen");

        String supervisorStr = request.getParameter("supervisor");
        String proyectoStr = request.getParameter("proyecto");

        // 2. Capturar los NUEVOS parámetros del HTML
        String telefono = request.getParameter("telefono");
        String numero_emergencia = request.getParameter("numero_emergencia");
        String direccion = request.getParameter("direccion");

        Integer id_supervisor = null;
        Integer id_proyecto = null;

        if (supervisorStr != null && !supervisorStr.isEmpty()) {
            id_supervisor = Integer.parseInt(supervisorStr);
        }

        if (proyectoStr != null && !proyectoStr.isEmpty()) {
            id_proyecto = Integer.parseInt(proyectoStr);
        }

        // 3. Guardamos la información en el objeto (usando tu constructor actual)
        trabajadores trabajador = new trabajadores(cedula, full_name, edad, puesto, salario_quincenal, origen, id_supervisor, id_proyecto);
        
        // 4. Inyectamos los nuevos datos usando los Setters
        trabajador.setTelefono(telefono);
        trabajador.setNumero_emergencia(numero_emergencia);
        trabajador.setDireccion(direccion);

        // 5. Mandamos a llamar el método que nos permite registrar el trabajador
        TrabajadoresDAO trabajadorDAO = new TrabajadoresDAO();
        trabajadorDAO.registrarTrabajador(trabajador);
        
        // 6. Redirigimos
        response.sendRedirect("AdminPage.jsp");
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
