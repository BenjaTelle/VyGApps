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
    <link rel="stylesheet" href="CSS/DetalleUso.css"> <link rel="icon" href="images/vyg.svg" type="image/png">
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
                <span><svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect x="2" y="7" width="20" height="14" rx="2" ry="2"></rect><path d="M16 21V5a2 2 0 0 0-2-2h-4a2 2 0 0 0-2 2v16"></path></svg> <%= d.getNombreProyecto() %><br><svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect x="3" y="4" width="18" height="18" rx="2" ry="2"></rect><line x1="16" y1="2" x2="16" y2="6"></line><line x1="8" y1="2" x2="8" y2="6"></line><line x1="3" y1="10" x2="21" y2="10"></line></svg> <%= d.getFecha() %></span>
            </div>
            <div class="info-box">
                <strong>Equipo Operativo</strong>
                <span><svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect x="2" y="7" width="20" height="14" rx="2" ry="2"></rect><path d="M16 21V5a2 2 0 0 0-2-2h-4a2 2 0 0 0-2 2v16"></path></svg> <%= d.getNombreMaquina() %><br><svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"></path><circle cx="9" cy="7" r="4"></circle><path d="M23 21v-2a4 4 0 0 0-3-3.87"></path><path d="M16 3.13a4 4 0 0 1 0 7.75"></path></svg> <%= d.getNombreTrabajador() %></span>
            </div>
        </div>

        <div class="math-section">
            <h3 style="margin-top: 0; color: #2c3e50;">Desglose de Costos (Facturación)</h3>
            <div class="math-row">
                <span><svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="10"></circle><polyline points="12 6 12 12 16 14"></polyline></svg> Uso de Maquinaria (<%= String.format("%.2f", d.getHorasTrabajadas()) %> hrs a C$ <%= String.format("%,.2f", d.getCostoPorHora()) %>)</span>
                <span>C$ <%= String.format("%,.2f", costoUsoMaquina) %></span>
            </div>
            <div class="math-row">
                <span>⛽ Combustible Consumido (<%= d.getGalonesCombustible() %> Galones)</span>
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
            <a href="HistorialUso" class="btn-back"><svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><line x1="19" y1="12" x2="5" y2="12"></line><polyline points="12 19 5 12 12 5"></polyline></svg> Volver al Historial</a>
        </div>
    </div>
</body>
</html>