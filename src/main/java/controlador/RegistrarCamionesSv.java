package controlador;

/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
import Repository.CamionesDAO;
import Repository.MaterialDAO;
import Repository.ProyectoDAO;
import Repository.UsoDAO;
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
import model.camiones;

/**
 *
 * @author Benja
 */
@WebServlet(urlPatterns = {"/RegistrarCamionesSv"})
public class RegistrarCamionesSv extends HttpServlet {

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

        MaterialDAO mDAO = new MaterialDAO();
        UsoDAO uDAO = new UsoDAO();

        request.setAttribute("ListaM", mDAO.ListarMateriales());
        request.setAttribute("ListaUso", uDAO.ListarRegistros());

        request.getRequestDispatcher("RegistrarCamiones.jsp").forward(request, response);
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
        int id_uso = Integer.parseInt(request.getParameter("id_uso"));
        int id_material = Integer.parseInt(request.getParameter("id_material"));
        double cantidad_cargada = Double.parseDouble(request.getParameter("cantidad_cargada"));
        String origen = request.getParameter("origen");
        String destino = request.getParameter("destino");

        String hInicioStr = request.getParameter("hora_llegada");
        String hFinStr = request.getParameter("hora_salida");

// Le agregamos ":00" (segundos) si el navegador solo mandó horas y minutos (tamaño 5, ej: "14:30")
        if (hInicioStr != null && hInicioStr.length() == 5) {
            hInicioStr += ":00";
        }
        if (hFinStr != null && hFinStr.length() == 5) {
            hFinStr += ":00";
        }

        Time hora_salida = Time.valueOf(hFinStr);
        Time hora_entrada = Time.valueOf(hInicioStr);
        Double costo_flete = Double.parseDouble(request.getParameter("costo_flete"));

        //creamos el objeto
        camiones c = new camiones(hora_salida, hora_entrada, origen, destino, cantidad_cargada, id_uso, costo_flete, id_material);

        CamionesDAO  cDAO = new CamionesDAO();
        cDAO.registrarCamion(c);
        
        response.sendRedirect("SupervisorPage.jsp");

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
