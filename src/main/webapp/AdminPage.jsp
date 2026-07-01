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
    <title>Panel Administrativo | VyGApps</title>
    
    <link rel="stylesheet" href="CSS/AdminPage.css">
    <script src="JS/menu-movil.js" defer></script>
    <link rel="icon" href="images/vyg.svg" type="image/png">
</head>
<body>

<div class="admin-container">
    <div class="overlay" id="sidebarOverlay"></div>

    <aside class="sidebar" id="sidebar">
                <div class="sidebar-header">
            <img src="images/vyg.svg" alt="VyG Logo" class="sidebar-logo">
            <div class="brand-text">
                <h2>VyGApps</h2>
                <span class="panel-badge" style="<%= (usuarioLogeado.getRol().equalsIgnoreCase("Administrador") ? "background:#fceceb; color:#c0392b;" : usuarioLogeado.getRol().equalsIgnoreCase("Supervisor") ? "background:#eafaf1; color:#27ae60;" : "background:#e8f0fe; color:#1a73e8;") %>"><%= usuarioLogeado.getRol() %></span>
            </div>
        </div>
        
        <nav class="sidebar-nav">
            <a href="AdminPage.jsp" class="nav-item active">
                <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect x="3" y="3" width="7" height="9"></rect><rect x="14" y="3" width="7" height="5"></rect><rect x="14" y="12" width="7" height="9"></rect><rect x="3" y="16" width="7" height="5"></rect></svg>
                <span>Dashboard Maestro</span>
            </a>
            <a href="VerUsuarios" class="nav-item">
                <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"></path><circle cx="9" cy="7" r="4"></circle><path d="M23 21v-2a4 4 0 0 0-3-3.87"></path><path d="M16 3.13a4 4 0 0 1 0 7.75"></path></svg>
                <span>Gestión de Usuarios</span>
            </a>
            <a href="ReporteTrabajadoresSv" class="nav-item">
                <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"></path></svg>
                <span>Gestión Laboral</span>
            </a>
            <a href="AdminFinanzas" class="nav-item">
                <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><line x1="12" y1="1" x2="12" y2="23"></line><path d="M17 5H9.5a3.5 3.5 0 0 0 0 7h5a3.5 3.5 0 0 1 0 7H6"></path></svg>
                <span>Control Financiero</span>
            </a>
            <a href="Configuracion.jsp" class="nav-item">
                <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="3"></circle><path d="M19.4 15a1.65 1.65 0 0 0 .33 1.82l.06.06a2 2 0 0 1 0 2.83 2 2 0 0 1-2.83 0l-.06-.06a1.65 1.65 0 0 0-1.82-.33 1.65 1.65 0 0 0-1 1.51V21a2 2 0 0 1-2 2 2 2 0 0 1-2-2v-.09A1.65 1.65 0 0 0 9 19.4a1.65 1.65 0 0 0-1.82.33l-.06.06a2 2 0 0 1-2.83 0 2 2 0 0 1 0-2.83l.06-.06a1.65 1.65 0 0 0 .33-1.82 1.65 1.65 0 0 0-1.51-1H3a2 2 0 0 1-2-2 2 2 0 0 1 2-2h.09A1.65 1.65 0 0 0 4.6 9a1.65 1.65 0 0 0-.33-1.82l-.06-.06a2 2 0 0 1 0-2.83 2 2 0 0 1 2.83 0l.06.06a1.65 1.65 0 0 0 1.82.33H9a1.65 1.65 0 0 0 1-1.51V3a2 2 0 0 1 2-2 2 2 0 0 1 2 2v.09a1.65 1.65 0 0 0 1 1.51 1.65 1.65 0 0 0 1.82-.33l.06-.06a2 2 0 0 1 2.83 0 2 2 0 0 1 0 2.83l-.06.06a1.65 1.65 0 0 0-.33 1.82V9a1.65 1.65 0 0 0 1.51 1H21a2 2 0 0 1 2 2 2 2 0 0 1-2 2h-.09a1.65 1.65 0 0 0-1.51 1z"></path></svg>
                <span>Configuración</span>
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
            </div>
            
            <div class="profile-menu">
                <div class="profile-info">
                    <span class="profile-name"><%= usuarioLogeado.getUser_name() %></span>
                    <span class="profile-role">Administrador</span>
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
                            <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"></path><circle cx="9" cy="7" r="4"></circle><path d="M23 21v-2a4 4 0 0 0-3-3.87"></path><path d="M16 3.13a4 4 0 0 1 0 7.75"></path></svg>
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
                            <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M3 9l9-7 9 7v11a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z"></path><polyline points="9 22 9 12 15 12 15 22"></polyline></svg>
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
                            <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><line x1="12" y1="1" x2="12" y2="23"></line><path d="M17 5H9.5a3.5 3.5 0 0 0 0 7h5a3.5 3.5 0 0 1 0 7H6"></path></svg>
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

</body>
</html>