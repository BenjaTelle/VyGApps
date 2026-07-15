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
    <title>Liquidar Maquinaria | Kronos Industrial</title>
    
    <link rel="stylesheet" href="CSS/SupervisorPage.css">
    <link rel="stylesheet" href="CSS/FormulariosGeneracion.css">
    <script src="JS/menu-movil.js" defer></script>
    <link rel="icon" href="images/KronosIndustrial.svg" type="image/svg+xml">
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
                <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect x="3" y="3" width="7" height="9"></rect><rect x="14" y="3" width="7" height="5"></rect><rect x="14" y="12" width="7" height="9"></rect><rect x="3" y="16" width="7" height="5"></rect></svg>
                <span>Dashboard Maestro</span>
            </a>
            <a href="AdminFinanzas" class="nav-item">
                <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><line x1="12" y1="1" x2="12" y2="23"></line><path d="M17 5H9.5a3.5 3.5 0 0 0 0 7h5a3.5 3.5 0 0 1 0 7H6"></path></svg>
                <span>Control Financiero</span>
            </a>
            <a href="GenerarPagoMaquinaria.jsp" class="nav-item active" style="background-color: #121216;">
                <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M14.7 6.3a1 1 0 0 0 0 1.4l1.6 1.6a1 1 0 0 0 1.4 0l3.77-3.77a6 6 0 0 1-7.94 7.94l-6.91 6.91a2.12 2.12 0 0 1-3-3l6.91-6.91a6 6 0 0 1 7.94-7.94l-3.76 3.76z"></path></svg>
                <span>Liquidación Maquinaria</span>
            </a>
            <a href="LogoutSv" class="nav-item logout-link">
                <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4"></path><polyline points="16 17 21 12 16 7"></polyline><line x1="21" y1="12" x2="9" y2="12"></line></svg>
                <span>Cerrar Sesión</span>
            </a>
        </nav>
    </aside>

    <main class="main-content">

        <header class="topbar">
            <div class="header-left">
                <button id="menu-toggle" class="mobile-menu-btn">
                    <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><line x1="3" y1="12" x2="21" y2="12"></line><line x1="3" y1="6" x2="21" y2="6"></line><line x1="3" y1="18" x2="21" y2="18"></line></svg>
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
                            <svg width="28" height="28" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M14.7 6.3a1 1 0 0 0 0 1.4l1.6 1.6a1 1 0 0 0 1.4 0l3.77-3.77a6 6 0 0 1-7.94 7.94l-6.91 6.91a2.12 2.12 0 0 1-3-3l6.91-6.91a6 6 0 0 1 7.94-7.94l-3.76 3.76z"></path></svg>
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

</body>
</html>
