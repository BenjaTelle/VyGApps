<%-- 
    Document   : MonitorAutorizaciones
    Created on : 2 abr 2026
    Author     : Benja
--%>

<%@page import="java.util.List"%>
<%@page import="DTO.MonitorPendientesDTO"%> 
<%@page import="model.Usuarios"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    // Seguridad: Solo Administradores
    HttpSession sessionActual = request.getSession(false);
    Usuarios user = (sessionActual != null) ? (Usuarios) sessionActual.getAttribute("usuarioLogeado") : null;

    if (user == null || !user.getRol().equalsIgnoreCase("Administrador")) {
        response.sendRedirect("login.jsp");
        return;
    }

    // Lista de pendientes enviada por el Servlet
    List<MonitorPendientesDTO> listaPendientes = (List<MonitorPendientesDTO>) request.getAttribute("ListaMonitor");
%>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Monitor de Autorizaciones | VyGApps</title>
    
    <link rel="stylesheet" href="CSS/SupervisorPage.css">
    <link rel="stylesheet" href="CSS/MonitorAutorizaciones.css">
    
    <script src="JS/menu-movil.js" defer></script>
    <link rel="icon" href="images/vyg.svg" type="image/svg+xml">
</head>
<body>

<div class="admin-container">

    <div class="overlay" id="sidebarOverlay"></div>

    <aside class="sidebar" id="sidebar">
        <div class="sidebar-header">
            <img src="images/vyg.svg" alt="VyG Logo" class="sidebar-logo">
            <div class="brand-text">
                <h2>VyGApps</h2>
                <span class="panel-badge" style="background:#fceceb; color:#c0392b;">Administrador</span>
            </div>
        </div>

        <nav class="sidebar-nav">
            <a href="AdminPage.jsp" class="nav-item">
                <span class="icon">📊</span>
                <span>Dashboard Maestro</span>
            </a>
            <a href="AdminFinanzas" class="nav-item">
                <span class="icon">💰</span>
                <span>Control Financiero</span>
            </a>
            <a href="MonitorAutorizaciones" class="nav-item active" style="background-color: #2c3e50;">
                <span class="icon">👀</span>
                <span>Monitor Autorizaciones</span>
            </a>
            <a href="LogoutSv" class="nav-item logout-link">
                <span class="icon">🚪</span>
                <span>Cerrar Sesión</span>
            </a>
        </nav>
    </aside>

    <main class="main-content">

        <header class="topbar">
            <div class="header-left">
                <button id="menu-toggle" class="mobile-menu-btn">☰</button>
            </div>

            <div class="profile-menu">
                <div class="profile-info">
                    <span class="profile-name"><%= user.getUser_name() %></span>
                    <span class="profile-role">Administrador</span>
                </div>
                <img src="images/usuario.png" class="profile-img" alt="Perfil">
            </div>
        </header>

        <section class="dashboard" style="max-width: 1100px; margin: 0 auto;">

            <div class="admin-header-banner" style="background: linear-gradient(135deg, #2c3e50, #2980b9);">
                <div class="admin-header-info">
                    <h2>👀 Monitor de Autorizaciones Pendientes</h2>
                    <p>Seguimiento en tiempo real de planillas generadas que esperan aprobación de supervisores.</p>
                </div>
            </div>

            <div class="card monitor-card">
                <div class="card-header">
                    <h3>🚦 Gestión de Pagos</h3>
                    <p>Los registros en rojo indican retrasos superiores a 48 horas.</p>
                </div>

                <div class="table-responsive">
                    <table class="vyg-table">
                        <thead>
                            <tr>
                                <th>Proyecto</th>
                                <th>Supervisor Responsable</th>
                                <th>Fecha Generación</th>
                                <th>Monto Total</th>
                                <th style="text-align: center;">Días de Retraso</th>
                                <th>Estado</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% 
                                if(listaPendientes != null && !listaPendientes.isEmpty()) {
                                    for(MonitorPendientesDTO m : listaPendientes) { 
                                        String claseRetraso = (m.getDiasRetraso() >= 3) ? "retraso-critico" : (m.getDiasRetraso() >= 2 ? "retraso-medio" : "al-dia");
                            %>
                            <tr class="<%= claseRetraso %>">
                                <td data-label="Proyecto"><strong><%= m.getNombreProyecto() %></strong></td>
                                <td data-label="Supervisor"><%= m.getNombreSupervisor() %></td>
                                <td data-label="Generado el"><%= m.getFechaGeneracion() %></td>
                                <td data-label="Monto" class="monto">C$ <%= String.format("%,.2f", m.getMontoTotal()) %></td>
                                <td data-label="Retraso" style="text-align: center;">
                                    <span class="dias-badge"><%= m.getDiasRetraso() %> días</span>
                                </td>
                                <td data-label="Estado">
                                    <span class="status-indicator">Pendiente</span>
                                </td>
                            </tr>
                            <% 
                                    }
                                } else { 
                            %>
                            <tr>
                                <td colspan="6" class="empty-message">🎉 ¡Excelente! No hay autorizaciones pendientes de larga duración.</td>
                            </tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
            </div>

            <div style="margin-top: 25px; padding-bottom: 30px;">
                <a href="AdminFinanzas" class="btn-back">⬅️ Volver al Panel Financiero</a>
            </div>

        </section>

    </main>
</div>

</body>
</html>