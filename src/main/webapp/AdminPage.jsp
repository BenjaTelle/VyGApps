<%-- 
    Document   : AdminPage
    Created on : 2 feb 2026, 9:08:44 p.m.
    Author     : Benja
--%>
<%@page import="model.Usuarios"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    /* Recuperación de sesión y validación de permisos de Administrador */
    HttpSession sessionActual = request.getSession(false);
    Usuarios usuarioLogeado = (sessionActual != null) ? (Usuarios) sessionActual.getAttribute("usuarioLogeado") : null;

    if (usuarioLogeado == null) {
        response.sendRedirect("login.jsp");
        return; 
    } 
    
    if (!usuarioLogeado.getRol().equalsIgnoreCase("Administrador")) {
        response.sendRedirect("AccDen.jsp");
        return; 
    }
%>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Panel Administrativo | V&G Ingenieros</title>
    
    <link rel="stylesheet" href="CSS/AdminPage.css">
    <script src="JS/menu-movil.js" defer></script>
    <link rel="icon" href="images/vygLogo.svg" type="image/svg+xml">

    <!-- Lucide Icons CDN -->
    <script src="JS/lucide.min.js"></script>
</head>
<body>

<div class="admin-container">
    <div class="overlay" id="sidebarOverlay"></div>

    <aside class="sidebar" id="sidebar">
        <div class="sidebar-header">
            <img src="images/vygLogo.svg" alt="V&G Ingenieros Logo" class="sidebar-logo">
            <div class="brand-text">
                <h2>V&G Ingenieros</h2>
                <span class="panel-badge"><%= usuarioLogeado.getRol() %></span>
            </div>
        </div>
        
        <nav class="sidebar-nav">
            <a href="AdminPage.jsp" class="nav-item active">
                <i data-lucide="layout-dashboard" style="width: 20px; height: 20px"></i>
                <span>Dashboard Maestro</span>
            </a>
            <a href="VerUsuarios" class="nav-item">
                <i data-lucide="users" style="width: 20px; height: 20px"></i>
                <span>Gestión de Usuarios</span>
            </a>
            <a href="ReporteTrabajadoresSv" class="nav-item">
                <i data-lucide="shield" style="width: 20px; height: 20px"></i>
                <span>Gestión Laboral</span>
            </a>
            <a href="AdminFinanzas" class="nav-item">
                <i data-lucide="dollar-sign" style="width: 20px; height: 20px"></i>
                <span>Control Financiero</span>
            </a>
            <a href="Configuracion.jsp" class="nav-item">
                <i data-lucide="settings" style="width: 20px; height: 20px"></i>
                <span>Configuración</span>
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
            </div>
            
            <div class="profile-menu">
                <div class="profile-info">
                    <span class="profile-name"><%= usuarioLogeado.getUser_name() %></span>
                    <span class="profile-role"><%= usuarioLogeado.getRol() %></span>
                </div>
                <img src="images/usuario.png" class="profile-img" alt="Perfil">
            </div>
        </header>

        <section class="dashboard">
            <div class="admin-header-banner">
                <div class="admin-header-info">
                    <h2>Bienvenido al Panel de Control</h2>
                    <p>Módulo de gestión integral: Accesos, proyectos, personal y control financiero.</p>
                </div>
            </div>

            <div class="dashboard-grid">

                <div class="dashboard-card">
                    <div class="card-header">
                        <div class="card-icon icon-blue">
                            <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M16 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"></path><circle cx="8.5" cy="7" r="4"></circle><polyline points="17 11 19 13 23 9"></polyline></svg>
                        </div>
                        <div class="card-title">
                            <h3>Gestión de Usuarios</h3>
                            <p>Accesos y perfiles del sistema</p>
                        </div>
                    </div>
                    <div class="actions-grid">
                        <a href="CrearUsuario" class="btn-action outline">Crear</a>
                        <a href="ActualizarUsuario" class="btn-action outline">Actualizar</a>
                        <a href="VerUsuarios" class="btn-action primary">Consultar</a>
                        <a href="EliminarUsu" class="btn-action danger">Eliminar</a>
                    </div>
                </div>

                <div class="dashboard-card">
                    <div class="card-header">
                        <div class="card-icon icon-green">
                            <i data-lucide="users" style="width: 24px; height: 24px"></i>
                        </div>
                        <div class="card-title">
                            <h3>Fuerza Laboral</h3>
                            <p>Personal operativo y supervisores</p>
                        </div>
                    </div>
                    <div class="actions-grid">
                        <a href="RegistrarUsu" class="btn-action outline">Registrar</a>
                        <a href="ActualizarTrabajadores" class="btn-action outline">Modificar</a>
                        <a href="EliminarTrabajadores" class="btn-action danger">Baja</a>
                        <a href="HistorialT.jsp" class="btn-action outline">Historial</a>
                    </div>
                </div>

                <div class="dashboard-card">
                    <div class="card-header">
                        <div class="card-icon icon-orange">
                            <i data-lucide="home" style="width: 24px; height: 24px"></i>
                        </div>
                        <div class="card-title">
                            <h3>Gestión de Obras</h3>
                            <p>Control de proyectos y asignaciones</p>
                        </div>
                    </div>
                    <div class="actions-grid">
                        <a href="CrearProyecto" class="btn-action outline">Nueva Obra</a>
                        <a href="ListarProyectos" class="btn-action primary">Listado</a>
                        <a href="AsignSup" class="btn-action outline">Asignar Sup.</a>
                        <a href="AsignProyecto" class="btn-action outline">Asignar Cuadrilla</a>
                    </div>
                </div>

                <div class="dashboard-card highlight-card">
                    <div class="card-header">
                        <div class="card-icon icon-purple">
                            <i data-lucide="dollar-sign" style="width: 24px; height: 24px"></i>
                        </div>
                        <div class="card-title">
                            <h3>Reportes & Finanzas</h3>
                            <p>Auditoría contable y consolidación</p>
                        </div>
                    </div>
                    <div class="actions-grid">
                        <a href="ReporteProyecto" class="btn-action outline">Reporte Obras</a>
                        <a href="ReporteTrabajadoresSv" class="btn-action outline">Dir. Personal</a>
                        <a href="AdminFinanzas" class="btn-action outline">Aprobar Pagos</a>
                        <a href="ResumenDiarioSv" class="btn-action primary">Resumen Diario</a>
                    </div>
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