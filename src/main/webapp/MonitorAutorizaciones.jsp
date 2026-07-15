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
    <title>Monitor de Autorizaciones | Kronos Industrial</title>
    
    <link rel="stylesheet" href="CSS/SupervisorPage.css">
    <link rel="stylesheet" href="CSS/MonitorAutorizaciones.css">
    
    <script src="JS/menu-movil.js" defer></script>
    <link rel="icon" href="images/KronosIndustrial.svg" type="image/svg+xml">

    <!-- Lucide Icons CDN -->
    <script src="https://unpkg.com/lucide@latest"></script>
</head>
<body>

<div class="admin-container">

    <div class="overlay" id="sidebarOverlay"></div>

    <aside class="sidebar" id="sidebar">
        <div class="sidebar-header">
            <img src="images/KronosIndustrial.svg" alt="Kronos Industrial Logo" class="sidebar-logo">
            <div class="brand-text">
                <h2 style="font-size: 18px;">Kronos Industrial</h2>
                <span class="panel-badge" style="background: #FDE8E8; color: #991B1B;"><%= user.getRol() %></span>
            </div>
        </div>

        <nav class="sidebar-nav">
            <a href="AdminPage.jsp" class="nav-item">
                <span class="icon"><i data-lucide="bar-chart-3" style="width: 20px; height: 20px"></i></span>
                <span>Dashboard Maestro</span>
            </a>
            <a href="AdminFinanzas" class="nav-item">
                <span class="icon"><i data-lucide="dollar-sign" style="width: 20px; height: 20px"></i></span>
                <span>Control Financiero</span>
            </a>
            <a href="MonitorAutorizaciones" class="nav-item active" style="background-color: #121216;">
                <span class="icon"><i data-lucide="settings" style="width: 20px; height: 20px"></i></span>
                <span>Monitor Autorizaciones</span>
            </a>
            <a href="LogoutSv" class="nav-item logout-link">
                <span class="icon"><i data-lucide="log-out" style="width: 20px; height: 20px"></i></span>
                <span>Cerrar Sesión</span>
            </a>
        </nav>
    </aside>

    <main class="main-content">

        <header class="topbar">
            <div class="header-left">
                <button id="menu-toggle" class="mobile-menu-btn"><i data-lucide="menu" style="width: 24px; height: 24px"></i></button>
            </div>

            <div class="profile-menu">
                <div class="profile-info">
                    <span class="profile-name"><%= user.getUser_name() %></span>
                    <span class="profile-role"><%= user.getRol() %></span>
                </div>
                <img src="images/usuario.png" class="profile-img" alt="Perfil">
            </div>
        </header>

        <section class="dashboard" style="max-width: 1100px; margin: 0 auto;">

            <div class="admin-header-banner" style="background: linear-gradient(135deg, #121216, #2980b9);">
                <div class="admin-header-info">
                    <h2><i data-lucide="settings" style="width: 20px; height: 20px"></i> Monitor de Autorizaciones Pendientes</h2>
                    <p>Seguimiento en tiempo real de planillas generadas que esperan aprobación de supervisores.</p>
                </div>
            </div>

            <div class="card monitor-card">
                <div class="card-header">
                    <h3><i data-lucide="clock" style="width: 20px; height: 20px"></i> Gestión de Pagos</h3>
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
                                <td colspan="6" class="empty-message"><svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"></path><polyline points="22 4 12 14.01 9 11.01"></polyline></svg> ¡Excelente! No hay autorizaciones pendientes de larga duración.</td>
                            </tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
            </div>

            <div style="margin-top: 25px; padding-bottom: 30px;">
                <a href="AdminFinanzas" class="btn-back"><i data-lucide="arrow-left" style="width: 20px; height: 20px"></i> Volver al Panel Financiero</a>
            </div>

        </section>

    </main>
</div>


    <!-- Inicializacion de Lucide Icons -->
    <script>
        lucide.createIcons();
    </script>
</body>
</html>
