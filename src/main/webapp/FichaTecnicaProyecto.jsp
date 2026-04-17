<%-- 
    Document   : FichaTecnicaProyecto
    Created on : 30 mar 2026, 4:55:26 p.m.
    Author     : Benja
--%>

<%@page import="DTO.FichaTecnicaDTO"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="DTO.ListarProyectosDTO"%> 
<%@page import="model.Usuarios"%>

<%-- 
    Document   : FichaTecnica
    Created on : [Fecha Actual]
    Author     : Benja
--%>
<%
    

%>


<%
    // Validación de seguridad
    HttpSession sessionActual = request.getSession(false);
    Usuarios user = (sessionActual != null) ? (Usuarios) sessionActual.getAttribute("usuarioLogeado") : null;
    
    if (user == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    // Obtenemos el objeto con los datos del proyecto
    FichaTecnicaDTO f = (FichaTecnicaDTO) request.getAttribute("ficha") ;

    
    // Si entran sin un proyecto cargado, los regresamos
    if(f == null){
        response.sendRedirect("SupervisorPage.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Ficha Técnica | <%= f.getNombre_proyecto() %></title>
    
    <link rel="stylesheet" href="CSS/FichaTecnicaProyecto.css">
    <link rel="icon" href="images/vyg.svg" type="image/svg+xml">
</head>
<body>

    <div class="page-wrapper">
        
        <!-- Contenedor Principal de la Ficha -->
        <div class="document-card" id="fichaImprimible">
            
            <!-- Encabezado de la Ficha -->
            <div class="doc-header">
                <div class="header-logo">
                    <!-- Asegúrate de tener tu logo en esta ruta -->
                    <img src="images/vyg.svg" alt="VyG Logo">
                </div>
                <div class="header-titles">
                    <h2>FICHA TÉCNICA DE OBRA</h2>
                    <h1><%= f.getNombre_proyecto() %></h1>
                    <span class="doc-id">Código de Proyecto: PRY-00<%= f.getIdP()%></span>
                </div>
            </div>

            <hr class="divider">

            <!-- Cuerpo de Datos -->
            <div class="doc-body">
                
                <div class="data-grid">
                    <!-- Estado -->
                    <div class="data-box">
                        <span class="data-label">&#128679; Estado Operativo</span>
                        <div class="data-value">
                            <span class="status-badge <%= f.getEstado().equalsIgnoreCase("activo") ? "status-active" : "status-inactive" %>">
                                <%= f.getEstado().toUpperCase() %>
                            </span>
                        </div>
                    </div>

                    <!-- Supervisor -->
                    <div class="data-box">
                        <span class="data-label">&#128119; Supervisor a Cargo</span>
                        <div class="data-value highlight-text">
                            <%= (f.getNombre_supervisor() != null && !f.getNombre_supervisor().isEmpty()) ? f.getNombre_supervisor() : "<span style='color:#e74c3c; font-style:italic;'>No asignado</span>" %>
                        </div>
                    </div>

                    <!-- Trabajadores -->
                    <div class="data-box">
                        <span class="data-label">&#9874; Fuerza Laboral Activa</span>
                        <div class="data-value number-value text-blue">
                            <%= f.getTotal_trabajadores() %> <span class="unit">Trabajadores</span>
                        </div>
                    </div>

                    <!-- Presupuesto -->
                    <div class="data-box">
                        <span class="data-label">&#128176; Presupuesto Asignado</span>
                        <div class="data-value number-value text-green">
                            C$ <%= String.format("%,.2f", f.getPresupuesto()) %>
                        </div>
                    </div>
                </div>

            </div>

            <hr class="divider">

            <!-- Pie del documento -->
            <div class="doc-footer">
                <p>Documento generado por el Sistema VyGApps.</p>
                <p>Fecha de emisión: <%= new java.text.SimpleDateFormat("dd/MM/yyyy HH:mm").format(new java.util.Date()) %></p>
            </div>
            
        </div>

        <!-- Botonera (No se imprime) -->
        <div class="action-buttons">
            <a href="javascript:history.back()" class="btn btn-back">&#11013; Volver</a>
            <button onclick="window.print()" class="btn btn-print">&#128424; Imprimir Ficha Técnica</button>
        </div>

    </div>

</body>
</html>