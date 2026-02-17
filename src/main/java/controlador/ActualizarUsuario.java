/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controlador;

import Repository.TrabajadoresDAO;
import Repository.UsuarioDAO;
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
import model.Usuarios;

/**
 *
 * @author Benja
 */
@WebServlet(name = "ActualizarUsuario", urlPatterns = {"/ActualizarUsuario"})
public class ActualizarUsuario extends HttpServlet {

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
                UsuarioDAO usu = new UsuarioDAO();
                TrabajadoresDAO t = new TrabajadoresDAO();
                request.setAttribute("ListaT", t.ListarTrabajadores());
                request.setAttribute("ListaUsuarios", usu.ListarUsuarios());
        }catch(SQLException e)
        {
            e.printStackTrace();
        }
        
        request.getRequestDispatcher("ActualizarUsu.jsp").forward(request, response);
        
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
        
        
        int id_user = Integer.parseInt(request.getParameter("id_usuario")); 
        String NuevoUsuario = request.getParameter("user_name");
        String NuevaContraseña = request.getParameter("pass");  
        String NuevoRol = request.getParameter("rol");
        int nuevoId_trabajador = Integer.parseInt(request.getParameter("id_trabajador"));
        UsuarioDAO usuDAO = new UsuarioDAO();
        Usuarios usu = new Usuarios();
        
        
        usu.setId_user(id_user); //id usuario que le quiero mandar a modificar 
        usu.setPass(NuevaContraseña);
        usu.setRol(NuevoRol);
        usu.setUser_name(NuevoUsuario);
        usu.setId_trabajador(nuevoId_trabajador); //id trabajador que voy a asignar 
        try {
            int filas = usuDAO.modificarUsuario(usu);
            System.out.println("filas afectadas: "+filas);
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
