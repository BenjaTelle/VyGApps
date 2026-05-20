<%-- 
    Document   : FichaTecnicaProyecto
    Created on : 30 mar 2026
    Author     : Benja
--%>
<%@page import="DTO.FichaTecnicaDTO"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="model.Usuarios"%>

<%
    // Validación de seguridad
    HttpSession sessionActual = request.getSession(false);
    Usuarios user = (sessionActual != null) ? (Usuarios) sessionActual.getAttribute("usuarioLogeado") : null;
    
    if (user == null || (!user.getRol().equalsIgnoreCase("Supervisor") && !user.getRol().equalsIgnoreCase("Administrador"))) {
        response.sendRedirect("login.jsp");
        return;
    }

    FichaTecnicaDTO f = (FichaTecnicaDTO) request.getAttribute("ficha") ;

    if(f == null){
        response.sendRedirect("SupervisorPage");
        return;
    }
%>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Ficha Técnica | <%= f.getNombre_proyecto() %></title>
    
    <link rel="stylesheet" href="CSS/SupervisorPage.css">
    <link rel="stylesheet" href="CSS/FichaTecnicaProyecto.css">
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
                <span class="panel-badge"><%= user.getRol() %></span>
            </div>
        </div>

        <nav class="sidebar-nav">
            <a href="SupervisorPage" class="nav-item">
                <span class="icon">📊</span>
                <span>Dashboard</span>
            </a>
            <a href="ListarProyectos" class="nav-item active">
                <span class="icon">🏗️</span>
                <span>Proyectos Activos</span>
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
                <div class="welcome">
                    <h1>Ficha Técnica</h1>
                    <span>Detalle operativo de la obra seleccionada.</span>
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
            
            <div class="page-wrapper">
                <div class="document-card" id="fichaImprimible">
                    
                    <div class="doc-header">
                        <div class="header-logo">
                            <img src="images/vyg.svg" alt="VyG Logo">
                        </div>
                        <div class="header-titles">
                            <h2>FICHA TÉCNICA DE OBRA</h2>
                            <h1><%= f.getNombre_proyecto() %></h1>
                            <span class="doc-id">Código de Proyecto: PRY-<%= String.format("%03d", f.getIdP()) %></span>
                        </div>
                    </div>

                    <hr class="divider">

                    <div class="doc-body">
                        <div class="data-grid">
                            
                            <div class="data-box">
                                <span class="data-label">🚧 Estado Operativo</span>
                                <div class="data-value">
                                    <span class="status-badge <%= f.getEstado().equalsIgnoreCase("activo") ? "status-active" : "status-inactive" %>">
                                        <%= f.getEstado().toUpperCase() %>
                                    </span>
                                </div>
                            </div>

                            <div class="data-box">
                                <span class="data-label">👷 Supervisor a Cargo</span>
                                <div class="data-value highlight-text">
                                    <%= (f.getNombre_supervisor() != null && !f.getNombre_supervisor().trim().isEmpty() && !f.getNombre_supervisor().equalsIgnoreCase("null")) 
                                        ? f.getNombre_supervisor() 
                                        : "<span style='color:#e74c3c; font-weight:normal; font-size:14px;'>⚠️ Sin asignar</span>" %>
                                </div>
                            </div>

                            <div class="data-box">
                                <span class="data-label">⚒️ Fuerza Laboral Activa</span>
                                <div class="data-value number-value text-blue">
                                    <%= f.getTotal_trabajadores() %> <span class="unit">Trabajadores</span>
                                </div>
                            </div>

                            <div class="data-box">
                                <span class="data-label">💰 Presupuesto Asignado</span>
                                <div class="data-value number-value text-green">
                                    C$ <%= String.format("%,.2f", f.getPresupuesto()) %>
                                </div>
                            </div>

                        </div>
                    </div>

                    <hr class="divider">

                    <div class="doc-footer">
                        <p>Documento generado por el Sistema VyGApps.</p>
                        <p>Fecha de emisión: <%= new java.text.SimpleDateFormat("dd/MM/yyyy HH:mm").format(new java.util.Date()) %></p>
                    </div>
                </div>

                <div class="action-buttons">
                    <a href="javascript:history.back()" class="btn btn-back">⬅️ Volver Atrás</a>
                    <button onclick="window.print()" class="btn btn-print">🖨️ Imprimir Ficha</button>
                </div>

            </div>

        </section>

    </main>
</div>

</body>
</html>