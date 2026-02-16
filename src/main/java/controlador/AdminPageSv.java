package controlador;

/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
import Repository.ProyectoDAO;
import Repository.TrabajadoresDAO;
import Repository.UsuarioDAO;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.HashSet;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import model.Usuarios;
import model.proyectos;
import java.sql.SQLException;
import model.trabajadores;

/**
 *
 * @author Benja
 */
@WebServlet(urlPatterns = {"/AdminPageSv"})
public class AdminPageSv extends HttpServlet {

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
        
        
    String accion = request.getParameter("accion");

    try {
        UsuarioDAO usuDAO = new UsuarioDAO();
        ProyectoDAO proyectoDAO = new ProyectoDAO();

        request.setAttribute("ListaSuperv", usuDAO.traerSupervisor());
        request.setAttribute("ListarProy", proyectoDAO.ListarProyectos());

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
       
        String action = request.getParameter("accion");
        switch (action) {
            case "guardarTrabajador":
//traigo los campos que requiero para  crear el trabajador
                String cedula = request.getParameter("cedula");
                String full_name = request.getParameter("full_name");
                int edad = Integer.parseInt(request.getParameter("edad"));
                String puesto = request.getParameter("puesto");
                double salario_quincenal = Double.parseDouble(request.getParameter("salario_quincenal"));
                String origen = request.getParameter("origen");
                int id_supervisor = Integer.parseInt(request.getParameter("supervisor"));
                int id_proyecto = Integer.parseInt(request.getParameter("proyecto"));

              

                
                //guardamos la informacion en un objeto 
                trabajadores trabajador = new trabajadores(cedula,full_name,edad,puesto,salario_quincenal,origen,id_supervisor,id_proyecto);
                //mandamos a llamar el metodo que nos permite registrar el trabajador
                TrabajadoresDAO trabajadorDAO = new TrabajadoresDAO();
                
                trabajadorDAO.registrarTrabajador(trabajador);
                
                

                break;

            case "proyectos":
                break;

            case "supervisores":
                break;

            case "reportes":
                break;
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
