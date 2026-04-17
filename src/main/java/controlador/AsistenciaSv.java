/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controlador;

import Repository.AsistenciaDAO;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Date;
import java.sql.SQLException;
import java.sql.Time;
import java.util.logging.Level;
import java.util.logging.Logger;
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
@WebServlet(name = "AsistenciaSv", urlPatterns = {"/AsistenciaSv"})
public class AsistenciaSv extends HttpServlet {

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
        
      // 1. Recuperamos la sesión del trabajador
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("usuarioLogeado") == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        AsistenciaDAO aDAO = new AsistenciaDAO();
        Usuarios usuario = (Usuarios) session.getAttribute("usuarioLogeado");
        int idTrabajador = usuario.getId_trabajador(); 

        // 2. Atrapamos la acción y el código que vienen del formulario
        String accion = request.getParameter("accion");
        String codigoSupervisor = request.getParameter("codigo_supervisor"); // NUEVO

        if (accion != null) {
            switch (accion) {
                case "marcar_entrada":
                    try {
                        // A. Validar el código ingresado antes de hacer cualquier cosa
                        boolean codigoValido = aDAO.validarCodigoObra(codigoSupervisor, idTrabajador);

                        if (codigoValido) {
                            // B. Si es válido, guardamos la entrada en la BD
                            String horaActual = new java.text.SimpleDateFormat("HH:mm:ss").format(new java.util.Date());
                            Time entrada = Time.valueOf(horaActual);
                            
                            String fechaActual = new java.text.SimpleDateFormat("yyyy-MM-dd").format(new java.util.Date());
                            Date fecha = Date.valueOf(fechaActual);
                            
                            aDAO.MarcarEntrada(idTrabajador, entrada, fecha);
                            
                            // C. Actualizamos la sesión
                            session.setAttribute("horaEntradaRegistrada", horaActual);
                            session.removeAttribute("errorAsistencia"); // Limpiamos errores si los hubo
                            
                        } else {
                            // D. Si es inválido, mandamos un mensaje de error
                            session.setAttribute("errorAsistencia", "❌ El código ingresado es inválido o ha expirado.");
                        }
                    } catch (SQLException ex) {
                        ex.printStackTrace();
                        session.setAttribute("errorAsistencia", "❌ Error de conexión al validar el código.");
                    }
                    
                    // Redirigimos al Servlet Home para que recargue los datos correctamente
                    response.sendRedirect("Home");
                    break;

                case "marcar_salida":
                    try {
                        // A. Actualizamos el registro en la BD para poner la hora de salida
                        String horaSalida = new java.text.SimpleDateFormat("HH:mm:ss").format(new java.util.Date());
                        Time salida = Time.valueOf(horaSalida);
                        
                        aDAO.MarcarSalida(idTrabajador, salida);
                        
                    } catch (SQLException ex) {
                        ex.printStackTrace();
                    }
                    
                    // B. Limpiamos la variable de sesión
                    session.removeAttribute("horaEntradaRegistrada");
                    session.removeAttribute("errorAsistencia");
                    
                    response.sendRedirect("Home");
                    break;
            }
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
