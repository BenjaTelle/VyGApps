/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controlador;

import Repository.MaquinasDAO;
import Repository.ProyectoDAO;
import Repository.RegistroUsoDAO;
import Repository.TrabajadoresDAO;
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
import model.uso_registros;

/**
 *
 * @author Benja
 */
@WebServlet(name = "RegistrarUso", urlPatterns = {"/RegistrarUso"})
public class RegistrarUso extends HttpServlet {

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

            MaquinasDAO mDAO = new MaquinasDAO();
            TrabajadoresDAO tDAO = new TrabajadoresDAO();
            ProyectoDAO pDAO = new ProyectoDAO();
            request.setAttribute("ListarM", mDAO.listarMaquinas());
            request.setAttribute("ListarT", tDAO.ListarTecnicoOperadorativo());
            request.setAttribute("ListarP", pDAO.ListarProyectos());

        } catch (SQLException e) {
            e.printStackTrace();
        }

        request.getRequestDispatcher("UsoMaquinaria.jsp").forward(request, response);
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
        
        int id_proyecto = Integer.parseInt(request.getParameter("id_proyect"));
        int id_maquina = Integer.parseInt(request.getParameter("id_maquinaria"));
        int id_trabajador = Integer.parseInt(request.getParameter("id_trabajador"));
        Date fechaOp = Date.valueOf(request.getParameter("fecha"));
       double costoHora = Double.parseDouble(request.getParameter("costo_por_hora"));
        String hInicioStr = request.getParameter("hora_inicio");
String hFinStr = request.getParameter("hora_fin");

// 2. Le agregas los ":00" (segundos) si el navegador solo mandó horas y minutos (tamaño 5, ej: "14:30")
if (hInicioStr != null && hInicioStr.length() == 5) {
    hInicioStr += ":00"; 
}
if (hFinStr != null && hFinStr.length() == 5) {
    hFinStr += ":00";
}
        
        
        Time horaIni = Time.valueOf(hInicioStr);
         Time horaFin= Time.valueOf(hFinStr);
        double combustible = Double.parseDouble(request.getParameter("combustible"));
        double costo_combustible = Double.parseDouble(request.getParameter("costo_combustible_total"));
        
        uso_registros uso = new uso_registros();
        
        uso.setId_maquina(id_maquina);
        uso.setId_proyect(id_proyecto);
        uso.setId_trabajador(id_trabajador);
        
        uso.setFecha(fechaOp);
        uso.setHora_inicio(horaIni);
        uso.setHora_fin(horaFin);
        uso.setCombustible(combustible);
        uso.setCostoT_combustible(costo_combustible);
        uso.setCosto_hora(costoHora);
        RegistroUsoDAO ru = new RegistroUsoDAO();
        try {
            ru.CrearRegistroUso(uso);
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        
        response.sendRedirect("SupervisorPage");
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
