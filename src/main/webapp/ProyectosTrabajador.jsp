<%-- 
    Document   : ProyectosTrabajador
    Created on : 20 mar 2026, 8:37:54 p.m.
    Author     : Benja
--%>

<%-- 
    Document   : MisProyectosTrabajador
    Created on : [Fecha actual]
    Author     : Benja
--%>

<%@page import="java.util.List"%>
<%@page import="DTO.ProyectosTrabajadorDTO"%> 
<%@page import="model.Usuarios"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    // --- LÓGICA DE SEGURIDAD ---
    HttpSession sessionActual = request.getSession(false);
    Usuarios user = (sessionActual != null) ? (Usuarios) sessionActual.getAttribute("usuarioLogeado") : null;
    
    if (user == null || !user.getRol().equalsIgnoreCase("Trabajador")) {
        response.sendRedirect("login.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Mis Proyectos | Panel de Usuario</title>
    
    <link rel="stylesheet" href="CSS/ProyectosTrabajador.css">
</head>
<body>

    <div class="page-wrapper">
        <div class="card attendance-card">
            
            <div class="card-header">
                <h2>&#128194; Mis Proyectos Asignados</h2>
                <p>Listado de las obras en las que estás registrado actualmente.</p>
            </div>

            <div class="table-responsive">
                <table class="vyg-table">
                    <thead>
                        <tr>
                            <th>Nombre del Trabajador</th>
                            <th>Puesto Asignado</th>
                            <th>Proyecto / Obra</th>
                            <th>Estado de la Obra</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            ProyectosTrabajadorDTO misProyectos = (ProyectosTrabajadorDTO) request.getAttribute("TraerProyecto");

                            if (misProyectos != null && !misProyectos.getNombre_proyecto().isEmpty()) {
                                
                                    
                                    // Lógica para el color del estado
                                    String estadoClass = "status-paused"; // Por defecto
                                    if (misProyectos.getEstado().equalsIgnoreCase("activo")) {
                                        estadoClass = "status-active";
                                    } else if (misProyectos.getEstado().equalsIgnoreCase("finalizado") || misProyectos.getEstado().equalsIgnoreCase("inactivo")) {
                                        estadoClass = "status-finished";
                                    }
                        %>
                        <tr>
                            <td><strong><%= misProyectos.getNombre()%></strong></td>
                            <td class="text-puesto"><%= misProyectos.getPuesto() %></td>
                            <td>
                                <span class="project-icon">&#127975;</span> 
                                <strong><%= misProyectos.getNombre_proyecto()%></strong>
                            </td>
                            <td>
                                <span class="status-badge <%= estadoClass %>">
                                    <%= misProyectos.getEstado().toUpperCase() %>
                                </span>
                            </td>
                        </tr>
                        <%
                                
                            } else {
                        %>
                        <tr>
                            <td colspan="4">
                                <div class="empty-state-container">
                                    <span class="empty-icon">&#128679;</span>
                                    <h3>Sin asignaciones activas</h3>
                                    <p>
                                        Actualmente no tienes ningún proyecto u obra asignada en el sistema. <br>
                                        Consulta con tu Ingeniero Residente o Supervisor.
                                    </p>
                                </div>
                            </td>
                        </tr>
                        <%
                            }
                        %>
                    </tbody>
                </table>
            </div>

            <div class="card-footer">
                <a href="Home.jsp" class="btn-back">&#11013; Volver a mi Panel</a>
            </div>

        </div>
    </div>

</body>
</html>