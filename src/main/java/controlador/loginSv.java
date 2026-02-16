/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controlador;

import Repository.UsuarioDAO;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.SQLException;
import java.util.Set;
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
@WebServlet(name = "loginSv", urlPatterns = {"/loginSv"})
public class loginSv extends HttpServlet {

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

        UsuarioDAO userDao = new UsuarioDAO();
        Usuarios user = new Usuarios();

        try {
           user = userDao.login(user_name, pass);

            
             if(user==null){
                
                 // rol desconocido
                    request.setAttribute("error", "Contraseña o Usuario incorrectos. Vuelva a intentarlo.");
                    request.getRequestDispatcher("login.jsp").forward(request, response);
                    return;
            }
            //crear sesion del usuario 
             HttpSession sesion = request.getSession();
             
             sesion.setAttribute("usuarioLogeado", user);
             switch(user.getRol())
             {
                 
                 case "Administrador":
                                response.sendRedirect("AdminPage.jsp");
                                
                                
                     break;
                 case "Trabajador":
                     
                     
                      response.sendRedirect("Home");
                     break;
                    
                 case "Supervisor":
                      response.sendRedirect("SupervisorPage.jsp");
                     break;
                     
                     
                 default:
                      request.setAttribute("Error", "Rol no válido");
                request.getRequestDispatcher("login.jsp").forward(request, response);
                             
             }

        } catch (SQLException ex) {
          ex.printStackTrace();
        request.setAttribute("error", "Error interno. Intente más tarde.");
        request.getRequestDispatcher("login.jsp").forward(request, response);
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
