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
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import model.Usuarios;
import model.trabajadores;

/**
 *
 * @author Benja
 */
@WebServlet(name = "CrearUsuario", urlPatterns = {"/CrearUsuario"})
public class CrearUsuario extends HttpServlet {

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
   
        
        
        try{
            
            TrabajadoresDAO tDAO = new TrabajadoresDAO();  
            List<trabajadores> lista = tDAO.ListarTrabajadores();
            request.setAttribute("ListaT",  tDAO.ListarTrabajadores());
            
        for(trabajadores list:  lista)
        {
            System.out.println("nombre trabajador"+ list.getFull_name());
        }
           
            
            
            
        }catch(SQLException e )
        {
            e.printStackTrace();
        }
        
        
         request.getRequestDispatcher("RegistrarUsu.jsp")
                .forward(request, response);
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
        
        String user_name = request.getParameter("user_name");
        String pass = request.getParameter("pass");
        String rol = request.getParameter("rol");
         String id_trabajadorSTR=request.getParameter("id_trabajador");
         Integer id_trabajador=null;
         if(id_trabajadorSTR != null && !id_trabajadorSTR.isEmpty())
         {
             id_trabajador = Integer.parseInt(id_trabajadorSTR);
         }
        UsuarioDAO userDAO = new UsuarioDAO();
        Usuarios usu = new Usuarios();
        
        usu.setId_trabajador(id_trabajador);
        usu.setPass(pass);
        usu.setUser_name(user_name);
        usu.setRol(rol);

        try {
            userDAO.registrarUsuario(usu);
        } catch (SQLException e) {
         e.printStackTrace();
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
