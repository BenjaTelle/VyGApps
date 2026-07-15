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
                <span class="panel-badge"><%= user.getRol() %></span>
            </div>
        </div>

        <nav class="sidebar-nav">
            <a href="SupervisorPage" class="nav-item">
                <span class="icon"><i data-lucide="bar-chart-3" style="width: 20px; height: 20px"></i></span>
                <span>Dashboard</span>
            </a>
            <a href="ListarProyectos" class="nav-item active">
                <span class="icon"><i data-lucide="briefcase" style="width: 20px; height: 20px"></i></span>
                <span>Proyectos Activos</span>
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
                            <img src="images/KronosIndustrial.svg" alt="Kronos Industrial Logo">
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
                                <span class="data-label"><i data-lucide="briefcase" style="width: 20px; height: 20px"></i> Estado Operativo</span>
                                <div class="data-value">
                                    <span class="status-badge <%= f.getEstado().equalsIgnoreCase("activo") ? "status-active" : "status-inactive" %>">
                                        <%= f.getEstado().toUpperCase() %>
                                    </span>
                                </div>
                            </div>

                            <div class="data-box">
                                <span class="data-label"><i data-lucide="users" style="width: 20px; height: 20px"></i> Supervisor a Cargo</span>
                                <div class="data-value highlight-text">
                                    <% if (f.getNombre_supervisor() != null && !f.getNombre_supervisor().trim().isEmpty() && !f.getNombre_supervisor().equalsIgnoreCase("null")) { %>
                                        <%= f.getNombre_supervisor() %>
                                    <% } else { %>
                                        <span class="no-supervisor">
                                            <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                                <path d="M10.29 3.86L1.82 18a2 2 0 0 0 1.71 3h16.94a2 2 0 0 0 1.71-3L13.71 3.86a2 2 0 0 0-3.42 0z"></path>
                                                <line x1="12" y1="9" x2="12" y2="13"></line>
                                                <line x1="12" y1="17" x2="12.01" y2="17"></line>
                                            </svg>
                                            Sin asignar
                                        </span>
                                    <% } %>
                                </div>
                            </div>

                            <div class="data-box">
                                <span class="data-label"><i data-lucide="briefcase" style="width: 20px; height: 20px"></i> Fuerza Laboral Activa</span>
                                <div class="data-value number-value text-blue">
                                    <%= f.getTotal_trabajadores() %> <span class="unit">Trabajadores</span>
                                </div>
                            </div>

                            <div class="data-box">
                                <span class="data-label"><i data-lucide="dollar-sign" style="width: 20px; height: 20px"></i> Presupuesto Asignado</span>
                                <div class="data-value number-value text-green">
                                    C$ <%= String.format("%,.2f", f.getPresupuesto()) %>
                                </div>
                            </div>

                        </div>
                    </div>

                    <hr class="divider">

                    <div class="doc-footer">
                        <p>Documento generado por el Sistema Kronos Industrial.</p>
                        <p>Fecha de emisión: <%= new java.text.SimpleDateFormat("dd/MM/yyyy HH:mm").format(new java.util.Date()) %></p>
                    </div>
                </div>

                <div class="action-buttons">
                    <a href="javascript:history.back()" class="btn btn-back"><i data-lucide="arrow-left" style="width: 20px; height: 20px"></i> Volver Atrás</a>
                    <button onclick="window.print()" class="btn btn-print"><i data-lucide="printer" style="width: 20px; height: 20px"></i> Imprimir Ficha</button>
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