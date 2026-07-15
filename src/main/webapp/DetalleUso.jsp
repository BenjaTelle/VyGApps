<%-- 
    Document   : DetalleUso
    Created on : 3 abr 2026, 7:18:57 p.m.
    Author     : Benja
--%>

<%@page import="DTO.HistorialUsoDTO"%>
<%@page import="model.Usuarios"%>
<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%
    HttpSession sessionActual = request.getSession(false);
    Usuarios user = (sessionActual != null) ? (Usuarios) sessionActual.getAttribute("usuarioLogeado") : null;
    if (user == null || !user.getRol().equalsIgnoreCase("Supervisor")) { response.sendRedirect("login.jsp"); return; }

    HistorialUsoDTO d = (HistorialUsoDTO) request.getAttribute("DetalleUso");
    if(d == null) { response.sendRedirect("HistorialUsoSv"); return; }

    // Matemática extra para la vista
    double costoUsoMaquina = d.getHorasTrabajadas() * d.getCostoPorHora();
    double costoCombustible = d.getCostoTotal() - costoUsoMaquina;
    double galonesPorHora = (d.getHorasTrabajadas() > 0) ? (d.getGalonesCombustible() / d.getHorasTrabajadas()) : 0;
%>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Detalle de Operación #<%= d.getIdUso() %></title>
    <link rel="stylesheet" href="CSS/HistorialUso.css"> 
    <link rel="stylesheet" href="CSS/DetalleUso.css"> <link rel="icon" href="images/KronosIndustrial.svg" type="image/png">

    <!-- Lucide Icons CDN -->
    <script src="https://unpkg.com/lucide@latest"></script>
</head>
<body>
    <div class="report-card">
        <div class="report-header">
            <h2>Reporte Operativo</h2>
            <span class="badge">Registro #<%= d.getIdUso() %></span>
        </div>

        <div class="grid-info">
            <div class="info-box">
                <strong>Proyecto & Fecha</strong>
                <span><i data-lucide="briefcase" style="width: 20px; height: 20px"></i> <%= d.getNombreProyecto() %><br><i data-lucide="calendar" style="width: 20px; height: 20px"></i> <%= d.getFecha() %></span>
            </div>
            <div class="info-box">
                <strong>Equipo Operativo</strong>
                <span><i data-lucide="briefcase" style="width: 20px; height: 20px"></i> <%= d.getNombreMaquina() %><br><i data-lucide="users" style="width: 20px; height: 20px"></i> <%= d.getNombreTrabajador() %></span>
            </div>
        </div>

        <div class="math-section">
            <h3 style="margin-top: 0; color: #121216;">Desglose de Costos (Facturación)</h3>
            <div class="math-row">
                <span><i data-lucide="clock" style="width: 20px; height: 20px"></i> Uso de Maquinaria (<%= String.format("%.2f", d.getHorasTrabajadas()) %> hrs a C$ <%= String.format("%,.2f", d.getCostoPorHora()) %>)</span>
                <span>C$ <%= String.format("%,.2f", costoUsoMaquina) %></span>
            </div>
            <div class="math-row">
                <span><svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" style="display:inline-block; vertical-align:middle; margin-right:4px;"><path d="M3 22V2a2 2 0 0 1 2-2h10a2 2 0 0 1 2 2v20"></path><path d="M4 9h12"></path><path d="M14 22V14a2 2 0 0 0-2-2H8a2 2 0 0 0-2 2v8"></path><path d="M19 12a4 4 0 0 1 4 4v5"></path></svg> Combustible Consumido (<%= d.getGalonesCombustible() %> Galones)</span>
                <span>C$ <%= String.format("%,.2f", costoCombustible) %></span>
            </div>
            <div class="math-row total">
                <span>Costo Total del Turno</span>
                <span>C$ <%= String.format("%,.2f", d.getCostoTotal()) %></span>
            </div>
        </div>

        <div class="kpi-section">
            <div class="kpi-card">
                Eficiencia de Combustible
                <span><%= String.format("%.1f", galonesPorHora) %> Gal/Hr</span>
            </div>
            <div class="kpi-card">
                Duración del Turno
                <span><%= d.getHoraInicio() %> a <%= d.getHoraFin() %></span>
            </div>
        </div>

        <div style="text-align: right;">
            <a href="HistorialUso" class="btn-back"><i data-lucide="arrow-left" style="width: 20px; height: 20px"></i> Volver al Historial</a>
        </div>
    </div>

    <!-- Inicializacion de Lucide Icons -->
    <script>
        lucide.createIcons();
    </script>
</body>
</html>