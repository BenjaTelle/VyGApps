<%-- 
    Document   : ListarProyectos
    Created on : 18 feb 2026
    Author     : Benja
--%>
<%@page import="DTO.ListarProyectosDTO"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="model.Usuarios"%>

<%
    // Lógica de seguridad
    HttpSession sessionActual = request.getSession(false);
    Usuarios user = (sessionActual != null) ? (Usuarios) sessionActual.getAttribute("usuarioLogeado") : null;
    
    if (user == null || (!user.getRol().equalsIgnoreCase("Supervisor") && !user.getRol().equalsIgnoreCase("Administrador"))) {
        response.sendRedirect("login.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Lista de Proyectos | VyGApps</title>
    
    <link rel="stylesheet" href="CSS/SupervisorPage.css">
    <link rel="stylesheet" href="CSS/ListarProyectos.css">
    <script src="JS/menu-movil.js" defer></script>
    <script src="JS/BuscadorListaProyectos.js" defer></script>
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
                <span class="panel-badge">Supervisor</span>
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
            <a href="RegistrarGastoSv" class="nav-item">
                <span class="icon">💸</span>
                <span>Control de Gastos</span>
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
                    <h1>Proyectos Activos</h1>
                    <span>Listado general y estado financiero de obras.</span>
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

        <section class="projects-dashboard">
            
            <div class="header-tools">
                <div class="search-box">
                    <span class="search-icon">🔍</span>
                    <input type="text" id="buscador" placeholder="Buscar proyecto por nombre..." class="search-input">
                </div>
            </div>

            <div class="cards-container">

                <%
                    List<ListarProyectosDTO> lista = (List<ListarProyectosDTO>) request.getAttribute("ListaP");

                    if (lista != null && !lista.isEmpty()) {
                        for (ListarProyectosDTO p : lista) {
                        String mensaje;
                        String nombreSup = p.getNombre_supervisor();
                        
                        if(nombreSup != null && !nombreSup.trim().isEmpty() && !nombreSup.equalsIgnoreCase("null")) {
                            mensaje = nombreSup;
                        } else {
                            mensaje = "<span class='no-supervisor'>⚠️ Sin asignar</span>";
                        }
                %>

                <div class="project-card">
                    <div class="card-header">
                        <h3 class="project-title"><%= p.getNombre_proyecto() %></h3>
                        <span class="status-badge status-active">En Proceso</span>
                    </div>
                    
                    <div class="card-body">
                        <div class="info-group">
                            <span class="info-label">👷 Supervisor Designado</span>
                            <span class="info-value text-dark"><%= mensaje%></span>
                        </div>
                        
                        <div class="info-group financial-group">
                            <span class="info-label">💰 Presupuesto Total</span>
                            <span class="info-value money">C$ <%= String.format("%,.2f", p.getPresupuesto_total()) %></span>
                        </div>
                    </div>

                    <div class="card-footer">
                        <a href="ListarProyectos?id_proyecto=<%= p.getId()%>" class="btn-detail">Ficha Técnica</a>
                        <a href="RegistrarGastoSv?id_proyecto=<%= p.getId()%>" class="btn-expense">➕ Agregar Gasto</a>
                    </div>
                </div>

                <%
                        }
                    } else {
                %>
                    <div class="empty-message">
                        <span style="font-size: 40px; display: block; margin-bottom: 10px;">🏗️</span>
                        <p>No hay proyectos registrados en el sistema actualmente.</p>
                    </div>
                <%
                    }
                %>

            </div>
        </section>

    </main>
</div>

</body>
</html>