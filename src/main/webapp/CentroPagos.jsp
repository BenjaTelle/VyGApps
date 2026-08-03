<%-- 
    Document   : CentroPagos
    Created on : 2 abr 2026
    Author     : Benja
--%>
<%@page import="model.Usuarios"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    // Lógica de seguridad
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
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Centro de Pagos | VyGApps</title>
    <link rel="stylesheet" href="CSS/SupervisorPage.css">
    <link rel="stylesheet" href="CSS/CentroPagos.css">
    <script src="JS/menu-movil.js" defer></script>
    <link rel="icon" href="images/vyg.svg" type="image/svg+xml">

    <!-- Lucide Icons CDN -->
    <script src="JS/lucide.min.js"></script>
</head>
<body>

<div class="admin-container">

    <div class="overlay" id="sidebarOverlay"></div>

    <aside class="sidebar" id="sidebar">
        <div class="sidebar-header">
            <img src="images/vyg.svg" alt="VyG Logo" class="sidebar-logo">
            <div class="brand-text">
                <h2 style="font-size: 18px;">VyGApps</h2>
                <span class="panel-badge"><%= user.getRol() %></span>
            </div>
        </div>

        <nav class="sidebar-nav">
            <a href="SupervisorPage" class="nav-item">
                <span class="icon"><i data-lucide="bar-chart-3" style="width: 20px; height: 20px"></i></span>
                <span>Dashboard</span>
            </a>
            <a href="CentroPagos" class="nav-item active">
                <span class="icon"><i data-lucide="dollar-sign" style="width: 20px; height: 20px"></i></span>
                <span>Planillas y Pagos</span>
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
                <div class="welcome">
                    <h1>Centro de Pagos</h1>
                    <span>Nóminas, liquidaciones y autorizaciones.</span>
                </div>
            </div>

            <div class="profile-menu">
                <div class="profile-info">
                    <span class="profile-name"><%= user.getUser_name() %></span>
                    <span class="profile-role"><%= user.getRol() %></span>
                </div>
                <img src="images/usuario.png" class="profile-img" alt="Perfil">
            </div>
        </header>

        <section class="dashboard">
            
            <% if(isAdmin) { %>
            <h3 class="section-title"><i data-lucide="settings" style="width: 20px; height: 20px"></i> Operaciones de Generación</h3>
            <div class="action-grid">
                
                <a href="GenerarPlanillaServlet" class="action-card" onclick="return confirm('¿Iniciar el cálculo automático de la quincena para todos los trabajadores?');">
                    <span class="action-icon"><i data-lucide="users" style="width: 20px; height: 20px"></i></span>
                    <h3>Generar Planilla</h3>
                    <p>Calcula días trabajados y genera pagos en estado "Pendiente".</p>
                </a>

                <a href="GenerarPagoMaquinariaServlet" class="action-card">
                    <span class="action-icon"><i data-lucide="briefcase" style="width: 20px; height: 20px"></i></span>
                    <h3>Liquidar Maquinaria</h3>
                    <p>Genera pagos por horas de uso y combustible registrado.</p>
                </a>

                <a href="AdministrarPresupuesto.jsp" class="action-card">
                    <span class="action-icon"><i data-lucide="bar-chart-3" style="width: 20px; height: 20px"></i></span>
                    <h3>Estado Presupuesto</h3>
                    <p>Revisa el balance general de los proyectos.</p>
                </a>
                
            </div>
            <% } %>

            <h3 class="section-title"><svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"></path><path d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z"></path></svg> Autorizaciones e Historial</h3>
            <div class="action-grid auth-grid">
                
                <a href="AutorizarPagoSv" class="action-card autorizacion-card">
                    <span class="action-icon"><svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"></path><polyline points="22 4 12 14.01 9 11.01"></polyline></svg></span>
                    <h3>Bandeja de Autorización</h3>
                    <p>Revisa las planillas pendientes y aprueba el desembolso.</p>
                </a>

                <a href="HistorialPagosSupSv" class="action-card historial-card">
                    <span class="action-icon"><svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M22 19a2 2 0 0 1-2 2H4a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h5l2 3h9a2 2 0 0 1 2 2z"></path></svg>️</span>
                    <h3>Historial de Pagos</h3>
                    <p>Consulta pagos pasados y genera PDFs firmados.</p>
                </a>

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