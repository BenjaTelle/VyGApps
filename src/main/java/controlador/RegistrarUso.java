package controlador;

import Repository.CamionesDAO;
import Repository.MaquinasDAO;
import Repository.MaterialDAO;
import Repository.ProyectoDAO;
import Repository.RegistroUsoDAO;
import Repository.TrabajadoresDAO;
import java.io.IOException;
import java.sql.Date;
import java.sql.SQLException;
import java.sql.Time;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import model.camiones;
import model.uso_registros;

@WebServlet(name = "RegistrarUso", urlPatterns = {"/RegistrarUso"})
public class RegistrarUso extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            MaquinasDAO mDAO = new MaquinasDAO();
            TrabajadoresDAO tDAO = new TrabajadoresDAO();
            ProyectoDAO pDAO = new ProyectoDAO();
            MaterialDAO matDAO = new MaterialDAO();
            
            request.setAttribute("ListarM", mDAO.listarMaquinas());
            request.setAttribute("ListarT", tDAO.ListarTecnicoOperadorativo());
            request.setAttribute("ListarP", pDAO.ListarProyectos());
            request.setAttribute("ListaMateriales", matDAO.ListarMateriales());

        } catch (SQLException e) {
            e.printStackTrace();
        }

        request.getRequestDispatcher("UsoMaquinaria.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        int id_proyecto = Integer.parseInt(request.getParameter("id_proyect"));
        int id_maquina = Integer.parseInt(request.getParameter("id_maquinaria"));
        int id_trabajador = Integer.parseInt(request.getParameter("id_trabajador"));
        Date fechaOp = Date.valueOf(request.getParameter("fecha"));
        double costoHora = Double.parseDouble(request.getParameter("costo_por_hora"));
        String hInicioStr = request.getParameter("hora_inicio");
        String hFinStr = request.getParameter("hora_fin");

        if (hInicioStr != null && hInicioStr.length() == 5) {
            hInicioStr += ":00"; 
        }
        if (hFinStr != null && hFinStr.length() == 5) {
            hFinStr += ":00";
        }
        
        Time horaIni = Time.valueOf(hInicioStr);
        Time horaFin = Time.valueOf(hFinStr);
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
            int idUsoGenerado = ru.CrearRegistroUso(uso);
            
            // Si el formulario envió el checkbox activado, guardamos los detalles del viaje.
            String incluirViaje = request.getParameter("incluir_viaje");
            if (incluirViaje != null) {
                camiones camion = new camiones();
                camion.setId_uso(idUsoGenerado);
                camion.setOrigen(request.getParameter("origen"));
                camion.setDestino(request.getParameter("destino"));
                
                String cantidadStr = request.getParameter("cantidad_cargada");
                if (cantidadStr != null && !cantidadStr.isEmpty()) {
                    camion.setCantidad_cargada((int) Double.parseDouble(cantidadStr));
                }
                
                String materialStr = request.getParameter("id_material");
                if (materialStr != null && !materialStr.trim().isEmpty()) {
                    camion.setId_material(Integer.parseInt(materialStr));
                } else {
                    camion.setId_material(0);
                }
                
                String costoFleteStr = request.getParameter("costo_flete");
                if (costoFleteStr != null && !costoFleteStr.isEmpty()) {
                    camion.setCosto_flete(Double.parseDouble(costoFleteStr));
                }
                
                // Mapear automáticamente las horas de la máquina al viaje
                camion.setHora_salida(horaIni);
                camion.setHora_llegada(horaFin);
                
                CamionesDAO cDAO = new CamionesDAO();
                cDAO.registrarCamion(camion);
            }
            
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        
        response.sendRedirect("SupervisorPage");
    }

    @Override
    public String getServletInfo() {
        return "Registrar Uso y Viajes de Maquinaria";
    }
}
