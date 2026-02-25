/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controlador;

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

/**
 *
 * @author Benja
 */
@WebServlet(name = "EliminarUsu", urlPatterns = {"/EliminarUsu"})
public class EliminarUsu extends HttpServlet {

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
                UsuarioDAO usuDAO = new  UsuarioDAO();
                request.setAttribute("ListaUsuarios", usuDAO.ListarUsuarios());
                
                
                
        }catch(SQLException e )
        {
            e.printStackTrace();
        }
        
        
        request.getRequestDispatcher("EliminarUsu.jsp").forward(request, response);
        
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
         int idUsu = Integer.parseInt(request.getParameter("id_user"));
          UsuarioDAO usuDAO = new  UsuarioDAO();
           int filas=0;
        try {
             filas = usuDAO.EliminarUsuario(idUsu);
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
         if(filas>0)
         {
             request.setAttribute("mensaje", "Usuario eliminado correctamente");
    request.setAttribute("tipo", "success");
             
    
         }
         else{
             request.setAttribute("mensaje", "No se pudo eliminar el usuario");
    request.setAttribute("tipo", "error");
             
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
