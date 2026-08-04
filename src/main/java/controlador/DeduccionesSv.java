package controlador;

import Repository.DeduccionDAO;
import Repository.TrabajadoresDAO;
import DTO.DeduccionDTO;
import model.Usuarios;
import model.trabajadores;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet(name = "DeduccionesSv", urlPatterns = {"/DeduccionesSv", "/Deducciones"})
public class DeduccionesSv extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession sessionActual = request.getSession(false);
        Usuarios usuarioLogeado = (sessionActual != null) ? (Usuarios) sessionActual.getAttribute("usuarioLogeado") : null;

        if (usuarioLogeado == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String rol = usuarioLogeado.getRol();
        if (!rol.equalsIgnoreCase("Administrador") && !rol.equalsIgnoreCase("Supervisor")) {
            response.sendRedirect("AccDen.jsp");
            return;
        }

        try {
            TrabajadoresDAO tDAO = new TrabajadoresDAO();
            List<trabajadores> listaTrabajadores = tDAO.ListarTrabajadores();
            request.setAttribute("listaTrabajadores", listaTrabajadores);

            DeduccionDAO dedDAO = new DeduccionDAO();
            List<DeduccionDTO> listaDeducciones = dedDAO.listarDeducciones();
            request.setAttribute("listaDeducciones", listaDeducciones);

        } catch (SQLException e) {
            e.printStackTrace();
        }

        request.getRequestDispatcher("Deducciones.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession sessionActual = request.getSession(false);
        Usuarios usuarioLogeado = (sessionActual != null) ? (Usuarios) sessionActual.getAttribute("usuarioLogeado") : null;

        if (usuarioLogeado == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String action = request.getParameter("action");
        DeduccionDAO dedDAO = new DeduccionDAO();

        if ("eliminar".equalsIgnoreCase(action)) {
            String idStr = request.getParameter("id_deduccion");
            if (idStr != null && !idStr.isEmpty()) {
                int idDed = Integer.parseInt(idStr);
                dedDAO.eliminarDeduccion(idDed);
            }
        } else {
            String idTrabStr = request.getParameter("id_trabajador");
            String concepto = request.getParameter("concepto");
            String montoStr = request.getParameter("monto");

            if (idTrabStr != null && !idTrabStr.isEmpty() && montoStr != null && !montoStr.isEmpty()) {
                int idTrabajador = Integer.parseInt(idTrabStr);
                double monto = Double.parseDouble(montoStr);
                Integer idUser = usuarioLogeado.getId_user();

                dedDAO.registrarDeduccion(idTrabajador, concepto, monto, idUser);
            }
        }

        response.sendRedirect("Deducciones");
    }
}
