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
import java.sql.Time;
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
              //cargamos la informacion para  el select
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
        // 1. Recepción de parámetros básicos
        String nombreProyecto = request.getParameter("nombre_proyecto");
        int idTrabajador = Integer.parseInt(request.getParameter("id_supervisor"));
        double presupuestoTotal = Double.parseDouble(request.getParameter("presupuesto_total"));
        String estado = "activo";
        
        // 2. Recepción de nuevas reglas operativas
        String horaEntradaStr = request.getParameter("hora_entrada_oficial");
        String horaSalidaStr = request.getParameter("hora_salida_oficial");
        String tarifaStr = request.getParameter("tarifa_hora_extra");

        // Convertir strings de hora a objetos java.sql.Time (se le añade :00 para los segundos)
        Time horaEntrada = Time.valueOf(horaEntradaStr + ":00");
        Time horaSalida = Time.valueOf(horaSalidaStr + ":00");
        double tarifaHoraExtra = Double.parseDouble(tarifaStr);

        ProyectoDAO pDAO = new ProyectoDAO();
        
        try {
            // 3. Crear y poblar el objeto Proyecto
            proyectos p = new proyectos();
            p.setEstado(estado);
            p.setNombre_proyecto(nombreProyecto);
            p.setPresupuesto_total(presupuestoTotal);
            p.setHora_entrada_oficial(horaEntrada);
            p.setHora_salida_oficial(horaSalida);
            p.setTarifa_hora_extra(tarifaHoraExtra);
            
            // 4. Guardar en Base de Datos
            pDAO.CrearProyecto(p);
            
        } catch (SQLException ex) {
            System.out.println("Error al crear el proyecto: " + ex.getMessage());
            ex.printStackTrace();
        }
        
        // 5. Asignar el supervisor al proyecto recién creado
        TrabajadoresDAO tDAO = new TrabajadoresDAO();
        try {
            int idGenerado = pDAO.BuscarPorNombre(nombreProyecto);
            if (idGenerado > 0) {
                tDAO.AsignarProyecto(idGenerado, idTrabajador);
            }
        } catch (SQLException ex) {
            System.out.println("Error al asignar supervisor: " + ex.getMessage());
            ex.printStackTrace();
        }
        
        // 6. Redirigir al Dashboard principal
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
