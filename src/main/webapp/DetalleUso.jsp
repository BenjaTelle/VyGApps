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
                <span>🏗️ <%= d.getNombreProyecto() %><br>📅 <%= d.getFecha() %></span>
            </div>
            <div class="info-box">
                <strong>Equipo Operativo</strong>
                <span>🚜 <%= d.getNombreMaquina() %><br>👷 <%= d.getNombreTrabajador() %></span>
            </div>
        </div>

        <div class="math-section">
            <h3 style="margin-top: 0; color: #2c3e50;">Desglose de Costos (Facturación)</h3>
            <div class="math-row">
                <span>⏱️ Uso de Maquinaria (<%= String.format("%.2f", d.getHorasTrabajadas()) %> hrs a C$ <%= String.format("%,.2f", d.getCostoPorHora()) %>)</span>
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
            <a href="HistorialUso" class="btn-back">⬅️ Volver al Historial</a>
        </div>
    </div>
</body>
</html>