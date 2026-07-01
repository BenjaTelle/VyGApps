<%-- 
    Document   : CrearProyecto
    Created on : 17 feb 2026
    Author     : Benja
--%>
<%@page import="java.util.List"%>
<%@page import="model.trabajadores"%>
<%@page import="model.Usuarios"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    // Validación estricta de seguridad
    HttpSession sessionActual = request.getSession(false);
    Usuarios usuarioLogeado = (sessionActual != null) ? (Usuarios) sessionActual.getAttribute("usuarioLogeado") : null;

    if (usuarioLogeado == null) {
        response.sendRedirect("login.jsp");
        return;
    } else if (!usuarioLogeado.getRol().equals("Administrador")) {
        response.sendRedirect("AccDen.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Crear Proyecto | VyGApps</title>
    <link rel="stylesheet" href="CSS/SupervisorPage.css">
    <link rel="stylesheet" href="CSS/CrearProyecto.css">
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
                <span class="panel-badge" style="<%= (usuarioLogeado.getRol().equalsIgnoreCase("Administrador") ? "background:#fceceb; color:#c0392b;" : usuarioLogeado.getRol().equalsIgnoreCase("Supervisor") ? "background:#eafaf1; color:#27ae60;" : "background:#e8f0fe; color:#1a73e8;") %>"><%= usuarioLogeado.getRol() %></span>
            </div>
        </div>
        <nav class="sidebar-nav">
            <a href="AdminPage.jsp" class="nav-item">
                <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect x="3" y="3" width="7" height="9"></rect><rect x="14" y="3" width="7" height="5"></rect><rect x="14" y="12" width="7" height="9"></rect><rect x="3" y="16" width="7" height="5"></rect></svg>
                <span>Dashboard Maestro</span>
            </a>
            <a href="ListarProyectosSv" class="nav-item active" style="background-color: #2c3e50;">
                <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M22 19a2 2 0 0 1-2 2H4a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h5l2 3h9a2 2 0 0 1 2 2z"></path></svg>
                <span>Gestión de Proyectos</span>
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
                    <h1>Módulo de Proyectos</h1>
                    <span>Apertura de obras y configuración de reglas.</span>
                </div>
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
            <div class="form-container">
                <div class="form-card">
                    
                    <div class="form-header">
                        <h2>Crear Nuevo Proyecto</h2>
                        <p class="subtitle">Complete la información financiera y operativa de la obra</p>
                    </div>

                    <form action="CrearProyecto" method="post">
                        
                        <div class="section-title">
                            <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"></path><polyline points="14 2 14 8 20 8"></polyline><line x1="16" y1="13" x2="8" y2="13"></line><line x1="16" y1="17" x2="8" y2="17"></line><polyline points="10 9 9 9 8 9"></polyline></svg>
                            Información General
                        </div>

                        <div class="form-group">
                            <label for="nombre">Nombre del Proyecto</label>
                            <input type="text" id="nombre" name="nombre_proyecto" placeholder="Ej. Residencial Las Colinas" required>
                        </div>

                        <div class="form-row">
                            <div class="form-group">
                                <label for="presupuesto">Presupuesto Inicial (C$)</label>
                                <input type="number" step="0.01" id="presupuesto" name="presupuesto_total" placeholder="Ej. 150000.50" required>
                            </div>
                            <div class="form-group">
                                <label for="supervisor">Supervisor Principal</label>
                                <select name="id_supervisor" id="supervisor" required>
                                    <option value="">-- Seleccione un supervisor --</option>
                                    <%
                                        List<trabajadores> lista = (List<trabajadores>) request.getAttribute("ListaSupervisores");
                                        if (lista != null) {
                                            for (trabajadores t : lista) {
                                    %>
                                    <option value="<%= t.getId_trabajador()%>"><%= t.getFull_name()%></option>
                                    <%
                                            }
                                        }
                                    %>
                                </select>
                            </div>
                        </div>

                        <div class="section-title" style="margin-top: 20px;">
                            <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="10"></circle><polyline points="12 6 12 12 16 14"></polyline></svg>
                            Reglas de Asistencia y Planilla
                        </div>

                        <div class="form-row">
                            <div class="form-group">
                                <label for="hora_entrada">Hora de Entrada Oficial</label>
                                <input type="time" id="hora_entrada" name="hora_entrada_oficial" value="08:00" required>
                            </div>
                            <div class="form-group">
                                <label for="hora_salida">Hora de Salida Oficial</label>
                                <input type="time" id="hora_salida" name="hora_salida_oficial" value="17:00" required>
                            </div>
                        </div>

                        <div class="form-group" style="margin-bottom: 30px;">
                            <label for="tarifa_extra">Tarifa de Hora Extra (C$ / hr)</label>
                            <input type="number" step="0.01" id="tarifa_extra" name="tarifa_hora_extra" placeholder="Ej. 100.00" value="0.00" required>
                            <small class="help-text">Monto a pagar por cada hora cumplida después del horario oficial.</small>
                        </div>

                        <div class="form-actions">
                            <a href="AdminPage.jsp" class="btn-cancelar">Cancelar</a>
                            <button type="submit" class="btn-submit">
                                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M19 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h11l5 5v11a2 2 0 0 1-2 2z"></path><polyline points="17 21 17 13 7 13 7 21"></polyline><polyline points="7 3 7 8 15 8"></polyline></svg>
                                Registrar Proyecto
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