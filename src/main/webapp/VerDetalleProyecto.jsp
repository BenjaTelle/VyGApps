<%-- 
    Document   : VerDetalleProyecto
    Created on : 6 mar 2026, 5:54:06 p.m.
    Author     : Benja
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="model.proyectos"%>

<%@page import="java.util.List"%>
<%@page import="model.Usuarios"%>
<%
    // Validación de seguridad de sesión
    HttpSession sessionActual = request.getSession(false);
    Usuarios usuarioLogeado = (sessionActual != null) ? (Usuarios) sessionActual.getAttribute("usuarioLogeado") : null;

    if (usuarioLogeado == null) {
        response.sendRedirect("login.jsp");
        return;
    } else if (!usuarioLogeado.getRol().equals("Supervisor")) {
        response.sendRedirect("AccDen.jsp");
        return;
    }

    // Listado de todos los proyectos para el <select>
    List<proyectos> listaProyectos = (List<proyectos>) request.getAttribute("ListaProyectos");
    
    // Objeto del proyecto específico (vendrá nulo si es la primera vez que se entra a la página)
    proyectos proyectoSeleccionado = (proyectos) request.getAttribute("proyectoSeleccionado");
%>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Detalles del Proyecto</title>
    <link rel="stylesheet" href="CSS/VerDetalleProyecto.css">
     <link rel="icon" href="images/vyg.svg" type="image/png">
</head>
<body>

    <div class="page-wrapper">
        
        <div class="card search-card">
            <div class="card-header">
                <h2>&#127977; Consultar Proyecto</h2>
                <p>Seleccione una obra para ver su estado y presupuesto.</p>
            </div>
            
            <form action="VerDetalleProyecto" method="GET" class="search-form">
                
                <input type="hidden" name="accion" value="verDetalle">
                
                <div class="form-group">
                    <label for="id_proyecto">Seleccione el Proyecto:</label>
                    <div class="input-group">
                        <select name="id_proyecto" id="id_proyecto" required>
                            <option value="" disabled selected>-- Lista de proyectos activos --</option>
                            <%
                                if(listaProyectos != null) {
                                    for(proyectos p : listaProyectos) {
                                        // Mantenemos seleccionado el proyecto actual si ya se buscó uno
                                        String isSelected = (proyectoSeleccionado != null && proyectoSeleccionado.getProyecto_id()== p.getProyecto_id()) ? "selected" : "";
                            %>
                            <option value="<%= p.getProyecto_id() %>" <%= isSelected %>>
                                <%= p.getNombre_proyecto()%>
                            </option>
                            <%
                                    }
                                }
                            %>
                        </select>
                        <button type="submit" class="btn-search">&#128269; Cargar Datos</button>
                    </div>
                </div>
            </form>
        </div>

        <% if (proyectoSeleccionado != null) { %>
        <div class="card result-card">
            <div class="result-header">
                <h3>&#128203; Ficha Técnica del Proyecto</h3>
                <span class="status-badge <%= proyectoSeleccionado.getEstado().equalsIgnoreCase("activo") ? "status-active" : "status-inactive" %>">
                    <%= proyectoSeleccionado.getEstado().toUpperCase() %>
                </span>
            </div>

            <div class="result-body">
                <div class="info-group full-width">
                    <span class="info-label">Nombre Oficial de la Obra</span>
                    <span class="info-value title-value"><%= proyectoSeleccionado.getNombre_proyecto()%></span>
                </div>

                <div class="info-group">
                    <span class="info-label">Código Interno</span>
                    <span class="info-value">PRY-00<%= proyectoSeleccionado.getProyecto_id()%></span>
                </div>

                <div class="info-group highlight-financial">
                    <span class="info-label">Presupuesto Total Asignado</span>
                    <span class="info-value text-green">C$ <%= String.format("%.2f", proyectoSeleccionado.getPresupuesto_total()) %></span>
                </div>
            </div>
            
            <div class="card-footer">
                <a href="SupervisorPage" class="btn-cancel">&#11013; Volver al Panel</a>
            </div>
        </div>
        <% } %>

    </div>

</body>
</html>