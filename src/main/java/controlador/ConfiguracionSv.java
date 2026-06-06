package controlador;

import Repository.UsuarioDAO;
import java.io.IOException;
import java.sql.SQLException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import model.Usuarios;

@WebServlet(name = "ConfiguracionSv", urlPatterns = {"/ConfiguracionSv"})
public class ConfiguracionSv extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        Usuarios user = (session != null) ? (Usuarios) session.getAttribute("usuarioLogeado") : null;
        
        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String nuevoNombre = request.getParameter("nuevo_nombre");
        String nuevaPass = request.getParameter("nueva_pass");
        String confirmarPass = request.getParameter("confirmar_pass");

        if (nuevaPass != null && !nuevaPass.isEmpty()) {
            if (!nuevaPass.equals(confirmarPass)) {
                response.sendRedirect("Configuracion.jsp?error=mismatch");
                return;
            }
            user.setPass(nuevaPass);
        }

        if (nuevoNombre != null && !nuevoNombre.trim().isEmpty()) {
            user.setUser_name(nuevoNombre);
        }

        UsuarioDAO uDAO = new UsuarioDAO();
        try {
            uDAO.modificarUsuario(user);
            session.setAttribute("usuarioLogeado", user);
            response.sendRedirect("Configuracion.jsp?success=true");
        } catch (SQLException ex) {
            ex.printStackTrace();
            response.sendRedirect("Configuracion.jsp?error=db");
        }
    }

    @Override
    public String getServletInfo() {
        return "Controlador de configuraciones de perfil";
    }
}
