/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controlador;

import Repository.ProyectoDAO;
import Repository.TrabajadoresDAO;
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
import model.trabajadores;

/**
 *
 * @author Benja
 */
@WebServlet(name = "ActualizarTrabajadores", urlPatterns = {"/ActualizarTrabajadores"})
public class ActualizarTrabajadores extends HttpServlet {

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
        try {
            TrabajadoresDAO tDAO = new TrabajadoresDAO();
            request.setAttribute("ListaTrabajadores", tDAO.ListarTrabajadoresSinSuperv());
            request.setAttribute("ListaSuperv", tDAO.ListarTrabajadoresSuperv());
            ProyectoDAO pDAO = new ProyectoDAO();
            request.setAttribute("ListarProyectos", pDAO.ListarProyectos());

        } catch (SQLException e) {

            e.printStackTrace();
        }

        request.getRequestDispatcher("ActualizarTrabajador.jsp").forward(request, response);
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
      // request.setCharacterEncoding("UTF-8"); // Opcional: útil si tienes problemas con acentos en la dirección o nombre

        int id_trabajador = Integer.parseInt(request.getParameter("id_trabajador"));
        
        System.out.println("Trabajador seleccionado para actualizar: " + id_trabajador);
        
        // 1. Capturamos los datos originales
        String NuevaCedula = request.getParameter("cedula");
        String NuevaNombre = request.getParameter("full_name");
        int NuevaEdad = Integer.parseInt(request.getParameter("edad"));
        String NuevoPuesto = request.getParameter("puesto");
        double NuevoSueldo = Double.parseDouble(request.getParameter("salario_quincenal"));
        String NuevoOrigen = request.getParameter("origen");
        int id_supervisor = Integer.parseInt(request.getParameter("id_supervisor"));
        int id_NuevoProyecto = Integer.parseInt(request.getParameter("proyecto"));
        
        // 2. Capturamos los NUEVOS campos del formulario HTML
        String telefono = request.getParameter("telefono");
        String numero_emergencia = request.getParameter("numero_emergencia");
        String direccion = request.getParameter("direccion");
        
        // 3. Creamos la instancia del trabajador y le pasamos los datos
        trabajadores t = new trabajadores(); 
        
        t.setId_trabajador(id_trabajador);
        t.setCedula(NuevaCedula);
        t.setFull_name(NuevaNombre);
        t.setEdad(NuevaEdad);
        t.setPuesto(NuevoPuesto);
        t.setSalario_quincenal(NuevoSueldo);
        t.setOrigen(NuevoOrigen);
        t.setId_proyect(id_NuevoProyecto);
        t.setId_supervisor(id_supervisor);
        
        // 4. Inyectamos los nuevos datos al objeto
        t.setTelefono(telefono);
        t.setNumero_emergencia(numero_emergencia);
        t.setDireccion(direccion);
        
        // 5. Mandamos al DAO para ejecutar el UPDATE en MySQL
        TrabajadoresDAO tDAO = new TrabajadoresDAO();
        try {
            tDAO.ActualizarTrabajador(t); 
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        
        // 6. Redirigimos al panel de control
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
