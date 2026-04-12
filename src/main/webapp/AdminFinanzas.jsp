<%-- 
    Document   : AdminFinanzas
    Created on : 2 abr 2026, 5:13:06 p.m.
    Author     : Benja
--%>


<%@page import="java.util.List"%>
<%@page import="DTO.DashboardAdminDTO"%>
<%@page import="model.Usuarios"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    // 1. Lógica de seguridad ESTRICTA (Solo Administradores)
    HttpSession sessionActual = request.getSession(false);
    Usuarios user = (sessionActual != null) ? (Usuarios) sessionActual.getAttribute("usuarioLogeado") : null;
    
    if (user == null || !user.getRol().equalsIgnoreCase("Administrador")) {
        if(user != null && user.getRol().equalsIgnoreCase("Supervisor")){
            response.sendRedirect("BandejaAutorizacion.js   p");
        } else {
            response.sendRedirect("login.jsp");
        }
        return;
    }

    // 2. Recibimos los datos financieros desde el Servlet
    DashboardAdminDTO dashboard = (DashboardAdminDTO) request.getAttribute("DashboardData");
    
    // Prevención de nulos por si acceden directo al JSP sin pasar por el Servlet
    if(dashboard == null) {
        dashboard = new DashboardAdminDTO();
        dashboard.setTotalPagadoMes("C$ 0.00");
        dashboard.setTotalPendiente("C$ 0.00");
        dashboard.setPlanillasPendientes(0);
        dashboard.setPresupuestoGlobal("C$ 0.00");
    }
%>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Control Financiero Maestro | VyGApps</title>
    <link rel="stylesheet" href="CSS/HistorialAsistencia.css">
    <link rel="stylesheet" href="CSS/DetalleAsistencia.css"> 
    <link rel="stylesheet" href="CSS/CentroPagos.css"> 
    <link rel="stylesheet" href="CSS/AdminFinanzas.css"> 
    <link rel="icon" href="images/vyg.svg" type="image/svg+xml">
</head>
<body>

    <div class="page-wrapper" style="max-width: 1000px;">
        
        <div class="worker-profile-header admin-header">
            <div class="profile-info">
                <h2>👑 Control Financiero y Nóminas</h2>
                <p>Bienvenido, <%= user.getUser_name() %>. Vista maestra de generación de pagos y control presupuestario.</p>
            </div>
        </div>

        <div class="kpi-grid">
            <div class="kpi-card">
                <span class="kpi-icon">💸</span>
                <div class="kpi-data">
                    <h3 style="color: #27ae60;"><%= dashboard.getTotalPagadoMes() %></h3>
                    <p>Pagado este mes</p>
                </div>
            </div>
            <div class="kpi-card">
                <span class="kpi-icon">⏳</span>
                <div class="kpi-data">
                    <h3 style="color: #f39c12;"><%= dashboard.getTotalPendiente() %></h3>
                    <p>En espera de Autorización</p>
                </div>
            </div>
            <div class="kpi-card">
                <span class="kpi-icon">📉</span>
                <div class="kpi-data">
                    <h3><%= dashboard.getPlanillasPendientes() %></h3>
                    <p>Planillas Pendientes</p>
                </div>
            </div>
            <div class="kpi-card">
                <span class="kpi-icon">🏗️</span>
                <div class="kpi-data">
                    <h3><%= dashboard.getPresupuestoGlobal() %></h3>
                    <p>Presupuesto Global Disp.</p>
                </div>
            </div>
        </div>

        <% 
            List<String> alertas = dashboard.getAlertas();
            if(alertas != null && !alertas.isEmpty()) { 
                for(String alertaMensaje : alertas) {
        %>
        <div class="alert-box">
            <span class="alert-icon">⚠️</span>
            <div>
                <strong>Atención requerida:</strong> <%= alertaMensaje %>
            </div>
        </div>
        <% 
                }
            } 
        %>

        <h3 class="section-title">⚙️ Generación de Egresos</h3>
        <div class="action-grid">
            <a href="GenerarPlanilla" class="action-card">
                <span class="action-icon">👥</span>
                <h3>Nómina Quincenal</h3>
                <p>Calcula días y genera pagos a trabajadores.</p>
            </a>
            <a href="GenerarPagoMaquinaria" class="action-card">
                <span class="action-icon">🚜</span>
                <h3>Liquidación Maquinaria</h3>
                <p>Genera pagos por horas de alquiler y diésel.</p>
            </a>
            <a href="GestionPresupuestos" class="action-card">
                <span class="action-icon">📊</span>
                <h3>Gestión Presupuestos</h3>
                <p>Asigna o modifica fondos por proyecto.</p>
            </a>
        </div>

        <h3 class="section-title">🕵️ Auditoría y Reportes</h3>
        <div class="action-grid" style="grid-template-columns: repeat(2, 1fr);">
            <a href="MonitorAutorizaciones" class="action-card" style="border-top-color: #9b59b6;">
                <span class="action-icon">👀</span>
                <h3>Monitor de Autorizaciones</h3>
                <p>Revisa el estatus de las planillas en la bandeja de cada supervisor.</p>
            </a>
            <a href="AuditoriaPagosSv" class="action-card" style="border-top-color: #34495e;">
                <span class="action-icon">🗂️</span>
                <h3>Historial Maestro (Auditoría)</h3>
                <p>Búsqueda global de pagos, filtros por trabajador o proyecto, y exportación a PDF.</p>
            </a>
        </div>

        <div style="margin-top: 30px;">
            <a href="AdminPage.jsp" class="btn-back">⬅️ Volver al Panel Principal</a>
       
        </div>
     

    </div>

</body>
</html>