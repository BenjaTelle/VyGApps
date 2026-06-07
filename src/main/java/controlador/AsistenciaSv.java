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
import java.time.Duration;
import java.time.LocalDate;
import java.time.LocalTime;
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
        String codigoSupervisor = request.getParameter("codigo_supervisor");

        if (accion != null) {
            switch (accion) {
                case "marcar_entrada":
                    try {
                        // A. Validar el código ingresado
                        boolean codigoValido = aDAO.validarCodigoObra(codigoSupervisor, idTrabajador);

                        if (codigoValido) {
                            // B. Registro de entrada exitoso
                            String horaActual = new java.text.SimpleDateFormat("HH:mm:ss").format(new java.util.Date());
                            Time entrada = Time.valueOf(horaActual);
                            
                            String fechaActual = new java.text.SimpleDateFormat("yyyy-MM-dd").format(new java.util.Date());
                            Date fecha = Date.valueOf(fechaActual);
                            
                            aDAO.MarcarEntrada(idTrabajador, entrada, fecha);
                            
                            // C. Actualización de estado en sesión
                            session.setAttribute("horaEntradaRegistrada", horaActual);
                            session.removeAttribute("errorAsistencia"); 
                            
                        } else {
                            session.setAttribute("errorAsistencia", "El código ingresado es inválido o ha expirado.");
                        }
                    } catch (SQLException ex) {
                        ex.printStackTrace();
                        session.setAttribute("errorAsistencia", "Error de conexión al validar el código de asistencia.");
                    }
                    
                    response.sendRedirect("Home");
                    break;

                case "marcar_salida":
                    try {
                        // A. Capturar hora y fecha real del servidor mediante java.time
                        LocalTime horaActualLT = LocalTime.now();
                        Time salida = Time.valueOf(horaActualLT);
                        Date fechaHoy = Date.valueOf(LocalDate.now());
                        
                        // B. Extraer las reglas operativas del proyecto del trabajador
                        Time horaOficialTime = aDAO.obtenerHoraSalidaOficial(idTrabajador);
                        
                        if (horaOficialTime == null) {
                            session.setAttribute("errorAsistencia", "No tienes un proyecto asignado con horario definido. Contacta a recursos humanos.");
                            response.sendRedirect("Home");
                            return;
                        }
                        
                        LocalTime horaOficialLT = horaOficialTime.toLocalTime();
                        int horasExtras = 0;
                        int marcaAnomala = 0;
                        
                        // C. MOTOR DE CÁLCULO DE TIEMPO
                        if (horaActualLT.isBefore(horaOficialLT)) {
                            // Escenario: Intento de Salida Temprana
                            if (codigoSupervisor != null && !codigoSupervisor.trim().isEmpty()) {
                                boolean codigoValido = aDAO.validarCodigoObra(codigoSupervisor, idTrabajador);
                                if (codigoValido) {
                                    marcaAnomala = 1; // Salida temprana autorizada por el supervisor
                                } else {
                                    session.setAttribute("errorAsistencia", "Código de supervisor inválido para autorizar salida temprana.");
                                    response.sendRedirect("Home");
                                    return; // Se detiene el proceso, no marca salida
                                }
                            } else {
                                session.setAttribute("errorAsistencia", "Estás intentando salir antes de la hora oficial (" + horaOficialLT + "). Se requiere código de autorización del supervisor.");
                                response.sendRedirect("Home");
                                return; // Se detiene el proceso, no marca salida
                            }
                        } else {
                            // Escenario: Salida Normal o con Horas Extras
                            Duration duracion = Duration.between(horaOficialLT, horaActualLT);
                            long minutosExtra = duracion.toMinutes();
                            
                            // Cálculo exclusivo de horas cumplidas (60 minutos = 1 hora)
                            if (minutosExtra >= 60) {
                                horasExtras = (int) (minutosExtra / 60); 
                            }
                        }
                        
                        // D. Persistencia en la Base de Datos
                        aDAO.MarcarSalida(idTrabajador, salida, horasExtras, marcaAnomala, fechaHoy);
                        
                        // E. Limpieza de estado en sesión
                        session.removeAttribute("horaEntradaRegistrada");
                        session.removeAttribute("errorAsistencia");
                        
                    } catch (SQLException ex) {
                        ex.printStackTrace();
                        session.setAttribute("errorAsistencia", "Error en el servidor al procesar el cierre de turno.");
                    }
                    
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
