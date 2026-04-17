package controlador;

/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

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
import model.proyectos;

/**
 *
 * @author Benja
 */
@WebServlet(urlPatterns = {"/CrearProyecto"})
public class CrearProyecto extends HttpServlet {

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
        
        
          try{
                   TrabajadoresDAO tDAO =  new TrabajadoresDAO();
                   request.setAttribute("ListaSupervisores", tDAO.ListarTrabajadoresSuperv());
                   
                   
              
          }catch(SQLException e)
          {
              e.printStackTrace();
              
          }
        request.getRequestDispatcher("CrearProyecto.jsp").forward(request, response);
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
        
        String NombreProyecto = request.getParameter("nombre_proyecto");
        int idtrabajador = Integer.parseInt(request.getParameter("id_supervisor"));
        double presupuesto_total= Double.parseDouble(request.getParameter("presupuesto_total"));
        String estado = "activo";
       //primero mandamos a crear el proyecto
        ProyectoDAO pDAO = new ProyectoDAO();
        
        try {
              proyectos p = new proyectos();
            p.setEstado(estado);
            p.setNombre_proyecto(NombreProyecto);
            p.setPresupuesto_total(presupuesto_total);
            pDAO.CrearProyecto(p);
          
            
        } catch (SQLException ex) {
           ex.printStackTrace();
        }
        
        //aplicamos el proyecto al trabajador
        
         TrabajadoresDAO tDAO = new TrabajadoresDAO();
        
        try {
            //traemos el id del proyecto que coincida con el nombre que el usuario puso
           int id = pDAO.BuscarPorNombre(NombreProyecto);
            //con ese id y el id del trabajador mandamos a actualizar el campo del supervisor
        tDAO.AsignarProyecto(id, idtrabajador);
        } catch (SQLException ex) {
          ex.printStackTrace();
        }
        
   
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
