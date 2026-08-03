<%-- 
    Document   : GenerarPagoMaquinaria
    Created on : 2 abr 2026, 6:58:12 p.m.
    Author     : Benja
--%>

<%@page import="model.Usuarios"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    // Lógica de seguridad ESTRICTA (Solo Administradores)
    HttpSession sessionActual = request.getSession(false);
    Usuarios user = (sessionActual != null) ? (Usuarios) sessionActual.getAttribute("usuarioLogeado") : null;
    
    if (user == null || !user.getRol().equalsIgnoreCase("Administrador")) {
        response.sendRedirect("login.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Liquidar Maquinaria | VyGApps</title>
    
    <link rel="stylesheet" href="CSS/SupervisorPage.css">
    <link rel="stylesheet" href="CSS/FormulariosGeneracion.css">
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
                <span class="panel-badge" style="background: #FDE8E8; color: #991B1B;"><%= user.getRol() %></span>
            </div>
        </div>

        <nav class="sidebar-nav">
            <a href="AdminPage.jsp" class="nav-item">
                <i data-lucide="layout-dashboard" style="width: 20px; height: 20px"></i>
                <span>Dashboard Maestro</span>
            </a>
            <a href="AdminFinanzas" class="nav-item">
                <i data-lucide="dollar-sign" style="width: 20px; height: 20px"></i>
                <span>Control Financiero</span>
            </a>
            <a href="GenerarPagoMaquinaria.jsp" class="nav-item active" style="background-color: #121216;">
                <i data-lucide="wrench" style="width: 20px; height: 20px"></i>
                <span>Liquidación Maquinaria</span>
            </a>
            <a href="LogoutSv" class="nav-item logout-link">
                <i data-lucide="log-out" style="width: 20px; height: 20px"></i>
                <span>Cerrar Sesión</span>
            </a>
        </nav>
    </aside>

    <main class="main-content">

        <header class="topbar">
            <div class="header-left">
                <button id="menu-toggle" class="mobile-menu-btn">
                    <i data-lucide="menu" style="width: 24px; height: 24px"></i>
                </button>
                <div class="welcome">
                    <h1>Liquidación de Maquinaria</h1>
                    <span>Calcula los costos de horas y combustible de equipos pesados.</span>
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

            <div class="generator-wrapper">
                
                <div class="generator-header bg-maquinaria">
                    <div class="header-content">
                        <div style="display: flex; align-items: center; gap: 10px; margin-bottom: 10px;">
                            <i data-lucide="wrench" style="width: 28px; height: 28px"></i>
                            <h2 style="margin: 0;">Órdenes de Pago por Uso</h2>
                        </div>
                        <p>Genera la pre-facturación del alquiler y diésel de maquinaria en los proyectos.</p>
                    </div>
                </div>

                <div class="form-card">
                    <div class="form-header">
                        <h3>Parámetros de Liquidación</h3>
                        <p>Selecciona el rango de fechas. El sistema buscará registros de uso no pagados y calculará su costo.</p>
                    </div>

                    <form action="GenerarPagoMaquinaria" method="POST" class="vyg-form">
                        
                        <div class="form-row">
                            <div class="form-group">
                                <label for="fecha_inicio">Fecha de Inicio:</label>
                                <input type="date" id="fecha_inicio" name="fecha_inicio" required>
                            </div>
                            
                            <div class="form-group">
                                <label for="fecha_fin">Fecha de Corte (Fin):</label>
                                <input type="date" id="fecha_fin" name="fecha_fin" required>
                            </div>
                        </div>

                        <div class="info-box info-orange">
                            <svg class="info-icon" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="10"></circle><line x1="12" y1="16" x2="12" y2="12"></line><line x1="12" y1="8" x2="12.01" y2="8"></line></svg>
                            <div class="info-text">
                                <strong>Matemática Interna</strong>
                                El sistema cruzará la hora de inicio y fin. Multiplicará esas horas por el costo de la máquina y le sumará el diésel. Los registros ya liquidados serán ignorados automáticamente.
                            </div>
                        </div>

                        <div class="form-actions">
                            <a href="AdminFinanzas" class="btn-cancelar">Cancelar</a>
                            <button type="submit" class="btn-generar btn-maquinaria">
                                Generar Órdenes
                            </button>
                        </div>
                    </form>
                </div>

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
