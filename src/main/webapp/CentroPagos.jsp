<%-- 
    Document   : CentroPagos
    Created on : 2 abr 2026, 4:57:11 p.m.
    Author     : Benja
--%>

<%@page import="model.Usuarios"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    // Lógica de seguridad (Solo Admins y Supervisores pueden entrar aquí)
    HttpSession sessionActual = request.getSession(false);
    Usuarios user = (sessionActual != null) ? (Usuarios) sessionActual.getAttribute("usuarioLogeado") : null;
    
    if (user == null || (!user.getRol().equalsIgnoreCase("Supervisor") && !user.getRol().equalsIgnoreCase("Administrador"))) {
        response.sendRedirect("login.jsp");
        return;
    }
    
    boolean isAdmin = user.getRol().equalsIgnoreCase("Administrador");
%>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Centro de Pagos | VyGApps</title>
    <link rel="stylesheet" href="CSS/HistorialAsistencia.css">
    <link rel="stylesheet" href="CSS/DetalleAsistencia.css">
    <link rel="stylesheet" href="CSS/CentroPagos.css">
    <link rel="icon" href="images/vyg.svg" type="image/svg+xml">
</head>
<body>

    <div class="page-wrapper">
        
        <div class="worker-profile-header">
            <div class="profile-info">
                <h2>💰 Centro de Pagos y Liquidaciones</h2>
                <p>Módulo de generación de nóminas, pago de maquinaria y autorizaciones presupuestarias.</p>
            </div>
        </div>

        <% if(isAdmin) { %>
        <h3 class="section-title">⚙️ Operaciones de Generación</h3>
        <div class="action-grid">
            
            <a href="GenerarPlanillaServlet" class="action-card" onclick="return confirm('¿Iniciar el cálculo automático de la quincena para todos los trabajadores?');">
                <span class="action-icon">👥</span>
                <h3>Generar Planilla Quincenal</h3>
                <p>Calcula días trabajados y genera pagos en estado "Pendiente".</p>
            </a>

            <a href="GenerarPagoMaquinariaServlet" class="action-card">
                <span class="action-icon">🚜</span>
                <h3>Liquidar Maquinaria</h3>
                <p>Genera pagos por horas de uso y combustible registrado.</p>
            </a>

            <a href="AdministrarPresupuesto.jsp" class="action-card">
                <span class="action-icon">📊</span>
                <h3>Estado del Presupuesto</h3>
                <p>Revisa el balance general de los proyectos antes de pagar.</p>
            </a>
            
        </div>
        <% } %>

        <h3 class="section-title">📝 Autorizaciones e Historial</h3>
        <div class="action-grid" style="grid-template-columns: repeat(2, 1fr);">
            
            <a href="AutorizarPagoSv" class="action-card autorizacion-card">
                <span class="action-icon">✅</span>
                <h3>Bandeja de Autorización</h3>
                <p>Revisa las planillas pendientes y aprueba el desembolso.</p>
            </a>

            <a href="HistorialPagos.jsp" class="action-card historial-card">
                <span class="action-icon">🗂️</span>
                <h3>Historial y Comprobantes</h3>
                <p>Consulta pagos pasados y genera PDFs firmados.</p>
            </a>

        </div>

        <div style="margin-top: 30px;">
            <a href="SupervisorPage.jsp" class="btn-back">⬅️ Volver al Panel Principal</a>
        </div>

    </div>

</body>
</html>